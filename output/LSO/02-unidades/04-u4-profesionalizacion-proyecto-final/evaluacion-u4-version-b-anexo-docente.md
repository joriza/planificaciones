# Anexo docente — Evaluación U4 Versión B (Proyecto final sobre doctores)

## Solución completa

El `Program.cs` completo para la versión B (ubicado en `trabajo-final/`):

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
        FROM doctors ORDER BY last_name").ToList();
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
        ORDER BY d.last_name").ToList();
    return Results.Ok(doctors);
});

// GET /doctors/search?specialty=texto — buscar por especialidad
app.MapGet("/doctors/search", (string? specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (specialty is null)
    {
        var todos = connection.Query<Doctor>(@"
            SELECT doctor_id AS DoctorId, first_name AS FirstName,
                   last_name AS LastName, specialty AS Specialty,
                   phone AS Phone, email AS Email
            FROM doctors ORDER BY last_name").ToList();
        return Results.Ok(todos);
    }

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors
        WHERE specialty LIKE @patron
        ORDER BY last_name", new { patron = $"%{specialty}%" }).ToList();
    return Results.Ok(doctors);
});

// POST /doctors — crear doctor
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

// PUT /doctors/{id:long} — actualizar doctor
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

// DELETE /doctors/{id:long} — eliminar doctor
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM doctors WHERE doctor_id = @id", new { id });

    if (filas == 0)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    return Results.NoContent();
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

record DoctorInput(string FirstName, string? LastName, string? Specialty,
                   string? Phone, string? Email);

record Doctor(long DoctorId, string FirstName, string? LastName, string? Specialty,
              string? Phone, string? Email);

record DoctorWithAdmissions(long DoctorId, string FirstName, string? LastName,
                            string? Specialty, long AdmissionCount);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

## Tabla de puntaje detallada

| ✔ | Criterio | Pts | Notas |
|---|---|---|---|
| ☐ | GET /doctors ordenado | 3 | |
| ☐ | GET /doctors/{id} — 200 | 2 | |
| ☐ | GET /doctors/{id} — 404 | 1 | |
| ☐ | GET /doctors/with-admissions | 4 | LEFT JOIN + COUNT + GROUP BY |
| ☐ | GET /doctors/search?specialty= | 4 | LIKE, funciona con/sin specialty |
| ☐ | POST /doctors — crea y 201 | 3 | |
| ☐ | POST /doctors — valida | 2 | 400 si FirstName vacío |
| ☐ | PUT /doctors/{id} — actualiza | 2 | 204 |
| ☐ | PUT /doctors/{id} — 404 | 2 | |
| ☐ | DELETE /doctors/{id} — 204 | 2 | |
| ☐ | DELETE /doctors/{id} — 404 | 2 | |
| ☐ | GET /patients/{id} | 3 | 200 o 404 |
| ☐ | Tipos canónicos | 5 | long, string, ? |
| ☐ | Alias AS | 4 | |
| ☐ | using conexiones | 4 | |
| ☐ | Results.* | 4 | |
| ☐ | Records al final | 3 | |
| ☐ | Issues | 5 | 2+ creados y cerrados |
| ☐ | Ramas feature | 5 | |
| ☐ | PR con revisión | 5 | |
| ☐ | Main protegida | 5 | |
| ☐ | README (5 elementos) | 10 | 2 pts c/u |
| ☐ | Defensa individual | 20 | Aparte |
| | **Total** | **100** | |

## Equivalencia con versión A

| Aspecto | Versión A (pacientes) | Versión B (doctores) |
|---|---|---|
| Tabla principal CRUD | patients | doctors |
| JOIN con agregación | count-by-province | with-admissions |
| Búsqueda | Ninguna | ?specialty=LIKE |
| Segunda tabla | doctors | patients |
| Complejidad endpoints | 8 | 8 |
| Git profesional | Issues, ramas, PR, main protegida | Issues, ramas, PR, main protegida |
| Defensa | Individual, 10 min | Individual, 10 min |
| Puntaje máximo | 100 | 100 |

## Preguntas sugeridas para la defensa (todas las versiones)

1. "¿Por qué los IDs se declaran como `long` y no `int`?"
2. "¿Qué hace `ExecuteScalar<long>` en el POST?"
3. "¿Cuál es la diferencia entre `Results.Ok`, `Results.Created` y `Results.NoContent`?"
4. "¿Por qué es obligatorio el alias `AS` en el SELECT?"
5. "¿Qué protege la regla de branch protection en `main`?"
6. "¿Qué pasa si no se cierra la conexión con `using`?"
7. "¿Cuándo usarías LEFT JOIN en lugar de INNER JOIN?"
8. "¿Por qué las fechas son `string` en los records en lugar de `DateTime`?"
9. "¿Cuál es la diferencia entre `Query<T>` y `QueryFirstOrDefault<T>`?"
10. "¿Qué devuelve `Execute` en un DELETE?"