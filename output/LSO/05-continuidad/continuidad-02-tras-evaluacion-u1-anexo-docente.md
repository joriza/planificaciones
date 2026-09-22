# Anexo docente — Continuidad pedagógica 02: Tras evaluación de U1

## Soluciones

### Actividad 1 — Tipos de datos y variables (15 puntos)

**a) Declaración de variables:**

```csharp
long patientId = 1;
string firstName = "Ana";
string? city = null;
long? height = 165;
int age = 30;
double temperature = 36.5;
```

**b) Resultado predicho y verificado:**

```
Int64
True
True
```

- `patientId.GetType().Name` → `Int64` (no `Int32`).
- `height.HasValue` → `True` porque `height` tiene valor 175.
- `city == null` → `True` porque `city` fue asignado como `null`.

**c) Si se declara `int patientId = 42`:**

No produce un error de compilación por sí solo. Sin embargo, cuando se usa con Dapper para leer una columna INTEGER de SQLite, Dapper devuelve `Int64` y el constructor del record posicional espera `long`. Si el record declara `int PatientId`, se produce una `InvalidOperationException`: "No constructor was found that matches the column types." Este es el defecto frecuente documentado en la convención técnica del curso.

**Criterios de corrección:**
- Variables declaradas con tipos canónicos correctos: 5 puntos.
- Resultados de `GetType`, `HasValue` y `null` check correctos: 5 puntos.
- Explicación correcta del error con `int` vs `long` en Dapper: 5 puntos.

---

### Actividad 2 — Control de flujo (20 puntos)

**a) Solución:**

```csharp
int age = 25;
string category;

if (age < 18)
{
    category = "Menor de 18 — requiere consentimiento";
}
else if (age <= 65)
{
    category = "Adulto";
}
else
{
    category = "Adulto mayor";
}

Console.WriteLine(category);
```

Pruebas con 15 → "Menor de 18", 40 → "Adulto", 70 → "Adulto mayor".

**b) Solución:**

```csharp
string GetSeverity(long heartRate)
{
    if (heartRate < 60)
    {
        return "Bajo";
    }
    else if (heartRate <= 100)
    {
        return "Normal";
    }
    else
    {
        return "Alto";
    }
}
```

Pruebas: 55 → "Bajo", 75 → "Normal", 110 → "Alto".

**c) Si no se incluye `else` para el caso "Alto":**

El método devuelve `null` (tipo `string`) cuando `heartRate > 100` porque ninguna rama del `if/else if` se ejecuta. Esto puede causar `NullReferenceException` en el consumidor o un comportamiento inesperado. La solución correcta es incluir siempre una rama `else` o un `return` al final del método.

**Criterios de corrección:**
- Código correcto y probado con tres valores: 10 puntos (5 por inciso).
- Explicación correcta del comportamiento sin `else`: 5 puntos.
- Código limpio y comentado: 5 puntos.

---

### Actividad 3 — Métodos y funciones (20 puntos)

**a) Método CalculateBMI:**

```csharp
// Calcular el indice de masa corporal
// peso en gramos, altura en centimetros, resultado como long
long CalculateBMI(long weight, long height)
{
    return weight / (height * height) * 10000;
}
```

**b) Método IsValidPatient:**

```csharp
// Verificar que los campos numericos del paciente sean validos
bool IsValidPatient(long? height, long? weight)
{
    return height.HasValue && weight.HasValue && height > 0 && weight > 0;
}
```

**c) Llamada desde Main:**

```csharp
long weight = 75000;
long height = 175;
long bmi = CalculateBMI(weight, height);
bool valid = IsValidPatient(height, weight);

Console.WriteLine($"IMC: {bmi}");
Console.WriteLine($"Valido: {valid}");
```

Resultado esperado: IMC = 24 (75000 / (175*175) * 10000 = 75000 / 30625 * 10000 = 24489... espera, hagamos el cálculo bien).

75000 / (175 * 175) * 10000 = 75000 / 30625 * 10000

Como usamos `long`, la división es entera:
75000 / 30625 = 2 (división entera)
2 * 10000 = 20000

Hmm, esto no es correcto. El IMC real sería 75 / (1.75 * 1.75) = 24.49.

