# Anexo docente — Evaluación del momento de intensificación y fortalecimiento 17-18 (versiones A y B)

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de las versiones A y B, las respuestas esperadas, los criterios de Apto por objetivo mínimo, los errores previstos y la pauta de registro y devolución. El archivo base es `evaluacion-intensificaciones-17-18.md`.

## 1. Solución completa de la versión A (`Program.cs`)

```csharp
// Program.cs - intensificaciones-17-18 - Version A (solucion del docente)
// Nucleos de las Unidades 1 y 2 sobre hospital.db: medicos y sus ingresos

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2 =====

// GET /doctors/{id:long}: un medico segun su id, o 404
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Alias AS para que cada columna snake_case encaje en el record
    var doctor = connection.QueryFirstOrDefault<DoctorCard>(
        @"SELECT doctor_id AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE doctor_id = @id",
        new { id });   // Consulta SIEMPRE parametrizada: nunca concatenar el id

    // Sin fila: 404 con mensaje. Con fila: 200 con el medico
    return doctor is null
        ? Results.NotFound(new { mensaje = "No existe ese medico" })
        : Results.Ok(doctor);
});

// ===== Item 3 =====

// GET /doctors?specialty=...: medicos cuya especialidad contiene el texto
app.MapGet("/doctors", (string? specialty) =>
{
    // Validacion manual: la busqueda no puede llegar vacia (400 con mensaje)
    if (string.IsNullOrWhiteSpace(specialty))
    {
        return Results.BadRequest(new { mensaje = "El texto de busqueda es obligatorio" });
    }

    using var connection = new SqliteConnection(connectionString);

    // LIKE con el comodin % alrededor del parametro: busqueda parcial.
    // El patron viaja por parametro @patron, nunca pegado al SQL
    var doctors = connection.Query<DoctorCard>(
        @"SELECT doctor_id AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE specialty LIKE @patron
          ORDER BY last_name",
        new { patron = "%" + specialty + "%" });

    // 200 con la lista serializada a JSON (lista vacia si no hay coincidencias)
    return Results.Ok(doctors);
});

// ===== Item 4 =====

// GET /doctors/{id:long}/admissions: ingresos atendidos por un medico
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN de dos tablas: cada ingreso se cruza con su medico tratante;
    // el nombre completo se arma concatenando en SQL
    var admissions = connection.Query<AdmissionOfDoctor>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.diagnosis      AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.attending_doctor_id = @id
          ORDER BY a.admission_date",
        new { id });

    // 200 con la lista (vacia si el medico no tiene ingresos)
    return Results.Ok(admissions);
});

// ===== Item 5 =====

// POST /doctors: alta de un medico con validacion manual
app.MapPost("/doctors", (DoctorInput input) =>
{
    // Los tres campos obligatorios de la tabla doctors
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Nombre, apellido y especialidad son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado + last_insert_rowid() devuelve el id generado
    var newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Specialty });

    // 201 con la URL del recurso nuevo y el medico creado
    return Results.Created($"/doctors/{newId}",
        new DoctorCard(newId, input.FirstName, input.LastName, input.Specialty));
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record DoctorCard(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
record DoctorInput(string FirstName, string LastName, string Specialty);
```

Aceptaciones válidas menores: `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`; `Results.Ok(connection.Query<...>(...))` sin variable intermedia; orden por `specialty` o `first_name` en el Ítem 3 en lugar de `last_name`; `LIKE @patron` con el patrón armado en una variable previa (`var patron = $"%{specialty}%"`). No se acepta `TypedResults` (canon del curso: `Results` en .NET 6) ni SQL concatenado.

## 2. Respuestas esperadas de la versión A

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/doctors/1` | `200` con `{"doctorId":1,"firstName":"...","lastName":"...","specialty":"..."}` |
| `GET http://localhost:5080/doctors/999` | `404` con `{"mensaje":"No existe ese medico"}` |
| `GET http://localhost:5080/doctors?specialty=cardio` | `200` con la lista de médicos cuya `specialty` contiene «cardio» (Cardiologist, Cardiovascular Surgeon, ...) en JSON camelCase |
| `GET http://localhost:5080/doctors?specialty=xyz` | `200` con `[]` (lista vacía: no hay coincidencias) |
| `GET http://localhost:5080/doctors?specialty=` | `400` con `{"mensaje":"El texto de busqueda es obligatorio"}` |
| `GET http://localhost:5080/doctors/1/admissions` | `200` con los ingresos del médico 1: `[{"admissionDate":"...","diagnosis":"...","doctorName":"Nombre Apellido"}, ...]` |
| `POST /doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | `201`, encabezado `Location: /doctors/28` (27 médicos en la base), cuerpo con `doctorId` generado |
| `POST /doctors` con `{"firstName":"Ana","lastName":"","specialty":"Cardiologist"}` | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"
curl.exe -i http://localhost:5080/doctors/999
```

## 3. Solución completa de la versión B (`Program.cs`)

