# Anexo docente — Encuentro 29: Consolidación CRUD con JOINs

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Solución: CRUD completo para doctors y admissions

**Endpoints para doctors:**

```csharp
// GET /doctors — listar todos los doctores
app.MapGet("/doctors", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>("SELECT * FROM doctors");
    return Results.Ok(doctors);
});

// GET /doctors/{id:long} — obtener un doctor por ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Buscar doctor por id con consulta parametrizada
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty,
               city AS City,
               province_id AS ProvinceId
        FROM doctors
        WHERE doctor_id = @id", new { id });

    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
});

// POST /doctors — crear un nuevo doctor
app.MapPost("/doctors", (Doctor newDoctor) =>
{
    // Validar que el nombre no venga vacio
    if (string.IsNullOrWhiteSpace(newDoctor.FirstName))
    {
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });
    }

    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Insertar doctor y obtener el id generado
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO doctors (first_name, last_name, specialty, city, province_id)
        VALUES (@FirstName, @LastName, @Specialty, @City, @ProvinceId)",
        newDoctor);

    return Results.Created($"/doctors/{newId}", newDoctor);
});

// PUT /doctors/{id:long} — actualizar un doctor existente
app.MapPut("/doctors/{id:long}", (long id, Doctor updatedDoctor) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Verificar que el doctor existe antes de actualizar
    var existing = connection.QueryFirstOrDefault<Doctor>(
        "SELECT doctor_id FROM doctors WHERE doctor_id = @id", new { id });

    if (existing is null)
    {
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });
    }

    // Ejecutar la actualizacion
    connection.Execute(@"
        UPDATE doctors SET
            first_name = @FirstName,
            last_name = @LastName,
            specialty = @Specialty,
            city = @City,
            province_id = @ProvinceId
        WHERE doctor_id = @id", updatedDoctor);

    return Results.NoContent();
});

// DELETE /doctors/{id:long} — eliminar un doctor
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Ejecutar eliminacion
    var rowsAffected = connection.Execute("DELETE FROM doctors WHERE doctor_id = @id", new { id });

    if (rowsAffected == 0)
    {
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });
    }

    return Results.NoContent();
});

public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty, string City, long ProvinceId);
```

**Endpoints para admissions:**

```csharp
// GET /admissions — listar todas las admisiones
app.MapGet("/admissions", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<Admission>("SELECT * FROM admissions");
    return Results.Ok(admissions);
});

// GET /admissions/{id:long} — obtener una admision por ID
app.MapGet("/admissions/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Buscar admision por id con consulta parametrizada
    var admission = connection.QueryFirstOrDefault<Admission>(@"
        SELECT admission_id AS AdmissionId,
               patient_id AS PatientId,
               doctor_id AS DoctorId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis
        FROM admissions
        WHERE admission_id = @id", new { id });

    return admission is null
        ? Results.NotFound(new { mensaje = "Admisión no encontrada" })
        : Results.Ok(admission);
});

// POST /admissions — crear una nueva admision
app.MapPost("/admissions", (Admission newAdmission) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Insertar admision y obtener el id generado
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO admissions (patient_id, doctor_id, admission_date, discharge_date, diagnosis)
        VALUES (@PatientId, @DoctorId, @AdmissionDate, @DischargeDate, @Diagnosis)",
        newAdmission);

    return Results.Created($"/admissions/{newId}", newAdmission);
});

// PUT /admissions/{id:long} — actualizar una admision existente
app.MapPut("/admissions/{id:long}", (long id, Admission updatedAdmission) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Verificar que la admision existe antes de actualizar
    var existing = connection.QueryFirstOrDefault<Admission>(
        "SELECT admission_id FROM admissions WHERE admission_id = @id", new { id });

    if (existing is null)
    {
        return Results.NotFound(new { mensaje = "Admisión no encontrada" });
    }

    // Ejecutar la actualizacion
    connection.Execute(@"
        UPDATE admissions SET
            patient_id = @PatientId,
            doctor_id = @DoctorId,
            admission_date = @AdmissionDate,
            discharge_date = @DischargeDate,
            diagnosis = @Diagnosis
        WHERE admission_id = @id", updatedAdmission);

    return Results.NoContent();
});

// DELETE /admissions/{id:long} — eliminar una admision
app.MapDelete("/admissions/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Ejecutar eliminacion
    var rowsAffected = connection.Execute("DELETE FROM admissions WHERE admission_id = @id", new { id });

    if (rowsAffected == 0)
    {
        return Results.NotFound(new { mensaje = "Admisión no encontrada" });
    }

    return Results.NoContent();
});

public record Admission(long AdmissionId, long PatientId, long DoctorId, string AdmissionDate, string? DischargeDate, string? Diagnosis);
```

