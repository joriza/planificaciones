# Evaluación de la Unidad 2 — Anexo docente Versión A: Médicos del hospital

> Documento de uso docente. No distribuir a estudiantes.

## Solución completa esperada (Program.cs)

```csharp
// tp-u2 — Versión A: Médicos del hospital
// Endpoints GET sobre hospital.db con Dapper. Todo el código en Program.cs,
// sin abstracciones, con Minimal API de .NET 6.

using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion: hospital.db vive en la raiz del proyecto, junto al .csproj.
var connectionString = "Data Source=hospital.db";

// GET /doctors: listado completo, ordenado por apellido y nombre.
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name, first_name").ToList();

    return Results.Ok(doctors);
});

// GET /doctors/{id:int}: un medico por Id; 404 si no existe.
app.MapGet("/doctors/{id:int}", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctor = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @Id",
        // Objeto anonimo: la clave Id completa el marcador @Id. Nunca concatenar el valor.
        new { Id = id }).FirstOrDefault();

    return doctor is null ? Results.NotFound(new { mensaje = "No existe el medico" })
                          : Results.Ok(doctor);
});

// GET /doctors/by-specialty/{specialty}: filtro EXACTO con WHERE y parametro.
app.MapGet("/doctors/by-specialty/{specialty}", (string specialty) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE specialty = @Specialty
        ORDER BY last_name, first_name",
        new { Specialty = specialty }).ToList();

    // 200 con la lista, aunque venga vacia: busqueda sin coincidencias no es un error.
    return Results.Ok(doctors);
});

// GET /doctors/search?lastName=xxx: busqueda PARCIAL con LIKE (query string).
app.MapGet("/doctors/search", (string lastName) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE last_name LIKE @Pattern
        ORDER BY last_name, first_name",
        // El comodin % se arma en el VALOR; el SQL sigue siendo fijo.
        new { Pattern = "%" + lastName + "%" }).ToList();

    return Results.Ok(doctors);
});

// GET /doctors/{id:int}/patients: pacientes atendidos por el medico (JOIN).
app.MapGet("/doctors/{id:int}/patients", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero se verifica que el medico exista: 404 si no.
    // int? permite null: si la consulta no trae fila, FirstOrDefault da null.
    var exists = connection.Query<int?>(
        "SELECT doctor_id FROM doctors WHERE doctor_id = @Id",
        new { Id = id }).FirstOrDefault();

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

    // JOIN de admissions con pacientes; DISTINCT evita repetir al paciente
    // que tiene varios ingresos atendidos por el mismo medico.
    var patients = connection.Query<PatientBrief>(@"
        SELECT DISTINCT pa.patient_id AS PatientId,
               pa.first_name AS FirstName,
               pa.last_name AS LastName,
               pa.gender AS Gender
        FROM admissions a
        JOIN patients pa ON pa.patient_id = a.patient_id
        WHERE a.attending_doctor_id = @Id
        ORDER BY pa.last_name, pa.first_name",
        new { Id = id }).ToList();

    // 200 con la lista, aunque venga vacia: el medico existe. 404 solo si no existe.
    return Results.Ok(patients);
});

app.Run();

// ---- Records DTO: al final del archivo, despues de app.Run() (regla de C#). ----
// Los ids van con long: SQLite entrega los enteros como Int64.
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record PatientBrief(long PatientId, string FirstName, string LastName, string Gender);
```

Solución de referencia: se aceptan variantes equivalentes (nombres de variables, orden de declaración de los endpoints, DTO con propiedades adicionales) siempre que cumplan la consigna y la rúbrica.

Prueba esperada del flujo completo (ejemplo):

```bash
dotnet run
# GET /doctors                          -> 200 con los 27 medicos ordenados por apellido
# GET /doctors/11                       -> 200 con Douglas Brooks (Respirologist)
# GET /doctors/999                      -> 404 con mensaje
# GET /doctors/by-specialty/Urologist   -> 200 con los medicos de esa especialidad
# GET /doctors/by-specialty/Inexistente -> 200 con []
# GET /doctors/search?lastName=bro      -> 200 con Brooks, Brinkman, ...
# GET /doctors/11/patients              -> 200 con pacientes atendidos, sin repetir
# GET /doctors/999/patients             -> 404 con mensaje
```

## Casos borde y respuestas esperadas

