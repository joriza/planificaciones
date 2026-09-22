# Convenciones técnicas — Minimal API con C# .NET 6

> **Canon del curso.** Esta hoja es la fuente única de verdad de tipos, formatos y estructura de código de la materia «Minimal API con C# .NET 6». Todos los documentos de la materia la obedecen: **toda divergencia con esta hoja es un defecto**, no una variación de estilo.

| Campo | Valor |
| --- | --- |
| Curso | Minimal API con C# .NET 6 |
| Registro | Docente y alumnos |
| Base de datos canónica | SQLite, archivo `hospital.db` — 4 tablas: `province_names`, `doctors`, `patients`, `admissions` |
| Referencias de apoyo | `database-docs/` (esquema, diccionario, modelos de referencia, resumen para el curso) |

## 1. Propósito y alcance

- Esta hoja define los **tipos de datos, formatos y estructura del código** de todo el curso: ejemplos de clase, anexos docentes, evaluaciones y trabajos de alumnos (TP-U1, TP-U2, TP-U3 y trabajo final).
- Ante cualquier duda técnica, **esta hoja decide**: el ajuste se hace primero acá y recién después se propaga a los documentos derivados. Nunca al revés.
- **Alcance:** entorno y estructura del proyecto, estilo de código, tipos canónicos para el mapeo BD-lenguaje, acceso a datos con Dapper, respuestas HTTP, control de versiones y prueba de la API.
- **Fuera de alcance:** el contenido de cada encuentro (lo fija la planificación anual) y el formato pedagógico de los documentos (lo fija `estructura-de-la-clase.md`).

## 2. Entorno y estructura del proyecto

- **Entorno:** VS Code + terminal. SDK .NET 6 (o versión superior disponible, el comportamiento de registros posicionales y Dapper es idéntico).
- **Proyecto:** se crea con `dotnet new web`, se ejecuta con `dotnet run` y se detiene con `Ctrl+C`.
- **Dónde vive el código:** todo el código en un único archivo `Program.cs` con top-level statements. Prohibidas las carpetas `Models/`, `Services/`, `Interfaces/` y `Controllers/`.
- **Archivos extra:** solo cuando sean estrictamente necesarios (por ejemplo, `hospital.db` copiado al lado del `.csproj`). `.gitignore` en la raíz con `bin/` y `obj/`.
- **Esqueleto del archivo:**
  1. `using` directivas (Dapper, Microsoft.Data.Sqlite)
  2. `var builder = WebApplication.CreateBuilder(args);`
  3. `var app = builder.Build();`
  4. Endpoints (`MapGet` / `MapPost` / `MapPut` / `MapDelete`)
  5. `app.Run();`
  6. **Records posicionales al final**, después de `app.Run()` (requerido por CS8803: no pueden declararse antes de las top-level statements).

## 3. Estilo de código

- **Idiomas:** identificadores y rutas de endpoints en inglés y en plural (`Patient`, `patientId`, `/patients/{id:long}`). Texto visible al usuario (mensajes de error, títulos de ejemplo) y comentarios en español.
- **Comentarios:** un comentario por cada acción del código. Sin tildes ni eñes dentro del código fuente (sí en los comentarios). Ejemplo:
  ```csharp
  // Abrir conexion a la base de datos
  using var connection = new SqliteConnection(connectionString);
  ```
- **Ejemplos:** mínimos, completos, que compilen y corran tal cual. Sin pseudocódigo ni fragmentos incompletos.
- **Prohibido:** patrón repositorio, inyección de dependencias, cualquier abstracción fuera del alcance de la materia. Sin `TypedResults`: usar solo `Results.*`.

## 4. Tipos canónicos (BD ↔ lenguaje)

> **Advertencia del spike de verificación.** Todas las reglas de esta sección fueron verificadas experimentalmente contra la base `hospital.db` con Dapper y registros posicionales de C#. Las columnas INTEGER de SQLite se leen como `Int64` (long) en .NET, no como `Int32` (int). Las columnas TEXT se leen como `String`. Dapper construye los registros posicionales emparejando el tipo del constructor con el tipo devuelto por la columna — si no coinciden exactamente, la materialización falla con `InvalidOperationException`.

