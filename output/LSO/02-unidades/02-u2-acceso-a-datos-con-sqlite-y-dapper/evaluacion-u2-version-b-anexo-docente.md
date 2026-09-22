# Anexo docente — Evaluación de la Unidad 2 — Encuentro 15 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — retornar la lista completa de pacientes
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City
        FROM patients
        ORDER BY PatientId"
    ).ToList();
    return Results.Ok(patients);
});

// GET /patients/{patientId:long} — obtener un paciente por ID
app.MapGet("/patients/{patientId:long}", (long patientId) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City
        FROM patients
        WHERE patient_id = @patientId", new { patientId });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// GET /admissions — retornar todas las admissions
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_patient_id AS AttendingPatientId
        FROM admissions
        ORDER BY AdmissionDate DESC"
    ).ToList();
    return Results.Ok(admissions);
});

// GET /admissions?patientId={patientId:long} — filtrar admissions por paciente
app.MapGet("/admissions", (long? patientId) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (patientId.HasValue)
    {
        var admissions = connection.Query<Admission>(@"
            SELECT patient_id AS PatientId,
                   admission_date AS AdmissionDate,
                   discharge_date AS DischargeDate,
                   diagnosis AS Diagnosis,
                   attending_patient_id AS AttendingPatientId
            FROM admissions
            WHERE attending_patient_id = @patientId
            ORDER BY AdmissionDate DESC", new { patientId }).ToList();
        return Results.Ok(admissions);
    }
    var allAdmissions = connection.Query<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_patient_id AS AttendingPatientId
        FROM admissions
        ORDER BY AdmissionDate DESC").ToList();
    return Results.Ok(allAdmissions);
});

// GET /patients/count — conteo de pacientes
app.MapGet("/patients/count", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var count = connection.ExecuteScalar<long>("SELECT COUNT(*) FROM patients");
    return Results.Ok(new { count });
});

// GET /patients?city={city} — buscar pacientes por ciudad
app.MapGet("/patients", (string? city) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (!string.IsNullOrEmpty(city))
    {
        var patients = connection.Query<Patient>(@"
            SELECT patient_id AS PatientId,
                   first_name AS FirstName,
                   last_name AS LastName,
                   city AS City
            FROM patients
            WHERE city LIKE @city", new { city = $"%{city}%" }).ToList();
        return Results.Ok(patients);
    }
    var allPatients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City
        FROM patients
        ORDER BY PatientId").ToList();
    return Results.Ok(allPatients);
});

app.Run();

// Records posicionales (después de app.Run()): CS8803 requiere que las declaraciones
// de tipos sigan a las top-level statements.
public record Patient(long PatientId, string FirstName, string LastName, string City);
public record Admission(long PatientId, string AdmissionDate, string? DischargeDate, string? Diagnosis, long AttendingPatientId);
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada |
| --- | --- | --- |
| `GET /patients` | Lista completa | JSON con 27 objetos Patient |
| `GET /patients/1` | Paciente con ID 1 | JSON del paciente con PatientId=1 |
| `GET /patients/999` | Paciente inexistente | `404` con `{ "mensaje": "Paciente no encontrado" }` |
| `GET /admissions` | Lista completa | JSON con todas las admissions (306+ registros) |
| `GET /admissions?patientId=1` | Admissions del paciente 1 | JSON con las admissions donde attending_patient_id=1 |
| `GET /patients/count` | Conteo | JSON con `count` = 27 |
| `GET /patients?city=Cardiologist` | Pacientes de Cardiologist | JSON con los pacientes cuya city contenga "Cardiologist" |

## 3. Criterios de corrección ítem por ítem

| Ítem | Puntos | Qué se observa | Error previsto | Intervención |
| --- | --- | --- | --- | --- |
| 1.1 Record Patient con campos correctos | 10 | Los campos PatientId (long), FirstName (string), LastName (string), City (string) están declarados como record posicional. | Usar `int` para PatientId; omitir `?` en campos nullable. | Recordar que Dapper exige `Int64` para columnas INTEGER y que fields nullable deben usar `?`. |
| 1.2 GET /patients retorna lista | 15 | El endpoint retorna `Results.Ok(patients)` con la lista completa. | Retornar la lista sin envolver; usar `int` en el record; omitir alias `AS`. | Verificar que la consulta use alias `AS` y que el endpoint retorne `Results.Ok`. |
| 1.3 GET /patients/{patientId:long} con 404 | 15 | El endpoint busca por ID y retorna 404 con `mensaje` en español si no existe. | No manejar el caso de no encontrado; usar `int` para el parámetro; mensaje en inglés. | Verificar el tipo del parámetro de ruta y la presencia del mensaje en español. |
| 2.1 Record Admission con campos correctos | 10 | Los campos PatientId (long), AdmissionDate (string), DischargeDate (string?), Diagnosis (string?), AttendingPatientId (long) están declarados. | Tipos incorrectos; omitir `?` en campos nullable. | Verificar los tipos canónicos y la nulabilidad. |
| 2.2 GET /admissions con alias AS | 15 | El endpoint retorna todas las admissions usando alias `AS` en el SELECT. | Omitir alias `AS`; no usar `Results.Ok`. | Verificar que cada columna tenga alias `AS` que coincida con los parámetros del record. |
| 2.3 GET /admissions?patientId filtrado | 15 | El endpoint filtra por patientId parametrizando con `new { patientId }`. | Concatenar el valor al SQL; no parametrizar; usar `int` en lugar de `long`. | Verificar que la consulta use `@patientId` y `new { patientId }`. |
| 3.1 GET /patients/count con ExecuteScalar<long> | 10 | El endpoint usa `ExecuteScalar<long>` para contar pacientes. | Usar `ExecuteScalar<int>`; no envolver en `Results.Ok`. | Verificar el tipo de retorno y la respuesta HTTP. |
| 3.2 GET /patients?city con LIKE | 10 | El endpoint busca por ciudad usando `LIKE` con parámetro. | Concatenar al SQL; no usar `%` en el parámetro; no parametrizar. | Verificar que la consulta use `LIKE @city` y `new { city = $"%{city}%" }`. |
| 4.1 Pregunta conceptual long vs int | 5 | Respuesta correcta sobre Dapper e Int64. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar la tabla de tipos canónicos. |
| 4.2 Pregunta conceptual alias AS | 5 | Respuesta correcta sobre el error de materialización sin alias. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar que Dapper busca constructor con nombres de columna. |

## 4. Pauta de devolución

Se devuelve la evaluación con los puntos obtenidos por cada ítem. Se indica qué ítems están pendientes y qué correcciones se esperan. Si el alumno no alcanza 60 puntos, se le asigna la versión alternativa (A) para recuperación. Se registra la nota en la planilla con los comentarios del docente.
