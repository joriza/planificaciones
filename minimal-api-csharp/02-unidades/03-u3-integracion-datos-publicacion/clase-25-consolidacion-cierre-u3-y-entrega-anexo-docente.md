# Anexo docente — Encuentro 25: sprint integrador, cierre de la Unidad 3 y entrega del tp-u3

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 3 — Integración de datos y publicación

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 25 — Sprint integrador, cierre de la Unidad 3 y entrega del tp-u3 (planificación anual; formato de cierre de unidad) |
| Trabajo evaluado | `tp-u3`: API sobre hospital.db con JOIN triple, estadística GROUP BY, búsqueda LIKE con validación 400, 404 de existencia y manejo explícito de un dato sucio; entrega por GitHub |
| Momento del bloque | Sprint integrador y consolidación (75 min) + trabajo del tp-u3 (90 min) + ciclo de entrega (45 min) + cierre (15 min) |
| Insumos | Repositorio del grupo con `tp-u1` y `tp-u2`, `hospital.db`, SDK de .NET 6, esqueleto del paso 4 del documento de clase |
| Encuentro siguiente | Evaluación de la Unidad 3 (26): verificación de entrega, defensa individual y prueba A/B |

## Preparación previa (gestión del aula)

- Ejecutar antes de clase la solución completa del TP (abajo) contra `hospital.db` y anotar valores reales: ranking de `/stats/top-doctors/1`, cantidad de resultados de `/patients/search?term=son` (sufijo común en apellidos), médicos con y sin ingresos para el 404, e ingresos abiertos. Son los valores de referencia de la revisión en el aula.
- Verificar los repositorios de los grupos antes del sprint: `.gitignore` en la raíz con `bin/` y `obj/`, y los trabajos anteriores entregados. Corregir eso al inicio es más barato que durante la entrega.
- Tener impreso o proyectado el checklist de entrega de la sección 5 del documento de clase; la evidencia del ciclo (commits y push) se revisa hoy, no en el encuentro de evaluación.
- Reservar los últimos 45 minutos para el ciclo de entrega: un TP sin push es un TP no entregado, aunque esté terminado. Cortar la construcción cuando el reloj lo diga.

## Solución completa del TP (Program.cs)

Referencia de corrección: los grupos pueden elegir variantes (la estadística de la consigna admite tres; el dato sucio, tres), pero cualquier variante válida mantiene estos patrones: consultas parametrizadas, `Results` explícitos, records al final, comentarios en español sin tildes, ids `long` y fechas `string`.

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);

// Configuracion de la clase 24: la cadena vive en appsettings.json.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();

// REQUISITO 1 (clase 21): GET /admissions/full, JOIN triple completo.
app.MapGet("/admissions/full", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        ORDER BY a.admission_date DESC").ToList();

    return Results.Ok(admissions);
});

// REQUISITO 2 (clase 22): eleccion del grupo; la referencia usa el Top N.
app.MapGet("/stats/top-doctors/{top:int}", (int top) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<TopDoctorAdmissions>(@"
        SELECT d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        GROUP BY d.doctor_id
        ORDER BY TotalAdmissions DESC
        LIMIT @Top",
        new { Top = top }).ToList();

    return Results.Ok(doctors);
});

// REQUISITO 3 (clases 12 y 22): busqueda LIKE con validacion y 400.
// El parametro es string? para que NUESTRA validacion responda el 400
// con mensaje: si fuera string sin ?, el framework corta antes con su 400.
app.MapGet("/patients/search", (string? term) =>
{
    if (string.IsNullOrWhiteSpace(term) || term.Trim().Length < 2)
    {
        return Results.BadRequest(new { mensaje = "El termino debe tener al menos 2 caracteres" });
    }

    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientBrief>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName
        FROM patients
        WHERE last_name LIKE @Pattern
        ORDER BY last_name, first_name",
        new { Pattern = "%" + term.Trim() + "%" }).ToList();

    return Results.Ok(patients);
});

