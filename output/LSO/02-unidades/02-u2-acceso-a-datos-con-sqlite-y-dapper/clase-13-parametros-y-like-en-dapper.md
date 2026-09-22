# Encuentro 13 — Parámetros y LIKE en Dapper

> Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 13 de 36 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Eje temático | 4 — Dapper y consultas parametrizadas |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Parámetros y LIKE en Dapper |
| Requisitos previos | Haber completado el Encuentro 12; saber crear records y mapear con `Query<T>`; conocer los tipos canónicos de mapeo. |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual; cada alumno tiene su proyecto con `hospital.db` en la raíz. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Explicar por qué las consultas SQL deben ser siempre parametrizadas y nunca concatenar datos.
2. Usar parámetros con objetos anónimos (`new { ... }`) en Dapper para consultas seguras.
3. Usar el operador `LIKE` de SQL con parámetros para búsquedas parciales.
4. Crear endpoints de búsqueda que filtren datos de la base de forma segura.

## 3. Apertura y motivación (20 min)

### Recap del Encuentro 12

El docente pide que cada alumno ejecute el endpoint `/doctors` que crearon en el encuentro anterior. Se pregunta: ¿qué pasaría si queremos buscar médicos por especialidad? ¿Podemos simplemente pegar el texto en el SQL?

### Introducción a los parámetros y la seguridad

Cuando escribimos una consulta SQL, nunca debemos concatenar datos del usuario directamente en el texto de la consulta. Hacerlo abre la puerta a la inyección SQL, un ataque donde un usuario malicioso puede manipular la consulta para acceder o modificar datos que no debería.

**Analogía rápida:** pensá en la consulta SQL como una receta. Si le das al cocinero los ingredientes sueltos, puede poner lo que quiera. Pero si le das los ingredientes en envoltorios separados y etiquetados (parámetros), el cocinero solo puede usar lo que le corresponde.

En Dapper, los parámetros se pasan como un objeto anónimo:

```csharp
// Bien: el valor llega por @nombre y se pasa con new { nombre }
connection.Query<Doctor>(@"
    SELECT * FROM doctors WHERE specialty = @specialty",
    new { specialty });
```

```csharp
// MAL: concatenar el valor directamente en el SQL
connection.Query<Doctor>($@"
    SELECT * FROM doctors WHERE specialty = '{specialty}'");
```

La segunda forma es vulnerable a inyección SQL y nunca debe usarse.

## 4. Desarrollo teórico-práctico (120 min)

### Teoría: consultas parametrizadas con Dapper

Dapper usa el objeto anónimo que pasamos como segundo argumento para reemplazar los marcadores `@nombre` en el SQL. Esto garantiza que los valores se traten como datos, no como código SQL.

La regla es simple: **todo valor que venga del usuario o de una variable va como parámetro `@nombre` con `new { nombre }`**.

### Práctica guiada: consultas parametrizadas

Vamos a crear endpoints que busquen datos usando parámetros.

```csharp
// Program.cs — Ejemplo completo: consultas parametrizadas con LIKE
// Usar Dapper y Microsoft.Data.Sqlite para conectarse a la base

using Dapper;
using Microsoft.Data.Sqlite;

// Cadena de conexion fija: apunta al archivo hospital.db
var connectionString = "Data Source=hospital.db";

// Crear la aplicacion web con Minimal API
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients/search — buscar pacientes por nombre (búsqueda parcial)
app.MapGet("/patients/search", (string name) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines % para búsqueda parcial
    // El parámetro @name lleva el valor con % alrededor para que LIKE funcione
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

// GET /patients/by-city/{city} — buscar pacientes por ciudad
app.MapGet("/patients/by-city/{city}", (string city) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Consulta parametrizada con LIKE y comodín al final
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
        WHERE city LIKE @city
        ORDER BY last_name, first_name
    ", new { city = $"{city}%" }).ToList();

    return Results.Ok(patients);
});

// GET /patients/by-allergy — buscar pacientes con una alergia específica
app.MapGet("/patients/by-allergy", (string allergy) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines en ambos lados para buscar la alergia anywhere
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
        WHERE allergies LIKE @allergy
        ORDER BY last_name, first_name
    ", new { allergy = $"%{allergy}%" }).ToList();

    return Results.Ok(patients);
});

// Arrancar la aplicacion
app.Run();

// Record para pacientes: todos los tipos deben coincidir con lo que devuelve la BD
// INTEGER de SQLite -> long (no int)
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
```

**Salida esperada al navegar a `http://localhost:5000/patients/search?name=Don`:**

```json
[
  {
    "patientId": 1,
    "firstName": "Donald",
    "lastName": "Waterfield",
    "gender": "M",
    "birthDate": "1963-02-12",
    "city": "Barrie",
    "provinceId": "ON",
    "allergies": "Penicillin",
    "height": 185,
    "weight": 76
  }
]
```

**Salida esperada al navegar a `http://localhost:5000/patients/by-allergy?allergy=Penicillin`:**

