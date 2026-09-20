# Anexo docente — Continuidad pedagógica 2: Tras la evaluación de la Unidad 1

> Documento docente formal. **No se entrega a los alumnos**: contiene las soluciones completas de las seis actividades del documento `continuidad-02-tras-evaluacion-u1.md` y los criterios de corrección por actividad, con puntaje. La solución de programación es de referencia (entidad `books`, canon .NET 6, CRUD en memoria sin base de datos): cada grupo presenta su propia entidad, campos y mensajes equivalentes. Queda a disposición del docente para corregir las presentaciones manuscritas individuales y registrar el resultado como una actividad más del proceso de evaluación.

## 1. Soluciones y criterios por actividad

### Actividad 1 — La receta de la Minimal API (15 puntos)

**Solución inciso (a).** Las cuatro partes, en orden:

1. **Preparar:** `var builder = WebApplication.CreateBuilder(args);`
2. **Construir:** `var app = builder.Build();`
3. **Definir endpoints:** los `app.MapGet`, `app.MapPost`, `app.MapPut`, `app.MapDelete`.
4. **Ejecutar:** `app.Run();`

**Solución inciso (b).**

```powershell
dotnet new web -n RepasoApi
cd RepasoApi
dotnet run
# detener: Ctrl+C
```

**Solución inciso (c).** Guardar con `Ctrl+S`, cortar con `Ctrl+C` y volver a correr con `dotnet run`. No alcanza con recargar la página porque la API ya cargó el programa en memoria: recién al reiniciar toma la versión nueva del archivo.

**Solución inciso (d).** Responde `404`: esa ventanilla no está definida. No es un programa roto: es la API contestando que no conoce esa ruta.

**Solución inciso (e).** Endpoint de referencia:

```csharp
app.MapGet("/estado", () => "La API esta funcionando");
```

El texto es libre; lo verificable es que el navegador muestre el texto definido en la ruta probada.

**Criterios de corrección (15 puntos):** inciso (a), 4 puntos (1 por parte con su instrucción); inciso (b), 4 puntos (1 por comando, 1 por la detención con `Ctrl+C`); inciso (c), 3 puntos (2 por la rutina completa, 1 por la explicación de la memoria); inciso (d), 2 puntos (1 por el 404, 1 por la interpretación); inciso (e), 2 puntos (endpoint probado y texto anotado).

### Actividad 2 — Rutas que preguntan (15 puntos)

**Solución inciso (a).** `{name}` toma el trozo variable de la URL (lo que se escribe en ese lugar de la ruta) y la API lo entrega al endpoint como un dato: el handler lo declara como `(string name)` y lo usa en la respuesta.

**Solución inciso (b).** `{id:long}` exige que el trozo de la URL sea un número entero. Si no lo es (por ejemplo, `abc`), la ruta no coincide y la API responde `404`: para esta ventanilla, ese pedido no existe.

**Solución inciso (c).**

| URL | ¿Qué responde? | ¿Por qué? |
| --- | --- | --- |
| `http://localhost:5080/hello/Ana` | `Hola, Ana!` | `{name}` toma `Ana` y la respuesta lo usa |
| `http://localhost:5080/hello` | `404` | Falta el valor del parámetro: la ruta no coincide |
| `http://localhost:5080/patients/25` | `{"patientId":25,"firstName":"Ana"}` | `{id:long}` toma `25`; JSON automático con el objeto anónimo |
| `http://localhost:5080/patients/abc` | `404` | El filtro `{id:long}` exige número: la ruta no coincide |
| `http://localhost:5080/hola/Juan` | `404` | Esa ruta no está definida en este `Program.cs` |

**Solución inciso (d).** Endpoint de referencia:

```csharp
app.MapGet("/salas/{name}", (string name) =>
{
    return $"Sala asignada: {name}";
});
```

Con valores probados responde el texto con cada nombre; con `http://localhost:5080/salas` responde `404`: falta el valor del parámetro y la ruta no coincide.