1. **Médico inexistente (detalle y sub-recurso).** `GET /doctors/999` y `GET /doctors/999/patients` responden 404 con cuerpo similar a:

```json
{
  "mensaje": "No existe el medico"
}
```

Criterio de aceptación: la verificación de existencia se hace ANTES del JOIN en el endpoint integrador; mismo código y mensaje comprensible en ambos endpoints.

2. **Búsqueda sin coincidencias.** `GET /doctors/by-specialty/Inexistente` y `GET /doctors/search?lastName=zzz` responden 200 con un arreglo vacío `[]`. Criterio: no se devuelve 404; "sin resultados" no es "recurso inexistente".

3. **Pacientes repetidos sin DISTINCT.** Sin `DISTINCT`, un paciente con dos ingresos atendidos por el mismo médico aparece dos veces en `GET /doctors/{id}/patients`. Criterio de aceptación: ningún paciente repetido en la respuesta del endpoint integrador. Se acepta también la alternativa `GROUP BY` si el estudiante la justifica, aunque la pista de la consigna era `DISTINCT`.

## Criterios de corrección por ítem de la rúbrica

| Ítem | Logrado | Parcial | No logrado |
|---|---|---|---|
| API funcionando sobre hospital.db (25) | 20-25: compila, ejecuta `dotnet run` tras clonar y los 5 endpoints responden con datos reales | 12-19: compila y corre, pero 1 o 2 endpoints fallan (o un 500 de conexión/mapeo queda sin resolver) | 0-11: no compila, no corre o `hospital.db` falta en el repositorio |
| Consultas SQL correctas (20) | 15-20: SELECT con alias AS, WHERE con marcador `@`, LIKE con el patrón en el valor, JOIN con `ON` completo y columnas calificadas | 8-14: el SQL funciona pero con desvíos (ORDER BY ausente, filtro no calificado en el JOIN) o un marcador mal nombrado ya corregido | 0-7: SQL concatenado con los valores, JOIN sin `ON`, o consultas que no corresponden a la consigna |
| DTOs y mapeo con Dapper (15) | 12-15: records al final de Program.cs, una propiedad por alias AS, ids `long`, DTO reutilizado cuando corresponde | 6-11: mapea correctamente pero con ids `int` (sin 500 en su entorno) o DTO con propiedades de más/menos | 0-5: alias ausentes (500 de materialization) o records mezclados con la lógica del programa |
| Códigos de respuesta correctos (10) | 8-10: 200 con datos, 200 con `[]` en búsquedas, 404 con mensaje en el recurso inexistente | 4-7: 404 correcto, pero confunde búsqueda vacía con 404 (o al revés) | 0-3: códigos incorrectos o ausentes |
| Entrega por Git (15) | 12-15: carpeta tp-u2, proyecto y hospital.db commiteados, commits referentes y push dentro del encuentro | 6-11: push hecho pero `hospital.db` ausente, mensajes genéricos ("cambios", "fix") o commits únicos tardíos | 0-5: sin push, sin commits, o el proyecto no funciona tras clonar |
| Defensa individual (15) | 12-15: explica endpoints y SQL con sus palabras, justifica parámetros y códigos, realiza la modificación menor y refiere devoluciones previas incorporadas | 6-11: explica parcialmente y necesita ayudas del docente para la modificación | 0-5: no puede explicar el código ni modificarlo |

Nota sobre tipos: la regla del curso es `long` para los ids. Se acepta `int` únicamente si todos los endpoints responden sin error 500 en la máquina de la defensa (el criterio "DTOs y mapeo" baja a Parcial).

Aprobación: 60 puntos o más Y defensa realizada.

## Preguntas sugeridas para la defensa individual

Cada estudiante responde las preguntas y realiza una modificación menor, con el proyecto a la vista. Modificaciones menores válidas: cambiar el criterio de orden de un listado (`ORDER BY`), agregar una columna al SELECT y su propiedad al DTO (por ejemplo `pa.city AS City` con propiedad `City` en `PatientBrief`), cambiar el texto del mensaje 404, cambiar el término de prueba de una búsqueda. No son válidas: modificar datos de la base ni eliminar endpoints.

1. **En el record `Doctor`, ¿por qué `DoctorId` se declara `long` y no `int`?**
   Respuesta esperada: SQLite entrega los enteros como Int64; con `int` el mapeo puede fallar con un 500 (`... System.Int64 ... is required`). Menciona que los textos y las fechas viajan como `string`.
