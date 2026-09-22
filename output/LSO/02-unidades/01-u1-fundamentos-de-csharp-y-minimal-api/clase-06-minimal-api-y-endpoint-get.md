# Encuentro 6 — Minimal API y endpoint GET

> Unidad 1 — Fundamentos de C# y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 6 de 36 |
| Unidad | 1 — Fundamentos de C# y Minimal API |
| Eje temático | 2 — Minimal API y endpoints HTTP |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Concepto nuevo | Minimal API y endpoint GET |
| Requisitos previos | Encuentros 4 y 5: tipos de datos, variables, estructuras de control, métodos |
| Organización del trabajo | Grupos de 3-4 personas; un repositorio compartido por grupo para todo el curso |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Crear un proyecto de Minimal API con `dotnet new web`.
2. Definir un endpoint GET con `MapGet` que devuelva una respuesta al navegador.
3. Entender la diferencia entre devolver texto plano y un objeto JSON.
4. Probar un endpoint GET desde el navegador y desde la terminal con `curl`.
5. Explicar el flujo de una solicitud HTTP: cliente → servidor → respuesta.

## 3. Apertura y motivación (20 min)

### Charla rápida: ¿Cómo llega un pedido al restaurante?

Cuando piden un plato en un restaurante, el mesero toma el pedido, lo lleva a la cocina, la cocina lo prepara y el mesero lo trae de vuelta. En una web, pasa algo parecido: el navegador (cliente) hace una solicitud (pedido), el servidor la recibe, procesa y devuelve una respuesta. Hoy vamos a construir el servidor.

### Pregunta de apertura

- ¿Qué creen que pasa cuando escriben una URL en el navegador y presionan Enter?
- ¿Quién es el cliente y quién es el servidor en esa situación?

Se toman 3 minutos para reflexionar en grupos de a 2. Se comparten las respuestas.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 Crear la primera Minimal API (15 min)

Desde la terminal, en la carpeta del proyecto:

```bash
# Crear un nuevo proyecto web (Minimal API)
dotnet new web -n MiApi
cd MiApi
```

El archivo `Program.cs` se genera con una estructura base. Abirlo y observar que contiene:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.Run();
```

Estas tres líneas son el esqueleto de toda Minimal API.

### 4.2 El primer endpoint GET (25 min)

Agregar una línea entre `var app = builder.Build();` y `app.Run();`:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Definir un endpoint GET en la ruta /
// Cuando alguien visite la ruta raiz, devuelve este texto
app.MapGet("/", () => "Hola desde mi primera API");

app.Run();
```

**Pasos para probar:**
1. Ejecutar `dotnet run` en la terminal.
2. Abrir el navegador y visitar `http://localhost:5000` (o el puerto que asigna .NET).
3. Deberían ver el texto `Hola desde mi primera API`.
4. Detener el servidor con `Ctrl+C`.

**Salida esperada en el navegador:** `Hola desde mi primera API`

### 4.3 Devolver objetos JSON (20 min)

En lugar de texto plano, se puede devolver un objeto. Minimal API lo convierte automáticamente a JSON.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Endpoint que devuelve un objeto como JSON
app.MapGet("/saludo", () => new
{
    mensaje = "Hola, mundo!",
    autor = "Curso Minimal API"
});

app.Run();
```

**Salida esperada en el navegador:** `{"mensaje":"Hola, mundo!","autor":"Curso Minimal API"}`

**Nota:** Los nombres de las propiedades en el JSON salen en camelCase (minúscula la primera letra) sin necesidad de configuración adicional.

### 4.4 Probar con `curl` (15 min)

Desde la terminal, en otra ventana (con el servidor corriendo):

```bash
# Probar el endpoint GET con curl
curl http://localhost:5000/saludo
```

**Salida esperada:** `{"mensaje":"Hola, mundo!","autor":"Curso Minimal API"}`

### 4.5 Endpoints con parámetros de ruta (25 min)

Los endpoints pueden recibir valores directamente en la URL.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Endpoint con un parametro de ruta :nombre
// La URL seria: http://localhost:5000/saludo/Carlos
app.MapGet("/saludo/{nombre}", (string nombre) =>
    $"Hola, {nombre}! Bienvenido.");

// Endpoint con un parametro numerico :id
// La URL seria: http://localhost:5000/usuario/5
app.MapGet("/usuario/{id:long}", (long id) =>
    new { id, mensaje = $"Usuario con ID {id}" });

app.Run();
```

