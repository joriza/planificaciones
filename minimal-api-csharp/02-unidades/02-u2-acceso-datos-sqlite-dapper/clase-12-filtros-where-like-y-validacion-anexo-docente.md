# Anexo docente — Encuentro 12: filtros WHERE y LIKE, búsqueda y validación (400/404)

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 12 — filtros de búsqueda parcial con `LIKE`, búsqueda combinada por query string, validación manual (`IsNullOrWhiteSpace`, `long.TryParse`) y respuestas 400/404 con mensaje |
| Formato | Encuentro estándar del curso (BOPPPS + GRR), plantilla de clase regular (20/40/70/50/45/15) |
| Producción esperada | Proyecto `u2-api` con `GET /patients/by-allergy` y `GET /patients/search` validados (más los endpoints previos), y los dos ítems del ejercicio (`GET /doctors/search`, `/by-province` mejorado) |
| Insumos | Proyecto `u2-api` de las clases 10 y 11; `hospital.db` en su lugar |

**Decisión didáctica (criterios obligatorios en la búsqueda combinada):** en `/patients/search` los dos criterios (ciudad y alergia) son obligatorios. Mantener ambos obligatorios evita introducir el truco SQL de los criterios opcionales (`OR @param IS NULL`) en la práctica guiada; ese truco queda como desafío de la extensión, donde el grupo ya domina la validación y puede leerlo con calma.

## Solución completa del ejercicio independiente

Ítem 1 (`GET /doctors/search`) e ítem 2 (`/patients/by-province` mejorado), junto a la base común del encuentro. Archivo `Program.cs` completo:

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

// GET /patients/by-allergy?allergy=Peni (LIKE + validacion, de la practica)
app.MapGet("/patients/by-allergy", (string? allergy) =>
{
    if (string.IsNullOrWhiteSpace(allergy))
    {
        return Results.BadRequest(new { mensaje = "Indique una alergia para buscar" });
    }

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
          WHERE allergies LIKE @patron
          ORDER BY last_name, first_name",
        new { patron = $"%{allergy}%" });

    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente con esa alergia" });
    }

    return Results.Ok(patients);
});

// GET /patients/search?city=tor&allergy=pen&limit=5 (de la practica)
app.MapGet("/patients/search", (string? city, string? allergy, string? limit) =>
{
    if (string.IsNullOrWhiteSpace(city) || string.IsNullOrWhiteSpace(allergy))
    {
        return Results.BadRequest(new { mensaje = "Indique ciudad y alergia para buscar" });
    }

    long max = 20;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

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
          WHERE city LIKE @ciudad
            AND allergies LIKE @alergia
          ORDER BY last_name, first_name
          LIMIT @max",
        new { ciudad = $"%{city}%", alergia = $"%{allergy}%", max });

    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente con esa ciudad y esa alergia" });
    }

    return Results.Ok(patients);
});

