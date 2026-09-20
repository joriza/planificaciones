# Encuentro 11 — Consultas parametrizadas: WHERE, ORDER BY y query string

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 11 de 36 |
| Unidad | Unidad didáctica 2: Acceso a datos con SQLite y Dapper (clase 2 de 4) |
| Momento | Clase regular de unidad |
| Eje temático | Nº 2 — Acceso a datos con Dapper |
| Carácter/Objetivo | Procedimental: parametrizar, ordenar y recortar consultas |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Consultas parametrizadas (`WHERE ... = @id` + objeto anónimo); `QueryFirstOrDefault<T>`; parámetro de ruta `{id:long}`; `ORDER BY` en SQL; query string (`?city=`, `?limit=`) como entrada del endpoint; `LIMIT` en SQL |
| Requisitos previos | Clase 10 completa: proyecto `u2-api` con conexión a `hospital.db` y `GET /patients` funcionando; U1: parámetros de ruta y records |
| Uso de celular | No permitido |
| Registro | Didáctico: material de clase dirigido al estudiante (el anexo docente va en archivo separado) |
| Grupos | Alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar; rotación de integrantes en la práctica y el ejercicio |
| Planificación anual | Encuentro 11: consultas parametrizadas: WHERE, ORDER BY, parámetros de ruta y query string sobre la base |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (20 min).** Ayer la API devolvió siempre la estantería completa: 258 pacientes en cada pedido. Pregunta disparadora: si el médico necesita *una* historia, ¿para qué traer las 258? Hoy el endpoint aprende a recibir un dato del afuera (el id de la ruta, un valor por query string) y a meterlo **adentro** de la consulta SQL sin romperla: eso es una consulta parametrizada. De paso, la base aprende a entregar ordenado (`ORDER BY`) y recortado (`LIMIT`).

Al finalizar el encuentro, cada estudiante puede:

1. Explicar por qué el valor va por parámetro (`@id` + `new { id }`) y nunca pegado al SQL con `+`.
2. Construir un endpoint `GET /patients/{id:long}` que devuelva un paciente con `QueryFirstOrDefault<T>` y responda 404 cuando el id no existe.
3. Ordenar el resultado de una consulta con `ORDER BY` por apellido y nombre.
4. Leer valores de query string (`?city=`, `?limit=`) y usarlos como parámetros de la consulta, con `LIMIT` para recortar.
5. Verificar las respuestas en el navegador combinando ruta y query string.

## 3. Teoría mínima (40 min)

### Charla rápida: el pedido preciso al archivo

En el archivo de historias clínicas nadie dice "traigan todas las planillas". El pedido preciso suena así: "la historia número 47", o bien "las historias de la sala 3, ordenadas por apellido, y traé solo cinco". El empleado del archivo no rehace la estantería: recibe **el dato del pedido** y lo usa para buscar.

Una consulta parametrizada es exactamente eso: la consulta tiene un hueco (`@id`) y el dato del pedido viaja por un canal seguro hasta ese hueco.

### Parametrizar: el hueco y el dato por separado

```csharp
WHERE patient_id = @id        // el hueco, adentro del SQL
new { id }                    // el dato, en un objeto anonimo aparte
```

Dapper toma el objeto anónimo y le entrega a SQLite cada propiedad como parámetro: el nombre de la propiedad completa el nombre del hueco (`id` → `@id`). El valor **nunca se pega al texto del SQL** con `+`:

- El SQL con `+` rompe con las comillas: pedir `O'Brien` a una consulta concatenada la rompe en pedazos.
- El SQL con `+` abre la puerta a la inyección SQL: quien controla el texto que se pega, controla la consulta.
- El SQL parametrizado manda el texto y el dato por canales separados: SQLite se ocupa de las comillas y del peligro.

Regla del curso desde hoy: **jamás se concatena el SQL con datos recibidos**.

### Tres formas de entrar el dato

| Entrada | Ejemplo | Dónde aterriza |
| --- | --- | --- |
| Parámetro de ruta | `GET /patients/25` | `app.MapGet("/patients/{id:long}", (long id) => ...)` |
| Query string | `GET /patients/by-city?city=Toronto&limit=5` | `(string? city, int? limit) => ...` |
| Valor fijo de la consulta | `ORDER BY last_name` | Escrito en el SQL, no viene del afuera |

La restricción `{id:long}` hace doble trabajo: documentar la ruta y rechazar lo que no es número (`/patients/abc` no entra al handler: sin la restricción, ese pedido llega convertido en un id inválido).

### ORDER BY y LIMIT: ordenar y recortar en SQL

