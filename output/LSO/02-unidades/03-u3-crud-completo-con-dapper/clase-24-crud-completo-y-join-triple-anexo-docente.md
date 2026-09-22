# Encuentro 24 — Anexo docente: CRUD completo y JOIN triple

## Resumen de la clase

| Bloque | Duracion | Actividad |
|---|---|---|
| Apertura y motivacion | 20 min | Repaso de los tres verbos de escritura (POST, PUT, DELETE) y la lectura (GET). La meta del dia: CRUD completo sobre admissions + JOIN triple. |
| Teoria minima con ejemplo completo | 50 min | Explicar JOIN triple con alias, record compuesto `AdmissionDetail`. Codificar GET /admissions con JOIN. |
| Ejercicio progresivo | 120 min | Etapa 1: GET /admissions/{id} con JOIN (guiada, 30 min). Etapa 2: CRUD completo POST+PUT+DELETE sobre admissions (semiguiada, 50 min). Etapa 3: GET /patients?search con JOIN a province (independiente, 40 min). |
| Puesta en comun y correccion de errores | 30 min | Revisar soluciones, especialmente los alias en el JOIN triple y el CRUD completo. |
| Cierre | 20 min | Takeaway. Preview del TP-U3 que se entrega en el proximo encuentro. |

## Solucion completa del ejemplo

`Program.cs` completo con CRUD de admissions + GET con JOIN triple:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /admissions — listar con JOIN triple
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admisiones = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName,
               p.patient_id AS PatientId,
               p.first_name AS PatientFirstName,
               p.last_name AS PatientLastName
        FROM admissions a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN patients p ON a.patient_id = p.patient_id
        ORDER BY a.admission_date DESC").ToList();
    return Results.Ok(admisiones);
});

// GET /admissions/{id:long} — una admision con JOIN triple
app.MapGet("/admissions/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admision = connection.QueryFirstOrDefault<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName,
               p.patient_id AS PatientId,
               p.first_name AS PatientFirstName,
               p.last_name AS PatientLastName
        FROM admissions a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN patients p ON a.patient_id = p.patient_id
        WHERE a.admission_id = @id", new { id });

    return admision is null
        ? Results.NotFound(new { mensaje = "Admision no encontrada" })
        : Results.Ok(admision);
});

// POST /admissions
app.MapPost("/admissions", (AdmissionInput input) =>
{
    if (input.PatientId <= 0)
        return Results.BadRequest(new { mensaje = "El ID del paciente es obligatorio" });
    if (string.IsNullOrWhiteSpace(input.AdmissionDate))
        return Results.BadRequest(new { mensaje = "La fecha de admision es obligatoria" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO admissions (patient_id, doctor_id, admission_date, diagnosis, discharge_date)
        VALUES (@PatientId, @DoctorId, @AdmissionDate, @Diagnosis, @DischargeDate);
        SELECT last_insert_rowid() AS NewId;", input);

    var admision = connection.QueryFirstOrDefault<Admission>(@"
        SELECT admission_id AS AdmissionId, patient_id AS PatientId,
               doctor_id AS DoctorId, admission_date AS AdmissionDate,
               diagnosis AS Diagnosis, discharge_date AS DischargeDate
        FROM admissions WHERE admission_id = @id", new { id = newId });

    return Results.Created($"/admissions/{newId}", admision);
});

// PUT /admissions/{id:long}
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

    connection.Execute(@"
        UPDATE admissions SET patient_id = @PatientId, doctor_id = @DoctorId,
            admission_date = @AdmissionDate, diagnosis = @Diagnosis,
            discharge_date = @DischargeDate
        WHERE admission_id = @Id", new
    {
        input.PatientId, input.DoctorId, input.AdmissionDate,
        input.Diagnosis, input.DischargeDate, Id = id
    });

    return Results.NoContent();
});

// DELETE /admissions/{id:long}
app.MapDelete("/admissions/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM admissions WHERE admission_id = @id", new { id });

    if (filas == 0)
        return Results.NotFound(new { mensaje = "Admision no encontrada" });

    return Results.NoContent();
});

app.Run();

// --- records al final ---
record AdmissionInput(long PatientId, long? DoctorId, string AdmissionDate,
                      string? Diagnosis, string? DischargeDate);
record Admission(long AdmissionId, long PatientId, long? DoctorId,
                 string AdmissionDate, string? Diagnosis, string? DischargeDate);
record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       long DoctorId, string DoctorFirstName, string? DoctorLastName,
                       long PatientId, string PatientFirstName, string? PatientLastName);
```

## Soluciones del ejercicio progresivo

### Etapa 3 — GET /patients?search=texto con JOIN a provincia

```csharp
app.MapGet("/patients", (string? search) =>
{
    using var connection = new SqliteConnection(connectionString);

    if (string.IsNullOrWhiteSpace(search))
    {
        var todos = connection.Query<Patient>(@"
            SELECT patient_id AS PatientId, first_name AS FirstName,
                   last_name AS LastName, gender AS Gender, birth_date AS BirthDate,
                   city AS City, province_id AS ProvinceId,
                   allergies AS Allergies, height AS Height, weight AS Weight
            FROM patients").ToList();
        return Results.Ok(todos);
    }

    var pacientes = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               pr.province_name AS ProvinceName,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight
        FROM patients p
        JOIN province_names pr ON p.province_id = pr.province_id
        WHERE p.first_name LIKE @search OR p.last_name LIKE @search", new { search = $"%{search}%" }).ToList();

    return Results.Ok(pacientes);
});

record PatientWithProvince(long PatientId, string FirstName, string? LastName,
                           string Gender, string BirthDate, string? City,
                           string? ProvinceName, string? Allergies,
                           long? Height, long? Weight);
```

## Errores anticipados y correccion

| Error esperado | Donde aparece | Correccion en clase |
|---|---|---|
| Alias duplicado en JOIN triple | `d.first_name` y `p.first_name` sin prefijo | Mostrar que Dapper machaca el primer valor con el segundo. Usar `DoctorFirstName` / `PatientFirstName`. |
| `InvalidOperationException` por nombre de columna | `admission_id AS admissionId` (camelCase en lugar de PascalCase) | El alias debe coincidir con el constructor del record (PascalCase). |
| JOIN sin `ON` | `JOIN doctors` sin condicion | Resultado: producto cartesiano. Mostrar la cantidad de filas erronea. |
| `QueryFirstOrDefault` sin `new { id }` | Parametro faltante | Dapper no puede sustituir `@id` y la consulta falla. |
| Record `AdmissionDetail` antes de `app.Run()` | Error CS8803 | Mover records al final del archivo. |
| `PUT` sin `WHERE admission_id = @Id` | Actualiza todas las filas de la tabla | Mostrar el desastre. Ensenar a siempre verificar el WHERE. |