| Dato en la BD | Tipo C# canónico | Declaración en el record | Regla (comportamiento observado) |
| --- | --- | --- | --- |
| Clave primaria (INTEGER → Int64) | `long` | `long PatientId` | **No usar `int`**: Dapper exige el tipo exacto `Int64` para columnas INTEGER. Intentar `int PatientId` produce `InvalidOperationException`: el constructor del record posicional no coincide. |
| Fecha (TEXT → String, ISO `yyyy-MM-dd`) | `string` | `string BirthDate` | **No usar `DateTime` ni `DateOnly`**: Dapper no convierte el String devuelto por SQLite a esos tipos en el constructor posicional. El error es el mismo: no hay constructor que coincida. Usar `string` y convertir solo al presentar. |
| Texto nullable (TEXT nullable → String o null) | `string?` | `string? City` | Funciona correctamente: las columnas que admiten NULL se mapean como `string?` y Dapper asigna `null` cuando el valor es `NULL`. |
| Número nullable (INTEGER nullable → Int64 o null) | `long?` | `long? Height` | **No usar `int?`**: Dapper ve `Int64` de la columna. `long?` funciona correctamente para valores presentes y `null`. |
| Conteos / agregaciones (INTEGER → Int64) | `long` | `ExecuteScalar<long>()` | `ExecuteScalar<long>` y `ExecuteScalar<int>` funcionan ambos para `COUNT(*)`. Se prefiere `long` por consistencia con el resto de tipos canónicos. |

**Mapeo de nombres:** las columnas de la BD usan snake_case (`patient_id`, `first_name`). Los records usan PascalCase (`PatientId`, `FirstName`). **Siempre se usa alias `AS`** en el SELECT con el nombre exacto del parámetro del constructor:

```sql
SELECT patient_id AS PatientId, first_name AS FirstName FROM patients
```

Sin alias, Dapper busca un constructor con parámetros que coincidan con los nombres de columna (`patient_id`), lo que falla porque el record usa `PatientId`.

**Fechas:** viajan como texto ISO `yyyy-MM-dd` en el record y en la consulta. Se convierten solo al presentar:

```csharp
string nacimiento = "1963-02-12";                // tal como sale de la BD
var fecha = DateTime.Parse(nacimiento);           // para operar
string enFormatoLocal = fecha.ToString("dd/MM/yyyy");  // "12/02/1963"
```

## 5. Acceso a datos

- **Conexión:** cadena fija `"Data Source=hospital.db"`. La base se copia junto al `.csproj`. Cada handler abre su propia conexión con `using var connection = new SqliteConnection(connectionString);` (se cierra automáticamente al salir del bloque).
- **Consultas SIEMPRE parametrizadas:** el valor llega por `@id` con un objeto anónimo `new { id }`. Jamás concatenar datos al texto SQL.
- **Operaciones canónicas (lista cerrada):**

| Operación | Método Dapper | Retorno | Ejemplo |
| --- | --- | --- | --- |
| Lectura de muchas filas | `Query<T>` | `List<T>` | `conn.Query<Patient>(sql).ToList()` |
| Lectura de una fila | `QueryFirstOrDefault<T>` | `T?` | `conn.QueryFirstOrDefault<Patient>(sql, new { id })` |
| Escritura (INSERT/UPDATE/DELETE) | `Execute` | `int` (filas afectadas) | `conn.Execute(sql, new { ... })` |
| Alta con devolución del ID | `ExecuteScalar<long>` | `long` | `conn.ExecuteScalar<long>(sqlInsert, new { ... })` |
| Conteo | `ExecuteScalar<long>` | `long` | `conn.ExecuteScalar<long>("SELECT COUNT(*) FROM patients")` |

