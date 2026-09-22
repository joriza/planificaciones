# Anexo docente — Evaluación de la Unidad 3 — Encuentro 26 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// POST /admissions — crear una nueva admission
app.MapPost("/admissions", (AdmissionInput input) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Validar que el paciente existe antes de insertar
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City
        FROM patients
        WHERE patient_id = @PatientId", new { input.PatientId });

    if (patient is null)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    // Insertar la admission y obtener el ID generado
    long newId = connection.ExecuteScalar<long>(@"
        INSERT INTO admissions (patient_id, admission_date, discharge_date, diagnosis, attending_patient_id)
        VALUES (@PatientId, @AdmissionDate, @DischargeDate, @Diagnosis, @AttendingPatientId);
        SELECT last_insert_rowid();", new { input.PatientId, input.AdmissionDate, input.DischargeDate, input.Diagnosis, input.AttendingPatientId });

    var admissionDetail = new AdmissionDetail(
        input.AdmissionDate,
        input.Diagnosis,
        $"{patient.FirstName} {patient.LastName}",
        "N/A"
    );

    return Results.Created($"/admissions/{newId}", admissionDetail);
});

// PUT /admissions/{patientId:long}/{admissionDate:date} — actualizar diagnosis
app.MapPut("/admissions/{patientId:long}/{admissionDate:date}", (long patientId, string admissionDate, string diagnosis) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Validar que la admission existe
    var existing = connection.QueryFirstOrDefault<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_patient_id AS AttendingPatientId
        FROM admissions
        WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { patientId, admissionDate });

    if (existing is null)
        return Results.NotFound(new { mensaje = "Ingreso no encontrado" });

    connection.Execute(@"
        UPDATE admissions SET diagnosis = @diagnosis
        WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { diagnosis, patientId, admissionDate });

    return Results.Ok(existing with { Diagnosis = diagnosis });
});

// PUT /admissions/{patientId:long}/{admissionDate:date}/discharge — establecer fecha de alta
app.MapPut("/admissions/{patientId:long}/{admissionDate:date}/discharge", (long patientId, string admissionDate, string dischargeDate) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existing = connection.QueryFirstOrDefault<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_patient_id AS AttendingPatientId
        FROM admissions
        WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { patientId, admissionDate });

    if (existing is null)
        return Results.NotFound(new { mensaje = "Ingreso no encontrado" });

    if (existing.DischargeDate is not null)
        return Results.BadRequest(new { mensaje = "La admission ya tiene fecha de alta" });

    connection.Execute(@"
        UPDATE admissions SET discharge_date = @dischargeDate
        WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { dischargeDate, patientId, admissionDate });

    return Results.Ok();
});

// DELETE /admissions/{patientId:long}/{admissionDate:date} — borrar admission
app.MapDelete("/admissions/{patientId:long}/{admissionDate:date}", (long patientId, string admissionDate) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existing = connection.QueryFirstOrDefault<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_patient_id AS AttendingPatientId
        FROM admissions
        WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { patientId, admissionDate });

    if (existing is null)
        return Results.NotFound(new { mensaje = "Ingreso no encontrado" });

    connection.Execute(@"
        DELETE FROM admissions
        WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { patientId, admissionDate });

    return Results.NoContent();
});

// GET /admissions/detail — JOIN de 3 tablas
app.MapGet("/admissions/detail", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var details = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_patient_id = d.doctor_id
        ORDER BY a.admission_date DESC"
    ).ToList();
    return Results.Ok(details);
});

app.Run();

