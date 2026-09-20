# Anexo docente — Evaluación del especial de diciembre (versiones A y B)

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones completas de las versiones A y B (código canon), las respuestas esperadas y los criterios de resultado por objetivo mínimo. La prueba evalúa el camino mínimo completo del curso con criterio Apto / No apto aún.

## Anexo docente

## 1. Preparación previa (gestión del aula)

- Ejecutar antes de la instancia las soluciones de ambas versiones con la base del aula y anotar los valores reales: la base ronda los 306 ingresos y unos 28 abiertos (`discharge_date` NULL), por lo que los reportes deben cerrar cerca de 278 ingresos contados; los valores exactos se constatan con la base de cada equipo antes de comparar contra el alumno.
- Verificar que cada estudiante puede acceder con sus credenciales al repositorio de su grupo (requisito del momento) y que la carpeta `especial-diciembre/` arranca limpia; si más de un integrante del mismo grupo rinde, acordar la subcarpeta de cada uno antes de empezar.
- Tener impresas o a mano las hojas de comandos de ambas versiones: la prueba no permite consultar otro material.
- Preparar la planilla de registro: alumno, versión, objetivo mínimo por objetivo (Logrado / No logrado aún) y resultado del momento (Apto / No apto aún).

## 2. Solución completa — Versión A: médicos (Program.cs)

```csharp
// Program.cs - Especial de diciembre - Version A (solucion del docente)
// Mini API de medicos: recorre el camino minimo completo del curso (U1 a U4)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2: GET con parametro de ruta =====

// GET /doctors/{id:long}: devuelve UN medico segun su id
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // SELECT con alias de columnas snake_case -> PascalCase, SIEMPRE parametrizado
    var doctor = connection.QueryFirstOrDefault<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE doctor_id = @id",
        new { id });

    // Sin fila: 404 con mensaje. Con fila: 200 con el medico serializado a JSON
    return doctor is null
        ? Results.NotFound(new { mensaje = "No existe ese medico" })
        : Results.Ok(doctor);
});

// ===== Item 3: busqueda LIKE con JOIN de dos tablas =====

// GET /admissions?text=...: ingresos cuyo diagnostico contiene el texto
app.MapGet("/admissions", (string? text) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines alrededor del parametro: busqueda parcial, nunca concatenada.
    // El JOIN con doctors suma el nombre completo del medico tratante (dos tablas)
    var admissions = connection.Query<AdmissionSearch>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.diagnosis      AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.diagnosis LIKE @text
          ORDER BY a.admission_date",
        new { text = "%" + text + "%" });

    // 200 con la lista (vacia si no hay coincidencias)
    return Results.Ok(admissions);
});

// ===== Item 4: reporte con JOIN triple, GROUP BY y dato sucio =====

// GET /reports/admissions-by-specialty: cantidad de ingresos por especialidad
app.MapGet("/reports/admissions-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN triple (admissions con patients y con doctors) agrupado por especialidad.
    // Dato sucio: los ingresos abiertos no tienen fecha de alta (NULL) y quedan fuera
    var report = connection.Query<AdmissionsBySpecialty>(
        @"SELECT d.specialty AS Specialty,
                 COUNT(*)    AS Total
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          JOIN doctors d  ON a.attending_doctor_id = d.doctor_id
          WHERE a.discharge_date IS NOT NULL
          GROUP BY d.specialty
          ORDER BY Total DESC");

    return Results.Ok(report);
});

// ===== Item 5: escritura validada =====

// POST /doctors: alta de un medico en la base (INSERT parametrizado)
app.MapPost("/doctors", (Doctor doctor) =>
{
    // Validacion manual simple: los tres campos obligatorios de la tabla
    if (string.IsNullOrWhiteSpace(doctor.FirstName) ||
        string.IsNullOrWhiteSpace(doctor.LastName) ||
        string.IsNullOrWhiteSpace(doctor.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Nombre, apellido y especialidad son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado + last_insert_rowid() devuelve el id generado
    var newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { doctor.FirstName, doctor.LastName, doctor.Specialty });

    // 201 con la URL del recurso nuevo y el medico con su id real
    return Results.Created($"/doctors/{newId}",
        new Doctor(newId, doctor.FirstName, doctor.LastName, doctor.Specialty));
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionSearch(string AdmissionDate, string? Diagnosis, string DoctorName);
record AdmissionsBySpecialty(string Specialty, int Total);
```

Aceptaciones válidas menores: `FirstOrDefault` resuelto con `Where(...).FirstOrDefault()` o con un `foreach`; el texto del `LIKE` armado en una variable previa; `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`. No se acepta `TypedResults` (canon del curso: `Results` en .NET 6) ni SQL concatenado.