```csharp
// Program.cs - intensificaciones-17-18 - Version B (solucion del docente)
// Nucleos de las Unidades 1 y 2 sobre hospital.db: pacientes y sus ingresos

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2 =====

// GET /patients/{id:long}: un paciente segun su id, o 404
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Alias AS para que cada columna snake_case encaje en el record;
    // city es nullable en la tabla, por eso el string? del record
    var patient = connection.QueryFirstOrDefault<PatientCard>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 city       AS City
          FROM patients
          WHERE patient_id = @id",
        new { id });   // Consulta SIEMPRE parametrizada: nunca concatenar el id

    // Sin fila: 404 con mensaje. Con fila: 200 con el paciente
    return patient is null
        ? Results.NotFound(new { mensaje = "No existe ese paciente" })
        : Results.Ok(patient);
});

// ===== Item 3 =====

// GET /patients?city=...: pacientes cuya ciudad contiene el texto
app.MapGet("/patients", (string? city) =>
{
    // Validacion manual: la busqueda no puede llegar vacia (400 con mensaje)
    if (string.IsNullOrWhiteSpace(city))
    {
        return Results.BadRequest(new { mensaje = "El texto de busqueda es obligatorio" });
    }

    using var connection = new SqliteConnection(connectionString);

    // LIKE con el comodin % alrededor del parametro: busqueda parcial.
    // El patron viaja por parametro @patron, nunca pegado al SQL.
    // Las filas con city NULL quedan afuera: NULL no coincide con LIKE
    var patients = connection.Query<PatientCard>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 city       AS City
          FROM patients
          WHERE city LIKE @patron
          ORDER BY last_name",
        new { patron = "%" + city + "%" });

    // 200 con la lista serializada a JSON (lista vacia si no hay coincidencias)
    return Results.Ok(patients);
});

// ===== Item 4 =====

// GET /patients/{id:long}/admissions: ingresos del paciente
app.MapGet("/patients/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN de dos tablas: cada ingreso se cruza con su paciente;
    // el nombre completo se arma concatenando en SQL
    var admissions = connection.Query<AdmissionOfPatient>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.diagnosis      AS Diagnosis,
                 p.first_name || ' ' || p.last_name AS PatientName
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          WHERE a.patient_id = @id
          ORDER BY a.admission_date",
        new { id });

    // 200 con la lista (vacia si el paciente no tiene ingresos)
    return Results.Ok(admissions);
});

// ===== Item 5 =====

// POST /patients: alta de un paciente con validacion manual
app.MapPost("/patients", (PatientInput input) =>
{
    // Los cinco campos obligatorios de la tabla patients
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Gender) ||
        string.IsNullOrWhiteSpace(input.BirthDate) ||
        string.IsNullOrWhiteSpace(input.ProvinceId))
    {
        return Results.BadRequest(new { mensaje = "Nombre, apellido, genero, fecha de nacimiento y provincia son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado + last_insert_rowid() devuelve el id generado.
    // Las columnas que quedan afuera (city, allergies, height, weight) aceptan NULL
    var newId = connection.ExecuteScalar<long>(
        @"INSERT INTO patients (first_name, last_name, gender, birth_date, province_id)
          VALUES (@FirstName, @LastName, @Gender, @BirthDate, @ProvinceId);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Gender, input.BirthDate, input.ProvinceId });

    // 201 con la URL del recurso nuevo y el paciente creado (aun sin ciudad)
    return Results.Created($"/patients/{newId}",
        new PatientCard(newId, input.FirstName, input.LastName, null));
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record PatientCard(long PatientId, string FirstName, string LastName, string? City);
record AdmissionOfPatient(string AdmissionDate, string? Diagnosis, string PatientName);
record PatientInput(string FirstName, string LastName, string Gender, string BirthDate, string ProvinceId);
```

Aceptaciones válidas menores: idénticas a la versión A. La cantidad de campos validados en el Ítem 5 (cinco en B, tres en A) es la que fija cada tabla; la regla es la misma (campos obligatorios no vacíos).

