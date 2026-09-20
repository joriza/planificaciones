# Evaluación — Intensificación de las Unidades 1 y 2 (Encuentros 17–18)

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 1 y 2 — primera instancia |
| Encuentros | 17 y 18 |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |
| Cantidad de versiones | 2 (A y B) |
| Destinatarios | Totalidad del curso |
| Requisitos | Haber participado de los encuentros 17 y 18; contar con `hospital.db`, proyecto `dotnet new web` y paquetes Dapper + Sqlite restaurados |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite y Thunder Client |

## Descripción general

Esta evaluación comprueba que cada estudiante ha alcanzado los objetivos mínimos sobre endpoints GET con Dapper y SQLite. Cada estudiante recibe la versión A o la versión B (mismos objetivos, distinta tabla de `hospital.db`). Resuelve de forma individual sobre su proyecto `Program.cs`.

## Criterios de evaluación

Se evalúa cada objetivo de forma independiente. El resultado general es **Apto** si todos los objetivos están logrados; **No apto aún por objetivo mínimo** si falta al menos uno, y se detalla cuál(es).

| # | Objetivo mínimo | Logrado | No logrado |
|---|---|---|---|
| 1 | Crea un endpoint GET con `MapGet` que devuelva una respuesta JSON | ☐ | ☐ |
| 2 | Conecta SQLite desde C# con `SqliteConnection` y cadena fija `"Data Source=hospital.db"` | ☐ | ☐ |
| 3 | Usa Dapper `Query<T>` para devolver una lista de registros como JSON | ☐ | ☐ |
| 4 | Usa Dapper `QueryFirstOrDefault<T>` para devolver un solo registro o `null` | ☐ | ☐ |
| 5 | Implementa un endpoint con parámetro de ruta `{id}` usando `new { id }` en Dapper | ☐ | ☐ |
| 6 | Maneja el caso "no encontrado" con `Results.NotFound` | ☐ | ☐ |
| 7 | Ejecuta un JOIN de 2 tablas con alias `AS` en SQL y lo mapea a un record con las columnas combinadas | ☐ | ☐ |

## Guía de corrección (docente)

Cada estudiante ejecuta su proyecto y muestra los endpoints funcionando con Thunder Client o curl. El docente revisa el código fuente para verificar los patrones correctos.

**Versión A — tabla Patients / Provinces.**
**Versión B — tabla Doctors / Admissions (según corresponda).**

Para aprobar un objetivo, el código debe:
1. Usar `app.MapGet("ruta", ...)` con función lambda o delegado.
2. Declarar `using var connection = new SqliteConnection("Data Source=hospital.db")` dentro del endpoint.
3. Llamar a `connection.Query<T>(sql).ToList()` y devolverlo con `Results.Ok`.
4. Llamar a `connection.QueryFirstOrDefault<T>(sql, new { id })` y verificar si es `null`.
5. Recibir el ID como parámetro `long id` en la ruta `{id:long}` y pasarlo a `new { id }`.
6. Usar `Results.NotFound(new { mensaje = "..." })` si el registro no existe.
7. El SQL debe contener `JOIN` explícito, alias `AS` en cada columna, y el record debe tener propiedades con los nombres de los alias.

No se exige paginación, filtros por query string ni JOIN de 3 tablas. Esos son contenidos de fortalecimiento y no forman parte del camino mínimo.