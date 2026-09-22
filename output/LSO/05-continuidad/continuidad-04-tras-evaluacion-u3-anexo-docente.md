# Anexo docente — Continuidad pedagógica 04: Tras evaluación de U3

## Soluciones

### Actividad 1 — Repaso U1+U2 rápido (10 puntos)

**a) Tipos canónicos:**
- INTEGER → `long` (no `int`). Dapper lee columnas INTEGER de SQLite como `Int64`. Si el record usa `int` (que es `Int32`), el constructor posicional no coincide y se produce `InvalidOperationException`.
- TEXT → `string` (o `string?` si es nullable).

**b) Error sin alias `AS`:**
Dapper busca un constructor cuyos parámetros coincidan con los nombres de columna del resultado. Si la columna se llama `patient_id` (snake_case) y el record tiene `PatientId` (PascalCase), Dapper no encuentra coincidencia y lanza `InvalidOperationException`. El alias `AS PatientId` renombra la columna en el resultado para que coincida.

**c) Códigos de respuesta:**
- `Results.Ok` → 200 OK (lectura exitosa).
- `Results.Created` → 201 Created (recurso creado, incluye URL del nuevo recurso).
- `Results.NotFound` → 404 Not Found (recurso inexistente).
- `Results.NoContent` → 204 No Content (operación exitosa sin cuerpo en la respuesta, típico de DELETE y PUT).

**d) SQL parametrizado:**

```sql
SELECT * FROM patients WHERE city LIKE @city
```

Con parámetro: `new { city = $"%{valor}%" }` (o mejor, `new { city = $"%{valor}%" }`).

**Criterios de corrección:**
- Cada respuesta correcta: 2.5 puntos (total 10 puntos).

---

### Actividad 2 — INSERT/DELETE/UPDATE parametrizados (25 puntos)

**a) POST /patients:**

```csharp
// Alta de un paciente nuevo
app.MapPost("/patients", (Patient patient) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Insertar el paciente y obtener el ID generado
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight)",
        patient);

    // Devolver 201 Created con la URL del nuevo recurso
    return Results.Created($"/patients/{newId}", patient);
});
```

**b) DELETE /patients/{id:long}:**

```csharp
// Eliminar un paciente por ID
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Verificar que el paciente existe antes de eliminar
    var exists = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId
        FROM patients
        WHERE patient_id = @id", new { id });

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    // Eliminar el paciente
    connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    return Results.NoContent();
});
```

**c) PUT /patients/{id:long}:**

```csharp
// Actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, Patient patient) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Verificar que el paciente existe antes de actualizar
    var exists = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId
        FROM patients
        WHERE patient_id = @id", new { id });

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    // Actualizar los datos del paciente
    connection.Execute(@"
        UPDATE patients
        SET first_name = @FirstName,
            last_name = @LastName,
            gender = @Gender,
            birth_date = @BirthDate,
            city = @City,
            province_id = @ProvinceId,
            allergies = @Allergies,
            height = @Height,
            weight = @Weight
        WHERE patient_id = @id",
        new { patient.FirstName, patient.LastName, patient.Gender, patient.BirthDate, patient.City, patient.ProvinceId, patient.Allergies, patient.Height, patient.Weight, id });

    return Results.NoContent();
});
```

**Criterios de corrección:**
- POST con `ExecuteScalar<long>` y `Results.Created`: 6 puntos.
- DELETE con validación de existencia y `Results.NotFound`/`Results.NoContent`: 6 puntos.
- PUT con validación de existencia y `Results.NotFound`/`Results.NoContent`: 6 puntos.
- SQL parametrizado en todas las operaciones: 4 puntos.
- Comentarios en español: 3 puntos.

---

### Actividad 3 — MapPost/MapDelete/MapPut y códigos de respuesta (20 puntos)

**a) POST /doctors:**

```csharp
app.MapPost("/doctors", (Doctor doctor) =>
{
    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO doctors (first_name, last_name, specialty)
        VALUES (@FirstName, @LastName, @Specialty)",
        doctor);

    return Results.Created($"/doctors/{newId}", doctor);
});
```

**b) DELETE /doctors/{id:long}:**

