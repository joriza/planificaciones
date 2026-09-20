# Encuentro 12 — Filtros WHERE y LIKE, búsqueda y validación (400/404)

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 12 de 36 |
| Unidad | Unidad didáctica 2: Acceso a datos con SQLite y Dapper (clase 3 de 4) |
| Momento | Clase regular de unidad |
| Eje temático | Nº 2 — Acceso a datos con Dapper |
| Carácter/Objetivo | Procedimental: filtrar por partes del texto y validar entradas |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | `LIKE` con patrón `%...%` para búsqueda parcial; búsqueda combinada por query string; validación manual (`IsNullOrWhiteSpace`, `long.TryParse`); respuestas con cuerpo legible: 400 con mensaje y 404 con mensaje |
| Requisitos previos | Clases 10 y 11 completas: conexión, `GET /patients/{id:long}` con 404, query string con `?limit=`; U1: códigos de estado HTTP |
| Uso de celular | No permitido |
| Registro | Didáctico: material de clase dirigido al estudiante (el anexo docente va en archivo separado) |
| Grupos | Alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar; rotación de integrantes en la práctica y el ejercicio |
| Planificación anual | Encuentro 12: filtros WHERE y LIKE, búsquedas, validación manual simple, 400/404 |

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

**Apertura y puente (20 min).** Ayer quedó un cabo: pedir `?city=` vacío devuelve una lista vacía y el cliente no sabe qué hizo mal. Pregunta disparadora: cuando el dato que llega está mal, ¿quién se lo tiene que decir, la lista vacía o la API con un mensaje claro? Hoy el endpoint aprende dos cosas: a buscar por **partes** del texto (`LIKE` con `%`: escribir `Peni` y encontrar `Penicillin`) y a **validar** lo que llega antes de consultar la base, respondiendo 400 con un mensaje en español. Además, la búsqueda pasa a combinar varios criterios a la vez.

Al finalizar el encuentro, cada estudiante puede:

1. Construir filtros de búsqueda parcial con `LIKE '%...%'` sobre columnas de texto (alergias, ciudades), parametrizando el patrón.
2. Armar una búsqueda combinada por query string que filtre por dos criterios juntos.
3. Validar manualmente la entrada con `IsNullOrWhiteSpace` (texto obligatorio) y `long.TryParse` (número válido), respondiendo 400 con `new { mensaje = ... }`.
4. Responder 404 con mensaje cuando la búsqueda no trae resultados, en lugar de devolver una lista vacía.
5. Probar en el navegador los caminos buenos y los caminos malos de cada endpoint (caso válido, criterio faltante, límite inválido, sin resultados).

## 3. Teoría mínima (40 min)

### Charla rápida: el índice del archivo

En el archivo de historias, nadie busca "la historia de alguien cuyo apellido empieza con algo parecido a Cas..." leyendo las 258 planillas: mira el índice. Pero para las búsquedas raras ("¿quién registró alergia a la penicilina?") el empleado hojea y compara **porciones** del texto: no necesita la palabra completa, le alcanza el pedazo.

`LIKE` es la orden de comparar porciones: `WHERE allergies LIKE '%Peni%'` encuentra toda fila cuya alergia contenga "Peni" en cualquier posición.

### LIKE y el patrón %

El `%` en el patrón significa "acá puede haber cualquier cosa, incluso nada":

| Patrón | Encuentra | No encuentra |
| --- | --- | --- |
| `'Peni%'` | Empieza con "Peni" (`Penicillin`) | `Sulfa` |
| `'%pen'` | Termina con "pen" | `Penicillin` |
| `'%Peni%'` | Contiene "Peni" en cualquier posición (`Penicillin`) | `Sulfa` |

En la API el patrón se arma alrededor del dato que llegó, **antes** de mandarlo como parámetro:

```csharp
new { patron = $"%{allergy}%" }   // el dato viaja envuelto en el patron
```

El SQL queda `WHERE allergies LIKE @patron`: el hueco `@patron` recibe el patrón completo. La regla de la clase 11 no cambia: **el valor viaja siempre por parámetro**; lo único nuevo es que el valor es un patrón.

Detalle que conviene saber: `LIKE` distingue mayúsculas de minúsculas según la configuración de la base; en SQLite, para texto ASCII, la comparación es insensible a mayúsculas por defecto (`peni` también encuentra `Penicillin`). Los pacientes sin alergia (`NULL`) no aparecen nunca: `NULL` no coincide ni con `LIKE '%%'`.

### Validación manual: mirar el dato antes de gastar la consulta

La API no puede confiar en lo que llega por la URL. Validar es barato; consultar la base con un dato basura es caro y confuso. Dos validaciones cubren casi todo:

| Herramienta | Qué revisa | Ejemplo |
| --- | --- | --- |
| `string.IsNullOrWhiteSpace(x)` | Que no venga vacío, `null` o solo espacios | El criterio de búsqueda es obligatorio |
| `long.TryParse(texto, out valor)` | Que el texto sea un número entero válido | `?limit=hola` → 400; `?limit=5` → sigue |

Para el `limit` se usa `long` porque en SQLite todo entero entra como `long`: un solo tipo entero para los números del lenguaje SQL y para los ids.

