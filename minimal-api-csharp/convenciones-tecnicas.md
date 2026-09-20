# Convenciones técnicas — Minimal API con C# .NET 6

> **Canon del curso.** Esta hoja es la fuente única de verdad de tipos, formatos y estructura de código de la materia «Minimal API con C# .NET 6». Todos los documentos de la materia (planificación, clases, evaluaciones, encuadre y cierres, intensificaciones, continuidad y criterios) la obedecen. **Toda divergencia con esta hoja es un defecto**, no una variación de estilo.

| Campo | Valor |
| --- | --- |
| Curso | Minimal API con C# .NET 6 |
| Registro | Hoja técnica docente, dirigida al docente y a los alumnos |
| Base de datos canónica | `hospital.db` (SQLite): tablas `province_names`, `doctors`, `patients`, `admissions` |
| Referencias de apoyo | `database-docs/01-esquema-bd.md` (esquema) y `database-docs/03-modelos-csharp-dapper.md` (records canónicos) del repositorio de planificación |

## 1. Propósito y alcance

- Esta hoja define los **tipos de datos, formatos y estructura del código** de todo el curso: ejemplos de clase, anexos, evaluaciones y trabajos de alumnos.
- Ante cualquier duda técnica, **esta hoja decide**. Si un documento necesitara algo distinto, se ajusta PRIMERO esta hoja (y, si el cambio afecta a los modelos, también `database-docs/03-modelos-csharp-dapper.md`), y recién después se propaga el cambio a los documentos derivados. Nunca al revés.
- **Alcance:** entorno y estructura del proyecto, estilo de código, tipos canónicos, acceso a datos, respuestas HTTP, control de versiones y prueba de la API.
- **Fuera de alcance:** el contenido de cada encuentro (lo fija la planificación anual) y el formato pedagógico de los documentos (lo fija la estructura de la clase). Los anexos docentes con soluciones van SIEMPRE en archivos `-anexo-docente.md` separados, nunca dentro de un documento entregable.

## 2. Entorno y estructura del proyecto

- **Entorno:** VS Code + terminal, con el SDK de .NET 6. Sin IDEs completos ni asistentes que generen archivos extra.
- **Proyecto:** se crea con `dotnet new web` (plantilla mínima de Minimal API, sin contenido de ejemplo innecesario). Si hace falta nombrarlo: inglés en PascalCase (`HospitalApi`). Se ejecuta con `dotnet run` y se detiene con `Ctrl+C`.
- **Todo el código vive en `Program.cs`**: endpoints escritos como *top-level statements* (instrucciones sueltas, sin `class` ni `Main`) y records declarados **en el mismo archivo**. Los records van **SIEMPRE al final**, después de `app.Run()`: el compilador rechaza una declaración de tipo antes o entre las instrucciones del programa (error CS8803).
- **Otros archivos solo si es estrictamente necesario:** `hospital.db` junto al `.csproj`, el propio `.csproj` (se modifica solo con `dotnet add package`), y `appsettings.json` recién en la Unidad 3 para la cadena de conexión. Nunca carpetas `Models/`, `Services/`, `Interfaces/` ni `Controllers/`.

Esqueleto canónico de `Program.cs`:

```csharp
using Dapper;                    // (desde la Unidad 2) ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // (desde la Unidad 2) conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// ... endpoints (MapGet, MapPost, MapPut, MapDelete) ...

app.Run();   // Deja la API escuchando pedidos hasta que se corta con Ctrl+C

// ---- Records: SIEMPRE al final, despues de las instrucciones ----
record Patient(long PatientId, string FirstName, string LastName);
```

## 3. Estilo de código

