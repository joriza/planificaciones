# Anexo docente — Continuidad pedagógica 03: Tras evaluación de U2

## Soluciones

### Actividad 1 — Repaso tipos y control de flujo de U1 (10 puntos)

**Solución:**

```csharp
// Clasificar paciente segun IMC aproximado
string ClassifyPatient(long? height, long? weight)
{
    // Verificar si faltan datos
    if (!height.HasValue || !weight.HasValue)
    {
        return "Datos incompletos";
    }

    // Verificar si los datos son validos
    if (height <= 0 || weight <= 0)
    {
        return "Datos invalidos";
    }

    // Calcular IMC aproximado: peso(gramos) / altura(cm)^2 * 10000
    long imcTimes1000 = weight * 10000 / (height * height);

    // Clasificar segun el IMC
    if (imcTimes1000 < 18500) // IMC < 18.5
    {
        return "Bajo peso";
    }
    else if (imcTimes1000 < 25000) // IMC < 25
    {
        return "Normal";
    }
    else if (imcTimes1000 < 30000) // IMC < 30
    {
        return "Sobrepeso";
    }
    else
    {
        return "Obesidad";
    }
}
```

**Pruebas:**
a) height = 175, weight = 75000 → `75000 * 10000 / (175 * 175)` = `750000000 / 30625` = `24489` → 24.489 → `"Normal"` ✓
b) height = null → `"Datos incompletos"` ✓
c) height = 160, weight = 95000 → `95000 * 10000 / (160 * 160)` = `950000000 / 25600` = `37109` → 37.109 → `"Obesidad"` ✓

**Criterios de corrección:**
- Método correcto con todas las ramas de validación: 4 puntos.
- Clasificación correcta del IMC: 3 puntos.
- Pruebas con los tres conjuntos de datos: 3 puntos.

---

### Actividad 2 — Repaso métodos y endpoint GET de U1 (10 puntos)

**Solución:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — lista completa de medicos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors").ToList();

    return Results.Ok(doctors);
});

// GET /doctors/{id:long} — un medico por ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @id", new { id });

    return doctor is null
        ? Results.NotFound(new { mensaje = "Medico no encontrado" })
        : Results.Ok(doctor);
});

app.Run();

// Record posicional despues de app.Run()
record Doctor(
    long DoctorId,
    string FirstName,
    string LastName,
    string Specialty);
