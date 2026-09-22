# Anexo docente — Encuentro 4: Introducción a .NET y C#

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Solución de la exploración de verbos HTTP

Los cuatro verbos fundamentales en Minimal API son:

| Verbo Minimal API | Verbo HTTP | Uso típico |
| --- | --- | --- |
| `MapGet` | GET | Obtener un recurso o lista de recursos |
| `MapPost` | POST | Crear un nuevo recurso |
| `MapPut` | PUT | Reemplazar un recurso existente |
| `MapDelete` | DELETE | Eliminar un recurso |

Ejemplo mínimo de cada uno en `Program.cs`:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET: obtener un saludo
app.MapGet("/saludo", () => "Hola desde Minimal API");

// POST: crear un mensaje (sin cuerpo real, solo ejemplo)
app.MapPost("/mensaje", (string texto) => $"Mensaje recibido: {texto}");

// PUT: actualizar un recurso por id
app.MapPut("/elemento/{id:long}", (long id, string valor) =>
    $"Elemento {id} actualizado a: {valor}");

// DELETE: eliminar un recurso por id
app.MapDelete("/elemento/{id:long}", (long id) =>
    $"Elemento {id} eliminado");

app.Run();
```

### Solución del cuadro comparativo

| Verbo | Método Minimal API | Verbo HTTP | Qué hace típicamente |
| --- | --- | --- | --- |
| Obtener | `MapGet` | GET | Lee un recurso sin modificar el servidor |
| Crear | `MapPost` | POST | Envía datos para crear un nuevo recurso |
| Actualizar | `MapPut` | PUT | Reemplaza un recurso existente con datos nuevos |
| Eliminar | `MapDelete` | DELETE | Borra un recurso del servidor |

## 2. Solución de la actividad de extensión

### Ejemplo completo de cada verbo ejecutable

```csharp
// Program.cs — ejemplos de todos los verbos HTTP en Minimal API
// No usa base de datos; solo demuestra la estructura de cada verbo

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET / — respuesta simple de texto
app.MapGet("/", () => "Bienvenido a la API");

// GET /saludo — respuesta con objeto anonimo
app.MapGet("/saludo", () => new { mensaje = "Hola, mundo!" });

// POST /saludo — recibe un nombre y devuelve un saludo personalizado
app.MapPost("/saludo", (string nombre) =>
    new { mensaje = $"Hola, {nombre}!" });

// PUT /saludo/{id} — actualiza un saludo por id
app.MapPut("/saludo/{id:long}", (long id, string nombre) =>
    new { id, mensaje = $"Saludo actualizado para {nombre}" });

// DELETE /saludo/{id} — elimina un saludo por id
app.MapDelete("/saludo/{id:long}", (long id) =>
    Results.Ok(new { mensaje = $"Saludo {id} eliminado" }));

app.Run();
```

**Salida esperada al probar en el navegador:**
- `GET /` → `Bienvenido a la API`
- `GET /saludo` → `{"mensaje":"Hola, mundo!"}`
- Los otros verbos requieren herramientas como Thunder Client o `curl` para enviar la petición.

## 3. Respuesta esperada del ejercicio

| Pregunta | Respuesta esperada |
| --- | --- |
| ¿Qué es .NET? | Una plataforma de desarrollo de Microsoft que incluye runtime, biblioteca estándar y herramientas CLI para crear aplicaciones multiplataforma. |
| ¿Qué es C#? | El lenguaje de programación principal que se usa sobre la plataforma .NET. |
| ¿Cuál es la diferencia entre `dotnet new console` y `dotnet new web`? | Console crea una app de línea de comandos que ejecuta código secuencial y termina. Web crea una aplicación que levanta un servidor HTTP y responde a peticiones de forma continua. |
| ¿Qué es `Program.cs` en .NET 6? | El archivo único donde vive todo el código de la aplicación, usando sentencias de nivel superior (top-level statements) sin necesidad de una clase `Main` explícita. |
| ¿Qué hace `app.Run()`? | Inicia el servidor Kestrel y pone la aplicación a escuchar peticiones HTTP en el puerto asignado. |
| ¿Qué tipos de datos fundamentales se vieron? | `string` (texto), `int` (entero 32 bits), `long` (entero 64 bits), `bool` (verdadero/falso), `double` (decimal de doble precisión). |

## 4. Criterios de corrección (lista de verificación)

- [ ] El alumno puede nombrar al menos 3 tipos de datos fundamentales de C# y dar un ejemplo de cada uno.
- [ ] El alumno distingue correctamente entre proyecto de consola y proyecto web.
- [ ] El alumno puede explicar qué hace cada línea de `Program.cs` (`CreateBuilder`, `Build`, `Run`).
- [ ] El alumno identifica correctamente los 4 verbos HTTP disponibles en Minimal API.
- [ ] El alumno puede ejecutar `dotnet new web` y `dotnet run` sin errores.
- [ ] El alumno escribe comentarios en español sin tildes ni eñes dentro del código.
- [ ] El alumno hizo el primer commit en GitHub con el mensaje correcto.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `dotnet new web` genera errores de permisos | No tener permisos de escritura en la carpeta destino | Verificar que la carpeta de trabajo sea escribible; probar en otra ubicación. |
| `Program.cs` no tiene `app.Run()` y la app no arranca | Olvidar la línea que inicia el servidor | Recordar que `app.Run()` es obligatoria para levantar el servidor; es la última línea del archivo. |
| Confusión entre `int` y `long` para IDs | No conocer la diferencia de tamaño entre 32 y 64 bits | Explicar que `int` es de 32 bits y `long` de 64 bits; en la materia se usa `long` para IDs por consistencia con la base de datos futura. |
| Comentarios con tildes en el código fuente | No conocer la convención del curso | Recordar la regla: comentarios en el código sin tildes ni eñes; usar `e` o `ee` como reemplazo. |
| No hacer commit al final del encuentro | Falta de hábito de versionado | Reforzar la rutina: `git add .`, `git commit -m "<carpeta>: <resumen>"`, `git push` al cerrar cada sesión. |
| No distingue consola de web | Confusión entre los dos tipos de proyecto | Hacer comparar los archivos `.csproj` generados por cada comando; el de web tiene referencias a `Microsoft.AspNetCore.App`. |

## 6. Registro de la clase

| Grupo | Presentes | Participación en apertura | Comprensión de tipos | Ejecución de `dotnet run` | Commit en GitHub | Observaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | — | — | — | — | — | — |
| Grupo 2 | — | — | — | — | — | — |
| Grupo 3 | — | — | — | — | — | — |
| Grupo 4 | — | — | — | — | — | — |

**Notas para evaluación de proceso:**
- Verificar que cada grupo tenga al menos un commit en GitHub al final del encuentro.
- Observar si los grupos pueden ejecutar `dotnet run` sin ayuda.
- Registrar qué grupos identificaron correctamente los 4 verbos HTTP en la extensión.
- Anotar errores frecuentes para abordarlos en el encuentro siguiente.