// EJERCICIO 1 - GET /doctors/search?q=card
// Busqueda parcial de medicos por especialidad
app.MapGet("/doctors/search", (string? q) =>
{
    // Validacion: el criterio es obligatorio -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(q))
    {
        return Results.BadRequest(new { mensaje = "Indique un texto de especialidad para buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Patron %q% armado en C# y viajando parametrizado
    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE specialty LIKE @patron
          ORDER BY last_name, first_name",
        new { patron = $"%{q}%" });

    // Validacion de resultados: pedido valido, sin coincidencias -> 404
    if (doctors.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun medico con esa especialidad" });
    }

    return Results.Ok(doctors);
});

// EJERCICIO 2 - GET /patients/by-province mejorado: LIKE + 400 + 404
app.MapGet("/patients/by-province", (string? province, int? limit) =>
{
    // Validacion 1: el codigo (o pedazo de codigo) es obligatorio
    if (string.IsNullOrWhiteSpace(province))
    {
        return Results.BadRequest(new { mensaje = "Indique una provincia para buscar" });
    }

    int max = limit ?? 10;

    using var connection = new SqliteConnection(connectionString);

    // Antes comparaba exacto (=); ahora busca porciones del codigo
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
          WHERE province_id LIKE @patron
          ORDER BY last_name, first_name
          LIMIT @max",
        new { patron = $"%{province}%", max });

    // Validacion 2: sin resultados -> 404 con mensaje
    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente de esa provincia" });
    }

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

Salida esperada (verificada): `GET /doctors/search?q=card` devuelve los médicos de las dos especialidades que contienen "card" (`Cardiologist`, `Cardiovascular Surgeon`; ambas están en la base, bien distribuidas). `GET /patients/by-province?province=n` devuelve pacientes de `ON`, `NS`, `NT` y `NU` (los cuatro códigos que contienen "n"; la mayoría de Ontario). `?province=xz` responde 404 con mensaje. Los mensajes 400/404 se verifican textualmente con `curl.exe -i`.

## Solución de la extensión

**Ítem 2 — criterio opcional con el truco SQL** (`/patients/search` con alergia opcional):

```csharp
// EXTENSION - la alergia pasa a ser opcional sin romper el SQL:
// si @alergia es NULL, la condicion (allergies LIKE @alergia
// OR @alergia IS NULL) queda siempre verdadera y no filtra
app.MapGet("/patients/search", (string? city, string? allergy, string? limit) =>
{
    if (string.IsNullOrWhiteSpace(city))
    {
        return Results.BadRequest(new { mensaje = "Indique una ciudad para buscar" });
    }

    long max = 20;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Si allergy no vino, el parametro viaja null (no como '%%')
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
          WHERE city LIKE @ciudad
            AND (allergies LIKE @alergia OR @alergia IS NULL)
          ORDER BY last_name, first_name
          LIMIT @max",
        new { ciudad = $"%{city}%", alergia = allergy is null ? (string?)null : $"%{allergy}%", max });

    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente con esos criterios" });
    }

    return Results.Ok(patients);
});
```

Advertencia para la puesta en común: con alergia opcional, las filas con `allergies = NULL` **no** aparecen ni en el modo "sin filtro de alergia" (porque `NULL LIKE '%%'` es falso); si se quisiera incluirlas haría falta `(allergies LIKE @alergia OR allergies IS NULL OR @alergia IS NULL)`. Dejar planteada la pregunta: es exactamente el territorio de los datos sucios de la Unidad 3.

**Ítem 3 — búsqueda por diagnóstico** (`GET /admissions/search?diagnosis=pain`):

```csharp
// EXTENSION - busqueda parcial por diagnostico en admissions
app.MapGet("/admissions/search", (string? diagnosis) =>
{
    if (string.IsNullOrWhiteSpace(diagnosis))
    {
        return Results.BadRequest(new { mensaje = "Indique un diagnostico para buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<Admission>(
        @"SELECT patient_id          AS PatientId,
                 admission_date      AS AdmissionDate,
                 discharge_date      AS DischargeDate,
                 diagnosis           AS Diagnosis,
                 attending_doctor_id AS AttendingDoctorId
          FROM admissions
          WHERE diagnosis LIKE @patron
          ORDER BY admission_date DESC",
        new { patron = $"%{diagnosis}%" });

    if (admissions.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun ingreso con ese diagnostico" });
    }

    return Results.Ok(admissions);
});
```

```csharp
// Record de ingreso (si no se agrego en la clase 10)
record Admission(
    long PatientId,          // id: SIEMPRE long
    string AdmissionDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? DischargeDate,
    string? Diagnosis,
    long AttendingDoctorId
);
```

Hallazgo esperado (dato real de la base): `pain` encuentra ingresos (`Stomache Pain` con typo incluido); `stomach pain` encuentra menos o nada, porque el texto exacto del dato es `Stomache Pain` (con typo y mayúscula distinta). Es la motivación perfecta para la Unidad 3 (datos sucios).

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Patrón `LIKE` parametrizado | `$"%{dato}%"` en C# y `@patron` en el SQL; cero concatenación de strings en el SQL |
| 2 | Validación de obligatorios | `IsNullOrWhiteSpace` antes de abrir la conexión; 400 con `new { mensaje = ... }` |
| 3 | Validación numérica | `long.TryParse` para el límite; `?limit=hola` responde 400 y `?limit=5` funciona |
| 4 | 404 con mensaje en búsquedas | `if (patients.Count() == 0)` + `Results.NotFound(new { mensaje = ... })` |
| 5 | Orden de validación → consulta → 404 | Los `if` de validación están antes de la conexión; no se consulta la base con datos inválidos |
| 6 | Cobertura de casos probados | El grupo probó y puede mostrar: caso válido, criterio faltante (400), límite inválido (400), sin resultados (404) |
| 7 | Tipos canónicos intactos | `long` en ids, `string` en fechas, records al final, `Results` explícito |

## Errores esperados e intervención

| Error esperado | Causa probable | Intervención docente |
| --- | --- | --- |
| 400 que nunca aparece | Validación escrita después de la consulta | Insistir en el orden: primero se mira el dato, después se abre la conexión |
| `?limit=hola` produce 500 | El handler declara `long limit` (sin `?` y tipado) y el binding explota antes del handler | Los valores de query string que se validan a mano llegan como `string?`; el binding fuerte de números se usa cuando el formato está garantizado (`{id:long}`) |
| Búsqueda que trae de más | Patrón sin `%` (`LIKE @patron` con `patron = allergy`) | Mostrar la diferencia `'%peni%'` frente a `'peni'`; el `%` es lo que convierte comparación en búsqueda |
| Dos mensajes distintos para el mismo error en el grupo | Mensajes improvisados por integrante | Acordar el texto del mensaje en equipo (es parte del contrato de la API); en el tp-u2 deben ser coherentes |
| `OR @alergia IS NULL` copiado sin entender | La extensión se copia de otro grupo | Pedir que expliquen qué pasa cuando el parámetro es `null`; si no lo pueden explicar, volver a la práctica base y dejar la extensión para después |
| Confusión 400 vs 404 | "Los dos son errores" | Repetir la regla: 400 el pedido está roto; 404 el pedido está bien y no hay resultados; el cuerpo con `mensaje` lo confirma |

## Respuestas esperadas (verificación de comprensión)

- **¿Por qué el patrón se arma en C# y no en el SQL?** Porque el SQL recibe parámetros, no fórmulas: el `%` es parte del valor que viaja por `@patron`. Pegarlo en el SQL con `+` reintroduciría la concatenación que el curso prohíbe.
- **¿Qué revisa cada validación?** `IsNullOrWhiteSpace`: que el criterio exista (400 si no). `long.TryParse`: que el número sea número (400 si no). El 404 no valida el pedido: informa que no hubo resultados.
- **¿Por qué `long` en el límite y no `int`?** En SQLite todo entero es de 64 bits: `long` es el entero del lenguaje SQL y el tipo de todos los ids; un solo criterio menos que recordar.
- **¿Por qué los pacientes sin alergia no aparecen en `?allergy=peni`?** Su columna es `NULL` y `NULL` no coincide con ningún `LIKE`. El vacío en SQL es "dato ausente", no "texto cualquiera".
