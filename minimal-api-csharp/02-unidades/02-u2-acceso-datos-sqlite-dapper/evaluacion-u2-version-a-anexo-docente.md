# Anexo docente — Evaluación de la Unidad 2 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A (médicos e ingresos), las respuestas esperadas, los criterios de corrección ítem por ítem, los errores previstos y la pauta de devolución para el Encuentro 16.

## 1. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion Unidad 2 - Version A (solucion del docente)
// Dominio: medicos e ingresos de hospital.db (tablas doctors y admissions)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1 =====

// GET /doctors/{id:long}: UN medico por id (200 o 404 con mensaje)
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // QueryFirstOrDefault: la primera fila o null. Consulta SIEMPRE
    // parametrizada (@id); cada columna snake_case lleva su alias AS
    var doctor = connection.QueryFirstOrDefault<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE doctor_id = @id",
        new { id });

    // Sin fila: 404 con mensaje. Con fila: 200 con el medico
    return doctor is null
        ? Results.NotFound(new { mensaje = "No existe el medico con ese id" })
        : Results.Ok(doctor);
});

// ===== Parte 2 =====

// GET /doctors/search?text=cardi: medicos cuya especialidad contiene el texto
app.MapGet("/doctors/search", (string? text) =>
{
    // Validacion 1: sin texto no hay nada que buscar -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(text))
    {
        return Results.BadRequest(new { mensaje = "Indique un texto para buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    // El patron %...% se arma en C# y viaja parametrizado (@patron):
    // el SQL nunca se concatena con el dato recibido
    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE specialty LIKE @patron
          ORDER BY last_name, first_name",
        new { patron = $"%{text}%" });

    // Validacion 2: pedido valido sin resultados -> 404 con mensaje
    if (doctors.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun medico con esa especialidad" });
    }

    return Results.Ok(doctors);
});

// ===== Parte 3 =====

// GET /doctors/{id:long}/admissions: ingresos atendidos por un medico.
// JOIN de dos tablas: admissions (a) + doctors (d)
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // El JOIN empareja cada ingreso con su medico tratante por el id;
    // el nombre completo se arma en SQL con || y sale como una columna mas
    var admissions = connection.Query<AdmissionOfDoctor>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.diagnosis      AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.attending_doctor_id = @id
          ORDER BY a.admission_date",
        new { id });

    // 200 con la lista (vacia si el medico no tiene ingresos registrados)
    return Results.Ok(admissions);
});

// ===== Parte 4 =====

// POST /doctors: alta de un medico (INSERT parametrizado)
app.MapPost("/doctors", (DoctorInput input) =>
{
    // Validacion: los tres campos son obligatorios -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Nombre, apellido y especialidad son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // ExecuteScalar: corre el INSERT y trae last_insert_rowid(), el id
    // que SQLite asigno; todo en la misma llamada y la misma conexion
    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Specialty });

    // 201 Created: URL del recurso nuevo + el medico con su id real
    var created = new Doctor(newId, input.FirstName, input.LastName, input.Specialty);
    return Results.Created($"/doctors/{newId}", created);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
record DoctorInput(string FirstName, string LastName, string Specialty);
```

Aceptaciones válidas menores: ternario resuelto con `if`/`else`; `Any()` en lugar de `Count() == 0`; `Results.Ok(connection.Query<...>(...))` sin variable intermedia; textos de mensaje libres siempre que sean legibles y en español. No se acepta `TypedResults` (no es canon del curso en .NET 6) ni SQL concatenado con el dato recibido.

## 2. Respuestas esperadas

Con la API corriendo (`dotnet run`) y la copia provista de `hospital.db` junto al `.csproj` (la referencia tiene 27 médicos; los valores de fila dependen de la copia):

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/doctors/3` | `200` con `{"doctorId":3,"firstName":"...","lastName":"...","specialty":"..."}` |
| `GET http://localhost:5080/doctors/99999` | `404` con `{"mensaje":"No existe el medico con ese id"}` |
| `GET http://localhost:5080/doctors/search?text=cardio` | `200` con los médicos de especialidades que contienen «cardio» (Cardiologist, Cardiovascular Surgeon) |
| `GET http://localhost:5080/doctors/search` | `400` con `{"mensaje":"Indique un texto para buscar"}` |
| `GET http://localhost:5080/doctors/search?text=zzz` | `404` con `{"mensaje":"Ningun medico con esa especialidad"}` |
| `GET http://localhost:5080/doctors/7/admissions` | `200` con los ingresos del médico 7: `[{"admissionDate":"...","diagnosis":"...","doctorName":"Hazel Patterson"}, ...]` |
| `GET http://localhost:5080/doctors/99999/admissions` | `200` con `[]` (el cruce no encontró ingresos de ese id) |
| `POST /doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | `201`, `Location: /doctors/28` (en la base recién copiada: 27 médicos + 1), cuerpo `{"doctorId":28,...}` |
| `POST /doctors` con `{"firstName":"Ana","lastName":"","specialty":"Cardiologist"}` | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe "http://localhost:5080/doctors/search?text=cardio"
curl.exe -i "http://localhost:5080/doctors/99999"
curl.exe -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"
```

