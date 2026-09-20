# Encuentro 23 — Subconsultas y datos sucios

> Unidad 3 — Integración de datos y publicación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 23 |
| Unidad | 3 — Integración de datos y publicación |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Subconsultas simples (escalar correlacionada y `IN`), valores `NULL` (`IS NULL`, `COALESCE`), datos sucios reales (typos, fechas imposibles) y robustez del endpoint |
| Requisitos previos | Clase 22 completada (COUNT/AVG/SUM con GROUP BY, LIMIT parametrizado, `strftime` y `julianday`); observación anotada del promedio «extraño» de `/stats/stay` |
| Uso de celular | No permitido |
| Grupos | Presentes ÷ equipos disponibles (mínimo posible); rotación de integrantes entre la práctica y la extensión |
| Planificación anual | Encuentro 23: subconsultas simples; datos sucios reales (valores NULL, errores de tipeo, fechas erróneas): robustez y manejo de errores |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (20 min).** Se retoma la observación anotada en la clase 22: el promedio de días de internación salió más bajo de lo esperado. La base no está rota: está sucia. Entre los ingresos reales conviven fechas de alta imposibles (del año 1971, anteriores al propio ingreso), diagnósticos mal tipeados («Stomache Pain», «Amigima») e ingresos sin fecha de alta. Segunda pregunta puente: ¿qué médicos atendieron a los pacientes con MÁS ingresos? Contar los ingresos de cada paciente es una consulta; usar ese conteo como filtro es otra consulta dentro de la primera. Dos herramientas nuevas hoy: la subconsulta y el control de calidad sobre los datos antes de exponerlos.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar qué es una subconsulta: una consulta cuyo resultado alimenta a otra (como valor calculado o como lista de comparación `IN`).
2. Escribir la subconsulta escalar correlacionada (conteo de ingresos por paciente) y la subconsulta con `IN` (pacientes de 60 años o más).
3. Distinguir el `NULL` del resto de los valores y tratarlo con `IS NULL` y `COALESCE` al exponer datos.
4. Detectar los datos sucios reales de hospital.db (typos de diagnóstico, altas imposibles de 1971) con consultas de auditoría.
5. Construir endpoints robustos que no expongan datos basura: filtrar lo imposible y reemplazar el faltante con un texto explícito.

## 3. Teoría mínima (40 min)

### Charla rápida: la ficha sin fecha de alta

En el archivo del hospital aparece una ficha de ingreso sin fecha de alta. ¿Está incompleta? No: significa que el paciente todavía está internado. La ausencia del dato ES la información. Ese «todavía no» tiene nombre en las bases de datos: `NULL`. No es cero, no es texto vacío, no es error: es la marca de que el dato no existe todavía. Y como toda la base la escriben personas, también arrastra errores de tipeo («Stomache Pain») y fechas imposibles (alta en 1971 de un ingreso de 2018). Un endpoint que expone la base tal cual está, expone también los errores de quien la cargó. Antes de servir el plato, la cocina revisa: hoy la API aprende a revisar.

### Lo mínimo indispensable

**Subconsulta escalar correlacionada.** Una consulta que produce UN valor por fila de la consulta externa, usando datos de esa fila:

```sql
SELECT p.patient_id AS PatientId,
       p.first_name AS FirstName,
       p.last_name  AS LastName,
       (SELECT COUNT(*)
        FROM admissions a
        WHERE a.patient_id = p.patient_id) AS AdmissionCount
FROM patients p
```

Por cada paciente, la subconsulta interna cuenta SUS ingresos (por eso es «correlacionada»: referencia a `p`, la fila externa). El resultado se usa como cualquier columna, con su alias AS. Y puede usarse también como filtro:

```sql
WHERE (SELECT COUNT(*) FROM admissions a
       WHERE a.patient_id = p.patient_id) > @Min
```

**Subconsulta con `IN`.** La consulta interna devuelve una LISTA y la externa compara contra ella:

```sql
WHERE a.patient_id IN (SELECT p2.patient_id FROM patients p2 WHERE ...)
```

