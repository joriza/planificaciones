# Anexo docente — Evaluación U4 Versión A (Proyecto final sobre pacientes)

## Solución completa

El `Program.cs` completo para la versión A (ubicado en `trabajo-final/`):

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

// GET /patients/count-by-province — conteo por provincia
app.MapGet("/patients/count-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var counts = connection.Query<ProvinceCount>(@"
        SELECT pn.province_id AS ProvinceId, pn.province_name AS ProvinceName,
               COUNT(p.patient_id) AS PatientCount
        FROM province_names pn
        LEFT JOIN patients p ON pn.province_id = p.province_id
        GROUP BY pn.province_id, pn.province_name
        ORDER BY pn.province_name").ToList();
    return Results.Ok(counts);
});

// POST /patients — crear paciente
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

// PUT /patients/{id:long} — actualizar paciente
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

// DELETE /patients/{id:long} — eliminar paciente
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });

    if (filas == 0)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    return Results.NoContent();
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

record PatientInput(string FirstName, string LastName, string Gender,
                    string BirthDate, string? City, string ProvinceId,
                    string? Allergies, long? Height, long? Weight);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);

record PatientWithProvince(long PatientId, string FirstName, string LastName, string Gender,
                           string BirthDate, string? City, string ProvinceName, string? Allergies,
                           long? Height, long? Weight);

record ProvinceCount(string ProvinceId, string ProvinceName, long PatientCount);

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

## Tabla de puntaje detallada

| ✔ | Criterio | Pts | Notas |
|---|---|---|---|
| ☐ | GET /patients | 3 | Ordenado por last_name |
| ☐ | GET /patients/{id} — 200 | 2 | |
| ☐ | GET /patients/{id} — 404 | 1 | |
| ☐ | GET /patients/with-province | 4 | JOIN con province_names |
| ☐ | GET /patients/count-by-province | 4 | LEFT JOIN + GROUP BY |
| ☐ | POST /patients — crea y 201 | 3 | |
| ☐ | POST /patients — valida | 2 | 400 si FirstName vacío |
| ☐ | PUT /patients/{id} — actualiza | 2 | 204 |
| ☐ | PUT /patients/{id} — 404 | 2 | |
| ☐ | DELETE /patients/{id} — 204 | 2 | |
| ☐ | DELETE /patients/{id} — 404 | 2 | |
| ☐ | GET /doctors/{id} | 3 | 200 o 404 |
| ☐ | Tipos canónicos | 5 | long, string, ? |
| ☐ | Alias AS | 4 | |
| ☐ | using conexiones | 4 | |
| ☐ | Results.* | 4 | |
| ☐ | Records al final | 3 | |
| ☐ | Issues | 5 | 2+ creados y cerrados |
| ☐ | Ramas feature | 5 | feature/... |
| ☐ | PR con revisión | 5 | 2+ mergeados |
| ☐ | Main protegida | 5 | |
| ☐ | README nombre/desc | 2 | |
| ☐ | README requisitos | 2 | |
| ☐ | README estructura | 2 | |
| ☐ | README tecnologías | 2 | |
| ☐ | README integrantes | 2 | |
| ☐ | Defensa individual | 20 | Aparte |
| | **Total** | **100** | |

## Equivalencia con versión B

| Aspecto | Versión A | Versión B |
|---|---|---|
| Tabla principal CRUD | patients | doctors |
| JOIN con | province_names | admissions (conteo) |
| Segunda tabla | doctors | patients |
| Query string / filtro | Ninguno | ?search= |
| Defensa | Individual, 8+2 min | Individual, 8+2 min |
| Puntaje | 100 | 100 |
| Dificultad | Equivalente | Equivalente |