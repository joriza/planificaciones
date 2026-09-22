# Anexo docente — Encuentro 8: Cierre U1: repaso y TP

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### TP-U1: Minimal API GET — solución completa

```csharp
// Program.cs — TP-U1: Minimal API con endpoints GET
// No usa base de datos; ejercicio de entrega de la unidad 1

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET / — endpoint raiz
app.MapGet("/", () => new { mensaje = "API de la unidad 1" });

// GET /saludo/{nombre} — saluda al nombre recibido en la ruta
app.MapGet("/saludo/{nombre}", (string nombre) =>
    new { saludo = $"Hola, {nombre}!" });

// GET /suma/{a}/{b} — suma dos numeros recibidos como parametros de ruta
app.MapGet("/suma/{a:double}/{b:double}", (double a, double b) =>
    new { resultado = a + b });

// GET /productos — lista de productos de ejemplo
app.MapGet("/productos", () =>
{
    var productos = new[]
    {
        new { id = 1L, nombre = "Laptop", precio = 999.99 },
        new { id = 2L, nombre = "Mouse", precio = 29.99 },
        new { id = 3L, nombre = "Teclado", precio = 59.99 }
    };

    return Results.Ok(productos);
});

// GET /productos/{id} — obtener un producto por id
app.MapGet("/productos/{id:long}", (long id) =>
{
    var productos = new[]
    {
        new { id = 1L, nombre = "Laptop", precio = 999.99 },
        new { id = 2L, nombre = "Mouse", precio = 29.99 },
        new { id = 3L, nombre = "Teclado", precio = 59.99 }
    };

    var producto = productos.FirstOrDefault(p => p.id == id);
    return producto is null
        ? Results.NotFound(new { mensaje = "Producto no encontrado" })
        : Results.Ok(producto);
});

app.Run();
```

**Salida verificada:**

| Endpoint | Comando | Salida esperada |
| --- | --- | --- |
| `GET /` | `curl http://localhost:5000/` | `{"mensaje":"API de la unidad 1"}` |
| `GET /saludo/Carlos` | `curl http://localhost:5000/saludo/Carlos` | `{"saludo":"Hola, Carlos!"}` |
| `GET /suma/3/5` | `curl http://localhost:5000/suma/3/5` | `{"resultado":8}` |
| `GET /productos` | `curl http://localhost:5000/productos` | Array JSON con 3 productos |
| `GET /productos/1` | `curl http://localhost:5000/productos/1` | `{"id":1,"nombre":"Laptop","precio":999.99}` |
| `GET /productos/99` | `curl http://localhost:5000/productos/99` | `{"mensaje":"Producto no encontrado"}` (404) |

## 2. Solución de la actividad de extensión

### Ejercicio 1: endpoint de detalle con resumen

```csharp
// GET /productos/{id}/detalle — resumen de un producto
app.MapGet("/productos/{id:long}/detalle", (long id) =>
{
    var productos = new[]
    {
        new { id = 1L, nombre = "Laptop", precio = 999.99 },
        new { id = 2L, nombre = "Mouse", precio = 29.99 },
        new { id = 3L, nombre = "Teclado", precio = 59.99 }
    };

    var producto = productos.FirstOrDefault(p => p.id == id);
    if (producto is null)
    {
        return Results.NotFound(new { mensaje = "Producto no encontrado" });
    }

    var detalle = $"{producto.nombre} - Precio: ${producto.precio}";
    return Results.Ok(new { producto, detalle });
});
```

**Salida esperada:**
- `GET /productos/1/detalle` → `{"producto":{"id":1,"nombre":"Laptop","precio":999.99},"detalle":"Laptop - Precio: $999.99"}`
- `GET /productos/99/detalle` → `{"mensaje":"Producto no encontrado"}` (404)

### Ejercicio 2: suma con query strings

```csharp
// GET /suma?a=3&b=5 — suma con parametros de query string
app.MapGet("/suma", (double a, double b) =>
    new { resultado = a + b });
```

**Salida esperada:**
- `GET /suma?a=3&b=5` → `{"resultado":8}`
- `GET /suma` → error 400 (parámetros obligatorios sin valores por defecto)

### Ejercicio 3: validación del endpoint de saludo

```csharp
// GET /saludo/{nombre} con validacion
app.MapGet("/saludo/{nombre}", (string nombre) =>
{
    if (string.IsNullOrWhiteSpace(nombre))
    {
        return Results.BadRequest(new { mensaje = "El nombre no puede estar vacio" });
    }

    return Results.Ok(new { saludo = $"Hola, {nombre}!" });
});
```

**Salida esperada:**
- `GET /saludo/Ana` → `{"saludo":"Hola, Ana!"}`
- `GET /saludo/` → `{"mensaje":"El nombre no puede estar vacio"}` (400)

## 3. Respuesta esperada del ejercicio