Se lee igual que en castellano: «los ingresos cuyo paciente está en la lista de pacientes de 60 años o más». La edad se calcula comparando años de nacimiento con `strftime('%Y', birth_date)`; es una aproximación por año, suficiente para agrupar.

**`NULL`: ni cero ni vacío.** Tres reglas prácticas:

| Herramienta | Qué hace | Ejemplo |
| --- | --- | --- |
| `IS NULL` | Encuentra lo que no tiene valor | `WHERE discharge_date IS NULL` → los aún internados |
| `IS NOT NULL` | Encuentra lo que sí tiene valor | el filtro que usó la clase 22 para promediar |
| `COALESCE(col, texto)` | Devuelve el primer valor no nulo | `COALESCE(diagnosis, 'Sin diagnostico')` |

`COALESCE` es el traductor de bordes: la base guarda «no hay dato», el JSON muestra un texto explícito. Consecuencia directa para el record: si el SELECT garantiza un valor con `COALESCE`, la propiedad se declara `string` (sin `?`), porque ya no puede llegar `null`.

**Datos sucios: detectar, no esconder.** La auditoría usa las herramientas de siempre (LIKE, comparaciones de texto ISO) para nombrar el problema: `discharge_date LIKE '1971-%'` encuentra las fechas imposibles; `discharge_date < admission_date` encuentra altas anteriores al ingreso. La robustez combina ambas: el endpoint que expone historias filtra lo imposible y lo que falta lo declara con `COALESCE`. El JSON que sale de la API debe poder leerse sin disculpas.

## 4. Práctica guiada (70 min)

### Paso 1 — Preparar el proyecto

Reutilizar el proyecto de la clase 22 (o recrearlo). Todo el código de hoy reemplaza el contenido de `Program.cs`.

### Paso 2 — Reemplazar Program.cs

Borrar todo y pegar este código completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion canonica: hospital.db junto al .csproj.
var connectionString = "Data Source=hospital.db";

// GET /patients/multiple-admissions/{min}: pacientes con MAS de min ingresos.
// La subconsulta escalar correlacionada cuenta los ingresos de CADA paciente
// y ese conteo se usa como columna y como filtro.
app.MapGet("/patients/multiple-admissions/{min:int}", (int min) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientAdmissionCount>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               (SELECT COUNT(*)
                FROM admissions a
                WHERE a.patient_id = p.patient_id) AS AdmissionCount
        FROM patients p
        WHERE (SELECT COUNT(*)
               FROM admissions a
               WHERE a.patient_id = p.patient_id) > @Min
        ORDER BY AdmissionCount DESC",
        new { Min = min }).ToList();

    return Results.Ok(patients);
});

// GET /stats/seniors-by-specialty: ingresos a pacientes de 60 anios o mas,
// por especialidad. La subconsulta con IN devuelve la lista de esos pacientes
// y el JOIN con doctors suma el resto del detalle (consulta gancho).
app.MapGet("/stats/seniors-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<AdmissionBySpecialty>(@"
        SELECT d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.patient_id IN (
                SELECT p2.patient_id
                FROM patients p2
                WHERE (CAST(strftime('%Y', 'now') AS INTEGER)
                     - CAST(strftime('%Y', p2.birth_date) AS INTEGER)) >= 60)
        GROUP BY d.specialty
        ORDER BY TotalAdmissions DESC").ToList();

    return Results.Ok(stats);
});

// GET /admissions/open: ingresos SIN fecha de alta = pacientes aun internados.
// NULL no se expone crudo: COALESCE reemplaza el diagnostico faltante.
app.MapGet("/admissions/open", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<OpenAdmission>(@"
        SELECT a.patient_id AS PatientId,
               p.first_name || ' ' || p.last_name AS PatientName,
               a.admission_date AS AdmissionDate,
               COALESCE(a.diagnosis, 'Sin diagnostico') AS Diagnosis
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        WHERE a.discharge_date IS NULL
        ORDER BY a.admission_date").ToList();

    return Results.Ok(admissions);
});

