# Evaluación de la Unidad 1 — Encuentro 9 — Versión B

> Dominio de esta versión: books de soporte (mini API en memoria, sin base de datos). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u1.md`.

## Antes de empezar

- Resolver la prueba en un único archivo `Program.cs`.
- Usar las convenciones del curso: tipos canónicos, `Results.*`, record posicional después de `app.Run()`.
- No se permite usar base de datos; la API es en memoria.
- El esqueleto de `Program.cs` se provee a continuación; no se modifica la estructura base (usings, builder, app.Run()), solo se completan los endpoints y records.
- Al terminar, detener la aplicación con `Ctrl+C` y dejar el proyecto en estado limpio.

## Objetivos de la prueba

1. Crear un endpoint GET que retorne una colección de recursos en memoria.
2. Crear un endpoint GET con parámetro de ruta que retorne un recurso individual.
3. Usar un record posicional para modelar el dominio.
4. Aplicar las convenciones del curso: tipos canónicos, `Results.*`, comentarios en español.

## Material provisto — Esqueleto de `Program.cs`

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// TODO: definir el record Posicional del dominio (después de app.Run())
// TODO: definir la lista en memoria con al menos 3 elementos
// TODO: implementar los endpoints GET

app.Run();

// Records posicionales (después de app.Run())
```

## Parte 1 — Endpoints GET (60 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Crear un record posicional llamado `Book` con los campos: `BookId` (long), `BookInput` (string), `Author` (string), `PublishedDate` (string). | 10 |
| 1.2 | Crear una lista en memoria llamada `books` con al menos 3 objetos `Book` de ejemplo. | 10 |
| 1.3 | Implementar `GET /books` que retorne la lista completa de books con `Results.Ok`. | 15 |
| 1.4 | Implementar `GET /books/{bookId:long}` que retorne el book con ese ID o `Results.NotFound` con `new { mensaje = "Book no encontrado" }` si no existe. | 15 |
| 1.5 | Implementar `GET /books?author=alta` que filtre los books por prioridad (query string) y retorne la lista filtrada. | 10 |

## Parte 2 — Registro y modelado (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Declarar un contador `nextBookId` inicializado en 4 para generar IDs de nuevos books. | 10 |
| 2.2 | Agregar un comentario en español explicando por qué el record va después de `app.Run()`. | 10 |

## Parte 3 — Verificación de la API (10 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Probar `GET /books` y verificar que retorna los 3 books iniciales. | 5 |
| 3.2 | Probar `GET /books/1` y verificar que retorna el book con ID 1. | 5 |

## Parte 4 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Puntos |
| --- | --- | --- |
| 4.1 | ¿Por qué se usa `long` y no `int` para `BookId` si la base de datos usa INTEGER? (Respuesta: Dapper exige `Int64` para columnas INTEGER de SQLite.) | 5 |
| 4.2 | ¿Qué error aparece si se declara el record antes de `app.Run()`? (Respuesta: CS8803, las top-level statements deben preceder a las declaraciones de tipos.) | 5 |

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `GET /books` | Lista completa de books | JSON con 3 objetos Book, cada uno con BookId, BookInput, Author, PublishedDate |
| `GET /books/1` | Book con ID 1 | JSON del book con BookId = 1 |
| `GET /books/99` | Book inexistente | `404` con `{ "mensaje": "Book no encontrado" }` |
| `GET /books?author=alta` | Books con prioridad "alta" | JSON con los books cuya prioridad sea "alta" |

## Al terminar

Dejar la aplicación detenida (`Ctrl+C`). No hacer commit ni push. El docente verificará la ejecución durante la defensa.