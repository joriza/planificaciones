# Evaluación del momento 34-35 — Versión B

> Dominio de esta versión: patients/admissions de hospital.db (U3+U4). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-34-35.md`.

## Antes de empezar

- El esqueleto de `Program.cs` se proporciona a continuación. No se modifica la lista base, el contador de ids ni los records provistos.
- Convenciones del curso: INTEGER → `long`, SQL parametrizado con `new { id }`, respuestas con `Results.*` (`Ok`, `NotFound`, `Created`, `BadRequest`), códigos HTTP 201 para POST, 200 para PUT, 204/404 para DELETE.
- Usar `Data Source=hospital.db` para conectar a la base de datos.
- Probar cada endpoint con curl o Thunder Client antes de entregar.
- Al terminar, avisar al docente y dejar el repo con commit y push realizados.

## Objetivos de la prueba

- U3: implementar operaciones CRUD completas (INSERT, UPDATE, DELETE) con validación de existencia y códigos HTTP correctos (201, 200, 404).
- U4: crear README de portada, gestionar issues, crear ramas por feature, abrir PR hacia `main` protegida.
- Criterio de evaluación: Apto / No apto aún por objetivo mínimo.

## Material provisto — Esqueleto de `Program.cs`

```csharp
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Data.SQLite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// --- U3: CRUD completo sobre hospital.db ---
var connectionString = "Data Source=hospital.db";

// TODO: implementar endpoints CRUD para patients

// --- U4: Trabajo final ---
// TODO: README de portada, issue en GitHub, rama por feature, PR hacia main

app.Run();
```

## Parte 1 — CRUD de patients con Dapper (50 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Implementar `POST /patients` que inserte un nuevo patient en la tabla `patients` y retorne `Results.Created` con código 201 y el patient creado (incluyendo el `patientId` generado). Validar que `firstName` y `lastName` no estén vacíos. | 15 |
| 1.2 | Implementar `PUT /patients/{patientId:long}` que actualice el patient con ese ID y retorne `Results.Ok` (200) con el patient actualizado. Si el patient no existe, retornar `Results.NotFound` con `new { mensaje = "Patient no encontrado" }`. | 15 |
| 1.3 | Implementar `DELETE /patients/{patientId:long}` que elimine el patient con ese ID y retorne `Results.NoContent` (204) si se eliminó correctamente. Si el patient no existe, retornar `Results.NotFound` con `new { mensaje = "Patient no encontrado" }`. | 10 |
| 1.4 | Validar que antes de DELETE se verifique la existencia del patient y que no tenga admissions asociadas (integridad referencial). Si tiene admissions, retornar `Results.BadRequest` con `new { mensaje = "No se puede eliminar un patient con admissions asociadas" }`. | 10 |

## Parte 2 — Flujo git y README (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Crear README de portada con descripción del proyecto, endpoints disponibles y instrucciones de ejecución. | 10 |
| 2.2 | Crear un issue en GitHub que describa una mejora pendiente del proyecto. | 5 |
| 2.3 | Crear una rama por feature (por ejemplo, `feature/crud-patients`), hacer commit en esa rama y abrir un PR hacia `main`. | 10 |
| 2.4 | Verificar que `main` esté protegida (no se puede hacer push directo) y que el PR haya sido revisado. | 5 |

## Parte 3 — Verificación y cierre (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Probar `POST /patients` con datos válidos y verificar que retorna 201 con el patient creado. | 5 |
| 3.2 | Probar `PUT /patients/1` con datos válidos y verificar que retorna 200 con el patient actualizado. | 5 |
| 3.3 | Probar `DELETE /patients/999` (ID inexistente) y verificar que retorna 404. | 5 |
| 3.4 | Realizar commit final y push al repo grupal. | 5 |

## Parte 4 — Ítems conceptuales

- ¿Por qué se usa el código 201 en `POST` y no 200? (5 pts)
- ¿Qué diferencia hay entre `Results.Ok` y `Results.Created` en cuanto al código HTTP y la semántica? (5 pts)
- ¿Qué es una rama por feature y por qué se usa en lugar de trabajar directamente en `main`? (5 pts)
- ¿Qué significa que `main` esté protegida y qué operaciones se bloquean? (5 pts)

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `POST /patients` con body válido | Nuevo patient creado | `201` con el patient creado incluyendo `patientId` generado |
| `POST /patients` con body vacío (sin firstName) | Validación fallida | `400` con mensaje de error de validación |
| `PUT /patients/1` con body válido | Patient actualizado | `200` con el patient actualizado |
| `PUT /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` |
| `DELETE /patients/1` | Patient eliminado | `204` sin contenido |
| `DELETE /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` |
| `DELETE /patients/1` (con admissions) | Patient con admissions | `400` con `{ "mensaje": "No se puede eliminar un patient con admissions asociadas" }` |

## Al terminar

Dejar el proyecto funcionando, con commit y push realizados, README de portada, issue creado y PR abierto hacia `main`. Avisar al docente para la corrección. Se devuelve con nota de Apto o No apto aún por objetivo mínimo.
