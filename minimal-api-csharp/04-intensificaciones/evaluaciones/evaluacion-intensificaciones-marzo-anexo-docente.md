# Anexo docente — Evaluación de la intensificación de marzo (versiones A y B)

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de las versiones A y B, las respuestas esperadas, los criterios de logro por objetivo mínimo, los errores previstos y la pauta de registro y devolución. El archivo base es `evaluacion-intensificaciones-marzo.md`.

## 1. Solución completa de la versión A (`Program.cs`)

```csharp
// Program.cs - intensificaciones-marzo - Version A (solucion del docente)
// Camino minimo completo del curso sobre hospital.db: ingresos y medicos

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2 =====

// GET /admissions/{patientId}/{admissionDate}: el ingreso de un paciente en una fecha
app.MapGet("/admissions/{patientId:long}/{admissionDate}", (long patientId, string admissionDate) =>
{
    using var connection = new SqliteConnection(connectionString);

    // La clave del ingreso es compuesta: paciente + fecha de ingreso.
    // Alias AS para que cada columna snake_case encaje en el record
    var admission = connection.QueryFirstOrDefault<AdmissionDetails>(
        @"SELECT admission_date AS AdmissionDate,
                 discharge_date AS DischargeDate,
                 diagnosis      AS Diagnosis
          FROM admissions
          WHERE patient_id = @patientId AND admission_date = @admissionDate",
        new { patientId, admissionDate });   // Consulta SIEMPRE parametrizada

    // Sin fila: 404 con mensaje. Con fila: 200 con el ingreso
    return admission is null
        ? Results.NotFound(new { mensaje = "No existe ese ingreso" })
        : Results.Ok(admission);
});

// ===== Item 3 =====

// GET /admissions?text=...: ingresos cuyo medico tratante tiene apellido parecido al texto
app.MapGet("/admissions", (string? text) =>
{
    // El logro del item se evalua por la busqueda con LIKE y el 200;
    // el control de texto vacio es de buen trato y no es obligatorio aqui
    if (string.IsNullOrWhiteSpace(text))
    {
        return Results.BadRequest(new { mensaje = "El texto de busqueda es obligatorio" });
    }

    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines % alrededor del parametro: busqueda parcial.
    // El patron viaja por parametro @patron, nunca pegado al SQL
    var admissions = connection.Query<AdmissionSearch>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.diagnosis      AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE d.last_name LIKE @patron
          ORDER BY a.admission_date",
        new { patron = "%" + text + "%" });

    // 200 con la lista serializada a JSON (lista vacia si no hay coincidencias)
    return Results.Ok(admissions);
});

// ===== Item 4 =====

// GET /reports/admissions-by-doctor: ingresos cerrados por medico tratante
app.MapGet("/reports/admissions-by-doctor", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN de las tres tablas + GROUP BY + COUNT(*).
    // Dato sucio: discharge_date en NULL es un ingreso abierto y queda fuera
    var report = connection.Query<AdmissionsByDoctor>(
        @"SELECT d.first_name || ' ' || d.last_name AS DoctorName,
                 COUNT(*) AS Total
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.discharge_date IS NOT NULL
          GROUP BY d.first_name || ' ' || d.last_name
          ORDER BY Total DESC");

    // 200 con el reporte ordenado de mas a menos ingresos
    return Results.Ok(report);
});

// ===== Item 5 =====

// POST /admissions: alta de un ingreso con validacion manual
app.MapPost("/admissions", (AdmissionInput input) =>
{
    // Campos obligatorios de la tabla admissions: paciente, fecha de ingreso
    // y medico tratante (los ids numericos se validan distintos de 0)
    if (input.PatientId == 0 ||
        string.IsNullOrWhiteSpace(input.AdmissionDate) ||
        input.AttendingDoctorId == 0)
    {
        return Results.BadRequest(new { mensaje = "Paciente, fecha de ingreso y medico tratante son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado. La clave es compuesta (paciente + fecha):
    // no hay id numerico generado que recuperar
    connection.Execute(
        @"INSERT INTO admissions (patient_id, admission_date, diagnosis, attending_doctor_id)
          VALUES (@PatientId, @AdmissionDate, @Diagnosis, @AttendingDoctorId)",
        new { input.PatientId, input.AdmissionDate, input.Diagnosis, input.AttendingDoctorId });

    // 201 con la URL del ingreso nuevo (la fecha de alta queda en NULL: ingreso abierto)
    return Results.Created($"/admissions/{input.PatientId}/{input.AdmissionDate}",
        new AdmissionDetails(input.AdmissionDate, null, input.Diagnosis));
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record AdmissionDetails(string AdmissionDate, string? DischargeDate, string? Diagnosis);
record AdmissionSearch(string AdmissionDate, string? Diagnosis, string DoctorName);
record AdmissionsByDoctor(string DoctorName, int Total);
record AdmissionInput(long PatientId, string AdmissionDate, string? Diagnosis, long AttendingDoctorId);
```

