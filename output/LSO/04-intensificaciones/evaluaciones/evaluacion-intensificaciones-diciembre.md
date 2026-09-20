# Evaluación — Intensificación de diciembre — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de diciembre (fuera de la estructura anual) |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |
| Cantidad de versiones | 2 (A y B) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos durante el ciclo lectivo |
| Requisitos | Haber cursado la totalidad del año; contar con `hospital.db`, SDK .NET 6, Dapper, Git y cuenta GitHub |
| Lugar | Aula de informática con VS Code, Thunder Client y conexión a GitHub |

## Descripción general

Esta evaluación verifica el camino mínimo completo del curso. Cada estudiante construye (o completa) un proyecto Minimal API con CRUD sobre `hospital.db` y lo entrega en GitHub. El estándar es el mismo para ambas versiones; cambia la tabla de trabajo.

## Criterios de evaluación

Se evalúa cada objetivo de forma independiente. El resultado general es **Apto** si todos los objetivos están logrados; **No apto aún por objetivo mínimo** si falta al menos uno, y se detalla cuál(es).

| # | Objetivo mínimo | Logrado | No logrado |
|---|---|---|---|
| 1 | Declara variables, usa condicionales, bucles y funciones en un programa de consola C# | ☐ | ☐ |
| 2 | Crea un endpoint GET con `MapGet` que devuelve una respuesta JSON | ☐ | ☐ |
| 3 | Conecta SQLite con `SqliteConnection` y ejecuta una consulta SELECT con `QueryFirstOrDefault` y parámetro de ruta | ☐ | ☐ |
| 4 | Devuelve `Results.NotFound` para un recurso inexistente | ☐ | ☐ |
| 5 | Implementa un endpoint GET con `Query<T>` que devuelve una lista completa de registros | ☐ | ☐ |
| 6 | Crea un endpoint POST con `MapPost`, `ExecuteScalar` y devuelve `Results.Created` | ☐ | ☐ |
| 7 | Crea un endpoint PUT con `MapPut`, verifica existencia y actualiza con `Execute` | ☐ | ☐ |
| 8 | Crea un endpoint DELETE con `MapDelete`, verifica existencia y devuelve `Results.NoContent` | ☐ | ☐ |
| 9 | Todas las consultas SQL usan parámetros (`@param` + objeto anónimo) sin concatenación | ☐ | ☐ |
| 10 | Entrega en GitHub con rama feature, PR mergeado y README de portada | ☐ | ☐ |

## Guía de corrección (docente)

**Versión A — tabla Patients.**
**Versión B — tabla Doctors.**

El estudiante presenta su proyecto funcionando y el repositorio en GitHub. El docente recorre cada objetivo con la lista de verificación. Para aprobar cada objetivo, el código debe cumplir los patrones canónicos de `convenciones-tecnicas.md` (tipos `long` para IDs, `string` para fechas, alias `AS` en SELECT, consultas parametrizadas, `using var connection`, records después de `app.Run()`).

Si el estudiante completa todos los objetivos en la versión A pero no en la B (o viceversa), se considera **No apto aún** y se le asigna la misma versión que no completó para la instancia de marzo. No hay cambio de versión entre diciembre y marzo.