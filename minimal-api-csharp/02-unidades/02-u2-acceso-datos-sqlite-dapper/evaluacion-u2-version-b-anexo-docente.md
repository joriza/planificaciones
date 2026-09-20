# Evaluación de la Unidad 2 — Anexo docente Versión B: Pacientes y provincias del hospital

> Documento de uso docente. No distribuir a estudiantes.

## Solución completa esperada (Program.cs)

```csharp
// tp-u2 — Versión B: Pacientes y provincias del hospital
// Endpoints GET sobre hospital.db con Dapper. Todo el código en Program.cs,
// sin abstracciones, con Minimal API de .NET 6.

using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion: hospital.db vive en la raiz del proyecto, junto al .csproj.
var connectionString = "Data Source=hospital.db";

// GET /patients: listado combinado patients + province_names, por apellido y nombre.
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.last_name, p.first_name").ToList();

    return Results.Ok(patients);
});

// GET /patients/{id:int}: un paciente con su provincia; 404 si no existe.
app.MapGet("/patients/{id:int}", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.patient_id = @Id",
        // Objeto anonimo: la clave Id completa el marcador @Id. Nunca concatenar el valor.
        new { Id = id }).FirstOrDefault();

    return patient is null ? Results.NotFound(new { mensaje = "No existe el paciente" })
                           : Results.Ok(patient);
});

// GET /patients/by-city/{city}: filtro EXACTO por ciudad, columna calificada con p.
app.MapGet("/patients/by-city/{city}", (string city) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.city = @City
        ORDER BY p.last_name, p.first_name",
        new { City = city }).ToList();

    // 200 con la lista, aunque venga vacia: busqueda sin coincidencias no es un error.
    return Results.Ok(patients);
});

// GET /patients/search?lastName=xxx: busqueda PARCIAL con LIKE (query string).
app.MapGet("/patients/search", (string lastName) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.last_name LIKE @Pattern
        ORDER BY p.last_name, p.first_name",
        // El comodin % se arma en el VALOR; el SQL sigue siendo fijo.
        new { Pattern = "%" + lastName + "%" }).ToList();

    return Results.Ok(patients);
});

// GET /patients/{id:int}/admissions: los ingresos reales del paciente.
app.MapGet("/patients/{id:int}/admissions", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero se verifica que el paciente exista: 404 si no.
    // int? permite null: si la consulta no trae fila, FirstOrDefault da null.
    var exists = connection.Query<int?>(
        "SELECT patient_id FROM patients WHERE patient_id = @Id",
        new { Id = id }).FirstOrDefault();

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    // Ingresos con el nombre del medico tratante: el operador || concatena
    // nombre y apellido en una sola columna, con su alias AS.
    var admissions = connection.Query<AdmissionWithDoctor>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               d.first_name || ' ' || d.last_name AS DoctorName
        FROM admissions a
        JOIN doctors d ON d.doctor_id = a.attending_doctor_id
        WHERE a.patient_id = @Id
        ORDER BY a.admission_date",
        new { Id = id }).ToList();

    // 200 con la lista, aunque venga vacia: el paciente existe. 404 solo si no existe.
    return Results.Ok(admissions);
});

app.Run();

// ---- Records DTO: al final del archivo, despues de app.Run() (regla de C#). ----
// Los ids van con long: SQLite entrega los enteros como Int64.
// Las fechas son TEXT en SQLite: viajan como string (DateOnly falla con Dapper).
record PatientWithProvince(long PatientId, string FirstName, string LastName, string? City, string ProvinceName);
record AdmissionWithDoctor(string AdmissionDate, string Diagnosis, string DoctorName);
```

Solución de referencia: se aceptan variantes equivalentes (nombres de variables, orden de declaración de los endpoints, rutas con sufijo descriptivo como `/patients/with-province`) siempre que cumplan la consigna y la rúbrica.

Prueba esperada del flujo completo (ejemplo):

```bash
dotnet run
# GET /patients                       -> 200 con las 258 filas combinadas
# GET /patients/12                    -> 200 con Emily Watson (Toronto, Ontario)
# GET /patients/9999                  -> 404 con mensaje
# GET /patients/by-city/Toronto       -> 200 con los pacientes de esa ciudad
# GET /patients/by-city/Nowhere       -> 200 con []
# GET /patients/search?lastName=son   -> 200 con Watson, Johnson, ...
# GET /patients/1/admissions          -> 200 con los ingresos del paciente (doctorName completo)
# GET /patients/9999/admissions       -> 404 con mensaje
```

## Casos borde y respuestas esperadas

