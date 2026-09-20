# Anexo docente — Encuentro 13: JOIN de dos tablas y records compuestos

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 13 — JOIN de dos tablas (`patients`+`province_names`, `admissions`+`doctors`), alias de tabla, records compuestos y concatenación de textos en SQL |
| Formato | Encuentro estándar del curso (BOPPPS + GRR), plantilla de clase regular (20/40/70/50/45/15) |
| Producción esperada | Proyecto `u2-api` con `GET /patients/with-province` y `GET /admissions/with-doctor` funcionando, y los dos endpoints del ejercicio (`GET /provinces`, `GET /admissions/by-doctor/{id:long}`) |
| Insumos | Proyecto `u2-api` de las clases 10 a 12; `hospital.db` en su lugar; el esquema de la base a la vista (relación clave–tabla de referencia) |

**Decisión didáctica (dos JOIN completos, sin INNER/LEFT en teoría):** la práctica guiada presenta el `JOIN` canónico (equivalente a `INNER JOIN`) sin abrir el catálogo de variantes (`LEFT`, `RIGHT`): el contenido nuevo del encuentro es el cruce por clave y el record compuesto. Las variantes quedan fuera del curso (no son requisito de ninguna unidad) y el docente puede mencionarlas de pasada si algún grupo pregunta.

**Errores de concepto a vigilar:** (1) creer que el JOIN "modifica" las tablas — solo construye filas de resultado; (2) esperar una fila de menos cuando la clave no matchea — con el JOIN canónico, la fila sin pareja desaparece del resultado (en `hospital.db` las claves foráneas están íntegras, así que no se observa el caso, y conviene no abrirlo salvo pregunta explícita).

## Solución completa del ejercicio independiente

Ítem 1 (`GET /provinces`) e ítem 2 (`GET /admissions/by-doctor/{id:long}`), junto a la base común del encuentro. Archivo `Program.cs` completo:

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

// GET /patients/{id}: UN paciente segun su id (404 con mensaje)
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

    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente con ese id" });
    }

    return Results.Ok(patient);
});

// GET /patients/with-province (JOIN de la practica)
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

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

// GET /admissions/with-doctor?limit=10 (JOIN de la practica)
app.MapGet("/admissions/with-doctor", (string? limit) =>
{
    long max = 20;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionWithDoctor>(
        @"SELECT a.patient_id          AS PatientId,
                 a.admission_date      AS AdmissionDate,
                 a.discharge_date      AS DischargeDate,
                 a.diagnosis           AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty           AS DoctorSpecialty
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          ORDER BY a.admission_date DESC
          LIMIT @max",
        new { max });

    return Results.Ok(admissions);
});

// EJERCICIO 1 - GET /provinces: las 13 provincias y territorios
app.MapGet("/provinces", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Tabla de referencia: id TEXT (no es entero, no lleva long)
    var provinces = connection.Query<Province>(
        @"SELECT province_id   AS ProvinceId,
                 province_name AS ProvinceName
          FROM province_names
          ORDER BY province_name");

    return Results.Ok(provinces);
});

