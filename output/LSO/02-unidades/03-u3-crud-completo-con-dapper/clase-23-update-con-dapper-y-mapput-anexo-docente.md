# Encuentro 23 — Anexo docente: UPDATE con Dapper y MapPut

## Resumen de la clase

| Bloque | Duracion | Actividad |
|---|---|---|
| Apertura y motivacion | 20 min | Analogia del paciente que actualiza sus datos. Repasar DELETE del encuentro anterior. |
| Teoria minima con ejemplo completo | 50 min | Explicar `MapPut`, verificacion con `QueryFirstOrDefault`, UPDATE con `Execute`, `Results.NoContent`. Codificar `PUT /patients/{id:long}`. |
| Ejercicio progresivo | 120 min | Etapa 1: PUT /doctors (guiada, 40 min). Etapa 2: PUT /provinces (semiguiada, 40 min). Etapa 3: PUT /admissions con UPDATE condicional (independiente, 40 min). |
| Puesta en comun y correccion de errores | 30 min | Revisar soluciones, especialmente el armado condicional de Etapa 3. |
| Cierre | 20 min | Takeaway y preview del proximo encuentro (CRUD completo + JOIN triple). |

## Solucion completa del ejemplo

`PUT /patients/{id:long}` completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender, birth_date AS BirthDate,
               city AS City, province_id AS ProvinceId,
               allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients").ToList();
    return Results.Ok(patients);
});

// POST /patients — crear
app.MapPost("/patients", (PatientInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });
    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid() AS NewId;", input);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender, birth_date AS BirthDate,
               city AS City, province_id AS ProvinceId,
               allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id = newId });
    return Results.Created($"/patients/{newId}", patient);
});

// DELETE /patients/{id:long}
app.MapDelete("/patients/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });
    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });
    if (filas == 0)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    return Results.NoContent();
});

// PUT /patients/{id:long}
app.MapPut("/patients/{id:long}", (long id, PatientInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender, birth_date AS BirthDate,
               city AS City, province_id AS ProvinceId,
               allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    connection.Execute(@"
        UPDATE patients SET first_name = @FirstName, last_name = @LastName,
            gender = @Gender, birth_date = @BirthDate, city = @City,
            province_id = @ProvinceId, allergies = @Allergies,
            height = @Height, weight = @Weight
        WHERE patient_id = @Id", new
    {
        input.FirstName, input.LastName, input.Gender, input.BirthDate,
        input.City, input.ProvinceId, input.Allergies, input.Height, input.Weight,
        Id = id
    });

    return Results.NoContent();
});

app.Run();

// --- records al final ---
record PatientInput(string FirstName, string? LastName, string Gender, string BirthDate,
                    string? City, long? ProvinceId, string? Allergies, long? Height, long? Weight);
record Patient(long PatientId, string FirstName, string? LastName, string Gender,
               string BirthDate, string? City, long? ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

## Soluciones del ejercicio progresivo

### Etapa 1 — PUT /doctors/{id:long}

```csharp
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
        WHERE doctor_id = @Id", new
    {
        input.FirstName, input.LastName, input.Specialty, input.Phone, input.Email,
        Id = id
    });

    return Results.NoContent();
});
```

### Etapa 2 — PUT /provinces/{id:long}

```csharp
app.MapPut("/provinces/{id:long}", (long id, ProvinceInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.ProvinceName))
        return Results.BadRequest(new { mensaje = "El nombre de provincia es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var existente = connection.QueryFirstOrDefault<Province>(@"
        SELECT province_id AS ProvinceId, province_name AS ProvinceName
        FROM province_names WHERE province_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Provincia no encontrada" });

    connection.Execute(@"
        UPDATE province_names SET province_name = @ProvinceName
        WHERE province_id = @Id", new { input.ProvinceName, Id = id });

    return Results.NoContent();
});
```

### Etapa 3 — PUT /admissions/{id:long} con UPDATE condicional

```csharp
app.MapPut("/admissions/{id:long}", (long id, AdmissionInput input) =>
{
    if (input.PatientId <= 0)
        return Results.BadRequest(new { mensaje = "El ID del paciente es obligatorio" });
    if (string.IsNullOrWhiteSpace(input.AdmissionDate))
        return Results.BadRequest(new { mensaje = "La fecha de admision es obligatoria" });

    using var connection = new SqliteConnection(connectionString);
    var existente = connection.QueryFirstOrDefault<Admission>(@"
        SELECT admission_id AS AdmissionId, patient_id AS PatientId,
               doctor_id AS DoctorId, admission_date AS AdmissionDate,
               diagnosis AS Diagnosis, discharge_date AS DischargeDate
        FROM admissions WHERE admission_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Admision no encontrada" });

    // Armar UPDATE condicional: solo los campos que no sean null en input
    var sql = "UPDATE admissions SET patient_id = @PatientId, admission_date = @AdmissionDate";
    if (input.DoctorId.HasValue) sql += ", doctor_id = @DoctorId";
    if (input.Diagnosis != null) sql += ", diagnosis = @Diagnosis";
    if (input.DischargeDate != null) sql += ", discharge_date = @DischargeDate";
    sql += " WHERE admission_id = @Id";

    connection.Execute(sql, new
    {
        input.PatientId, input.DoctorId, input.AdmissionDate,
        input.Diagnosis, input.DischargeDate, Id = id
    });

    return Results.NoContent();
});
```

## Errores anticipados y correccion

| Error esperado | Donde aparece | Correccion en clase |
|---|---|---|
| Olvidar `Id = id` en el objeto anonimo | Cualquier PUT | Mostrar que sin `Id`, el UPDATE se ejecuta sin WHERE y afecta todas las filas. |
| No verificar existencia con `QueryFirstOrDefault` | PUT sin `if (existente is null)` | El UPDATE se ejecuta igual y no avisa que el recurso no existe. |
| Devolver `Results.Ok` con el recurso actualizado | PUT sobre BD | El canon dice `204` para operaciones de escritura sobre BD. |
| `int` en vez de `long` en DoctorId / PatientId | Records de entrada | Recordar la tabla de tipos canonicos: INTEGER siempre es `long`. |
| No incluir `?` en campos opcionales | `string?` en campos nulables | Si la columna acepta NULL, el record debe declarar `string?`. |
| Poner `new { id }` en lugar de `new { input.xxx, Id = id }` | Objeto anonimo del UPDATE | El objeto debe incluir tanto los campos del input como el ID con su propio nombre. |