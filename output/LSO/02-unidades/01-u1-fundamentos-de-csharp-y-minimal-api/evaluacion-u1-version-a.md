# Evaluación de la Unidad 1 — Encuentro 9 — Versión A

> Dominio de esta versión: tickets de soporte (mini API en memoria, sin base de datos). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u1.md`.

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
| 1.1 | Crear un record posicional llamado `Ticket` con los campos: `TicketId` (long), `TicketInput` (string), `Priority` (string), `CreatedDate` (string). | 10 |
| 1.2 | Crear una lista en memoria llamada `tickets` con al menos 3 objetos `Ticket` de ejemplo. | 10 |
| 1.3 | Implementar `GET /tickets` que retorne la lista completa de tickets con `Results.Ok`. | 15 |
| 1.4 | Implementar `GET /tickets/{ticketId:long}` que retorne el ticket con ese ID o `Results.NotFound` con `new { mensaje = "Ticket no encontrado" }` si no existe. | 15 |
| 1.5 | Implementar `GET /tickets?priority=alta` que filtre los tickets por prioridad (query string) y retorne la lista filtrada. | 10 |

## Parte 2 — Registro y modelado (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Declarar un contador `nextTicketId` inicializado en 4 para generar IDs de nuevos tickets. | 10 |
| 2.2 | Agregar un comentario en español explicando por qué el record va después de `app.Run()`. | 10 |

## Parte 3 — Verificación de la API (10 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Probar `GET /tickets` y verificar que retorna los 3 tickets iniciales. | 5 |
| 3.2 | Probar `GET /tickets/1` y verificar que retorna el ticket con ID 1. | 5 |

## Parte 4 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Puntos |
| --- | --- | --- |
| 4.1 | ¿Por qué se usa `long` y no `int` para `TicketId` si la base de datos usa INTEGER? (Respuesta: Dapper exige `Int64` para columnas INTEGER de SQLite.) | 5 |
| 4.2 | ¿Qué error aparece si se declara el record antes de `app.Run()`? (Respuesta: CS8803, las top-level statements deben preceder a las declaraciones de tipos.) | 5 |

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `GET /tickets` | Lista completa de tickets | JSON con 3 objetos Ticket, cada uno con TicketId, TicketInput, Priority, CreatedDate |
| `GET /tickets/1` | Ticket con ID 1 | JSON del ticket con TicketId = 1 |
| `GET /tickets/99` | Ticket inexistente | `404` con `{ "mensaje": "Ticket no encontrado" }` |
| `GET /tickets?priority=alta` | Tickets con prioridad "alta" | JSON con los tickets cuya prioridad sea "alta" |

## Al terminar

Dejar la aplicación detenida (`Ctrl+C`). No hacer commit ni push. El docente verificará la ejecución durante la defensa.