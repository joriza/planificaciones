# Encuentro 8: Cierre U1 — repaso y TP

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de C# y Minimal API |
| Encuentro | 8 de 8 |
| Duración | 240 minutos |
| Carácter | Actitudinal |

## Objetivos de aprendizaje

- Integrar todos los conceptos de la Unidad 1 en una API funcional.
- Implementar el TP-U1: Minimal API con endpoints GET.
- Publicar el trabajo en GitHub siguiendo la rutina de cierre.
- Revisar los errores más frecuentes del código propio y ajeno.

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |

## Charla rápida

Hasta acá aprendimos a escribir código C#, a envolverlo en métodos, a decidir con `if`, a repetir con `foreach`, y a exponer datos por HTTP con una Minimal API. Todo ese conocimiento se integra en un solo trabajo práctico: el TP-U1. Piensen en el TP como el "examen de cocina" donde tienen que preparar el plato completo sin ayuda. La receta la conocen: es la misma progresión que hicimos desde el Encuentro 4 hasta hoy. Lo nuevo es que al terminar lo suben a GitHub, y a partir de ahora cada entrega va a tener su propio espacio en el repositorio del grupo.

## Repaso integrador

### Estructura canónica de `Program.cs`

```
1. Datos (lista de pacientes literal)
2. var builder = WebApplication.CreateBuilder(args);
3. var app = builder.Build();
4. Endpoints GET (listar, buscar por ID, filtrar)
5. app.Run();
6. Records posicionales AL FINAL
```

### Checklist de lo que debe tener el TP-U1

- [ ] Proyecto creado con `dotnet new web`.
- [ ] Carpeta `tp-u1/` dentro del repositorio grupal.
- [ ] Archivo `Program.cs` con top-level statements.
- [ ] Lista de pacientes en memoria (literal, sin base de datos).
- [ ] Endpoint `GET /patients` que devuelva la lista completa.
- [ ] Endpoint `GET /patients/{id:long}` que devuelva un paciente o 404.
- [ ] Endpoint `GET /patients/count` que devuelva el total.
- [ ] Filtro opcional `?gender=X` en `GET /patients`.
- [ ] `Results.Ok`, `Results.NotFound` con `new { mensaje = "..." }`.
- [ ] Record al final del archivo después de `app.Run()`.
- [ ] `.gitignore` con `bin/` y `obj/`.
- [ ] Commit y push al final.

## Práctica guiada: armado del TP

Vamos a construir juntos el esqueleto del TP-U1. Cada grupo parte de esta base y la completa con sus propios datos.

**Paso 1:** crear la carpeta del TP dentro del repositorio grupal:

```bash
mkdir -p tp-u1
cd tp-u1
dotnet new web
```

**Paso 2:** reemplazar `Program.cs` con la estructura completa:

```csharp
// Lista de pacientes del grupo (completar con 5 pacientes propios)
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15"),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22"),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03"),
    new Patient(4, "Carlos", "Perez", "M", "2000-01-10"),
    new Patient(5, "Sofia", "Diaz", "F", "1995-07-30")
};

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — lista completa (con filtro opcional por genero)
app.MapGet("/patients", (string? gender) =>
{
    if (gender is not null)
    {
        var filtered = patients.Where(p => p.Gender == gender).ToList();
        return Results.Ok(filtered);
    }
    return Results.Ok(patients);
});

// GET /patients/count — total de pacientes
app.MapGet("/patients/count", () =>
{
    return Results.Ok(new { total = patients.Count });
});

// GET /patients/{id:long} — buscar por ID
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

**Paso 3:** probar los cuatro endpoints.

**Paso 4:** crear el `.gitignore` en `tp-u1/`:

```bash
echo "bin/" > .gitignore
echo "obj/" >> .gitignore
```

## Ejercicio independiente: personalizar y entregar

1. Cambiar los pacientes de la lista por datos inventados por el grupo (mínimo 5 pacientes, con al menos 2 de cada género).
2. Agregar un endpoint adicional `GET /patients/older-than?age=30` que devuelva los pacientes mayores de una edad dada.

**Pista:** filtrar con `Where` y calcular la edad con `DateTime.Parse` y la misma lógica del Encuentro 5:

```csharp
var older = patients.Where(p =>
{
    var birth = DateTime.Parse(p.BirthDate);
    int edad = DateTime.Today.Year - birth.Year;
    if (DateTime.Today < birth.AddYears(edad)) edad--;
    return edad > age;
}).ToList();
```

## Rutina de cierre (git)

Al finalizar, subir el trabajo al repositorio grupal:

```bash
git add .
git commit -m "tp-u1: minimal api get con filtros y endpoint por id"
git push
```

> **Importante:** un commit por encuentro. El mensaje va en español, sin tildes, después de los dos puntos.

### Qué te llevás

- .NET ejecuta código C# compilado.
- `string` para texto, `long` para números enteros.
- Métodos, `if`, `foreach` y records posicionales.
- Una Minimal API expone datos por HTTP con `MapGet`.
- Los parámetros de ruta y query string permiten filtrar.

### Lo que viene

En el Encuentro 9, evaluación de la Unidad 1: defensa oral y prueba A/B. Después, en la Unidad 2, la API se conecta a una base de datos SQLite real (`hospital.db`): consultas SELECT con JOIN y resultados mapeados con Dapper y records posicionales. Los datos dejan de ser literales en el código.

## Errores comunes y trampas (repaso general)

| Error | Causa | Solución |
|---|---|---|
| Record antes de `app.Run()` | CS8803: declaraciones de tipo antes que el código ejecutable. | Mover el record al final. |
| ID como `int` en el record | Dapper espera `Int64`; inconsistencia con la BD futura. | Usar `long PatientId`. |
| Fecha como `DateTime` en el record | Dapper recibe `string` de SQLite; el constructor no coincide. | Usar `string BirthDate`. |
| Olvidar `Results.*` | Devolver el objeto crudo serializa, pero viola la convención. | Envolver con `Results.Ok()`, `Results.NotFound()`, etc. |
| Ruta sin barra inicial | `MapGet("patients", ...)` sin `/` no matchea. | Usar `"/patients"`. |
| Query string sin `string?` | El parámetro nullable sin `?` es obligatorio y la ruta falla. | Declarar `string? gender`. |
| `SELECT` sin alias `AS` | Para la Unidad 2: sin `AS PatientId` el mapeo con Dapper falla. | Usar `SELECT patient_id AS PatientId`. |