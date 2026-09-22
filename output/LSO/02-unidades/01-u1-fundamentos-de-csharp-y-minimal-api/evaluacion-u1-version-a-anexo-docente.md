# Anexo docente — Evaluación de la Unidad 1 — Encuentro 9 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Lista en memoria para simular persistencia sin base de datos
var tickets = new List<Ticket>
{
    new Ticket(1, "Impresora no responde", "alta", "2025-01-15"),
    new Ticket(2, "Pantalla parpadea", "media", "2025-01-16"),
    new Ticket(3, "Teclado lento", "baja", "2025-01-17")
};

// Contador para generar IDs de nuevos tickets
var nextTicketId = 4;

// GET /tickets — retornar la lista completa de tickets
app.MapGet("/tickets", () =>
{
    return Results.Ok(tickets);
});

// GET /tickets/{ticketId:long} — obtener un ticket por ID
app.MapGet("/tickets/{ticketId:long}", (long ticketId) =>
{
    var ticket = tickets.FirstOrDefault(t => t.TicketId == ticketId);
    return ticket is null
        ? Results.NotFound(new { mensaje = "Ticket no encontrado" })
        : Results.Ok(ticket);
});

// GET /tickets?priority=alta — filtrar tickets por prioridad
app.MapGet("/tickets", (string? priority) =>
{
    if (string.IsNullOrEmpty(priority))
        return Results.Ok(tickets);
    var filtrados = tickets.Where(t => t.Priority.Equals(priority, StringComparison.OrdinalIgnoreCase)).ToList();
    return Results.Ok(filtrados);
});

app.Run();

// Records posicionales (después de app.Run()): CS8803 requiere que las declaraciones de tipos
// sigan a las top-level statements; colocar el record antes produce error de compilación.
public record Ticket(long TicketId, string TicketInput, string Priority, string CreatedDate);
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada |
| --- | --- | --- |
| `GET /tickets` | Lista completa | JSON con 3 objetos Ticket: IDs 1,2,3 con sus datos |
| `GET /tickets/1` | Ticket con ID 1 | JSON del ticket con TicketId=1, TicketInput="Impresora no responde" |
| `GET /tickets/99` | Ticket inexistente | 404 con `{ "mensaje": "Ticket no encontrado" }` |
| `GET /tickets?priority=alta` | Filtrado por prioridad | JSON con el ticket de ID 1 (prioridad "alta") |
| `GET /tickets?priority=media` | Filtrado por prioridad | JSON con el ticket de ID 2 (prioridad "media") |

## 3. Criterios de corrección ítem por ítem

| Ítem | Puntos | Qué se observa | Error previsto | Intervención |
| --- | --- | --- | --- | ---|
| 1.1 Record Ticket con campos correctos | 10 | Los campos TicketId (long), TicketInput (string), Priority (string), CreatedDate (string) están declarados como record posicional. | Usar `int` en lugar de `long` para TicketId. | Recordar que Dapper exige `Int64` para columnas INTEGER; aunque no hay BD en esta versión, la convención del curso es `long`. |
| 1.2 Lista `tickets` con al menos 3 elementos | 10 | La lista se inicializa con 3 o más objetos `Ticket`. | Lista vacía o con menos de 3 elementos. | Verificar que la lista tenga al menos 3 elementos con datos válidos. |
| 1.3 `GET /tickets` retorna lista | 15 | El endpoint retorna `Results.Ok(tickets)` con la lista completa. | Retornar la lista sin envolver en `Results.Ok`; retornar solo la lista cruda. | Explicar que toda respuesta debe usar `Results.*` y no el objeto crudo. |
| 1.4 `GET /tickets/{ticketId:long}` con 404 | 15 | El endpoint busca por ID y retorna 404 con `mensaje` en español si no existe. | No manejar el caso de no encontrado; usar `int` en lugar de `long` para el parámetro; mensaje en inglés. | Verificar el tipo del parámetro de ruta y la presencia del mensaje en español. |
| 1.5 `GET /tickets?priority=alta` con filtrado | 10 | El endpoint filtra por query string `priority` y retorna la lista filtrada. | No manejar el parámetro query; filtrado incorrecto (case-sensitive sin justificación). | Verificar que el filtrado funcione y que se maneje el caso de parámetro nulo. |
| 2.1 Contador `nextTicketId` | 10 | Se declara `var nextTicketId = 4;` después de la lista. | No declarar el contador; inicializar en otro valor. | Verificar que el contador exista y tenga valor coherente (4, después de los 3 tickets iniciales). |
| 2.2 Comentario sobre ubicación del record | 10 | El comentario explica que el record va después de `app.Run()` por la regla CS8803. | Comentario genérico sin referencia a CS8803; comentario en inglés. | Verificar que el comentario sea en español y mencione la razón técnica. |
| 3.1 Probar GET /tickets | 5 | El endpoint funciona y retorna los 3 tickets. | Endpoint no responde; retorna error 500. | Verificar que la aplicación compile y el endpoint retorne datos. |
| 3.2 Probar GET /tickets/1 | 5 | El endpoint retorna el ticket con ID 1. | Endpoint no responde; retorna 404. | Verificar que la ruta y el parámetro estén correctamente definidos. |
| 4.1 Pregunta conceptual long vs int | 5 | Respuesta correcta sobre Dapper e Int64. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar la tabla de tipos canónicos. |
| 4.2 Pregunta conceptual CS8803 | 5 | Respuesta correcta sobre records antes de app.Run(). | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar el error de compilación. |

## 4. Pauta de devolución

Se devuelve la evaluación con los puntos obtenidos por cada ítem. Se indica qué ítems están pendientes y qué correcciones se esperan. Si el alumno no alcanza 60 puntos, se le asigna la versión alternativa (B) para recuperación. Se registra la nota en la planilla con los comentarios del docente.