1. **Paciente inexistente (detalle y sub-recurso).** `GET /patients/9999` y `GET /patients/9999/admissions` responden 404 con cuerpo similar a:

```json
{
  "mensaje": "No existe el paciente"
}
```

Criterio de aceptación: la verificación de existencia se hace ANTES del JOIN en el endpoint integrador; mismo código y mensaje comprensible en ambos endpoints.

2. **Búsqueda sin coincidencias.** `GET /patients/by-city/Nowhere` y `GET /patients/search?lastName=zzz` responden 200 con un arreglo vacío `[]`. Criterio: no se devuelve 404; "sin resultados" no es "recurso inexistente". Recordar: el filtro exacto con `=` distingue mayúsculas (`toronto` devuelve `[]`), LIKE en SQLite no.

3. **Paciente existente sin ingresos.** Si el paciente existe pero no tiene filas en `admissions`, `GET /patients/{id}/admissions` responde 200 con `[]`, nunca 404. Criterio adicional: `doctorName` llega como nombre completo ("Nombre Apellido"), armado en el SELECT con `||`.

## Criterios de corrección por ítem de la rúbrica

| Ítem | Logrado | Parcial | No logrado |
|---|---|---|---|
| API funcionando sobre hospital.db (25) | 20-25: compila, ejecuta `dotnet run` tras clonar y los 5 endpoints responden con datos reales | 12-19: compila y corre, pero 1 o 2 endpoints fallan (o un 500 de conexión/mapeo queda sin resolver) | 0-11: no compila, no corre o `hospital.db` falta en el repositorio |
| Consultas SQL correctas (20) | 15-20: SELECT con alias AS, WHERE con marcador `@`, LIKE con el patrón en el valor, JOIN con `ON` completo y columnas calificadas | 8-14: el SQL funciona pero con desvíos (ORDER BY ausente, filtro sin calificar en el JOIN) o un marcador mal nombrado ya corregido | 0-7: SQL concatenado con los valores, JOIN sin `ON`, o consultas que no corresponden a la consigna |
| DTOs y mapeo con Dapper (15) | 12-15: records al final de Program.cs, una propiedad por alias AS, ids `long`, fechas `string`, DTO reutilizado cuando corresponde | 6-11: mapea correctamente pero con ids `int` (sin 500 en su entorno) o DTO con propiedades de más/menos | 0-5: alias ausentes (500 de materialization) o records mezclados con la lógica del programa |
| Códigos de respuesta correctos (10) | 8-10: 200 con datos, 200 con `[]` en búsquedas, 404 con mensaje en el recurso inexistente | 4-7: 404 correcto, pero confunde búsqueda vacía con 404 (o al revés) | 0-3: códigos incorrectos o ausentes |
| Entrega por Git (15) | 12-15: carpeta tp-u2, proyecto y hospital.db commiteados, commits referentes y push dentro del encuentro | 6-11: push hecho pero `hospital.db` ausente, mensajes genéricos ("cambios", "fix") o commits únicos tardíos | 0-5: sin push, sin commits, o el proyecto no funciona tras clonar |
| Defensa individual (15) | 12-15: explica endpoints y SQL con sus palabras, justifica parámetros y códigos, realiza la modificación menor y refiere devoluciones previas incorporadas | 6-11: explica parcialmente y necesita ayudas del docente para la modificación | 0-5: no puede explicar el código ni modificarlo |

Nota sobre tipos: la regla del curso es `long` para los ids. Se acepta `int` únicamente si todos los endpoints responden sin error 500 en la máquina de la defensa (el criterio "DTOs y mapeo" baja a Parcial).

Aprobación: 60 puntos o más Y defensa realizada.

## Preguntas sugeridas para la defensa individual

Cada estudiante responde las preguntas y realiza una modificación menor, con el proyecto a la vista. Modificaciones menores válidas: cambiar el criterio de orden de un listado (`ORDER BY`), agregar una columna al SELECT y su propiedad al DTO (por ejemplo `pn.province_id AS ProvinceId` con propiedad `ProvinceId` en `PatientWithProvince`), cambiar el texto del mensaje 404, cambiar el término de prueba de una búsqueda. No son válidas: modificar datos de la base ni eliminar endpoints.

1. **¿Por qué las columnas del JOIN llevan `p.` y `pn.` en el SELECT?**
   Respuesta esperada: son alias cortos de tabla que califican las columnas; `province_id` existe en las dos tablas y, sin calificar, SQLite corta con `ambiguous column name`. El `ON p.province_id = pn.province_id` empareja cada paciente con su provincia.
2. **¿Qué hace el alias `AS` en el SELECT y qué error aparece si falta?**
   Respuesta esperada: renombra cada columna en el resultado para que coincida con la propiedad del record: Dapper encaja por nombre. Sin alias, el navegador muestra 500 y en la terminal aparece `... is required for ... materialization`.
