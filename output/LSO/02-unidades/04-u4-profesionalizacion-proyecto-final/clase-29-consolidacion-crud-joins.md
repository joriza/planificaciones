# Encuentro 29 — Consolidación CRUD con JOINs

> Profesionalización y proyecto final

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 29 de 36 |
| Unidad | 4 — Profesionalización y proyecto final |
| Eje temático | 6 — Profesionalización y control de versiones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Consolidación CRUD con JOINs |
| Requisitos previos | Encuentro 28: README de portada y issues creados; flujo de ramas y PRs configurado |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de trabajo (presentes ÷ equipos disponibles); cada grupo opera su propio repositorio |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Consolidar el CRUD completo (GET, POST, PUT, DELETE) sobre `hospital.db` usando Dapper.
2. Escribir consultas con JOINs que relacionen `patients`, `doctors`, `provinces` y `admissions`.
3. Aplicar los tipos canónicos del curso: `long` para INTEGER, `string` para fechas, `?` para campos nullable.
4. Mantener los endpoints parametrizados y seguros contra inyección SQL.

## 3. Apertura y motivación (20 min)

### Charla rápida

Cuando un paciente llega al hospital, no basta con saber su nombre: necesitamos saber qué doctor lo atiende, en qué provincia está, y si tiene admisiones previas. En una API real, los datos viven en varias tablas conectadas entre sí. Los JOINs son la herramienta que permite traer toda esa información junta en una sola consulta. Hoy van a consolidar el CRUD completo y van a construir endpoints que conecten las tablas de `hospital.db`.

### Puente desde el trabajo anterior

En los encuentros anteriores, cada grupo tiene su repositorio con README de portada, issues organizados y flujo profesional de ramas y PRs. Ahora toca poner la API a funcionar con la base de datos real: CRUD completo sobre `hospital.db` y endpoints que usen JOINs para mostrar datos relacionados.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 — CRUD completo sobre hospital.db (40 min)

El CRUD completo significa que cada tabla de la base de datos tiene endpoints para leer, crear, actualizar y eliminar registros. Siguiendo las convenciones del curso, todo el código vive en un único archivo `Program.cs` y se accede a la base con Dapper.

**Convenciones canónicas a respetar:**

| Regla | Detalle |
| --- | --- |
| Tipos de ID | Siempre `long` (nunca `int`) para claves primarias INTEGER de SQLite |
| Fechas | Siempre `string` en el record, formato ISO `yyyy-MM-dd` |
| Campos nullable | `string?` para TEXT nullable, `long?` para INTEGER nullable |
| Consultas | Siempre parametrizadas con `@id` y `new { id }` |
| Respuestas | Siempre con `Results.Ok()`, `Results.Created()`, `Results.NoContent()`, `Results.BadRequest()`, `Results.NotFound()` |
| Records | Siempre al final del archivo, después de `app.Run()` |

**Esqueleto canónico de Program.cs:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// --- ENDPOINTS DE PACIENTES ---

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>("SELECT * FROM patients");
    return Results.Ok(patients);
});

// GET /patients/{id:long} — obtener un paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Buscar paciente por id con consulta parametrizada
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

// POST /patients — crear un nuevo paciente
app.MapPost("/patients", (Patient newPatient) =>
{
    // Validar que el nombre no venga vacio
    if (string.IsNullOrWhiteSpace(newPatient.FirstName))
    {
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });
    }

    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Insertar paciente y obtener el id generado
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight)",
        newPatient);

    return Results.Created($"/patients/{newId}", newPatient);
});

// PUT /patients/{id:long} — actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, Patient updatedPatient) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Verificar que el paciente existe antes de actualizar
    var existing = connection.QueryFirstOrDefault<Patient>(
        "SELECT patient_id FROM patients WHERE patient_id = @id", new { id });

    if (existing is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    // Ejecutar la actualizacion
    connection.Execute(@"
        UPDATE patients SET
            first_name = @FirstName,
            last_name = @LastName,
            gender = @Gender,
            birth_date = @BirthDate,
            city = @City,
            province_id = @ProvinceId,
            allergies = @Allergies,
            height = @Height,
            weight = @Weight
        WHERE patient_id = @id", updatedPatient);

    return Results.NoContent();
});

