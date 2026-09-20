# Anexo docente — Evaluación de la Unidad 1 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B (libros), las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución para el encuentro 10.

## 1. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion de la Unidad 1 - Version B (solucion del docente)
// Mini API de libros de una biblioteca en memoria (sin base de datos)

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: datos iniciales provistos por la prueba
var books = new List<Book>
{
    new Book(1, "El principito", "Antoine de Saint-Exupery", "1943-04-06"),
    new Book(2, "Martin Fierro", "Jose Hernandez", "1872-11-30"),
    new Book(3, "Rayuela", "Julio Cortazar", "1963-06-28")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextBookId = 4;

// ===== Parte 1 =====

// GET /books: toda la lista -> 200
app.MapGet("/books", () =>
{
    return Results.Ok(books);
});

// GET /books/{id:long}: un libro o 404
app.MapGet("/books/{id:long}", (long id) =>
{
    // Find recorre la lista y devuelve el primer libro con ese id, o null
    var book = books.Find(b => b.BookId == id);

    // Sin coincidencia: 404 con mensaje. Con coincidencia: 200 con el libro
    return book is null
        ? Results.NotFound(new { mensaje = "No existe el libro" })
        : Results.Ok(book);
});

// ===== Parte 2 =====

// POST /books: alta con validacion -> 400 o 201
app.MapPost("/books", (BookInput input) =>
{
    // Chequeos en orden, con un mensaje que diga QUE falta.
    // IsNullOrWhiteSpace cubre null, vacio y solo espacios
    if (string.IsNullOrWhiteSpace(input.Title))
    {
        return Results.BadRequest(new { mensaje = "Falta el titulo del libro" });
    }

    if (string.IsNullOrWhiteSpace(input.Author))
    {
        return Results.BadRequest(new { mensaje = "Falta el autor" });
    }

    if (string.IsNullOrWhiteSpace(input.PublishedDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de publicacion" });
    }

    // Se arma el libro completo con el id del contador y se agrega
    var book = new Book(nextBookId, input.Title, input.Author, input.PublishedDate);
    nextBookId++;

    books.Add(book);

    // 201 con la URL del recurso nuevo y el libro en el cuerpo
    return Results.Created($"/books/{book.BookId}", book);
});

// ===== Parte 3 =====

// DELETE /books/{id:long}: baja -> 404 o 204
app.MapDelete("/books/{id:long}", (long id) =>
{
    var book = books.Find(b => b.BookId == id);

    // 1) Primero: existe el libro?
    if (book is null)
    {
        return Results.NotFound(new { mensaje = "No existe el libro" });
    }

    // 2) Existe: se quita de la lista y se responde 204 sin cuerpo
    books.Remove(book);

    return Results.NoContent();
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos, SIEMPRE al final del archivo ----
record Book(long BookId, string Title, string Author, string PublishedDate);
record BookInput(string Title, string Author, string PublishedDate);
```

Aceptaciones válidas menores: `Find` resuelto con `FirstOrDefault` o con un `foreach`; `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`; `Results.Created($"/books/{nextBookId}", book)` calculado antes de incrementar (equivalente); un solo `if` combinado con un mensaje único que nombre los tres campos (puntúa el ítem completo de validación con mensaje general, no diferenciado). **No se acepta:** `TypedResults` (no es canon de .NET 6), ids `int`, rutas en español, responder el objeto crudo sin `Results`.

## 2. Salidas de referencia para la corrección

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`):

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/books` | `200` con `[{...libro 1...},{"bookId":2,"title":"Martin Fierro","author":"Jose Hernandez","publishedDate":"1872-11-30"},{"bookId":3,...}]` (JSON camelCase) |
| `GET http://localhost:5080/books/2` | `200` con `{"bookId":2,"title":"Martin Fierro","author":"Jose Hernandez","publishedDate":"1872-11-30"}` |
| `GET http://localhost:5080/books/99` | `404` con `{"mensaje":"No existe el libro"}` |
| `POST /books` con `{"title":"El aleph","author":"Jorge Luis Borges","publishedDate":"1949-06-11"}` | `201`, encabezado `Location: /books/4`, cuerpo con el libro y `bookId: 4` |
| `POST /books` con `title` vacío | `400` con `{"mensaje":"Falta el titulo del libro"}` (o equivalente que nombre el campo) |
| `POST /books` sin `author` | `400` con `{"mensaje":"Falta el autor"}` |
| `POST /books` sin `publishedDate` | `400` con `{"mensaje":"Falta la fecha de publicacion"}` |
| `DELETE /books/3` | `204`, sin cuerpo |
| `DELETE /books/3` de nuevo | `404` con `{"mensaje":"No existe el libro"}` |
| `GET http://localhost:5080/books/3` tras el borrado | `404` con el mismo mensaje |

```powershell
curl.exe -i -X POST http://localhost:5080/books -H "Content-Type: application/json" -d "{\"title\":\"El aleph\",\"author\":\"Jorge Luis Borges\",\"publishedDate\":\"1949-06-11\"}"
curl.exe -i -X POST http://localhost:5080/books -H "Content-Type: application/json" -d "{\"title\":\"\",\"author\":\"Jorge Luis Borges\",\"publishedDate\":\"1949-06-11\"}"
curl.exe -i -X DELETE http://localhost:5080/books/3
```

## 3. Criterios de corrección ítem por ítem

### Parte 1 — Consulta de libros (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1a | Proyecto creado con `dotnet new web`, esqueleto pegado sin modificar y API corriendo con `dotnet run` | 4 |
| 1b | Ruta `GET /books` con `200` y la lista completa en JSON (`Results.Ok`) | 7 |
| 1c | Ruta `GET /books/{id:long}` con parámetro tipado `long id`; `200` con el libro encontrado | 9 |
| 1d | `404` con mensaje en español cuando el id no existe (`Results.NotFound` + `new { mensaje = ... }`) | 10 |

### Parte 2 — Alta con validación (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2a | Ruta `POST /books` que lee el cuerpo con el record de entrada `BookInput` (DTO sin id) | 5 |
| 2b | Validación con `string.IsNullOrWhiteSpace` y `400` con mensaje que dice qué falta, chequeado antes de agregar el libro | 10 |
| 2c | Alta con el id del contador (`nextBookId`, incrementado después de usarlo) y `201` con la URL del recurso nuevo (`Results.Created`) | 12 |
| 2d | Verificación posterior: `GET /books/4` responde `200` con el libro creado | 3 |

### Parte 3 — Baja (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3a | Ruta `DELETE /books/{id:long}` con parámetro tipado `long id` | 5 |
| 3b | `404` con mensaje cuando el id no existe | 8 |
| 3c | `204` sin cuerpo cuando borra (`Results.NoContent`) | 7 |
| 3d | El libro borrado desaparece: `GET` posterior al mismo id responde `404` | 5 |

### Parte 4 — Ítems conceptuales (15 puntos)

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1 | Verbo y código correctos en las cuatro filas (2 puntos cada una): GET `404` · POST `201` · POST `400` · DELETE `204` | 8 |
| C2a | Formato `<trabajo>: <resumen de lo hecho>`, en minúsculas y sin tildes (p. ej. `eval-u1: crud de libros en memoria`); se acepta cualquier par trabajo/resumen coherente con esta prueba | 3 |
| C2b | Orden: `git add .` → `git commit -m "..."` → `git push` | 2 |
| C2c | Evita versionar archivos generados; en el curso ignora `bin/` y `obj/` | 2 |

**Total: 100 puntos.** No se duplican descuentos por el mismo defecto en ítems distintos: una convención desviada penaliza una sola vez, en el ítem donde aparece.

### Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `TypedResults` en las respuestas | Confusión de versión | Defecto de versión (canon: `Results` en .NET 6); descuenta en el ítem donde aparece |
| Ids declarados `int` | Canon de tipos incumplido | Descuenta el ítem de la ruta correspondiente |
| Rutas en español (`/books` → otra cosa) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| `400`/`404` sin cuerpo (`Results.BadRequest()` a secas) | Mensaje olvidado | Descuento parcial: el código correcto puntúa, el mensaje exigido no |
| `books.Add(...)` antes de las validaciones | Orden de chequeos | Las validaciones pierden efecto: descuenta el ítem 2b |
| Lista declarada dentro de un handler | Cada pedido arranca con la lista del esqueleto | Descuenta los ítems 2c y 3d si el estado no se sostiene |
| Contador sin incrementar | Duplicación de ids en el segundo POST | Descuento parcial en 2c |
| Error CS8803 (record antes de `app.Run()`) | Records movidos de lugar | Avisar la causa no invalida la prueba; se corrige lo que alcance a compilar |

## 4. Pauta de devolución (encuentro 10)

- El encuentro 10 **abre con la devolución**, antes de iniciar la Unidad 2: cada alumno recibe su corrección escrita individual, con el desglose ítem por ítem (qué puntúa, qué no y por qué).
- Comentarios generales al curso antes de arrancar la unidad: los aciertos más frecuentes (estructura del esqueleto, uso de `Results`, mensajes 400 diferenciados) y los errores comunes observados en esta versión.
- Los ítems no alcanzados se traducen en objetivos pendientes en la planilla y en pistas de recuperación según las capas de `06-aprobacion/criterios-aprobacion.md`: devolución y reincorporación en las clases de la Unidad 2; intensificaciones 17-18 si el pendiente persiste.
- La planilla de resultados registra: alumno, versión (B), puntaje por parte (30/30/25/15), total sobre 100, objetivos mínimos de U1 logrados/pendientes y observaciones de la defensa del TP-u1.
- Si la entrega del tp-u1 quedó incompleta, recordar la regla vigente: se evalúa lo presentado y el repositorio del grupo permanece abierto para completar con nuevos commits y push.