## 4. Respuestas esperadas de la versión B

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/patients/1` | `200` con `{"patientId":1,"firstName":"...","lastName":"...","city":"..."}` |
| `GET http://localhost:5080/patients/999` | `404` con `{"mensaje":"No existe ese paciente"}` |
| `GET http://localhost:5080/patients?city=Toronto` | `200` con la lista de pacientes cuya `city` contiene «Toronto» en JSON camelCase |
| `GET http://localhost:5080/patients?city=xyz` | `200` con `[]` (lista vacía: no hay coincidencias) |
| `GET http://localhost:5080/patients?city=` | `400` con `{"mensaje":"El texto de busqueda es obligatorio"}` |
| `GET http://localhost:5080/patients/1/admissions` | `200` con los ingresos del paciente 1: `[{"admissionDate":"...","diagnosis":"...","patientName":"Nombre Apellido"}, ...]` |
| `POST /patients` con `{"firstName":"Ana","lastName":"Garcia","gender":"F","birthDate":"2001-03-14","provinceId":"ON"}` | `201`, encabezado `Location: /patients/259` (258 pacientes en la base), cuerpo con `patientId` generado y `city` en `null` |
| `POST /patients` sin `birthDate` | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"
curl.exe -i http://localhost:5080/patients/999
```

## 5. Criterios de Apto por objetivo mínimo

Cada objetivo se registra Apto o No apto aún; ningún objetivo requiere puntaje numérico. Los ítems que evidencian cada objetivo son los mismos en las dos versiones.

| Nº | Objetivo mínimo | Evidencia en la prueba | Apto cuando |
| --- | --- | --- | --- |
| OM1 | Crear y correr la API | Ítem 1 | El proyecto se creó con `dotnet new web`, los paquetes están agregados, `hospital.db` está junto al `.csproj`, la API corre con `dotnet run` y se probó un GET en el navegador |
| OM2 | Endpoint con parámetro | Ítem 2 | La ruta lleva `{id:long}` con el parámetro tipado `long`; el id existente responde `200` y el inexistente `404` con mensaje |
| OM3 | Verbos y códigos de respuesta | Ítems 2, 3 y 5 | Todas las respuestas usan `Results` explícito; los `400` y `404` llevan cuerpo con `mensaje` en español; el `POST` responde `201` con la URL del recurso nuevo |
| OM4 | SELECT/WHERE/LIKE con Dapper | Ítems 2 y 3 | La conexión se abre con `using` dentro del handler; las columnas `snake_case` llevan alias `AS`; la consulta y el patrón del `LIKE` viajan por parámetro (nunca concatenados) |
| OM5 | JOIN de dos tablas | Ítem 4 | El `JOIN ... ON` empareja las claves correctas; el record compuesto reúne columnas de ambas tablas (incluido el nombre concatenado) y se devuelve con `200` |
| OM6 | Escritura validada | Ítem 5 | La validación de los campos obligatorios corre antes de consultar la base; el `INSERT` es parametrizado; el id se obtiene con `ExecuteScalar<long>` y se responde `201` con la URL |
| OM7 | Ciclo de entrega GitHub | Ítem 6 | El trabajo quedó en `intensificaciones-17-18/` dentro del repositorio del grupo, con commits referentes por ítem y push visible en GitHub |

## 6. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en `GET .../{id:long}` | Record con tipos distintos al alias, o `int` en el id | Intervenir en el momento (es núcleo de la unidad); el objetivo afectado se evalúa con lo que alcance a corregir |
| SQL con el texto concatenado (`"... LIKE '%" + city + "%'"`) | No parametrizó | OM4 queda No apto aún: la parametrización es canon de seguridad de la unidad |
| `TypedResults` en las respuestas | Confusión de versión | Se orienta al canon (`Results` en .NET 6); si corrige en el momento, el objetivo se evalúa con la versión corregida |
| Búsqueda que solo encuentra coincidencia exacta | `LIKE` sin los comodines `%` | OM4 queda No apto aún en su componente de búsqueda parcial; los ítems 2 y 5 se evalúan por separado |
| `400`/`404` sin cuerpo de mensaje | Respondió `Results.NotFound()` a secas | OM3 queda No apto aún; el resto de los objetivos de esos ítems se evalúan con normalidad |
| Rutas en español (`/medicos`, `/pacientes`) | Canon de rutas incumplido | Se orienta la corrección en el momento; el objetivo se evalúa con la ruta corregida |
| Records movidos por encima de `app.Run()` | Error CS8803 al compilar | Intervenir en el momento; se evalúa lo que alcance a compilar |
| `no such table` al consultar | `hospital.db` fuera de la raíz del proyecto | Intervenir en el momento: mover la base no invalida el ítem (es parte del OM1) |
| Push ausente al cierre | Entrega incompleta | OM7 se evalúa con lo que esté visible en GitHub al momento de la verificación del plenario de cierre |

## 7. Registro del resultado y pauta de devolución

- Planilla de resultados (registro docente formal): alumno, versión (A o B) y resultado Apto / No apto aún de cada objetivo (OM1 a OM7), con observación breve del criterio no cumplido.
- La verificación de la entrega por GitHub se realiza en los primeros 15 minutos del plenario de cierre del Encuentro 18; el docente confirma la carpeta `intensificaciones-17-18/`, los commits y el push de cada alumno presente.
- Devolución individual escrita al inicio del Encuentro 19, junto con la apertura del proyecto puente: cada alumno recibe su fila de objetivos con el estado alcanzado y los núcleos a reforzar.
- Los objetivos No apto aún se traducen en la agenda de intensificación de diciembre (y, de ser necesario, marzo): mismos núcleos, misma tabla de objetivos mínimos.
- Comentarios generales al curso en el plenario de cierre del Encuentro 18: los logros más frecuentes de cada pista y los errores comunes vistos en la prueba.