```csharp
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var exists = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId
        FROM doctors
        WHERE doctor_id = @id", new { id });

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "Medico no encontrado" });
    }

    connection.Execute(@"
        DELETE FROM doctors
        WHERE doctor_id = @id", new { id });

    return Results.NoContent();
});
```

**c) Códigos HTTP para DELETE:**
- DELETE exitoso → `204 No Content`. Indica que la operación se completó y no hay contenido para devolver. Es el semánticamente correcto para eliminaciones.
- Recurso no existía → `404 Not Found`. Indica que el cliente intentó eliminar algo que no existe.
- No se devuelve `200 OK` en DELETE exitoso porque `204` es más apropiado semánticamente: la operación tuvo éxito pero no hay cuerpo en la respuesta. `200 OK` implicaría que hay un cuerpo de respuesta, lo cual no es el caso.

**d) NoContent vs Ok en PUT:**
- `Results.NoContent()` → 204. Indica que la actualización fue exitosa y no se devuelve contenido.
- `Results.Ok()` → 200. Indica éxito y devuelve un cuerpo en la respuesta.
- El semánticamente correcto para PUT es `204 NoContent` si no se devuelve el recurso actualizado, o `200 Ok` si se devuelve el recurso actualizado como cuerpo de la respuesta.

**Criterios de corrección:**
- Código POST correcto: 5 puntos.
- Código DELETE correcto: 5 puntos.
- Explicación de códigos HTTP: 5 puntos.
- Diferencia NoContent vs Ok: 5 puntos.

---

### Actividad 4 — Validación de existencia y manejo de errores (15 puntos)

**a) POST /admissions con validación:**

```csharp
app.MapPost("/admissions", (Admission admission) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Validar que el paciente existe
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId
        FROM patients
        WHERE patient_id = @patientId", new { admission.PatientId });

    if (patient is null)
    {
        return Results.BadRequest(new { mensaje = "El paciente con ID " + admission.PatientId + " no existe" });
    }

    // Validar que el medico existe
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId
        FROM doctors
        WHERE doctor_id = @doctorId", new { admission.DoctorId });

    if (doctor is null)
    {
        return Results.BadRequest(new { mensaje = "El medico con ID " + admission.DoctorId + " no existe" });
    }

    // Insertar la admision
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO admissions (patient_id, doctor_id, admission_date, discharge_date)
        VALUES (@PatientId, @DoctorId, @AdmissionDate, @DischargeDate)",
        admission);

    return Results.Created($"/admissions/{newId}", admission);
});
```

**b) Si ambos existen, se inserta y se devuelve `Results.Created`.**

**c) Problema de concurrencia:**
Si dos grupos insertan admisiones para el mismo paciente al mismo tiempo, podrían generarse admisiones duplicadas o inconsistentes. Se mitiga usando transacciones (`connection.Execute` dentro de `connection.BeginTransaction()`) o usando un nivel de aislamiento más estricto en la base de datos. También se puede agregar una restricción UNIQUE en la base de datos si las admisiones duplicadas no están permitidas.

**Criterios de corrección:**
- Validación de existencia de patient_id y doctor_id: 5 puntos.
- `Results.BadRequest` con mensaje en español: 3 puntos.
- INSERT con `ExecuteScalar<long>` y `Results.Created`: 4 puntos.
- Respuesta conceptual sobre concurrencia: 3 puntos.

---

### Actividad 5 — JOIN triple y consultas complejas (20 puntos)

**a) JOIN triple:**

```sql
SELECT p.first_name AS FirstName,
       p.last_name AS LastName,
       d.first_name AS DoctorFirstName,
       d.last_name AS DoctorLastName,
       a.admission_date AS AdmissionDate
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
```

Con Dapper:

```csharp
var results = connection.Query(@"
    SELECT p.first_name AS FirstName,
           p.last_name AS LastName,
           d.first_name AS DoctorFirstName,
           d.last_name AS DoctorLastName,
           a.admission_date AS AdmissionDate
    FROM admissions a
    JOIN patients p ON a.patient_id = p.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id").ToList();
```

**b) Filtrado por specialty:**

