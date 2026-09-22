# Encuentro 7 — Parámetros y rutas en GET

> Unidad 1 — Fundamentos de C# y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 7 de 36 |
| Unidad | 1 — Fundamentos de C# y Minimal API |
| Eje temático | 2 — Minimal API y endpoints HTTP |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Concepto nuevo | Parámetros y rutas en GET |
| Requisitos previos | Encuentro 6: Minimal API y endpoint GET |
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

1. Definir parámetros de ruta en un endpoint GET usando la sintaxis `{parametro:tipo}`.
2. Diferenciar entre parámetros de ruta y parámetros de query string.
3. Filtrar datos en un endpoint usando valores de query string.
4. Construir una API GET con múltiples parámetros opcionales y obligatorios.
5. Probar endpoints con diferentes combinaciones de parámetros en el navegador y `curl`.

## 3. Apertura y motivación (20 min)

### Charla rápida: ¿Cómo busca un bibliotecario un libro?

Un bibliotecario busca un libro por título, por autor o por ambos. Si le das solo el título, busca por título. Si le das el título y el autor, filtra más. En una API, los parámetros de ruta son como decir "el libro número 5" y los parámetros de query string son como decir "quiero libros de autor X". Hoy vamos a aprender ambos.

### Diagnóstico rápido

- Si la URL es `/productos/3`, ¿qué es `3`? ¿Un parámetro de ruta o de query string?
- ¿Cuál es la diferencia entre `/productos?id=3` y `/productos/3`?
- ¿Pueden pensar una URL de un buscador que use query strings? (Ejemplo: `google.com/search?q=algo`)

Se toman 3 minutos para discutir en grupos de a 2.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 Parámetros de ruta (25 min)

Los parámetros de ruta se definen entre llaves en la URL del endpoint.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Un solo parametro de ruta
// URL: http://localhost:5000/producto/3
app.MapGet("/producto/{id:long}", (long id) =>
    new { id, mensaje = $"Producto con ID {id}" });

// Dos parametros de ruta
// URL: http://localhost:5000/categoria/2/producto/15
app.MapGet("/categoria/{categoriaId:long}/producto/{productoId:long}",
    (long categoriaId, long productoId) =>
    new { categoriaId, productoId });

app.Run();
```

**Salida esperada:**
- `GET /producto/3` → `{"id":3,"mensaje":"Producto con ID 3"}`
- `GET /categoria/2/producto/15` → `{"categoriaId":2,"productoId":15}`

### 4.2 Parámetros de query string (25 min)

Los parámetros de query string vienen después del `?` en la URL y se declaran como parámetros del método.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Endpoint que acepta un parametro de query string opcional
// URL: http://localhost:5000/buscar?nombre=Laptop
app.MapGet("/buscar", (string? nombre) =>
{
    if (string.IsNullOrEmpty(nombre))
    {
        return Results.BadRequest(new { mensaje = "El parametro nombre es obligatorio" });
    }

    return Results.Ok(new { resultado = $"Buscando: {nombre}" });
});

// Endpoint con parametro de query string con valor por defecto
// URL: http://localhost:5000/paginar?pagina=2
app.MapGet("/paginar", (int pagina = 1, int tamano = 10) =>
    new { pagina, tamano, totalElementos = pagina * tamano });

app.Run();
```

**Salida esperada:**
- `GET /buscar?nombre=Laptop` → `{"resultado":"Buscando: Laptop"}`
- `GET /buscar` → `{"mensaje":"El parametro nombre es obligatorio"}` (400)
- `GET /paginar?pagina=2` → `{"pagina":2,"tamano":10,"totalElementos":20}`
- `GET /paginar` → `{"pagina":1,"tamano":10,"totalElementos":10}` (usa valores por defecto)

### 4.3 Combinar ruta y query string (25 min)

