# Continuidad pedagógica — Anexo docente: Repaso tras evaluación de la Unidad 1

> Documento exclusivo para el docente. Soluciones y criterios de corrección.
> No se entrega a los alumnos ni a la administración.

---

## Soluciones

### Actividad 1 — Repaso de C# básico (20 ptos.)

**Parte A (10 ptos.) — Código esperado:**

```csharp
Console.Write("Ingresá tu nombre: ");
string? nombre = Console.ReadLine();
Console.Write("Ingresá tu edad: ");
int edad = int.Parse(Console.ReadLine()!);

if (edad >= 18)
    Console.WriteLine($"Hola {nombre}, sos mayor de edad");
else
    Console.WriteLine($"Hola {nombre}, sos menor de edad");
```

Se acepta `int.TryParse` en lugar de `int.Parse`, y `Convert.ToInt32`. El `!` en `ReadLine()!` es admisible pero no obligatorio.

- Variables correctas (3 ptos.): al menos `string?` (o `string`) y `int`.
- Lectura con `Console.ReadLine` (3 ptos.).
- Condición `if` correcta (4 ptos.): `edad >= 18` y ambos mensajes.

**Parte B (10 ptos.) — Explicación esperada:**
> `string?` declara una cadena que puede ser `null`. `string` sin el signo no acepta `null` de forma explícita (es *non-nullable*). El signo `?` indica que el tipo es anulable, lo cual es necesario porque `Console.ReadLine()` puede devolver `null`.

- Explica el concepto de *nullable* (5 ptos.).
- Menciona que `ReadLine()` puede devolver `null` (5 ptos.).

### Actividad 2 — Endpoint GET sin base de datos (20 ptos.)

**Código esperado:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/saludo", () =>
    Results.Ok(new { mensaje = "Hola desde Minimal API" }));

app.MapGet("/saludo/{nombre:string}", (string nombre) =>
    Results.Ok(new { mensaje = $"Hola {nombre}" }));

app.Run();
```

- Estructura completa (6 ptos.): `using`, `builder`, `app.Build()`, `app.Run()`. Sin `using` Dapper/Sqlite se descuenta 2 ptos.; sin `app.Run()` se descuenta 4 ptos.
- Endpoint `/saludo` (6 ptos.): debe devolver `Results.Ok` con un objeto anónimo que tenga la propiedad `mensaje`.
- Endpoint `/saludo/{nombre}` (8 ptos.): debe tener el parámetro en la ruta con `{nombre:string}`, debe recibirlo como `string nombre` en el lambda y debe interpolarlo. Si usa concatenación con `+` también es válido.

### Actividad 3 — Parámetros de ruta y query string (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/calcular", (HttpContext context) =>
{
    if (!context.Request.Query.ContainsKey("a") || !context.Request.Query.ContainsKey("b"))
        return Results.BadRequest(new { mensaje = "Faltan parámetros a y/o b" });

    long a = long.Parse(context.Request.Query["a"]!);
    long b = long.Parse(context.Request.Query["b"]!);
    return Results.Ok(new { a, b, suma = a + b });
});
```

Se acepta `HttpRequest` en lugar de `HttpContext`, y `TryGetValue` en lugar de `ContainsKey`.

- Lectura de query params (8 ptos.): debe usar `context.Request.Query` y parsear a `long`. Usar `int` es error grave (penaliza 4 ptos. por incumplir las convenciones del curso).
- Validación con `ContainsKey` o `TryGetValue` (6 ptos.): debe devolver `Results.BadRequest`. Si falta, 0 ptos.
- Respuesta JSON (6 ptos.): debe incluir `a`, `b` y `suma` en el objeto anónimo.

### Actividad 4 — Errores comunes (20 ptos.)

**Error 1 (7 ptos.):** El tipo del parámetro de ruta y del constructor del record usan `int` en lugar de `long`.

- Línea del endpoint: `(int id)` → debe ser `(long id)`.
- Línea del record: `int patient_id` → debe ser `long patient_id`.

**Si el alumno solo marca uno de los dos, corresponde medio puntaje (3 ptos.).**

**Error 2 (7 ptos.):** El SELECT usa `SELECT *` sin alias `AS`. Dapper busca en el constructor parámetros con nombres que coincidan con las columnas (`patient_id` en snake_case), pero el record usa PascalCase (`PatientId`). Debe ser:

```sql
SELECT patient_id AS PatientId, first_name AS FirstName, birth_date AS BirthDate FROM patients WHERE patient_id = @id
```

**O bien** cambiar el record a snake_case, lo que viola la convención del curso. Se acepta solo si el alumno también justifica que no es lo recomendado (se descuentan 2 ptos. si no lo justifica).

**Error 3 (6 ptos.):** El campo `birth_date` es TEXT en SQLite pero el record lo declara como `string` (correcto en tipo, pero el nombre está en snake_case en el constructor). Si usa el constructor posicional `Patient(int patient_id, string first_name, string birth_date)`, Dapper busca una columna con alias `birth_date` (snake_case). Como no hay alias, falla.

Corrección: usar `string BirthDate` en el constructor y alias `birth_date AS BirthDate` en el SELECT.

**Código corregido completo:**

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection("Data Source=hospital.db");
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               birth_date AS BirthDate
        FROM patients
        WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

app.Run();

record Patient(long PatientId, string FirstName, string BirthDate);
```

### Actividad 5 — Bucle y lista en endpoint (20 ptos.)

**Código esperado:**

```csharp
app.MapGet("/tabla/{numero:long}", (long numero) =>
{
    var multiplos = new List<long>();
    for (int i = 1; i <= 10; i++)
        multiplos.Add(numero * i);

    return Results.Ok(new { numero, multiplos });
});
```

- Bucle `for` (8 ptos.): debe iterar de 1 a 10 (no de 0 a 9, aunque `{0, 10, 20...}` sería válido si el alumno lo aclara). Se descuentan 2 ptos. si la multiplicación está al revés.
- Construcción de lista (6 ptos.): debe declarar `new List<long>()` o `new long[10]`. Usar `var` es aceptable. Usar `ArrayList` del viejo `System.Collections` es válido pero se descuenta 2 ptos. por mala práctica.
- Respuesta (6 ptos.): debe incluir `numero` y `multiplos` en el objeto anónimo. Si devuelve solo la lista sin `numero`, descuento 3 ptos.

---

## Criterios generales de corrección

- **Puntaje total:** 100 puntos.
- **Presentación:** se descuenta hasta 5 ptos. si la presentación no es manuscrita. Código manuscrito debe ser legible; si no se entiende una porción, se descuenta el puntaje de ese ítem.
- **Aprobación del repaso:** 60 ptos. o más.
- **Uso de computadora:** el alumno debe describir que probó el código. Si solo copia de memoria sin evidencia de ejecución (ni siquiera una anotación de la salida), se descuenta 1 pto. por actividad no verificada.
- **Grupo:** se permite trabajo grupal, pero la entreja es individual. Dos textos idénticos se verifican con defensa oral breve.