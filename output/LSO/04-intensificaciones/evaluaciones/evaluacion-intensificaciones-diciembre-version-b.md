# Evaluación del momento diciembre — Versión B

> Dominio de esta versión: books de soporte (U1, mini API en memoria) y patients/admissions de hospital.db (U2). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-diciembre.md`.

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

// --- U1: books de soporte (en memoria) ---
var books = new List<object>
{
    new { bookId = 1L, bookInput = "No funciona la impresora", author = "alta", publishedDate = "2025-01-15" },
    new { bookId = 2L, bookInput = "Error al guardar", author = "media", publishedDate = "2025-01-16" },
    new { bookId = 3L, bookInput = "Solicitud de acceso", author = "baja", publishedDate = "2025-01-17" }
};
var nextBookId = 4L;

// --- U2: conexión a hospital.db ---
var connectionString = "Data Source=hospital.db";

// TODO: implementar endpoints U1, U2, U3 y U4

app.Run();
```

## Parte 1 — Endpoints GET de books (U1, 25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Implementar `GET /books` que retorne la lista completa de books con `Results.Ok`. | 10 |
| 1.2 | Implementar `GET /books/{bookId:long}` que retorne el book con ese ID o `Results.NotFound` con `new { mensaje = "Book no encontrado" }` si no existe. | 10 |
| 1.3 | Implementar `GET /books?author=alta` que filtre los books por prioridad (query string) y retorne la lista filtrada. | 5 |

## Parte 2 — Consultas a patients y admissions (U2, 25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Implementar `GET /patients` que retorne la lista completa de pacientes con `Results.Ok`. | 10 |
| 2.2 | Implementar `GET /patients/{patientId:long}` que retorne el patient con ese ID o `Results.NotFound` con `new { mensaje = "Patient no encontrado" }` si no existe. | 10 |
| 2.3 | Implementar `GET /admissions` que retorne todas las admissions con sus datos, usando alias `AS` en el SELECT y un JOIN a patients. | 5 |

## Parte 3 — CRUD de patients (U3, 30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Implementar `POST /patients` que inserte un nuevo patient y retorne `Results.Created` con código 201. Validar que `firstName` y `lastName` no estén vacíos. | 10 |
| 3.2 | Implementar `PUT /patients/{patientId:long}` que actualice el patient y retorne `Results.Ok` (200). Si no existe, retornar `Results.NotFound`. | 10 |
| 3.3 | Implementar `DELETE /patients/{patientId:long}` que elimine el patient y retorne `Results.NoContent` (204). Si no existe, retornar `Results.NotFound`. Si tiene admissions asociadas, retornar `Results.BadRequest`. | 10 |

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
| `GET /books` | Lista completa de books | JSON con 3 objetos Book, cada uno con BookId, BookInput, Author, PublishedDate |
| `GET /books/1` | Book con ID 1 | JSON del book con BookId = 1 |
| `GET /books/99` | Book inexistente | `404` con `{ "mensaje": "Book no encontrado" }` |
| `GET /books?author=alta` | Books con prioridad "alta" | JSON con los books cuya prioridad sea "alta" |
| `GET /patients` | Lista completa de pacientes | JSON con la lista de pacientes de hospital.db |
| `GET /patients/1` | Patient con ID 1 | JSON del patient con PatientId=1 |
| `GET /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions con datos del patient |
| `POST /patients` con body válido | Nuevo patient creado | `201` con el patient creado incluyendo `patientId` generado |
| `PUT /patients/1` con body válido | Patient actualizado | `200` con el patient actualizado |
| `DELETE /patients/1` | Patient eliminado | `204` sin contenido |
| `DELETE /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` |

## Al terminar

Dejar el proyecto funcionando, con commit y push realizados, README de portada, issue creado y PR abierto hacia `main`. Avisar al docente para la corrección. Se devuelve con nota de Apto o No apto.