### Los códigos que hablan: 400 y 404 con mensaje

Desde la Unidad 1 el curso usa `Results`; hoy se completa el criterio de cuándo va cada uno:

- **400 Bad Request**: el pedido está roto antes de llegar a la base (falta el criterio, el límite no es número). Siempre con cuerpo legible: `Results.BadRequest(new { mensaje = "..." })`.
- **404 Not Found**: el pedido era válido, pero la base no tiene nada que responder (ningún paciente con esa alergia). También con cuerpo: `Results.NotFound(new { mensaje = "..." })`.

La diferencia conceptual: **400 = el pedido está mal; 404 = el pedido está bien y no hay resultados**. La lista vacía `[]` queda reservada para los casos en que vacío es una respuesta útil; en las búsquedas de hoy, vacío se dice con 404 y palabra.

## 4. Práctica guiada (70 min)

### Paso 1 — Partir del proyecto de la unidad

Abrir `u2-api/` (clases 10 y 11). El archivo de hoy mantiene `GET /patients` y `GET /patients/{id:long}` (con el 404 mejorado con mensaje) y agrega dos endpoints de búsqueda: `GET /patients/by-allergy` y `GET /patients/search`. Si conservaste los endpoints de búsqueda de la clase 11 (`/by-city`, `/by-province`), pueden convivir: el listado de referencia de hoy muestra la base común más lo nuevo.

### Paso 2 — Reemplazar Program.cs completo

Reemplazar todo el contenido de `Program.cs` por este archivo (última versión completa del encuentro):

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

// GET /patients/{id}: UN paciente segun su id
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

    // Desde hoy el 404 lleva mensaje legible para el cliente
    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente con ese id" });
    }

    return Results.Ok(patient);
});

