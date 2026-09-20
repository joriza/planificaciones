# Continuidad pedagógica — Anexo docente: Repaso tras evaluación de la Unidad 2

> Documento exclusivo para el docente. Soluciones y criterios de corrección.
> No se entrega a los alumnos ni a la administración.

---

## Soluciones

### Actividad 1 — Conexión y SELECT simple (20 ptos.)

**Código esperado:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var connectionString = "Data Source=hospital.db";

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

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate,
               string? City, long ProvinceId, string? Allergies, long? Height, long? Weight);
```

- Conexión (5 ptos.): `var connectionString = ...` fuera del endpoint (4 ptos.) o dentro (5 ptos.). Sin `using` en la conexión → 0 ptos.
- SELECT con alias (6 ptos.): debe tener alias AS para todas las columnas. Si omite una sola, descuento 1 pto. cada una. Si escribe `SELECT *` sin alias, descuento 6 ptos.
- Record (6 ptos.): cada tipo incorrecto descuenta 1 pto. (por ejemplo, `int PatientId` en lugar de `long` son -2 ptos.; `DateTime BirthDate` en lugar de `string` son -2 ptos.).
- `Results.Ok` (3 ptos.): debe estar presente; si falta se asignan 0 ptos.

### Actividad 2 — Filtro WHERE con parámetro (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});
```

Se acepta que el SELECT sea más corto (solo las columnas necesarias siempre que mantenga los alias).

- Ruta `{id:long}` (6 ptos.): si usa `{id:int}` son -4 ptos. por violar la convención del curso.
- Consulta parametrizada (6 ptos.): debe usar `@id` y `new { id }`. Si concatena `$"WHERE patient_id = {id}"` son 0 ptos. en este ítem.
- `Results.NotFound` (4 ptos.): acepta cualquier mensaje en español; si el mensaje está en inglés se descuentan 2 ptos.
- Mensaje en español (4 ptos.): asignado solo si está presente.

### Actividad 3 — JOIN entre dos tablas (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty
        FROM doctors").ToList();
    return Results.Ok(doctors);
});

app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @id", new { id });

    return doctor is null
        ? Results.NotFound(new { mensaje = "Médico no encontrado" })
        : Results.Ok(doctor);
});

app.Run();

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

- Endpoint GET /doctors (8 ptos.): SELECT completo con alias, devolución con `Results.Ok`.
- Endpoint GET /doctors/{id:long} (8 ptos.): filtro parametrizado, manejo de 404.
- Record (4 ptos.): `long DoctorId` (no `int`), `string` en las tres propiedades restantes.

### Actividad 4 — LIKE con parámetro (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/patients/search", (HttpContext context) =>
{
    var term = context.Request.Query["term"];

    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients
        WHERE last_name LIKE '%' || @term || '%'", new { term }).ToList();

    return Results.Ok(patients);
});
```

- Lectura de `term` (6 ptos.): puede usar `context.Request.Query["term"]` o recibir `string term` como parámetro directo en el lambda (ASP.NET lo vincula desde la query string automáticamente). Cualquiera de las dos es válida.
- LIKE parametrizado (8 ptos.): debe usar `@term` como parámetro. Si el LIKE se escribe como `$"LIKE '%{term}%'"` concatenando, es 0 ptos. en este ítem (riesgo de inyección SQL además de violar la regla del curso).
- Devolución (6 ptos.): `Results.Ok(patients)`. Si devuelve la lista sin envolver, descuento 3 ptos.

**Nota:** el uso de concatenación con `||` es específico de SQLite y es seguro porque `term` llega como parámetro, no como texto literal.

### Actividad 5 — Repaso integrador Unidad 1 (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/resumen", () =>
{
    var unidades = new List<string>
    {
        "U1: Fundamentos de C# y Minimal API",
        "U2: Acceso a datos con SQLite y Dapper"
    };

    int total = 0;
    for (int i = 0; i < 4; i++)
        total++;

    return Results.Ok(new
    {
        materia = "Minimal API con C# .NET 6",
        unidadesVistas = unidades,
        totalEndpointsCreados = total
    });
});
```

- Objeto JSON (8 ptos.): tres propiedades exactas. Si el nombre de una propiedad está mal escrito (por ejemplo, `total_endpoints` en lugar de `totalEndpointsCreados`), descuento 2 ptos. cada una.
- Bucle `for` (8 ptos.): debe usar `for` con un contador. Si el resultado no es 4 (por ejemplo, `i < 3` en lugar de `i < 4`), descuento 4 ptos.
- `Results.Ok` (4 ptos.): si falta o devuelve otro tipo, 0 ptos.

---

## Criterios generales de corrección

- **Puntaje total:** 100 puntos.
- **Presentación:** descuento de hasta 5 ptos. si no es manuscrita.
- **Aprobación del repaso:** 60 ptos. o más.
- **Verificación de ejecución:** se espera que el alumno anote al menos un resultado de una prueba (p. ej., «Probé con curl y devolvió la lista de pacientes»). Sin eso, se descuenta 1 pto. por actividad.
- **Grupo:** se permite trabajo grupal; entrega individual manuscrita. Textos idénticos entre alumnos se verifican con defensa oral.
- **Uso de computadora obligatorio para las actividades 1 a 4.** Si el alumno no tiene acceso, se acuerda una resolución asistida en el próximo encuentro. La Actividad 5 puede resolverse en papel (solo código, sin ejecución).