Respuestas esperadas (con la API corriendo; los ejemplos usan el puerto 5080):

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/doctors/1` | `200` con `{"doctorId":1,"firstName":"...","lastName":"...","specialty":"..."}` |
| `GET http://localhost:5080/doctors/9999` | `404` con `{"mensaje":"No existe ese medico"}` |
| `GET http://localhost:5080/admissions?text=pain` | `200` con la lista de ingresos cuyo diagnóstico contiene «pain», cada uno con `admissionDate`, `diagnosis` y `doctorName` |
| `GET http://localhost:5080/reports/admissions-by-specialty` | `200` con filas `{"specialty":"Cardiologist","total":N}` ordenadas de más a menos, sin los ingresos abiertos |
| `POST /doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | `201`, encabezado `Location: /doctors/28`, cuerpo con el `doctorId` generado |
| `POST /doctors` con `{"firstName":"Ana","lastName":"","specialty":"Cardiologist"}` | `400` con mensaje |

## 3. Solución completa — Versión B: pacientes (Program.cs)

```csharp
// Program.cs - Especial de diciembre - Version B (solucion del docente)
// Mini API de pacientes: recorre el camino minimo completo del curso (U1 a U4)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2: GET con parametro de ruta =====

// GET /patients/{id:long}: devuelve UN paciente segun su id
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // SELECT con alias de columnas snake_case -> PascalCase, SIEMPRE parametrizado
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

    // Sin fila: 404 con mensaje. Con fila: 200 con el paciente serializado a JSON
    return patient is null
        ? Results.NotFound(new { mensaje = "No existe ese paciente" })
        : Results.Ok(patient);
});

// ===== Item 3: busqueda LIKE con JOIN de dos tablas =====

// GET /patients?text=...: pacientes cuyo apellido contiene el texto
app.MapGet("/patients", (string? text) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines alrededor del parametro: busqueda parcial, nunca concatenada.
    // El JOIN con province_names suma el nombre de la provincia (dos tablas)
    var patients = connection.Query<PatientSearch>(
        @"SELECT p.first_name    AS FirstName,
                 p.last_name     AS LastName,
                 pn.province_name AS ProvinceName
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE p.last_name LIKE @text
          ORDER BY p.last_name",
        new { text = "%" + text + "%" });

    // 200 con la lista (vacia si no hay coincidencias)
    return Results.Ok(patients);
});

// ===== Item 4: reporte con JOIN triple, GROUP BY y dato sucio =====

// GET /reports/admissions-by-province: cantidad de ingresos por provincia del paciente
app.MapGet("/reports/admissions-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN triple (admissions con patients y con province_names) agrupado por provincia.
    // Dato sucio: los ingresos abiertos no tienen fecha de alta (NULL) y quedan fuera
    var report = connection.Query<AdmissionsByProvince>(
        @"SELECT pn.province_name AS Province,
                 COUNT(*)         AS Total
          FROM admissions a
          JOIN patients p       ON a.patient_id = p.patient_id
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE a.discharge_date IS NOT NULL
          GROUP BY pn.province_name
          ORDER BY Total DESC");

    return Results.Ok(report);
});

// ===== Item 5: escritura validada =====

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
    return Results.Created($"/patients/{newId}", patient with { PatientId = newId });
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record Patient(
    long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City, string ProvinceId, string? Allergies,
    int? Height, int? Weight);
record PatientSearch(string FirstName, string LastName, string ProvinceName);
record AdmissionsByProvince(string Province, int Total);
```

Aceptaciones válidas menores: responder `201` con un `new Patient(newId, ...)` reconstruido campo por campo en lugar de `with`; `ORDER BY Total DESC` escrito como `ORDER BY COUNT(*) DESC`. No se acepta `TypedResults`, SQL concatenado ni un `INSERT` que grabe campos nullable obligándolos a no serlo.

Respuestas esperadas (con la API corriendo; los ejemplos usan el puerto 5080):

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/patients/25` | `200` con el paciente completo en JSON camelCase (`patientId`, `firstName`, ... `weight`) |
| `GET http://localhost:5080/patients/9999` | `404` con `{"mensaje":"No existe ese paciente"}` |
| `GET http://localhost:5080/patients?text=garc` | `200` con la lista de pacientes cuyo apellido contiene «garc», cada uno con `firstName`, `lastName` y `provinceName` |
| `GET http://localhost:5080/reports/admissions-by-province` | `200` con filas `{"province":"Ontario","total":N}` ordenadas de más a menos, sin los ingresos abiertos |
| `POST /patients` con los cinco campos obligatorios válidos | `201`, encabezado `Location: /patients/259`, cuerpo con el `patientId` generado |
| `POST /patients` sin `birthDate` | `400` con mensaje |