```json
[
  {
    "patientId": 1,
    "firstName": "Donald",
    "lastName": "Waterfield",
    "gender": "M",
    "birthDate": "1963-02-12",
    "city": "Barrie",
    "provinceId": "ON",
    "allergies": "Penicillin",
    "height": 185,
    "weight": 76
  }
]
```

**Salida esperada al navegar a `http://localhost:5000/patients/by-city?city=Tor`:**

```json
[
  {
    "patientId": 3,
    "firstName": "Jiji",
    "lastName": "Sharma",
    "gender": "F",
    "birthDate": "1990-05-15",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": "Sulfa",
    "height": 162,
    "weight": 55
  }
]
```

### Práctica guiada: QueryFirstOrDefault con parámetros

Ahora vamos a buscar un solo paciente por su nombre completo, usando `QueryFirstOrDefault<T>`.

```csharp
// GET /patient/find — buscar un paciente por nombre y apellido
app.MapGet("/patient/find", (string firstName, string lastName) =>
{
    using var connection = new SqliteConnection(connectionString);

    // QueryFirstOrDefault<T> devuelve null si no encuentra resultados
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
        WHERE first_name = @firstName
          AND last_name = @lastName",
        new { firstName, lastName });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});
```

**Salida esperada al navegar a `http://localhost:5000/patient/find?firstName=Donald&lastName=Waterfield`:**

```json
{
  "patientId": 1,
  "firstName": "Donald",
  "lastName": "Waterfield",
  "gender": "M",
  "birthDate": "1963-02-12",
  "city": "Barrie",
  "provinceId": "ON",
  "allergies": "Penicillin",
  "height": 185,
  "weight": 76
}
```

**Salida esperada al navegar a `http://localhost:5000/patient/find?firstName=Juan&lastName=Perez`:**

```json
{
  "mensaje": "Paciente no encontrado"
}
```

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- Las consultas SQL deben ser siempre parametrizadas: nunca concatenar datos en el texto SQL.
- En Dapper, los parámetros se pasan con `@nombre` en el SQL y `new { nombre }` como segundo argumento.
- `LIKE` permite búsquedas parciales con comodines `%`: `LIKE @nombre` con `new { nombre = $"%{texto}%" }`.
- `QueryFirstOrDefault<T>` devuelve `null` cuando no hay resultados; se usa para buscar un solo registro.
- Los objetos anónimos `new { ... }` permiten pasar múltiples parámetros a la vez.

### Lo que viene

Encuentro 14: Cierre U2: repaso y TP — vamos a repasar todos los conceptos de la unidad y a trabajar en la entrega del TP-U2.

## 6. Actividad complementaria (80 min)

### Crear endpoints de búsqueda con parámetros y LIKE

En esta actividad vas a crear endpoints que permitan buscar datos de la base de forma segura.

**Consigna 1 — Búsqueda por especialidad médica (25 min):**
Creá un endpoint `GET /doctors/by-specialty?specialty=Cardiologist` que devuelva todos los médicos de una especialidad dada. Usá `LIKE` con el parámetro para permitir búsquedas parciales (p.ej., `specialty=Card` debería encontrar `Cardiologist`).

Pista: usá `new { specialty = $"%{specialty}%" }` para envolver el valor con comodines.

**Consigna 2 — Búsqueda de ingresos por diagnóstico (25 min):**
Creá un endpoint `GET /admissions/search?diagnosis=Heart` que devuelva los ingresos cuyo diagnóstico contenga la palabra clave. Mostrá la fecha de ingreso, el diagnóstico y el nombre del médico tratante.

Pista: necesitás un `JOIN` entre `admissions` y `doctors` para obtener el nombre del médico.

**Consigna 3 — Búsqueda con múltiples filtros (30 min):**
Creá un endpoint `GET /patients/filter` que acepte parámetros opcionales: `?gender=M&city=Toronto&provinceId=ON`. El endpoint debe filtrar solo por los parámetros que se proporcionen. Si no se pasa ningún parámetro, devuelve todos los pacientes.

Pista: construí la consulta SQL dinámicamente o usá condiciones `WHERE 1=1` con `AND` para cada filtro.

## 7. Errores comunes y trampas

| Error observable | Causa probable | Cómo intervenir |
| --- | --- | --- |
| `InvalidOperationException` al ejecutar LIKE | Falta envolver el valor con `%` en el objeto anónimo. | Mostrar que `LIKE @nombre` requiere `new { nombre = $"%{valor}%" }` para los comodines. |
| La búsqueda no devuelve resultados | Se usó `=` en vez de `LIKE` para búsqueda parcial. | Recordar que `=` busca coincidencia exacta y `LIKE` permite coincidencia parcial con `%`. |
| Inyección SQL en la consulta | Se concatenó el valor directamente en el SQL con `$"{valor}"`. | Explicar que siempre se debe usar `@param` con `new { param }` y nunca concatenar. |
| `null` en el JSON para campos nullable | La propiedad no lleva `?` en el record. | Declarar como `string?` o `long?` según el tipo canónico. |
| La consulta con múltiples filtros no funciona | Se usó `WHERE` sin manejar parámetros opcionales. | Mostrar la técnica de `WHERE 1=1` con `AND` condicional o construir la consulta dinámicamente. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |
