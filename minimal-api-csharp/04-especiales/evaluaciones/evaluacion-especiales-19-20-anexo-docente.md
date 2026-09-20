# Anexo docente — Evaluación del momento especial 19-20 (proyecto puente U1-U2)

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones de referencia de las versiones A y B, las pruebas rápidas con respuestas esperadas, la aplicación de la rúbrica con ejemplos de desempeño por nivel y la pauta de seguimiento, registro y devolución.

## 1. Verificación previa a la instancia

- Controlar que la copia de `hospital.db` que usan los grupos coincida con los volúmenes de referencia del curso: `province_names` 13 · `doctors` 27 · `patients` 258 · `admissions` 306. Si la copia difiere, ajustar en este anexo los ids y conteos esperados.
- Cada grupo trabaja sobre **su propio repositorio** (creado en el Encuentro 8) con la carpeta nueva `puente-u1-u2/`. Verificar en la apertura del Encuentro 19 que el remoto está accesible desde las PCs del aula.
- Las dos versiones son equivalentes: mismo proyecto y requisitos, distinto dominio. La asignación es **por grupo** y se registra al abrir el Encuentro 19.

## 2. Solución de referencia — Versión A (turnos e ingresos)

Archivo `puente-u1-u2/Program.cs` completo:

```csharp
// Program.cs - Proyecto puente U1-U2 - Version A (solucion de referencia del docente)
// Parte 1: agenda de turnos en memoria (Unidad 1)
// Parte 2: medicos e ingresos de hospital.db (Unidad 2)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// ===== Parte 1: agenda de turnos en memoria (Unidad 1) =====

// Lista compartida: los datos propios del grupo (5 o 6 turnos iniciales)
var appointments = new List<Appointment>
{
    new Appointment(1, "Lucia Fernandez", "2024-05-03", "Control de rutina"),
    new Appointment(2, "Martin Sosa", "2024-05-04", "Vacunacion")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextAppointmentId = 3;

// GET /appointments: toda la agenda -> 200
app.MapGet("/appointments", () =>
{
    return Results.Ok(appointments);
});

// GET /appointments/{id:long}: un turno o 404
app.MapGet("/appointments/{id:long}", (long id) =>
{
    var appointment = appointments.Find(a => a.AppointmentId == id);

    return appointment is null
        ? Results.NotFound(new { mensaje = "No existe el turno" })
        : Results.Ok(appointment);
});

// POST /appointments: alta con validacion -> 400 o 201
app.MapPost("/appointments", (AppointmentInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.PatientName) ||
        string.IsNullOrWhiteSpace(input.Date) ||
        string.IsNullOrWhiteSpace(input.Reason))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del turno" });
    }

    var appointment = new Appointment(nextAppointmentId, input.PatientName, input.Date, input.Reason);
    nextAppointmentId++;

    appointments.Add(appointment);

    return Results.Created($"/appointments/{appointment.AppointmentId}", appointment);
});

// PUT /appointments/{id:long}: reemplazo -> 404, 400 o 200
app.MapPut("/appointments/{id:long}", (long id, AppointmentInput input) =>
{
    var appointment = appointments.Find(a => a.AppointmentId == id);

    if (appointment is null)
    {
        return Results.NotFound(new { mensaje = "No existe el turno" });
    }

    if (string.IsNullOrWhiteSpace(input.PatientName) ||
        string.IsNullOrWhiteSpace(input.Date) ||
        string.IsNullOrWhiteSpace(input.Reason))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del turno" });
    }

    var updated = new Appointment(appointment.AppointmentId, input.PatientName, input.Date, input.Reason);
    appointments[appointments.IndexOf(appointment)] = updated;

    return Results.Ok(updated);
});

// DELETE /appointments/{id:long}: baja -> 404 o 204
app.MapDelete("/appointments/{id:long}", (long id) =>
{
    var appointment = appointments.Find(a => a.AppointmentId == id);

    if (appointment is null)
    {
        return Results.NotFound(new { mensaje = "No existe el turno" });
    }

    appointments.Remove(appointment);

    return Results.NoContent();
});

// ===== Parte 2: hospital.db (Unidad 2) =====

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// 2a) GET /admissions/by-doctor/{id:long}: ingresos de un medico con su nombre.
//     JOIN de dos tablas: admissions (a) + doctors (d)
app.MapGet("/admissions/by-doctor/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // ON empareja cada ingreso con su medico tratante; cada columna
    // snake_case lleva alias para encajar en el record compuesto
    var admissions = connection.Query<AdmissionOfDoctor>(
        @"SELECT a.admission_date AS AdmissionDate,
                 a.diagnosis      AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.attending_doctor_id = @id
          ORDER BY a.admission_date",
        new { id }).ToList();

    // Sin ingresos (o medico inexistente): 404 con mensaje
    if (admissions.Count == 0)
    {
        return Results.NotFound(new { mensaje = "El medico no tiene ingresos registrados" });
    }

    return Results.Ok(admissions);
});

// 2b) GET /doctors?text=...: medicos cuya especialidad contiene el texto
app.MapGet("/doctors", (string? text) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines alrededor del parametro: busqueda parcial.
    // El valor viaja SIEMPRE por parametro, nunca concatenado
    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE specialty LIKE @patron
          ORDER BY specialty",
        new { patron = $"%{text}%" });

    return Results.Ok(doctors);
});

// 2c) POST /doctors: alta de un medico en la base (escritura validada)
app.MapPost("/doctors", (DoctorInput input) =>
{
    // Validacion ANTES de escribir: los tres campos son obligatorios
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado; last_insert_rowid() trae el id que asigno la base
    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Specialty });

    // 201 con la URL del recurso nuevo y el medico con su id real
    var created = new Doctor(newId, input.FirstName, input.LastName, input.Specialty);
    return Results.Created($"/doctors/{newId}", created);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Turno de la agenda en memoria (respuesta del GET y del POST)
record Appointment(long AppointmentId, string PatientName, string Date, string Reason);

// Datos de entrada del POST y del PUT de turnos: sin id, lo asigna el contador
record AppointmentInput(string PatientName, string Date, string Reason);

// Medico: una fila de la tabla doctors
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// Datos de entrada del alta de medicos
record DoctorInput(string FirstName, string LastName, string Specialty);

// Record COMPUESTO del JOIN: columnas de admissions + nombre del medico
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
```

