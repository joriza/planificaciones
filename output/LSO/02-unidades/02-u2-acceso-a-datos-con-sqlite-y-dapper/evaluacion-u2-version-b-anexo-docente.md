# Anexo docente — Evaluación U2 Versión B (Doctores y admisiones)

## Solución completa

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — listar todos los doctores
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty
        FROM doctors
        ORDER BY last_name
    ").ToList();
    return Results.Ok(doctors);
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

// GET /doctors/by-specialty/{specialty} — buscar por especialidad con LIKE
app.MapGet("/doctors/by-specialty/{specialty}", (string specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty
        FROM doctors
        WHERE specialty LIKE @patron
        ORDER BY last_name", new { patron = $"%{specialty}%" }).ToList();
    return Results.Ok(doctors);
});

// GET /doctors/with-admissions — doctores con conteo de admisiones
app.MapGet("/doctors/with-admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<DoctorWithAdmissions>(@"
        SELECT d.doctor_id AS DoctorId, d.first_name AS FirstName,
               d.last_name AS LastName, d.specialty AS Specialty,
               COUNT(a.admission_id) AS AdmissionCount
        FROM doctors d
        LEFT JOIN admissions a ON d.doctor_id = a.doctor_id
        GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialty
        ORDER BY d.last_name
    ").ToList();
    return Results.Ok(doctors);
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

app.Run();

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

record DoctorWithAdmissions(long DoctorId, string FirstName, string LastName,
                            string Specialty, long AdmissionCount);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

## Tabla de puntaje

| ✔ | Criterio | Pts |
|---|---|---|
| ☐ | GET /doctors ordenado | 10 |
| ☐ | GET /doctors/{id} — 200 si existe | 5 |
| ☐ | GET /doctors/{id} — 404 si no existe | 5 |
| ☐ | GET /doctors/by-specialty/{specialty} con LIKE | 10 |
| ☐ | GET /doctors/with-admissions con LEFT JOIN y COUNT | 15 |
| ☐ | GET /patients/{id} — 200 si existe | 5 |
| ☐ | GET /patients/{id} — 404 si no existe | 5 |
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

## Equivalencia con versión A

| Aspecto | Versión A | Versión B |
|---|---|---|
| Tabla principal | patients | doctors |
| JOIN con | province_names (INNER) | admissions (LEFT + GROUP) |
| LIKE sobre | last_name | specialty |
| Segunda tabla | doctors | patients |
| Dificultad | Equivalente | Equivalente |
| Puntaje máximo | 100 | 100 |