## 4. Criterios de resultado por objetivo mínimo (Apto / No apto aún)

Cada objetivo mínimo se registra **Logrado** o **No logrado aún** según la evidencia de los ítems; el resultado del momento es **Apto** solo con los cuatro logrados, y **No apto aún** si alguno queda pendiente.

| Unidad | Objetivo mínimo | Ítems | Se registra Logrado cuando... |
| --- | --- | --- | --- |
| U1 | Crear y ejecutar la API; endpoint con parámetro; verbos y códigos; entrega por GitHub | 1, 2, 5 y 6 | El proyecto queda creado y corriendo; el GET por id responde 200 con el dato y 404 con mensaje usando `Results`; la escritura responde 201 y 400 según corresponda; la entrega queda con commits y push en el repositorio del grupo |
| U2 | SELECT/WHERE parametrizado; LIKE; JOIN de dos tablas; escritura validada | 2, 3 y 5 | Las consultas van parametrizadas con alias de columnas; el LIKE usa comodines sin concatenar SQL; el JOIN de dos tablas mapea al record compuesto; el INSERT es parametrizado con validación manual previa |
| U3 | JOIN de tres tablas; COUNT y GROUP BY; dato sucio | 4 | El reporte une las tres tablas con `ON` correcto; agrupa con `GROUP BY` por la columna exhibida y cuenta con `COUNT(*)`; el filtro `IS NOT NULL` excluye los ingresos abiertos (dato sucio NULL) |
| U4 | README de portada; flujo issue, rama, pull request y main | 6 | La carpeta del ejercicio tiene un README breve; existe el issue; el trabajo va por rama `feature/diciembre` con commits referentes; el pull request se revisó y fusionó a `main` sin push directo |

Criterios complementarios de registro:

- Un objetivo con evidencia parcial (por ejemplo, el reporte con JOIN triple y GROUP BY pero sin el filtro del dato sucio) se registra **No logrado aún**: el objetivo se logra completo o no.
- La constancia del ítem 6 puede completarse hasta el cierre del encuentro; sin ella, el objetivo U4 se registra No logrado aún.
- El tiempo agotado no invalida lo alcanzado: se registra la evidencia observable al cierre.

## 5. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en el GET por id | Id declarado `int` o alias que no coincide con el record | Es un defecto canon del curso: la evidencia del ítem no acredita el objetivo hasta corregirlo dentro del tiempo; orientar no quita el registro |
| SQL concatenado (`... LIKE '%" + text + "%'`) | No parametrizó | Canon de seguridad: sin parametrización, el ítem no acredita U2 |
| `TypedResults` en las respuestas | Confusión de versión | Defecto de versión (canon: `Results` en .NET 6); corregir para acreditar |
| Reporte sin `GROUP BY` o agrupando por otra columna | Consulta armada por prueba y error | U3 no queda acreditada: el GROUP BY debe ser por la columna exhibida |
| Reporte que incluye los ingresos abiertos | Falta el filtro del dato sucio (`IS NOT NULL`) | La parte del dato sucio no queda acreditada |
| Rutas en español (`/medicos`, `/pacientes`) | Canon de rutas incumplido | Corregir para acreditar el ítem correspondiente |
| Records por encima de `app.Run()` | Error CS8803 al compilar | Avisar la causa no invalida la prueba; se acredita lo que alcance a compilar |
| Constancia incompleta (sin issue, sin PR o sin push) | Flujo U4 no ejecutado completo | U4 se registra No logrado aún; puede completarse hasta el cierre del encuentro |

## 6. Registro, devolución y plan de marzo

- Registrar alumno, versión, objetivo por objetivo (Logrado / No logrado aún) y resultado del momento (Apto / No apto aún) en el registro docente formal.
- Devolución oral en la plenaria de cierre, objetivo por objetivo y con la evidencia observada; el alumno marca en su guía los núcleos pendientes.
- A quien obtenga No apto aún se le entrega por escrito el plan de marzo: objetivos pendientes, guía de repaso y fecha; el estándar de marzo (`especiales-marzo-intensificacion.md`) es idéntico al de diciembre, con más tiempo de preparación.
- La prueba acredita el camino mínimo completo del curso; no se agregan contenidos ni exigencias fuera de este anexo.