// EJERCICIO 2 - GET /admissions/by-doctor/{id}
// Los ingresos de UN medico, con su nombre via JOIN
app.MapGet("/admissions/by-doctor/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // El filtro es por la columna de la tabla principal con su alias:
    // a.attending_doctor_id, no d.doctor_id
    var admissions = connection.Query<AdmissionWithDoctor>(
        @"SELECT a.patient_id          AS PatientId,
                 a.admission_date      AS AdmissionDate,
                 a.discharge_date      AS DischargeDate,
                 a.diagnosis           AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty           AS DoctorSpecialty
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.attending_doctor_id = @id
          ORDER BY a.admission_date DESC",
        new { id });

    // Sin ingresos (o id inexistente): misma respuesta, 404 con mensaje
    if (admissions.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ese medico no tiene ingresos registrados" });
    }

    return Results.Ok(admissions);
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

// Record compuesto del JOIN patients + province_names
record PatientWithProvince(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? City,
    string ProvinceName,
    string? Allergies,
    int? Height,
    int? Weight
);

// Record compuesto del JOIN admissions + doctors
record AdmissionWithDoctor(
    long PatientId,           // id del paciente internado: SIEMPRE long
    string AdmissionDate,     // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? DischargeDate,
    string? Diagnosis,
    string DoctorName,
    string DoctorSpecialty
);

// EJERCICIO 1 - Provincia: id TEXT (codigo de dos letras, no entero)
record Province(string ProvinceId, string ProvinceName);
```

Salida esperada (verificada): `GET /provinces` devuelve 13 objetos ordenados por nombre (conteo estable; la tabla `province_names` es idéntica en todas las copias), con la estructura `{"provinceId":"ON","provinceName":"Ontario"}`. `GET /admissions/by-doctor/7` devuelve los ingresos del médico estable de la tabla `doctors` (Hazel Patterson, Oncologist) con `doctorName` completo; un id sin ingresos (`/admissions/by-doctor/9999`) responde 404 con mensaje.

## Solución de la extensión

**Ítem 2 — JOIN con filtro por provincia** (parámetro opcional en `/patients/with-province`):

```csharp
// EXTENSION - /patients/with-province?province=ON
app.MapGet("/patients/with-province", (string? province) =>
{
    using var connection = new SqliteConnection(connectionString);

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
          WHERE p.province_id = @province OR @province IS NULL
          ORDER BY p.last_name, p.first_name",
        new { province });

    return Results.Ok(patients);
});
```

El `WHERE` combina igualdad exacta (código de dos letras) con el truco del parámetro opcional (`OR @province IS NULL`), presentado como extensión en la clase 12.

**Ítem 3 — ingresos por diagnóstico con JOIN** (parámetro opcional en `/admissions/with-doctor`):

```csharp
// EXTENSION - /admissions/with-doctor?limit=10&diagnosis=pain
app.MapGet("/admissions/with-doctor", (string? limit, string? diagnosis) =>
{
    long max = 20;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionWithDoctor>(
        @"SELECT a.patient_id          AS PatientId,
                 a.admission_date      AS AdmissionDate,
                 a.discharge_date      AS DischargeDate,
                 a.diagnosis           AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty           AS DoctorSpecialty
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          WHERE a.diagnosis LIKE @patron OR @patron IS NULL
          ORDER BY a.admission_date DESC
          LIMIT @max",
        new { max, patron = diagnosis is null ? (string?)null : $"%{diagnosis}%" });

    return Results.Ok(admissions);
});
```

Hallazgo esperado: `?diagnosis=pain` recorta la lista a ingresos con "pain" en el diagnóstico (incluido `Stomache Pain`, con el typo real de la base). Es el primer reporte compuesto de la API y el mejor puente hacia el tp-u2.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | JOIN con regla de emparejamiento explícita | `JOIN ... ON` con la clave correcta; alias de tabla en todas las columnas compartidas |
| 2 | Record compuesto a medida | `PatientWithProvince`/`AdmissionWithDoctor` declarados al final; ninguna propiedad en `null` o `0` por mapeo |
| 3 | Concatenación de nombre en SQL | `DoctorName` construido en el SELECT con espacio entre nombre y apellido |
| 4 | Filtro por la columna correcta | En `/admissions/by-doctor`: `WHERE a.attending_doctor_id = @id`, parametrizado con `new { id }` |
| 5 | 404 con mensaje donde corresponde | Médico sin ingresos → 404 con mensaje; validación de `limit` heredada de la clase 12 intacta |
| 6 | Tipos canónicos en los compuestos | `long` en ids (`PatientId`), `string` ISO en fechas (`AdmissionDate`, `DischargeDate`); `ProvinceId` es `string` porque es código de texto |
| 7 | Prueba de cruce completa | El grupo mostró provincia con nombre (`"Ontario"`), médico con nombre, y un caso 404 |

## Errores esperados e intervención

| Error esperado | Causa probable | Intervención docente |
| --- | --- | --- |
| "ambiguous column name" | Columna compartida sin alias de tabla | Hacer el conteo: `province_id` existe en las dos tablas; el alias dice de cuál se habla |
| Resultado vacío con JOIN bien escrito | `ON` invertido (clave del lado equivocado) o filtro sobre la columna equivocada | Leer el `ON` contra el esquema de la base dibujado en el paso de consolidación |
| `DoctorName` en una sola palabra | Espacio faltante en la concatenación | Mostrar la fila cruda en la base (dos columnas) frente a la concatenada; el espacio es un texto del SELECT |
| Record compuesto con propiedades `null` | Alias faltante en alguna columna nueva del SELECT | Comparar alias del SELECT contra propiedades del record, una por una |
| Filtro `WHERE doctor_id = @id` que explota | Columna de `doctors` usada como filtro de `admissions` | Volver a la pregunta clave: ¿de qué tabla es la columna que filtra? Es la del lado "muchos" (`a.attending_doctor_id`) |
| Confusión `ProvinceId` como `long` | "Todo id es long": casi siempre, salvo los TEXT | El id de `province_names` es un código de texto (`ON`): canónicamente `string`; el verificador de la unidad acepta ambos porque la regla es por tipo de dato |

## Respuestas esperadas (verificación de comprensión)

- **¿Quién cruza las tablas, el C# o la base?** La base, adentro del SELECT con `JOIN ... ON`. Traer dos listas y cruzarlas en C# sería hacer el trabajo de la base afuera, más lento y con más código.
- **¿Por qué hacen falta alias de tabla?** Porque las dos tablas tienen columnas con el mismo nombre (`province_id`); sin alias, la base no sabe cuál se nombra y devuelve "ambiguous column name".
- **¿Qué es un record compuesto?** Un record a medida para las filas del cruce: columnas de la tabla principal más las columnas que aporta la segunda tabla (`ProvinceName`, `DoctorName`, `DoctorSpecialty`). El mapeo sigue siendo por alias `AS`.
- **¿Por qué el 404 del médico sin ingresos no valida si el médico existe?** Porque la respuesta es la misma en ambos casos: "no hay ingresos para ese médico". Validar existencia aparte agregaría una consulta para producir el mismo resultado.
