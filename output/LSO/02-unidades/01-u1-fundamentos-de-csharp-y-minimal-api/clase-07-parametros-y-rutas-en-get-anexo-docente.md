# Anexo docente — Encuentro 7: Parámetros y rutas en GET

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### API de búsqueda de películas — solución completa

```csharp
// Program.cs — API de peliculas con parametros de ruta y query string
// No usa base de datos; ejercicio de filtrado con endpoints GET

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var peliculas = new[]
{
    new { id = 1L, titulo = "El Senor de los Anillos", anio = 2001, genero = "Fantasia" },
    new { id = 2L, titulo = "Inception", anio = 2010, genero = "Ciencia Ficcion" },
    new { id = 3L, titulo = "El Padrino", anio = 1972, genero = "Drama" },
    new { id = 4L, titulo = "Interstellar", anio = 2014, genero = "Ciencia Ficcion" }
};

// GET /peliculas — listar todas las peliculas
app.MapGet("/peliculas", () => Results.Ok(peliculas));

// GET /peliculas/{id} — obtener una pelicula por id
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

**Salida verificada:**

| Endpoint | Comando | Salida esperada |
| --- | --- | --- |
| `GET /peliculas` | `curl http://localhost:5000/peliculas` | Array JSON con 4 películas |
| `GET /peliculas/1` | `curl http://localhost:5000/peliculas/1` | `{"id":1,"titulo":"El Senor de los Anillos","anio":2001,"genero":"Fantasia"}` |
| `GET /peliculas/99` | `curl http://localhost:5000/peliculas/99` | `{"mensaje":"Pelicula no encontrada"}` (404) |
| `GET /peliculas/buscar?genero=Ciencia%20Ficcion` | `curl` | Inception e Interstellar |
| `GET /peliculas/buscar?anioMin=2000&anioMax=2015` | `curl` | El Senor de los Anillos, Inception, Interstellar |

## 2. Solución de la actividad de extensión

### Extensión: endpoint de detalle con resumen

Agregar un endpoint que devuelva un resumen de la película con el género en mayúsculas y el año entre paréntesis.

```csharp
// GET /peliculas/{id}/resumen — resumen formateado de una pelicula
app.MapGet("/peliculas/{id:long}/resumen", (long id) =>
{
    var pelicula = peliculas.FirstOrDefault(p => p.id == id);
    if (pelicula is null)
    {
        return Results.NotFound(new { mensaje = "Pelicula no encontrada" });
    }

    var resumen = $"{pelicula.titulo} ({pelicula.anio}) — {pelicula.genero.ToUpper()}";
    return Results.Ok(new { resumen });
});
```

**Salida esperada:**
- `GET /peliculas/1/resumen` → `{"resumen":"El Senor de los Anillos (2001) — FANTASIA"}`
- `GET /peliculas/99/resumen` → `{"mensaje":"Pelicula no encontrada"}` (404)

**Pista para el docente:** `ToUpper()` convierte un string a mayúsculas. Funciona sobre `string` y no sobre tipos anónimos.

## 3. Respuesta esperada del ejercicio

| Pregunta | Respuesta esperada |
| --- | --- |
| ¿Qué es un parámetro de ruta? | Un valor que forma parte de la URL del endpoint, definido entre llaves como `{id:long}`. |
| ¿Qué es un parámetro de query string? | Un valor que se pasa después del `?` en la URL como `?clave=valor`, y se declara como parámetro del método. |
| ¿Cómo se hace un parámetro de ruta opcional? | Se agrega `?` después del nombre del parámetro en la ruta: `{id:long?}`. |
| ¿Qué hace `Results.NotFound`? | Devuelve una respuesta HTTP 404 con el objeto proporcionado como cuerpo. |
| ¿Por qué se usa `StringComparison.OrdinalIgnoreCase`? | Para que la comparación de strings ignore mayúsculas y minúsculas, haciendo la búsqueda insensible a ese aspecto. |
| ¿Qué pasa si no se verifica `null` en un parámetro de query string opcional? | Se produce un error en tiempo de ejecución al intentar llamar un método sobre un valor `null`. |
| ¿Cuál es la diferencia entre `GET /peliculas/buscar?genero=Fantasia` y `GET /peliculas/buscar?anioMin=2000&anioMax=2015`? | Ambos usan el mismo endpoint `/peliculas/buscar` pero con diferentes parámetros de query string. El primero filtra por género, el segundo por rango de años. |

## 4. Criterios de corrección (lista de verificación)

- [ ] El alumno define el endpoint `GET /peliculas` que devuelve la lista completa.
- [ ] Define `GET /peliculas/{id:long}` que devuelve una película por ID.
- [ ] Maneja correctamente el caso en que el ID no existe con `Results.NotFound`.
- [ ] Define `GET /peliculas/buscar?genero=...` que filtra por género.
- [ ] Valida que el parámetro `genero` no sea nulo o vacío y devuelve 400 si lo es.
- [ ] Define `GET /peliculas/buscar?anioMin=...&anioMax=...` que filtra por rango de años.
- [ ] Valida que ambos parámetros de año estén presentes.
- [ ] El código compila sin errores.
- [ ] Los endpoints se prueban correctamente en el navegador o con `curl`.
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes.
- [ ] El grupo hizo commit y push al final del encuentro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `404` al visitar `/peliculas/1` | El enrutador no coincide porque falta `:long` en la definición de la ruta | Verificar que la ruta sea `/peliculas/{id:long}` y no `/peliculas/{id}` (sin tipo). |
| `Results.NotFound` no reconocido | Falta `using` o el método no está disponible en el scope | En Minimal API, `Results` está disponible sin `using` adicionales en .NET 6. Verificar que el proyecto sea `dotnet new web`. |
| El filtro por género no distingue mayúsculas/minúsculas | No usar `StringComparison.OrdinalIgnoreCase` en la comparación | Mostrar la diferencia entre `Equals(genero)` y `Equals(genero, StringComparison.OrdinalIgnoreCase)`. |
| Error al usar `FirstOrDefault` en un tipo anónimo | Los tipos anónimos no tienen un tipo explícito que el compilador pueda inferir en algunos contextos | Usar `Where(...).FirstOrDefault()` en lugar de `FirstOrDefault(...)` directamente sobre la colección, o declarar la lista con un tipo concreto. |
| Dos endpoints con la misma ruta `/peliculas/buscar` pero diferentes parámetros | El enrutador no puede distinguir entre ambos | Explicar que en Minimal API, los endpoints con la misma ruta pero diferentes parámetros de query string pueden coexistir si los parámetros son diferentes. Si hay conflicto, separar en rutas distintas. |
| `anioMin` y `anioMax` llegan como 0 en lugar de null | No declararlos como `int?` (nullable) | Los parámetros de query string opcionales deben ser tipos nullable (`int?`, `double?`, `string?`). |

## 6. Registro de la clase

| Grupo | Presentes | Endpoint / creado | Prueba de ruta exitosa | Prueba de query string exitosa | Manejo de errores (400/404) | Commit en GitHub | Observaciones |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | — | — | — | — | — | — | — |
| Grupo 2 | — | — | — | — | — | — | — |
| Grupo 3 | — | — | — | — | — | — | — |
| Grupo 4 | — | — | — | — | — | — | — |

**Notas para evaluación de proceso:**
- Verificar que cada grupo tenga al menos un commit en GitHub al final del encuentro.
- Observar si los grupos pueden construir endpoints con parámetros de ruta y query string sin ayuda.
- Registrar qué grupos lograron la extensión (resumen formateado) sin ayuda.
- Anotar errores frecuentes para abordarlos en el encuentro siguiente.