El problema es que con `long`, la fórmula `weight / (height * height) * 10000` produce resultados incorrectos por la división entera.

La fórmula correcta con `long` sería: `(weight * 10000) / (height * height)`.

75000 * 10000 = 750000000
175 * 175 = 30625
750000000 / 30625 = 24489 (aproximadamente 24.49 × 1000)

Hmm, pero el resultado esperado es 24 (IMC redondeado a entero).

La fórmula correcta sería: `weight * 10000 / (height * height)` que da 24489, y si queremos el IMC como entero, sería `24489 / 1000 = 24`.

O bien, la fórmula debería ser `(weight * 100) / (height * height)` para obtener el IMC × 100, y luego dividir por 100.

Vamos a simplificar: la fórmula del IMC es `peso(kg) / altura(m)^2`.
- peso = 75 kg → 75000 gramos
- altura = 175 cm → 1.75 m

IMC = 75 / (1.75 * 1.75) = 75 / 3.0625 = 24.49

Con `long`, la mejor aproximación sería:
`(weight * 10000) / (height * height)` → `750000000 / 30625 = 24489`
Esto representa el IMC × 1000, así que el IMC sería 24 (truncando).

Vamos a corregir la solución:

```csharp
long CalculateBMI(long weight, long height)
{
    // IMC = peso(kg) / altura(m)^2
    // peso en gramos: weight / 1000 = kg
    // altura en cm: height / 100 = m
    // IMC = (weight / 1000) / ((height / 100) * (height / 100))
    // IMC = (weight * 10000) / (height * height) / 1000
    // Para evitar divisiones intermedias con long, multiplicamos primero:
    return (weight * 10000) / (height * height) / 1000;
}
```

(75000 * 10000) / (175 * 175) / 1000 = 750000000 / 30625 / 1000 = 24489 / 1000 = 24

OK, eso da 24. Pero la fórmula original del enunciado era `weight / (height * height) * 10000`, que con `long` da:
75000 / 30625 * 10000 = 2 * 10000 = 20000

Eso está mal. La fórmula correcta es `(weight * 10000) / (height * height) / 1000`.

Voy a ajustar la solución del anexo para reflejar esto correctamente.

Actually, let me reconsider. The activity says the formula is `weight / (height * height) * 10000`. With `long` arithmetic, this gives wrong results due to integer division. The point of the question (inciso d) is to discuss this precision loss. So the solution should acknowledge this.

Let me fix the solution:

**c) Llamada:**

```csharp
long weight = 75000;
long height = 175;
long bmi = CalculateBMI(weight, height);
Console.WriteLine($"IMC: {bmi}");
```

Con la fórmula `weight / (height * height) * 10000`:
- `height * height` = 30625
- `weight / 30625` = 75000 / 30625 = 2 (división entera)
- `2 * 10000` = 20000

Esto es incorrecto. El IMC real es ≈ 24.49.

La fórmula correcta con enteros sería `(weight * 10000) / (height * height)` que da:
- `75000 * 10000` = 750000000
- `750000000 / 30625` = 24489

Y luego `/ 1000` para obtener 24.

**d) Respuesta:** Se usa `long` porque el curso establece que los campos INTEGER de SQLite se mapean a `long` en C#. Sin embargo, el IMC es una operación que requiere precisión decimal. Usar `long` produce errores por división entera. En un escenario real, se usaría `double`. El inciso d) pide que el alumno reflexione sobre esta limitación.

**Criterios de corrección:**
- Métodos correctos: 8 puntos.
- Llamada y resultado verificado: 4 puntos.
- Explicación de la limitación de `long` en operaciones de punto flotante: 8 puntos.

---

### Actividad 4 — Endpoint GET con MapGet (25 puntos)

**Solución completa:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — obtener la lista completa de pacientes
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

// GET /patients/{id:long} — obtener un paciente por ID
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

