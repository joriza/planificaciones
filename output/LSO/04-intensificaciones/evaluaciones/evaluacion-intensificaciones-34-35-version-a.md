# Evaluación del momento 34-35 — Versión A

> Dominio de esta versión: doctors/admissions de hospital.db (U3+U4). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-34-35.md`.

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

// TODO: implementar endpoints CRUD para doctors

// --- U4: Trabajo final ---
// TODO: README de portada, issue en GitHub, rama por feature, PR hacia main

app.Run();
```

## Parte 1 — CRUD de doctors con Dapper (50 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Implementar `POST /doctors` que inserte un nuevo doctor en la tabla `doctors` y retorne `Results.Created` con código 201 y el doctor creado (incluyendo el `doctorId` generado). Validar que `firstName` y `lastName` no estén vacíos. | 15 |
| 1.2 | Implementar `PUT /doctors/{doctorId:long}` que actualice el doctor con ese ID y retorne `Results.Ok` (200) con el doctor actualizado. Si el doctor no existe, retornar `Results.NotFound` con `new { mensaje = "Doctor no encontrado" }`. | 15 |
| 1.3 | Implementar `DELETE /doctors/{doctorId:long}` que elimine el doctor con ese ID y retorne `Results.NoContent` (204) si se eliminó correctamente. Si el doctor no existe, retornar `Results.NotFound` con `new { mensaje = "Doctor no encontrado" }`. | 10 |
| 1.4 | Validar que antes de DELETE se verifique la existencia del doctor y que no tenga admissions asociadas (integridad referencial). Si tiene admissions, retornar `Results.BadRequest` con `new { mensaje = "No se puede eliminar un doctor con admissions asociadas" }`. | 10 |

## Parte 2 — Flujo git y README (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Crear README de portada con descripción del proyecto, endpoints disponibles y instrucciones de ejecución. | 10 |
| 2.2 | Crear un issue en GitHub que describa una mejora pendiente del proyecto. | 5 |
| 2.3 | Crear una rama por feature (por ejemplo, `feature/crud-doctors`), hacer commit en esa rama y abrir un PR hacia `main`. | 10 |
| 2.4 | Verificar que `main` esté protegida (no se puede hacer push directo) y que el PR haya sido revisado. | 5 |

## Parte 3 — Verificación y cierre (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Probar `POST /doctors` con datos válidos y verificar que retorna 201 con el doctor creado. | 5 |
| 3.2 | Probar `PUT /doctors/1` con datos válidos y verificar que retorna 200 con el doctor actualizado. | 5 |
| 3.3 | Probar `DELETE /doctors/999` (ID inexistente) y verificar que retorna 404. | 5 |
| 3.4 | Realizar commit final y push al repo grupal. | 5 |

## Parte 4 — Ítems conceptuales

- ¿Por qué se usa el código 201 en `POST` y no 200? (5 pts)
- ¿Qué diferencia hay entre `Results.Ok` y `Results.Created` en cuanto al código HTTP y la semántica? (5 pts)
- ¿Qué es una rama por feature y por qué se usa en lugar de trabajar directamente en `main`? (5 pts)
- ¿Qué significa que `main` esté protegida y qué operaciones se bloquean? (5 pts)

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `POST /doctors` con body válido | Nuevo doctor creado | `201` con el doctor creado incluyendo `doctorId` generado |
| `POST /doctors` con body vacío (sin firstName) | Validación fallida | `400` con mensaje de error de validación |
| `PUT /doctors/1` con body válido | Doctor actualizado | `200` con el doctor actualizado |
| `PUT /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` |
| `DELETE /doctors/1` | Doctor eliminado | `204` sin contenido |
| `DELETE /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` |
| `DELETE /doctors/1` (con admissions) | Doctor con admissions | `400` con `{ "mensaje": "No se puede eliminar un doctor con admissions asociadas" }` |

## Al terminar

Dejar el proyecto funcionando, con commit y push realizados, README de portada, issue creado y PR abierto hacia `main`. Avisar al docente para la corrección. Se devuelve con nota de Apto o No apto aún por objetivo mínimo.