**Criterios de corrección (15 puntos):** inciso (a), 3 puntos; inciso (b), 3 puntos (2 por el filtro, 1 por el 404 con texto); inciso (c), 5 puntos (1 por fila completa); inciso (d), 4 puntos (2 por el endpoint con parámetro funcionando, 2 por las tres pruebas anotadas, incluida la ruta sin valor).

### Actividad 3 — Verbos y códigos: el mapa del CRUD (15 puntos)

**Solución inciso (a).**

| Verbo | Letra de CRUD | Acción |
| --- | --- | --- |
| GET | R (Read) | Leer |
| POST | C (Create) | Crear |
| PUT | U (Update) | Reemplazar |
| DELETE | D (Delete) | Borrar |

**Solución inciso (b).**

| Caso | Código | Método `Results` |
| --- | --- | --- |
| 1. GET `/doctors` con datos | 200 | `Results.Ok(doctors)` |
| 2. GET `/doctors/2` existente | 200 | `Results.Ok(doctor)` |
| 3. GET `/doctors/99` inexistente | 404 | `Results.NotFound(new { mensaje = ... })` |
| 4. POST sin la especialidad | 400 | `Results.BadRequest(new { mensaje = ... })` |
| 5. POST con todos los campos | 201 | `Results.Created($"/doctors/{id}", doctor)` |
| 6. PUT `/doctors/1` completo | 200 | `Results.Ok(updated)` |
| 7. PUT `/doctors/99` inexistente | 404 | `Results.NotFound(new { mensaje = ... })` |
| 8. PUT `/doctors/2` con nombre vacío | 400 | `Results.BadRequest(new { mensaje = ... })` |
| 9. DELETE `/doctors/3` existente | 204 | `Results.NoContent()` |
| 10. DELETE `/doctors/3` otra vez | 404 | `Results.NotFound(new { mensaje = ... })` |

**Solución inciso (c).**

1. Primero se chequea que el recurso exista: si no existe no hay nada que reemplazar, y el 400 hablaría de datos de algo que no está. El orden canónico del PUT es 404 → 400 → proceso.
2. Porque el borrado correcto no tiene datos que devolver: el 204 confirma la operación con una respuesta sin cuerpo.
3. Dentro de un objeto anónimo `new { mensaje = "..." }`, escritos en español.
4. Se construye un record **nuevo** con el mismo id y los datos actualizados, y se reemplaza en su posición de la lista: los records no se editan.

**Criterios de corrección (15 puntos):** inciso (a), 4 puntos (1 por verbo); inciso (b), 6 puntos (0,5 por caso con código y método correctos); inciso (c), 5 puntos (incisos 1 y 4: 2 puntos cada uno; incisos 2 y 3: 0,5 punto cada uno).

### Actividad 4 — Mini CRUD en memoria (35 puntos)

**Solución de referencia completa** (`Program.cs`, entidad `books`; cada grupo presenta su equivalente):

