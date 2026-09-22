# Anexo docente — Evaluación U3 Versión B (CRUD pacientes + JOIN triple)

## Solución completa

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar todos
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients ORDER BY last_name").ToList();
    return Results.Ok(patients);
});

// GET /patients/{id:long} — buscar por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id });
    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// POST /patients — crear un paciente
app.MapPost("/patients", (PatientInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date,
                              city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate,
                @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid()", input);

    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id = newId });

    return Results.Created($"/patients/{newId}", patient);
});

// PUT /patients/{id:long} — actualizar un paciente
app.MapPut("/patients/{id:long}", (long id, PatientInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    connection.Execute(@"
        UPDATE patients SET first_name = @FirstName, last_name = @LastName,
            gender = @Gender, birth_date = @BirthDate, city = @City,
            province_id = @ProvinceId, allergies = @Allergies,
            height = @Height, weight = @Weight
        WHERE patient_id = @Id",
        new { input.FirstName, input.LastName, input.Gender, input.BirthDate,
              input.City, input.ProvinceId, input.Allergies, input.Height,
              input.Weight, Id = id });

    return Results.NoContent();
});

// DELETE /patients/{id:long} — eliminar un paciente
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });

    if (filas == 0)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    return Results.NoContent();
});

// GET /admissions/{id:long} — admision con JOIN triple
app.MapGet("/admissions/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admision = connection.QueryFirstOrDefault<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId, a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis, a.discharge_date AS DischargeDate,
               p.patient_id AS PatientId, p.first_name AS PatientFirstName,
               p.last_name AS PatientLastName, d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName, d.last_name AS DoctorLastName
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.doctor_id = d.doctor_id
        WHERE a.admission_id = @id", new { id });

    return admision is null
        ? Results.NotFound(new { mensaje = "Admision no encontrada" })
        : Results.Ok(admision);
});

app.Run();

record PatientInput(string FirstName, string LastName, string Gender,
                    string BirthDate, string? City, string ProvinceId,
                    string? Allergies, long? Height, long? Weight);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);

record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       string? DischargeDate, long PatientId, string PatientFirstName,
                       string? PatientLastName, long DoctorId, string DoctorFirstName,
                       string? DoctorLastName);
```

## Tabla de puntaje

| ✔ | Criterio | Pts |
|---|---|---|
| ☐ | GET /patients ordenado | 5 |
| ☐ | GET /patients/{id} — 200 | 3 |
| ☐ | GET /patients/{id} — 404 | 2 |
| ☐ | POST /patients — crea y 201 | 7 |
| ☐ | POST /patients — valida y 400 | 5 |
| ☐ | PUT /patients/{id} — actualiza y 204 | 7 |
| ☐ | PUT /patients/{id} — 404 | 5 |
| ☐ | DELETE /patients/{id} — 204 | 3 |
| ☐ | DELETE /patients/{id} — 404 | 3 |
| ☐ | GET /admissions/{id} JOIN triple | 15 |
| ☐ | Tipos canónicos | 11 |
| ☐ | Calidad (alias, Results, using) | 9 |
| ☐ | Git y entrega | 20 |
| | **Total** | **100** |

## Equivalencia con versión A

| Aspecto | Versión A (doctores) | Versión B (pacientes) |
|---|---|---|
| CRUD sobre | doctors | patients |
| Validación | FirstName | FirstName |
| Cantidad de campos entry | 5 | 9 |
| JOIN triple orden | doctors → patients | patients → doctors |
| Dificultad | Equivalente | Equivalente |