| Pregunta | Respuesta esperada |
| --- | --- |
| ¿Qué debe contener el TP-U1? | Una Minimal API con al menos 5 endpoints GET funcionales en un único archivo `Program.cs`. |
| ¿Cuál es la estructura mínima de `Program.cs`? | `CreateBuilder` → `Build` → `MapGet` (uno o más) → `Run`. |
| ¿Qué es un commit en Git? | Una captura del estado del proyecto en un momento dado, con un mensaje descriptivo. |
| ¿Por qué se usa `git push`? | Para enviar los commits locales al repositorio remoto en GitHub, compartiendo el trabajo con el equipo y el docente. |
| ¿Qué debe contener el `.gitignore`? | Al menos `bin/` y `obj/` para evitar versionar archivos generados por la compilación. |
| ¿Cuál es el mensaje de commit correcto para la entrega? | `tp-u1: entrega final minimal api get` (español, minúsculas después de los dos puntos, sin tildes). |
| ¿Qué diferencia hay entre `Results.Ok` y `Results.NotFound`? | `Results.Ok` devuelve un código HTTP 200 con los datos. `Results.NotFound` devuelve un código HTTP 404 indicando que el recurso no existe. |

## 4. Criterios de corrección (lista de verificación)

### Para el TP-U1:

- [ ] El repositorio del grupo existe en GitHub con la carpeta `tp-u1/`.
- [ ] El archivo `Program.cs` contiene al menos 5 endpoints GET funcionales.
- [ ] El endpoint `/` devuelve un objeto con la propiedad `mensaje`.
- [ ] El endpoint `/saludo/{nombre}` recibe un parámetro de ruta y lo incluye en la respuesta.
- [ ] El endpoint `/suma/{a}/{b}` recibe dos parámetros numéricos y devuelve la suma.
- [ ] El endpoint `/productos` devuelve una lista de al menos 3 productos.
- [ ] El endpoint `/productos/{id:long}` maneja correctamente el caso de ID inexistente con `Results.NotFound`.
- [ ] El `.gitignore` en la raíz contiene `bin/` y `obj/`.
- [ ] El último commit tiene el mensaje de entrega correcto.
- [ ] El commit se hizo en la rama `main`.
- [ ] El código compila y los endpoints se prueban correctamente.
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes.

### Para la defensa individual (evaluación del Encuentro 9):

- [ ] El alumno puede explicar qué es .NET y qué rol cumple C#.
- [ ] El alumno puede explicar la estructura de `Program.cs` en una Minimal API.
- [ ] El alumno puede definir un endpoint GET con `MapGet` y explicar cada parte.
- [ ] El alumno distingue entre parámetros de ruta y parámetros de query string.
- [ ] El alumno puede modificar un endpoint existente para agregar un parámetro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `git: command not found` | Git no está instalado o no está en el PATH | Verificar que Git esté instalado; en VS Code usar la terminal integrada que ya tiene Git configurado. |
| `fatal: not a git repository` | No se ejecutó `git init` antes de los comandos de Git | Ejecutar `git init` en la carpeta raíz del proyecto antes de `git add`. |
| `remote origin already exists` | Ya se agregó un remote con ese nombre | Usar `git remote set-url origin <nueva-url>` para actualizar la URL. |
| `rejected: non-fast-forward` | El repositorio remoto tiene commits que el local no tiene | Hacer `git pull origin main` antes de `git push`. |
| El commit no incluye los archivos nuevos | No se ejecutó `git add .` antes del commit | Verificar que `git add .` se ejecutó y que los archivos aparecen en `git status`. |
| `tp-u1/` no está en el repositorio | El alumno creó los archivos en la carpeta raíz en lugar de en `tp-u1/` | Crear la carpeta `tp-u1/` y mover los archivos allí; hacer commit nuevamente. |
| `Results.NotFound` no reconocido | Falta `using` o el proyecto no es `dotnet new web` | Verificar que el proyecto se creó con `dotnet new web`. En Minimal API, `Results` está disponible sin `using` adicionales. |
| Commit con tildes en el mensaje | No conocer la convención del curso | Recordar que los mensajes de commit no llevan tildes ni eñes. Usar `e` o `ee` como reemplazo. |

## 6. Registro de la clase

| Grupo | Presentes | TP-U1 completado | Endpoints funcionales | Commit de entrega en GitHub | Rama main verificada | .gitignore correcto | Observaciones |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | — | — | — | — | — | — | — |
| Grupo 2 | — | — | — | — | — | — | — |
| Grupo 3 | — | — | — | — | — | — | — |
| Grupo 4 | — | — | — | — | — | — | — |

**Notas para evaluación de proceso:**
- Verificar que cada grupo tenga el commit de entrega en GitHub al final del encuentro.
- Confirmar que el `.gitignore` en la raíz contenga `bin/` y `obj/`.
- Confirmar que el último commit esté en la rama `main`.
- Registrar qué grupos tienen todos los endpoints funcionando.
- Anotar grupos que necesiten ayuda adicional para la defensa individual del Encuentro 9.
- Verificar que los grupos hayan recalculado el tamaño de los equipos según presentes ÷ equipos disponibles.
