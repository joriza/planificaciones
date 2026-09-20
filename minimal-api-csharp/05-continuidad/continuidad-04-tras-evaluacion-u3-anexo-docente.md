# Continuidad pedagógica 4 — Anexo docente: soluciones y criterios de corrección

> Uso exclusivo docente. Compañero del documento del alumno `continuidad-04-tras-evaluacion-u3.md`. Contiene la solución de referencia completa, las respuestas esperadas de cada actividad y los criterios de corrección. Los textos exactos de los mensajes 404 no se exigen literales: se exige que el cuerpo exista, con un mensaje en español. Los valores concretos dependen de la copia de `hospital.db`; la referencia del curso tiene 306 ingresos, 258 pacientes, 27 médicos y 13 provincias, con ingresos entre junio de 2018 y junio de 2019.

## 1. Panorama de la corrección

| Actividad | Puntos | Tiempo | Qué se verifica principalmente |
| --- | --- | --- | --- |
| 1. Puesta a punto y repaso U2 | 10 | 30 min | Proyecto corriendo; patrón de lectura por id con 404 con mensaje |
| 2. JOIN triple y endpoints compuestos | 20 | 45 min | JOIN triple con alias calificados; existencia verificada antes del JOIN filtrado |
| 3. Agregaciones con GROUP BY | 20 | 50 min | COUNT/AVG/SUM sobre grupos; orden y corte sobre el agregado |
| 4. Subconsulta simple | 15 | 35 min | Subconsulta escalar correlacionada como columna y como filtro |
| 5. Datos sucios de la base real | 20 | 45 min | `IS NULL` y `COALESCE`; auditoría de altas imposibles |
| 6. Configuración y publicación | 15 | 35 min | `appsettings.json`, `dotnet publish` y prueba de la API publicada |
| **Total** | **100** | **240 min** | |

## 2. Solución de referencia: appsettings.json y Program.cs completo

`appsettings.json` (la sección `ConnectionStrings` al principio; las comas separan las secciones):

