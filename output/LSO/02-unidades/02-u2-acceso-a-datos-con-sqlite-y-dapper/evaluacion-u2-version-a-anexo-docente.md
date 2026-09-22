# Anexo docente — Evaluación de la Unidad 2 — Encuentro 15 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — retornar la lista completa de doctores
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY DoctorId"
    ).ToList();
    return Results.Ok(doctors);
});

// GET /doctors/{doctorId:long} — obtener un doctor por ID
app.MapGet("/doctors/{doctorId:long}", (long doctorId) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @doctorId", new { doctorId });

    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
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
               attending_doctor_id AS AttendingDoctorId
        FROM admissions
        ORDER BY AdmissionDate DESC"
    ).ToList();
    return Results.Ok(admissions);
});

// GET /admissions?doctorId={doctorId:long} — filtrar admissions por doctor
app.MapGet("/admissions", (long? doctorId) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (doctorId.HasValue)
    {
        var admissions = connection.Query<Admission>(@"
            SELECT patient_id AS PatientId,
                   admission_date AS AdmissionDate,
                   discharge_date AS DischargeDate,
                   diagnosis AS Diagnosis,
                   attending_doctor_id AS AttendingDoctorId
            FROM admissions
            WHERE attending_doctor_id = @doctorId
            ORDER BY AdmissionDate DESC", new { doctorId }).ToList();
        return Results.Ok(admissions);
    }
    var allAdmissions = connection.Query<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_doctor_id AS AttendingDoctorId
        FROM admissions
        ORDER BY AdmissionDate DESC").ToList();
    return Results.Ok(allAdmissions);
});

// GET /doctors/count — conteo de doctores
app.MapGet("/doctors/count", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var count = connection.ExecuteScalar<long>("SELECT COUNT(*) FROM doctors");
    return Results.Ok(new { count });
});

// GET /doctors?specialty={specialty} — buscar doctores por especialidad
app.MapGet("/doctors", (string? specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (!string.IsNullOrEmpty(specialty))
    {
        var doctors = connection.Query<Doctor>(@"
            SELECT doctor_id AS DoctorId,
                   first_name AS FirstName,
                   last_name AS LastName,
                   specialty AS Specialty
            FROM doctors
            WHERE specialty LIKE @specialty", new { specialty = $"%{specialty}%" }).ToList();
        return Results.Ok(doctors);
    }
    var allDoctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY DoctorId").ToList();
    return Results.Ok(allDoctors);
});

app.Run();

// Records posicionales (después de app.Run()): CS8803 requiere que las declaraciones
// de tipos sigan a las top-level statements.
public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
public record Admission(long PatientId, string AdmissionDate, string? DischargeDate, string? Diagnosis, long AttendingDoctorId);
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada |
| --- | --- | --- |
| `GET /doctors` | Lista completa | JSON con 27 objetos Doctor |
| `GET /doctors/1` | Doctor con ID 1 | JSON del doctor con DoctorId=1 |
| `GET /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` |
| `GET /admissions` | Lista completa | JSON con todas las admissions (306+ registros) |
| `GET /admissions?doctorId=1` | Admissions del doctor 1 | JSON con las admissions donde attending_doctor_id=1 |
| `GET /doctors/count` | Conteo | JSON con `count` = 27 |
| `GET /doctors?specialty=Cardiologist` | Doctores cardiólogos | JSON con los doctores cuya specialty contenga "Cardiologist" |

## 3. Criterios de corrección ítem por ítem

| Ítem | Puntos | Qué se observa | Error previsto | Intervención |
| --- | --- | --- | --- | --- |
| 1.1 Record Doctor con campos correctos | 10 | Los campos DoctorId (long), FirstName (string), LastName (string), Specialty (string) están declarados como record posicional. | Usar `int` para DoctorId; omitir `?` en campos nullable. | Recordar que Dapper exige `Int64` para columnas INTEGER y que fields nullable deben usar `?`. |
| 1.2 GET /doctors retorna lista | 15 | El endpoint retorna `Results.Ok(doctors)` con la lista completa. | Retornar la lista sin envolver; usar `int` en el record; omitir alias `AS`. | Verificar que la consulta use alias `AS` y que el endpoint retorne `Results.Ok`. |
| 1.3 GET /doctors/{doctorId:long} con 404 | 15 | El endpoint busca por ID y retorna 404 con `mensaje` en español si no existe. | No manejar el caso de no encontrado; usar `int` para el parámetro; mensaje en inglés. | Verificar el tipo del parámetro de ruta y la presencia del mensaje en español. |
| 2.1 Record Admission con campos correctos | 10 | Los campos PatientId (long), AdmissionDate (string), DischargeDate (string?), Diagnosis (string?), AttendingDoctorId (long) están declarados. | Tipos incorrectos; omitir `?` en campos nullable. | Verificar los tipos canónicos y la nulabilidad. |
| 2.2 GET /admissions con alias AS | 15 | El endpoint retorna todas las admissions usando alias `AS` en el SELECT. | Omitir alias `AS`; no usar `Results.Ok`. | Verificar que cada columna tenga alias `AS` que coincida con los parámetros del record. |
| 2.3 GET /admissions?doctorId filtrado | 15 | El endpoint filtra por doctorId parametrizando con `new { doctorId }`. | Concatenar el valor al SQL; no parametrizar; usar `int` en lugar de `long`. | Verificar que la consulta use `@doctorId` y `new { doctorId }`. |
| 3.1 GET /doctors/count con ExecuteScalar<long> | 10 | El endpoint usa `ExecuteScalar<long>` para contar doctores. | Usar `ExecuteScalar<int>`; no envolver en `Results.Ok`. | Verificar el tipo de retorno y la respuesta HTTP. |
| 3.2 GET /doctors?specialty con LIKE | 10 | El endpoint busca por especialidad usando `LIKE` con parámetro. | Concatenar al SQL; no usar `%` en el parámetro; no parametrizar. | Verificar que la consulta use `LIKE @specialty` y `new { specialty = $"%{specialty}%" }`. |
| 4.1 Pregunta conceptual long vs int | 5 | Respuesta correcta sobre Dapper e Int64. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar la tabla de tipos canónicos. |
| 4.2 Pregunta conceptual alias AS | 5 | Respuesta correcta sobre el error de materialización sin alias. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar que Dapper busca constructor con nombres de columna. |

## 4. Pauta de devolución

Se devuelve la evaluación con los puntos obtenidos por cada ítem. Se indica qué ítems están pendientes y qué correcciones se esperan. Si el alumno no alcanza 60 puntos, se le asigna la versión alternativa (B) para recuperación. Se registra la nota en la planilla con los comentarios del docente.