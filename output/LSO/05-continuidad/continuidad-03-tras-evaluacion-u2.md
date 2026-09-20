# Continuidad pedagógica — Repaso tras evaluación de la Unidad 2

**Curso:** Minimal API con C# .NET 6
**Momento de uso:** Tras la evaluación de la Unidad 2 (encuentro 15)
**Duración teórica:** 240 minutos
**Requisitos:** Computadora con SDK .NET 6, VS Code, terminal, conexión a Internet, archivo `hospital.db` copiado junto al `.csproj`.
**Contenido repasado:** Unidad 1 (fundamentos de C# y Minimal API GET) y Unidad 2 completa (SQLite, SQL con SELECT/JOIN/ORDER BY, Dapper con Query\<T\>, alias, parámetros y operador LIKE).

---

## Objetivos

- Conectar una base SQLite desde C# usando `SqliteConnection` y ejecutar consultas SELECT con Dapper.
- Escribir consultas SQL con `WHERE`, `JOIN` entre dos tablas y `ORDER BY`.
- Usar alias `AS` en el SELECT para emparejar con los registros posicionales de C#.
- Aplicar el operador `LIKE` con parámetros para filtrar texto parcial.
- Manejar el tipo `long` y `string` en los registros posicionales según las convenciones del curso.

---

## Actividades (100 puntos — 240 minutos)

### Actividad 1 — Conexión y SELECT simple (20 puntos — 50 minutos)

Escribí el código completo de un endpoint `GET /patients` que devuelva la lista de todos los pacientes de la tabla `patients`. Usá Dapper con `Query<Patient>` y mostrá el resultado con `Results.Ok`.

Incluí:
- La declaración de `connectionString`.
- El `using var connection` dentro del endpoint.
- El SELECT con alias `AS` para cada columna.
- El record `Patient` posicional al final del archivo.

**Valores de la BD:** `patient_id` (INTEGER → `long`), `first_name`, `last_name`, `gender`, `birth_date` (TEXT → `string`), `city` (`string?`), `province_id` (`long`), `allergies` (`string?`), `height` (`long?`), `weight` (`long?`).

| Criterio | Puntaje |
| --- | --- |
| Conexión y estructura del endpoint correctas | 5 ptos. |
| SELECT con alias `AS` para todas las columnas | 6 ptos. |
| Record `Patient` con tipos correctos (long en PK, string en fechas, ? en nulables) | 6 ptos. |
| Devolución con `Results.Ok(patients)` | 3 ptos. |

### Actividad 2 — Filtro WHERE con parámetro (20 puntos — 50 minutos)

Agregá al mismo proyecto un endpoint `GET /patients/{id:long}` que busque un paciente por su ID. Usá `QueryFirstOrDefault<Patient>` con un parámetro `@id`.

Si el paciente existe, devolvelo con `Results.Ok`. Si no existe, devolvé `Results.NotFound` con un mensaje en español.

| Criterio | Puntaje |
| --- | --- |
| Endpoint con ruta `{id:long}` y parámetro `long id` | 6 ptos. |
| Consulta parametrizada con `@id` y `new { id }` | 6 ptos. |
| Manejo de `null` con `Results.NotFound` | 4 ptos. |
| Mensaje de error en español | 4 ptos. |

### Actividad 3 — JOIN entre dos tablas (20 puntos — 50 minutos)

La tabla `doctors` tiene las columnas `doctor_id`, `first_name`, `last_name` y `specialty`. Escribí un endpoint `GET /doctors` que devuelva todos los médicos. Luego, escribí un endpoint `GET /doctors/{id:long}` que devuelva un médico por ID.

Para el segundo endpoint, el SELECT debe incluir **alias AS** exactamente como en el primer ejercicio. Mostrá el código completo de ambos endpoints.

| Criterio | Puntaje |
| --- | --- |
| Endpoint `GET /doctors` con SELECT y alias correctos | 8 ptos. |
| Endpoint `GET /doctors/{id:long}` con filtro parametrizado | 8 ptos. |
| Record `Doctor` correcto (tipos: `long DoctorId`, `string FirstName`, `string LastName`, `string Specialty`) | 4 ptos. |

### Actividad 4 — LIKE con parámetro (20 puntos — 50 minutos)

Escribí un endpoint `GET /patients/search` que acepte un *query parameter* `term` (de tipo `string`) y devuelva los pacientes cuyo apellido (`last_name`) contenga ese término.

Usá `LIKE '%' || @term || '%'` (concatenación con `||` compatible con SQLite). Devolvé la lista con `Results.Ok`.

Ejemplo: `GET /patients/search?term=Garc` devuelve todos los pacientes con apellido que contenga "Garc".

| Criterio | Puntaje |
| --- | --- |
| Lectura del parámetro `term` desde la *query string* | 6 ptos. |
| Consulta con `LIKE` y concatenación segura (parametrizada) | 8 ptos. |
| Devolución correcta con `Results.Ok` | 6 ptos. |

### Actividad 5 — Repaso integrador Unidad 1 (20 puntos — 40 minutos)

Sin usar base de datos, escribí un endpoint `GET /resumen` que devuelva un objeto JSON con la siguiente información:

```json
{
  "materia": "Minimal API con C# .NET 6",
  "unidadesVistas": ["U1: Fundamentos de C# y Minimal API", "U2: Acceso a datos con SQLite y Dapper"],
  "totalEndpointsCreados": 4
}
```

El valor `totalEndpointsCreados` debe calcularse con una variable `int total` inicializada en 0 y sumarle 1 cuatro veces mediante un bucle `for`.

| Criterio | Puntaje |
| --- | --- |
| Objeto JSON con las tres propiedades correctas | 8 ptos. |
| Bucle `for` correcto para calcular el total | 8 ptos. |
| Uso de `Results.Ok` y código compilable | 4 ptos. |

---

## Autoevaluación para el alumno

| Afirmación | Lo logré | Lo logré parcialmente | No lo logré |
| --- | --- | --- | --- |
| Conecto SQLite desde C# y ejecuto SELECT con Dapper. | ☐ | ☐ | ☐ |
| Escribo un JOIN entre dos tablas con alias AS. | ☐ | ☐ | ☐ |
| Filtro con WHERE parametrizado (`@id`, `new { id }`). | ☐ | ☐ | ☐ |
| Uso LIKE con concatenación `||` para texto parcial. | ☐ | ☐ | ☐ |
| Declaro records con `long` en PK, `string` en fechas y `?` en nulables. | ☐ | ☐ | ☐ |
| Combino endpoints GET con y sin base de datos en un mismo proyecto. | ☐ | ☐ | ☐ |

**Tiempo real que me llevó:** ________ minutos.

---

## Nota académica obligatoria

La resolución de estas actividades se realiza en forma habitual, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es **individual y manuscrita**, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.