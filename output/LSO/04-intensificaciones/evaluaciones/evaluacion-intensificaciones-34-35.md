# Evaluación — Intensificación de las Unidades 3 y 4 (Encuentros 34–35)

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 3 y 4 |
| Encuentros | 34 y 35 |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |
| Cantidad de versiones | 2 (A y B) |
| Destinatarios | Totalidad del curso |
| Requisitos | Haber participado de los encuentros 34 y 35; contar con `hospital.db`, proyecto `dotnet new web`, Dapper, Thunder Client y cuenta GitHub |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite, Git y GitHub |

## Descripción general

Esta evaluación comprueba que cada estudiante ha alcanzado los objetivos mínimos sobre operaciones CRUD con Dapper y flujo Git profesional. Cada estudiante recibe la versión A o la versión B (mismos objetivos, distinta tabla de `hospital.db`). Resuelve de forma individual.

## Criterios de evaluación

Se evalúa cada objetivo de forma independiente. El resultado general es **Apto** si todos los objetivos están logrados; **No apto aún por objetivo mínimo** si falta al menos uno, y se detalla cuál(es).

| # | Objetivo mínimo | Logrado | No logrado |
|---|---|---|---|
| 1 | Crea un endpoint POST con `MapPost` que recibe JSON y ejecuta `INSERT` con `ExecuteScalar` | ☐ | ☐ |
| 2 | Devuelve `Results.Created` con la URL del nuevo recurso en un POST exitoso | ☐ | ☐ |
| 3 | Crea un endpoint PUT con `MapPut` que verifica existencia con `QueryFirstOrDefault` antes de actualizar | ☐ | ☐ |
| 4 | Devuelve `Results.NotFound` si el recurso a actualizar o eliminar no existe | ☐ | ☐ |
| 5 | Crea un endpoint DELETE con `MapDelete` que ejecuta `Execute` y devuelve `Results.NoContent` | ☐ | ☐ |
| 6 | Usa consultas parametrizadas en todas las operaciones CRUD (sin concatenación SQL) | ☐ | ☐ |
| 7 | Crea una rama feature en Git, commitea los cambios, abre un Pull Request y lo mergea | ☐ | ☐ |
| 8 | Escribe un README de portada con título, descripción, tecnologías y tabla de endpoints | ☐ | ☐ |

## Guía de corrección (docente)

Cada estudiante muestra los endpoints funcionando con Thunder Client y el repositorio en GitHub.

**Versión A — tabla Patients.**
**Versión B — tabla Doctors.**

Para aprobar un objetivo, el código debe:
1. `app.MapPost("/ruta", (TipoRequest request) => { ... })` con `ExecuteScalar<long>`.
2. `Results.Created($"/ruta/{nuevoId}", recurso)`.
3. `connection.QueryFirstOrDefault<T>(sql, new { id })` dentro del PUT, y si es `null` devolver `Results.NotFound`.
4. Usar `Execute(sql, new { ... })` para UPDATE y DELETE.
5. `Results.NoContent()` después del DELETE exitoso.
6. Todos los SQL con `@param` y objeto anónimo.
7. Rama con nombre descriptivo (`feature/crud-minimo`), al menos un commit, PR mergeado en GitHub.
8. README.md con los elementos solicitados, visible en la raíz del repo.

No se exige validación cruzada, tests de integración, milestones ni CI/CD. Esos son contenidos de fortalecimiento.