# Anexo docente — Evaluación integradora del cuatrimestre 1 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas, los criterios de corrección ítem por ítem, los errores previstos y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion integradora cuatrimestre 1 - Version A (solucion del docente)
// Parte 1: catalogo de especialidades en memoria (Unidad 1)
// Partes 2 y 3: medicos e ingresos de hospital.db (Unidad 2)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Catalogo en memoria de la Parte 1: datos provistos por la prueba
var specialties = new List<Specialty>
{
    new(1, "Cardiologia"),
    new(2, "Pediatria"),
    new(3, "Traumatologia")
};

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1 =====

// a) GET /specialties/{id:long}: una especialidad del catalogo o 404
app.MapGet("/specialties/{id:long}", (long id) =>
{
    // Busca en la lista la primera coincidencia por id (o null)
    var specialty = specialties.FirstOrDefault(s => s.SpecialtyId == id);

    // Sin coincidencia: 404 con mensaje. Con coincidencia: 200 con la especialidad
    return specialty is null
        ? Results.NotFound(new { mensaje = "No existe esa especialidad" })
        : Results.Ok(specialty);
});

// b) POST /specialties: alta con validacion manual
app.MapPost("/specialties", (Specialty specialty) =>
{
    // Validacion manual simple: el nombre no puede quedar vacio
    if (string.IsNullOrWhiteSpace(specialty.Name))
    {
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });
    }

    // Nuevo id: el maximo de la lista mas uno (la lista nunca arranca vacia)
    var newId = specialties.Max(s => s.SpecialtyId) + 1;

    // Alta en la lista con el id calculado
    var created = new Specialty(newId, specialty.Name);
    specialties.Add(created);

    // 201 con la URL del recurso nuevo y la especialidad en el cuerpo
    return Results.Created($"/specialties/{newId}", created);
});

// ===== Parte 2 =====

// a) GET /doctors?text=...: medicos cuya especialidad contiene el texto
app.MapGet("/doctors", (string? text) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIKE con el comodin % alrededor del parametro: busqueda parcial.
    // Consulta SIEMPRE parametrizada: el texto llega por @text, nunca concatenado
    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE specialty LIKE @text
          ORDER BY specialty",
        new { text = "%" + text + "%" });

    // 200 con la lista serializada a JSON (lista vacia si no hay coincidencias)
    return Results.Ok(doctors);
});

// b) GET /doctors/{id:long}/admissions: ingresos atendidos por un medico
//    JOIN de dos tablas: admissions + doctors
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // El JOIN une cada ingreso con el medico tratante por el id;
    // las columnas snake_case llevan alias para encajar en el record
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

// ===== Parte 3 =====