```csharp
// Program.cs - Continuidad pedagogica 2: CRUD en memoria (solucion de referencia)
// Tematica de ejemplo: libros. Cada grupo adapta entidad, campos y mensajes.

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: se crea UNA vez al arrancar y vive mientras la API corra
var books = new List<Book>
{
    new Book(1, "El halo", "R. Bach", "2019-04-11"),
    new Book(2, "Ruta 40", "M. Arias", "2021-09-03"),
    new Book(3, "Ultima frontera", "C. Paz", "2018-06-30")
};

// Contador de ids: arranca despues del ultimo id usado y suma 1 en cada alta
long nextBookId = 4;

// ---- READ: GET devuelve datos, nunca modifica ----

// GET /books: toda la lista -> 200
app.MapGet("/books", () =>
{
    return Results.Ok(books);
});

// GET /books/{id:long}: un libro o 404 si no existe
app.MapGet("/books/{id:long}", (long id) =>
{
    var book = books.Find(b => b.BookId == id);

    return book is null
        ? Results.NotFound(new { mensaje = "No existe el libro" })
        : Results.Ok(book);
});

// ---- CREATE: POST crea un recurso nuevo ----

app.MapPost("/books", (BookInput input) =>
{
    // Validacion minima: ningun campo puede quedar vacio.
    // IsNullOrWhiteSpace cubre null, vacio y solo espacios
    if (string.IsNullOrWhiteSpace(input.Title) ||
        string.IsNullOrWhiteSpace(input.Author))
    {
        return Results.BadRequest(new { mensaje = "Faltan el titulo o el autor" });
    }

    if (string.IsNullOrWhiteSpace(input.PublicationDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de publicacion" });
    }

    var book = new Book(nextBookId, input.Title, input.Author, input.PublicationDate);
    nextBookId++;

    books.Add(book);

    // 201 Created: devuelve el recurso nuevo y su ruta en el header Location
    return Results.Created($"/books/{book.BookId}", book);
});

// ---- UPDATE: PUT reemplaza los datos de un recurso existente ----

app.MapPut("/books/{id:long}", (long id, BookInput input) =>
{
    var book = books.Find(b => b.BookId == id);

    // 1) Primero: existe el libro?
    if (book is null)
    {
        return Results.NotFound(new { mensaje = "No existe el libro" });
    }

    // 2) Despues: los datos nuevos son validos?
    if (string.IsNullOrWhiteSpace(input.Title) ||
        string.IsNullOrWhiteSpace(input.Author))
    {
        return Results.BadRequest(new { mensaje = "Faltan el titulo o el autor" });
    }

    if (string.IsNullOrWhiteSpace(input.PublicationDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de publicacion" });
    }

    // 3) Recien ahora: records no se editan, se reemplazan
    var updated = new Book(book.BookId, input.Title, input.Author, input.PublicationDate);
    books[books.IndexOf(book)] = updated;

    return Results.Ok(updated);
});

// ---- DELETE: DELETE borra un recurso existente ----

app.MapDelete("/books/{id:long}", (long id) =>
{
    var book = books.Find(b => b.BookId == id);

    if (book is null)
    {
        return Results.NotFound(new { mensaje = "No existe el libro" });
    }

    books.Remove(book);

    // 204 No Content: borrado correcto, la respuesta no lleva cuerpo
    return Results.NoContent();
});

// 4) Deja la API escuchando pedidos
app.Run();

// ---- Records: SIEMPRE al final del archivo ----
record Book(long BookId, string Title, string Author, string PublicationDate);
record BookInput(string Title, string Author, string PublicationDate);
```

**Batería de pruebas esperada (con la solución de referencia):**

| Pedido | Código esperado |
| --- | --- |
| GET `/books` (navegador) | 200 con el array de tres libros |
| GET `/books/2` (navegador) | 200 con el libro 2 |
| GET `/books/99` (navegador) | 404 con mensaje |
| POST con todos los campos | 201 con header `Location: /books/4` |
| POST con un campo vacío | 400 con mensaje |
| PUT de un id existente, completo | 200 con el libro reemplazado |
| PUT de un id inexistente | 404 |
| PUT con un campo vacío | 400 |
| DELETE de un id que existe | 204 sin cuerpo |
| DELETE del mismo id, otra vez | 404 (ya no existe) |

**Criterios de corrección (35 puntos):**

| Componente | Puntos |
| --- | --- |
| Proyecto creado con `dotnet new web` y todo el código en `Program.cs` (records al final) | 3 |
| Entidad con id `long` + tres o cuatro campos; fecha como `string` ISO si hay | 4 |
| Rutas en inglés y plural, con filtro `{id:long}` donde va el id | 3 |
| GET todos (200) y GET uno (200/404 con mensaje) | 5 |
| POST con validación 400 con mensaje en español y 201 con `Location` | 6 |
| PUT con el orden 404 → 400 → reemplazo (record nuevo con el mismo id) | 5 |
| DELETE con 404 o 204 | 3 |
| Batería de diez pruebas anotada con el código obtenido en cada fila | 4 |
| Comentarios abundantes en el código | 2 |
| **Total** | **35** |

### Actividad 5 — El cuaderno de git y el ciclo de entrega (15 puntos)

**Solución inciso (a).**

| Acción | Comando |
| --- | --- |
| Iniciar el repositorio (una sola vez por proyecto) | `git init` |
| Ver qué archivos cambiaron | `git status` |
| Preparar todo lo nuevo o modificado | `git add .` |
| Registrar los cambios con un mensaje | `git commit -m "mensaje referente"` |
| Leer el historial en una línea por commit | `git log --oneline` |

