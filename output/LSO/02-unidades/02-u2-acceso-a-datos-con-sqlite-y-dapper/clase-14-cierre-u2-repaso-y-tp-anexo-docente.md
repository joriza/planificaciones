# Anexo docente — Encuentro 14: Cierre U2: repaso y TP

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Paso 1 — TP-U2 completo: Program.cs

```csharp
// Program.cs — TP-U2: SQLite y Dapper basico
// Minimal API con C# .NET 6 — Unidad 2

using Dapper;
using Microsoft.Data.Sqlite;

// Cadena de conexion fija: apunta al archivo hospital.db
var connectionString = "Data Source=hospital.db";

// Crear la aplicacion web con Minimal API
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar todos los pacientes
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
        FROM patients
    ").ToList();

    return Results.Ok(patients);
});

// GET /patients/{id:long} — obtener un paciente por su ID
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

// GET /patients-with-province — pacientes con nombre de provincia (JOIN)
app.MapGet("/patients-with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               pn.province_name AS ProvinceName,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.last_name, p.first_name
    ").ToList();

    return Results.Ok(patients);
});

// GET /patients/search — busqueda parcial por nombre
app.MapGet("/patients/search", (string name) =>
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
        FROM patients
        WHERE first_name LIKE @name
           OR last_name LIKE @name
        ORDER BY last_name, first_name
    ", new { name = $"%{name}%" }).ToList();

    return Results.Ok(patients);
});

// GET /doctors — listar todos los medicos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name, first_name
    ").ToList();

    return Results.Ok(doctors);
});

// GET /doctors/by-specialty — medicos por especialidad (LIKE)
app.MapGet("/doctors/by-specialty", (string specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE specialty LIKE @specialty
        ORDER BY last_name, first_name
    ", new { specialty = $"%{specialty}%" }).ToList();

    return Results.Ok(doctors);
});

// Arrancar la aplicacion
app.Run();

// Records posicionales: despues de app.Run() (CS8803)
// INTEGER de SQLite -> long (nunca int)
// TEXT de SQLite -> string
// Columnas nullable llevan ?
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

public record PatientWithProvince(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    string ProvinceName,
    string? Allergies,
    long? Height,
    long? Weight
);

public record Doctor(
    long DoctorId,
    string FirstName,
    string LastName,
    string Specialty
);
```

## 2. Solución de la actividad de extensión

**Paso 1 — Finalizar el TP-U2:** Se espera que cada grupo tenga los 6 endpoints mínimos funcionando y que el proyecto compile sin errores.

**Paso 2 — Preparar la entrega:** Se espera que la carpeta `tp-u2/` esté en el repositorio del grupo con los archivos del proyecto, `hospital.db` (o en `.gitignore` según la convención del grupo), y que el commit y push se hayan realizado correctamente.

**Paso 3 — Preparación para la defensa individual:** Cada alumno debe poder explicar los conceptos clave de la unidad y justificar las decisiones de diseño (por qué `long` y no `int`, por qué `AS`, por qué parametrizar, etc.).

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Verificación |
| --- | --- | --- |
| TP-U2 compila sin errores | `dotnet build` sin errores ni advertencias | Ejecutar `dotnet build` en la carpeta `tp-u2/` |
| `GET /patients` devuelve pacientes | Array de 258 objetos | Navegar al endpoint y verificar la cantidad |
| `GET /patients/{id:long}` devuelve un paciente | Objeto con los datos del paciente | Verificar con id=1 |
| `GET /patients-with-province` devuelve JOIN | Array de pacientes con `provinceName` | Verificar que todos tengan `provinceName` |
| `GET /patients/search?name=Don` devuelve coincidencias | Array con pacientes cuyo nombre contiene "Don" | Verificar que todos los resultados coinciden |
| `GET /doctors` devuelve médicos | Array de 27 objetos | Verificar la cantidad |
| `GET /doctors/by-specialty?specialty=Card` devuelve coincidencias | Array de médicos con especialidad que contiene "Card" | Verificar que todos los resultados coinciden |
| El commit tiene mensaje en español, minúsculas, sin tildes | `git log -1` muestra mensaje correcto | Verificar el último commit |
| La carpeta `tp-u2/` está en el repositorio | `git ls-files` muestra los archivos | Verificar en el repo remoto |