// POST /doctors: alta de un medico en la base (INSERT parametrizado)
app.MapPost("/doctors", (Doctor doctor) =>
{
    // Validacion manual simple: los tres campos son obligatorios
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

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record Specialty(long SpecialtyId, string Name);
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
```

Aceptaciones válidas menores: `FirstOrDefault` resuelto con `Where(...).FirstOrDefault()` o con un `foreach`; cálculo del nuevo id con `Count() + 1` (correcto mientras no se borren elementos de la lista); `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`; `Results.Ok(connection.Query<...>(...))` sin variable intermedia. No se acepta `TypedResults` (no existe como canon en .NET 6) ni SQL concatenado.

## 2. Respuestas esperadas

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/specialties/2` | `200` con `{"specialtyId":2,"name":"Pediatria"}` |
| `GET http://localhost:5080/specialties/99` | `404` con `{"mensaje":"No existe esa especialidad"}` |
| `POST /specialties` con `{"name":"Oftalmologia"}` | `201`, encabezado `Location: /specialties/4`, cuerpo `{"specialtyId":4,"name":"Oftalmologia"}` |
| `POST /specialties` con `{"name":""}` | `400` con `{"mensaje":"El nombre es obligatorio"}` |
| `GET http://localhost:5080/doctors?text=cardio` | `200` con la lista de médicos cuya `specialty` contiene «cardio» (Cardiologist, Cardiovascular Surgeon, ...) en JSON camelCase |
| `GET http://localhost:5080/doctors?text=xyz` | `200` con `[]` (lista vacía: no hay coincidencias) |
| `GET http://localhost:5080/doctors/1/admissions` | `200` con la lista de ingresos del médico 1: `[{"admissionDate":"2018-06-07","diagnosis":"...","doctorName":"Nombre Apellido"}, ...]` |
| `POST /doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | `201`, `Location: /doctors/28` (27 médicos en la base), cuerpo con `doctorId` generado |
| `POST /doctors` con `{"firstName":"Ana","lastName":"","specialty":"Cardiologist"}` | `400` con mensaje |

Pruebas con `curl` (una línea, con `curl.exe` en PowerShell):

```powershell
curl.exe -X POST http://localhost:5080/specialties -H "Content-Type: application/json" -d "{\"name\":\"Oftalmologia\"}"
curl.exe -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"
curl.exe -i http://localhost:5080/specialties/99
```

## 3. Criterios de corrección ítem por ítem

### Parte 1 — Catálogo en memoria (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1a | Ruta `GET /specialties/{id:long}` con parámetro tipado `long id` | 3 |
| 1a | `200` con la especialidad encontrada (`Results.Ok`) | 4 |
| 1a | `404` con mensaje cuando el id no existe (`Results.NotFound`) | 3 |
| 1b | Ruta `POST /specialties` que lee el cuerpo con el record | 3 |
| 1b | Validación manual del nombre vacío con `400` y mensaje | 5 |
| 1b | `201` con la URL del recurso nuevo (`Results.Created`) y la especialidad con su id calculado | 7 |

### Parte 2 — Consultas a la base (35 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2a | Ruta `GET /doctors` con el texto por query string | 3 |
| 2a | `SELECT` con alias de columnas `snake_case` → `PascalCase` | 4 |
| 2a | `LIKE @text` parametrizado con comodines (nunca concatenado) | 5 |
| 2a | `200` con la lista en JSON (`Results.Ok`) | 3 |
| 2b | Ruta con parámetro `long id` | 3 |
| 2b | `JOIN admissions` + `doctors` con `ON` correcto | 6 |
| 2b | Alias de todas las columnas, incluido el nombre del médico concatenado | 5 |
| 2b | `WHERE` parametrizado por el id del médico y orden por fecha | 3 |
| 2b | `200` con la lista mapeada a `AdmissionOfDoctor` | 3 |

### Parte 3 — Alta en la base (20 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3 | Validación de los tres campos obligatorios con `400` y mensaje | 5 |
| 3 | `INSERT` parametrizado sobre `doctors` | 6 |
| 3 | Id generado con `ExecuteScalar<long>` (`last_insert_rowid`) | 4 |
| 3 | `201` con la URL del nuevo médico (`Results.Created`) | 5 |

### Parte 4 — Ítems conceptuales (20 puntos)

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1a | Las especialidades creadas por `POST` se pierden: la lista se reconstruye desde el código en cada ejecución | 2 |
| C1b | Los médicos quedan grabados en el archivo `hospital.db`: la base persiste aunque la API se corte | 3 |
| C2 | Verbo y código correctos: GET `404` · POST `201` · POST `400` · GET `200` (2 puntos cada fila) | 8 |
| C3a | Orden: `git add .` → `git commit -m "..."` → `git push` | 3 |
| C3b | `git commit` (con `-m` el mensaje se escribe ahí) | 2 |
| C3c | Evita versionar archivos generados; en el curso ignora `bin/` y `obj/` | 2 |

**Total: 100 puntos.** Se tolera un endpoint funcional con una convención desviada si el criterio puntual lo penaliza una sola vez; no se duplican descuentos por el mismo defecto en ítems distintos.

## 4. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `500` en `GET /doctors?text=` | Record con tipos distintos al alias, o `int` en el id | Se corrige el criterio de alias/tipos del ítem; orientar en el momento no quita el descuento |
| SQL con el texto concatenado (`"... LIKE '%" + text + "%'"`) | No parametrizó | Descuenta el ítem de parametrización; es canon de seguridad de la unidad |
| `TypedResults` en las respuestas | Confusión de versión | Se marca como defecto de versión (canon: `Results` en .NET 6); descuenta en el ítem donde aparece |
| Rutas en español (`/especialidades`) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| 404/400 sin cuerpo de mensaje | Respondió `Results.NotFound()` a secas | Descuento parcial: el código correcto puntúa, el mensaje exigido no |
| Records movidos por encima de `app.Run()` | Error CS8803 al compilar | Avisar la causa no invalida la prueba; se corrige lo que alcance a compilar |

## 5. Pauta de devolución

- Corrección individual escrita por ítem (qué puntúa, qué no y por qué), entregada al inicio del encuentro 17 junto con la devolución de las demás instancias del cuatrimestre.
- Comentarios generales al curso antes de la plenaria de metacognición: los aciertos más frecuentes (estructura de `Program.cs`, uso de `Results`) y los errores comunes (parametrización del `LIKE`, alias de columnas, códigos 400 sin mensaje).
- Los ítems no alcanzados se traducen en pistas de recuperación para los encuentros 17 y 18: cada alumno marca en su corrección los núcleos a reforzar (rutas y códigos; consultas parametrizadas; INSERT).
- La planilla de resultados registra alumno, versión (A), puntaje por parte y total sobre 100.
