# Continuidad pedagógica 3 — Anexo docente: soluciones y criterios de corrección

> Uso exclusivo docente. Compañero del documento del alumno `continuidad-03-tras-evaluacion-u2.md`. Contiene la solución de referencia completa, las respuestas esperadas de cada actividad y los criterios de corrección. Los textos exactos de los mensajes 400/404 no se exigen literales: se exige que el cuerpo exista, con un mensaje en español. La cantidad de filas y los valores concretos dependen de la copia de `hospital.db`; la referencia del curso tiene 258 pacientes, 27 médicos, 306 ingresos y 13 provincias.

## 1. Panorama de la corrección

| Actividad | Puntos | Tiempo | Qué se verifica principalmente |
| --- | --- | --- | --- |
| 1. Puesta a punto del proyecto | 10 | 30 min | Proyecto corriendo con la base y los paquetes; GET /patients con 258 filas |
| 2. Repaso U1: verbos y códigos | 10 | 25 min | Cuadro 1 completo y correcto; respuestas (a) y (b) |
| 3. Lectura parametrizada | 20 | 50 min | Los tres endpoints con parametrización, orden, query string y 400/404 |
| 4. LIKE con validación | 20 | 45 min | Patrón parametrizado; 400 y 404 con mensaje; cuatro casos probados |
| 5. JOIN de dos tablas | 20 | 45 min | JOIN con alias y ON correctos; record compuesto con ProvinceName |
| 6. Escritura con Dapper | 20 | 45 min | Ciclo POST/PUT/DELETE con 201/204/400/404 y filas afectadas |
| **Total** | **100** | **240 min** | |

## 2. Solución de referencia: Program.cs completo

La solución final integra las seis actividades en un solo archivo. El proyecto crece por hitos: cada actividad agrega sus endpoints al mismo `Program.cs`.

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients: todos los pacientes, ordenados por apellido y nombre (Act. 1 y 3)
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Cada columna snake_case lleva su alias AS para coincidir con el record
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

// GET /patients/{id}: UN paciente por id, con 404 con mensaje (Act. 3)
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Consulta parametrizada: el hueco @id se completa con new { id }.
    // El valor nunca se pega al texto del SQL con +
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

    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente con ese id" });
    }

    return Results.Ok(patient);
});

// GET /patients/by-province?province=ON&limit=10: query string parametrizada (Act. 3)
app.MapGet("/patients/by-province", (string? province, string? limit) =>
{
    // Validacion: sin provincia no hay nada que buscar -> 400
    if (string.IsNullOrWhiteSpace(province))
    {
        return Results.BadRequest(new { mensaje = "Indique la provincia" });
    }

    // Si no vino ?limit=, se muestran 10; si vino y no es numero, 400.
    // En SQLite todo entero entra como long: long.TryParse cubre el limite
    long max = 10;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Igualdad exacta sobre el codigo de provincia; LIMIT parametrizado
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

    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "No hay pacientes de esa provincia" });
    }

    return Results.Ok(patients);
});

// GET /patients/by-allergy?allergy=Peni: busqueda parcial con LIKE (Act. 4)
app.MapGet("/patients/by-allergy", (string? allergy) =>
{
    // Validacion 1: sin texto no hay nada que buscar -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(allergy))
    {
        return Results.BadRequest(new { mensaje = "Indique una alergia para buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    // El patron se arma en C# y viaja parametrizado igual que cualquier valor
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
          WHERE allergies LIKE @patron
          ORDER BY last_name, first_name",
        new { patron = $"%{allergy}%" });

    // Validacion 2: el pedido era valido pero no hubo resultados -> 404
    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente con esa alergia" });
    }

    return Results.Ok(patients);
});

// GET /patients/with-province: JOIN de dos tablas (Act. 5)
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Alias de tabla: p = patients, pn = province_names.
    // ON es la regla de emparejamiento por la clave compartida
    var patients = connection.Query<PatientWithProvince>(
        @"SELECT p.patient_id  AS PatientId,
                 p.first_name  AS FirstName,
                 p.last_name   AS LastName,
                 p.gender      AS Gender,
                 p.birth_date  AS BirthDate,
                 p.city        AS City,
                 pn.province_name AS ProvinceName,
                 p.allergies   AS Allergies,
                 p.height      AS Height,
                 p.weight      AS Weight
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          ORDER BY p.last_name, p.first_name");

    return Results.Ok(patients);
});

// POST /doctors: ALTA de un medico (Act. 6)
app.MapPost("/doctors", (DoctorInput input) =>
{
    // Validacion: los tres datos del cuerpo son obligatorios
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

    // ExecuteScalar corre el INSERT y trae el id que SQLite asigno
    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Specialty });

    // 201 Created: URL del recurso nuevo + el recurso en el cuerpo
    var created = new Doctor(newId, input.FirstName, input.LastName, input.Specialty);
    return Results.Created($"/doctors/{newId}", created);
});

