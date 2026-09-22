# Evaluación del momento 19-20 — Versión A

> Dominio de esta versión: tickets de soporte (U1, mini API en memoria) y doctors/admissions de hospital.db (U2). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-19-20.md`.

## Antes de empezar

- El esqueleto de `Program.cs` se proporciona a continuación. No se modifica la lista base, el contador de ids ni los records provistos.
- Convenciones del curso: INTEGER → `long`, SQL parametrizado con `new { id }`, respuestas con `Results.*` (`Ok`, `NotFound`, `Created`, `BadRequest`).
- Usar `Data Source=hospital.db` para conectar a la base de datos.
- Probar cada endpoint con curl o Thunder Client antes de entregar.
- Al terminar, avisar al docente y dejar el repo con commit y push realizados.

## Objetivos de la prueba

- Implementar endpoints GET con tipos canónicos, parámetros de ruta y query, y respuestas HTTP correctas (200, 404).
- Conectar a SQLite con Dapper, ejecutar SELECT con WHERE y parámetros, usar LIKE para búsqueda parcial, y consultar con JOIN.
- Articular U1 y U2 en un proyecto Minimal API completo.
- Criterio de evaluación: Apto (≥60 pts) / No apto (<60 pts).

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

// TODO: implementar endpoints U1 y U2

app.Run();
```

## Rúbrica de 100 puntos

| Criterio | Peso | Descripción |
| --- | --- | --- |
| Endpoint GET `/tickets` | 15 pts | Retorna la lista completa de tickets con `Results.Ok`. |
| Endpoint GET `/tickets/{ticketId:long}` | 15 pts | Retorna el ticket con ese ID o `Results.NotFound` con mensaje si no existe. |
| Endpoint GET `/tickets?priority=...` | 10 pts | Filtra tickets por prioridad con query string. |
| Endpoint GET `/doctors` | 10 pts | Retorna la lista completa de doctores de hospital.db con `Results.Ok`. |
| Endpoint GET `/doctors/{doctorId:long}` | 10 pts | Retorna el doctor con ese ID o `Results.NotFound` si no existe. |
| Endpoint GET `/admissions` con JOIN | 10 pts | Retorna admissions con datos del doctor usando JOIN y alias `AS`. |
| Endpoint GET `/admissions?doctorId=...` | 5 pts | Filtra admissions por doctor con parámetro parametrizado. |
| Endpoint GET `/doctors/search?name=...` con LIKE | 5 pts | Busca doctores por nombre o especialidad usando LIKE. |
| Código y convenciones | 10 pts | Tipos canónicos (`long` para INTEGER), SQL parametrizado, `Results.*`, sin objetos crudos. |
| README, commit y defensa | 10 pts | README de portada, commit final, push, y defensa oral (2-3 min). |
| **Total** | **100 pts** | |

## Parte 1 — Endpoints de tickets (U1, 40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Implementar `GET /tickets` que retorne la lista completa de tickets con `Results.Ok`. | 15 |
| 1.2 | Implementar `GET /tickets/{ticketId:long}` que retorne el ticket con ese ID o `Results.NotFound` con `new { mensaje = "Ticket no encontrado" }` si no existe. | 15 |
| 1.3 | Implementar `GET /tickets?priority=alta` que filtre los tickets por prioridad (query string) y retorne la lista filtrada. | 10 |

## Parte 2 — Consultas a doctors y admissions (U2, 40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Implementar `GET /doctors` que retorne la lista completa de doctores con `Results.Ok`. | 10 |
| 2.2 | Implementar `GET /doctors/{doctorId:long}` que retorne el doctor con ese ID o `Results.NotFound` con `new { mensaje = "Doctor no encontrado" }` si no existe. | 10 |
| 2.3 | Implementar `GET /admissions` que retorne todas las admissions con sus datos, usando alias `AS` en el SELECT y un JOIN a doctors. | 10 |
| 2.4 | Implementar `GET /doctors/search?name={name}` que busque doctores por nombre o especialidad usando `LIKE` con parámetro. | 5 |
| 2.5 | Implementar `GET /admissions?doctorId={doctorId:long}` que retorne solo las admissions del doctor indicado, parametrizando la consulta con `new { doctorId }`. | 5 |

## Parte 3 — Integración, README y defensa (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Crear README de portada con descripción del proyecto, endpoints disponibles y instrucciones de ejecución. | 5 |
| 3.2 | Verificar que todos los endpoints responden correctamente (probar con curl o Thunder Client). | 5 |
| 3.3 | Realizar commit final y push al repo grupal. | 5 |
| 3.4 | Defensa oral individual (2-3 min): explicar la estructura del proyecto y justificar una decisión de diseño. | 5 |

## Parte 4 — Ítems conceptuales

- ¿Qué diferencia hay entre un parámetro de ruta y un parámetro de query? (5 pts)
- ¿Por qué se usa `long` para los campos INTEGER de SQLite y no `int`? (5 pts)
- ¿Qué es el alias `AS` en una consulta SQL y para qué sirve en el contexto de Dapper? (5 pts)
- ¿Cuándo se debe usar `Results.NotFound` en lugar de retornar `null`? (5 pts)

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
| `GET /admissions?doctorId=1` | Admissions del doctor 1 | JSON con las admissions del doctor con DoctorId=1 |
| `GET /doctors/search?name=cardio` | Doctores con cardio en nombre o especialidad | JSON con doctores cuyo firstName, lastName o specialty contengan "cardio" |

## Al terminar

Dejar el proyecto funcionando, con commit y push realizados y README de portada. Avisar al docente para la corrección. Se devuelve con nota numérica según la rúbrica de 100 puntos: Apto (≥60 pts) o No apto (<60 pts).