// DELETE /patients/{id:long} — eliminar un paciente
app.MapDelete("/patients/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Ejecutar eliminacion
    var rowsAffected = connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });

    if (rowsAffected == 0)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    return Results.NoContent();
});

// Record posicional al final, despues de app.Run()
public record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, long ProvinceId, string? Allergies, long? Height, long? Weight);

app.Run();
```

**Práctica guiada:**

El docente muestra el CRUD completo de pacientes y explica cada parte:
- La conexión se abre con `using var connection` dentro de cada handler.
- Las consultas usan siempre `@id` con `new { id }` (nunca concatenar).
- Los records usan `long` para IDs y `string` para fechas.
- Los campos nullable llevan `?` (`string?`, `long?`).

**Ejercicio independiente:**

Cada grupo completa el CRUD completo para las tablas `doctors` y `admissions` siguiendo el mismo patrón:
- `GET /doctors`, `GET /doctors/{id:long}`, `POST /doctors`, `PUT /doctors/{id:long}`, `DELETE /doctors/{id:long}`
- `GET /admissions`, `GET /admissions/{id:long}`, `POST /admissions`, `PUT /admissions/{id:long}`, `DELETE /admissions/{id:long}`

### 4.2 — JOINs en los endpoints (40 min)

Los JOINs permiten combinar datos de varias tablas en una sola consulta. En el contexto del hospital, los casos más frecuentes son:

- **Pacientes con sus admisiones:** un paciente puede tener múltiples admisiones.
- **Doctores con sus pacientes:** un doctor atiende a varios pacientes.
- **Admisiones con datos completos:** mostrar una admisión incluyendo el nombre del paciente y del doctor.

**Patrón canónico para JOINs:**

```csharp
// GET /patients-with-admissions — listar pacientes con sus admisiones
app.MapGet("/patients-with-admissions", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    // Consulta con JOIN entre patients y admissions
    var sql = @"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               p.province_id AS ProvinceId,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight,
               a.admission_id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis
        FROM patients p
        INNER JOIN admissions a ON p.patient_id = a.patient_id
        ORDER BY p.patient_id";

    var result = connection.Query<Patient, Admission, Patient>(sql, (patient, admission) =>
    {
        // Agregar la admision a la lista del paciente
        patient.Admissions ??= new List<Admission>();
        patient.Admissions.Add(admission);
        return patient;
    }, splitOn: "AdmissionId");

    // Agrupar por paciente ya que una consulta con JOIN devuelve una fila por admision
    var grouped = result.GroupBy(p => p.PatientId).Select(g => g.First());
    return Results.Ok(grouped);
});

public record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, long ProvinceId, string? Allergies, long? Height, long? Weight, List<Admission>? Admissions);
public record Admission(long AdmissionId, long PatientId, long DoctorId, string AdmissionDate, string? DischargeDate, string? Diagnosis);
```

**Nota sobre tipos canónicos:** las columnas INTEGER de SQLite se mapean como `long` en C#. Las columnas TEXT nullable se mapean como `string?`. Siempre se usa alias `AS` en el SELECT con el nombre exacto del parámetro del constructor del record.

**Práctica guiada:**

El docente muestra cómo construir un JOIN entre `patients` y `admissions`, explicando:
- El uso de `splitOn` para indicar dónde Dapper debe separar los objetos.
- La necesidad de agrupar los resultados por paciente.
- El uso de `List<Admission>?` para la propiedad de navegación.

**Ejercicio independiente:**

Cada grupo construye un endpoint `/doctors-with-patients` que muestre cada doctor con la lista de pacientes que atiende, usando un JOIN entre `doctors` y `patients`.

### 4.3 — Verificación contra hospital.db (40 min)

Una vez que el CRUD y los JOINs están implementados, cada grupo verifica que todo funcione contra la base de datos real `hospital.db`.

**Práctica guiada:**

El docente muestra cómo verificar:
1. Ejecutar `dotnet run` y confirmar que la API arranca sin errores.
2. Probar cada endpoint con `curl` o Thunder Client:
   - `curl http://localhost:5000/patients` → lista de pacientes.
   - `curl http://localhost:5000/patients/1` → paciente con ID 1.
   - `curl http://localhost:5000/patients-with-admissions` → pacientes con sus admisiones.
3. Probar errores:
   - `curl http://localhost:5000/patients/99999` → 404 con mensaje.
   - `curl -X POST http://localhost:5000/patients -H "Content-Type: application/json" -d '{"firstName":""}'` → 400 con mensaje.

**Ejercicio independiente:**

Cada grupo prueba todos sus endpoints y verifica que los códigos HTTP coinciden con lo esperado (200, 201, 204, 400, 404).

## 5. Consolidación y cierre (20 min)

Revisión de los CRUD completos y JOINs:

- ¿Cada tabla tiene sus 5 endpoints (GET list, GET by id, POST, PUT, DELETE)?
- ¿Los JOINs devuelven datos relacionados correctamente?
- ¿Los tipos canónicos se respetan (`long` para IDs, `string` para fechas, `?` para nullable)?
- ¿Las consultas están parametrizadas (nunca concatenadas)?

El docente verifica en pantalla los endpoints de cada grupo y confirma que los tipos y los JOINs funcionan correctamente.

## 6. Actividad complementaria (80 min)

### Trabajo en grupo: CRUD completo + JOINs + Tests de integración básicos

Cada grupo completa las siguientes tareas:

1. **CRUD completo para las 3 tablas** (25 min): verificar que `patients`, `doctors` y `admissions` tienen los 5 endpoints cada una y que funcionan contra `hospital.db`.
2. **JOINs funcionales** (20 min): implementar al menos 2 endpoints con JOINs y verificar que devuelven datos relacionados correctamente.
3. **Tests de integración básicos** (35 min): la extensión de esta unidad son tests de integración básicos con la API. Cada grupo escribe tests que:
   - Verifican que `GET /patients` devuelve 200.
   - Verifican que `GET /patients/{id:long}` con un ID existente devuelve 200.
   - Verifican que `GET /patients/{id:long}` con un ID inexistente devuelve 404.
   - Verifican que `POST /patients` con datos válidos devuelve 201.
   - Verifican que `POST /patients` con datos faltantes devuelve 400.

Los tests se escriben en un archivo separado o como parte de la actividad complementaria, sin modificar `Program.cs`. La extensión justifica los 80 minutos de actividad complementaria con la práctica de integración completa.

## 7. Cierre (15 min)

### Qué te llevás

- El CRUD completo sobre `hospital.db` sigue las convenciones canónicas: tipos `long` para IDs, `string` para fechas, `?` para nullable, consultas siempre parametrizadas.
- Los JOINs permiten relacionar datos de varias tablas en un solo endpoint.
- Los tests de integración verifican que la API responde correctamente a solicitudes reales.
- Todo el código vive en `Program.cs` con records posicionales al final.

## Lo que viene

Encuentro 30: Avance trabajo final — van a planificar el trabajo final y a avanzar con commits por feature en su flujo profesional de Git.

## 8. Errores comunes y trampas

| ✔ | Error | Causa probable | Intervención |
| --- | --- | --- | --- |
| ☐ | `InvalidOperationException` al materializar un record | Usar `int` en lugar de `long` para el ID del record | Verificar que todos los IDs de tabla usan `long` en el record, nunca `int` |
| ☐ | `InvalidOperationException` por fecha en el record | Usar `DateTime` o `DateOnly` en lugar de `string` | Usar `string BirthDate` en el record y convertir solo al presentar |
| ☐ | SELECT sin alias `AS` y Dapper no encuentra el constructor | Las columnas snake_case no coinciden con los nombres PascalCase del record | Usar siempre `SELECT column_name AS PascalName` en cada consulta |
| ☐ | Concatenar valores al SQL en lugar de usar parámetro | Práctica antigua o desconocimiento del riesgo | Usar siempre `@param` con `new { param }` en toda consulta |
| ☐ | Conexión no cerrada | Olvidar el `using` en la declaración de la conexión | Usar `using var connection = new SqliteConnection(...)` dentro de cada handler |
| ☐ | Record declarado antes de `app.Run()` | Error CS8803: las top-level statements deben preceder a las declaraciones de tipos | Escribir `app.Run();` primero y los records después |