// PUT /doctors/{id}: REEMPLAZO de los datos del medico (Act. 6)
app.MapPut("/doctors/{id:long}", (long id, DoctorInput input) =>
{
    // Misma validacion que el alta
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Execute devuelve las filas afectadas: 0 significa id inexistente
    // y NADA se escribio. Ese 0 es el 404 de la escritura
    int rows = connection.Execute(
        @"UPDATE doctors
          SET first_name = @FirstName,
              last_name  = @LastName,
              specialty  = @Specialty
          WHERE doctor_id = @id",
        new { id, input.FirstName, input.LastName, input.Specialty });

    if (rows == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico con ese id" });
    }

    return Results.NoContent();   // 204: cambio hecho, respuesta sin cuerpo
});

// DELETE /doctors/{id}: BAJA del medico (Act. 6)
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Misma tecnica del PUT: filas afectadas 0 = id inexistente
    int rows = connection.Execute(
        "DELETE FROM doctors WHERE doctor_id = @id",
        new { id });

    if (rows == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico con ese id" });
    }

    return Results.NoContent();   // 204: borrado hecho, respuesta sin cuerpo
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Paciente: una fila de la tabla patients. Id SIEMPRE long, fecha SIEMPRE string
record Patient(
    long PatientId,      // id: SIEMPRE long (con int el mapeo falla con 500)
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd" (nunca DateTime)
    string? City,        // nullable: la columna acepta NULL
    string ProvinceId,
    string? Allergies,
    int? Height,         // altura en cm (medida, no id)
    int? Weight          // peso en kg
);

// Record COMPUESTO: columnas de patients + ProvinceName de province_names
record PatientWithProvince(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? City,
    string ProvinceName, // vive en province_names, llega por el JOIN
    string? Allergies,
    int? Height,
    int? Weight
);

// Medico: una fila de la tabla doctors (respuesta del GET y del POST)
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// Datos de entrada del POST y del PUT: llegan por el cuerpo del pedido
// en JSON; sin id, porque el id lo asigna la base en el alta
record DoctorInput(string FirstName, string LastName, string Specialty);
```

## 3. Soluciones y respuestas esperadas por actividad

### Actividad 1 — Puesta a punto del proyecto (10 puntos)

Salida esperada de `GET /patients` (258 objetos; estructura de referencia, los valores de fila dependen de la copia de la base):

```json
[
  {
    "patientId": 1,
    "firstName": "Susan",
    "lastName": "Zhang",
    "gender": "F",
    "birthDate": "1955-10-13",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": null,
    "height": 165,
    "weight": 68
  }
]
```

Verificaciones: 258 filas; propiedades en camelCase (`patientId`, `firstName`); campos vacíos como `null`; fecha en texto ISO. Respuesta escrita esperada: los datos viven en el archivo `hospital.db`, no en la memoria del programa; al apagar la API el archivo sigue en el disco y los datos permanecen.

### Actividad 2 — Repaso U1: verbos y códigos (10 puntos)

**Cuadro 1 resuelto:**

| Verbo | Para qué sirve en la API | Código de éxito típico | Método de `Results` |
| --- | --- | --- | --- |
| GET | Leer o listar recursos | 200 OK | `Results.Ok(dato)` |
| POST | Dar de alta un recurso nuevo | 201 Created | `Results.Created(url, dato)` |
| PUT | Reemplazar los datos de un recurso existente | 204 No Content | `Results.NoContent()` |
| DELETE | Dar de baja (borrar) un recurso | 204 No Content | `Results.NoContent()` |

> Regla del canon: el cuadro describe la API sobre `hospital.db` (Unidad 2 en adelante). En memoria (Unidad 1) el PUT de reemplazo responde `200 OK` con el recurso (`Results.Ok`); el DELETE es siempre `204 No Content`.

**(a)** Un 400 significa que el pedido está roto antes de consultar la base: falta un dato, viene vacío o no es un número válido. Un 404 significa que el pedido era correcto pero no hay nada que responder: el recurso no existe o la búsqueda no trajo resultados.

**(b)** El POST crea algo que antes no existía: se responde 201 con el recurso y la URL donde encontrarlo (encabezado `Location`). El DELETE no deja nada nuevo que mostrar: el 204 confirma que la operación quedó hecha, sin cuerpo.

### Actividad 3 — Lectura parametrizada (20 puntos)

Verificaciones por endpoint:

| Pedido | Respuesta esperada |
| --- | --- |
| `/patients` | 200 con los 258 pacientes ordenados por apellido y nombre |
| `/patients/7` | 200 con un solo objeto (valores según la copia de la base) |
| `/patients/99999` | 404 con `{"mensaje":"No existe el paciente con ese id"}` |
| `/patients/by-province?province=ON&limit=3` | 200 con hasta 3 pacientes de Ontario |
| `/patients/by-province?province=ON` | 200 con hasta 10 (valor por defecto) |
| `/patients/by-province?province=` | 400 con mensaje |
| `/patients/by-province?province=ZZ` | 404 con `{"mensaje":"No hay pacientes de esa provincia"}` |

Presentación escrita: el SELECT por id con sus diez alias, `new { id }` y la explicación: el valor viaja por un canal aparte (`new { id }`) hasta el hueco `@id`; pegarlo con `+` rompe las comillas (por ejemplo con `O'Brien`) y habilita la inyección SQL.

