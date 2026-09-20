# Anexo docente — Encuentro 11: consultas parametrizadas, WHERE, ORDER BY y query string

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 11 — consultas parametrizadas: WHERE por id y por query string, ORDER BY, parámetros de ruta y query string sobre `hospital.db` |
| Formato | Encuentro estándar del curso (BOPPPS + GRR), plantilla de clase regular (20/40/70/50/45/15) |
| Producción esperada | Proyecto `u2-api` con `GET /patients` ordenado, `GET /patients/{id:long}` con 404, `GET /patients/by-city` con query string, y los dos endpoints del ejercicio (`GET /doctors/{id:long}`, `GET /patients/by-province`) |
| Insumos | Proyecto `u2-api` de la clase 10 con conexión y `GET /patients` funcionando; `hospital.db` en su lugar |

**Decisión didáctica (validación diferida):** los valores vacíos o inválidos de la query string se registran hoy como comportamiento incómodo (lista vacía, `limit` negativo) pero **no se corrigen todavía**: la validación manual con 400 es el contenido central del Encuentro 12. Mantener ese orden evita mezclar dos novedades (parametrización y validación) en la misma práctica, y deja plantado el problema cuya solución llega la próxima clase.

## Solución completa del ejercicio independiente

Archivo `Program.cs` completo con los dos endpoints nuevos (`GET /doctors/{id:long}` y `GET /patients/by-province`) junto a la base común del encuentro:

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients: todos los pacientes, ordenados por apellido y nombre
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          ORDER BY last_name, first_name");

    return Results.Ok(patients);
});

// GET /patients/{id}: UN paciente segun su id
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.QueryFirstOrDefault<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE patient_id = @id",
        new { id });

    return patient is null ? Results.NotFound()
                           : Results.Ok(patient);
});

// GET /patients/by-city?city=Toronto&limit=5
app.MapGet("/patients/by-city", (string? city, int? limit) =>
{
    int max = limit ?? 10;

    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE city = @city
          ORDER BY last_name, first_name
          LIMIT @max",
        new { city, max });

    return Results.Ok(patients);
});

// EJERCICIO 1 - GET /doctors: todos los medicos ordenados
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          ORDER BY last_name, first_name");

    return Results.Ok(doctors);
});

// EJERCICIO 1 - GET /doctors/{id}: UN medico por id (404 si no existe)
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Parametrizado: hueco @id + dato en new { id }
    var doctor = connection.QueryFirstOrDefault<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE doctor_id = @id",
        new { id });

    return doctor is null ? Results.NotFound()
                          : Results.Ok(doctor);
});

