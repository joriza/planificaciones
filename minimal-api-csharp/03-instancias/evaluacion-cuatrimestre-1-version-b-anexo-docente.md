# Anexo docente — Evaluación integradora del cuatrimestre 1 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas, los criterios de corrección ítem por ítem, los errores previstos y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion integradora cuatrimestre 1 - Version B (solucion del docente)
// Parte 1: catalogo de ciudades en memoria (Unidad 1)
// Partes 2 y 3: pacientes y provincias de hospital.db (Unidad 2)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Catalogo en memoria de la Parte 1: datos provistos por la prueba
var cities = new List<City>
{
    new(1, "Rosario"),
    new(2, "Cordoba"),
    new(3, "Mendoza")
};

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1 =====

// a) GET /cities/{id:long}: una ciudad del catalogo o 404
app.MapGet("/cities/{id:long}", (long id) =>
{
    // Busca en la lista la primera coincidencia por id (o null)
    var city = cities.FirstOrDefault(c => c.CityId == id);

    // Sin coincidencia: 404 con mensaje. Con coincidencia: 200 con la ciudad
    return city is null
        ? Results.NotFound(new { mensaje = "No existe esa ciudad" })
        : Results.Ok(city);
});

// b) POST /cities: alta con validacion manual
app.MapPost("/cities", (City city) =>
{
    // Validacion manual simple: el nombre no puede quedar vacio
    if (string.IsNullOrWhiteSpace(city.Name))
    {
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });
    }

    // Nuevo id: el maximo de la lista mas uno (la lista nunca arranca vacia)
    var newId = cities.Max(c => c.CityId) + 1;

    // Alta en la lista con el id calculado
    var created = new City(newId, city.Name);
    cities.Add(created);

    // 201 con la URL del recurso nuevo y la ciudad en el cuerpo
    return Results.Created($"/cities/{newId}", created);
});

// ===== Parte 2 =====

// a) GET /patients?text=...: pacientes cuya ciudad contiene el texto
app.MapGet("/patients", (string? text) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con el comodin % alrededor del parametro: busqueda parcial.
    // Consulta SIEMPRE parametrizada: el texto llega por @text, nunca concatenado
    var patients = connection.Query<PatientCard>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 city       AS City
          FROM patients
          WHERE city LIKE @text
          ORDER BY last_name",
        new { text = "%" + text + "%" });

    // 200 con la lista serializada a JSON (lista vacia si no hay coincidencias)
    return Results.Ok(patients);
});

// b) GET /provinces/{provinceId}/patients: pacientes de una provincia
//    JOIN de dos tablas: patients + province_names
app.MapGet("/provinces/{provinceId}/patients", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // El JOIN une cada paciente con el nombre de su provincia;
    // las columnas snake_case llevan alias para encajar en el record
    var patients = connection.Query<PatientInProvince>(
        @"SELECT p.patient_id   AS PatientId,
                 p.first_name   AS FirstName,
                 p.last_name    AS LastName,
                 pn.province_name AS ProvinceName
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE pn.province_id = @provinceId
          ORDER BY p.last_name",
        new { provinceId });

    // 200 con la lista (vacia si la provincia no tiene pacientes)
    return Results.Ok(patients);
});

// ===== Parte 3 =====

