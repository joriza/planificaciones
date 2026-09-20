# Anexo docente — Evaluación de la Unidad 2 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B (pacientes y provincias), las respuestas esperadas, los criterios de corrección ítem por ítem, los errores previstos y la pauta de devolución para el Encuentro 16.

## 1. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion Unidad 2 - Version B (solucion del docente)
// Dominio: pacientes y provincias de hospital.db (tablas patients y province_names)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1 =====

// GET /patients/{id:long}: UN paciente por id (200 o 404 con mensaje)
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // QueryFirstOrDefault: la primera fila o null. Consulta SIEMPRE
    // parametrizada (@id); cada columna snake_case lleva su alias AS
    var patient = connection.QueryFirstOrDefault<PatientCard>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 gender     AS Gender,
                 birth_date AS BirthDate,
                 city       AS City
          FROM patients
          WHERE patient_id = @id",
        new { id });

    // Sin fila: 404 con mensaje. Con fila: 200 con el paciente
    return patient is null
        ? Results.NotFound(new { mensaje = "No existe el paciente con ese id" })
        : Results.Ok(patient);
});

// ===== Parte 2 =====

// GET /patients/search?text=tor: pacientes cuya ciudad contiene el texto
app.MapGet("/patients/search", (string? text) =>
{
    // Validacion 1: sin texto no hay nada que buscar -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(text))
    {
        return Results.BadRequest(new { mensaje = "Indique un texto para buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    // El patron %...% se arma en C# y viaja parametrizado (@patron):
    // el SQL nunca se concatena con el dato recibido
    var patients = connection.Query<PatientCard>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 gender     AS Gender,
                 birth_date AS BirthDate,
                 city       AS City
          FROM patients
          WHERE city LIKE @patron
          ORDER BY last_name, first_name",
        new { patron = $"%{text}%" });

    // Validacion 2: pedido valido sin resultados -> 404 con mensaje
    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente con esa ciudad" });
    }

    return Results.Ok(patients);
});

// ===== Parte 3 =====

// GET /provinces/{provinceId}/patients: pacientes de una provincia.
// JOIN de dos tablas: patients (p) + province_names (pn)
app.MapGet("/provinces/{provinceId}/patients", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // El JOIN empareja cada paciente con la fila de su provincia por el
    // codigo; el nombre completo de la provincia sale del cruce
    var patients = connection.Query<PatientInProvince>(
        @"SELECT p.first_name     AS FirstName,
                 p.last_name      AS LastName,
                 p.city           AS City,
                 pn.province_name AS ProvinceName
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE p.province_id = @provinceId
          ORDER BY p.last_name, p.first_name",
        new { provinceId });

    // 200 con la lista (vacia si el codigo no tiene pacientes)
    return Results.Ok(patients);
});

// ===== Parte 4 =====

