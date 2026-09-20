# Encuentro 21 — Anexo docente: INSERT con Dapper y POST

## Resumen de la clase

| Bloque | Duracion | Actividad |
|---|---|---|
| Apertura y motivacion | 20 min | Charla rapida del recepcionista que da de alta pacientes. Recuperar SELECT parametrizado de U2. |
| Teoria minima con ejemplo completo | 50 min | Explicar POST, `ExecuteScalar<long>`, `Results.Created`. Codificar el ejemplo de `POST /patients` paso a paso. |
| Ejercicio progresivo | 120 min | Etapa 1: POST /doctors (guiada, 40 min). Etapa 2: POST /provinces (semiguiada, 40 min). Etapa 3: POST /admissions (independiente, 40 min). |
| Puesta en comun y correccion de errores | 30 min | Revisar soluciones. Destacar errores del anexo. |
| Cierre | 20 min | Takeaway y preview del proximo encuentro (DELETE). |

## Solucion completa del ejemplo

`POST /patients` (codigo completo para el docente):

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar todos (reposo)
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients").ToList();
    return Results.Ok(patients);
});

// POST /patients — crear nuevo paciente
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
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients WHERE patient_id = @id", new { id = newId });

    return Results.Created($"/patients/{newId}", patient);
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

### Etapa 1 — POST /doctors

```csharp
app.MapPost("/doctors", (DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO doctors (first_name, last_name, specialty, phone, email)
        VALUES (@FirstName, @LastName, @Specialty, @Phone, @Email);
        SELECT last_insert_rowid() AS NewId;", input);

    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty,
               phone AS Phone,
               email AS Email
        FROM doctors WHERE doctor_id = @id", new { id = newId });

    return Results.Created($"/doctors/{newId}", doctor);
});

// record al final
record DoctorInput(string FirstName, string? LastName, string? Specialty, string? Phone, string? Email);
record Doctor(long DoctorId, string FirstName, string? LastName, string? Specialty, string? Phone, string? Email);
```

### Etapa 2 — POST /provinces

```csharp
app.MapPost("/provinces", (ProvinceInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.ProvinceName))
        return Results.BadRequest(new { mensaje = "El nombre de provincia es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO province_names (province_name) VALUES (@ProvinceName);
        SELECT last_insert_rowid() AS NewId;", input);

    var province = connection.QueryFirstOrDefault<Province>(@"
        SELECT province_id AS ProvinceId, province_name AS ProvinceName
        FROM province_names WHERE province_id = @id", new { id = newId });

    return Results.Created($"/provinces/{newId}", province);
});

record ProvinceInput(string ProvinceName);
record Province(long ProvinceId, string ProvinceName);
```

### Etapa 3 — POST /admissions

```csharp
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

    var admission = connection.QueryFirstOrDefault<Admission>(@"
        SELECT admission_id AS AdmissionId,
               patient_id AS PatientId,
               doctor_id AS DoctorId,
               admission_date AS AdmissionDate,
               diagnosis AS Diagnosis,
               discharge_date AS DischargeDate
        FROM admissions WHERE admission_id = @id", new { id = newId });

    return Results.Created($"/admissions/{newId}", admission);
});

record AdmissionInput(long PatientId, long? DoctorId, string AdmissionDate,
                      string? Diagnosis, string? DischargeDate);
record Admission(long AdmissionId, long PatientId, long? DoctorId,
                 string AdmissionDate, string? Diagnosis, string? DischargeDate);
```

## Errores anticipados y correccion

| Error esperado | Donde aparece | Correccion en clase |
|---|---|---|
| Usar `conn.Execute(sql)` en vez de `conn.ExecuteScalar<long>(sql)` | Cualquier POST | `Execute` devuelve filas afectadas, no el ID. Senalar la diferencia. |
| Olvidar `SELECT last_insert_rowid() AS NewId` | INSERT sin la segunda instruccion | Sin esa linea, `ExecuteScalar<long>` devuelve `0`. |
| Record declarado antes de `app.Run()` | Alumno copia el record arriba | Recordar CS8803. Mostrar el error en terminal. |
| `int` en vez de `long` en campos ID | `PatientInput` o `Patient` | Recordar la regla canonica: INTEGER de SQLite = `long` en C#. |
| Falta de alias `AS` en SELECT del readback | SELECT sin `patient_id AS PatientId` | Dapper busca parametro `patient_id` y no encuentra constructor. |
| No validar `FirstName` vacio | POST /patients | Mostrar que SQLite acepta el INSERT y queda un registro sin nombre. |
| Enviar fecha como `DateOnly` en JSON | `birthDate: new Date(...)` en JS | El record espera string ISO. Mostrar la diferencia. |