// REQUISITO 4 (clase 21): JOIN triple filtrado con 404 de existencia.
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var exists = connection.ExecuteScalar<long>(
        @"SELECT doctor_id
          FROM doctors
          WHERE doctor_id = @Id",
        new { Id = id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.attending_doctor_id = @Id
        ORDER BY a.admission_date DESC",
        new { Id = id }).ToList();

    return Results.Ok(admissions);
});

// REQUISITO 5 (clase 23): dato sucio explicito. Eleccion de referencia:
// los aun internados. IS NULL encuentra el NULL y COALESCE declara el
// diagnostico faltante: la API no expone ni basura ni silencios.
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

app.Run();

// ---- Records: SIEMPRE al final del archivo ----
// Canonico de paciente (del esqueleto; ids long, fechas string).
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);

// Detalle de ingreso (del esqueleto; requisitos 1 y 4).
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);

// Requisito 2 en su variante Top N.
record TopDoctorAdmissions(string DoctorName, string Specialty, int TotalAdmissions);

// Requisito 3: busqueda por apellido.
record PatientBrief(long PatientId, string FirstName, string LastName);

// Requisito 5: ingreso abierto, con diagnostico garantizado por COALESCE.
record OpenAdmission(long PatientId, string PatientName, string AdmissionDate, string Diagnosis);
```

Variantes aceptadas de la consigna (todas con el molde ya probado en clase):

- Requisito 2: `GET /stats/admissions-by-specialty` o `GET /stats/by-month` en lugar del Top N (soluciones completas en la práctica de la clase 22).
- Requisito 5: `GET /patients/{id}/admissions` con filtro de altas imposibles, o `COALESCE` de diagnósticos sobre cualquier endpoint de detalle (soluciones en la práctica de la clase 23).

Pedidos de prueba de la referencia:

```http
### Requisito 1: el detalle completo (esperar 200 con los ingresos)
GET http://localhost:5080/admissions/full

### Requisito 2: el medico con mas ingresos (esperar 200 con una fila)
GET http://localhost:5080/stats/top-doctors/1

### Requisito 3: busqueda valida (esperar 200 con coincidencias)
GET http://localhost:5080/patients/search?term=son

### Requisito 3: termino de 1 caracter (esperar 400 con mensaje)
GET http://localhost:5080/patients/search?term=s

### Requisito 3: termino ausente (esperar 400 con mensaje)
GET http://localhost:5080/patients/search

### Requisito 3: termino valido sin coincidencias (esperar 200 con [])
GET http://localhost:5080/patients/search?term=zzz

### Requisito 4: medico existente (esperar 200 con sus ingresos)
GET http://localhost:5080/doctors/3/admissions

### Requisito 4: medico inexistente (esperar 404 con mensaje)
GET http://localhost:5080/doctors/9999/admissions

