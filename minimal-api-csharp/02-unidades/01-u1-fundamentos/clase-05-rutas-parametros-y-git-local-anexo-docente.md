# Anexo docente — Encuentro 5: Rutas, parámetros y git local

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente (Program.cs completo)

```csharp
// Program.cs - Encuentro 5: ejercicio independiente (solucion del docente)

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Endpoint guiado de la practica, se conserva como referencia
app.MapGet("/hello/{name}", (string name) =>
{
    return $"Hola, {name}! Esta respuesta salio de una ruta con parametro.";
});

app.MapGet("/patients/{id:long}", (long id) =>
{
    return new
    {
        patientId = id,
        firstName = "Ana",
        lastName = "Garcia",
        birthDate = "2001-03-14"
    };
});

app.MapGet("/doctors/{id:long}", (long id) =>
{
    long doctorId = id;
    string specialty = "Pediatria";

    return new { doctorId, specialty };
});

// ---- Endpoints del ejercicio independiente ----

// /appointments/{id:long}: turno de ejemplo, con fecha como string ISO
app.MapGet("/appointments/{id:long}", (long id) =>
{
    return new
    {
        appointmentId = id,
        doctorId = 2,           // dato de ejemplo fijo por ahora
        date = "2024-09-12"     // fechas: SIEMPRE string en ISO yyyy-MM-dd
    };
});

// /wards/{name}: texto armado con el parametro recibido
app.MapGet("/wards/{name}", (string name) =>
{
    return "Sala asignada: " + name;
});

app.Run();
```

### Git esperado del ejercicio

```text
git add .
git commit -m "u1-clase-05: ejercicio de rutas con parametros"
git log --oneline
```

Salida esperada de `git log --oneline`:

```text
b7c4d21 (HEAD -> main) u1-clase-05: ejercicio de rutas con parametros
3f2a1b9 u1-clase-05: rutas con parametros y json automatico
```

Verificación clave: `git status` antes del `add` muestra `Program.cs` modificado y ningún elemento de `bin/` ni `obj/`.

## 2. Solución de la actividad de extensión

1. **Ruta con dos parámetros** — el orden de los parámetros en la ruta define el orden de llegada: `app.MapGet("/full-name/{name}/{surname}", (string name, string surname) => $"Paciente: {name} {surname}");`
2. **Objeto anónimo ampliado** — mismas reglas (id `long`, fecha string ISO), con más propiedades: `gender = "F"` y `city = "Rosario"` se agregan al objeto del `/patients/{id:long}` guiado.
3. **Lectura del historial:** si un mensaje no se entiende sin abrir el código, el hábito a corregir es el mensaje, no el lector. Reescribir el criterio con el grupo: `u1-clase-05: lo que hice` no sirve; `u1-clase-05: ejercicio de rutas con parametros` sí.
4. **Simulacro de recuperación:** `dotnet run` desde la carpeta del proyecto reconstruye todo. Ningún estado del curso vive «dentro» de VS Code.

### Implementación de referencia de los ítems 1 y 2

```csharp
// Dos parametros en una ruta: se leen de izquierda a derecha
app.MapGet("/full-name/{name}/{surname}", (string name, string surname) =>
{
    return $"Paciente: {name} {surname}";
});

// Version ampliada del paciente: mas propiedades, mismas reglas de tipos
app.MapGet("/patients/{id:long}", (long id) =>
{
    return new
    {
        patientId = id,
        firstName = "Ana",
        lastName = "Garcia",
        gender = "F",
        birthDate = "2001-03-14",
        city = "Rosario"
    };
});
```

## 3. Respuesta esperada del ejercicio

| URL | Respuesta esperada |
| --- | --- |
| `http://localhost:5080/appointments/5` | `{"appointmentId":5,"doctorId":2,"date":"2024-09-12"}` |
| `http://localhost:5080/appointments/abc` | `HTTP ERROR 404` (el filtro `:long` no coincide) |
| `http://localhost:5080/wards/Cardiologia` | `Sala asignada: Cardiologia` |
| `git log --oneline` | Dos líneas: el commit guiado y el commit del ejercicio |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio |
| --- | --- |
| ☐ | `/appointments/{id:long}` existe con el filtro `:long` y el parámetro tipado `long id` |
| ☐ | El JSON del turno usa `appointmentId`, `doctorId` y `date`, con la fecha como string ISO |
| ☐ | `/wards/{name}` devuelve un texto que incluye el valor recibido |
| ☐ | El repositorio local quedó en la carpeta del proyecto (junto al `.csproj`) |
| ☐ | El `.gitignore` con `bin/` y `obj/` está en la raíz y `git status` no los lista |
| ☐ | Hay dos commits con mensajes referentes según la convención `u1-clase-05: ...` |
| ☐ | Al menos un integrante explica la diferencia entre `{name}` y `{id:long}` |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `git commit` falla pidiendo identidad | `user.name`/`user.email` sin configurar en esa PC | Acompañar los dos `git config --global`; explicar que la firma es por computadora, no por proyecto |
| `bin/` y `obj/` aparecen en `git status` | `.gitignore` inexistente o creado en otra carpeta | Verificar que esté junto al `.csproj`; si ya se versionaron, sacarlos del índice junto al docente antes del próximo commit |
| El repo quedó una carpeta arriba del proyecto | `git init` lanzado en el directorio equivocado | Aclarar con el grupo dónde tiene que vivir `.git`; rehacer el inicio en la carpeta correcta con acompañamiento |
| `/patients/abc` devuelve 404 y el grupo lo trata como error | Lectura del filtro como falla | Replantear: el filtro `:long` está protegiendo la ruta; probar con un número |
| JSON con propiedades `PatientId`/`FirstName` en PascalCase | Escribieron las propiedades con mayúscula | Mostrar que el JSON usa el nombre tal cual se escribió en el objeto anónimo; convención del curso: camelCase en los objetos anónimos |
| Commit con mensaje `"cambios"` | Mensaje escrito a las apuradas | Corregir en el momento y fijar la convención `u1-clase-NN: resumen` para el resto del año |

## 6. Registro de la clase

- Registrar por grupo: endpoints funcionando, estado del repositorio local y calidad de los mensajes de commit (insumo de la evaluación de proceso de la Unidad 1).
- Anotar qué PCs requirieron configuración de identidad: quedan listas para los encuentros siguientes.