Aceptaciones válidas menores: el chequeo de lista vacía con `admissions.Any()` o `Count() == 0`; la validación en un solo `if` o en varios; mensajes propios distintos, siempre en español, sin tildes y coherentes entre endpoints; `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`. No se acepta `TypedResults` (no existe como canon en .NET 6), SQL concatenado ni ids `int`.

## 3. Solución de referencia — Versión B (pacientes por provincia)

Archivo `puente-u1-u2/Program.cs` completo:

```csharp
// Program.cs - Proyecto puente U1-U2 - Version B (solucion de referencia del docente)
// Parte 1: agenda de controles en memoria (Unidad 1)
// Parte 2: pacientes y provincias de hospital.db (Unidad 2)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// ===== Parte 1: agenda de controles en memoria (Unidad 1) =====

// Lista compartida: los datos propios del grupo (5 o 6 controles iniciales)
var checkups = new List<Checkup>
{
    new Checkup(1, "Lucia Fernandez", "2024-05-03", "Control de altura y peso"),
    new Checkup(2, "Martin Sosa", "2024-05-04", "Control odontologico")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextCheckupId = 3;

// GET /checkups: toda la agenda -> 200
app.MapGet("/checkups", () =>
{
    return Results.Ok(checkups);
});

// GET /checkups/{id:long}: un control o 404
app.MapGet("/checkups/{id:long}", (long id) =>
{
    var checkup = checkups.Find(c => c.CheckupId == id);

    return checkup is null
        ? Results.NotFound(new { mensaje = "No existe el control" })
        : Results.Ok(checkup);
});

// POST /checkups: alta con validacion -> 400 o 201
app.MapPost("/checkups", (CheckupInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.PatientName) ||
        string.IsNullOrWhiteSpace(input.Date) ||
        string.IsNullOrWhiteSpace(input.Notes))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del control" });
    }

    var checkup = new Checkup(nextCheckupId, input.PatientName, input.Date, input.Notes);
    nextCheckupId++;

    checkups.Add(checkup);

    return Results.Created($"/checkups/{checkup.CheckupId}", checkup);
});

// PUT /checkups/{id:long}: reemplazo -> 404, 400 o 200
app.MapPut("/checkups/{id:long}", (long id, CheckupInput input) =>
{
    var checkup = checkups.Find(c => c.CheckupId == id);

    if (checkup is null)
    {
        return Results.NotFound(new { mensaje = "No existe el control" });
    }

    if (string.IsNullOrWhiteSpace(input.PatientName) ||
        string.IsNullOrWhiteSpace(input.Date) ||
        string.IsNullOrWhiteSpace(input.Notes))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del control" });
    }

    var updated = new Checkup(checkup.CheckupId, input.PatientName, input.Date, input.Notes);
    checkups[checkups.IndexOf(checkup)] = updated;

    return Results.Ok(updated);
});

// DELETE /checkups/{id:long}: baja -> 404 o 204
app.MapDelete("/checkups/{id:long}", (long id) =>
{
    var checkup = checkups.Find(c => c.CheckupId == id);

    if (checkup is null)
    {
        return Results.NotFound(new { mensaje = "No existe el control" });
    }

    checkups.Remove(checkup);

    return Results.NoContent();
});

// ===== Parte 2: hospital.db (Unidad 2) =====

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// 2a) GET /provinces/{provinceId}/patients: pacientes de una provincia con el
//     NOMBRE de la provincia. JOIN de dos tablas: patients (p) + province_names (pn)
app.MapGet("/provinces/{provinceId}/patients", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // La clave del cruce es el codigo de provincia (TEXT): 'ON', 'BC', ...
    var patients = connection.Query<PatientInProvince>(
        @"SELECT p.patient_id     AS PatientId,
                 p.first_name     AS FirstName,
                 p.last_name      AS LastName,
                 pn.province_name AS ProvinceName
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          WHERE p.province_id = @provinceId
          ORDER BY p.last_name, p.first_name",
        new { provinceId }).ToList();

    // Sin pacientes con ese codigo: 404 con mensaje
    if (patients.Count == 0)
    {
        return Results.NotFound(new { mensaje = "No hay pacientes con ese codigo de provincia" });
    }

    return Results.Ok(patients);
});

// 2b) GET /patients?text=...: pacientes cuyo apellido contiene el texto
app.MapGet("/patients", (string? text) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines alrededor del parametro: busqueda parcial.
    // El valor viaja SIEMPRE por parametro, nunca concatenado
    var patients = connection.Query<PatientCard>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 province_id AS ProvinceId
          FROM patients
          WHERE last_name LIKE @patron
          ORDER BY last_name, first_name",
        new { patron = $"%{text}%" });

    return Results.Ok(patients);
});

// 2c) POST /patients: alta de un paciente en la base (escritura validada)
app.MapPost("/patients", (PatientInput input) =>
{
    // Validacion ANTES de escribir: los cinco campos obligatorios de la tabla
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Gender) ||
        string.IsNullOrWhiteSpace(input.BirthDate) ||
        string.IsNullOrWhiteSpace(input.ProvinceId))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos obligatorios del paciente" });
    }

    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado (los campos opcionales pueden llegar NULL);
    // last_insert_rowid() trae el id que asigno la base
    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO patients (first_name, last_name, gender, birth_date,
                                city, province_id, allergies, height, weight)
          VALUES (@FirstName, @LastName, @Gender, @BirthDate,
                  @City, @ProvinceId, @Allergies, @Height, @Weight);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Gender, input.BirthDate,
              input.City, input.ProvinceId, input.Allergies, input.Height, input.Weight });

    // 201 con la URL del recurso nuevo y el paciente con su id real
    var created = new Patient(newId, input.FirstName, input.LastName, input.Gender,
        input.BirthDate, input.City, input.ProvinceId, input.Allergies,
        input.Height, input.Weight);
    return Results.Created($"/patients/{newId}", created);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Control de salud de la agenda en memoria (respuesta del GET y del POST)
record Checkup(long CheckupId, string PatientName, string Date, string Notes);

// Datos de entrada del POST y del PUT de controles: sin id, lo asigna el contador
record CheckupInput(string PatientName, string Date, string Notes);

// Paciente: una fila de la tabla patients (record canonico del curso)
record Patient(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string en ISO "yyyy-MM-dd"
    string? City,
    string ProvinceId,
    string? Allergies,
    int? Height,         // cm (medida, no id)
    int? Weight          // kg
);

// Datos de entrada del alta de pacientes: los cinco primeros son obligatorios;
// el resto puede no llegar (columnas que aceptan NULL en la tabla)
record PatientInput(
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string ProvinceId,
    string? City,
    string? Allergies,
    int? Height,
    int? Weight
);

// Record de la busqueda por apellido
record PatientCard(long PatientId, string FirstName, string LastName, string ProvinceId);

// Record COMPUESTO del JOIN: columnas de patients + nombre de la provincia
record PatientInProvince(long PatientId, string FirstName, string LastName, string ProvinceName);
```

