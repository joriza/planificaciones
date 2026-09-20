# Anexo docente — Encuentro 8: Cierre U1 — repaso y TP

## Encuadre

Quinto y último encuentro de la Unidad 1. Los estudiantes integran todo lo aprendido en un trabajo práctico que deben entregar por GitHub. El TP-U1 es una Minimal API con endpoints GET que lista pacientes, los filtra por ID, género y edad, y devuelve conteos. Es el primer hito evaluable de la cursada. A partir de acá comienza el control de versiones formal con commits por encuentro.

La modalidad es "actitudinal": se evalúa la entrega completa y la correcta publicación en GitHub, no solo el código.

## Qué observar durante la clase

- Dificultad para organizar la carpeta `tp-u1/` dentro del repositorio grupal (no confundir con el proyecto `hospital-api` de los encuentros anteriores).
- Errores de sintaxis que ya habían aparecido en encuentros anteriores: record antes de `app.Run()`, falta de `Results.Ok`, ID como `int`.
- Duda sobre el mensaje del commit: algunos escriben "Entrega TP" con mayúscula o tildes, o no usan el prefijo de carpeta.
- Confusión sobre cómo publicar: `git push` sin haber hecho `git add`/`git commit` primero, o push sin remote configurado.

## Solución completa del TP-U1 (ejercicio independiente)

El `Program.cs` completo con el endpoint adicional `older-than`:

```csharp
// Lista de pacientes (personalizada por el grupo)
var patients = new List<Patient>
{
    new Patient(1, "Maria", "Gomez", "F", "1988-03-21"),
    new Patient(2, "Pedro", "Ramirez", "M", "1992-11-14"),
    new Patient(3, "Laura", "Fernandez", "F", "1975-06-07"),
    new Patient(4, "Diego", "Torres", "M", "2001-09-30"),
    new Patient(5, "Valentina", "Acosta", "F", "1999-02-18")
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

// GET /patients/older-than?age=30 — filtrar por edad minima
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

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

## Errores previsibles

1. **`git remote -v` no configurado:** el grupo creó el repo local pero no vinculó el remoto de GitHub. Verificar con `git remote -v` antes del push.
2. **Conflictos de merge:** si dos integrantes del grupo hicieron commit por separado sin pull, el push falla. En Unidad 1 se trabaja en rama `main` sin ramas, así que el primer push suele ser limpio.
3. **Carpeta `tp-u1` en la raíz del repositorio vs. dentro de una subcarpeta:** aclarar que el repo tiene `tp-u1/`, `tp-u2/`, etc. en la raíz. No crear una subcarpeta adicional.
4. **Olvidar el `.gitignore`:** el `bin/` y `obj/` se suben al repositorio, ocupando espacio innecesario.
5. **Parámetro `age` como `int` sin constraint de ruta:** en `older-than`, el parámetro `age` viene por query string y es `int` (no `long`), porque representa una edad, no una clave primaria. Esto es correcto y consistente con el canon.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Entrega un proyecto que compila pero no cumple todos los endpoints. Sin commit ni push. |
| 5 | Compila, tiene al menos 3 endpoints funcionales; no sube a GitHub. |
| 6 | Todos los endpoints funcionan, el record está al final, hay `.gitignore`. Sube a GitHub sin mensaje de commit correcto. |
| 7 | Entrega completa: 5 endpoints, record al final, `.gitignore`, commit con mensaje correcto, push exitoso. |
| 8 | Todo lo del 7 más: código con comentarios explicativos, nombres de pacientes variados, un endpoint extra (ej. ordenado por nombre). |

## Agrupamiento

Grupal (2-3 integrantes). Cada grupo entrega un solo repositorio con un solo `tp-u1/`. Los integrantes pueden trabajar en una sola máquina o en equipo mediante compartir pantalla. A partir de la Unidad 4 se introducirán ramas por integrante.

## Ajustes para la siguiente edición

- Si más del 40% de los grupos no logra completar el push en clase, dedicar los primeros 15 minutos de la Unidad 2 a resolver la conexión con GitHub.
- Si el endpoint `older-than` resulta demasiado complejo para el cierre de U1, reemplazarlo por `GET /patients/summary` que devuelva solo `{ total, femenino, masculino }`.