- `ORDER BY last_name, first_name` ordena por apellido y, si hay empate, por nombre. El orden también podría hacerlo C#, pero el trabajo le corresponde a la base: llega ordenado y el código no toca la lista.
- `LIMIT 5` recorta la respuesta a las primeras 5 filas. En el navegador es la diferencia entre leer 5 objetos y leer 258.
- El `LIMIT` también se parametriza: `LIMIT @max` con `max` en el objeto anónimo.

### QueryFirstOrDefault: una fila o nada

`Query<T>` devuelve la lista completa. Para buscar una sola fila existe `QueryFirstOrDefault<T>`: devuelve la primera fila mapeada o `null` si no hubo filas. Ese `null` es la señal perfecta para el 404: `patient is null ? Results.NotFound() : Results.Ok(patient)`.

## 4. Práctica guiada (70 min)

### Paso 1 — Partir del proyecto de la unidad

Abrir `u2-api/` en VS Code (el proyecto de la clase 10 con `GET /patients` funcionando). Hoy el archivo crece: se modifica `GET /patients`, se agregan `GET /patients/{id:long}` y `GET /patients/by-city`.

### Paso 2 — Ordenar la lista completa

En `GET /patients`, agregar `ORDER BY` al final del SELECT: la lista llega ordenada por apellido y nombre, sin tocar una línea de C#.

### Paso 3 — Reemplazar Program.cs completo

Reemplazar todo el contenido de `Program.cs` por este archivo (última versión completa del encuentro; incluye los dos endpoints nuevos):

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

    // ORDER BY en SQL: la base entrega la lista ya ordenada;
    // empate de apellido lo desempata el nombre
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

// GET /patients/{id}: UN paciente segun su id (parametro de ruta)
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Consulta PARAMETRIZADA: el hueco es @id y el dato viaja en
    // new { id }. Nunca se pega el valor al texto del SQL con +
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
        new { id });   // objeto anonimo: la propiedad id llena el hueco @id

    // QueryFirstOrDefault trajo null: no existe ese paciente -> 404
    return patient is null ? Results.NotFound()
                           : Results.Ok(patient);
});

