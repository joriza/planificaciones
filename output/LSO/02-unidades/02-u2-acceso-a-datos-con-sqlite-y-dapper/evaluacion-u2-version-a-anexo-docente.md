# Anexo docente — Evaluación U2 Versión A (Pacientes y provincias)

## Solución completa

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients
        ORDER BY last_name
    ").ToList();
    return Results.Ok(patients);
});

// GET /patients/{id:long} — buscar paciente por ID
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

// GET /patients/by-name/{lastName} — buscar por apellido con LIKE
app.MapGet("/patients/by-name/{lastName}", (string lastName) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients
        WHERE last_name LIKE @patron
        ORDER BY last_name", new { patron = $"%{lastName}%" }).ToList();
    return Results.Ok(patients);
});

// GET /patients/with-province — pacientes con nombre de provincia
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId, p.first_name AS FirstName,
               p.last_name AS LastName, p.gender AS Gender,
               p.birth_date AS BirthDate, p.city AS City,
               pn.province_name AS ProvinceName, p.allergies AS Allergies,
               p.height AS Height, p.weight AS Weight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.last_name, p.first_name").ToList();
    return Results.Ok(patients);
});

// GET /doctors/{id:long} — buscar doctor por ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty
        FROM doctors WHERE doctor_id = @id", new { id });
    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
});

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);

record PatientWithProvince(long PatientId, string FirstName, string LastName, string Gender,
                           string BirthDate, string? City, string ProvinceName, string? Allergies,
                           long? Height, long? Weight);

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

## Tabla de puntaje

| ✔ | Criterio | Pts |
|---|---|---|
| ☐ | GET /patients ordenado | 10 |
| ☐ | GET /patients/{id} — 200 si existe | 5 |
| ☐ | GET /patients/{id} — 404 si no existe | 5 |
| ☐ | GET /patients/by-name/{lastName} con LIKE | 10 |
| ☐ | GET /patients/with-province con JOIN | 15 |
| ☐ | GET /doctors/{id} — 200 si existe | 5 |
| ☐ | GET /doctors/{id} — 404 si no existe | 5 |
| ☐ | IDs como `long` | 5 |
| ☐ | Fechas como `string` | 5 |
| ☐ | Nulables con `?` | 5 |
| ☐ | Alias AS en todas las columnas | 5 |
| ☐ | Consultas parametrizadas | 5 |
| ☐ | Records después de `app.Run()` | 5 |
| ☐ | Carpeta `tp-u2/` | 5 |
| ☐ | `.gitignore` | 5 |
| ☐ | Commit semántico | 5 |
| ☐ | Push exitoso | 5 |
| | **Total** | **100** |

## Equivalencia con versión B

| Aspecto | Versión A | Versión B |
|---|---|---|
| Tabla principal | patients | doctors |
| JOIN con | province_names | admissions |
| Segunda tabla | doctors | patients |
| LIKE sobre | last_name | specialty |
| Dificultad | Equivalente | Equivalente |