// Records posicionales (después de app.Run()): CS8803 requiere que las declaraciones
// de tipos sigan a las top-level statements.
public record Patient(long PatientId, string FirstName, string LastName, string City);
public record Admission(long PatientId, string AdmissionDate, string? DischargeDate, string? Diagnosis, long AttendingPatientId);
public record AdmissionDetail(string AdmissionDate, string? Diagnosis, string PatientName, string DoctorName);
public record AdmissionInput(long PatientId, string AdmissionDate, string? DischargeDate, string? Diagnosis, long AttendingPatientId);
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada |
| --- | --- | --- |
| `POST /admissions` | Crear nueva admission | `201` con AdmissionDetail y URL de ubicación |
| `POST /admissions` con paciente inexistente | Paciente no encontrado | `404` con `{ "mensaje": "Paciente no encontrado" }` |
| `PUT /admissions/1/2024-01-15` | Actualizar diagnosis | `200` con la admission actualizada |
| `PUT /admissions/999/2024-01-15` | Ingreso inexistente | `404` con `{ "mensaje": "Ingreso no encontrado" }` |
| `DELETE /admissions/1/2024-01-15` | Borrar admission | `204` No Content |
| `DELETE /admissions/999/2024-01-15` | Ingreso inexistente | `404` con `{ "mensaje": "Ingreso no encontrado" }` |
| `GET /admissions/detail` | Lista con JOIN de 3 tablas | JSON con AdmissionDetail (AdmissionDate, Diagnosis, PatientName, DoctorName) |

## 3. Criterios de corrección ítem por ítem

| Ítem | Puntos | Qué se observa | Error previsto | Intervención |
| --- | --- | --- | --- | --- |
| 1.1 Record Patient | 5 | El record Patient tiene los campos correctos con tipos canónicos. | Tipos incorrectos; campos faltantes. | Verificar los tipos y la declaración del record. |
| 1.2 Record Admission | 5 | El record Admission tiene los campos correctos con tipos canónicos y nullable. | Tipos incorrectos; omitir `?` en DischargeDate/Diagnosis. | Verificar los tipos canónicos y la nulabilidad. |
| 1.3 Record AdmissionDetail | 5 | El record AdmissionDetail tiene los campos correctos. | Campos faltantes o nombres incorrectos. | Verificar que el record coincida con lo que retorna el endpoint. |
| 1.4 POST /admissions con validación | 10 | El endpoint inserta la admission, valida que el paciente existe, retorna 201 con Created. | No validar la existencia del paciente; no retornar 201; no parametrizar. | Verificar que la validación use `QueryFirstOrDefault` y que el INSERT use `ExecuteScalar<long>`. |
| 2.1 PUT /admissions actualizar diagnosis | 15 | El endpoint actualiza la diagnosis y retorna 200 o 404. | No validar existencia; retornar código incorrecto; no parametrizar. | Verificar que use `QueryFirstOrDefault` para validar y `Execute` para actualizar. |
| 2.2 PUT /admissions/discharge | 10 | El endpoint establece discharge_date, valida existencia y que no tenga ya fecha de alta. | No validar existencia; no verificar si ya tiene discharge_date; retornar código incorrecto. | Verificar que la validación de existencia y de discharge_date nula estén presentes. |
| 3.1 DELETE /admissions | 20 | El endpoint borra la admission y retorna 204 o 404. | No validar existencia; retornar código incorrecto; no parametrizar. | Verificar que use `QueryFirstOrDefault` para validar y `Execute` para borrar. |
| 4.1 GET /admissions/detail con JOIN de 3 tablas | 20 | El endpoint retorna AdmissionDetail con JOIN de admissions + patients + doctors usando alias `AS`. | Omitir alias `AS`; no hacer JOIN de 3 tablas; concatenar SQL. | Verificar que el JOIN incluya las 3 tablas y que cada columna tenga alias `AS`. |
| 5.1 Pregunta conceptual código 201 | 5 | Respuesta correcta: 201 Created porque se creó un nuevo recurso. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar la convención de códigos HTTP. |
| 5.2 Pregunta conceptual DELETE inexistente | 5 | Respuesta correcta: 404 Not Found con mensaje en español. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar la convención de códigos HTTP. |

## 4. Pauta de devolución

Se devuelve la evaluación con los puntos obtenidos por cada ítem. Se indica qué ítems están pendientes y qué correcciones se esperan. Si el alumno no alcanza 60 puntos, se le asigna la versión alternativa (A) para recuperación. Se registra la nota en la planilla con los comentarios del docente.