// POST /patients: alta de un paciente en la base (INSERT parametrizado)
app.MapPost("/patients", (Patient patient) =>
{
    // Validacion manual simple: los cinco campos obligatorios de la tabla
    if (string.IsNullOrWhiteSpace(patient.FirstName) ||
        string.IsNullOrWhiteSpace(patient.LastName) ||
        string.IsNullOrWhiteSpace(patient.Gender) ||
        string.IsNullOrWhiteSpace(patient.BirthDate) ||
        string.IsNullOrWhiteSpace(patient.ProvinceId))
    {
        return Results.BadRequest(new { mensaje = "Nombre, apellido, genero, fecha de nacimiento y provincia son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado solo con las columnas obligatorias;
    // city, allergies, height y weight quedan en NULL, como permite la tabla
    var newId = connection.ExecuteScalar<long>(
        @"INSERT INTO patients (first_name, last_name, gender, birth_date, province_id)
          VALUES (@FirstName, @LastName, @Gender, @BirthDate, @ProvinceId);
          SELECT last_insert_rowid();",
        new { patient.FirstName, patient.LastName, patient.Gender, patient.BirthDate, patient.ProvinceId });

    // 201 con la URL del recurso nuevo y el paciente con su id real
    return Results.Created($"/patients/{newId}",
        new Patient(newId, patient.FirstName, patient.LastName, patient.Gender,
                    patient.BirthDate, patient.City, patient.ProvinceId,
                    patient.Allergies, patient.Height, patient.Weight));
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record City(long CityId, string Name);
record Patient(
    long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City, string ProvinceId, string? Allergies,
    int? Height, int? Weight);
record PatientCard(long PatientId, string FirstName, string LastName, string? City);
record PatientInProvince(long PatientId, string FirstName, string LastName, string ProvinceName);
```

Aceptaciones válidas menores: `FirstOrDefault` resuelto con `Where(...).FirstOrDefault()` o con un `foreach`; cálculo del nuevo id con `Count() + 1` (correcto mientras no se borren elementos de la lista); `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`; `Results.Ok(connection.Query<...>(...))` sin variable intermedia; en el POST, el INSERT ampliado con `city` si el alumno la valida y la inserta. No se acepta `TypedResults` (no existe como canon en .NET 6) ni SQL concatenado.

## 2. Respuestas esperadas

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/cities/2` | `200` con `{"cityId":2,"name":"Cordoba"}` |
| `GET http://localhost:5080/cities/99` | `404` con `{"mensaje":"No existe esa ciudad"}` |
| `POST /cities` con `{"name":"Parana"}` | `201`, encabezado `Location: /cities/4`, cuerpo `{"cityId":4,"name":"Parana"}` |
| `POST /cities` con `{"name":""}` | `400` con `{"mensaje":"El nombre es obligatorio"}` |
| `GET http://localhost:5080/patients?text=ham` | `200` con la lista de pacientes cuya `city` contiene «ham» en JSON camelCase (los que tienen ciudad `NULL` no coinciden con el `LIKE`) |
| `GET http://localhost:5080/patients?text=xyz` | `200` con `[]` (lista vacía: no hay coincidencias) |
| `GET http://localhost:5080/provinces/ON/patients` | `200` con la lista de pacientes de Ontario: `[{"patientId":25,"firstName":"...","lastName":"...","provinceName":"Ontario"}, ...]` |
| `GET http://localhost:5080/provinces/ZZ/patients` | `200` con `[]` |
| `POST /patients` con `{"firstName":"Ana","lastName":"Garcia","gender":"F","birthDate":"2001-03-14","provinceId":"ON"}` | `201`, `Location: /patients/259` (258 pacientes en la base), cuerpo con `patientId` generado y el resto en `null` |
| `POST /patients` sin `birthDate` | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe -X POST http://localhost:5080/cities -H "Content-Type: application/json" -d "{\"name\":\"Parana\"}"
curl.exe -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"
curl.exe -i http://localhost:5080/provinces/ON/patients
```

## 3. Criterios de corrección ítem por ítem

### Parte 1 — Catálogo en memoria (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1a | Ruta `GET /cities/{id:long}` con parámetro tipado `long id` | 3 |
| 1a | `200` con la ciudad encontrada (`Results.Ok`) | 4 |
| 1a | `404` con mensaje cuando el id no existe (`Results.NotFound`) | 3 |
| 1b | Ruta `POST /cities` que lee el cuerpo con el record | 3 |
| 1b | Validación manual del nombre vacío con `400` y mensaje | 5 |
| 1b | `201` con la URL del recurso nuevo (`Results.Created`) y la ciudad con su id calculado | 7 |

### Parte 2 — Consultas a la base (35 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2a | Ruta `GET /patients` con el texto por query string | 3 |
| 2a | `SELECT` con alias de columnas `snake_case` → `PascalCase` | 4 |
| 2a | `LIKE @text` parametrizado con comodines (nunca concatenado) | 5 |
| 2a | `200` con la lista mapeada a `PatientCard` en JSON (`Results.Ok`) | 3 |
| 2b | Ruta con el código de provincia como parámetro de ruta | 3 |
| 2b | `JOIN patients` + `province_names` con `ON` correcto | 6 |
| 2b | Alias de todas las columnas, incluido el nombre de la provincia | 5 |
| 2b | `WHERE` parametrizado por provincia y orden por apellido | 3 |
| 2b | `200` con la lista en JSON (`Results.Ok`) | 3 |

### Parte 3 — Alta en la base (20 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3 | Validación de los cinco campos obligatorios con `400` y mensaje | 5 |
| 3 | `INSERT` parametrizado sobre `patients` | 6 |
| 3 | Id generado con `ExecuteScalar<long>` (`last_insert_rowid`) | 4 |
| 3 | `201` con la URL del nuevo paciente (`Results.Created`) | 5 |

### Parte 4 — Ítems conceptuales (20 puntos)

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1a | Las ciudades creadas por `POST` se pierden: la lista se reconstruye desde el código en cada ejecución | 2 |
| C1b | Los pacientes quedan grabados en el archivo `hospital.db`: la base persiste aunque la API se corte | 3 |
| C2 | Verbo y código correctos: GET `404` · POST `201` · POST `400` · GET `200` (2 puntos cada fila) | 8 |
| C3a | Orden: `git add .` → `git commit -m "..."` → `git push` | 3 |
| C3b | `git commit` (con `-m` el mensaje se escribe ahí) | 2 |
| C3c | Evita versionar archivos generados; en el curso ignora `bin/` y `obj/` | 2 |

**Total: 100 puntos.** Se tolera un endpoint funcional con una convención desviada si el criterio puntual lo penaliza una sola vez; no se duplican descuentos por el mismo defecto en ítems distintos.

## 4. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en `GET /patients?text=` | Record con tipos distintos al alias, o `int` en el id | Se corrige el criterio de alias/tipos del ítem; orientar en el momento no quita el descuento |
| SQL con el texto concatenado (`"... LIKE '%" + text + "%'"`) | No parametrizó | Descuenta el ítem de parametrización; es canon de seguridad de la unidad |
| `TypedResults` en las respuestas | Confusión de versión | Se marca como defecto de versión (canon: `Results` en .NET 6); descuenta en el ítem donde aparece |
| Rutas en español (`/pacientes`, `/provincias`) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| `POST /patients` que inserta sin validar el género | Validación incompleta | Descuenta la fila de validación del ítem 3 |
| 404/400 sin cuerpo de mensaje | Respondió `Results.NotFound()` a secas | Descuento parcial: el código correcto puntúa, el mensaje exigido no |
| Records movidos por encima de `app.Run()` | Error CS8803 al compilar | Avisar la causa no invalida la prueba; se corrige lo que alcance a compilar |

## 5. Pauta de devolución

- Corrección individual escrita por ítem (qué puntúa, qué no y por qué), entregada al inicio del encuentro 17 junto con la devolución de las demás instancias del cuatrimestre.
- Comentarios generales al curso antes de la plenaria de metacognición: los aciertos más frecuentes (estructura de `Program.cs`, uso de `Results`) y los errores comunes (parametrización del `LIKE`, alias de columnas, códigos 400 sin mensaje).
- Los ítems no alcanzados se traducen en pistas de recuperación para los encuentros 17 y 18: cada alumno marca en su corrección los núcleos a reforzar (rutas y códigos; consultas parametrizadas; INSERT).
- La planilla de resultados registra alumno, versión (B), puntaje por parte y total sobre 100.