```json
{
  "ConnectionStrings": {
    "Hospital": "Data Source=hospital.db"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

`Program.cs` completo, con las seis actividades integradas en un solo archivo:

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API

// Configuracion (Act. 6): la cadena vive en appsettings.json, seccion
// ConnectionStrings, clave Hospital. Si la clave falta, el ?? entrega
// la cadena canonica y la API arranca igual
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();                          // Construye la aplicacion

// GET /patients/{id}: UN paciente por id (Act. 1, repaso de la Unidad 2)
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.QueryFirstOrDefault<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE patient_id = @id",
        new { id });

    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente con ese id" });
    }

    return Results.Ok(patient);
});

// GET /admissions/full: JOIN triple admissions + patients + doctors (Act. 2)
app.MapGet("/admissions/full", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Cada columna calificada con su alias de tabla; los nombres se
    // concatenan en el SELECT con || y llevan su alias AS
    var admissions = connection.Query<AdmissionDetail>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.discharge_date AS DischargeDate,
                 a.diagnosis      AS Diagnosis,
                 p.first_name || ' ' || p.last_name AS PatientName,
                 d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty      AS DoctorSpecialty
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          ORDER BY a.admission_date DESC");

    return Results.Ok(admissions);
});

// GET /doctors/{id}/admissions: el mismo JOIN triple, filtrado por medico (Act. 2)
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero la existencia: 0 filas significa medico inexistente -> 404.
    // El orden importa: no se consulta el JOIN de alguien que no existe
    var exists = connection.ExecuteScalar<long>(
        @"SELECT doctor_id
          FROM doctors
          WHERE doctor_id = @id",
        new { id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

    var admissions = connection.Query<AdmissionDetail>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.discharge_date AS DischargeDate,
                 a.diagnosis      AS Diagnosis,
                 p.first_name || ' ' || p.last_name AS PatientName,
                 d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty      AS DoctorSpecialty
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.attending_doctor_id = @id
          ORDER BY a.admission_date DESC",
        new { id });

    return Results.Ok(admissions);
});

// GET /stats/admissions-by-specialty: ingresos por especialidad (Act. 3)
app.MapGet("/stats/admissions-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Un grupo por especialidad; COUNT cuenta las filas de cada grupo.
    // El orden por el agregado pone la especialidad con mas ingresos primero
    var stats = connection.Query<AdmissionBySpecialty>(
        @"SELECT d.specialty AS Specialty,
                 COUNT(*)    AS TotalAdmissions
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          GROUP BY d.specialty
          ORDER BY TotalAdmissions DESC");

    return Results.Ok(stats);
});

// GET /stats/top-doctors/{top}: los medicos con mas ingresos (Act. 3)
app.MapGet("/stats/top-doctors/{top:int}", (int top) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Se agrupa por d.doctor_id (la clave, que no se repite) aunque el
    // SELECT muestre el nombre. El LIMIT se parametriza como cualquier valor
    var doctors = connection.Query<DoctorAdmissions>(
        @"SELECT d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty AS Specialty,
                 COUNT(*)    AS TotalAdmissions
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          GROUP BY d.doctor_id
          ORDER BY TotalAdmissions DESC
          LIMIT @top",
        new { top });

    return Results.Ok(doctors);
});

// GET /stats/stay: conteo, promedio y suma de dias de internacion (Act. 3)
app.MapGet("/stats/stay", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Los ingresos sin alta no tienen duracion: se excluyen con IS NOT NULL.
    // La consulta agregada sin GROUP BY devuelve una sola fila
    var stay = connection.QueryFirstOrDefault<StayStats>(
        @"SELECT COUNT(*) AS DischargedAdmissions,
                 ROUND(AVG(julianday(discharge_date) - julianday(admission_date)), 1) AS AvgDays,
                 CAST(SUM(julianday(discharge_date) - julianday(admission_date)) AS INTEGER) AS TotalDays
          FROM admissions
          WHERE discharge_date IS NOT NULL");

    return Results.Ok(stay);
});

// GET /patients/multiple-admissions/{min}: pacientes con MAS de min ingresos (Act. 4)
app.MapGet("/patients/multiple-admissions/{min:int}", (int min) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Subconsulta escalar correlacionada: por cada paciente de la consulta
    // externa (p), la interna cuenta SUS ingresos. El conteo viaja como
    // columna y como filtro
    var patients = connection.Query<PatientAdmissionCount>(
        @"SELECT p.patient_id AS PatientId,
                 p.first_name AS FirstName,
                 p.last_name  AS LastName,
                 (SELECT COUNT(*)
                  FROM admissions a
                  WHERE a.patient_id = p.patient_id) AS AdmissionCount
          FROM patients p
          WHERE (SELECT COUNT(*)
                 FROM admissions a
                 WHERE a.patient_id = p.patient_id) > @min
          ORDER BY AdmissionCount DESC",
        new { min });

    return Results.Ok(patients);
});

// GET /admissions/open: ingresos sin fecha de alta (Act. 5)
app.MapGet("/admissions/open", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // NULL no se expone crudo: COALESCE traduce el diagnostico faltante
    // en un texto explicito; el nombre viaja concatenado con ||
    var admissions = connection.Query<OpenAdmission>(
        @"SELECT a.patient_id AS PatientId,
                 p.first_name || ' ' || p.last_name AS PatientName,
                 a.admission_date AS AdmissionDate,
                 COALESCE(a.diagnosis, 'Sin diagnostico') AS Diagnosis
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          WHERE a.discharge_date IS NULL
          ORDER BY a.admission_date");

    return Results.Ok(admissions);
});

// GET /admissions/strange-discharges: altas imposibles (Act. 5)
app.MapGet("/admissions/strange-discharges", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Alta imposible: anterior al propio ingreso o con fecha de 1971.
    // Es la auditoria que nombra el dato sucio antes de exponerlo
    var admissions = connection.Query<StrangeDischarge>(
        @"SELECT a.patient_id     AS PatientId,
                 a.admission_date AS AdmissionDate,
                 a.discharge_date AS DischargeDate,
                 a.diagnosis      AS Diagnosis
          FROM admissions a
          WHERE a.discharge_date IS NOT NULL
            AND (a.discharge_date < a.admission_date
                 OR a.discharge_date LIKE '1971-%')
          ORDER BY a.discharge_date");

    return Results.Ok(admissions);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Paciente: una fila de la tabla patients (repaso de la Unidad 2)
record Patient(
    long PatientId,      // id: SIEMPRE long (con int el mapeo falla con 500)
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd" (nunca DateTime)
    string? City,        // nullable: la columna acepta NULL
    string ProvinceId,
    string? Allergies,
    int? Height,
    int? Weight
);

// Detalle de ingreso: columnas de las tres tablas del JOIN triple
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,   // nullable: sin alta = aun internado
    string? Diagnosis,
    string PatientName,      // armado con || en el SELECT
    string DoctorName,
    string DoctorSpecialty
);

// Resumen por especialidad: el grupo y su total
record AdmissionBySpecialty(string Specialty, int TotalAdmissions);

// Resumen por medico: el grupo es el id, el nombre se muestra
record DoctorAdmissions(string DoctorName, string Specialty, int TotalAdmissions);

// Estadistica de internacion: conteo, promedio y suma de dias
record StayStats(int DischargedAdmissions, double AvgDays, int TotalDays);

// Paciente con su conteo de ingresos: la subconsulta agrega la columna
record PatientAdmissionCount(long PatientId, string FirstName, string LastName, int AdmissionCount);

// Ingreso aun abierto: el diagnostico faltante sale como texto explicito
record OpenAdmission(long PatientId, string PatientName, string AdmissionDate, string Diagnosis);

// Alta imposible: la fecha de alta contra la de ingreso, a la vista
record StrangeDischarge(long PatientId, string AdmissionDate, string DischargeDate, string? Diagnosis);
```

