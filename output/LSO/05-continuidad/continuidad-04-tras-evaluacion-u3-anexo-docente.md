# Continuidad pedagógica — Anexo docente: Repaso tras evaluación de la Unidad 3

> Documento exclusivo para el docente. Soluciones y criterios de corrección.
> No se entrega a los alumnos ni a la administración.

---

## Soluciones

### Actividad 1 — POST: INSERT con Dapper (20 ptos.)

**Código esperado:**

```csharp
app.MapPost("/patients", (PatientCreateRequest request) =>
{
    if (string.IsNullOrWhiteSpace(request.FirstName) ||
        string.IsNullOrWhiteSpace(request.LastName) ||
        string.IsNullOrWhiteSpace(request.Gender) ||
        string.IsNullOrWhiteSpace(request.BirthDate))
        return Results.BadRequest(new { mensaje = "Faltan campos obligatorios" });

    using var connection = new SqliteConnection(connectionString);
    var sql = @"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, allergies)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @Allergies);
        SELECT last_insert_rowid();";

    long newId = connection.ExecuteScalar<long>(sql, request);

    var createdPatient = connection.QueryFirstOrDefault<Patient>(
        @"SELECT patient_id AS PatientId, first_name AS FirstName, ... FROM patients WHERE patient_id = @id",
        new { id = newId });

    return Results.Created($"/patients/{newId}", createdPatient);
});

// Al final del archivo
record PatientCreateRequest(string FirstName, string LastName, string Gender, string BirthDate,
                           string? City, string? Allergies);
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate,
               string? City, long ProvinceId, string? Allergies, long? Height, long? Weight);
```

- Validación (6 ptos.): debe chequear los cuatro campos obligatorios. Si solo chequea uno o dos, descuento 3 ptos. Si usa `string.IsNullOrEmpty` en lugar de `string.IsNullOrWhiteSpace`, es aceptable (no descuenta).
- `ExecuteScalar<long>` (6 ptos.): si usa `Execute` (que devuelve `int` de filas afectadas) y no obtiene el ID, descuento 4 ptos. Si usa `ExecuteScalar<int>` descuento 2 ptos. por tipo no canónico.
- `Results.Created` (5 ptos.): debe incluir la URL `$"/patients/{newId}"` y los datos del paciente creado. Si solo devuelve `Results.Ok`, descuento 3 ptos.
- Record (3 ptos.): `PatientCreateRequest` con `string?` en City y Allergies. Si usa `string` sin `?`, descuento 1 pto.

### Actividad 2 — DELETE: borrar un paciente (20 ptos.)

**Código esperado:**

```csharp
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    int affected = connection.Execute(
        "DELETE FROM patients WHERE patient_id = @id", new { id });

    return affected == 0
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.NoContent();
});
```

- Ruta `{id:long}` y parámetro `long id` (5 ptos.): si usa `{id:int}` o `int id`, descuento 3 ptos.
- DELETE parametrizado (5 ptos.): debe usar `@id` y `new { id }`. Concatenar descuenta todo el ítem.
- Comprobación de `affected` (5 ptos.): `affected == 0` o `affected < 1` según el caso. Si no comprueba y siempre devuelve `NoContent`, descuento 3 ptos.
- Respuestas HTTP (5 ptos.): `Results.NotFound` cuando affected es 0; `Results.NoContent` cuando affected > 0.

### Actividad 3 — PUT: actualizar un paciente (20 ptos.)

**Código esperado:**

```csharp
app.MapPut("/patients/{id:long}", (long id, PatientCreateRequest request) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existing = connection.QueryFirstOrDefault<Patient>(
        "SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });

    if (existing is null)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    var sql = @"
        UPDATE patients
        SET first_name = @FirstName, last_name = @LastName, gender = @Gender,
            birth_date = @BirthDate, city = @City, allergies = @Allergies
        WHERE patient_id = @Id";

    connection.Execute(sql, new
    {
        request.FirstName, request.LastName, request.Gender,
        request.BirthDate, request.City, request.Allergies,
        Id = id
    });

    return Results.NoContent();
});
```