### Actividad 4 — LIKE con validación (20 puntos)

Casos esperados:

| Pedido | Respuesta esperada |
| --- | --- |
| `/patients/by-allergy?allergy=Peni` | 200 con los pacientes con alergia `Penicillin` (la alergia más común de la base) |
| `/patients/by-allergy?allergy=` | 400 con `{"mensaje":"Indique una alergia para buscar"}` |
| `/patients/by-allergy?allergy=Kryptonita` | 404 con `{"mensaje":"Ningun paciente con esa alergia"}` |
| `/patients/by-allergy?allergy=Sulfa` | 200 con los pacientes con `Sulfa` |

Detalle de corrección: el patrón `%...%` se arma en C# (`$"%{allergy}%"`) y viaja por `@patron`; los pacientes sin alergia (`NULL`) no aparecen en ninguna búsqueda con `LIKE`, y eso es correcto. En la tabla de casos se valora que los cuatro códigos (200, 400, 404, 200) estén justificados.

### Actividad 5 — JOIN de dos tablas (20 puntos)

Salida esperada de `/patients/with-province` (estructura; los valores dependen de la copia): cada paciente con `provinceName` completo (`"Ontario"`, no `"ON"`) y sin `provinceId`, porque el record compuesto lo reemplazó:

```json
[
  {
    "patientId": 1,
    "firstName": "Susan",
    "lastName": "Zhang",
    "gender": "F",
    "birthDate": "1955-10-13",
    "city": "Toronto",
    "provinceName": "Ontario",
    "allergies": null,
    "height": 165,
    "weight": 68
  }
]
```

Dibujo esperado: dos rectángulos (`patients` con `province_id`; `province_names` con `province_id` y `province_name`) y una flecha del `province_id` del paciente al `province_id` de la provincia, rotulada `ON`. Explicación esperada: pedir `province_id` a secas produce el error `ambiguous column name: province_id`, porque la columna existe en las dos tablas; cada mención se califica con el alias (`p.province_id`, `pn.province_id`).

### Actividad 6 — Escritura con Dapper (20 puntos)

Ciclo de referencia con `curl.exe` (el id lo asigna la base; en la copia de referencia, con 27 médicos originales, el nuevo es el 28):

