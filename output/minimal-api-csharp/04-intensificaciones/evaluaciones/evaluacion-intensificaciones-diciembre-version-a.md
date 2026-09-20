# Evaluación — Intensificación de diciembre — Versión A

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | CRUD completo sobre tabla `Patients` con JOIN a `Provinces` |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Construí un proyecto Minimal API desde cero (`dotnet new web`) que cumpla los siguientes puntos. Trabajá de forma individual. Usá la base `hospital.db` con los tipos canónicos de `convenciones-tecnicas.md`.

### Requisitos

1. **Programa de consola** (se puede hacer en un proyecto separado `dotnet new console`): declará variables `string`, `int` y `double`. Escribí un condicional `if/else` que determine si un número es positivo o negativo. Escribí un bucle `for` que sume los primeros 10 números naturales. Escribí una función `static` que calcule el cuadrado de un número.

2. **Endpoint GET /patients** — Devuelve todos los pacientes como JSON usando `Query<Patient>`.

3. **Endpoint GET /patients/{id:long}** — Devuelve un paciente por ID con `QueryFirstOrDefault<Patient>`. Si no existe, devolvé `Results.NotFound`.

4. **Endpoint POST /patients** — Recibe JSON con `FirstName`, `LastName`, `Gender`, `BirthDate`, `City`. Insertá con `ExecuteScalar<long>`, devolvé `Results.Created`.

5. **Endpoint PUT /patients/{id:long}** — Verificá existencia, ejecutá `UPDATE` con `Execute`, devolvé `Results.Ok` con el registro actualizado. Si no existe, devolvé `Results.NotFound`.

6. **Endpoint DELETE /patients/{id:long}** — Verificá existencia, ejecutá `DELETE` con `Execute`, devolvé `Results.NoContent`. Si no existe, devolvé `Results.NotFound`.

7. Probá el ciclo completo: POST → GET → PUT → GET → DELETE → GET (404).

8. **Git:** creá una rama `feature/crud-minimo`, commit, PR y merge.

9. **README.md** con título, descripción, tecnologías y tabla de endpoints.