Aceptaciones válidas menores: `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`; `Results.Ok(connection.Query<...>(...))` sin variable intermedia; el patrón del `LIKE` armado en una variable previa (`var patron = $"%{text}%"`); en el ítem 4, `GROUP BY` por las columnas del nombre (`d.first_name, d.last_name`) en lugar de la concatenación; sin el control de texto vacío del ítem 3 (solo se exige la búsqueda con `LIKE` y el `200`). No se acepta `TypedResults` (canon del curso: `Results` en .NET 6) ni SQL concatenado.

## 2. Respuestas esperadas de la versión A

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/admissions/1/2018-11-06` | `200` con `{"admissionDate":"2018-11-06","dischargeDate":"2018-11-08","diagnosis":"Ovarian Dermoid-Cyct"}` |
| `GET http://localhost:5080/admissions/1/2018-01-01` | `404` con `{"mensaje":"No existe ese ingreso"}` |
| `GET http://localhost:5080/admissions?text=green` | `200` con los ingresos cuyo médico tratante tiene un apellido que contiene «green» (p. ej., los atendidos por Joshua Green), con fecha, diagnóstico y nombre completo, ordenados por fecha |
| `GET http://localhost:5080/admissions?text=xyz` | `200` con `[]` (lista vacía: no hay coincidencias) |
| `GET http://localhost:5080/reports/admissions-by-doctor` | `200` con la lista de médicos (nombre completo) y sus ingresos cerrados, de más a menos ingresos, sin los ingresos abiertos |
| `POST /admissions` con `{"patientId":1,"admissionDate":"2019-06-10","diagnosis":"Control","attendingDoctorId":2}` | `201`, encabezado `Location: /admissions/1/2019-06-10`, cuerpo con el ingreso y fecha de alta en `null` |
| `POST /admissions` con `attendingDoctorId` en `0` | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe -X POST http://localhost:5080/admissions -H "Content-Type: application/json" -d "{\"patientId\":1,\"admissionDate\":\"2019-06-10\",\"diagnosis\":\"Control\",\"attendingDoctorId\":2}"
curl.exe -i http://localhost:5080/admissions/1/2018-01-01
```

## 3. Solución completa de la versión B (`Program.cs`)

```csharp
// Program.cs - intensificaciones-marzo - Version B (solucion del docente)
// Camino minimo completo del curso sobre hospital.db: provincias y pacientes

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2 =====

// GET /provinces/{provinceId}: una provincia segun su codigo, o 404
app.MapGet("/provinces/{provinceId}", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // La clave de province_names es de texto: el codigo llega por la ruta.
    // Alias AS para que cada columna snake_case encaje en el record
    var province = connection.QueryFirstOrDefault<ProvinceCard>(
        @"SELECT province_id   AS ProvinceId,
                 province_name AS ProvinceName
          FROM province_names
          WHERE province_id = @provinceId",
        new { provinceId });   // Consulta SIEMPRE parametrizada

    // Sin fila: 404 con mensaje. Con fila: 200 con la provincia
    return province is null
        ? Results.NotFound(new { mensaje = "No existe esa provincia" })
        : Results.Ok(province);
});

// ===== Item 3 =====

// GET /patients?text=...: pacientes cuya alergia es parecida al texto
app.MapGet("/patients", (string? text) =>
{
    // El logro del item se evalua por la busqueda con LIKE y el 200;
    // el control de texto vacio es de buen trato y no es obligatorio aqui
    if (string.IsNullOrWhiteSpace(text))
    {
        return Results.BadRequest(new { mensaje = "El texto de busqueda es obligatorio" });
    }

    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines % alrededor del parametro: busqueda parcial.
    // Las filas con allergies NULL no coinciden nunca: NULL no pasa el LIKE
    var patients = connection.Query<PatientSearch>(
        @"SELECT p.first_name AS FirstName,
                 p.last_name  AS LastName,
                 pn.province_name AS ProvinceName
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE p.allergies LIKE @patron
          ORDER BY p.last_name",
        new { patron = "%" + text + "%" });

    // 200 con la lista serializada a JSON (lista vacia si no hay coincidencias)
    return Results.Ok(patients);
});

