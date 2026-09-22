# Anexo docente — Encuentro 29: Consolidación CRUD con JOINs

---

## Preguntas guía para la apertura

1. "¿Qué diferencia hay entre un JOIN y hacer dos consultas separadas?"
2. "¿Para qué sirve un LEFT JOIN cuando contamos admisiones por doctor?"
3. "¿Cómo explicarían el flujo de un endpoint GET que devuelve datos de tres tablas?"

---

## Resumen teórico para el pizarrón

- JOIN de 2 tablas: `patients` + `province_names` → paciente con nombre de provincia.
- JOIN de 3 tablas: `admissions` + `doctors` + `patients` → admisión completa.
- Conteo: `COUNT` + `GROUP BY` + `LEFT JOIN` (para no perder filas con cero).
- Flujo Git: `feature/endpoint-joins` → PR → revisión → merge.

---

## Ejemplo de código completo para proyectar y verificar

El `Program.cs` completo del trabajo final hasta este encuentro:

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
    var patients = connection.Query<Patient>("SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName, gender AS Gender, birth_date AS BirthDate, city AS City, province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight FROM patients").ToList();
    return Results.Ok(patients);
});

// GET /patients/{id:long} — obtener uno
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>("SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName, gender AS Gender, birth_date AS BirthDate, city AS City, province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight FROM patients WHERE patient_id = @id", new { id });
    return patient is null ? Results.NotFound(new { mensaje = "Paciente no encontrado" }) : Results.Ok(patient);
});

// GET /patients/with-province — pacientes con nombre de provincia
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query(@"
        SELECT pa.patient_id AS PatientId, pa.first_name AS FirstName,
               pa.last_name AS LastName, pa.gender AS Gender,
               pa.birth_date AS BirthDate, pa.city AS City,
               pa.allergies AS Allergies, pa.height AS Height,
               pa.weight AS Weight, pn.province_name AS ProvinceName
        FROM patients pa
        JOIN province_names pn ON pa.province_id = pn.province_id
    ").ToList();
    return Results.Ok(patients);
});

// GET /patients/count-by-province — conteo por provincia
app.MapGet("/patients/count-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var result = connection.Query(@"
        SELECT pn.province_name AS ProvinceName,
               COUNT(pa.patient_id) AS PatientCount
        FROM province_names pn
        LEFT JOIN patients pa ON pa.province_id = pn.province_id
        GROUP BY pn.province_name
        ORDER BY PatientCount DESC
    ").ToList();
    return Results.Ok(result);
});

// POST /patients — crear paciente
app.MapPost("/patients", (Patient patient) =>
{
    if (string.IsNullOrWhiteSpace(patient.FirstName) || string.IsNullOrWhiteSpace(patient.LastName))
        return Results.BadRequest(new { mensaje = "Nombre y apellido son obligatorios" });
    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid();", patient);
    return Results.Created($"/patients/{newId}", patient);
});

// PUT /patients/{id:long} — actualizar paciente
app.MapPut("/patients/{id:long}", (long id, Patient patient) =>
{
    using var connection = new SqliteConnection(connectionString);
    var existing = connection.QueryFirstOrDefault<Patient>("SELECT patient_id AS PatientId, first_name AS FirstName FROM patients WHERE patient_id = @id", new { id });
    if (existing is null) return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    connection.Execute(@"
        UPDATE patients SET first_name = @FirstName, last_name = @LastName,
            gender = @Gender, birth_date = @BirthDate, city = @City,
            province_id = @ProvinceId, allergies = @Allergies,
            height = @Height, weight = @Weight
        WHERE patient_id = @id",
        new { patient.FirstName, patient.LastName, patient.Gender, patient.BirthDate, patient.City, patient.ProvinceId, patient.Allergies, patient.Height, patient.Weight, id });
    return Results.NoContent();
});

// DELETE /patients/{id:long} — eliminar paciente
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var existing = connection.QueryFirstOrDefault<Patient>("SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });
    if (existing is null) return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });
    return Results.NoContent();
});

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, long ProvinceId, string? Allergies, long? Height, long? Weight);
```

---

## Rúbrica de evaluación del ejercicio independiente

| Criterio | Logrado (2 pts) | En desarrollo (1 pt) | No logrado (0 pts) |
|---|---|---|---|
| Endpoint `GET /doctors/{id:long}` con JOIN | Devuelve datos del doctor + `AdmissionCount` | Devuelve datos sin conteo | Endpoint no implementado |
| Conteo con LEFT JOIN | Usa LEFT JOIN para incluir doctores sin admisiones | Usa JOIN y doctores sin admisiones no aparecen | Sin COUNT ni GROUP BY |
| Prueba con curl o Thunder Client | Endpoint probado y respuesta verificada | Probado pero respuesta incorrecta | Sin probar |
| Integración Git profesional | Rama feature, PR, revisión y merge completos | Rama creada pero sin merge | Sin rama ni PR |

---

## Solución del ejercicio independiente

Endpoint esperado:

```csharp
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault(@"
        SELECT d.doctor_id AS DoctorId,
               d.first_name AS FirstName,
               d.last_name AS LastName,
               d.specialty AS Specialty,
               COUNT(a.id) AS AdmissionCount
        FROM doctors d
        LEFT JOIN admissions a ON a.attending_doctor_id = d.doctor_id
        WHERE d.doctor_id = @id
    ", new { id });
    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
});
```

Respuesta esperada para `GET /doctors/1`:

```json
{
  "doctorId": 1,
  "firstName": "John",
  "lastName": "Smith",
  "specialty": "Cardiology",
  "admissionCount": 42
}
```

---

## Notas para el docente

- El `Program.cs` completo presentado en el anexo es extenso. Proyectarlo en partes: primero los endpoints JOIN, después el CRUD completo. Si algún grupo ya tiene su CRUD propio, solo debe agregar los nuevos endpoints.
- Verificar que todos los grupos tengan el endpoint de conteo (`/patients/count-by-province`) funcionando antes del cierre, porque es el que se usa en el encuentro 30.
- Para grupos lentos, establecer un mínimo: el endpoint `GET /patients/with-province` y el de conteo. El JOIN triple puede quedar como extensión.
- Recordar a los grupos que el trabajo final se defiende en el encuentro 31. El código debe estar completo y probado.