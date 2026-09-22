# Anexo docente — Encuentro 6: Minimal API y endpoint GET

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### API de saludos — solución completa

```csharp
// Program.cs — API de saludos con endpoints GET
// No usa base de datos; ejercicio de endpoints Minimal API

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET / — endpoint raiz que devuelve un mensaje
app.MapGet("/", () => new { mensaje = "API de saludos" });

// GET /saludo/{nombre} — saluda al nombre recibido en la ruta
app.MapGet("/saludo/{nombre}", (string nombre) =>
    new { saludo = $"Hola, {nombre}!" });

// GET /suma/{a}/{b} — suma dos numeros y devuelve el resultado
app.MapGet("/suma/{a:double}/{b:double}", (double a, double b) =>
    new { resultado = a + b });

app.Run();
```

**Salida verificada:**

| Endpoint | Comando | Salida esperada |
| --- | --- | --- |
| `GET /` | `curl http://localhost:5000/` | `{"mensaje":"API de saludos"}` |
| `GET /saludo/Ana` | `curl http://localhost:5000/saludo/Ana` | `{"saludo":"Hola, Ana!"}` |
| `GET /suma/3/5` | `curl http://localhost:5000/suma/3/5` | `{"resultado":8}` |
| `GET /suma/2.5/1.5` | `curl http://localhost:5000/suma/2.5/1.5` | `{"resultado":4}` |

## 2. Solución de la actividad de extensión

### Extensión: endpoint de multiplicación y saludo con despedida

Agregar dos endpoints más a la API de saludos:

1. `GET /multiplicar/{a}/{b}` — devuelve el producto de dos números.
2. `GET /despedida/{nombre}` — devuelve un mensaje de despedida personalizado.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => new { mensaje = "API de saludos" });

app.MapGet("/saludo/{nombre}", (string nombre) =>
    new { saludo = $"Hola, {nombre}!" });

app.MapGet("/suma/{a:double}/{b:double}", (double a, double b) =>
    new { resultado = a + b });

// Extension: multiplicar dos numeros
app.MapGet("/multiplicar/{a:double}/{b:double}", (double a, double b) =>
    new { resultado = a * b });

// Extension: despedida personalizada
app.MapGet("/despedida/{nombre}", (string nombre) =>
    new { despedida = $"Adios, {nombre}! Hasta la proxima." });

app.Run();
```

**Salida esperada adicional:**
- `GET /multiplicar/4/3` → `{"resultado":12}`
- `GET /despedida/Luis` → `{"despedida":"Adios, Luis! Hasta la proxima."}`

## 3. Respuesta esperada del ejercicio

| Pregunta | Respuesta esperada |
| --- | --- |
| ¿Qué hace `app.MapGet("/", () => ...)`? | Define un endpoint GET en la ruta raíz `/`. Cuando un cliente hace una solicitud GET a esa URL, ejecuta la función lambda y devuelve lo que esta retorna. |
| ¿Por qué el JSON sale en camelCase? | El serializador JSON por defecto de .NET convierte los nombres de propiedades PascalCase a camelCase automáticamente. |
| ¿Qué diferencia hay entre `{nombre}` y `{nombre:double}`? | Sin tipo, el parámetro es `string` por defecto. Con `:double`, el enrutador convierte el valor de la URL a tipo `double` antes de pasárselo al método. |
| ¿Qué pasa si visito `/saludo/` sin un nombre? | El enrutador no coincide porque la ruta requiere un valor para `{nombre}`. Devuelve un error 404. |
| ¿Cómo se prueba un endpoint que recibe dos parámetros? | Se incluyen ambos valores en la URL separados por barras, por ejemplo `/suma/3/5`. |
| ¿Por qué usamos `double` en lugar de `int` para las sumas? | `double` permite recibir números decimales en los parámetros de ruta, haciendo el endpoint más flexible. |

## 4. Criterios de corrección (lista de verificación)

- [ ] El alumno crea un proyecto con `dotnet new web` sin errores.
- [ ] Define al menos 3 endpoints GET con `MapGet`.
- [ ] El endpoint `/` devuelve un objeto con la propiedad `mensaje`.
- [ ] El endpoint `/saludo/{nombre}` recibe un parámetro de ruta y lo incluye en la respuesta.
- [ ] El endpoint `/suma/{a}/{b}` recibe dos parámetros numéricos y devuelve la suma.
- [ ] El código compila sin errores.
- [ ] Los endpoints se prueban correctamente en el navegador o con `curl`.
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes.
- [ ] El grupo hizo commit y push al final del encuentro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `curl` devuelve conexión rechazada | El servidor no está corriendo o está en otro puerto | Verificar que `dotnet run` esté ejecutándose en otra terminal. El puerto lo asigna .NET automáticamente. |
| `404 Not Found` al visitar una ruta | La ruta definida en `MapGet` no coincide con la URL visitada | Verificar que la ruta en `MapGet` coincida exactamente con la URL del navegador, incluyendo mayúsculas y minúsculas. |
| Error de compilación con `{a:double}` | Sintaxis incorrecta en el tipo de ruta | La sintaxis correcta es `{a:double}` dentro de la cadena de la ruta. Verificar que no haya espacios. |
| `nombre` llega como `null` o vacío | No pasar el valor en la URL | La ruta `/saludo/` sin valor no coincide con `/saludo/{nombre}`. La URL debe ser `/saludo/AlgunaGente`. |
| El resultado de la suma es un entero aunque se usen decimales | Usar `int` en lugar de `double` para los parámetros | Cambiar el tipo de los parámetros a `double` para aceptar decimales en la URL. |
| Olvidar `app.Run()` | La app compila pero no responde a peticiones | `app.Run()` es obligatoria para iniciar el servidor. Debe ser la última línea ejecutable de `Program.cs`. |

## 6. Registro de la clase

| Grupo | Presentes | Endpoint / creado | Prueba en navegador exitosa | Prueba con curl exitosa | Commit en GitHub | Observaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | — | — | — | — | — | — |
| Grupo 2 | — | — | — | — | — | — |
| Grupo 3 | — | — | — | — | — | — |
| Grupo 4 | — | — | — | — | — | — |

**Notas para evaluación de proceso:**
- Verificar que cada grupo tenga al menos un commit en GitHub al final del encuentro.
- Observar si los grupos pueden crear y probar al menos un endpoint GET sin ayuda.
- Registrar qué grupos lograron la extensión (multiplicación y despedida) sin ayuda.
- Anotar errores frecuentes para abordarlos en el encuentro siguiente.
