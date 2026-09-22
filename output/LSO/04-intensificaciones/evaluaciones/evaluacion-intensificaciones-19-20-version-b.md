# Evaluación del momento 19-20 — Versión B

> Dominio de esta versión: books de soporte (U1, mini API en memoria) y patients/admissions de hospital.db (U2). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-19-20.md`.

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

// TODO: implementar endpoints U1 y U2

app.Run();
```

## Rúbrica de 100 puntos

| Criterio | Peso | Descripción |
| --- | --- | --- |
| Endpoint GET `/books` | 15 pts | Retorna la lista completa de books con `Results.Ok`. |
| Endpoint GET `/books/{bookId:long}` | 15 pts | Retorna el book con ese ID o `Results.NotFound` con mensaje si no existe. |
| Endpoint GET `/books?author=...` | 10 pts | Filtra books por prioridad con query string. |
| Endpoint GET `/patients` | 10 pts | Retorna la lista completa de pacientes de hospital.db con `Results.Ok`. |
| Endpoint GET `/patients/{patientId:long}` | 10 pts | Retorna el patient con ese ID o `Results.NotFound` si no existe. |
| Endpoint GET `/admissions` con JOIN | 10 pts | Retorna admissions con datos del patient usando JOIN y alias `AS`. |
| Endpoint GET `/admissions?patientId=...` | 5 pts | Filtra admissions por patient con parámetro parametrizado. |
| Endpoint GET `/patients/search?name=...` con LIKE | 5 pts | Busca pacientes por nombre o ciudad usando LIKE. |
| Código y convenciones | 10 pts | Tipos canónicos (`long` para INTEGER), SQL parametrizado, `Results.*`, sin objetos crudos. |
| README, commit y defensa | 10 pts | README de portada, commit final, push, y defensa oral (2-3 min). |
| **Total** | **100 pts** | |

## Parte 1 — Endpoints de books (U1, 40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Implementar `GET /books` que retorne la lista completa de books con `Results.Ok`. | 15 |
| 1.2 | Implementar `GET /books/{bookId:long}` que retorne el book con ese ID o `Results.NotFound` con `new { mensaje = "Book no encontrado" }` si no existe. | 15 |
| 1.3 | Implementar `GET /books?author=alta` que filtre los books por prioridad (query string) y retorne la lista filtrada. | 10 |

## Parte 2 — Consultas a patients y admissions (U2, 40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Implementar `GET /patients` que retorne la lista completa de pacientes con `Results.Ok`. | 10 |
| 2.2 | Implementar `GET /patients/{patientId:long}` que retorne el patient con ese ID o `Results.NotFound` con `new { mensaje = "Patient no encontrado" }` si no existe. | 10 |
| 2.3 | Implementar `GET /admissions` que retorne todas las admissions con sus datos, usando alias `AS` en el SELECT y un JOIN a patients. | 10 |
| 2.4 | Implementar `GET /patients/search?name={name}` que busque pacientes por nombre o ciudad usando `LIKE` con parámetro. | 5 |
| 2.5 | Implementar `GET /admissions?patientId={patientId:long}` que retorne solo las admissions del patient indicado, parametrizando la consulta con `new { patientId }`. | 5 |

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
| `GET /books` | Lista completa de books | JSON con 3 objetos Book, cada uno con BookId, BookInput, Author, PublishedDate |
| `GET /books/1` | Book con ID 1 | JSON del book con BookId = 1 |
| `GET /books/99` | Book inexistente | `404` con `{ "mensaje": "Book no encontrado" }` |
| `GET /books?author=alta` | Books con prioridad "alta" | JSON con los books cuya prioridad sea "alta" |
| `GET /patients` | Lista completa de pacientes | JSON con la lista de pacientes de hospital.db |
| `GET /patients/1` | Patient con ID 1 | JSON del patient con PatientId=1 |
| `GET /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions con datos del patient |
| `GET /admissions?patientId=1` | Admissions del patient 1 | JSON con las admissions del patient con PatientId=1 |
| `GET /patients/search?name=cardio` | Pacientes con cardio en nombre o ciudad | JSON con pacientes cuyo firstName, lastName o city contengan "cardio" |

## Al terminar

Dejar el proyecto funcionando, con commit y push realizados y README de portada. Avisar al docente para la corrección. Se devuelve con nota numérica según la rúbrica de 100 puntos: Apto (≥60 pts) o No apto (<60 pts).