## 4. Criterios de corrección (lista de verificación)

- [ ] La carpeta `tp-u2/` existe en el repositorio del grupo.
- [ ] El archivo `Program.cs` compila sin errores ni advertencias.
- [ ] Se usa `using Dapper;` y `using Microsoft.Data.Sqlite;` al inicio.
- [ ] La cadena de conexión es `"Data Source=hospital.db"`.
- [ ] Cada endpoint abre la conexión con `using var connection = new SqliteConnection(...)`.
- [ ] Todas las consultas usan alias `AS` para mapear columnas snake_case a PascalCase.
- [ ] Los records usan `long` para columnas INTEGER (no `int`).
- [ ] Los campos nullable llevan `?` (`string?`, `long?`).
- [ ] Los records están declarados después de `app.Run();`.
- [ ] Los endpoints devuelven `Results.Ok(...)`, `Results.NotFound(...)` o `Results.BadRequest(...)` (nunca el objeto crudo).
- [ ] Los comentarios en el código están en español y no contienen tildes ni eñes.
- [ ] Los parámetros se pasan con objetos anónimos `new { ... }` y nunca se concatenan en el SQL.
- [ ] `LIKE` usa comodines `%` envueltos en el objeto anónimo (`$"%{valor}%"`).
- [ ] El commit tiene mensaje en español, minúsculas después de los dos puntos, sin tildes.
- [ ] El push llegó al repositorio remoto.
- [ ] El alumno puede explicar cada endpoint y cada decisión de diseño en la defensa individual.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException` al ejecutar un endpoint | El record usa `int` en vez de `long` para una columna INTEGER. | Indicar que SQLite INTEGER siempre devuelve `Int64` (long). |
| `InvalidOperationException` por falta de alias | Falta `AS` en el SELECT; Dapper busca `patient_id` pero el record tiene `PatientId`. | Mostrar que cada columna necesita `AS NombrePropiedad` que coincida exactamente. |
| La lista devuelve 0 pacientes | `hospital.db` no está en la carpeta correcta del proyecto. | Verificar que `hospital.db` esté en la raíz del proyecto y que la cadena de conexión sea `"Data Source=hospital.db"`. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |
| El endpoint devuelve el objeto crudo sin `Results` | Se devolvió el objeto directamente en vez de envolverlo con `Results.Ok(...)`. | Recordar que siempre se debe envolver la respuesta con `Results.Ok()`, `Results.NotFound()`, etc. |
| El commit tiene tildes o mayúsculas | No se siguió la convención del curso. | Indicar que los mensajes deben estar en minúsculas después de los dos puntos y sin tildes. |
| La carpeta `tp-u2/` no está en el repo | No se creó la carpeta o no se hizo `git add .`. | Recordar la secuencia completa: crear carpeta → copiar archivos → `git add .` → `git commit` → `git push`. |
| `null` aparece como cadena vacía en el JSON | La propiedad nullable no lleva `?` en la declaración del record. | Declarar como `string?` o `long?` según el tipo canónico. |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Repaso de conceptos | Observar si los alumnos pueden enumerar los conceptos clave de la unidad sin ayuda. |
| Completitud del TP-U2 | Verificar que cada grupo tenga los 6 endpoints mínimos funcionando. |
| Calidad del commit | Registrar si los mensajes de commit siguen la convención del curso (español, minúsculas, sin tildes). |
| Push al remoto | Verificar que cada grupo haya hecho push correctamente al repositorio remoto. |
| Defensa individual | Anotar qué alumnos pueden explicar cada endpoint y qué alumnos necesitan más apoyo. |
| Errores frecuentes en el TP | Documentar los errores más comunes encontrados en los TP para ajustar la retroalimentación de la evaluación. |
| Distribución de equipos | Registrar la composición de cada grupo y la cantidad de presentes para calcular el tamaño de los equipos. |
