# Anexo docente — Evaluación U1 Versión B (Doctores en memoria)

## Solución completa

A continuación se muestra el `Program.cs` completo para la versión B, incluyendo el endpoint extra `GET /doctors/summary`. Corresponde a 100 puntos si se entrega completo y con defensa satisfactoria.

```csharp
var doctors = new List<Doctor>
{
    new Doctor(1, "Maria", "Gomez", "Cardiologia", "1165432100", "maria.gomez@hospital.com", "M", "1980-03-15"),
    new Doctor(2, "Pedro", "Ramirez", "Clinica Medica", null, "pedro.ramirez@hospital.com", "M", "1975-07-22"),
    new Doctor(3, "Laura", "Fernandez", "Pediatria", "1165112233", null, "F", "1988-11-10"),
    new Doctor(4, "Diego", "Torres", "Cardiologia", "1165778899", "diego.torres@hospital.com", "M", "1992-05-05"),
    new Doctor(5, "Valentina", "Acosta", "Neurologia", null, null, "F", "1985-09-18"),
    new Doctor(6, "Jorge", "Mendoza", "Clinica Medica", "1165432777", "jorge.mendoza@hospital.com", "M", "1979-12-01")
};

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — lista completa con filtro opcional por genero
app.MapGet("/doctors", (string? gender) =>
{
    if (gender is not null)
    {
        var filtered = doctors.Where(d => d.Gender == gender).ToList();
        return Results.Ok(filtered);
    }
    return Results.Ok(doctors);
});

// GET /doctors/count — total de doctores
app.MapGet("/doctors/count", () =>
{
    return Results.Ok(new { total = doctors.Count });
});

// GET /doctors/older-than?age=N — filtrar por edad
app.MapGet("/doctors/older-than", (int age) =>
{
    var older = doctors.Where(d =>
    {
        var birth = DateTime.Parse(d.BirthDate);
        int edad = DateTime.Today.Year - birth.Year;
        if (DateTime.Today < birth.AddYears(edad)) edad--;
        return edad > age;
    }).ToList();
    return Results.Ok(older);
});

// GET /doctors/{id:long} — buscar por ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    var doctor = doctors.FirstOrDefault(d => d.DoctorId == id);
    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
});

// ENDPOINT EXTRA: GET /doctors/summary
app.MapGet("/doctors/summary", () =>
{
    int femenino = doctors.Count(d => d.Gender == "F");
    int masculino = doctors.Count(d => d.Gender == "M");
    return Results.Ok(new { total = doctors.Count, femenino, masculino });
});

app.Run();

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty,
              string? Phone, string? Email, string Gender, string BirthDate);
```

## Criterios de corrección específicos

| ✔ | Criterio | Puntos | Notas para la corrección |
|---|---|---|---|
| ☐ | GET /doctors sin filtro | 10 | Debe devolver la lista completa. |
| ☐ | GET /doctors?gender=F/M | 10 | Filtro aplicado. Si `gender` es null, devuelve toda la lista. |
| ☐ | GET /doctors/{id} con ID existente | 5 | Devuelve 200 con el doctor. |
| ☐ | GET /doctors/{id} con ID inexistente | 5 | Devuelve 404 con `{ "mensaje": "Doctor no encontrado" }`. |
| ☐ | GET /doctors/count | 5 | Devuelve `{ "total": 6 }`. |
| ☐ | GET /doctors/older-than?age=30 | 10 | Filtra correctamente usando fecha de nacimiento. |
| ☐ | Endpoint extra (summary/por-especialidad/sorted) | 10 | Debe cumplir la consigna elegida. |
| ☐ | IDs como `long` | 5 | Todos los IDs son `long`. |
| ☐ | Fechas como `string` | 5 | BirthDate es `string`. |
| ☐ | Nulables con `?` | 5 | `string?` donde corresponde. |
| ☐ | Records después de `app.Run()` | 5 | No hay tipos antes del código ejecutable. |
| ☐ | `Results.*` en todas las respuestas | 5 | Ok, NotFound, etc. |
| ☐ | Carpeta `tp-u1/` | 5 | Proyecto dentro de `tp-u1/`. |
| ☐ | `.gitignore` con `bin/` y `obj/` | 5 | Archivo presente en la raíz del proyecto. |
| ☐ | Commit semántico | 5 | Mensaje en español sin tildes. |
| ☐ | Push exitoso en GitHub | 5 | El commit aparece en el remoto. |

## Errores frecuentes esperados

Idénticos a la versión A (ver anexo A para la lista completa). La equivalencia entre versiones A y B garantiza que ningún grupo tenga ventaja por el dominio de datos asignado.

## Equivalencia con versión A

| Aspecto | Versión A (Pacientes) | Versión B (Doctores) |
|---|---|---|
| Cantidad de endpoints requeridos | 4 | 4 |
| Endpoint extra | 1 a elección | 1 a elección |
| Tipos canónicos | `long`, `string`, `string?`, `long?` | `long`, `string`, `string?` |
| Filtro por género | `?gender=F/M` | `?gender=F/M` |
| Filtro por edad | `older-than?age=N` | `older-than?age=N` |
| Puntaje total | 100 | 100 |
| Dificultad técnica | Equivalente | Equivalente |