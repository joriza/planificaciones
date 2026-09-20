# Anexo docente — Evaluación U1 Versión A (Pacientes en memoria)

## Solución completa

A continuación se muestra el `Program.cs` completo para la versión A, incluyendo el endpoint extra `GET /patients/summary`. Corresponde a 100 puntos si se entrega completo y con defensa satisfactoria.

```csharp
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15", "Cordoba", "AR-C", null, 165, 62),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22", "Rosario", "AR-E", "Penicilina", 178, 80),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03", null, "AR-B", null, 160, null),
    new Patient(4, "Carlos", "Perez", "M", "2000-01-10", "Mendoza", "AR-M", null, 182, 75),
    new Patient(5, "Sofia", "Diaz", "F", "1995-07-30", "La Plata", "AR-B", "Ibuprofeno", null, 68),
    new Patient(6, "Miguel", "Fernandez", "M", "1982-11-18", "Salta", "AR-A", null, 175, 90)
};

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — lista completa con filtro opcional por genero
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

// GET /patients/older-than?age=N — filtrar por edad
app.MapGet("/patients/older-than", (int age) =>
{
    var older = patients.Where(p =>
    {
        var birth = DateTime.Parse(p.BirthDate);
        int edad = DateTime.Today.Year - birth.Year;
        if (DateTime.Today < birth.AddYears(edad)) edad--;
        return edad > age;
    }).ToList();
    return Results.Ok(older);
});

// GET /patients/{id:long} — buscar por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    var patient = patients.FirstOrDefault(p => p.PatientId == id);
    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// ENDPOINT EXTRA: GET /patients/summary
app.MapGet("/patients/summary", () =>
{
    int femenino = patients.Count(p => p.Gender == "F");
    int masculino = patients.Count(p => p.Gender == "M");
    return Results.Ok(new { total = patients.Count, femenino, masculino });
});

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

## Criterios de corrección específicos

| ✔ | Criterio | Puntos | Notas para la corrección |
|---|---|---|---|
| ☐ | GET /patients sin filtro | 10 | Debe devolver la lista completa. |
| ☐ | GET /patients?gender=F/M | 10 | Filtro aplicado. Si `gender` es null, devuelve toda la lista. |
| ☐ | GET /patients/{id} con ID existente | 5 | Devuelve 200 con el paciente. |
| ☐ | GET /patients/{id} con ID inexistente | 5 | Devuelve 404 con `{ "mensaje": "Paciente no encontrado" }`. |
| ☐ | GET /patients/count | 5 | Devuelve `{ "total": 6 }`. |
| ☐ | GET /patients/older-than?age=30 | 10 | Filtra correctamente usando fecha de nacimiento. |
| ☐ | Endpoint extra (summary/por-nombre/sorted) | 10 | Debe cumplir la consigna elegida. |
| ☐ | IDs como `long` | 5 | Todos los IDs son `long`. |
| ☐ | Fechas como `string` | 5 | BirthDate es `string`. |
| ☐ | Nulables con `?` | 5 | `string?`, `long?` donde corresponde. |
| ☐ | Records después de `app.Run()` | 5 | No hay tipos antes del código ejecutable. |
| ☐ | `Results.*` en todas las respuestas | 5 | Ok, NotFound, etc. |
| ☐ | Carpeta `tp-u1/` | 5 | Proyecto dentro de `tp-u1/`. |
| ☐ | `.gitignore` con `bin/` y `obj/` | 5 | Archivo presente en la raíz del proyecto. |
| ☐ | Commit semántico | 5 | Mensaje en español sin tildes. |
| ☐ | Push exitoso en GitHub | 5 | El commit aparece en el remoto. |

## Errores frecuentes esperados

| Error | Consecuencia | Puntaje sugerido |
|---|---|---|
| ID como `int` en el record | No compila con Dapper en U2; en U1 compila pero descuenta puntos de calidad | Descontar 5 |
| Record antes de `app.Run()` | Error CS8803 | No compila; descontar 5 |
| Falta `.gitignore` | Se suben `bin/` y `obj/` | Descontar 5 |
| Sin filtro de género | El endpoint no responde al parámetro | Descontar 10 |
| Endpoint extra sin implementar | No se asignan los 10 puntos | Descontar 10 |

## Equivalencia con versión B

Ambas versiones (A: pacientes, B: doctores) usan la misma rúbrica de 100 puntos, los mismos tipos canónicos y los mismos 5 endpoints requeridos más 1 extra. La única diferencia es el dominio de datos y los nombres de campos (Gender/BirthDate vs. Gender/BirthDate, Speciality vs. ProvinceId). El docente debe asignar las versiones de forma alternada entre grupos contiguos para desalentar la copia directa, asegurando que ambas versiones tengan la misma cantidad de grupos.