// GET /patients/by-city?city=Toronto&limit=5
// Query string: valores opcionales que llegan por nombre (?city=...)
app.MapGet("/patients/by-city", (string? city, int? limit) =>
{
    // Si no vino ?limit=, se muestran 10 (valor por defecto)
    int max = limit ?? 10;

    using var connection = new SqliteConnection(connectionString);

    // WHERE city = @city compara exacto; LIMIT @max recorta el resultado.
    // Los dos valores viajan parametrizados en el mismo objeto anonimo
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
          WHERE city = @city
          ORDER BY last_name, first_name
          LIMIT @max",
        new { city, max });   // city y max completan @city y @max

    return Results.Ok(patients);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Paciente: una fila de la tabla patients. Id SIEMPRE long, fecha SIEMPRE string
record Patient(
    long PatientId,      // id: SIEMPRE long (nunca int)
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd" (nunca DateTime)
    string? City,        // nullable: la columna acepta NULL
    string ProvinceId,
    string? Allergies,
    int? Height,
    int? Weight
);
```

### Paso 4 — Probar los tres endpoints en el navegador

| Pedido | Qué esperar |
| --- | --- |
| `http://localhost:5080/patients` | Los 258 pacientes ordenados por apellido y nombre |
| `http://localhost:5080/patients/7` | Un solo objeto: el paciente con `patientId` 7 (los valores dependen de la copia de la base) |
| `http://localhost:5080/patients/99999` | Página de 404 del navegador: no existe ese id, `Results.NotFound()` respondió sin cuerpo |
| `http://localhost:5080/patients/by-city?city=Toronto&limit=5` | Hasta 5 pacientes de Toronto, ordenados por apellido |
| `http://localhost:5080/patients/by-city?city=Toronto` | Sin `?limit=`: hasta 10 (el valor por defecto `limit ?? 10`) |
| `http://localhost:5080/patients/abc` | 404: la restricción `{id:long}` rechaza lo que no es número |

Observación pautada: si se pide `?city=` sin valor, la lista llega vacía (`[]`). Es un comportamiento incómodo que hoy se registra tal cual: en la próxima clase se agrega la validación para responder 400 con un mensaje.

### Salida esperada (verificada)

La respuesta de `GET /patients/by-city?city=Toronto&limit=2` es un arreglo JSON con hasta 2 objetos con esta estructura exacta (los valores de fila dependen de la copia de la base; la ciudad y el límite sí se verifican en cada pedido):

```json
[
  {
    "patientId": 1,
    "firstName": "Susan",
    "lastName": "Zhang",
    "gender": "F",
    "birthDate": "1955-10-13",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": null,
    "height": 165,
    "weight": 68
  }
]
```

## 5. Ejercicio independiente (50 min)

### Consigna

Sobre el mismo proyecto `u2-api`, agregar dos endpoints sobre la tabla `doctors` y la tabla `patients`:

1. `GET /doctors/{id:long}`: un médico por id, con `QueryFirstOrDefault<Doctor>`; id inexistente → 404. (Si no agregaste `GET /doctors` en la clase 10, agregalo ahora con `ORDER BY last_name, first_name`.)
2. `GET /patients/by-province?province=ON&limit=10`: pacientes de una provincia por su código (la base es 95% Ontario: con `ON` van a ver la escala de verdad), ordenados por apellido y nombre, con límite opcional por defecto 10.

Requisitos: consultas SIEMPRE parametrizadas (`new { id }`, `new { province, max }`), comentarios explicando el hueco `@` de cada consulta, y prueba en el navegador de cada endpoint incluyendo un caso de id inexistente.

### Pista

Los dos endpoints son variaciones del Paso 3: el primero es el gemelo de `GET /patients/{id:long}` con la tabla y el record cambiados; el segundo es el gemelo de `/by-city` con la columna `province_id` en el `WHERE`. No escribas nada que no esté ya en el archivo. La solución completa está en el anexo docente y se corrige en la puesta en común del bloque siguiente.

## 6. Extensión y consolidación (45 min)

Actividades explícitas del bloque (la solución de la extensión está en el anexo docente):

1. **Consolidación: cacería del `+`.** Cada integrante explica con sus palabras qué rompería `"... WHERE patient_id = " + id` y por qué `new { id }` es la única forma aceptada en el curso. Luego probar el ejemplo de la nota al pie del anexo (pedir `O'Brien` a una consulta concatenada): ver la rotura de comillas en vivo, para no olvidarla.
2. **Extensión: `GET /doctors/by-specialty?specialty=Cardiologist&limit=5`.** Médicos de una especialidad exacta, ordenados por apellido, con límite opcional. Con `Cardiologist` y con `Internist` hay resultados; con una especialidad inventada, lista vacía (la validación de ese caso llega en la clase 12).
3. **Explorar `?limit=0` y `?limit=-1`.** Con `0` la base no devuelve nada; en SQLite, un `LIMIT` negativo significa "sin límite" (devuelve todo). Es un buen recordatorio de que el `LIMIT` lo interpreta la base, no la API: la validación de este tipo de valores es tema de la próxima clase.
4. **Commit de avance.** `git add .`, `git commit -m "Clase 11: consultas parametrizadas, order by y query string"` y `git push`.

## 7. Cierre (15 min)

### Qué te llevás

- Consulta parametrizada = hueco (`@id`) + dato aparte (`new { id }`): nunca se pega el valor al SQL con `+`.
- `{id:long}` tipa la ruta y rechaza lo que no es número antes de llegar al handler.
- `QueryFirstOrDefault<T>` devuelve una fila o `null`: ese `null` se convierte en 404 con un ternario.
- `ORDER BY last_name, first_name` ordena en la base; `LIMIT @max` recorta el resultado y también se parametriza.
- La query string llega por nombre (`?city=Toronto&limit=5`) y permite valores opcionales con `??` (valor por defecto).

### Lo que viene

- Encuentro 12: filtros WHERE y LIKE, búsquedas, validación manual simple, 400/404. Hoy quedó pendiente el `?city=` vacío que devuelve una lista vacía incómoda: la próxima clase agrega la validación manual (`IsNullOrWhiteSpace`, `TryParse`) para responder 400 con mensajes claros, y el `LIKE` para buscar por partes del texto (alergias, ciudades).

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 11: consultas parametrizadas, order by y query string"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Concatenar el SQL con `+` | "Es más fácil así": costumbre de armar strings | Parametrizar siempre: `WHERE patient_id = @id` + `new { id }`; la concatenación rompe con comillas y habilita inyección SQL |
| El handler no recibe el id | Ruta sin restricción o parámetro mal nombrado: `/patients/{id}` con `(long id)` está bien; `/patients/{Id}` con `(long id)` no matchea | El nombre entre llaves y el parámetro del handler deben coincidir; mantener `{id:long}` + `(long id)` |
| `LIMIT @max` no recorta | El objeto anónimo no incluye `max` (o el nombre no coincide) | Cada hueco `@` necesita su propiedad en `new { ... }`; revisar nombres uno a uno |
| 500 con "must not be null" en query string | Declarar `string city` (sin `?`) y no enviar `?city=` | En query string los valores opcionales van `string? city`; los obligatorios se validan a mano (clase 12) |
| Creer que el 404 es un error del programa | `Results.NotFound()` responde sin cuerpo y el navegador muestra su página de error | Es la respuesta correcta: el recurso no existe. En la clase 12 el 404 pasa a llevar mensaje legible |
| Ordenar en C# en vez de en SQL | `patients.OrderBy(...)` después de traer todo | El trabajo es de la base: `ORDER BY` en el SELECT; el código no reordena listas traídas de la base |
