# Anexo docente — Evaluación de la Unidad 1 — Encuentro 9 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Lista en memoria para simular persistencia sin base de datos
var books = new List<Book>
{
    new Book(1, "Cien años de soledad", "Gabriel García Márquez", "2025-01-15"),
    new Book(2, "Rayuela", "Julio Cortázar", "2025-02-10"),
    new Book(3, "Ficciones", "Jorge Luis Borges", "2025-03-20")
};

// Contador para generar IDs de nuevos books
var nextBookId = 4;

// GET /books — retornar la lista completa de books
app.MapGet("/books", () =>
{
    return Results.Ok(books);
});

// GET /books/{bookId:long} — obtener un book por ID
app.MapGet("/books/{bookId:long}", (long bookId) =>
{
    var book = books.FirstOrDefault(b => b.BookId == bookId);
    return book is null
        ? Results.NotFound(new { mensaje = "Book no encontrado" })
        : Results.Ok(book);
});

// GET /books?author=alta — filtrar books por autor
app.MapGet("/books", (string? author) =>
{
    if (string.IsNullOrEmpty(author))
        return Results.Ok(books);
    var filtrados = books.Where(b => b.Author.Equals(author, StringComparison.OrdinalIgnoreCase)).ToList();
    return Results.Ok(filtrados);
});

app.Run();

// Records posicionales (después de app.Run()): CS8803 requiere que las declaraciones de tipos
// sigan a las top-level statements; colocar el record antes produce error de compilación.
public record Book(long BookId, string BookInput, string Author, string PublishedDate);
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada |
| --- | --- | --- |
| `GET /books` | Lista completa | JSON con 3 objetos Book: IDs 1,2,3 con sus datos |
| `GET /books/1` | Book con ID 1 | JSON del book con BookId=1, BookInput="Cien años de soledad" |
| `GET /books/99` | Book inexistente | 404 con `{ "mensaje": "Book no encontrado" }` |
| `GET /books?author=Gabriel García Márquez` | Filtrado por autor | JSON con el book de ID 1 (autor "Gabriel García Márquez") |
| `GET /books?author=Jorge Luis Borges` | Filtrado por autor | JSON con el book de ID 3 (autor "Jorge Luis Borges") |

## 3. Criterios de corrección ítem por ítem

| Ítem | Puntos | Qué se observa | Error previsto | Intervención |
| --- | --- | --- | --- | --- |
| 1.1 Record Book con campos correctos | 10 | Los campos BookId (long), BookInput (string), Author (string), PublishedDate (string) están declarados como record posicional. | Usar `int` en lugar de `long` para BookId. | Recordar que Dapper exige `Int64` para columnas INTEGER; aunque no hay BD en esta versión, la convención del curso es `long`. |
| 1.2 Lista `books` con al menos 3 elementos | 10 | La lista se inicializa con 3 o más objetos `Book`. | Lista vacía o con menos de 3 elementos. | Verificar que la lista tenga al menos 3 elementos con datos válidos. |
| 1.3 `GET /books` retorna lista | 15 | El endpoint retorna `Results.Ok(books)` con la lista completa. | Retornar la lista sin envolver en `Results.Ok`; retornar solo la lista cruda. | Explicar que toda respuesta debe usar `Results.*` y no el objeto crudo. |
| 1.4 `GET /books/{bookId:long}` con 404 | 15 | El endpoint busca por ID y retorna 404 con `mensaje` en español si no existe. | No manejar el caso de no encontrado; usar `int` en lugar de `long` para el parámetro; mensaje en inglés. | Verificar el tipo del parámetro de ruta y la presencia del mensaje en español. |
| 1.5 `GET /books?author=alta` con filtrado | 10 | El endpoint filtra por query string `author` y retorna la lista filtrada. | No manejar el parámetro query; filtrado incorrecto (case-sensitive sin justificación). | Verificar que el filtrado funcione y que se maneje el caso de parámetro nulo. |
| 2.1 Contador `nextBookId` | 10 | Se declara `var nextBookId = 4;` después de la lista. | No declarar el contador; inicializar en otro valor. | Verificar que el contador exista y tenga valor coherente (4, después de los 3 books iniciales). |
| 2.2 Comentario sobre ubicación del record | 10 | El comentario explica que el record va después de `app.Run()` por la regla CS8803. | Comentario genérico sin referencia a CS8803; comentario en inglés. | Verificar que el comentario sea en español y mencione la razón técnica. |
| 3.1 Probar GET /books | 5 | El endpoint funciona y retorna los 3 books. | Endpoint no responde; retorna error 500. | Verificar que la aplicación compile y el endpoint retorne datos. |
| 3.2 Probar GET /books/1 | 5 | El endpoint retorna el book con ID 1. | Endpoint no responde; retorna 404. | Verificar que la ruta y el parámetro estén correctamente definidos. |
| 4.1 Pregunta conceptual long vs int | 5 | Respuesta correcta sobre Dapper e Int64. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar la tabla de tipos canónicos. |
| 4.2 Pregunta conceptual CS8803 | 5 | Respuesta correcta sobre records antes de app.Run(). | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar el error de compilación. |

## 4. Pauta de devolución

Se devuelve la evaluación con los puntos obtenidos por cada ítem. Se indica qué ítems están pendientes y qué correcciones se esperan. Si el alumno no alcanza 60 puntos, se le asigna la versión alternativa (A) para recuperación. Se registra la nota en la planilla con los comentarios del docente.