Ejemplo canónico mínimo (lectura con parámetro):

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// GET /patients/{id:long} — obtener un paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});
```

## 6. Respuestas HTTP y errores

> **Nota del spike.** Todos los códigos se verificaron ejecutando endpoints reales contra la base. `Results.NotFound` y `Results.BadRequest` aceptan objetos anónimos con `mensaje` en español.

| Código | Cuándo se usa | Método canónico | Ejemplo |
| --- | --- | --- | --- |
| `200` | Lectura correcta (GET) o reemplazo en memoria | `Results.Ok(dato)` | `Results.Ok(patient)` |
| `201` | Alta correcta (POST) | `Results.Created(url, dato)` | `Results.Created($"/patients/{newId}", paciente)` |
| `204` | Borrado (DELETE) o actualización sobre BD (PUT) | `Results.NoContent()` | `Results.NoContent()` |
| `400` | Dato faltante, mal formado o que no pasa validación | `Results.BadRequest(new { mensaje = "..." })` | `Results.BadRequest(new { mensaje = "El nombre es obligatorio" })` |
| `404` | Recurso inexistente | `Results.NotFound(new { mensaje = "..." })` | `Results.NotFound(new { mensaje = "Paciente no encontrado" })` |

- `500` **nunca** se devuelve a propósito: cuando aparece indica un error de servidor (base no encontrada, columna mal nombrada) y se diagnostica revisando la terminal.
- Mensajes de `400` y `404` en español dentro de `new { mensaje = "..." }`.

## 7. Control de versiones del alumno

- **Repositorio:** un repositorio por grupo, con una carpeta por trabajo (`tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`) en la rama `main` hasta la Unidad 3.
- **Ramas:** desde la Unidad 4 se usan ramas por feature, pull requests revisados y `main` protegida.
- **Ignorados:** `bin/` y `obj/` desde el primer commit (`.gitignore` en la raíz).
- **Rutina de cierre de cada encuentro:**
  ```bash
  git add .
  git commit -m "<carpeta>: <resumen en espanol, sin tildes>"
  git push
  ```
  Un commit por encuentro, con mensaje referente al trabajo realizado.

## 8. Probar la API

- **Lecturas (GET):** navegador o `curl <url>` desde la terminal.
- **Escrituras (POST/PUT/DELETE):** Thunder Client (extensión de VS Code) o `curl` con `-X POST -H "Content-Type: application/json" -d '{...}' <url>`.
- **Puerto:** el que asigna .NET (`http://localhost:5xxx`); se asume `http://localhost:5000` en los ejemplos salvo que el SDK asigne otro.

## 9. Checklist de defectos frecuentes

> Cada defecto fue observado experimentalmente en el spike de verificación contra la base real `hospital.db` con registros posicionales de C#.

| ✔ | Defecto | Comportamiento observado | Corrección |
| --- | --- | --- | --- |
| ☐ | ID declarado como `int` en el record | `InvalidOperationException`: Dapper busca constructor `(Int64, String)` porque SQLite INTEGER devuelve `Int64`, pero el record ofrece `(int, String)`. La materialización falla. | Usar `long PatientId` en todos los records. |
| ☐ | Fecha declarada como `DateTime` o `DateOnly` | `InvalidOperationException`: Dapper recibe `String` de la columna TEXT y no encuentra constructor que acepte `DateTime`/`DateOnly`. | Usar `string BirthDate` en el record. Convertir con `DateTime.Parse()` solo al presentar. |
| ☐ | Columna INTEGER nullable declarada como `int?` | `InvalidOperationException`: Dapper espera `Int64` (o `long?`) porque SQLite INTEGER es siempre `Int64`. `int?` no coincide. | Usar `long? Height`, `long? Weight`. |
| ☐ | SELECT sin alias `AS` en snake_case | `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` (snake_case) en lugar de `PatientId` (PascalCase). | Usar `SELECT patient_id AS PatientId, ...`. |
| ☐ | Concatenar datos al SQL en lugar de parámetro | Riesgo de inyección SQL y errores de sintaxis con cadenas que contengan comillas. | Usar `@id` y `new { id }` en toda consulta. |
| ☐ | Devolver el objeto crudo sin `Results` | ASP.NET serializa con nombres del record (PascalCase) sin configuración adicional, pero viola la convención del curso. | Envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc. |
| ☐ | Olvidar `using` en la conexión | La conexión no se cierra y puede agotar el pool de SQLite. | Usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint. |
| ☐ | Records antes de `app.Run()` | Error CS8803: las top-level statements deben preceder a las declaraciones de tipos. | Escribir `app.Run();` y **después** los records. |
| ☐ | Olvidar `?` en campos nulables (allergies, city, height, weight) | Dapper asigna `null` pero la propiedad no nulable puede recibir un valor predeterminado vacío en lugar de `null`, ocultando la nulabilidad. | Declarar como `string?` o `long?` según el tipo canónico. |