// ===== Item 4 =====

// GET /reports/admissions-by-gender: ingresos cerrados por genero del paciente
app.MapGet("/reports/admissions-by-gender", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN de las tres tablas + GROUP BY + COUNT(*).
    // Dato sucio: discharge_date en NULL es un ingreso abierto y queda fuera
    var report = connection.Query<AdmissionsByGender>(
        @"SELECT p.gender AS Gender,
                 COUNT(*) AS Total
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE a.discharge_date IS NOT NULL
          GROUP BY p.gender
          ORDER BY Total DESC");

    // 200 con el reporte ordenado de mas a menos ingresos
    return Results.Ok(report);
});

// ===== Item 5 =====

// POST /provinces: alta de una provincia o territorio con validacion manual
app.MapPost("/provinces", (ProvinceInput input) =>
{
    // Campos obligatorios de la tabla province_names: codigo y nombre
    if (string.IsNullOrWhiteSpace(input.ProvinceId) ||
        string.IsNullOrWhiteSpace(input.ProvinceName))
    {
        return Results.BadRequest(new { mensaje = "El codigo y el nombre de la provincia son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado. La clave es el codigo de texto que llega en el
    // cuerpo: province_names no genera ids numericos
    connection.Execute(
        @"INSERT INTO province_names (province_id, province_name)
          VALUES (@ProvinceId, @ProvinceName)",
        new { input.ProvinceId, input.ProvinceName });

    // 201 con la URL de la provincia nueva
    return Results.Created($"/provinces/{input.ProvinceId}",
        new ProvinceCard(input.ProvinceId, input.ProvinceName));
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record ProvinceCard(string ProvinceId, string ProvinceName);
record PatientSearch(string FirstName, string LastName, string ProvinceName);
record AdmissionsByGender(string Gender, int Total);
record ProvinceInput(string ProvinceId, string ProvinceName);
```

Aceptaciones válidas menores: idénticas a la versión A. La cantidad de campos validados en el ítem 5 (tres en A, dos en B) es la que fija cada tabla; la regla es la misma (campos obligatorios no vacíos, ids numéricos distintos de 0). En ambas versiones la clave del recurso nuevo viaja en el cuerpo, porque `admissions` y `province_names` no generan id numérico.

## 4. Respuestas esperadas de la versión B

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/provinces/ON` | `200` con `{"provinceId":"ON","provinceName":"Ontario"}` |
| `GET http://localhost:5080/provinces/XX` | `404` con `{"mensaje":"No existe esa provincia"}` |
| `GET http://localhost:5080/patients?text=peni` | `200` con los pacientes con una alergia que contiene «peni» (Penicillin), con nombre, apellido y provincia, ordenados por apellido; los pacientes sin alergia registrada no aparecen |
| `GET http://localhost:5080/patients?text=xyz` | `200` con `[]` (lista vacía: no hay coincidencias) |
| `GET http://localhost:5080/reports/admissions-by-gender` | `200` con los ingresos cerrados por género (`M`/`F`), de más a menos, sin los ingresos abiertos |
| `POST /provinces` con `{"provinceId":"XN","provinceName":"Nueva Region"}` | `201`, encabezado `Location: /provinces/XN`, cuerpo con la provincia creada |
| `POST /provinces` con `{"provinceId":"XN"}` (sin nombre) | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe -X POST http://localhost:5080/provinces -H "Content-Type: application/json" -d "{\"provinceId\":\"XN\",\"provinceName\":\"Nueva Region\"}"
curl.exe -i http://localhost:5080/provinces/XX
```

## 5. Criterios de logro por objetivo mínimo (Apto / No apto aún)

Cada objetivo se registra Logrado o No logrado aún; ningún objetivo requiere puntaje numérico. Los ítems que evidencian cada objetivo son los mismos en las dos versiones y en las de diciembre.

| Objetivo | Evidencia | Logrado cuando |
| --- | --- | --- |
| Unidad 1 — API, endpoints y entrega | Ítems 1, 2, 5 y 6 | El proyecto se creó con `dotnet new web`, corre con `dotnet run` y se probó un GET en el navegador (ítem 1); el endpoint con parámetro de ruta responde `200` con el dato y `404` con mensaje (ítem 2); todas las respuestas usan `Results` explícito y el alta responde `201` con la URL del recurso nuevo o `400` con mensaje (ítem 5); el trabajo quedó en `intensificaciones-marzo/` con commits referentes y push visible en GitHub (ítem 6) |
| Unidad 2 — Consultas y escritura con Dapper | Ítems 2, 3 y 5 | La conexión se abre con `using` dentro del handler; las columnas `snake_case` llevan alias `AS`; la consulta y el patrón del `LIKE` viajan por parámetro, nunca concatenados (ítems 2 y 3); la validación manual de los campos obligatorios corre antes de consultar la base y el `INSERT` es parametrizado, con `201` y `400` (ítem 5) |
| Unidad 3 — Reporte e integración | Ítem 4 | El `JOIN ... ON` une las tres tablas con las claves correctas; agrupa con `GROUP BY` y cuenta con `COUNT(*)`; el filtro del dato sucio (`discharge_date IS NOT NULL`) excluye los ingresos abiertos; el resultado llega ordenado de más a menos |
| Unidad 4 — Flujo profesional del repositorio | Ítem 6 | Quedan el `README.md` breve en la carpeta del ejercicio, el issue «Intensificación de marzo», la rama `feature/marzo` con commits referentes, el pull request revisado y la fusión a `main` protegida |

## 6. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en los GET | Record con tipos distintos al alias, o `int` en el id | Intervenir en el momento (es núcleo de la unidad); el objetivo afectado se evalúa con lo que alcance a corregir |
| SQL con el texto concatenado (`"... LIKE '%" + text + "%'"`) | No parametrizó | Unidad 2 queda No logrado aún en su componente de parametrización: es canon de seguridad |
| `TypedResults` en las respuestas | Confusión de versión | Se orienta al canon (`Results` en .NET 6); si corrige en el momento, el objetivo se evalúa con la versión corregida |
| Búsqueda que solo encuentra coincidencia exacta | `LIKE` sin los comodines `%` | Unidad 2 queda No logrado aún en su componente de búsqueda parcial; los demás ítems se evalúan por separado |
| `400`/`404` sin cuerpo de mensaje | Respondió `Results.NotFound()` a secas | Unidad 1 queda No logrado aún en su componente de códigos de respuesta; el resto se evalúa con normalidad |
| Rutas en español (`/ingresos`, `/provincias`) | Canon de rutas incumplido | Se orienta la corrección en el momento; el objetivo se evalúa con la ruta corregida |
| Records movidos por encima de `app.Run()` | Error CS8803 al compilar | Intervenir en el momento; se evalúa lo que alcance a compilar |
| `no such table` al consultar | `hospital.db` fuera de la raíz del proyecto | Intervenir en el momento: mover la base no invalida el ítem (es parte del ítem 1) |
| Fecha en la ruta con formato distinto al ISO guardado (A) | La clave compuesta no encuentra la fila | Orientar a usar la fecha exacta de la tabla (`yyyy-MM-dd`); no invalida el ítem |
| `POST /admissions` con paciente o médico inexistente (A) | Error de clave foránea (`500`) | Intervenir en el momento; la validación y el `INSERT` parametrizado se evalúan con ids existentes |
| `POST /provinces` con un código repetido (B) | Error de clave primaria (`500`) | Intervenir en el momento; la validación y el `INSERT` parametrizado se evalúan con un código nuevo |
| Push ausente al cierre | Entrega incompleta | Unidad 1 (entrega) y Unidad 4 (flujo) se evalúan con lo que esté visible en GitHub al momento de la verificación del plenario de cierre |

## 7. Registro del resultado y pauta de devolución

- Planilla de resultados (registro docente formal): alumno, versión (A o B) y resultado de cada objetivo mínimo (Unidades 1 a 4: Logrado / No logrado aún), con observación breve del criterio no cumplido.
- La verificación de la entrega por GitHub se realiza en los primeros minutos del plenario de cierre; el docente confirma la carpeta `intensificaciones-marzo/`, el issue, la rama, el pull request y el push de cada alumno presente.
- Devolución oral objetivo por objetivo en el plenario de cierre del segundo encuentro, con la evidencia observada.
- Quienes obtengan No apto aún reciben por escrito el detalle de los objetivos pendientes para encarar el nuevo ciclo sabiendo qué reforzar.
- El estándar de esta evaluación es idéntico al de diciembre: misma tabla de objetivos mínimos, misma exigencia y versiones equivalentes; lo único que cambia es el tiempo de preparación que tuvo cada estudiante.