Se pueden usar ambos tipos de parámetros en el mismo endpoint.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Ruta: /productos/{categoriaId} con query string ?minPrecio y ?maxPrecio
app.MapGet("/productos/{categoriaId:long}", (long categoriaId, double? minPrecio, double? maxPrecio) =>
{
    // Simular una lista de productos (sin base de datos)
    var productos = new[]
    {
        new { id = 1L, nombre = "Laptop", categoriaId = 1L, precio = 999.99 },
        new { id = 2L, nombre = "Mouse", categoriaId = 1L, precio = 29.99 },
        new { id = 3L, nombre = "Monitor", categoriaId = 2L, precio = 299.99 },
        new { id = 4L, nombre = "Teclado", categoriaId = 1L, precio = 59.99 },
        new { id = 5L, nombre = "Impresora", categoriaId = 2L, precio = 199.99 }
    };

    // Filtrar por categoria
    var filtrados = productos.Where(p => p.categoriaId == categoriaId);

    // Filtrar por precio minimo si se proporciona
    if (minPrecio.HasValue)
    {
        filtrados = filtrados.Where(p => p.precio >= minPrecio.Value);
    }

    // Filtrar por precio maximo si se proporciona
    if (maxPrecio.HasValue)
    {
        filtrados = filtrados.Where(p => p.precio <= maxPrecio.Value);
    }

    return Results.Ok(filtrados);
});

app.Run();
```

**Salida esperada:**
- `GET /productos/1` → lista de productos con `categoriaId == 1`
- `GET /productos/1?minPrecio=50` → productos de categoría 1 con precio >= 50
- `GET /productos/2?maxPrecio=250` → productos de categoría 2 con precio <= 250

### 4.4 Parámetros opcionales en la ruta (25 min)

Se pueden hacer parámetros de ruta opcionales usando `?` al final del nombre.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Parametro de ruta opcional
// URL: http://localhost:5000/usuario/5
// URL: http://localhost:5000/usuario (sin id)
app.MapGet("/usuario/{id:long?}", (long? id) =>
{
    if (id.HasValue)
    {
        return Results.Ok(new { id, mensaje = $"Usuario con ID {id}" });
    }

    return Results.Ok(new { mensaje = "Lista de todos los usuarios" });
});

app.Run();
```

**Salida esperada:**
- `GET /usuario/5` → `{"id":5,"mensaje":"Usuario con ID 5"}`
- `GET /usuario` → `{"mensaje":"Lista de todos los usuarios"}`

### 4.5 Ejercicio guiado: API de filtrado de estudiantes (30 min)

Crear un endpoint `/estudiantes` que acepte parámetros de query string para filtrar por nombre y por nota mínima.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/estudiantes", (string? nombre, double? notaMinima) =>
{
    var estudiantes = new[]
    {
        new { nombre = "Ana", nota = 8.5 },
        new { nombre = "Luis", nota = 6.0 },
        new { nombre = "Maria", nota = 9.0 },
        new { nombre = "Carlos", nota = 4.5 }
    };

    var resultado = estudiantes.AsEnumerable();

    if (!string.IsNullOrEmpty(nombre))
    {
        resultado = resultado.Where(e => e.nombre.Contains(nombre, StringComparison.OrdinalIgnoreCase));
    }

    if (notaMinima.HasValue)
    {
        resultado = resultado.Where(e => e.nota >= notaMinima.Value);
    }

    return Results.Ok(resultado);
});