| Paso | Pedido | Respuesta esperada |
| --- | --- | --- |
| Alta | `POST /doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | 201 con `{"doctorId":28,"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` y encabezado `Location: http://localhost:5080/doctors/28` |
| Lectura | `GET /doctors/28` | 200 con el médico nuevo |
| Cambio | `PUT /doctors/28` con `"specialty":"Neurologist"` | 204 sin cuerpo; el GET posterior muestra `Neurologist` |
| Baja | `DELETE /doctors/28` | 204 sin cuerpo |
| Verificación | `GET /doctors/28` | 404 con `{"mensaje":"No existe el medico con ese id"}` |

**Cuadro 2 resuelto:**

| Operación | Método de Dapper | Respuesta si todo sale bien | Respuesta si el id no existe |
| --- | --- | --- | --- |
| Alta (POST /doctors) | `ExecuteScalar<long>` (INSERT + `last_insert_rowid()`) | 201 Created con la URL del recurso nuevo | No aplica: el id lo asigna la base en el alta |
| Cambio (PUT /doctors/{id}) | `Execute` (UPDATE) | 204 No Content | 404 con mensaje (filas afectadas = 0) |
| Baja (DELETE /doctors/{id}) | `Execute` (DELETE) | 204 No Content | 404 con mensaje (filas afectadas = 0) |

Detalle de corrección: la persistencia se comprueba cortando la API con `Ctrl+C`, volviendo a correr `dotnet run` y repitiendo el GET del médico creado antes de la baja. Si un grupo intentó borrar un médico original con ingresos (por ejemplo el 7), obtuvo un 500 con `SQLite Error 19: 'FOREIGN KEY constraint failed'`: la base protegió su integridad. No se penaliza el intento si el grupo lo documenta; la baja exigida se prueba con el médico creado por el propio POST.

## 4. Criterios de corrección

El texto exacto de los mensajes 400/404 no se exige literal: se exige el código correcto con un cuerpo legible en español. Los ítems de funcionamiento se verifican sobre la API del grupo; los ítems de presentación, sobre la entrega manuscrita individual.

| Actividad | Ítem | Puntos |
| --- | --- | --- |
| 1 (10) | Proyecto compila y corre con `dotnet run` | 3 |
| | `hospital.db` junto al `.csproj` y los dos paquetes agregados | 3 |
| | `GET /patients` responde 200 con las 258 filas | 2 |
| | Presentación: filas anotadas, camelCase y explicación de la persistencia | 2 |
| 2 (10) | Cuadro 1 completo y correcto (verbo, uso, código y método por fila) | 6 |
| | Respuesta (a): diferencia 400/404 | 2 |
| | Respuesta (b): 201 con recurso contra 204 sin cuerpo | 2 |
| 3 (20) | `/patients/{id:long}` con `QueryFirstOrDefault`, parametrizada y 404 con mensaje | 7 |
| | `/patients` con `ORDER BY last_name, first_name` en el SQL | 4 |
| | `/by-province` con query string, `LIMIT @max` parametrizado y valor por defecto 10 | 5 |
| | 400 si falta la provincia y 404 si no hay resultados | 2 |
| | Presentación: SELECT con alias, objeto anónimo y explicación de la parametrización | 2 |
| 4 (20) | Validación `IsNullOrWhiteSpace` con 400 y mensaje | 5 |
| | Patrón `%...%` armado en C# y viajando por `@patron` | 5 |
| | 404 con mensaje cuando no hay resultados | 4 |
| | Los cuatro casos probados y registrados con su código | 4 |
| | Presentación: endpoint copiado y tabla de casos | 2 |
| 5 (20) | JOIN con alias de tabla y `ON p.province_id = pn.province_id` correctos | 7 |
| | Record compuesto con `ProvinceName` y alias `AS` por columna | 5 |
| | Respuesta con el nombre de provincia (y sin `provinceId`) | 4 |
| | Explicación de la columna ambigua | 2 |
| | Presentación: dibujo del cruce y record copiado | 2 |
| 6 (20) | POST con validación 400, `ExecuteScalar<long>` y 201 con `Results.Created` | 6 |
| | PUT con `Execute`, filas afectadas y 204/404 correctos | 5 |
| | DELETE con la misma técnica y 204/404 correctos | 4 |
| | Ciclo completo probado con `curl.exe` y documentado | 3 |
| | Presentación: Cuadro 2 completo y las líneas de curl con sus códigos | 2 |

## 5. Errores frecuentes esperados

| Error observado | Causa | Atención en la corrección |
| --- | --- | --- |
| 500 al pedir `/patients` | Id declarado `int` en el record | Señalar la regla: los ids son `long`; el error completo está en la terminal de `dotnet run` |
| Propiedad del record en `null` o `0` | Falta un alias `AS` | Revisar el SELECT columna por columna contra el record |
| Consulta concatenada con `+` | Costumbre previa al curso | Es el ítem de parametrización: no otorgar esos puntos hasta la corrección |
| Búsqueda que devuelve `[]` en lugar de 404 | Falta el chequeo `Count() == 0` | Recordar el criterio: en las búsquedas de esta continuidad, vacío se dice con 404 y palabra |
| `ambiguous column name` en el JOIN | Columna sin calificar con alias de tabla | Marcar el dibujo del cruce: la flecha del `ON` y el alias de cada columna |
| 500 `FOREIGN KEY constraint failed` al borrar | Médico original con ingresos en `admissions` | Explicar que la base protege su integridad; la baja se prueba con el médico del POST |
| 201 sin encabezado `Location` | `Results.Ok` en lugar de `Results.Created(url, dato)` | Diferenciar ambos métodos; la URL lleva el id recién asignado |
| `last_insert_rowid()` devuelve 0 | INSERT y `SELECT` en llamadas o conexiones distintas | Ambas consultas van juntas en la misma `ExecuteScalar<long>` |

## 6. Registro del resultado

El puntaje sobre 100 de cada presentación se registra como una actividad más de la asignatura, dentro del proceso de evaluación, junto con observaciones cualitativas por estudiante (comprensión evidenciada en la entrega manuscrita, errores frecuentes del grupo, consultas pendientes de la autoevaluación). Las filas «Todavía no» de las autoevaluaciones se relevan al inicio de la clase siguiente y orientan la revisión de los núcleos con mayor dificultad.
