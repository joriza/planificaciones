# Evaluación — Intensificación de marzo — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de marzo (fuera de la estructura anual, previa al nuevo ciclo) |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |
| Cantidad de versiones | 2 (A y B) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en la instancia de diciembre |
| Requisitos | Haber cursado la totalidad del año y la instancia de diciembre; contar con `hospital.db`, SDK .NET 6, Dapper, Git y cuenta GitHub |
| Lugar | Aula de informática con VS Code, Thunder Client y conexión a GitHub |

## Descripción general

Esta evaluación verifica el camino mínimo completo del curso con el mismo estándar que diciembre. Cada estudiante trae su proyecto preparado (tuvo de diciembre a marzo para trabajarlo) y lo defiende en el encuentro. Se evalúa con la misma lista de objetivos.

## Criterios de evaluación

Idénticos a la instancia de diciembre (mismo estándar, no baja). Se evalúa cada objetivo de forma independiente. El resultado general es **Apto** si todos los objetivos están logrados; **No apto aún por objetivo mínimo** si falta al menos uno, y se detalla cuál(es).

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

Mismos criterios que diciembre. El docente ya tiene el registro de qué versión trabajó cada estudiante en diciembre. Si el estudiante cambia de versión por iniciativa propia, se evalúa sobre la nueva versión siempre que cumpla todos los objetivos. Si no completa, se registra con la versión que intentó.

Los criterios de aprobación por objetivo son idénticos a diciembre: patrones canónicos de `convenciones-tecnicas.md`, consultas parametrizadas, tipos correctos (`long`, `string`), `using var connection`, records después de `app.Run()`.

Si el estudiante no aprueba en marzo, se recomienda recursar la materia y se notifica formalmente.