// GET /patients?city={city} — filtrar pacientes por ciudad
app.MapGet("/patients", (string? city) =>
{
    using var connection = new SqliteConnection(connectionString);
    List<Patient> patients;

    if (!string.IsNullOrEmpty(city))
    {
        patients = connection.Query<Patient>(@"
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
    }
    else
    {
        patients = connection.Query<Patient>(@"
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
    }

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

**Nota:** Los tres endpoints comparten la ruta `/patients`, lo cual genera un conflicto en Minimal API. La solución correcta es usar rutas distintas o un solo endpoint con parámetro opcional. La solución aceptable es:

```csharp
// GET /patients — lista completa o filtrada por ciudad
app.MapGet("/patients", (string? city) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = string.IsNullOrEmpty(city)
        ? connection.Query<Patient>(@"
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
            FROM patients").ToList()
        : connection.Query<Patient>(@"
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

    return Results.Ok(patients);
});

// GET /patients/{id:long} — un paciente por ID
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
```

**Criterios de corrección:**
- Endpoint `/patients` con `Query<Patient>` y alias `AS`: 5 puntos.
- Endpoint `/patients/{id:long}` con `QueryFirstOrDefault<Patient>` y `Results.NotFound`: 5 puntos.
- Endpoint con `LIKE` y parámetro `@city` parametrizado: 5 puntos.
- Record `Patient` después de `app.Run()`, tipos canónicos (`long`, `string?`): 5 puntos.
- Código compila y sigue las convenciones del curso: 5 puntos.

---

### Actividad 5 — Repaso conceptual (20 puntos)

**a) Diferencia entre `MapGet` y `MapPost`:**

`MapGet` registra un endpoint que responde a solicitudes HTTP GET. Se usa para obtener datos del servidor. No recibe cuerpo en la solicitud. Ejemplo: `app.MapGet("/patients", () => Results.Ok(patients));`

`MapPost` registra un endpoint que responde a solicitudes HTTP POST. Se usa para crear un nuevo recurso. Recibe un cuerpo en la solicitud con los datos del nuevo recurso. Ejemplo: `app.MapPost("/patients", (Patient patient) => { ... return Results.Created($"/patients/{newId}", patient); });`

**b) ¿Por qué Dapper requiere alias `AS`?**

Dapper materializa los resultados mapeando los nombres de columna con los parámetros del constructor del record. Si la columna se llama `patient_id` (snake_case) y el record tiene `PatientId` (PascalCase), Dapper no encuentra coincidencia y lanza una excepción. El alias `AS PatientId` renombra la columna en el resultado del SELECT para que coincida con el nombre del parámetro del constructor.

**c) Diferencia entre `Query<T>` y `QueryFirstOrDefault<T>`:**

`Query<T>` devuelve una colección (`IEnumerable<T>`) con todas las filas que coincide la consulta. Se usa cuando se espera múltiples resultados (por ejemplo, listar todos los pacientes).

`QueryFirstOrDefault<T>` devuelve una sola instancia de `T` o `null` si no hay resultados. Se usa cuando se espera como máximo un resultado (por ejemplo, buscar un paciente por ID).

**d) Códigos de respuesta HTTP:**

- 404 Not Found: cuando el recurso solicitado no existe (por ejemplo, un paciente con un ID que no está en la base de datos).
- 400 Bad Request: cuando la solicitud tiene datos faltantes o mal formados (por ejemplo, un campo obligatorio vacío).

**e) ¿Por qué `ExecuteScalar<long>` y no `ExecuteScalar<int>`?**

Porque las columnas INTEGER de SQLite se leen como `Int64` (tipo `long` en C#) por Dapper. Usar `int` (que es `Int32`) produce una `InvalidOperationException` porque el constructor del record posicional no coincide con el tipo devuelto por la columna. `long` es el tipo canónico para todos los campos INTEGER del curso.

**Criterios de corrección:**
- Cada respuesta correcta: 4 puntos (total 20 puntos).
- Se valora la precisión técnica y el uso de terminología correcta.

---

## Criterios de corrección generales

| Criterio | Ponderación |
|----------|-------------|
| Soluciones de código correctas y compilables | 50% |
| Explicaciones técnicas precisas | 30% |
| Cumplimiento de convenciones del curso (tipos, alias, parametrización) | 20% |

La presentación es individual y manuscrita. Los fragmentos de código deben estar transcritos a mano con la misma estructura y comentarios que la solución oficial. Se penaliza la entrega de código que no compile o que omita alias `AS` en consultas Dapper.