app.Run();
```

**Salida esperada:**
- `GET /estudiantes` → lista completa de 4 estudiantes
- `GET /estudiantes?nombre=an` → Ana y Maria (búsqueda insensible a mayúsculas)
- `GET /estudiantes?notaMinima=7` → Ana (8.5) y Maria (9.0)
- `GET /estudiantes?nombre=carlos&notaMinima=4` → Carlos (4.5)

## 5. Consolidación y cierre (20 min)

- Cada grupo prueba su endpoint con al menos dos combinaciones de parámetros.
- Preguntas de verificación:
  - ¿Qué es un parámetro de ruta y qué es un parámetro de query string?
  - ¿Cómo se declara un parámetro de ruta como opcional?
  - ¿Qué hace `StringComparison.OrdinalIgnoreCase`?
- Se cierra con un commit del trabajo realizado.

## 6. Actividad complementaria (80 min)

### Ejercicio independiente: API de búsqueda de películas

Crear una Minimal API con los siguientes endpoints:

1. `GET /peliculas` — devuelve una lista de 4 películas (título, año, género).
2. `GET /peliculas/{id:long}` — devuelve una película por ID.
3. `GET /peliculas/buscar?genero={genero}` — filtra por género.
4. `GET /peliculas/buscar?anioMin={anio}&anioMax={anio}` — filtra por rango de años.

**Pista:** Para el endpoint 2, si el ID no existe, devolver `Results.NotFound(new { mensaje = "Pelicula no encontrada" })`.

### Solución esperada

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var peliculas = new[]
{
    new { id = 1L, titulo = "El Señor de los Anillos", anio = 2001, genero = "Fantasia" },
    new { id = 2L, titulo = "Inception", anio = 2010, genero = "Ciencia Ficcion" },
    new { id = 3L, titulo = "El Padrino", anio = 1972, genero = "Drama" },
    new { id = 4L, titulo = "Interstellar", anio = 2014, genero = "Ciencia Ficcion" }
};

// GET /peliculas — listar todas
app.MapGet("/peliculas", () => Results.Ok(peliculas));

// GET /peliculas/{id} — obtener por id
app.MapGet("/peliculas/{id:long}", (long id) =>
{
    var pelicula = peliculas.FirstOrDefault(p => p.id == id);
    return pelicula is null
        ? Results.NotFound(new { mensaje = "Pelicula no encontrada" })
        : Results.Ok(pelicula);
});

// GET /peliculas/buscar?genero=... — filtrar por genero
app.MapGet("/peliculas/buscar", (string? genero) =>
{
    if (string.IsNullOrEmpty(genero))
    {
        return Results.BadRequest(new { mensaje = "El parametro genero es obligatorio" });
    }

    var filtradas = peliculas.Where(p =>
        p.genero.Equals(genero, StringComparison.OrdinalIgnoreCase));
    return Results.Ok(filtradas);
});

// GET /peliculas/buscar?anioMin=...&anioMax=... — filtrar por rango de anios
app.MapGet("/peliculas/buscar", (int? anioMin, int? anioMax) =>
{
    if (!anioMin.HasValue || !anioMax.HasValue)
    {
        return Results.BadRequest(new { mensaje = "Los parametros anioMin y anioMax son obligatorios" });
    }

    var filtradas = peliculas.Where(p => p.anio >= anioMin.Value && p.anio <= anioMax.Value);
    return Results.Ok(filtradas);
});

app.Run();
```

**Salida esperada:**
- `GET /peliculas` → lista completa de 4 películas
- `GET /peliculas/1` → El Señor de los Anillos
- `GET /peliculas/99` → `{"mensaje":"Pelicula no encontrada"}` (404)
- `GET /peliculas/buscar?genero=Ciencia%20Ficcion` → Inception e Interstellar
- `GET /peliculas/buscar?anioMin=2000&anioMax=2015` → El Señor de los Anillos, Inception, Interstellar

### Entrega del commit

```bash
git add .
git commit -m "tp-u1: parametros de ruta y query string en endpoints GET"
git push
```

## 7. Cierre (15 min)

### Qué te llevás

- Los parámetros de ruta se definen entre llaves en la URL: `/recurso/{id:long}`.
- Los parámetros de query string van después del `?` en la URL y se declaran como parámetros del método.
- Se puede combinar rutas con query strings en el mismo endpoint.
- Los parámetros de ruta opcionales usan `?` después del nombre: `{id:long?}`.
- Los tipos canónicos para parámetros numéricos son `long` para IDs y `double` para decimales.

### Lo que viene

**Encuentro 8: Cierre U1: repaso y TP** — Repasaremos todos los conceptos de la unidad y entregaremos el TP-U1 en GitHub.

## 8. Errores comunes y trampas

1. **Tipo de parámetro de ruta incompatible** — Usar `int` en el método cuando la ruta tiene `{id:long}` genera un error de enrutamiento. Siempre usar `long` para parámetros de ruta numéricos.
2. **Falta de `?` en tipos nullable** — Si un parámetro de query string es opcional, declararlo como `string?` o `double?`. Sin el `?`, el parámetro es obligatorio y dará error si no se proporciona.
3. **Orden de parámetros en la URL** — Los parámetros de query string se pasan en cualquier orden después del `?`, separados por `&`: `?nombre=Ana&notaMin=7`.
4. **No manejar el caso null** — Cuando un parámetro de query string es opcional y no se pasa, su valor es `null`. No verificar `null` antes de usarlo genera errores en tiempo de ejecución.
5. **Comillas en la URL** — Los espacios en los valores de query string se codifican como `%20` o se reemplazan por `+`. Escribir `?nombre=Hola Mundo` en la URL puede no funcionar; usar `?nombre=Hola%20Mundo` o `?nombre=Hola+Mundo`.
6. **Confundir parámetros de ruta con parámetros de query string** — `/productos/5` tiene `5` como parámetro de ruta. `/productos?id=5` tiene `id=5` como parámetro de query string. Son diferentes y se declaran diferente en el código.