**Salida esperada:**
- `GET /saludo/Carlos` → `Hola, Carlos! Bienvenido.`
- `GET /usuario/5` → `{"id":5,"mensaje":"Usuario con ID 5"}`

### 4.6 Ejercicio guiado: endpoint de productos (20 min)

Crear un endpoint `/productos` que devuelva una lista de productos como JSON.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/productos", () =>
{
    var productos = new[]
    {
        new { nombre = "Laptop", precio = 999.99 },
        new { nombre = "Mouse", precio = 29.99 },
        new { nombre = "Teclado", precio = 59.99 }
    };

    return productos;
});

app.Run();
```

**Salida esperada en `http://localhost:5000/productos`:**
```json
[{"nombre":"Laptop","precio":999.99},{"nombre":"Mouse","precio":29.99},{"nombre":"Teclado","precio":59.99}]
```

## 5. Consolidación y cierre (20 min)

- Cada grupo prueba su endpoint en el navegador y muestra la salida al docente.
- Preguntas de verificación:
  - ¿Qué hace `MapGet`?
  - ¿Qué diferencia hay entre devolver texto y devolver un objeto?
  - ¿Cómo se pasa un valor como parámetro en la URL?
- Se cierra con un commit del trabajo realizado.

## 6. Actividad complementaria (80 min)

### Ejercicio independiente: API de saludos

Crear una Minimal API que tenga los siguientes endpoints:

1. `GET /` — devuelve `{"mensaje":"API de saludos"}`.
2. `GET /saludo/{nombre}` — devuelve `{"saludo":"Hola, {nombre}!"}`.
3. `GET /suma/{a}/{b}` — recibe dos números como parámetros de ruta y devuelve `{"resultado":a+b}`.

**Pista:** Para el endpoint `/suma`, los parámetros `a` y `b` deben ser de tipo `int` o `double`. Usen `double` para aceptar decimales.

### Solución esperada

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => new { mensaje = "API de saludos" });

app.MapGet("/saludo/{nombre}", (string nombre) =>
    new { saludo = $"Hola, {nombre}!" });

app.MapGet("/suma/{a:double}/{b:double}", (double a, double b) =>
    new { resultado = a + b });

app.Run();
```

**Salida esperada:**
- `GET /` → `{"mensaje":"API de saludos"}`
- `GET /saludo/Ana` → `{"saludo":"Hola, Ana!"}`
- `GET /suma/3/5` → `{"resultado":8}`
- `GET /suma/2.5/1.5` → `{"resultado":4}`

### Entrega del commit

```bash
git add .
git commit -m "tp-u1: primer endpoint minimal api con mapget"
git push
```

## 7. Cierre (15 min)

### Qué te llevás

- Una Minimal API se crea con `dotnet new web` y tiene `Program.cs` como archivo único.
- `MapGet` define un endpoint que responde a solicitudes GET en una ruta específica.
- Se puede devolver texto plano, un objeto (que se convierte a JSON automáticamente) o una colección.
- Los parámetros de ruta se declaran entre llaves en la URL y se reciben como argumentos del lambda.
- Se prueban los endpoints en el navegador o con `curl`.

### Lo que viene

**Encuentro 7: Parámetros y rutas en GET** — Profundizaremos en parámetros de ruta y query string para filtrar datos en los endpoints.

## 8. Errores comunes y trampas

1. **No poner `app.Run()` al final** — Sin esta línea, el servidor no arranca. La app compila pero no responde a peticiones.
2. **Usar comillas simples en C#** — En C# los strings usan comillas dobles `"`. Las comillas simples son para caracteres individuales (`'a'`). Usar comillas simples en un string genera un error de compilación.
3. **Tipo de parámetro incorrecto en la ruta** — Si la URL tiene `{id:long}` pero el método recibe `int id`, el enrutador no coincide. Usar siempre `long` para parámetros numéricos de ruta.
4. **Olvidar el `:` en el tipo de parámetro de ruta** — Escribir `{id}` sin `:long` hace que el parámetro sea de tipo `string` por defecto. Para números, usar `{id:long}`.
5. **No ejecutar `dotnet run` antes de probar en el navegador** — El servidor debe estar corriendo para recibir peticiones. Abrir el navegador sin que el servidor esté activo da error de conexión.
6. **Devolver el objeto crudo sin `Results`** — En este encuentro se devuelven objetos directamente desde el lambda. En encuentros futuros se usarán `Results.Ok()`, `Results.NotFound()`, etc. No confundir los dos enfoques.