// GET /patients/by-allergy?allergy=Peni
// Busqueda parcial por alergia con LIKE: 'Peni' encuentra 'Penicillin'
app.MapGet("/patients/by-allergy", (string? allergy) =>
{
    // Validacion 1: sin texto no hay nada que buscar -> 400 con mensaje
    if (string.IsNullOrWhiteSpace(allergy))
    {
        return Results.BadRequest(new { mensaje = "Indique una alergia para buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    // El patron se arma alrededor del dato ANTES de mandarlo:
    // el valor viaja igual de parametrizado (@patron)
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

    // Validacion 2: el pedido era valido pero no hubo resultados -> 404
    if (patients.Count() == 0)
    {
        return Results.NotFound(new { mensaje = "Ningun paciente con esa alergia" });
    }

    return Results.Ok(patients);
});

// GET /patients/search?city=tor&allergy=pen&limit=5
// Busqueda combinada: ciudad Y alergia a la vez, con limite opcional
app.MapGet("/patients/search", (string? city, string? allergy, string? limit) =>
{
    // Validacion 1: los dos criterios son obligatorios en esta busqueda
    if (string.IsNullOrWhiteSpace(city) || string.IsNullOrWhiteSpace(allergy))
    {
        return Results.BadRequest(new { mensaje = "Indique ciudad y alergia para buscar" });
    }

    // Validacion 2: si viene ?limit=, tiene que ser un numero entero.
    // En SQLite todo entero entra como long: long.TryParse cubre cualquier limite.
    // Si no viene, queda el valor por defecto 20
    long max = 20;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Dos LIKE combinados con AND: la fila tiene que cumplir los dos
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
    string? Allergies,   // nullable: sin alergia = NULL (no matchea LIKE)
    int? Height,
    int? Weight
);
```

### Paso 3 — Probar los caminos buenos y los caminos malos

Cada endpoint tiene dos caminos: el válido y los inválidos. Probarlos TODOS es parte de la práctica (el navegador alcanza; para ver el cuerpo del 400/404 conviene `curl.exe -i`):

| Pedido | Respuesta esperada |
| --- | --- |
| `/patients/by-allergy?allergy=Peni` | 200 con los pacientes con `Penicillin` (la alergia más común de la base) |
| `/patients/by-allergy?allergy=` | 400 con `{"mensaje":"Indique una alergia para buscar"}` |
| `/patients/by-allergy?allergy=Kryptonita` | 404 con mensaje: el pedido era válido, no hay resultados |
| `/patients/search?city=tor&allergy=pen&limit=2` | 200 con hasta 2 pacientes de ciudades que contengan "tor" y alergia "Pen..." |
| `/patients/search?city=tor` | 400: falta la alergia en la búsqueda combinada |
| `/patients/search?city=tor&allergy=pen&limit=hola` | 400 con mensaje: el límite no es número |
| `/patients/search?city=aaaa&allergy=pen` | 404 con mensaje: válida, sin resultados |

### Salida esperada (verificada)

`GET /patients/search?city=tor&allergy=pen&limit=1` devuelve un arreglo con hasta 1 objeto con esta estructura (los valores de fila dependen de la copia; los códigos 400/404 con sus mensajes sí se verifican textualmente):

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
    "allergies": "Penicillin",
    "height": 165,
    "weight": 68
  }
]
```

## 5. Ejercicio independiente (50 min)

### Consigna

Sobre el mismo proyecto `u2-api`:

1. Agregar `GET /doctors/search?q=card`: búsqueda parcial de médicos por especialidad con `LIKE` (`q=card` encuentra `Cardiologist` y `Cardiovascular Surgeon`). Validar el criterio con `IsNullOrWhiteSpace` → 400 con mensaje; sin resultados → 404 con mensaje.
2. Mejorar el endpoint `GET /patients/by-province` del ejercicio anterior: aceptar también búsqueda parcial (`?province=n` con patrón `%n%` encuentra `ON`, `NS`, `NT` y `NU`: cuatro provincias y territorios), responder 400 si no viene provincia y 404 si no hay resultados.

Requisitos: patrón `%...%` armado en C# y viajando parametrizado; comentarios que marquen cada validación con su código; prueba de los tres caminos (válido, inválido, sin resultados) en cada endpoint.

### Pista

El ítem 1 es el gemelo de `/by-allergy` con la tabla `doctors` y la columna `specialty`. El ítem 2 es transformar un `WHERE = @province` en un `WHERE LIKE @patron` y agregarle los dos `if` de validación. No hay ninguna pieza nueva más allá de las que ya están en el archivo. La solución completa está en el anexo docente y se corrige en la puesta en común del bloque siguiente.

## 6. Extensión y consolidación (45 min)

Actividades explícitas del bloque (la solución de la extensión está en el anexo docente):

1. **Consolidación: el tablero de códigos.** En papel, cada grupo arma el cuadro de sus cuatro endpoints de búsqueda (por-alergia, search, doctors/search, by-province) con sus columnas: qué valida, qué responde en cada caso (200/400/404) y con qué mensaje. El cuadro es el ensayo de la defensa de la unidad.
2. **Extensión: criterio opcional en la búsqueda combinada.** Hacer que en `/patients/search` la alergia sea opcional sin romper el SQL, con el patrón `(allergies LIKE @alergia OR @alergia IS NULL)`: si el parámetro llega `null`, la condición no filtra. Probar los tres estados: solo ciudad, solo alergia (pasando a ser obligatoria la ciudad), ambos.
3. **Extensión: búsqueda por diagnóstico.** Agregar `GET /admissions/search?diagnosis=pain` sobre la tabla `admissions` con `LIKE` en `diagnosis`. Los datos reales traen typos (`Stomache Pain`, `Amigima`): probar qué encuentra `pain` y qué no encuentra `stomach pain` (el espacio y el typo importan). Es el primer contacto con los datos sucios que se profundizan en la Unidad 3.
4. **Commit de avance.** `git add .`, `git commit -m "Clase 12: filtros con like y validacion 400/404"` y `git push`.

## 7. Cierre (15 min)

### Qué te llevás

- `LIKE '%texto%'` busca porciones de texto; el patrón se arma en C# (`$"%{dato}%"`) y viaja parametrizado igual que cualquier valor.
- Validar antes de consultar: `IsNullOrWhiteSpace` para obligatorios, `long.TryParse` para números (en SQLite, `long` es el entero de todo).
- **400** = el pedido está mal (falta dato, número inválido): siempre con `new { mensaje = ... }`.
- **404** = el pedido está bien y no hay resultados: también con mensaje. La lista vacía `[]` ya no es respuesta aceptable en las búsquedas.
- Los pacientes con `NULL` en la columna filtrada no aparecen en ningún `LIKE`: el vacío no matchea.

### Lo que viene

- Encuentro 13: JOIN de dos tablas (`patients`+`province_names`, `admissions`+`doctors`), records compuestos. Hasta hoy cada endpoint leyó una sola tabla; la próxima clase cruza dos en la misma consulta para responder la pregunta que todavía no se puede: ¿cómo se llama la provincia del paciente, y no solo su código `ON`?

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 12: filtros con like y validacion 400/404"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Inyección del patrón: `"..." + "%" + allergy` | Armar el SQL pegando el dato "solo el patrón" | El patrón se arma en C# (`$"%{allergy}%"`) y viaja por `@patron`: el SQL nunca se toca |
| Validar después de consultar la base | "Primero busco, después miro si venía algo" | El orden es validación (400) → consulta → 404 si vacío; consultar con basura gasta la base y confunde al cliente |
| `long.TryParse` sin usar el `out` | Declarar `max` adentro del `if` y perder el valor parseado | `long max = 20; if (limit is not null && !long.TryParse(limit, out max)) ...`: el `out` llena el `max` ya declarado |
| 404 con lista vacía `[]` | Olvidar el `if (patients.Count() == 0)` | En búsquedas, sin resultados se responde 404 con mensaje; la lista vacía se reserva para otros casos |
| Creer que `LIKE` con `NULL` encuentra todo | Esperar que `NULL` matchee `'%%'` | `NULL` no coincide con ningún patrón: los pacientes sin alergia nunca salen en búsquedas por alergia |
| Dos `WHERE` (uno por criterio) | Intentar encadenar dos `.Where` o dos consultas | Un solo `WHERE` con `AND`: la fila tiene que cumplir los dos criterios juntos |