## 3. Soluciones y respuestas esperadas por actividad

### Actividad 1 — Puesta a punto y repaso U2 (10 puntos)

Verificaciones: `/patients/1` responde 200 con el paciente 1 (valores según la copia de la base); `/patients/9999` responde 404 con `{"mensaje":"No existe el paciente con ese id"}`. Respuesta escrita esperada: el id es `long` porque SQLite entrega todos los enteros como `long` y con `int` el mapeo de Dapper falla con un 500; la fecha es `string` porque viaja como texto ISO `yyyy-MM-dd` tal como está guardada (`DateTime` no mapea contra el `TEXT` de SQLite).

### Actividad 2 — JOIN triple y endpoints compuestos (20 puntos)

Salida esperada de `/admissions/full` (primera fila; los valores dependen de la copia):

```json
[
  {
    "admissionDate": "2019-06-02",
    "dischargeDate": null,
    "diagnosis": "Stomache Pain",
    "patientName": "Emily Watson",
    "doctorName": "Robert Kim",
    "doctorSpecialty": "Cardiologist"
  }
]
```

Verificaciones: `/doctors/3/admissions` responde 200 con los ingresos del médico 3; `/doctors/9999/admissions` responde 404 con `{"mensaje":"No existe el medico"}`; la existencia se verifica ANTES de correr el JOIN filtrado. Presentación escrita esperada: `admissions.patient_id` apunta a `patients.patient_id` y `admissions.attending_doctor_id` apunta a `doctors.doctor_id` (dos flechas desde `admissions`); sin calificar, `patient_id` es ambigua (existe en las dos tablas) y SQLite corta con `ambiguous column name`.

### Actividad 3 — Agregaciones con GROUP BY (20 puntos)

Verificaciones: `/stats/admissions-by-specialty` responde 200 con 13 filas ordenadas de mayor a menor (en la copia de referencia, `Cardiologist` con 41 y `General Surgeon` con 33 encabezan); `/stats/top-doctors/5` responde con 5 médicos; `/stats/top-doctors/100` responde con los 27 que hay (el `LIMIT` corta, nunca inventa); `/stats/stay` responde con un objeto:

```json
{
  "dischargedAdmissions": 278,
  "avgDays": 7.3,
  "totalDays": 2029
}
```

Observación para la corrección: el promedio de la copia de referencia sale más bajo de lo esperado porque las altas imposibles de 1971 entran en el cálculo (el endpoint solo excluye los ingresos sin alta, tal como pide la consigna). Si un grupo lo detecta y lo explica en su presentación, es un hallazgo valioso: es exactamente el dato sucio de la actividad 5.

**Cuadro 1 resuelto:**

| Pregunta del hospital | Función de agregación | GROUP BY |
| --- | --- | --- |
| ¿Cuántos ingresos hubo por especialidad? | `COUNT(*)` | `d.specialty` |
| ¿Qué médicos atendieron más ingresos? (Top N) | `COUNT(*)` con `ORDER BY TotalAdmissions DESC` y `LIMIT` | `d.doctor_id` |
| ¿Cuánto dura en promedio una internación con alta? | `ROUND(AVG(julianday(discharge_date) - julianday(admission_date)), 1)` (con `COUNT` y `SUM` en el mismo SELECT) | Sin `GROUP BY`: una sola fila de resumen |
| ¿Cuántos pacientes hay por sexo? | `COUNT(*)` | `p.gender` |

