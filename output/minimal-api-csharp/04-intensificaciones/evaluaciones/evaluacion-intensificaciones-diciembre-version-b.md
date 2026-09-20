# Evaluación — Intensificación de diciembre — Versión B

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | CRUD completo sobre tabla `Doctors` con conteo de admisiones |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Construí un proyecto Minimal API desde cero (`dotnet new web`) que cumpla los siguientes puntos. Trabajá de forma individual. Usá la base `hospital.db` con los tipos canónicos de `convenciones-tecnicas.md`.

### Requisitos

1. **Programa de consola** (se puede hacer en un proyecto separado `dotnet new console`): declará variables `string`, `int` y `double`. Escribí un condicional `if/else` que determine si un estudiante aprueba o desaprueba (nota ≥ 6). Escribí un bucle `for` que cuente del 1 al 10. Escribí una función `static` que calcule el área de un rectángulo.

2. **Endpoint GET /doctors** — Devuelve todos los doctores como JSON usando `Query<Doctor>`.

3. **Endpoint GET /doctors/{id:long}** — Devuelve un doctor por ID con `QueryFirstOrDefault<Doctor>`. Si no existe, devolvé `Results.NotFound`.

4. **Endpoint POST /doctors** — Recibe JSON con `FirstName`, `LastName`, `Specialty`. Insertá con `ExecuteScalar<long>`, devolvé `Results.Created`.

5. **Endpoint PUT /doctors/{id:long}** — Verificá existencia, ejecutá `UPDATE` con `Execute`, devolvé `Results.Ok` con el registro actualizado. Si no existe, devolvé `Results.NotFound`.

6. **Endpoint DELETE /doctors/{id:long}** — Verificá existencia, ejecutá `DELETE` con `Execute`, devolvé `Results.NoContent`. Si no existe, devolvé `Results.NotFound`.

7. Probá el ciclo completo: POST → GET → PUT → GET → DELETE → GET (404).

8. **Git:** creá una rama `feature/crud-minimo`, commit, PR y merge.

9. **README.md** con título, descripción, tecnologías y tabla de endpoints.