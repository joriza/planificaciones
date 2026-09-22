# Evaluación del momento de intensificación y fortalecimiento marzo — Versión A

> Dominio de esta versión: tickets de soporte (U1, mini API en memoria) y doctors/admissions de hospital.db (U2). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-marzo.md`.

## Antes de empezar

- El esqueleto de `Program.cs` se proporciona a continuación. No se modifica la lista base, el contador de ids ni los records provistos.
- Convenciones del curso: INTEGER → `long`, SQL parametrizado con `new { id }`, respuestas con `Results.*` (`Ok`, `NotFound`, `Created`, `BadRequest`).
- Usar `Data Source=hospital.db` para conectar a la base de datos.
- Probar cada endpoint con curl o Thunder Client antes de entregar.
- Al terminar, avisar al docente y dejar el repo con commit y push realizados.

## Objetivos de la prueba

- U1: implementar endpoints GET con tipos canónicos, parámetros de ruta y query, y respuestas HTTP correctas (200, 404).
- U2: conectar a SQLite, ejecutar SELECT con WHERE y parámetros, usar LIKE para búsqueda parcial, y consultar con JOIN.
- U3: implementar operaciones CRUD completas (INSERT, UPDATE, DELETE) con validación de existencia y códigos HTTP correctos (201, 200, 404).
- U4: crear README de portada, gestionar issues, crear ramas por feature, abrir PR hacia `main` protegida.
- Criterio de evaluación: Apto / No apto.

## Material provisto — Esqueleto de `Program.cs`

```csharp
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Data.SQLite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// --- U1: tickets de soporte (en memoria) ---
var tickets = new List<object>
{
    new { ticketId = 1L, ticketInput = "No funciona la impresora", priority = "alta", createdDate = "2025-01-15" },
    new { ticketId = 2L, ticketInput = "Error al guardar", priority = "media", createdDate = "2025-01-16" },
    new { ticketId = 3L, ticketInput = "Solicitud de acceso", priority = "baja", createdDate = "2025-01-17" }
};
var nextTicketId = 4L;

// --- U2: conexión a hospital.db ---
var connectionString = "Data Source=hospital.db";

// TODO: implementar endpoints U1, U2, U3 y U4

app.Run();
```

## Parte 1 — Endpoints GET de tickets (U1, 25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Implementar `GET /tickets` que retorne la lista completa de tickets con `Results.Ok`. | 10 |
| 1.2 | Implementar `GET /tickets/{ticketId:long}` que retorne el ticket con ese ID o `Results.NotFound` con `new { mensaje = "Ticket no encontrado" }` si no existe. | 10 |
| 1.3 | Implementar `GET /tickets?priority=alta` que filtre los tickets por prioridad (query string) y retorne la lista filtrada. | 5 |

## Parte 2 — Consultas a doctors y admissions (U2, 25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Implementar `GET /doctors` que retorne la lista completa de doctores con `Results.Ok`. | 10 |
| 2.2 | Implementar `GET /doctors/{doctorId:long}` que retorne el doctor con ese ID o `Results.NotFound` con `new { mensaje = "Doctor no encontrado" }` si no existe. | 10 |
| 2.3 | Implementar `GET /admissions` que retorne todas las admissions con sus datos, usando alias `AS` en el SELECT y un JOIN a doctors. | 5 |

## Parte 3 — CRUD de doctors (U3, 30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Implementar `POST /doctors` que inserte un nuevo doctor y retorne `Results.Created` con código 201. Validar que `firstName` y `lastName` no estén vacíos. | 10 |
| 3.2 | Implementar `PUT /doctors/{doctorId:long}` que actualice el doctor y retorne `Results.Ok` (200). Si no existe, retornar `Results.NotFound`. | 10 |
| 3.3 | Implementar `DELETE /doctors/{doctorId:long}` que elimine el doctor y retorne `Results.NoContent` (204). Si no existe, retornar `Results.NotFound`. Si tiene admissions asociadas, retornar `Results.BadRequest`. | 10 |

## Parte 4 — Flujo git y README (U4, 20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 4.1 | Crear README de portada con descripción del proyecto, endpoints disponibles y instrucciones de ejecución. | 10 |
| 4.2 | Crear un issue en GitHub que describa una mejora pendiente. | 5 |
| 4.3 | Crear una rama por feature, hacer commit en esa rama y abrir un PR hacia `main`. | 5 |

## Parte 5 — Ítems conceptuales

- ¿Qué diferencia hay entre un parámetro de ruta y un parámetro de query? (5 pts)
- ¿Por qué se usa `long` para los campos INTEGER de SQLite y no `int`? (5 pts)
- ¿Qué es el alias `AS` en una consulta SQL y para qué sirve en el contexto de Dapper? (5 pts)
- ¿Cuándo se debe usar `Results.Created` en lugar de `Results.Ok`? (5 pts)

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `GET /tickets` | Lista completa de tickets | JSON con 3 objetos Ticket, cada uno con TicketId, TicketInput, Priority, CreatedDate |
| `GET /tickets/1` | Ticket con ID 1 | JSON del ticket con TicketId = 1 |
| `GET /tickets/99` | Ticket inexistente | `404` con `{ "mensaje": "Ticket no encontrado" }` |
| `GET /tickets?priority=alta` | Tickets con prioridad "alta" | JSON con los tickets cuya prioridad sea "alta" |
| `GET /doctors` | Lista completa de doctores | JSON con la lista de doctores de hospital.db |
| `GET /doctors/1` | Doctor con ID 1 | JSON del doctor con DoctorId=1 |
| `GET /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions con datos del doctor |
| `POST /doctors` con body válido | Nuevo doctor creado | `201` con el doctor creado incluyendo `doctorId` generado |
| `PUT /doctors/1` con body válido | Doctor actualizado | `200` con el doctor actualizado |
| `DELETE /doctors/1` | Doctor eliminado | `204` sin contenido |
| `DELETE /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` |

## Al terminar

Dejar el proyecto funcionando, con commit y push realizados, README de portada, issue creado y PR abierto hacia `main`. Avisar al docente para la corrección. Se devuelve con nota de Apto o No apto.