- **Identificadores en inglés:** records, propiedades, variables y rutas (`Patient`, `patientId`, `/patients`). **Texto y comentarios en español:** mensajes de respuesta y comentarios del código.
- **Comentarios abundantes:** cada acción del código de ejemplo va explicada con un comentario; el código se tiene que poder leer solo. En los comentarios **dentro del código** se evitan tildes y eñes (protege contra problemas de codificación en editores y consolas escolares); la prosa de los documentos mantiene su ortografía completa.
- **Ejemplos mínimos y funcionales:** cada fragmento compila y corre tal cual está escrito; nada de pseudocódigo ni partes «de relleno».
- **Sin abstracciones:** sin patrón repositorio, sin inyección de dependencias (no se registran servicios), sin clases intermedias con lógica. La estructura es siempre la misma: endpoints + records.
- **Rutas de endpoints en inglés y en plural:** `/patients`, `/doctors`, `/admissions`, `/provinces`. Un endpoint en español (`/pacientes`) es un defecto. Parámetros de ruta de id: `{id:long}`, con el parámetro del handler tipado `long id`.
- **JSON automático:** la API serializa los records a JSON con nombres *camelCase* (`patientId`, `firstName`) sin ninguna configuración.

## 4. Tipos canónicos (SQLite ↔ C#)

Tipos únicos para todo el curso, tanto en ejemplos como en trabajos de alumnos. También en la Unidad 1 (CRUD en memoria, sin base de datos) los ids son `long`: una sola regla, sin excepciones.

| Dato en SQLite | Tipo C# | Ejemplo en el record | Regla |
| --- | --- | --- | --- |
| `INTEGER` que es clave (id) | `long` | `long PatientId` | **Nunca `int` para ids** (SQLite entrega enteros como `long`; con `int` el mapeo falla con 500) |
| `TEXT` fecha en ISO `yyyy-MM-dd` | `string` | `string BirthDate` | **Nunca `DateOnly` ni `DateTime`** en records ni consultas |
| `TEXT` texto | `string` | `string LastName` | — |
| `TEXT` que acepta `NULL` | `string?` | `string? City` | El `?` solo si la columna es nullable |
| `INTEGER` que acepta `NULL` (medida) | `int?` | `int? Height` | Medidas (cm, kg), nunca ids |
| `INTEGER` conteo o total | `int` | `int Count` | `int` solo para conteos, nunca para ids |

Record canónico de paciente (alineado con `database-docs/03-modelos-csharp-dapper.md`, donde están también `Doctor`, `Admission` y los DTOs de JOIN; cualquier ajuste se hace primero allí y se refleja aquí):

```csharp
// Paciente: una fila de la tabla patients
record Patient(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string en ISO "yyyy-MM-dd"
    string? City,        // nullable: la columna acepta NULL
    string ProvinceId,
    string? Allergies,
    int? Height,         // cm (medida, no id)
    int? Weight          // kg
);
```

**Mapeo de columnas:** las columnas de la base están en *snake_case* (`patient_id`) y las propiedades C# en PascalCase (`PatientId`). Dapper encaja por nombre y el guión bajo rompe la coincidencia: **cada columna se renombra con alias en el SELECT** (`SELECT patient_id AS PatientId ...`). La comparación ignora mayúsculas y minúsculas, pero no perdona el guión bajo.

**Fechas:** la fecha viaja como texto ISO y se muestra tal cual (`"2001-03-14"`). Solo si hay que calcular con ella (edad, días internado) se convierte **al presentarla**, nunca en el record ni en la consulta:

```csharp
string birthDate = "2001-03-14";               // tal como sale del record
var fecha = DateTime.Parse(birthDate);         // conversion solo al presentar
int edad = DateTime.Today.Year - fecha.Year;   // calculo recien aqui
```

## 5. Acceso a datos con Dapper

- **Paquetes** (se agregan al comenzar la Unidad 2, dentro de la carpeta del proyecto):

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