// GET /diagnoses/suspicious: auditoria de typos conocidos de la base.
// Agrupa los diagnosticos sospechosos y cuenta cuantas veces aparece cada uno.
app.MapGet("/diagnoses/suspicious", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var diagnoses = connection.Query<SuspiciousDiagnosis>(@"
        SELECT a.diagnosis AS Diagnosis,
               COUNT(*) AS Total
        FROM admissions a
        WHERE a.diagnosis LIKE '%Stomache%'
           OR a.diagnosis LIKE '%Amigima%'
           OR a.diagnosis LIKE '%Rheumataoid%'
        GROUP BY a.diagnosis
        ORDER BY Total DESC").ToList();

    return Results.Ok(diagnoses);
});

// GET /admissions/strange-discharges: altas imposibles.
// Una alta de 1971 o anterior al propio ingreso no puede ser real.
app.MapGet("/admissions/strange-discharges", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<StrangeDischarge>(@"
        SELECT a.patient_id AS PatientId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis
        FROM admissions a
        WHERE a.discharge_date IS NOT NULL
          AND (a.discharge_date < a.admission_date
               OR a.discharge_date LIKE '1971-%')
        ORDER BY a.discharge_date").ToList();

    return Results.Ok(admissions);
});

// GET /patients/{id}/admissions: la historia LIMPIA de un paciente.
// Robustez en dos movimientos: lo imposible se filtra (altas de 1971 o
// previas al ingreso) y lo faltante se declara con COALESCE.
app.MapGet("/patients/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero el paciente: 404 si no existe (patron de la clase 21).
    var exists = connection.ExecuteScalar<long>(
        @"SELECT patient_id
          FROM patients
          WHERE patient_id = @Id",
        new { Id = id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    var admissions = connection.Query<PatientAdmission>(@"
        SELECT a.admission_date AS AdmissionDate,
               COALESCE(a.discharge_date, 'Aun internado') AS DischargeDate,
               COALESCE(a.diagnosis, 'Sin diagnostico') AS Diagnosis
        FROM admissions a
        WHERE a.patient_id = @Id
          AND (a.discharge_date IS NULL
               OR (a.discharge_date >= a.admission_date
                   AND a.discharge_date NOT LIKE '1971-%'))
        ORDER BY a.admission_date DESC",
        new { Id = id }).ToList();

    return Results.Ok(admissions);
});

app.Run();

// Los records van SIEMPRE al final del archivo, despues de app.Run().
// Paciente con su conteo de ingresos: la subconsulta agrega la columna.
record PatientAdmissionCount(long PatientId, string FirstName, string LastName, int AdmissionCount);

// Reutilizado de la clase 22: resumen de ingresos por especialidad.
record AdmissionBySpecialty(string Specialty, int TotalAdmissions);

// Ingreso aun abierto: el diagnostico faltante sale como texto explicito.
record OpenAdmission(long PatientId, string PatientName, string AdmissionDate, string Diagnosis);

// Auditoria de typos: el diagnostico sospechoso y cuantas veces aparece.
record SuspiciousDiagnosis(string Diagnosis, int Total);

// Alta imposible: fecha de alta contra fecha de ingreso, a la vista.
record StrangeDischarge(long PatientId, string AdmissionDate, string DischargeDate, string? Diagnosis);

// Fila de historia limpia: con COALESCE, nada puede llegar en null.
record PatientAdmission(string AdmissionDate, string DischargeDate, string Diagnosis);
```

### Paso 3 — Levantar la API

```powershell
dotnet run
```

### Paso 4 — Probar los endpoints en el navegador

- `http://localhost:5080/patients/multiple-admissions/2` → 200 con los pacientes que tuvieron MÁS de 2 ingresos, el que más tuvo primero. Probar también `/patients/multiple-admissions/0` (todos los que tengan al menos uno).
- `http://localhost:5080/stats/seniors-by-specialty` → 200 con el ranking de especialidades por ingresos a pacientes de 60 años o más (la consulta gancho).
- `http://localhost:5080/admissions/open` → 200 con los ingresos sin alta: los aún internados.
- `http://localhost:5080/diagnoses/suspicious` → 200 con los typos detectados y cuántas veces aparece cada uno.
- `http://localhost:5080/admissions/strange-discharges` → 200 con las altas imposibles, incluidas las de 1971.
- `http://localhost:5080/patients/12/admissions` → 200 con la historia limpia de ese paciente. Probar `/patients/9999/admissions` → 404 con mensaje.

### Paso 5 — Experimento: el endpoint sin control de calidad

1. En `/patients/{id}/admissions`, eliminar temporalmente el bloque `AND (a.discharge_date IS NULL OR ...)` del WHERE y los dos `COALESCE` (dejar las columnas crudas).
2. Reiniciar y recorrer historias de pacientes hasta encontrar una fila con `dischargeDate` en `1971-01-05` o una fecha de alta anterior al ingreso, y otra con `dischargeDate` en `null`.
3. Comparar con la versión filtrada: la misma historia, sin basura y sin `null`. Reponer los `COALESCE` y el filtro. La diferencia entre ambas versiones es, literalmente, «robustez».

### Salidas esperadas

**GET /patients/multiple-admissions/2** → 200 con los pacientes con más de 2 ingresos (estructura; los nombres y cantidades se constatan en clase):

```json
[
  {
    "patientId": 12,
    "firstName": "Emily",
    "lastName": "Watson",
    "admissionCount": 4
  }
]
```

**GET /admissions/open** → 200 con los aún internados; `diagnosis` nunca es `null` (o el texto real, o `"Sin diagnostico"`):

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

**GET /diagnoses/suspicious** → 200 con los typos reales de la base, por ejemplo:

```json
[
  { "diagnosis": "Stomache Pain", "total": 3 },
  { "diagnosis": "Rheumataoid Arthritis", "total": 2 },
  { "diagnosis": "Amigima", "total": 1 }
]
```

**GET /admissions/strange-discharges** → 200 con las altas imposibles; entre ellas las de fecha `1971-01-05` (anotar la cantidad exacta: es un dato de auditoría del grupo).

**GET /patients/12/admissions (versión robusta)** → 200 donde ninguna fila expone `null` ni fechas imposibles:

```json
[
  {
    "admissionDate": "2019-01-10",
    "dischargeDate": "Aun internado",
    "diagnosis": "Sin diagnostico"
  },
  {
    "admissionDate": "2018-07-02",
    "dischargeDate": "2018-07-15",
    "diagnosis": "Appendicitis"
  }
]
```

Observación: `"Aun internado"` no es una fecha y no pretende serlo: es el texto que declara el estado. El SELECT lo garantiza con `COALESCE`, por eso el record declara `string DischargeDate` sin `?`.

## 5. Ejercicio independiente (50 min)

Trabajo por grupos: presentes ÷ equipos disponibles, un equipo por PC. Rotación de roles a mitad del bloque.

### Consigna

Agregar al mismo proyecto dos endpoints:

1. `GET /patients/never-admitted`: los pacientes que NUNCA tuvieron un ingreso. Necesita un DTO propio con id, nombre y apellido (record `PatientBrief`). La subconsulta va del lado del `NOT IN`.
2. `GET /admissions/long-stays/{days:int}`: las internaciones de MÁS de `days` días (el gancho del hospital: «¿quiénes estuvieron internados más de 10 días?»). Cada fila muestra el ingreso y su duración calculada. Solo internaciones terminadas Y con alta verdadera: quedan afuera tanto los sin alta como las altas imposibles.

### Pista

Punto 1: `WHERE p.patient_id NOT IN (SELECT patient_id FROM admissions)` sobre `patients`, con los alias AS hacia `PatientBrief`. Punto 2: la duración es `julianday(discharge_date) - julianday(admission_date)` (la clase 22 la usó para promediar; acá se muestra por fila con `CAST(... AS INTEGER) AS Days`), el filtro de duración con `> @Days`, y la condición de alta verdadera es la misma del endpoint robusto de la práctica (`IS NOT NULL` + `>= admission_date` + `NOT LIKE '1971-%'`). La solución completa está en el anexo docente.

## 6. Extensión y consolidación (45 min)

Para los grupos que completan la consigna base. Los demás consolidan terminando el ejercicio con acompañamiento.

1. **Radiografía de la base.** `GET /admissions/data-quality`: UN endpoint con UNA fila que resuma la salud de la base — ingresos abiertos, altas imposibles y diagnósticos sospechosos, cada uno con su conteo. Las tres subconsultas escalares conviven en un solo SELECT (una por columna). Es el informe de auditoría que un hospital real querría.
2. **Consolidación: el mapa de la unidad.** Cada grupo arma en papel el cuadro de dos columnas — «la consulta» / «qué herramienta la resolvió» — para los seis endpoints de la práctica (subconsulta escalar, `IN`, `IS NULL`, LIKE de auditoría, filtro de imposibles, `COALESCE`). Rotación: completa el cuadro quien no condujo el teclado. Es material de repaso para la evaluación.
3. **Discusión dirigida: ¿corregir o exponer?** Con la evidencia de `/diagnoses/suspicious`: ¿la API debería corregir «Stomache Pain» a «Stomach Pain» al volcar la base, o exponerla tal cual y reportar el hallazgo? Cada grupo toma una posición y la defiende en dos líneas. No hay respuesta única: hay un criterio (la API no inventa datos; los corrige quien administra la base).

## 7. Cierre (15 min)

### Qué te llevás

- Una subconsulta es una consulta dentro de otra: la escalar correlacionada aporta UN valor por fila (el conteo de ingresos de cada paciente); la de `IN` aporta una LISTA contra la que comparar (los pacientes de 60 años o más).
- `NULL` es «todavía no»: ni cero ni vacío. `IS NULL` lo encuentra y `COALESCE` lo traduce a un texto explícito al exponer; si el SELECT garantiza valor, el record deja de declarar `?`.
- La base real tiene errores de carga: typos («Stomache Pain») y fechas imposibles (alta en 1971, alta antes del ingreso). Antes de promediar o exponer, la auditoría los nombra y el filtro los separa.
- Robustez del endpoint = dos movimientos: filtrar lo imposible y declarar lo faltante. El JSON que sale de la API se lee sin disculpas.
- La promesa de la clase 22 se cumplió: el promedio «extraño» tenía causa, y la herramienta para verla es una consulta de auditoría de tres líneas.

### Lo que viene

Encuentro 24: «Configuración de la cadena de conexión en appsettings.json; publicación con dotnet publish y ejecución en release». La API ya sabe leer una base imperfecta; le falta mudarse: la cadena de conexión deja de estar escrita dentro del código, la API se empaqueta con `dotnet publish` y corre desde la carpeta publicada como correría en una máquina real.

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 23: subconsultas y datos sucios"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Subconsulta que devuelve muchos valores donde se espera uno | Escalar usada como valor directo (`= (SELECT ...)`) con más de una fila de resultado | La escalar correlacionada usa `COUNT`/`MAX`/etc. o filtro por clave; para listas, `IN` |
| Comparar con `NULL` usando `= NULL` | `= NULL` nunca es verdadero en SQL: `NULL` no es igual a nada, ni a sí mismo | `IS NULL` para encontrarlo, `COALESCE` para reemplazarlo |
| Propiedad `string?` que nunca llega en `null` (o `string` que sí llega en `null`) | El tipo del record no refleja lo que el SELECT garantiza | Con `COALESCE` en la columna, declarar `string`; sin él, sobre columna nullable, `string?` |
| Las altas imposibles entran en la duración | `julianday` sobre la fecha de 1971 resta negativo y arruina conteos | Filtrar la alta verdadera: `IS NOT NULL AND discharge_date >= admission_date AND NOT LIKE '1971-%'` |
| Auditoría que «no encuentra nada» | Patrón LIKE demasiado estricto (`= 'Stomache Pain'` con variantes de carga) | `LIKE '%Stomache%'`: el comodín busca el fragmento en cualquier posición |
| Historia del paciente que devuelve 404 para un paciente real | El filtro de robustez excluyó TODO si el paciente solo tiene ingresos sucios (caso raro, pero posible) | Revisar el WHERE combinado (`IS NULL OR ...`): el paréntesis agrupa las condiciones de alta válida |
