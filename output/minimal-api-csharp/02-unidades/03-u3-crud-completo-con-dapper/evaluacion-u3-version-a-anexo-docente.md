# Anexo docente — Evaluación U3 Versión A (CRUD doctores + JOIN triple)

## Solución completa

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — listar todos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors").ToList();
    return Results.Ok(doctors);
});

// GET /doctors/{id:long} — buscar por ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors WHERE doctor_id = @id", new { id });
    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
});

// POST /doctors — crear un doctor
app.MapPost("/doctors", (DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO doctors (first_name, last_name, specialty, phone, email)
        VALUES (@FirstName, @LastName, @Specialty, @Phone, @Email);
        SELECT last_insert_rowid()", input);

    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors WHERE doctor_id = @id", new { id = newId });

    return Results.Created($"/doctors/{newId}", doctor);
});

// PUT /doctors/{id:long} — actualizar un doctor
app.MapPut("/doctors/{id:long}", (long id, DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var existente = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors WHERE doctor_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    connection.Execute(@"
        UPDATE doctors SET first_name = @FirstName, last_name = @LastName,
            specialty = @Specialty, phone = @Phone, email = @Email
        WHERE doctor_id = @Id",
        new { input.FirstName, input.LastName, input.Specialty,
              input.Phone, input.Email, Id = id });

    return Results.NoContent();
});

// DELETE /doctors/{id:long} — eliminar un doctor
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM doctors WHERE doctor_id = @id", new { id });

    if (filas == 0)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    return Results.NoContent();
});

// GET /admissions/{id:long} — admision con JOIN triple
app.MapGet("/admissions/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admision = connection.QueryFirstOrDefault<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId, a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis, a.discharge_date AS DischargeDate,
               d.doctor_id AS DoctorId, d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName, p.patient_id AS PatientId,
               p.first_name AS PatientFirstName, p.last_name AS PatientLastName
        FROM admissions a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN patients p ON a.patient_id = p.patient_id
        WHERE a.admission_id = @id", new { id });

    return admision is null
        ? Results.NotFound(new { mensaje = "Admision no encontrada" })
        : Results.Ok(admision);
});

app.Run();

record DoctorInput(string FirstName, string? LastName, string? Specialty,
                   string? Phone, string? Email);

record Doctor(long DoctorId, string FirstName, string? LastName, string? Specialty,
              string? Phone, string? Email);

record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       string? DischargeDate, long DoctorId, string DoctorFirstName,
                       string? DoctorLastName, long PatientId, string PatientFirstName,
                       string? PatientLastName);
```

## Tabla de puntaje

| ✔ | Criterio | Pts |
|---|---|---|
| ☐ | GET /doctors | 5 |
| ☐ | GET /doctors/{id} — 200 | 3 |
| ☐ | GET /doctors/{id} — 404 | 2 |
| ☐ | POST /doctors — crea y 201 | 7 |
| ☐ | POST /doctors — valida y 400 | 5 |
| ☐ | PUT /doctors/{id} — actualiza y 204 | 7 |
| ☐ | PUT /doctors/{id} — 404 si no existe | 5 |
| ☐ | DELETE /doctors/{id} — 204 | 3 |
| ☐ | DELETE /doctors/{id} — 404 | 3 |
| ☐ | GET /admissions/{id} JOIN triple | 15 |
| ☐ | Tipos canónicos | 11 |
| ☐ | Calidad (alias, Results, using) | 9 |
| ☐ | Git y entrega | 20 |
| | **Total** | **100** |

## Equivalencia con versión B

| Aspecto | Versión A | Versión B |
|---|---|---|
| Tabla CRUD | doctors | patients |
| JOIN triple | admissions → doctors + patients | admissions → patients + doctors |
| Validación | FirstName no vacío | FirstName no vacío |
| Complejidad | Equivalente | Equivalente |