- **Cadena de conexión canónica:** `"Data Source=hospital.db"`, con `hospital.db` copiado junto al `.csproj`. La conexión se abre **dentro de cada handler** con `using var connection = new SqliteConnection(connectionString);`: se cierra sola al terminar.
- **Consultas SIEMPRE parametrizadas:** el valor llega por un parámetro `@id` y se pasa con un objeto anónimo `new { ... }`. Jamás se concatena texto del SQL con datos recibidos (inyección SQL y errores de comillas).
- **Métodos de Dapper usados en el curso:** `Query<T>` (lista de filas), `QueryFirstOrDefault<T>` (una fila o `null`), `Execute` (INSERT/UPDATE/DELETE) y `ExecuteScalar<long>` (id recién insertado).

Ejemplo canónico mínimo, completo y funcional (endpoint GET con SELECT):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients/{id}: devuelve UN paciente segun su id
app.MapGet("/patients/{id:long}", (long id) =>
{
    // using: la conexion se cierra sola al salir del handler
    using var connection = new SqliteConnection(connectionString);

    // Consulta SIEMPRE parametrizada: el valor llega por @id,
    // nunca se concatena el SQL con el dato recibido.
    // Cada columna snake_case lleva AS para coincidir con el record
    var patient = connection.QueryFirstOrDefault<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE patient_id = @id",
        new { id });   // Objeto anonimo con los parametros de la consulta

    // Sin fila: 404. Con fila: 200 con el paciente serializado a JSON
    return patient is null ? Results.NotFound()
                           : Results.Ok(patient);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo (ver punto 4) ----
record Patient(
    long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City, string ProvinceId, string? Allergies,
    int? Height, int? Weight);
```

## 6. Respuestas HTTP

Los handlers devuelven **SIEMPRE** con la clase `Results` de forma explícita (`Results.Ok(...)`, `Results.NotFound(...)`), nunca devolviendo el objeto crudo. `Results` es el canon del curso en .NET 6: `TypedResults` es su variante con tipos, disponible desde .NET 7, y **no se usa en este curso** (un ejemplo que devuelva `TypedResults` es un defecto de versión).

| Código | Cuándo se usa | Método canónico | Ejemplo |
| --- | --- | --- | --- |
| `200` OK | Lectura (GET) o reemplazo correcto en memoria (PUT) | `Results.Ok(dato)` | `Results.Ok(patient)` |
| `201` Created | Alta correcta (POST), con la URL del recurso nuevo | `Results.Created(url, dato)` | `Results.Created($"/patients/{id}", patient)` |
| `204` No Content | Borrado correcto (DELETE) y actualización sobre base de datos (PUT/UPDATE con Dapper), respuesta sin cuerpo | `Results.NoContent()` | `Results.NoContent()` |
| `400` Bad Request | Pedido inválido: dato faltante, mal formado o que no pasa la validación manual | `Results.BadRequest(new { mensaje = "..." })` | `Results.BadRequest(new { mensaje = "La fecha no es valida" })` |
| `404` Not Found | El id pedido no existe en la base o en la lista | `Results.NotFound(new { mensaje = "..." })` | `Results.NotFound(new { mensaje = "No existe el paciente" })` |

> **Regla condicional del PUT:** sin base de datos (Unidad 1 y APIs en memoria) el reemplazo responde `200 OK` con el recurso actualizado (`Results.Ok(recursoActualizado)`); sobre base de datos con Dapper (Unidad 2 en adelante) responde `204 No Content` (`Results.NoContent()`), porque la consulta UPDATE no devuelve el recurso y así se evita una segunda consulta.

- `500` **nunca** se devuelve a propósito: aparece cuando el servidor falla sin manejo (por ejemplo, un mapeo `int`/`long` mal declarado). Ante un 500, leer el error completo en la terminal donde corre `dotnet run`.
- Los mensajes de `400` y `404` se escriben en español, dentro de un objeto anónimo `new { mensaje = "..." }`, para que la respuesta tenga un cuerpo legible.

## 7. Control de versiones (trabajo del alumno)

- **Un único repositorio por grupo para todo el curso**, alojado en GitHub. Una carpeta por trabajo en la raíz: `tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`. Cada entrega = carpeta nueva + commits + push.
- **Mono-rama `main`** desde el primer commit hasta la Unidad 4: nadie crea ramas antes de tiempo.
- **`.gitignore` en la raíz del repositorio**, creado con el primer commit, con las carpetas generadas `bin/` y `obj/` (nunca se versionan).

```text
repo-del-grupo/
├── .gitignore            <- en la raiz, desde el primer commit: bin/ y obj/
├── tp-u1/                <- proyecto Minimal API del primer trabajo
├── tp-u2/
├── tp-u3/
└── trabajo-final/
```

- **Rutina de cierre:** al terminar cada encuentro, o al cortar una clase sin terminar, un commit con mensaje referente y push:

```powershell
git add .
git commit -m "tp-u1: alta de pacientes"
git push
```

- **Convención de mensajes:** `<carpeta del trabajo>: <resumen de lo hecho>`, en español y en minúsculas después de los dos puntos, sin tildes (la consola no las trata bien). Ejemplos: `tp-u1: alta de pacientes`, `tp-u2: filtros con where y like`, `trabajo-final: estadisticas por especialidad`.
- **Unidad 4:** el mismo repositorio se profesionaliza con README de portada, issues para organizar el trabajo, ramas `feature/<tema>`, pull requests revisados entre pares antes de fusionar y `main` protegida (sin push directo).

## 8. Probar la API

- **GET: navegador.** Pegar la URL y leer el JSON (`http://localhost:5080/patients`). El navegador solo envía GET.
- **El resto de los verbos: `curl`**, siempre de una línea. El puerto lo asigna `dotnet run` (línea `Now listening on:`); los ejemplos asumen `5080`: reemplazar por el propio. En Windows PowerShell, `curl` puede ser un alias de `Invoke-WebRequest`: usar `curl.exe`.

```powershell
# GET todos (tambien desde el navegador)
curl http://localhost:5080/patients

# GET uno por id
curl http://localhost:5080/patients/25

# POST: alta (las comillas internas del JSON van escapadas con \")
curl -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"

# PUT: reemplazo completo del recurso
curl -X PUT http://localhost:5080/patients/25 -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"

# DELETE: baja (responde 204 sin cuerpo)
curl -X DELETE http://localhost:5080/patients/25

# -i muestra el codigo de estado de cualquier pedido
curl -i http://localhost:5080/patients/25
```

## 9. Checklist de defectos frecuentes

Verificación rápida antes de cerrar cualquier ejemplo o trabajo. Cada ítem es un defecto conocido del curso:

| ✔ | Defecto | Por qué falla | Corrección |
| --- | --- | --- | --- |
| ☐ | Id declarado `int` | SQLite entrega enteros como `long`: el mapeo de Dapper falla con 500 | Declarar `long` en todos los ids |
| ☐ | Fecha declarada `DateTime` o `DateOnly` | No mapea contra el `TEXT` ISO de SQLite | Declarar `string` con formato `yyyy-MM-dd` |
| ☐ | Consulta concatenada sin parámetros (`"... " + id`) | Inyección SQL y errores de comillas | Parametrizar siempre: `WHERE patient_id = @id` + `new { id }` |
| ☐ | Endpoint en español (`/pacientes`) | Rompe el canon de rutas del curso | Rutas en inglés y plural: `/patients` |
| ☐ | Código sin comentarios | El alumno no puede explicar su propia defensa | Comentar cada acción del código |
| ☐ | Archivo o carpeta extra innecesaria (`Models/`, `Services/`) | Viola la regla «solo `Program.cs`» | Todo el código en `Program.cs`, records al final |
| ☐ | Record declarado antes de `app.Run()` | El compilador rechaza tipos entre instrucciones (CS8803) | Records siempre al final del archivo |
| ☐ | `hospital.db` fuera de la raíz del proyecto | La conexión no encuentra las tablas (`no such table`) | Copiar la base junto al `.csproj` |