3. **En `GET /patients/{id:int}/admissions`, ¿por qué se consulta primero la existencia del paciente y por qué 200 con `[]` si no tiene ingresos?**
   Respuesta esperada: 404 comunica que el recurso pedido no existe; el paciente existente sin ingresos sí existe, así que la respuesta correcta es 200 con arreglo vacío. La verificación previa evita un JOIN innecesario y permite distinguir ambos casos.
4. **¿Qué hace el operador `||` en el SELECT del endpoint de ingresos?**
   Respuesta esperada: concatena textos en SQL; `d.first_name || ' ' || d.last_name` arma el nombre completo del médico tratante en una sola columna, con su alias `AS DoctorName`, y el JSON lo entrega ya armado.
5. **¿Qué devolución recibieron en la evaluación de la Unidad 1 y qué cambiaron en este TP a partir de ella?**
   Respuesta esperada: referencia concreta (por ejemplo, comentarios más claros, mensajes de error más explícitos, commits más frecuentes) con evidencia en el código o en el historial del repositorio. Es la expectativa oficial de "incorporar las devoluciones recibidas en instancias previas".
6. **¿Qué contiene el último commit y por qué se eligió ese mensaje?**
   Respuesta esperada: describe el contenido real del commit y lo justifica como mensaje referente: quien lee el historial entiende qué cambió sin abrir los archivos.

## Qué observar en la defensa

- Que el estudiante señale en su código la pareja marcador-objeto anónimo (`@Id` ↔ `new { Id = id }`, `@Pattern` ↔ `new { Pattern = "%" + lastName + "%" }`) y explique por qué el valor no se concatena al SQL.
- Que distinga 404 de 200 con `[]` sin leer la consigna, y justifique cada código con el significado HTTP.
- Ante un 500 provocado por el docente (por ejemplo, quitar un alias o descalificar `province_id`), que diagnostique desde la terminal donde corre `dotnet run`: `materialization` indica alias faltante; `ambiguous column name`, columna sin calificar.
- Que justifique el `JOIN` mostrando qué aportan las dos tablas al DTO combinado y qué pasaría sin la condición del `ON` (producto cruzado).
- Que la referencia a las devoluciones de la U1 sea concreta y verificable en el repositorio.

## Gestión del aula

- **Asignación de versión (minuto 0-15).** Por grupo, al inicio. Si el grupo resolvió la versión A en la evaluación de la Unidad 1, se sugiere asignar la versión B, y viceversa, para variar el dominio entre instancias.
- **Puntos de control durante el desarrollo (150').** Minuto 60: puntos 1 a 3 (proyecto levantado con `hospital.db`, listado combinado y detalle funcionando). Minuto 120: puntos 4 y 5 (filtro exacto y LIKE). Minuto 150 en adelante: punto 6 (ingresos con JOIN y `||`) y cierre de la entrega. Los grupos atrasados en un punto de control reciben una pregunta de diagnóstico, no la solución.
- **Señales de alerta frecuentes.** 500 con `... materialization is required` → falta un alias AS. 500 con `ambiguous column name` → columna del JOIN sin calificar. 500 con `no such table` o tabla vacía → `hospital.db` fuera de la raíz o archivo vacío creado por error: copiarlo junto al `.csproj` y borrar el `.db` vacío. 500 con `System.Int64` → ids declarados `int` en el record. 404 en búsquedas → revisar el criterio: búsqueda vacía es 200 con `[]`.
- **Grupos que llegan sin el proyecto de la clase 14.** Partir del repositorio del encuentro 14 (la rutina de commit al cierre debió dejarlo funcionando); si no, crear el proyecto desde cero con `dotnet new web`, los dos paquetes y `hospital.db` copiado.
- **Defensas (30').** En orden de lista, 3-5 minutos por estudiante, con el proyecto a la vista; el resto del grupo consolida la entrega en paralelo. Registrar el resultado por estudiante en la tabla de abajo.
- **Cierre (15').** Completar el registro de resultados, escribir acuerdos de mejora por estudiante y por grupo, y dejar anotada la devolución para el inicio del encuentro 16.

## Registro de resultados — Versión B

| Grupo | Estudiante | API (25) | SQL (20) | Mapeo (15) | Códigos (10) | Git (15) | Defensa (15) | Total (/100) | Defensa realizada (Sí/No) | Resultado | Acuerdos de mejora |
|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |

Resultado: Aprobado (60 o más y defensa realizada) / No aprobado. Devolución al inicio del encuentro 16.