// POST /patients: alta de un paciente (INSERT parametrizado)
app.MapPost("/patients", (PatientInput input) =>
{
    // Validacion: los cinco campos son obligatorios -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Gender) ||
        string.IsNullOrWhiteSpace(input.BirthDate) ||
        string.IsNullOrWhiteSpace(input.ProvinceId))
    {
        return Results.BadRequest(new { mensaje = "Nombre, apellido, genero, fecha de nacimiento y provincia son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // ExecuteScalar: corre el INSERT (solo las cinco columnas; las que
    // aceptan NULL quedan sin dato) y trae last_insert_rowid()
    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO patients (first_name, last_name, gender, birth_date, province_id)
          VALUES (@FirstName, @LastName, @Gender, @BirthDate, @ProvinceId);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Gender, input.BirthDate, input.ProvinceId });

    // 201 Created: URL del recurso nuevo + el paciente con su id real
    var created = new PatientCard(newId, input.FirstName, input.LastName,
        input.Gender, input.BirthDate, null);
    return Results.Created($"/patients/{newId}", created);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record PatientCard(long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City);
record PatientInProvince(string FirstName, string LastName, string? City, string ProvinceName);
record PatientInput(string FirstName, string LastName, string Gender, string BirthDate,
    string ProvinceId);
```

Aceptaciones válidas menores: ternario resuelto con `if`/`else`; `Any()` en lugar de `Count() == 0`; `Results.Ok(connection.Query<...>(...))` sin variable intermedia; mensajes libres siempre que sean legibles y en español; en el POST, responder con un `PatientInput` reconstruido o con un `PatientCard` de `City: null` (ambas salidas se aceptan). No se acepta `TypedResults` (no es canon del curso en .NET 6) ni SQL concatenado con el dato recibido.

## 2. Respuestas esperadas

Con la API corriendo (`dotnet run`) y la copia provista de `hospital.db` junto al `.csproj` (la referencia tiene 258 pacientes y 13 provincias; los valores de fila dependen de la copia):

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/patients/7` | `200` con `{"patientId":7,"firstName":"...","lastName":"...","gender":"...","birthDate":"...","city":"..."}` |
| `GET http://localhost:5080/patients/99999` | `404` con `{"mensaje":"No existe el paciente con ese id"}` |
| `GET http://localhost:5080/patients/search?text=tor` | `200` con los pacientes de ciudades que contienen «tor» (Toronto entre ellas) |
| `GET http://localhost:5080/patients/search` | `400` con `{"mensaje":"Indique un texto para buscar"}` |
| `GET http://localhost:5080/patients/search?text=zzz` | `404` con `{"mensaje":"Ningun paciente con esa ciudad"}` |
| `GET http://localhost:5080/provinces/ON/patients` | `200` con los pacientes de Ontario (mayoría de la base): `[{"firstName":"...","lastName":"...","city":"...","provinceName":"Ontario"}, ...]` |
| `GET http://localhost:5080/provinces/ZZ/patients` | `200` con `[]` (el cruce no encontró pacientes con ese código) |
| `POST /patients` con `{"firstName":"Ana","lastName":"Garcia","gender":"F","birthDate":"2001-03-14","provinceId":"ON"}` | `201`, `Location: /patients/259` (en la base recién copiada: 258 pacientes + 1), cuerpo `{"patientId":259,"firstName":"Ana","lastName":"Garcia","gender":"F","birthDate":"2001-03-14","city":null}` |
| `POST /patients` con `{"firstName":"Ana","lastName":"","gender":"F","birthDate":"2001-03-14","provinceId":"ON"}` | `400` con mensaje |
| `POST /patients` válido pero con `"provinceId":"XX"` (código inexistente) | `500` con `SQLite Error 19: 'FOREIGN KEY constraint failed'` en la terminal: la base protege su integridad (fuera del alcance de la validación pedida) |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe "http://localhost:5080/patients/search?text=tor"
curl.exe -i "http://localhost:5080/patients/99999"
curl.exe "http://localhost:5080/provinces/ON/patients"
curl.exe -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"
```

## 3. Respuestas esperadas de los ítems conceptuales

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1a | Evita la **inyección SQL**: el texto del cliente nunca se pega al SQL. La regla del curso: el valor viaja siempre por parámetro (`@patron` + objeto anónimo `new { ... }`); el SQL no se concatena nunca con datos recibidos | 4 |
| C1b | La comilla simple de `O'Brien` rompe la cadena del SQL: la consulta queda mal formada (error de sintaxis) o cambia de significado; es la manifestación concreta de la inyección | 4 |
| C2a | Las columnas de la base están en `snake_case` y las propiedades del record en PascalCase; Dapper empareja por nombre (ignora mayúsculas pero no el guión bajo). El `AS` deja cada columna con el nombre exacto de la propiedad | 4 |
| C2b | Esa columna no se mapea: la propiedad llega vacía en el JSON (`null` en textos, `0` en números), sin error explícito que lo avise | 3 |

## 4. Criterios de corrección ítem por ítem

### Parte 1 — Detalle de un paciente (15 puntos)

| Qué se observa | Puntos |
| --- | --- |
| Ruta `GET /patients/{id:long}` con parámetro tipado `long id` | 3 |
| `SELECT` con alias de columnas y `QueryFirstOrDefault` parametrizado (`@id`) | 5 |
| `200` con el paciente encontrado (`Results.Ok`) | 3 |
| `404` con mensaje cuando el id no existe (`Results.NotFound`) | 4 |

### Parte 2 — Búsqueda por ciudad (25 puntos)

| Qué se observa | Puntos |
| --- | --- |
| Ruta `GET /patients/search` con el texto por query string (`string? text`) | 3 |
| Validación del texto faltante con `IsNullOrWhiteSpace` y `400` con mensaje | 6 |
| `LIKE @patron` parametrizado con comodines armados en C# (nunca concatenado) | 6 |
| `404` con mensaje cuando no hay resultados | 5 |
| `200` con la lista y `ORDER BY` en el SQL | 5 |

### Parte 3 — Pacientes por provincia (25 puntos)

| Qué se observa | Puntos |
| --- | --- |
| Ruta `GET /provinces/{provinceId}/patients` con el código por la ruta | 3 |
| `JOIN patients` + `province_names` con `ON` correcto y alias de tabla (`p`, `pn`) | 7 |
| Alias de todas las columnas del record compuesto | 7 |
| `WHERE` parametrizado por el código de provincia y `ORDER BY` por apellido | 5 |
| `200` con la lista mapeada a `PatientInProvince` | 3 |

### Parte 4 — Alta de pacientes (20 puntos)

| Qué se observa | Puntos |
| --- | --- |
| `POST /patients` que lee el cuerpo con el record `PatientInput` (sin id) | 3 |
| Validación de los cinco campos obligatorios con `400` y mensaje | 5 |
| `INSERT` parametrizado sobre `patients` (las cinco columnas) | 4 |
| Id generado con `ExecuteScalar<long>` (`INSERT` + `last_insert_rowid()` juntos) | 4 |
| `201` con la URL del nuevo paciente (`Results.Created`) y el recurso con su id real | 4 |

### Parte 5 — Ítems conceptuales (15 puntos)

| Ítem | Puntos |
| --- | --- |
| C1a | 4 |
| C1b | 4 |
| C2a | 4 |
| C2b | 3 |

**Total: 100 puntos.** Se tolera un endpoint funcional con una convención desviada si el criterio puntual lo penaliza una sola vez; no se duplican descuentos por el mismo defecto en ítems distintos.

## 5. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en los GET | Id declarado `int` en vez de `long`, o alias `AS` que no coincide con la propiedad | Descuenta el ítem de mapeo correspondiente; orientar en el momento no quita el descuento |
| SQL con el texto concatenado (`"... LIKE '%" + text + "%'"`) | No parametrizó | Descuenta el ítem de parametrización; es canon de seguridad de la unidad |
| `TypedResults` en las respuestas | Confusión de versión | Defecto de versión (canon: `Results` en .NET 6); descuenta en el ítem donde aparece |
| Rutas en español (`/pacientes`) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| 400/404 sin cuerpo de mensaje | `Results.NotFound()` a secas | Descuento parcial: el código correcto puntúa, el mensaje exigido no |
| `string text` sin `?` en la query string | El parámetro opcional se declaró obligatorio | Descuenta el punto de query string si provoca error en el camino sin texto; la validación con `IsNullOrWhiteSpace` sigue exigida |
| La búsqueda por ciudad «no encuentra» pacientes que sí tienen ciudad escrita distinta | `NULL` en `city`: los pacientes sin ciudad no aparecen en ningún `LIKE` (el vacío no matchea) | Comportamiento correcto de la base: no es defecto del endpoint ni descuenta |
| `500` en el POST con código de provincia inexistente | Clave foránea `province_id` → `SQLite Error 19` | La validación pedida es solo de campos no vacíos: no descuenta; la base protegió la integridad (caso trabajado en la clase 14) |
| Ordenar en C# en vez de en SQL | `.OrderBy(...)` sobre la lista traída | Descuenta el punto de orden del ítem |
| Records movidos por encima de `app.Run()` | Error CS8803 al compilar | Avisar la causa no invalida la prueba; se corrige lo que alcance a compilar |
| El POST no recibe el cuerpo en curl | Falta `Content-Type: application/json` o comillas sin escapar | Es un problema de prueba, no de código: se orienta y no se descuenta |

## 6. Pauta de devolución (Encuentro 16)

- Corrección individual escrita ítem por ítem (qué puntúa, qué no y por qué), devuelta al **inicio del Encuentro 16**, junto con el resultado de la defensa por objetivo y el estado de la entrega del tp-u2.
- Comentarios generales al curso: aciertos más frecuentes (estructura de `Program.cs`, uso de `Results`) y errores comunes (parametrización del `LIKE`, alias de columnas, 400/404 sin mensaje).
- Los ítems y objetivos no alcanzados se traducen en pistas de recuperación para los encuentros de intensificación y fortalecimiento 17 y 18: cada alumno marca en su corrección los núcleos a reforzar (parametrización y validación; alias y records; JOIN; INSERT con id generado).
- La planilla de resultados registra alumno, versión (B), puntaje por parte, total sobre 100, resultado de la defensa por objetivo y observaciones para las intensificaciones.