### Actividad 4 — Subconsulta simple (15 puntos)

Verificaciones: `/patients/multiple-admissions/2` responde 200 con los pacientes que tuvieron MÁS de 2 ingresos, el de más ingresos primero (en la copia de referencia, el paciente 12 encabeza con 4 ingresos); `/patients/multiple-admissions/0` responde con todos los que tengan al menos uno. Presentación escrita esperada: la subconsulta es correlacionada porque la consulta interna referencia `p.patient_id`, la fila externa que se está recorriendo; por cada paciente calcula su propio conteo, y ese mismo conteo se usa como columna (`AdmissionCount`) y como filtro contra `@min`.

### Actividad 5 — Datos sucios de la base real (20 puntos)

Verificaciones: `/admissions/open` responde 200 con los ingresos sin alta; `diagnosis` nunca llega `null` (o el diagnóstico real, o `"Sin diagnostico"`):

```json
[
  {
    "patientId": 45,
    "patientName": "Marcus Reed",
    "admissionDate": "2019-05-28",
    "diagnosis": "Pneumonia"
  }
]
```

`/admissions/strange-discharges` responde con las altas imposibles; entre ellas, las de fecha `1971-01-05` (la cantidad exacta depende de la copia; anotarla es parte de la auditoría del grupo).

**Cuadro 2 resuelto:**

| Hallazgo en la base | Herramienta SQL | Qué significa para el paciente |
| --- | --- | --- |
| Ingreso sin fecha de alta (`NULL`) | `IS NULL` | El paciente todavía está internado: la ausencia del dato es la información |
| Diagnóstico mal tipeado («Stomache Pain») | `LIKE` en consulta de auditoría | Error de carga: la API lo reporta, no lo corrige ni lo inventa |
| Alta en 1971 o previa al ingreso | Comparación de fechas y `LIKE '1971-%'` | Alta imposible: se separa antes de exponer o de promediar |

Respuestas escritas esperadas: `NULL` significa que el dato todavía no existe (no es cero ni texto vacío): el ingreso está abierto y el paciente sigue internado. Una alta de 1971 no puede ser verdadera porque los ingresos de la base son de junio de 2018 a junio de 2019: una alta anterior al propio ingreso (y de hace casi medio siglo) solo puede ser un error de carga.

### Actividad 6 — Configuración y publicación (15 puntos)

Secuencia esperada (parados en la carpeta del proyecto):

```powershell
dotnet publish -c Release
cd bin\Release\net6.0\publish
Copy-Item ..\..\..\..\hospital.db .
dotnet ./continuidad-u3.dll
```

Verificaciones: `dotnet publish -c Release` termina mostrando la ruta de `...\publish\`; `HospitalApi` compilado queda como `continuidad-u3.dll` en esa carpeta (el nombre lo toma de la carpeta del proyecto); `hospital.db` queda junto al dll; `Now listening on:` informa típicamente el puerto 5000; los endpoints probados contra ese puerto responden con el mismo JSON que en desarrollo. Si falta la base en la carpeta publish, SQLite crea una vacía y el primer pedido falla con `no such table`: es el motivo del checklist.

Checklist de despliegue resuelto:

| ✔ | Paso | Verificación esperada |
| --- | --- | --- |
| ☐ | `dotnet publish -c Release` | Termina sin errores y muestra la ruta de `...\publish\` |
| ☐ | El dll existe en la carpeta publish | `dir` muestra `continuidad-u3.dll` |
| ☐ | `hospital.db` junto al dll | `dir` muestra la base en la misma carpeta |
| ☐ | La API corre desde la carpeta publish | `dotnet ./continuidad-u3.dll` con la terminal parada ahí |
| ☐ | Puerto leído, no asumido | `Now listening on:` anotado (típicamente 5000) |
| ☐ | Endpoints probados publicados | 200 en los endpoints probados en desarrollo |

## 4. Criterios de corrección

El texto exacto de los mensajes 404 no se exige literal: se exige el código correcto con un cuerpo legible en español. Los ítems de funcionamiento se verifican sobre la API del grupo; los ítems de presentación, sobre la entrega manuscrita individual.

| Actividad | Ítem | Puntos |
| --- | --- | --- |
| 1 (10) | Proyecto corre con `hospital.db` junto al `.csproj` y los dos paquetes | 4 |
| | `/patients/{id:long}` responde 200 con id real y 404 con mensaje | 4 |
| | Presentación: respuestas anotadas y explicación `long`/`string` | 2 |
| 2 (20) | `/admissions/full` con los dos `ON` correctos y columnas calificadas | 8 |
| | Nombres concatenados en el SELECT y alias `AS` completos hacia el DTO | 4 |
| | `/doctors/{id}/admissions` con verificación previa y 404 con mensaje | 6 |
| | Presentación: cadena de relaciones y record `AdmissionDetail` copiados | 2 |
| 3 (20) | `/stats/admissions-by-specialty` con COUNT y GROUP BY correctos | 6 |
| | `/stats/top-doctors/{top:int}` con `LIMIT @top` parametrizado | 6 |
| | `/stats/stay` con AVG, `julianday` y `IS NOT NULL` | 6 |
| | Cuadro 1 completo y correcto | 2 |
| 4 (15) | Subconsulta escalar como columna y como filtro | 9 |
| | Orden por el conteo y prueba con `/multiple-admissions/2` | 3 |
| | Presentación: consulta copiada y explicación de la correlación | 3 |
| 5 (20) | `/admissions/open` con `IS NULL` y `COALESCE` | 7 |
| | `/admissions/strange-discharges` con ambas condiciones de imposibilidad | 7 |
| | Respuestas escritas: significado de `NULL` y de la alta de 1971 | 4 |
| | Cuadro 2 completo y correcto | 2 |
| 6 (15) | Cadena en `appsettings.json` leída con `??` antes de `builder.Build()` | 4 |
| | `dotnet publish`, base copiada a publish y API probada en su puerto | 7 |
| | Presentación: secuencia de comandos, JSON y checklist completos | 4 |

## 5. Errores frecuentes esperados

| Error observado | Causa | Atención en la corrección |
| --- | --- | --- |
| `ambiguous column name: patient_id` | Columna sin calificar con alias de tabla | Con tres tablas la calificación es obligatoria: `a.`, `p.`, `d.` en cada columna |
| Filas absurdas o multiplicadas en el JOIN | Falta uno de los dos `ON` | Revisar que cada tabla que entra tenga su enlace completo |
| 500 en el endpoint de estadística | `GROUP BY` faltante o columna suelta en el SELECT agregado | El SELECT solo lleva la columna del GROUP BY y agregados |
| El Top N devuelve más filas que N | `LIMIT` sin parámetro o ruta sin `{top:int}` | `LIMIT @top` + `new { top }` y la restricción en la ruta |
| Promedio de días absurdo (bajo) | Las altas de 1971 entran al promedio | Es el dato sucio esperado: valorar si el grupo lo detecta y explica |
| Comparar con `= NULL` sin resultados | `= NULL` nunca es verdadero en SQL | `IS NULL` para encontrarlo, `COALESCE` para reemplazarlo al exponer |
| `no such table` en la API publicada | Base no copiada a la carpeta publish: SQLite creó una vacía | Copiar `hospital.db` junto al dll y correr desde esa carpeta |
| Probar el puerto de desarrollo contra lo publicado | Puerto asumido en lugar de leído | Leer `Now listening on:` del proceso publicado |
| La API publicada no muestra los cambios | Se editó y no se volvió a publicar: lo publicado es una copia congelada | Repetir `dotnet publish -c Release` después de cada cambio |
| 404 que nunca aparece en `/doctors/{id}/admissions` | Se consultó el JOIN sin verificar antes la existencia | `ExecuteScalar<long>` primero; 404 con mensaje si devuelve 0 |

## 6. Registro del resultado

El puntaje sobre 100 de cada presentación se registra como una actividad más de la asignatura, dentro del proceso de evaluación, junto con observaciones cualitativas por estudiante (comprensión evidenciada en la entrega manuscrita, errores frecuentes del grupo, consultas pendientes de la autoevaluación). Las filas «Todavía no» de las autoevaluaciones y las tres preguntas de cierre se relevan al inicio de la clase siguiente y orientan la revisión de los núcleos con mayor dificultad antes del lanzamiento del trabajo final.