**Solución inciso (b).** El `.gitignore` es la lista de lo que no se versiona. Este curso lista siempre las carpetas `bin/` y `obj/`: se regeneran solas en cada compilación, así que nunca van al repositorio.

**Solución inciso (c).** Orden correcto:

```text
1. git init y crear el .gitignore con bin/ y obj/
2. git add .
3. git commit -m "tp-u1: primera entrega"
4. Crear el repositorio remoto en GitHub desde el navegador.
5. git remote add origin https://github.com/usuario/repo-del-grupo.git
6. git push -u origin main
```

El repositorio local queda listo con su primer commit antes de crear y conectar el remoto; `git remote add` necesita la URL del repositorio ya creado, y el `push` va al final porque publica lo registrado.

**Solución inciso (d).**

1. Faltó `git add` y `git commit`: ese push no publica nada nuevo (o falla indicando que no hay nada para publicar). Primero se prepara y se registra; recién después se publica.
2. No está bien: `git init` se corre **una sola vez** por proyecto; correrlo de nuevo no tiene efecto útil y denota que no se entiende qué es el repositorio.
3. Le falta ser referente: un mensaje debe decir qué se hizo. Ejemplo correcto: `repaso: crud en memoria`.
4. Quedan versionadas `bin/` y `obj/`. Había que crear el `.gitignore` con esas carpetas **antes** del primer `git add .`.

**Solución inciso (e).** Salida esperada: `git log --oneline` muestra el commit `repaso: crud en memoria` (y solo ese, si el proyecto es nuevo), con `git status` sin mostrar nunca `bin/` ni `obj/` gracias al `.gitignore`.

**Criterios de corrección (15 puntos):** inciso (a), 5 puntos (1 por comando); inciso (b), 2 puntos (1 por definición, 1 por las carpetas y su motivo); inciso (c), 3 puntos (numeración correcta de los seis pasos); inciso (d), 2 puntos (0,5 por caso); inciso (e), 3 puntos (2 por repositorio con `.gitignore` y commit referente, 1 por la salida de `git log` anotada).

### Actividad 6 — Autoevaluación final (5 puntos)

**Solución:** no hay respuestas únicas: es un instrumento metacognitivo de cierre antes de la Unidad 2. La tabla de logros se completa marcando una columna por fila y las dos preguntas de reflexión se responden con una o dos líneas cada una.

**Criterios de corrección (5 puntos):** 3 puntos por la tabla completa (una columna marcada por fila) y 2 puntos por las dos reflexiones respondidas con concreción (qué salió fluido o costó, y qué se va a repasar).

## 2. Cuadro resumen de puntajes

| Actividad | Puntaje máximo |
| --- | --- |
| 1. La receta de la Minimal API | 15 |
| 2. Rutas que preguntan | 15 |
| 3. Verbos y códigos: el mapa del CRUD | 15 |
| 4. Mini CRUD en memoria | 35 |
| 5. El cuaderno de git y el ciclo de entrega | 15 |
| 6. Autoevaluación final | 5 |
| **Total** | **100** |

## 3. Registro y uso previsto

- La presentación es **individual y manuscrita**, al inicio de la próxima clase: respuestas numeradas por actividad, esqueleto del CRUD (rutas, verbos y códigos), batería de pruebas con los códigos obtenidos y autoevaluación completa.
- El docente corrige con los criterios de este anexo, registra el puntaje sobre 100 como una actividad más del proceso de evaluación y devuelve observaciones al grupo en el encuentro siguiente.
- El código se probó en grupo, pero la corrección es individual: en la presentación manuscrita se evalúa que cada alumno pueda explicar lo que escribió (por qué ese verbo, por qué ese código, por qué ese orden de chequeos), no la caligrafía del programa.
- Si la actividad 4 de un grupo quedó incompleta por tiempo, el docente prioriza en la devolución los cinco endpoints sobre los detalles: el esqueleto del CRUD es el prerrequisito directo de la Unidad 2.
