# Encuentro 7: Parámetros y rutas en GET

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de C# y Minimal API |
| Encuentro | 7 de 8 |
| Duración | 240 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Agregar un parámetro de ruta `{id:long}` a un endpoint GET.
- Filtrar la lista de pacientes por ID y devolver 404 si no existe.
- Recibir parámetros opcionales por query string (`?gender=M`).
- Usar `QueryFirstOrDefault` con una lista en memoria con `FirstOrDefault`.

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |

## Charla rápida

En el encuentro anterior teníamos un restaurant con una ventanilla única: siempre daba la lista completa de pacientes. Pero si un médico quiere ver los datos de un solo paciente, necesita pasarle el número de historia clínica. Ese número viaja en la ruta misma: `/patients/2` es como decir "quiero el paciente número 2". Si ese número no existe, el restaurant responde "paciente no encontrado". También podemos pasar filtros opcionales después de un signo de pregunta: `/patients?gender=F` significa "solo los pacientes de género femenino".

## Teoría mínima

### Parámetro de ruta

Se escribe entre llaves con el tipo después de dos puntos:

```csharp
app.MapGet("/patients/{id:long}", (long id) =>
{
    // id contiene el valor de la URL, ej: /patients/2 -> id = 2
});
```

El tipo debe ser `long` (Int64) porque las claves primarias en la base de datos serán `long`. El constraint `:long` rechaza valores no numéricos.

### Filtrar con `FirstOrDefault`

Para buscar un elemento en una lista por una propiedad:

```csharp
var patient = patients.FirstOrDefault(p => p.PatientId == id);
```

Si no encuentra ninguno, devuelve `null`. Eso se verifica con:

```csharp
if (patient is null)
{
    return Results.NotFound(new { mensaje = "Paciente no encontrado" });
}
return Results.Ok(patient);
```

### Query string

Los parámetros opcionales se reciben como argumentos del lambda:

```csharp
app.MapGet("/patients", (string? gender) =>
{
    // gender es null si no se envio ?gender=...
});
```

## Práctica guiada: endpoint por ID

Partimos del proyecto `hospital-api` del encuentro anterior.

**Paso 1:** editar `Program.cs` para agregar el endpoint de paciente por ID:

```csharp
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15"),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22"),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03")
};

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — devolver la lista completa
app.MapGet("/patients", () =>
{
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

**Paso 2:** ejecutar y probar:

```bash
dotnet run
```

- `http://localhost:5000/patients/1` → devuelve el paciente 1.
- `http://localhost:5000/patients/99` → `{ "mensaje": "Paciente no encontrado" }` con código 404.

## Ejercicio independiente: filtrar por género

Agregar filtro opcional por género al endpoint `GET /patients` existente. Si se pasa `?gender=M`, devolver solo los pacientes con ese género. Si no se pasa, devolver la lista completa.

**Pista:** modificar la firma del `MapGet` existente a `(string? gender)`. Dentro del lambda, preguntar `if (gender is not null)` y filtrar con `patients.Where(p => p.Gender == gender).ToList()`; si es null, devolver la lista completa.

**Solución esperada:**

Reemplazar el `MapGet("/patients", ...)` existente por:

```csharp
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
```

Pruebas:
- `http://localhost:5000/patients?gender=F` → solo Ana y Elena.
- `http://localhost:5000/patients?gender=M` → solo Luis.
- `http://localhost:5000/patients` (sin query) → los tres.

### Qué te llevás

- Los parámetros de ruta (`/patients/{id:long}`) identifican un recurso específico.
- `FirstOrDefault` busca en la lista y `is null` verifica existencia.
- El query string permite filtros opcionales sin cambiar la ruta.

### Lo que viene

En el Encuentro 8 se cierra la Unidad 1: repaso general y entrega del TP-U1, una Minimal API con endpoints GET que integra todo lo aprendido.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Parámetro `int` en lugar de `long` | La ruta usa `{id:long}` pero el lambda recibe `int id`. | Usar `long id`. |
| Olvidar el `?` en `string? gender` | Sin el signo, el parámetro es obligatorio y la ruta no coincide sin query string. | Declarar `string?` para parámetros opcionales. |
| `FirstOrDefault` sin `using System.Linq` | `List<T>` necesita `using System.Linq;` para `FirstOrDefault` y `Where`. | El proyecto `dotnet new web` lo incluye implícitamente con top-level statements. |
| Error de ruta `/patients/{id:long}/` con barra al final | La barra final no coincide con el patrón. | No agregar barra al final de la ruta. |
| Comparación con `==` en lugar de `is null` | `== null` funciona igual, pero `is null` es más legible y seguro con tipos nullable. | Preferir `is null`. |