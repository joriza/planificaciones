# Anexo docente — Encuentro 14: escritura con Dapper, cierre de la Unidad 2 y entrega del tp-u2

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 14 — cierre de la Unidad 2: escritura con Dapper (INSERT/UPDATE/DELETE parametrizados sobre `doctors`), consolidación, trabajo del tp-u2 y ciclo de entrega |
| Formato | Plantilla de cierre de unidad (apertura 15 · consolidación 75 · trabajo del TP 90 · ciclo de entrega 45 · cierre 15) |
| Producción esperada | Proyecto `u2-api` con CRUD completo de médicos; carpeta `tp-u2/` del repositorio con la API de la consigna, commits de avance y push verificado en GitHub |
| Insumos | Proyecto `u2-api` de las clases 10 a 13; repositorio del grupo con remoto configurado (ciclo del Encuentro 8); `hospital.db` |

**Nota técnica (código del UPDATE sobre la base):** en la Unidad 1, con listas en memoria, el reemplazo respondía 200 con el recurso. Sobre la base, el curso fija **204 No Content** para el UPDATE y el DELETE correctos: la escritura ya quedó hecha y la respuesta no necesita cuerpo. La variante 200 con el recurso actualizado es igualmente válida en REST; si un grupo la defiende con argumentos en la evaluación, aceptarla con la condición de que la respuesta sea explícita (`Results` en todos los caminos) y consistente en todo el trabajo.

**Verificación previa a la clase:** la referencia de `doctors` es estable (27 médicos, idéntica en todas las copias), por lo que el id asignado a la primera alta de la práctica es el 28. Si la copia de la base difiere, ajustar el id esperado del Paso 3.

## Solución completa del ejercicio independiente (solución modelo del tp-u2)

Program.cs completo de referencia para la consigna (los grupos pueden elegir recursos y rutas equivalentes; el modelo usa lecturas de pacientes con filtros, JOIN pacientes-provincias y escritura de médicos):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// REQUISITO 1 - Lecturas: lista con ORDER BY
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

// REQUISITO 1 - Lecturas: por id con 404 con mensaje
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

// REQUISITO 2 - Busqueda filtrada: LIKE por alergia + 400 + 404
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

// REQUISITO 3 - Cruce: JOIN de dos tablas con record compuesto
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

// REQUISITO 4 - Escritura sobre doctors: ALTA (201)
app.MapPost("/doctors", (DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Specialty });

    var created = new Doctor(newId, input.FirstName, input.LastName, input.Specialty);
    return Results.Created($"/doctors/{newId}", created);
});

// REQUISITO 4 - Escritura sobre doctors: REEMPLAZO (404/204)
app.MapPut("/doctors/{id:long}", (long id, DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

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

    return Results.NoContent();
});

// REQUISITO 4 - Escritura sobre doctors: BAJA (404/204)
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    int rows = connection.Execute(
        "DELETE FROM doctors WHERE doctor_id = @id",
        new { id });

    if (rows == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico con ese id" });
    }

    return Results.NoContent();
});

// Lecturas de apoyo: lista de medicos (para verificar las escrituras)
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          ORDER BY last_name, first_name");

    return Results.Ok(doctors);
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