**Variante recomendada para el alta de pacientes (verificación de la clave foránea):** `province_id` es clave foránea de `province_names`; con un código inexistente, el `INSERT` responde 500 (`FOREIGN KEY constraint failed`). El flujo robusto — camino documentado en la clase 14 — verifica el código contra la tabla antes de insertar y responde 400 con mensaje. Es una mejora de calidad, no un requisito de la rúbrica (el criterio 4 exige validación de los campos obligatorios, `INSERT` parametrizado y 201 con URL, igual en las dos versiones):

```csharp
// Despues de abrir la conexion y ANTES del INSERT:
long provinces = connection.ExecuteScalar<long>(
    "SELECT COUNT(*) FROM province_names WHERE province_id = @ProvinceId",
    new { input.ProvinceId });

if (provinces == 0)
{
    return Results.BadRequest(new { mensaje = "El codigo de provincia no existe" });
}
```

Aceptaciones válidas menores: las mismas de la versión A, más usar un record de respuesta de alta más chico (por ejemplo, solo los campos obligatorios con el id nuevo), siempre que el JSON salga camelCase y sin id inventado. No se acepta `TypedResults`, SQL concatenado, ids `int` ni `DateOnly`/`DateTime` para las fechas.

## 4. Pruebas rápidas y respuestas esperadas