### Requisito 5: los aun internados (esperar 200; sin diagnosis en null)
GET http://localhost:5080/admissions/open
```

Respuestas esperadas:

- `/admissions/full` y `/doctors/3/admissions` → 200 con el DTO compuesto (nombres armados, no códigos); `/doctors/9999/admissions` → 404 con `{"mensaje":"No existe el medico"}`. Las cantidades por médico se constatan en la preparación previa.
- `/stats/top-doctors/1` → 200 con una fila: el médico con más ingresos y su total (valor anotado en la preparación).
- `/patients/search?term=s` y `/patients/search` → 400 con `{"mensaje":"El termino debe tener al menos 2 caracteres"}`; `term=son` → 200 con los apellidos que contienen "son" (cantidad anotada); `term=zzz` → 200 con `[]`.
- `/admissions/open` → 200 con los ingresos sin alta; ninguna fila con `diagnosis` en `null` (o texto real, o `"Sin diagnostico"`).

## Solución de la extensión

Punto 1 — requisito extra de subconsulta (la consulta gancho de la clase 23 dentro del TP):

```csharp
// Extension: ingresos a pacientes de 60 anios o mas, por especialidad.
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
```

Punto 2 — demostración publicada: ciclo de la clase 24 sobre el proyecto del TP (`dotnet publish -c Release`, copiar `hospital.db` a la carpeta publish, `dotnet ./HospitalApi.dll`, leer `Now listening on` y probar los cinco requisitos desde el puerto publicado). En la defensa, esta variante se recibe como evidencia plena de la prueba de cada requisito.

Punto 3 — revisión cruzada: no lleva código. Registrar los hallazgos de cada revisión (grupo revisor, requisito, sugerencia); son insumo directo para la devolución del encuentro 27.

## Criterios de corrección

| # | Criterio | Evidencia observable | Ponderación sugerida |
| --- | --- | --- | --- |
| 1 | Requisito 1: JOIN triple completo | `/admissions/full` con DTO compuesto, alias AS, orden descendente | 20 |
| 2 | Requisito 2: estadística GROUP BY | La variante elegida responde con grupos y totales; `LIMIT` parametrizado si eligió Top N | 15 |
| 3 | Requisito 3: búsqueda con validación | 400 con mensaje en los dos casos inválidos; 200 con `[]` en término sin coincidencias | 15 |
| 4 | Requisito 4: 404 de existencia | `/doctors/9999/admissions` → 404 con mensaje, verificación previa con `ExecuteScalar<long>` | 15 |
| 5 | Requisito 5: dato sucio explícito | La variante elegida funciona y el comentario la justifica | 15 |
| 6 | Canon de código | Consultas parametrizadas, `Results` explícitos, records al final, ids `long`, fechas `string`, comentarios sin tildes | 10 |
| 7 | Entrega y proceso | Carpeta `tp-u3/`, commits referentes, push verificado en GitHub, `bin/` y `obj/` fuera del repositorio | 10 |

Nota de registro: la instancia sumativa es el encuentro 26 (entrega verificada, defensa individual y prueba A/B); esta corrección del sprint alimenta la devolución y la evidencia de proceso. La defensa individual pregunta por los requisitos construidos y el mapa requisito → clase; la prueba A/B se rige por su propio instrumento.

## Qué observar en el aula

- **El paso 6 es el filtro del sprint:** ningún grupo reparte con el andamio roto. Los errores del andamio (base no copiada, JSON con coma perdida) son los mismos de las clases 21 a 24 y se corrijen en minutos si se detectan ahí.
- **El reparto por dueño de requisito es la evidencia de rotación del encuentro.** Registrar en el libro quién construyó qué: la defensa del encuentro 26 respeta ese reparto y el registro evita discusiones.
- **El parámetro `string? term` del requisito 3 es el detalle técnico fino del TP.** Con `string` sin `?`, el framework responde SU 400 (sin cuerpo) y la validación propia nunca corre. Nombrarlo en la revisión: es la diferencia entre «la API valida» y «el framework rechaza».
- **Señal de alerta:** commits únicos finales (`git log` con un solo commit de todo el TP), endpoints sin caso de error probado y DTOs duplicados. Los tres están en la tabla de errores comunes del documento de clase; se corrigen hoy, no en la evaluación.
- **El corte del reloj manda.** Un grupo que entrega cuatro requisitos funcionales con commits limpios está en mejor posición que uno que entrega cinco a medias: el criterio de honestidad de la entrega se anuncia al abrir el ciclo.

## Errores previsibles y respuestas

- *El andamio responde 500 al arrancar el sprint* → Base no copiada o JSON inválido. Intervención: checklist de la clase 24 en mano; corregir antes de repartir.
- *400 del requisito 3 sin mensaje (cuerpo vacío)* → Parámetro declarado sin `?`: el framework corta antes que la validación propia. Intervención: mostrar la diferencia en vivo con `term=` vacío; cambiar a `string? term`.
- *`/doctors/9999/admissions` devuelve `[]` en lugar de 404* → Falta la verificación de existencia previa. Intervención: el molde está en el esqueleto (`/patients/{id}`): mismo patrón, otra tabla.
- *El TP no aparece completo en GitHub* → Falta `git push` (o los commits quedaron locales). Intervención: leer la salida de `git status` y `git push` con el grupo; la verificación final es en el navegador, sobre la página del repositorio.
- *Grupo sin tiempo para el requisito 5* → Intervención: reducir alcance con honestidad: entregar los cuatro requisitos funcionales y documentar en el commit final qué falta; no entregar un requisito 5 que no responde.