// Record compuesto del JOIN pacientes + provincias
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

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// Entrada del POST/PUT: sin id (lo asigna la base)
record DoctorInput(string FirstName, string LastName, string Specialty);
```

**Pasada de revisión durante el bloque** (ver más abajo). La solución modelo anterior cubre los requisitos mínimos; el bloque de extensión del tp-u2 es la variante que sigue.

## Solución de la extensión

**Variante con escritura sobre `patients` (camino difícil, para grupos que la elijan):** el INSERT de paciente exige `province_id` existente (clave foránea a `province_names`); el flujo recomendado es validar el código contra `GET /provinces` (o contra una consulta de conteo) antes de insertar y responder 400 con mensaje si no existe. La fecha de nacimiento viaja como `string` ISO y se valida solo el formato de texto (`yyyy-MM-dd`) con `DateTime.TryParse` **recién en la validación de entrada**, nunca en el record. Si el grupo la implementa correcta, es evidencia de extensión; si falla en la clave foránea, es el caso de intervención del cuadro de errores.

**Otras extensiones válidas del tp-u2** (todas con piezas ya vistas): búsqueda combinada por query string con dos criterios; segundo JOIN (ingresos con médico, `AdmissionWithDoctor`); criterio opcional con el truco `OR @param IS NULL`; endpoint `/provinces` para alimentar el alta de pacientes con códigos válidos.

## Pasada de revisión durante el bloque del TP (90 min)

| Momento | Qué revisar por grupo |
| --- | --- |
| Minuto 25-35 (primera pasada) | Carpeta `tp-u2/` creada con proyecto y base; lecturas corriendo; primer commit hecho |
| Minuto 60-70 (segunda pasada) | Búsqueda filtrada con 400/404 y JOIN funcionando; escritura en progreso |
| Minuto 85 (tercera pasada, corta) | Ciclo de entrega encaminado: commits con convención `tp-u2: ...` y push |

Intervención por defecto: preguntar qué requisito está tocando el grupo y hacer que muestren la prueba del último endpoint funcionado antes de aportar cualquier corrección.

## Criterios de corrección del tp-u2

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Lecturas completas | Lista con `ORDER BY`; por id con `QueryFirstOrDefault` y 404 con mensaje |
| 2 | Búsqueda filtrada con validación | `LIKE` o igualdad por query string; 400 con mensaje por criterio faltante o inválido; 404 con mensaje sin resultados |
| 3 | JOIN de dos tablas | `JOIN ... ON` con alias de tabla y record compuesto al final del archivo |
| 4 | Escritura completa parametrizada | POST (201 con `Location`), PUT (404/204 con filas afectadas), DELETE (404/204); huecos `@` + objetos anónimos, sin concatenación |
| 5 | Validación de entrada del cuerpo | `IsNullOrWhiteSpace` en los tres campos antes de escribir |
| 6 | Canon de tipos y estructura | Ids `long`, fechas `string` ISO, records al final, `Results` explícito, todo en `Program.cs` |
| 7 | Ciclo de entrega | Carpeta `tp-u2/` en el remoto; al menos 3 commits con convención `tp-u2: ...`; push verificado en GitHub web |
| 8 | Defensa anticipada (preparación) | El grupo puede mostrar y explicar la prueba de cada requisito (URL probada → respuesta) |

## Errores esperados e intervención

| Error esperado | Causa probable | Intervención docente |
| --- | --- | --- |
| 500 en el DELETE del médico de referencia | Clave foránea: el médico tiene ingresos | Recordar el Paso 4 de la práctica; pedir probar con el médico creado por POST y explicar qué protegió la base |
| POST sin efecto visible | Falta `Content-Type: application/json` o comillas sin escapar en PowerShell | Revisar el curl línea por línea contra la práctica; usar `curl.exe` |
| PUT con 204 pero sin cambio real | Objeto anónimo sin la propiedad `id` (el `WHERE` no matchea... y respondería 404) o `SET` con columnas sin alias de parámetro | Si respondió 204, el id existía: verificar con el GET posterior y comparar campo por campo |
| `last_insert_rowid()` en 0 | INSERT y SELECT en llamadas o conexiones separadas | Mostrar la forma canónica: una sola llamada a `ExecuteScalar<long>` con las dos consultas |
| Escritura sobre `patients` con 500 | `province_id` inexistente (clave foránea) o fecha en formato no texto | Derivar al camino recomendado (`doctors`) o exigir la validación previa del código de provincia |
| Commit único gigante al final | No versionaron por requisito | En la primera pasada: exigir el primer commit de las lecturas; en la entrega, aceptar el historial tal como está y registrarlo como pendiente de proceso |
| Carpeta fuera de la raíz del repo | Proyecto creado fuera del repositorio del grupo | Mover la carpeta `tp-u2/` a la raíz del repo antes del push; verificar el árbol en GitHub |

## Respuestas esperadas (verificación de comprensión)

- **¿Cómo sabe la API que el id no existía en un PUT/DELETE?** Por la cantidad de filas afectadas que devuelve `Execute`: 0 filas significa que el `WHERE` no encontró a nadie y nada se escribió; eso se convierte en 404 con mensaje.
- **¿Por qué el record de entrada no tiene id?** Porque en el alta el id lo asigna la base (`last_insert_rowid()`), y en el cambio o la baja el id viaja por la ruta. Un id en el cuerpo sería una promesa que la API no debe aceptar.
- **¿Qué diferencia hay entre 201 y 204?** 201Created: se creó un recurso nuevo y la respuesta incluye su URL (`Location`) y su cuerpo. 204 No Content: el cambio quedó hecho y no hay nada nuevo que mostrar; respuesta sin cuerpo.
- **¿Qué protegió la base cuando se intentó borrar al médico con ingresos?** La integridad referencial: `admissions.attending_doctor_id` apunta a ese médico y la base no permite dejar filas huérfanas. El error llega como 500 y se lee en la terminal (`FOREIGN KEY constraint failed`).
- **¿Dónde quedaron los datos del médico creado?** En el archivo `hospital.db`, en disco: sobreviven al reinicio de la API. Es la persistencia que abrió la unidad.
