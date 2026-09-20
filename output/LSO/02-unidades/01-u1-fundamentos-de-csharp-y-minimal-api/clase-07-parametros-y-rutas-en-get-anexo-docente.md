# Anexo docente — Encuentro 7: Parámetros y rutas en GET

## Encuadre

Cuarto encuentro de la Unidad 1. Los estudiantes agregan parámetros de ruta y filtros por query string a la API que crearon en el encuentro anterior. Siguen sin usar base de datos: la lista de pacientes es fija en memoria. El ejercicio progresivo agrega búsqueda por ID y filtrado por género, que son las operaciones que luego ejecutarán contra la base de datos en la Unidad 2. El TP-U1 se presenta en el próximo encuentro, y este encuentro es el último entrenamiento antes de la entrega.

## Qué observar durante la clase

- Confusión entre parámetro de ruta (`/patients/{id:long}`) y query string (`?gender=M`): explicar que la ruta identifica un recurso (un paciente) y el query string filtra una colección.
- Olvido del signo `?` en `string? gender`: sin él, la ruta `/patients` sin query string no matchea y devuelve 404.
- Uso de `List<T>.Find` en lugar de `FirstOrDefault`: ambos funcionan, pero `FirstOrDefault` es el estándar Dapper que usarán después.
- Dificultad con la expresión lambda `p => p.PatientId == id`: explicar que `p` es cada elemento de la lista y la expresión elige cuál.

## Solución completa del ejercicio independiente

```csharp
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15"),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22"),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03")
};

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — lista completa o filtrada por genero
app.MapGet("/patients", (string? gender) =>
{
    if (gender is not null)
    {
        var filtered = patients.Where(p => p.Gender == gender).ToList();
        return Results.Ok(filtered);
    }
    return Results.Ok(patients);
});

// GET /patients/{id:long} — buscar un paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    var patient = patients.FirstOrDefault(p => p.PatientId == id);
    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

## Errores previsibles

1. **Ambos endpoints `/patients` en conflicto:** si declaran dos `MapGet("/patients", ...)` sin diferenciar por query string, el segundo reemplaza al primero. El query string no cambia la ruta, así que usan el mismo handler.
2. **Parámetro `gender` como `string` no nullable:** la ruta sin `?gender=...` devuelve 404 porque el framework no puede pasar `null` a un `string` no nullable.
3. **`Where` sin `ToList()`:** `Where` devuelve `IEnumerable`, que se serializa pero puede dar comportamientos diferidos inesperados. Convertir con `.ToList()`.
4. **Olvidar `new { mensaje = "..." }` en el `NotFound`:** devolver `Results.NotFound()` sin argumento da un cuerpo vacío (código 404 correcto pero sin mensaje).
5. **Ruta `/patients/{id}` sin constraint de tipo:** sin `:long`, el parámetro es `string` y la conversión a `long` falla.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Comprende la diferencia ruta/query pero no logra implementar ningún filtro. |
| 5 | Endpoint por ID funciona; filtro por género no compila o no responde. |
| 6 | Ambos filtros funcionan; el 404 no incluye mensaje. |
| 7 | Filtros correctos, 404 con mensaje, código sin errores. |
| 8 | Explica por qué `string?` es necesario para query opcional y cómo `FirstOrDefault` maneja la ausencia. |

## Agrupamiento

Individual. Cada estudiante modifica su proyecto del encuentro anterior. Si hay estudiantes muy avanzados, pueden agregar un filtro adicional por rango de edad como actividad complementaria.

## Ajustes para la siguiente edición

- Si la confusión entre ruta y query string persiste en más de la mitad del grupo, agregar un cuadro visual de comparación en la pizarra durante la apertura.
- Si el operador ternario `?:` en el endpoint por ID confunde, reemplazar por un `if` explícito en la práctica guiada y mostrar el ternario solo en el anexo.