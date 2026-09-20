# Encuentro 6: Minimal API y endpoint GET

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de C# y Minimal API |
| Encuentro | 6 de 8 |
| Duración | 240 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Crear un proyecto web con `dotnet new web`.
- Explicar las partes de `Program.cs`: builder, endpoints y `app.Run()`.
- Escribir un endpoint `MapGet` que devuelva una lista de pacientes con `Results.Ok`.
- Probar el endpoint en el navegador.
- Declarar el record posicional al final del archivo después de `app.Run()`.

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |

## Charla rápida

Hasta ahora los datos viajaban de nuestro programa a la consola. Una API web es como un restaurant con ventanilla de take-away: el cliente (navegador) pide "dame la lista de pacientes" por la ventanilla (HTTP GET) y el chef (servidor) le pasa el plato (JSON) por la misma ventanilla. No hay pantalla ni consola: la comunicación es puramente electrónica. La Minimal API de .NET nos da las herramientas para montar esa ventanilla en muy pocas líneas.

## Teoría mínima

### Estructura de un proyecto web

Con `dotnet new web` obtenemos un `Program.cs` con esta estructura canónica:

1. `using` directivas (Dapper, Microsoft.Data.Sqlite — en Unidad 2)
2. `var builder = WebApplication.CreateBuilder(args);`
3. `var app = builder.Build();`
4. Endpoints: `app.MapGet(...)`, `app.MapPost(...)`, etc.
5. `app.Run();`
6. Records posicionales (al final, después de `app.Run()`)

### Endpoint GET básico

```csharp
app.MapGet("/patients", () =>
{
    return Results.Ok(patients);
});
```

- `MapGet` asocia la ruta `"/patients"` a una función que se ejecuta cuando el navegador visita esa URL.
- `Results.Ok(patients)` devuelve HTTP 200 con el contenido serializado como JSON.

### Tipos de respuesta HTTP (canónicos)

| Código | Cuándo se usa | Método |
|---|---|---|
| 200 | Lectura correcta | `Results.Ok(dato)` |
| 404 | Recurso no encontrado | `Results.NotFound(new { mensaje = "..." })` |

> **Regla:** siempre usar `Results.*`, nunca `TypedResults` ni devolver el objeto crudo.

## Práctica guiada: crear la API y devolver pacientes

Vamos a crear un proyecto web y devolver la misma lista de pacientes que usábamos en consola, ahora como JSON.

**Paso 1:** crear el proyecto web:

```bash
cd ..
dotnet new web -o hospital-api
cd hospital-api
```

**Paso 2:** reemplazar `Program.cs` con:

```csharp
// Lista fija de pacientes (sin BD)
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

app.Run();

// Record al final, DESPUES de app.Run()
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

**Paso 3:** ejecutar el proyecto:

```bash
dotnet run
```

**Paso 4:** abrir el navegador en `http://localhost:5000/patients` (o el puerto que indique la terminal). La respuesta debe ser JSON:

```json
[
  {
    "patientId": 1,
    "firstName": "Ana",
    "lastName": "Lopez",
    "gender": "F",
    "birthDate": "1990-05-15"
  },
  {
    "patientId": 2,
    "firstName": "Luis",
    "lastName": "Martinez",
    "gender": "M",
    "birthDate": "1985-08-22"
  },
  {
    "patientId": 3,
    "firstName": "Elena",
    "lastName": "Garcia",
    "gender": "F",
    "birthDate": "1978-12-03"
  }
]
```

Detener el servidor con `Ctrl+C`.

> **Nota:** las propiedades aparecen en camelCase (`patientId`) porque ASP.NET serializa con esa convención. No es necesario configurar nada adicional.

## Ejercicio independiente: agregar endpoint de conteo

Crear un segundo endpoint `GET /patients/count` que devuelva un objeto con la cantidad de pacientes.

**Pista:** declarar otro `app.MapGet` antes de `app.Run()`, con ruta `"/patients/count"`, y devolver `Results.Ok(new { total = patients.Count })`.

**Solución esperada:**

Agregar después del primer `MapGet`:

```csharp
// GET /patients/count — devolver la cantidad de pacientes
app.MapGet("/patients/count", () =>
{
    return Results.Ok(new { total = patients.Count });
});
```

Respuesta JSON esperada:

```json
{ "total": 3 }
```

## Cierre

**Qué te llevás:** una Minimal API expone datos a través de endpoints HTTP. `MapGet` asocia una ruta a una función. `Results.Ok` serializa como JSON con código 200. Los records van siempre después de `app.Run()`.

**Lo que viene:** en el próximo encuentro vamos a filtrar la lista: un endpoint que devuelva un solo paciente por ID y otro que filtre por género usando parámetros de ruta y query string.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| CRLF / compilación en otra carpeta | `dotnet run` sin estar dentro de la carpeta del proyecto. | Verificar que el terminal esté en `hospital-api/`. |
| Record antes de `app.Run()` | CS8803: las declaraciones de tipo no pueden ir antes de las top-level statements. | Mover el record al final del archivo. |
| Ruta sin barra inicial | `MapGet("patients", ...)` sin `/` no coincide con la URL. | Usar `"/patients"` con la barra. |
| Olvidar `Results.Ok` | Devolver `patients` directamente serializa el objeto, pero viola la convención del curso. | Envolver siempre con `Results.Ok()`. |
| Servidor no se detiene | `Ctrl+C` no funciona si la terminal no está enfocada. | Hacer clic en la terminal y luego `Ctrl+C`. |