## 3. Respuestas esperadas de los ítems conceptuales

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1a | Evita la **inyección SQL**: el texto del cliente nunca se pega al SQL. La regla del curso: el valor viaja siempre por parámetro (`@patron` + objeto anónimo `new { ... }`); el SQL no se concatena nunca con datos recibidos | 4 |
| C1b | La comilla simple de `O'Brien` rompe la cadena del SQL: la consulta queda mal formada (error de sintaxis) o cambia de significado; es la manifestación concreta de la inyección | 4 |
| C2a | Las columnas de la base están en `snake_case` y las propiedades del record en PascalCase; Dapper empareja por nombre (ignora mayúsculas pero no el guión bajo). El `AS` deja cada columna con el nombre exacto de la propiedad | 4 |
| C2b | Esa columna no se mapea: la propiedad llega vacía en el JSON (`null` en textos, `0` en números), sin error explícito que lo avise | 3 |

## 4. Criterios de corrección ítem por ítem

### Parte 1 — Detalle de un médico (15 puntos)

| Qué se observa | Puntos |
| --- | --- |
| Ruta `GET /doctors/{id:long}` con parámetro tipado `long id` | 3 |
| `SELECT` con alias de columnas y `QueryFirstOrDefault` parametrizado (`@id`) | 5 |
| `200` con el médico encontrado (`Results.Ok`) | 3 |
| `404` con mensaje cuando el id no existe (`Results.NotFound`) | 4 |

### Parte 2 — Búsqueda por especialidad (25 puntos)

| Qué se observa | Puntos |
| --- | --- |
| Ruta `GET /doctors/search` con el texto por query string (`string? text`) | 3 |
| Validación del texto faltante con `IsNullOrWhiteSpace` y `400` con mensaje | 6 |
| `LIKE @patron` parametrizado con comodines armados en C# (nunca concatenado) | 6 |
| `404` con mensaje cuando no hay resultados | 5 |
| `200` con la lista y `ORDER BY` en el SQL | 5 |

### Parte 3 — Ingresos por médico (25 puntos)

| Qué se observa | Puntos |
| --- | --- |
| Ruta `GET /doctors/{id:long}/admissions` con parámetro tipado | 3 |
| `JOIN admissions` + `doctors` con `ON` correcto y alias de tabla (`a`, `d`) | 7 |
| Alias de todas las columnas del record, incluido el nombre concatenado con `\|\|` | 7 |
| `WHERE` parametrizado por el id del médico y `ORDER BY` por fecha de ingreso | 5 |
| `200` con la lista mapeada a `AdmissionOfDoctor` | 3 |

### Parte 4 — Alta de médicos (20 puntos)

| Qué se observa | Puntos |
| --- | --- |
| `POST /doctors` que lee el cuerpo con el record `DoctorInput` (sin id) | 3 |
| Validación de los tres campos obligatorios con `400` y mensaje | 5 |
| `INSERT` parametrizado sobre `doctors` | 4 |
| Id generado con `ExecuteScalar<long>` (`INSERT` + `last_insert_rowid()` juntos) | 4 |
| `201` con la URL del nuevo médico (`Results.Created`) y el recurso con su id real | 4 |

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
| Rutas en español (`/medicos`) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| 400/404 sin cuerpo de mensaje | `Results.NotFound()` a secas | Descuento parcial: el código correcto puntúa, el mensaje exigido no |
| `string text` sin `?` en la query string | El parámetro opcional se declaró obligatorio | Descuenta el punto de query string si provoca error en el camino sin texto; la validación con `IsNullOrWhiteSpace` sigue exigida |
| Ordenar en C# en vez de en SQL | `.OrderBy(...)` sobre la lista traída | Descuenta el punto de orden del ítem |
| Records movidos por encima de `app.Run()` | Error CS8803 al compilar | Avisar la causa no invalida la prueba; se corrige lo que alcance a compilar |
| El POST no recibe el cuerpo en curl | Falta `Content-Type: application/json` o comillas sin escapar | Es un problema de prueba, no de código: se orienta y no se descuenta |

## 6. Pauta de devolución (Encuentro 16)

- Corrección individual escrita ítem por ítem (qué puntúa, qué no y por qué), devuelta al **inicio del Encuentro 16**, junto con el resultado de la defensa por objetivo y el estado de la entrega del tp-u2.
- Comentarios generales al curso: aciertos más frecuentes (estructura de `Program.cs`, uso de `Results`) y errores comunes (parametrización del `LIKE`, alias de columnas, 400/404 sin mensaje).
- Los ítems y objetivos no alcanzados se traducen en pistas de recuperación para los encuentros de intensificación y fortalecimiento 17 y 18: cada alumno marca en su corrección los núcleos a reforzar (parametrización y validación; alias y records; JOIN; INSERT con id generado).
- La planilla de resultados registra alumno, versión (A), puntaje por parte, total sobre 100, resultado de la defensa por objetivo y observaciones para las intensificaciones.