```sql
SELECT p.first_name AS FirstName,
       p.last_name AS LastName,
       d.first_name AS DoctorFirstName,
       d.last_name AS DoctorLastName,
       a.admission_date AS AdmissionDate
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE d.specialty = 'Cardiología'
```

**c) Conteo de admisiones por médico:**

```sql
SELECT d.first_name AS DoctorFirstName,
       d.last_name AS DoctorLastName,
       COUNT(*) AS AdmissionCount
FROM admissions a
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY AdmissionCount DESC
```

**d) Si un paciente no tiene admisiones en un INNER JOIN, se pierde de los resultados.** Para incluirlo, se usaría un `LEFT JOIN` (o `LEFT OUTER JOIN`) desde `patients` hacia `admissions`:

```sql
SELECT p.first_name AS FirstName,
       p.last_name AS LastName,
       d.first_name AS DoctorFirstName,
       a.admission_date AS AdmissionDate
FROM patients p
LEFT JOIN admissions a ON p.patient_id = a.patient_id
LEFT JOIN doctors d ON a.doctor_id = d.doctor_id
```

Esto incluye todos los pacientes, incluso los que no tienen admisiones (los campos de admisión y médico serán NULL para esos pacientes).

**Criterios de corrección:**
- JOIN triple correcto con alias `AS`: 5 puntos.
- Filtrado por specialty correcto: 4 puntos.
- Conteo por médico con GROUP BY y ORDER BY: 4 puntos.
- Explicación de LEFT JOIN y por qué se usa: 4 puntos.
- Consultas parametrizadas y sintaxis correcta: 3 puntos.

---

### Actividad 6 — Integración final: CRUD completo (10 puntos)

**Solución completa:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — lista completa de pacientes
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

// GET /patients/{id:long} — un paciente por ID o 404
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
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
        FROM patients
        WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// POST /patients — alta de un paciente nuevo
app.MapPost("/patients", (Patient patient) =>
{
    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight)",
        patient);

    return Results.Created($"/patients/{newId}", patient);
});

// PUT /patients/{id:long} — actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, Patient patient) =>
{
    using var connection = new SqliteConnection(connectionString);
    var exists = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId
        FROM patients
        WHERE patient_id = @id", new { id });

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        UPDATE patients
        SET first_name = @FirstName,
            last_name = @LastName,
            gender = @Gender,
            birth_date = @BirthDate,
            city = @City,
            province_id = @ProvinceId,
            allergies = @Allergies,
            height = @Height,
            weight = @Weight
        WHERE patient_id = @id",
        new { patient.FirstName, patient.LastName, patient.Gender, patient.BirthDate, patient.City, patient.ProvinceId, patient.Allergies, patient.Height, patient.Weight, id });

    return Results.NoContent();
});

// DELETE /patients/{id:long} — eliminar un paciente
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var exists = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId
        FROM patients
        WHERE patient_id = @id", new { id });

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    return Results.NoContent();
});

app.Run();

// Record posicional despues de app.Run()
record Patient(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    long ProvinceId,
    string? Allergies,
    long? Height,
    long? Weight);
```

**Criterios de corrección:**
- Los cinco endpoints funcionan correctamente: 4 puntos.
- Todos los SQL usan alias `AS` y parámetros `@`: 2 puntos.
- Códigos de respuesta correctos (200, 201, 204, 404): 2 puntos.
- Validación de existencia en PUT y DELETE: 1 punto.
- Record `Patient` después de `app.Run()`, tipos canónicos: 1 punto.

---

## Criterios de corrección generales

| Criterio | Ponderación |
|----------|-------------|
| Soluciones de código correctas y compilables | 45% |
| Explicaciones técnicas precisas (SQL, Dapper, HTTP codes) | 25% |
| Cumplimiento de convenciones del curso (tipos, alias, parametrización) | 20% |
| Presentación ordenada y legible | 10% |

La presentación es individual y manuscrita. Los fragmentos de código deben estar transcritos a mano con la misma estructura y comentarios que la solución oficial. Se penaliza la entrega de código que no compile, que omita alias `AS` en consultas Dapper, que concatene valores en consultas SQL, o que no valide la existencia antes de operaciones de escritura.