### Solución: JOIN endpoint `/doctors-with-patients`

```csharp
// GET /doctors-with-patients — listar doctores con sus pacientes
app.MapGet("/doctors-with-patients", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Consulta con JOIN entre doctors y patients
    var sql = @"
        SELECT d.doctor_id AS DoctorId,
               d.first_name AS FirstName,
               d.last_name AS LastName,
               d.specialty AS Specialty,
               d.city AS City,
               d.province_id AS ProvinceId,
               p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               p.province_id AS ProvinceId,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight
        FROM doctors d
        LEFT JOIN patients p ON d.doctor_id = p.doctor_id
        ORDER BY d.doctor_id";

    var result = connection.Query<Doctor, Patient, Doctor>(sql, (doctor, patient) =>
    {
        // Agregar el paciente a la lista del doctor
        doctor.Patients ??= new List<Patient>();
        doctor.Patients.Add(patient);
        return doctor;
    }, splitOn: "PatientId");

    // Agrupar por doctor ya que una consulta con JOIN devuelve una fila por paciente
    var grouped = result.GroupBy(d => d.DoctorId).Select(g => g.First());
    return Results.Ok(grouped);
});

public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty, string City, long ProvinceId, List<Patient>? Patients);
public record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, long ProvinceId, string? Allergies, long? Height, long? Weight);
```

## 2. Solución de la actividad de extensión

### Tests de integración básicos

Los tests de integración verifican que los endpoints responden correctamente a solicitudes HTTP reales. Se recomienda usar `WebApplicationFactory` de ASP.NET Core o probar contra la API en ejecución con `HttpClient`.

**Ejemplo de test para GET /patients:**

```csharp
// Test: GET /patients devuelve 200 y una lista de pacientes
// Se ejecuta contra la API en ejecucion en http://localhost:5000
using var client = new HttpClient();
var response = await client.GetAsync("http://localhost:5000/patients");
Assert.Equal(HttpStatusCode.OK, response.StatusCode);
```

**Ejemplo de test para GET /patients/{id:long} con ID inexistente:**

```csharp
// Test: GET /patients/99999 devuelve 404
using var client = new HttpClient();
var response = await client.GetAsync("http://localhost:5000/patients/99999");
Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
```

**Ejemplo de test para POST /patients con datos válidos:**

```csharp
// Test: POST /patients con datos validos devuelve 201
using var client = new HttpClient();
var json = "{ \"firstName\": \"Ana\", \"lastName\": \"Lopez\", \"gender\": \"F\", \"birthDate\": \"1990-01-15\" }";
var content = new StringContent(json, Encoding.UTF8, "application/json");
var response = await client.PostAsync("http://localhost:5000/patients", content);
Assert.Equal(HttpStatusCode.Created, response.StatusCode);
```

**Ejemplo de test para POST /patients con datos faltantes:**

```csharp
// Test: POST /patients con nombre vacio devuelve 400
using var client = new HttpClient();
var json = "{ \"firstName\": \"\", \"lastName\": \"Lopez\" }";
var content = new StringContent(json, Encoding.UTF8, "application/json");
var response = await client.PostAsync("http://localhost:5000/patients", content);
Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
```