// EJERCICIO 2 - GET /patients/by-province?province=ON&limit=10
app.MapGet("/patients/by-province", (string? province, int? limit) =>
{
    int max = limit ?? 10;   // valor por defecto, igual que en /by-city

    using var connection = new SqliteConnection(connectionString);

    // WHERE province_id = @province: comparacion exacta del codigo
    // de dos letras (ON, BC, AB...). LIMIT @max recorta la lista
    var patients = connection.Query<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE province_id = @province
          ORDER BY last_name, first_name
          LIMIT @max",
        new { province, max });

    return Results.Ok(patients);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

record Patient(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? City,
    string ProvinceId,
    string? Allergies,
    int? Height,
    int? Weight
);

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

Salida esperada (verificada): `GET /doctors/7` devuelve el médico estable de la tabla `doctors` (idéntica en todas las copias): `Hazel Patterson`, especialidad `Oncologist`. `GET /patients/by-province?province=ON&limit=5` devuelve hasta 5 pacientes de Ontario ordenados por apellido (la mayoría de la base es de ON: es el filtro con más volumen). `GET /doctors/999` responde 404.

## Solución de la extensión

`GET /doctors/by-specialty?specialty=Cardiologist&limit=5`:

```csharp
// EXTENSION - GET /doctors/by-specialty?specialty=Cardiologist&limit=5
app.MapGet("/doctors/by-specialty", (string? specialty, int? limit) =>
{
    int max = limit ?? 5;

    using var connection = new SqliteConnection(connectionString);

    // Comparacion exacta de especialidad (el LIKE parcial llega en la clase 12)
    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE specialty = @specialty
          ORDER BY last_name, first_name
          LIMIT @max",
        new { specialty, max });

    return Results.Ok(doctors);
});
```

Verificaciones: `Cardiologist` devuelve médicos (hay cardiologists en la base); `cardiologo` o `Cirujano` devuelven lista vacía: la comparación es exacta y en inglés. Ese vacío incómodo vuelve a justificar la validación y el 404/400 de la próxima clase.

**Nota para la cacería del `+` (consolidación, ítem 1):** el ejemplo de rotura se puede mostrar en un proyecto de consola desechable o proyectado:

```csharp
// NUNCA hacer esto: con un apellido como O'Brien, la comilla simple
// rompe el SQL en pedazos (y es exactamente la puerta de la inyeccion)
var sql = "SELECT * FROM doctors WHERE last_name = '" + apellido + "'";
```

Con `apellido = "O'Brien"`, el SQL resultante termina en `= 'O'Brien'`: tres comillas y una consulta rota. Con parámetros, SQLite recibe el texto y el dato por canales separados y no hay nada que romper.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Consultas parametrizadas sin excepción | Cada `WHERE`/`LIMIT` usa hueco `@` + objeto anónimo; cero concatenaciones con `+` |
| 2 | Búsqueda por id con 404 | `QueryFirstOrDefault<T>` + ternario `is null`; `/doctors/999` responde 404 |
| 3 | Restricción de ruta correcta | `{id:long}` en la ruta y `long id` en el handler; `/doctors/abc` no entra al handler |
| 4 | Query string con opcionales | `(string? province, int? limit)`; valor por defecto con `??` |
| 5 | Orden delegado a la base | `ORDER BY last_name, first_name` en el SELECT; sin reordenar en C# |
| 6 | Tipos canónicos intactos | `long` en ids, `string` en fechas, records al final |
| 7 | Prueba de casos incluida | El grupo probó id existente, id inexistente, query string completa y query string incompleta |

## Errores esperados e intervención

| Error esperado | Causa probable | Intervención docente |
| --- | --- | --- |
| Ruta ambigua o id que nunca llega | Nombre entre llaves distinto del parámetro del handler | Comparar en pizarra `{id:long}` con `(long id)`; el nombre es el pegamento |
| `LIMIT @max` ignorado | Falta `max` en el objeto anónimo | Contar los huecos `@` del SQL y las propiedades del objeto: deben emparejarse |
| Lista vacía con `?province=on` | El código de provincia se compara exacto: es `ON` en mayúsculas | Mostrar un par de filas de `province_names` (o recordar la columna de la clase 10); la comparación exacta no corrige mayúsculas del dato |
| 404 confundido con error | `Results.NotFound()` sin cuerpo muestra la página de error del navegador | Explicar el código de estado como respuesta válida; el mensaje en el 404 llega en la clase 12 |
| Intento de concatenar "solo esta vez" | Prisa por terminar | Volver al ejemplo `O'Brien` del anexo; la regla del curso no tiene excepciones |
| `int max` en vez de `int? limit` | Confundir el valor por defecto con el parámetro recibido | `limit` es opcional (`int?`); `max` es interno (`int`); son dos variables con roles distintos |

## Respuestas esperadas (verificación de comprensión)

- **¿Por qué el dato va en `new { id }` y no pegado al SQL?** Porque el hueco y el dato viajan por canales separados: SQLite se ocupa de las comillas y el texto malicioso no puede convertirse en consulta. Con concatenación, un dato con comilla rompe la consulta y un dato malicioso la secuestra.
- **¿Qué diferencia hay entre `Query<T>` y `QueryFirstOrDefault<T>`?** El primero siempre devuelve una lista (aunque sea vacía); el segundo devuelve la primera fila o `null`. Para "el paciente 7" hace falta el segundo: la respuesta es una fila o nada.
- **¿Por qué `ORDER BY` en SQL y no en C#?** La base está hecha para ordenar y recortar: el trabajo se delega donde los datos viven; el endpoint entrega lo que la base le entrega, ya ordenado.
- **¿Qué pasó con `?city=` vacío?** Llegó `null` como ciudad, el `WHERE city = @city` no matcheó ninguna fila y la lista vino vacía. Es válido pero incómodo para el cliente: la próxima clase lo convierte en un 400 con mensaje.
