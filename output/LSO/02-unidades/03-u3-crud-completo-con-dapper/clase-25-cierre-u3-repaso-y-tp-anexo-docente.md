# Anexo docente — Encuentro 25: Cierre U3: repaso y TP

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

El ejercicio independiente de este encuentro es la entrega del TP-U3 en GitHub. La solución de referencia es un repositorio de grupo con la carpeta `tp-u3/` que contiene un `Program.cs` funcional.

**Estructura esperada del repositorio de grupo**:

```
repo-grupo-x/
├── .gitignore
├── tp-u3/
│   └── Program.cs
└── (otros archivos del proyecto)
```

**Contenido esperado de `Program.cs`**:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var connectionString = "Data Source=hospital.db";

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients ORDER BY patient_id"
    ).ToList();
    return Results.Ok(patients);
});

// GET /patients/{id:long} — obtener un paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// POST /patients — crear un paciente nuevo
app.MapPost("/patients", (Patient nuevoPaciente) =>
{
    if (string.IsNullOrWhiteSpace(nuevoPaciente.FirstName) ||
        string.IsNullOrWhiteSpace(nuevoPaciente.LastName))
    {
        return Results.BadRequest(new { mensaje = "El nombre y el apellido son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    long newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid();
    ", nuevoPaciente);

    var pacienteCreado = nuevoPaciente with { PatientId = newId };
    return Results.Created($"/patients/{newId}", pacienteCreado);
});

// PUT /patients/{id:long} — actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, Patient pacienteActualizado) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });

    if (existente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        UPDATE patients
        SET first_name = @FirstName, last_name = @LastName, gender = @Gender,
            city = @City, province_id = @ProvinceId, allergies = @Allergies,
            height = @Height, weight = @Weight
        WHERE patient_id = @id",
        new
        {
            pacienteActualizado.FirstName,
            pacienteActualizado.LastName,
            pacienteActualizado.Gender,
            pacienteActualizado.City,
            pacienteActualizado.ProvinceId,
            pacienteActualizado.Allergies,
            pacienteActualizado.Height,
            pacienteActualizado.Weight,
            id
        });

    return Results.NoContent();
});

// DELETE /patients/{id:long} — borrar un paciente por ID
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var paciente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });

    if (paciente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        DELETE FROM patients WHERE patient_id = @id", new { id });

    return Results.NoContent();
});

// GET /admissions/detail — JOIN de 3 tablas
app.MapGet("/admissions/detail", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.patient_id AS PatientId,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        ORDER BY a.admission_date DESC"
    ).ToList();

    return Results.Ok(admissions);
});

app.Run();

public record Patient(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    string ProvinceId,
    string? Allergies,
    long? Height,
    long? Weight
);

public record AdmissionDetail(
    long PatientId,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty,
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis
);
```

## 2. Solución de la actividad de extensión

### Actividad 1 — Debug de código con errores intencionales

**Código con errores** (para que los alumnos corrijan):

```csharp
// ERROR 1: int en vez de long para el ID
public record Patient(int PatientId, string FirstName, string LastName, string BirthDate);

// ERROR 2: DateTime en vez de string para la fecha
public record Patient(int PatientId, string FirstName, string LastName, DateTime BirthDate);

// ERROR 3: SELECT sin alias AS
var patient = connection.Query<Patient>("SELECT patient_id, first_name, last_name FROM patients WHERE patient_id = @id", new { id });
```

**Correcciones**:

1. Cambiar `int PatientId` a `long PatientId`.
2. Cambiar `DateTime BirthDate` a `string BirthDate`.
3. Agregar alias `AS`: `SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName`.

### Actividad 2 — Preparación de la evaluación individual

Cada alumno debe preparar una mini-charla de 3 minutos que cubra:

1. **Método Dapper por operación**: `Query<T>` para GET many, `QueryFirstOrDefault<T>` para GET one, `ExecuteScalar<long>` para POST, `Execute` para PUT y DELETE.
2. **Códigos HTTP**: `200` (lectura), `201` (alta), `204` (actualización/borrado), `400` (dato faltante), `404` (recurso inexistente).
3. **JOIN de 3 tablas**: se une `admissions` con `patients` y `doctors` usando `JOIN ... ON`. Cada columna del SELECT tiene alias `AS` que coincide con el nombre del parámetro del record.

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada |
| --- | --- |
| TP-U3 entregado en `tp-u3/` | Carpeta `tp-u3/` presente en la rama `main` del repositorio de grupo |
| `Program.cs` compila y corre | El archivo compila con `dotnet build` y los endpoints responden contra `hospital.db` |
| 4 endpoints CRUD funcionales | GET (200), POST (201), PUT (204/404), DELETE (204/404) |
| JOIN de 3 tablas | Endpoint GET que une `admissions`, `patients` y `doctors` con alias `AS` |
| `.gitignore` con `bin/` y `obj/` | Archivo `.gitignore` en la raíz del repositorio |
| Commit con formato correcto | Mensaje en español, sin tildes, con formato `<carpeta>: <resumen>` |

## 4. Criterios de corrección (lista de verificación)

- [ ] La carpeta `tp-u3/` existe en la raíz del repositorio de grupo
- [ ] El `Program.cs` dentro de `tp-u3/` tiene los `using` de Dapper y Sqlite
- [ ] El `Program.cs` tiene `builder`, `app`, los 4 endpoints, `app.Run()`, y los records después
- [ ] Los records usan `long` para IDs (no `int`)
- [ ] Los records usan `string` para fechas (no `DateTime`)
- [ ] Los campos nullable tienen `?` (`string?`, `long?`)
- [ ] Cada endpoint usa `using var connection = new SqliteConnection(connectionString)`
- [ ] Todos los SQL usan parámetros (`@id`, `@FirstName`, etc.) y nunca concatenación
- [ ] El POST usa `ExecuteScalar<long>` y `Results.Created` con código 201
- [ ] El PUT y DELETE validan existencia y devuelven 404 si no existe
- [ ] El PUT y DELETE devuelven `Results.NoContent()` con código 204
- [ ] El endpoint con JOIN de 3 tablas usa `JOIN patients p ON ... JOIN doctors d ON ...`
- [ ] Cada columna del SELECT del JOIN tiene alias `AS`
- [ ] El commit tiene el formato correcto (español, sin tildes, carpeta: resumen)
- [ ] El push se realizó al repositorio remoto

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| No existe la carpeta `tp-u3/` | El grupo creó la carpeta con otro nombre o no creó la carpeta. | Indicar que la carpeta debe llamarse exactamente `tp-u3/` y estar en la raíz del repositorio. |
| El commit tiene tildes o mayúsculas | No se respetó el formato del mensaje de commit. | Recordar: `<carpeta>: <resumen en español, sin tildes, minúsculas después de los dos puntos>`. |
| El `Program.cs` no compila | Falta algún `using` o los records están antes de `app.Run()`. | Agregar `using Dapper;` y `using Microsoft.Data.Sqlite;`. Mover los records después de `app.Run()`. |
| El endpoint POST devuelve `200` | Se usó `Results.Ok()` en vez de `Results.Created()`. | `Results.Created(url, dato)` devuelve `201` con header `Location`. |
| El grupo no puede formarse | La cantidad de presentes no es divisible por los equipos disponibles. | Ajustar el tamaño de los grupos: algunos tendrán un integrante más que otros. |
| El TP-U3 no tiene el JOIN de 3 tablas | El grupo solo implementó los 4 endpoints CRUD sin el JOIN. | Indicar que el TP-U3 requiere al menos un endpoint con JOIN de 3 tablas. |

## 6. Registro de la clase

| Grupo | TP-U3 entregado en tp-u3/ | Program.cs compila | 4 endpoints CRUD funcionales | JOIN de 3 tablas incluido | Commit con formato correcto | Push al repositorio | Observaciones |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | Sí | Sí | Sí | Sí | Sí | Sí | |
| Grupo 2 | Sí | Sí | Sí | No | Sí | Sí | Falta el JOIN de 3 tablas |
| Grupo 3 | No, entregó en carpeta tp3/ | Sí | Sí | Sí | No, tiene tildes | Sí | Carpeta con nombre incorrecto |
| Grupo 4 | Sí | No, falta using | Sí | Sí | Sí | No | Requiere refuerzo en using y push |

**Notas para la evaluación de proceso:** verificar que cada grupo haya realizado el push al repositorio remoto. Evaluar si los alumnos pueden explicar la diferencia entre `ExecuteScalar<long>` y `Execute`. Registrar qué grupos tuvieron errores en el formato del commit o en la estructura de carpetas. Anotar qué alumnos no pudieron formar parte de un grupo y gestionar su reasignación.