- Verificación de existencia (6 ptos.): debe ejecutar un `QueryFirstOrDefault` antes del UPDATE. Si intenta actualizar directamente sin verificar, descuento 4 ptos.
- UPDATE parametrizado (6 ptos.): todos los campos SET deben ser parámetros. Si falta un campo, descuento 1 pto. cada uno. Si algún valor está concatenado, descuento 3 ptos.
- `Results.NotFound`/`Results.NoContent` (4 ptos.): `NotFound` si no existe, `NoContent` si se actualiza.
- Body (4 ptos.): debe aceptar `PatientCreateRequest` en el lambda. Si declara un record separado o usa tipos sueltos, es válido mientras funcione.

### Actividad 4 — JOIN triple con filtro (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               a.diagnosis AS Diagnosis,
               a.admission_date AS AdmissionDate
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.doctor_id = d.doctor_id").ToList();

    return Results.Ok(admissions);
});

// Al final del archivo
record AdmissionDetail(long AdmissionId, string PatientName, string DoctorName,
                       string Diagnosis, string AdmissionDate);
```

- JOIN triple (8 ptos.): debe conectar `admissions` con `patients` por `patient_id` y con `doctors` por `doctor_id`. Si falta un JOIN, descuento 4 ptos. Si usa `LEFT JOIN` en lugar de `JOIN` (INNER) es aceptable (no descuenta).
- Alias (5 ptos.): todas las columnas del SELECT deben tener alias AS correspondientes al record. La concatenación `p.first_name || ' ' || p.last_name` debe aliasearse como `PatientName`.
- Record (4 ptos.): `AdmissionDetail` con `long AdmissionId`, `string PatientName`, `string DoctorName`, `string Diagnosis`, `string AdmissionDate`. Si falta una propiedad, descuento 1 pto. cada una.
- `Results.Ok` (3 ptos.): debe devolver la lista envuelta.

### Actividad 5 — Repaso integrador U1+U2 (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/doctors/{id:long}/summary", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctor = connection.QueryFirstOrDefault<Doctor>(
        @"SELECT doctor_id AS DoctorId, first_name AS FirstName,
                  last_name AS LastName, specialty AS Specialty
           FROM doctors WHERE doctor_id = @id", new { id });

    if (doctor is null)
        return Results.NotFound(new { mensaje = "Médico no encontrado" });

    long total = connection.ExecuteScalar<long>(
        "SELECT COUNT(*) FROM admissions WHERE doctor_id = @id", new { id });

    return Results.Ok(new
    {
        doctorId = doctor.DoctorId,
        fullName = $"{doctor.FirstName} {doctor.LastName}",
        specialty = doctor.Specialty,
        totalAdmissions = total
    });
});
```

- Consulta del médico (6 ptos.): `QueryFirstOrDefault<Doctor>` con alias y parámetro. Si usa `Query<Doctor>` sin `FirstOrDefault`, descuento 2 ptos. (no funciona igual cuando no hay médico).
- COUNT (6 ptos.): `ExecuteScalar<long>` (no `int`, no `Execute`). Si usa `int`, descuento 2 ptos.
- Objeto de respuesta (4 ptos.): cuatro propiedades exactas con los nombres en camelCase del ejemplo.
- `Results.NotFound` (4 ptos.): si doctor es null, debe devolverlo con mensaje en español.

---

## Criterios generales de corrección

- **Puntaje total:** 100 puntos.
- **Presentación:** descuento de hasta 5 ptos. si no es manuscrita o es ilegible.
- **Aprobación del repaso:** 60 ptos. o más.
- **Verificación de código:** se espera que el alumno anote al menos un resultado de prueba por actividad con base de datos. Sin eso, descuento 1 pto. por actividad.
- **Grupo:** se permite trabajo grupal. Si dos entregas tienen exactamente el mismo código manuscrito, se cita a defensa oral breve.
- **Uso de computadora obligatorio para las actividades 1 a 4.** Actividad 5 puede resolverse en papel (código sin ejecutar).
- **Convenciones del curso:** cualquier desvío de los tipos canónicos (`int` en PK, `DateTime` en fechas, alias faltantes) se descuenta aunque el código compile teóricamente. El curso tiene una hoja de convenciones técnicas que es fuente única de verdad.