## 3. Respuesta esperada del ejercicio

| Endpoint | Método | Código esperado | Cuerpo esperado |
| --- | --- | --- | --- |
| `GET /patients` | GET | 200 | Lista de pacientes |
| `GET /patients/1` | GET | 200 | Paciente con ID 1 |
| `GET /patients/99999` | GET | 404 | `{ "mensaje": "Paciente no encontrado" }` |
| `POST /patients` (válido) | POST | 201 | Paciente creado con ID generado |
| `POST /patients` (nombre vacío) | POST | 400 | `{ "mensaje": "El nombre es obligatorio" }` |
| `PUT /patients/1` (existente) | PUT | 204 | Sin cuerpo |
| `PUT /patients/99999` (inexistente) | PUT | 404 | `{ "mensaje": "Paciente no encontrado" }` |
| `DELETE /patients/1` (existente) | DELETE | 204 | Sin cuerpo |
| `DELETE /patients/99999` (inexistente) | DELETE | 404 | `{ "mensaje": "Paciente no encontrado" }` |
| `GET /patients-with-admissions` | GET | 200 | Lista de pacientes con admisiones |
| `GET /doctors-with-patients` | GET | 200 | Lista de doctores con pacientes |

## 4. Criterios de corrección (lista de verificación)

- ☐ CRUD completo para `patients`, `doctors` y `admissions` (5 endpoints cada uno).
- ☐ Todos los IDs de records usan `long` (nunca `int`).
- ☐ Las fechas en records usan `string` (nunca `DateTime` ni `DateOnly`).
- ☐ Los campos nullable usan `?` (`string?`, `long?`).
- ☐ Todas las consultas usan alias `AS` para mapear snake_case a PascalCase.
- ☐ Todas las consultas están parametrizadas (nunca concatenadas).
- ☐ Las conexiones usan `using var connection` dentro de cada handler.
- ☐ Los records están declarados después de `app.Run()`.
- ☐ Los JOINs usan `splitOn` correctamente y agrupan los resultados.
- ☐ Los tests de integración verifican al menos 5 escenarios (200, 201, 204, 400, 404).

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException` al materializar un record | Usar `int` en lugar de `long` para IDs | Verificar que todos los IDs de tabla usan `long` en el record |
| `InvalidOperationException` por fecha en el record | Usar `DateTime` o `DateOnly` en lugar de `string` | Usar `string BirthDate` en el record y convertir solo al presentar |
| SELECT sin alias `AS` y Dapper no encuentra el constructor | Las columnas snake_case no coinciden con los nombres PascalCase | Usar siempre `SELECT column_name AS PascalName` en cada consulta |
| Concatenar valores al SQL | Práctica antigua o desconocimiento del riesgo | Usar siempre `@param` con `new { param }` en toda consulta |
| Conexión no cerrada | Olvidar el `using` en la declaración | Usar `using var connection = new SqliteConnection(...)` dentro de cada handler |
| Record declarado antes de `app.Run()` | Error CS8803 | Escribir `app.Run();` primero y los records después |
| JOIN devuelve duplicados sin agrupar | No usar `GroupBy` después del JOIN | Explicar que `splitOn` crea objetos separados y hay que agrupar por el padre |
| Test de integración no conecta a la API | API no está corriendo o puerto diferente | Verificar que `dotnet run` está ejecutándose y el puerto es el correcto |

## 6. Registro de la clase

| Grupo | CRUD patients | CRUD doctors | CRUD admissions | JOINs funcionales | Tests de integración | Observaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | | | | | | |
| Grupo 2 | | | | | | |
| Grupo 3 | | | | | | |
| Grupo 4 | | | | | | |

**Notas para evaluación de proceso:** verificar que cada grupo tenga CRUD completo para las 3 tablas, al menos 2 JOINs funcionales y tests de integración básicos. Registrar qué grupos necesitan acompañamiento adicional en tipos canónicos o en parametrización de consultas.