2. **Mostrar el endpoint de búsqueda: ¿dónde se arma el patrón `%...%` y por qué ahí?**
   Respuesta esperada: en el valor del objeto anónimo (`new { Pattern = "%" + lastName + "%" }`); el SQL viaja fijo y el valor viaja separado. Concatenar el valor dentro del SQL abre la puerta a la inyección SQL y rompe la sintaxis con apóstrofes.
3. **En `GET /doctors/{id:int}/patients`, ¿qué hace la condición del `ON` y qué pasaría sin ella?**
   Respuesta esperada: empareja cada ingreso con su paciente (`pa.patient_id = a.patient_id`); sin `ON` (o incompleto) se arma el producto cruzado; si además las columnas repetidas no se califican, aparece `ambiguous column name`.
4. **¿Cuándo la API responde 404 y cuándo 200 con arreglo vacío?**
   Respuesta esperada: 404 solo cuando el médico no existe (detalle o sub-recurso); 200 con `[]` cuando la búsqueda no tiene coincidencias o cuando el médico existe y no tiene pacientes atendidos.
5. **¿Qué devolución recibieron en la evaluación de la Unidad 1 y qué cambiaron en este TP a partir de ella?**
   Respuesta esperada: referencia concreta (por ejemplo, comentarios más claros, mensajes de error más explícitos, commits más frecuentes) con evidencia en el código o en el historial del repositorio. Es la expectativa oficial de "incorporar las devoluciones recibidas en instancias previas".
6. **¿Qué contiene el último commit y por qué se eligió ese mensaje?**
   Respuesta esperada: describe el contenido real del commit y lo justifica como mensaje referente: quien lee el historial entiende qué cambió sin abrir los archivos.

## Qué observar en la defensa

- Que el estudiante señale en su código el marcador `@Id` (o `@Specialty` / `@Pattern`) y el objeto anónimo correspondiente, y pueda explicar la pareja marcador-clave.
- Que distinga 404 de 200 con `[]` sin leer la consigna, y justifique cada código con el significado HTTP.
- Ante un 500 provocado por el docente (por ejemplo, quitar un alias), que diagnostique desde la terminal donde corre `dotnet run`, no desde el navegador.
- Que justifique el `DISTINCT` mostrando la repetición que aparece sin él (puede desactivarlo momentáneamente y volver a activarlo).
- Que la referencia a las devoluciones de la U1 sea concreta y verificable en el repositorio.

## Gestión del aula

- **Asignación de versión (minuto 0-15).** Por grupo, al inicio. Si el grupo resolvió la versión A en la evaluación de la Unidad 1, se sugiere asignar la versión B, y viceversa, para variar el dominio entre instancias.
- **Puntos de control durante el desarrollo (150').** Minuto 60: puntos 1 a 3 (proyecto levantado con `hospital.db`, listado y detalle funcionando). Minuto 120: puntos 4 y 5 (filtro exacto y LIKE). Minuto 150 en adelante: punto 6 (JOIN integrador) y cierre de la entrega. Los grupos atrasados en un punto de control reciben una pregunta de diagnóstico, no la solución.
- **Señales de alerta frecuentes.** 500 con `... materialization is required` → falta un alias AS. 500 con `no such table` o tabla vacía → `hospital.db` fuera de la raíz o archivo vacío creado por error: copiarlo junto al `.csproj` y borrar el `.db` vacío. 500 con `System.Int64` → ids declarados `int` en el record. 404 en búsquedas → revisar el criterio: búsqueda vacía es 200 con `[]`.
- **Grupos que llegan sin el proyecto de la clase 14.** Partir del repositorio del encuentro 14 (la rutina de commit al cierre debió dejarlo funcionando); si no, crear el proyecto desde cero con `dotnet new web`, los dos paquetes y `hospital.db` copiado.
- **Defensas (30').** En orden de lista, 3-5 minutos por estudiante, con el proyecto a la vista; el resto del grupo consolida la entrega en paralelo. Registrar el resultado por estudiante en la tabla de abajo.
- **Cierre (15').** Completar el registro de resultados, escribir acuerdos de mejora por estudiante y por grupo, y dejar anotada la devolución para el inicio del encuentro 16.

## Registro de resultados — Versión A

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