```

**Criterios de corrección:**
- Endpoint `/doctors` con `Query<Doctor>` y alias `AS`: 3 puntos.
- Endpoint `/doctors/{id:long}` con `QueryFirstOrDefault<Doctor>` y `Results.NotFound`: 3 puntos.
- Record `Doctor` después de `app.Run()`, tipos canónicos: 2 puntos.
- Código compila y sigue convenciones: 2 puntos.

---

### Actividad 3 — SQL básico: SELECT, WHERE, ORDER BY (20 puntos)

**a) Solución:**

```sql
SELECT first_name, last_name, city
FROM patients
WHERE city = 'Buenos Aires'
ORDER BY last_name ASC;
```

Resultado esperado: lista de pacientes de Buenos Aires ordenados por apellido.

**b) Solución:**

```sql
SELECT first_name, last_name, birth_date
FROM patients
WHERE birth_date >= '1990-01-01'
ORDER BY birth_date DESC;
```

Resultado esperado: pacientes nacidos a partir de 1990, del más joven al más viejo.

**c) Diferencia entre `=` y `LIKE`:**

`WHERE city = 'Buenos Aires'` es una comparación de igualdad exacta. Solo coincide con filas donde la ciudad es exactamente `'Buenos Aires'`.

`WHERE city LIKE 'Buenos Aires'` también es una comparación exacta cuando no hay comodines. `LIKE` se vuelve útil cuando se usan caracteres comodín como `%` (cualquier cadena) o `_` (un carácter). Se usaría `LIKE` cuando se necesita búsqueda parcial o patrones.

**d) Solución:**

```sql
SELECT city, COUNT(*) AS patient_count
FROM patients
GROUP BY city
ORDER BY patient_count DESC;
```

Con Dapper, se puede usar `Query<dynamic>` o un record auxiliar:

```csharp
var result = connection.Query(@"
    SELECT city, COUNT(*) AS patient_count
    FROM patients
    GROUP BY city
    ORDER BY patient_count DESC");
```

O con un record tipado (después de `app.Run()`):

```csharp
record CityCount(string City, long PatientCount);
var result = connection.Query<CityCount>(@"
    SELECT city AS City, COUNT(*) AS PatientCount
    FROM patients
    GROUP BY city
    ORDER BY PatientCount DESC").ToList();
```

**Criterios de corrección:**
- Consulta a) correcta: 4 puntos.
- Consulta b) correcta: 4 puntos.
- Explicación correcta de `=` vs `LIKE`: 4 puntos.
- Consulta d) correcta con GROUP BY y ORDER BY: 4 puntos.
- Uso de `ExecuteScalar<long>` o `Query` apropiado: 4 puntos.

---

### Actividad 4 — Dapper: Query<T> con alias AS y parámetros (25 puntos)

**Solución:**

```csharp
// GET /patients/search — buscar pacientes con filtros opcionales
app.MapGet("/patients/search", (string? city, long? minHeight) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Construir la consulta SQL dinamicamente segun los parametros recibidos
    var sql = @"
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
        WHERE 1 = 1";

    var parameters = new {};

    // Agregar filtro por ciudad si se proporciona
    if (!string.IsNullOrEmpty(city))
    {
        sql += " AND city LIKE @city";
        parameters = new { city = $"%{city}%" };
    }

    // Agregar filtro por altura minima si se proporciona
    if (minHeight.HasValue)
    {
        sql += " AND height >= @minHeight";
        // Nota: si ya tenemos parametros de city, necesitamos combinarlos
        // La forma correcta es construir un objeto con todos los parametros
    }

    var patients = connection.Query<Patient>(sql, parameters).ToList();
    return Results.Ok(patients);
});
```

**Solución correcta con parámetros combinados:**

```csharp
app.MapGet("/patients/search", (string? city, long? minHeight) =>
{
    using var connection = new SqliteConnection(connectionString);

    var sql = @"
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
        WHERE 1 = 1";

    // Construir el objeto de parametros dinamicamente
    var parameters = new Dictionary<string, object>();

    if (!string.IsNullOrEmpty(city))
    {
        sql += " AND city LIKE @city";
        parameters.Add("@city", $"%{city}%");
    }

    if (minHeight.HasValue)
    {
        sql += " AND height >= @minHeight";
        parameters.Add("@minHeight", minHeight.Value);
    }

    var patients = connection.Query<Patient>(sql, parameters).ToList();
    return Results.Ok(patients);
});
```

**Criterios de corrección:**
- Endpoint `/patients/search` con parámetros opcionales: 5 puntos.
- Filtro por `city` con `LIKE @city` y `%valor%`: 5 puntos.
- Filtro por `minHeight` con `height >= @minHeight`: 5 puntos.
- Consulta parametrizada (sin concatenación de strings): 5 puntos.
- Record `Patient` después de `app.Run()` y tipos canónicos: 5 puntos.

---

### Actividad 5 — LIKE y consultas con parámetros (15 puntos)

**a) Solución:**

```csharp
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
    WHERE first_name LIKE @name", new { name = "M%" }).ToList();
```

Resultado: pacientes cuyo primer nombre comienza con 'M'.

**b) Solución:**

```csharp
// Buscar pacientes cuya ciudad contenga 'san'
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
    WHERE city LIKE @city", new { city = "%san%" }).ToList();
```

**Problema de mayúsculas/minúsculas:** SQLite por defecto es case-sensitive para `LIKE`. La cadena `'%san%'` no coincidirá con `'San Martín'` ni `'SAN JUAN'`.

**Solución:** Usar `LOWER()` en la consulta y en el parámetro:

```csharp
WHERE LOWER(city) LIKE @city
```

Con `new { city = "%san%" }`. Esto convierte la ciudad a minúsculas antes de comparar, pero el patrón también debe estar en minúsculas. Alternativamente, se puede usar `COLLATE NOCASE`:

```sql
WHERE city LIKE @city COLLATE NOCASE
```

Con `new { city = "%san%" }`.

**c) Solución:**

```csharp
app.MapGet("/patients/bycity/{city}", (string city) =>
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
        WHERE city LIKE @city", new { city = $"%{city}%" }).ToList();

    return patients.Count == 0
        ? Results.NotFound(new { mensaje = "No se encontraron pacientes en esa ciudad" })
        : Results.Ok(patients);
});
```

**Criterios de corrección:**
- Consulta a) correcta con `M%`: 3 puntos.
- Consulta b) correcta con solución para case-sensitivity: 5 puntos.
- Endpoint c) correcto con `LIKE` y `Results.NotFound`: 4 puntos.
- Uso de parámetros (no concatenación): 3 puntos.

---

### Actividad 6 — Integración: endpoint GET con Dapper y filtrado (20 puntos)

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

// GET /patients/search — filtrado combinado por ciudad y altura minima
app.MapGet("/patients/search", (string? city, long? minHeight) =>
{
    using var connection = new SqliteConnection(connectionString);

    var sql = @"
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
        WHERE 1 = 1";

    var parameters = new Dictionary<string, object>();

    if (!string.IsNullOrEmpty(city))
    {
        sql += " AND city LIKE @city";
        parameters.Add("@city", $"%{city}%");
    }

    if (minHeight.HasValue)
    {
        sql += " AND height >= @minHeight";
        parameters.Add("@minHeight", minHeight.Value);
    }

    var patients = connection.Query<Patient>(sql, parameters).ToList();
    return Results.Ok(patients);
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
- Los tres endpoints funcionan correctamente: 8 puntos.
- Todos los SQL usan alias `AS` y parámetros `@`: 5 puntos.
- Record `Patient` después de `app.Run()`, tipos canónicos: 3 puntos.
- Códigos de respuesta correctos (200, 404): 2 puntos.
- Comentarios en español y código limpio: 2 puntos.

---

## Criterios de corrección generales

| Criterio | Ponderación |
|----------|-------------|
| Soluciones de código correctas y compilables | 45% |
| Explicaciones técnicas precisas (SQL, LIKE, Dapper) | 25% |
| Cumplimiento de convenciones del curso (tipos, alias, parametrización) | 20% |
| Presentación ordenada y legible | 10% |

La presentación es individual y manuscrita. Los fragmentos de código deben estar transcritos a mano con la misma estructura y comentarios que la solución oficial. Se penaliza la entrega de código que no compile, que omita alias `AS` en consultas Dapper, o que concatene valores en consultas SQL.