Con la API corriendo (`dotnet run`; los ejemplos usan el puerto `5080`) y `hospital.db` junto al `.csproj`. Los POST y PUT se prueban con `curl.exe` (una línea, comillas internas escapadas).

### Versión A

| Pedido | Respuesta esperada |
| --- | --- |
| `GET /appointments` | `200` con la agenda del grupo |
| `GET /appointments/99` | `404` con `{"mensaje":"No existe el turno"}` |
| `POST /appointments` con `{"patientName":"Ana Garcia","date":"2024-06-10","reason":"Vacunacion"}` | `201`, `Location: /appointments/3` (o el id que siga), cuerpo con el turno |
| `POST /appointments` sin `reason` | `400` con mensaje |
| `PUT /appointments/1` con datos completos | `200` con el turno actualizado |
| `DELETE /appointments/1` | `204` sin cuerpo; el GET posterior responde `404` |
| `GET /admissions/by-doctor/7` | `200` con los ingresos del médico 7 (Hazel Patterson), cada fila con `admissionDate`, `diagnosis` y `doctorName` |
| `GET /admissions/by-doctor/9999` | `404` con `{"mensaje":"El medico no tiene ingresos registrados"}` |
| `GET /doctors?text=cardio` | `200` con los médicos cuya `specialty` contiene «cardio» (Cardiologist, Cardiovascular Surgeon) |
| `GET /doctors?text=xyz` | `200` con `[]` |
| `POST /doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | `201`, `Location: /doctors/28` (27 médicos en la base de referencia), cuerpo con `doctorId` generado |
| `POST /doctors` sin `specialty` | `400` con mensaje |

```powershell
curl.exe -X POST http://localhost:5080/appointments -H "Content-Type: application/json" -d "{\"patientName\":\"Ana Garcia\",\"date\":\"2024-06-10\",\"reason\":\"Vacunacion\"}"
curl.exe -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"
curl.exe -i http://localhost:5080/admissions/by-doctor/9999
```

### Versión B

| Pedido | Respuesta esperada |
| --- | --- |
| `GET /checkups` | `200` con la agenda del grupo |
| `GET /checkups/99` | `404` con `{"mensaje":"No existe el control"}` |
| `POST /checkups` con `{"patientName":"Ana Garcia","date":"2024-06-10","notes":"Control dental"}` | `201`, `Location: /checkups/3` (o el id que siga), cuerpo con el control |
| `POST /checkups` sin `notes` | `400` con mensaje |
| `PUT /checkups/1` con datos completos | `200` con el control actualizado |
| `DELETE /checkups/1` | `204` sin cuerpo; el GET posterior responde `404` |
| `GET /provinces/ON/patients` | `200` con los pacientes de Ontario (la mayoría de la base), cada fila con `patientId`, `firstName`, `lastName` y `provinceName` |
| `GET /provinces/XX/patients` | `404` con `{"mensaje":"No hay pacientes con ese codigo de provincia"}` (código inexistente: lista vacía) |
| `GET /patients?text=garc` | `200` con los pacientes cuyo apellido contiene el texto buscado (en SQLite la comparación `LIKE` es insensible a mayúsculas para texto ASCII) |
| `GET /patients?text=xyz` | `200` con `[]` |
| `POST /patients` con los cinco obligatorios (`"provinceId":"ON"`) y, opcionalmente, los campos opcionales | `201`, `Location: /patients/259` (258 pacientes en la base de referencia), cuerpo con `patientId` generado |
| `POST /patients` sin `birthDate` | `400` con mensaje |
| `POST /patients` con `"provinceId":"XX"` (sin la verificación previa) | `500` con `FOREIGN KEY constraint failed`: es el caso de enseñanza de la variante recomendada de la sección 3 |

```powershell
curl.exe -X POST http://localhost:5080/checkups -H "Content-Type: application/json" -d "{\"patientName\":\"Ana Garcia\",\"date\":\"2024-06-10\",\"notes\":\"Control dental\"}"
curl.exe -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"
curl.exe -i http://localhost:5080/provinces/XX/patients
```

## 5. Aplicación de la rúbrica (idéntica para A y B)

Los criterios 1 a 4 se evalúan sobre los endpoints de la versión del grupo; los criterios 5 a 8 son comunes. La entrega evaluada es la publicada en GitHub al cierre del bloque de entrega del Encuentro 20.

### Desglose por criterio y sub-ítem

| Criterio | Desglose | Logrado | En proceso | No logrado |
| --- | --- | --- | --- | --- |
| 1. API en memoria (30) | GET todos 4 · GET uno 6 (ruta 2, 200 2, 404 con mensaje 2) · POST 7 (ruta y DTO 2, validación 400 2, 201 con URL 3) · PUT 7 (ruta 2, validación y códigos 3, 200/404 2) · DELETE 6 (ruta 2, 204 2, 404 2) | Los cinco endpoints con los códigos de la consigna y datos propios | CRUD incompleto o con códigos desviados: se otorga el parcial por sub-ítem | No hay CRUD propio o no compila (copia literal del ejemplo de clase no puntúa) |
| 2. JOIN (15) | `ON` por la clave compartida 6 · alias + record compuesto 5 · 200/404 según resultado 4 | JOIN correcto, record compuesto completo y los dos códigos | JOIN armado pero sin alias completo o sin el 404 del caso vacío | Una sola tabla, producto cruzado sin `ON` o record sin mapear |
| 3. LIKE (10) | `LIKE @patron` parametrizado con comodines 5 · query string + `ORDER BY` 3 · 200 con la lista 2 | Búsqueda parcial real, parametrizada y ordenada | Patrón sin comodines (comparación exacta) o sin orden: parcial por sub-ítem | SQL concatenado con el texto recibido |
| 4. Escritura (15) | Validación 400 antes de escribir 5 · `INSERT` parametrizado 5 · id con `ExecuteScalar<long>` + 201 con URL 5 | Los tres sub-ítems completos | Falta la validación, o el 201 no lleva la URL: parcial por sub-ítem | `INSERT` concatenado o escritura que responde 500 por datos no validados |
| 5. Convenciones (10) | 2 puntos por convención: `Results` · ids `long`/fechas `string` · rutas inglés plural · records al final · comentarios sin tildes | Las cinco convenciones en todo el archivo | Tres o cuatro convenciones correctas | Menos de tres, o desvíos de canon (`TypedResults`, ids `int`) |
| 6. Entrega GitHub (12) | Carpeta `puente-u1-u2/` con proyecto, base y paquetes 4 · al menos 3 commits `puente-u1-u2: ...` 4 · push visible con `.gitignore` correcto 4 | Entrega completa y verificada en el remoto | Parcial por sub-ítem (por ejemplo, un único commit final) | Sin push: la entrega no existe y el criterio vale 0 |
| 7. Batería (4) | Tabla completa esperado vs observado 4 · parcial 2 · sin evidencia 0 | | | |
| 8. Puesta en común (4) | Todos los integrantes explican 4 · parcial 2 · no presenta 0 | | | |

Regla general de corrección: no se duplican descuentos por el mismo defecto en criterios distintos, y los mensajes propios de cada grupo se aceptan si son en español, sin tildes y coherentes.

### Ejemplos de desempeño por nivel

Los tres perfiles son ilustrativos (dominio A; en B la estructura es idéntica):

**Perfil sólido — 94 puntos:** 1) 30 · 2) 15 · 3) 10 · 4) 15 · 5) 8 · 6) 12 · 7) 2 · 8) 2. Todo funciona y está entregado. Pierde puntos de calidad: los records de la parte en memoria no quedaron al final del archivo (−2), la batería anotada cubre solo los GET (2/4) y en la puesta en común explicaron la mitad del grupo (2/4).

**Perfil en proceso — 70 puntos:** 1) 24 · 2) 11 · 3) 5 · 4) 10 · 5) 6 · 6) 8 · 7) 2 · 8) 4. Los cuatro bloques están presentes con defectos puntuales: el DELETE responde 200 en lugar de 204 (−6), el JOIN no tiene el 404 del caso sin resultados (−4), la búsqueda compara exacto porque el patrón no tiene comodines (−5), el alta no valida antes de escribir (−5), ids `int` en memoria y comentarios escasos (−4), un único commit final (−4), batería solo de los GET (2/4).

**Perfil inicial — 44 puntos:** 1) 17 · 2) 6 · 3) 5 · 4) 0 · 5) 6 · 6) 8 · 7) 2 · 8) 0. La parte en memoria quedó a medias (sin PUT ni DELETE: 17/30), el JOIN empareja pero sin alias completo (6/15), la búsqueda compara exacto (5/10) y el alta se entregó sin validar y con SQL concatenado (0/15); la entrega tiene push y carpeta correcta pero un solo commit (8/12); no llegaron a la puesta en común (0/4).

## 6. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en el JOIN | Alias faltante o tipos del record que no coinciden | Descuenta el sub-ítem de alias/record del criterio 2; orientar en el momento no quita el descuento |
| La búsqueda trae todo o nada | Patrón sin `%` o texto concatenado | Sin comodines es parcial; concatenado es 0 en el criterio 3 |
| `500` al insertar paciente (versión B) | `province_id` inexistente: la clave foránea bloquea | Mostrar la variante recomendada de la sección 3; el criterio 4 no exige la verificación (exige validación de campos, `INSERT` parametrizado y 201) |
| El PUT "funciona" pero no cambia nada | `@id` sin su propiedad en el objeto anónimo | Contar los huecos `@` del SQL y las propiedades de `new { ... }` |
| 201 sin `Location` | `Results.Created(null, ...)` o URL escrita a mano | Descuenta el sub-ítem de 201 del criterio correspondiente |
| Push rechazado o remoto desactualizado | Falta un pull previo o el remoto cambió | Resolver antes de evaluar: la entrega es la que está publicada al cierre del bloque de entrega |
| Proyecto creado fuera de la raíz del repo | Carpeta dentro de carpeta | Descuenta el sub-ítem de carpeta del criterio 6; si el remoto lo muestra ordenado, evaluar lo publicado |

## 7. Seguimiento docente, registro y devolución

- **Pasadas de revisión:** Encuentro 19, una pasada por grupo al final de cada bloque (checklist de la parte en memoria; lecturas corriendo con commit). Encuentro 20, una pasada a mitad del bloque 1 (escritura y batería) y acompañamiento durante el bloque 2 (entrega y push). Cada pasada deja una marca en la planilla de proceso.
- **Registro:** planilla docente formal con grupo, versión asignada, puntos por criterio y total sobre 100, más una observación cualitativa breve por grupo.
- **Devolución:** al inicio del Encuentro 21, junto con la devolución de la evaluación de la Unidad 2: puntaje por criterio, los dos criterios más débiles de cada grupo y qué trabajará cada grupo después. El resultado informa el estado aún provisorio del curso según `06-aprobacion/criterios-aprobacion.md`.
- **Conexión con lo que sigue:** el proyecto puente es el ensayo del tp-u3: el JOIN de dos tablas se vuelve triple, y la validación y los códigos ya exigidos acá son la base de la robustez con datos sucios de la Unidad 3.
