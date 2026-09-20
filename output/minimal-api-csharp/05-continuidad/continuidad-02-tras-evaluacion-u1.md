# Continuidad pedagógica — Repaso tras evaluación de la Unidad 1

**Curso:** Minimal API con C# .NET 6
**Momento de uso:** Tras la evaluación de la Unidad 1 (encuentro 9)
**Duración teórica:** 240 minutos
**Requisitos:** Computadora con SDK .NET 6, VS Code o editor similar, terminal de comandos y conexión a Internet para crear proyectos y descargar paquetes.
**Contenido repasado:** Unidad 1 completa — fundamentos de C#, estructuras de control, Minimal API con endpoint GET, parámetros de ruta y *query string*.

---

## Objetivos

- Crear un proyecto web con `dotnet new web` y ejecutarlo con `dotnet run`.
- Declarar variables de tipos básicos (`int`, `long`, `double`, `string`, `bool`) y escribir estructuras de control (`if`, `for`, `while`).
- Definir endpoints `MapGet` que devuelvan datos en formato JSON.
- Extraer parámetros de la ruta (`{id:long}`) y de la *query string* (`?nombre=...`).
- Aplicar el alias `AS` en SQL y el uso correcto de `Results.Ok` y `Results.NotFound`.

---

## Actividades (100 puntos — 240 minutos)

### Actividad 1 — Repaso de C# básico (20 puntos — 50 minutos)

**Parte A (10 ptos.).** Escribí un programa de consola (sin Minimal API) que:

1. Declare una variable `string? nombre` y otra `int edad`.
2. Pida al usuario que ingrese su nombre y su edad (usá `Console.ReadLine()`).
3. Si la edad es mayor o igual a 18, muestre `"Hola {nombre}, sos mayor de edad"`. Si no, muestre `"Hola {nombre}, sos menor de edad"`.

Copiá el código completo en tu hoja.

**Parte B (10 ptos.).** Explicá, en tres líneas como máximo, qué significa `string?` (con el signo de pregunta) y en qué se diferencia de `string`.

| Criterio | Puntaje |
| --- | --- |
| Código correcto (variables, lectura, condición, escritura) | 10 ptos. |
| Explicación clara de `string?` (nullable) | 10 ptos. |

### Actividad 2 — Endpoint GET sin base de datos (20 puntos — 50 minutos)

Escribí el código de un proyecto Minimal API (archivo `Program.cs` completo) que:

- Exponga un endpoint `GET /saludo` que devuelva `Results.Ok(new { mensaje = "Hola desde Minimal API" })`.
- Exponga un endpoint `GET /saludo/{nombre:string}` que devuelva `Results.Ok(new { mensaje = $"Hola {nombre}" })`.

Incluí las directivas `using` necesarias y la estructura completa del archivo (`builder`, `app.Build()`, endpoints, `app.Run()`).

| Criterio | Puntaje |
| --- | --- |
| Estructura completa del archivo Program.cs | 6 ptos. |
| Endpoint `/saludo` correcto | 6 ptos. |
| Endpoint `/saludo/{nombre}` con string correcto | 8 ptos. |

### Actividad 3 — Parámetros de ruta y query string (20 puntos — 50 minutos)

Agregá al proyecto de la Actividad 2 un endpoint `GET /calcular` que acepte dos *query parameters* llamados `a` y `b` (ambos `long`) y devuelva:

```json
{ "a": 10, "b": 5, "suma": 15 }
```

El endpoint debe:
- Leer los parámetros desde la *query string* usando `HttpContext`.
- Validar que ambos estén presentes: si falta alguno, devolver `Results.BadRequest`.
- Devolver la suma y los valores originales.

| Criterio | Puntaje |
| --- | --- |
| Lectura correcta de query parameters desde `HttpContext` | 8 ptos. |
| Validación de parámetros faltantes con `Results.BadRequest` | 6 ptos. |
| Cálculo y respuesta JSON correctos | 6 ptos. |

### Actividad 4 — Errores comunes (20 puntos — 40 minutos)

Identificá y corregí los errores del siguiente código. Hay exactamente **tres errores** conceptuales (no de sintaxis menor):

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/patients/{id:int}", (int id) =>
{
    using var connection = new SqliteConnection("Data Source=hospital.db");
    var patient = connection.QueryFirstOrDefault<Patient>(
        "SELECT * FROM patients WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

app.Run();

record Patient(int patient_id, string first_name, string birth_date);
```

Para cada error:
- Escribí **cuál es**.
- Escribí **la línea corregida**.

| Criterio | Puntaje |
| --- | --- |
| Error 1 identificado y corregido | 7 ptos. |
| Error 2 identificado y corregido | 7 ptos. |
| Error 3 identificado y corregido | 6 ptos. |

### Actividad 5 — Bucle y lista en endpoint (20 puntos — 50 minutos)

Escribí un endpoint `GET /tabla/{numero:long}` que devuelva los primeros diez múltiplos del número ingresado, en este formato:

```json
{
  "numero": 7,
  "multiplos": [7, 14, 21, 28, 35, 42, 49, 56, 63, 70]
}
```

Usá un bucle `for` para generar la lista y `Results.Ok` para la respuesta.

| Criterio | Puntaje |
| --- | --- |
| Bucle `for` correcto (índice de 1 a 10, multiplicación) | 8 ptos. |
| Construcción de la lista de múltiplos | 6 ptos. |
| Respuesta con `Results.Ok` en el formato exacto | 6 ptos. |

---

## Autoevaluación para el alumno

| Afirmación | Lo logré | Lo logré parcialmente | No lo logré |
| --- | --- | --- | --- |
| Creo y ejecuto un proyecto `dotnet new web`. | ☐ | ☐ | ☐ |
| Escribo un `if` con variables de tipo `string` y `int`. | ☐ | ☐ | ☐ |
| Defino endpoints `MapGet` con y sin parámetros. | ☐ | ☐ | ☐ |
| Leo parámetros desde la *query string* y valido su presencia. | ☐ | ☐ | ☐ |
| Corrijo errores de tipos (usar `int` en vez de `long`, fecha como `string`, alias `AS`). | ☐ | ☐ | ☐ |
| Genero una lista con un bucle `for` dentro de un endpoint. | ☐ | ☐ | ☐ |

**Tiempo real que me llevó:** ________ minutos.

---

## Nota académica obligatoria

La resolución de estas actividades se realiza en forma habitual, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es **individual y manuscrita**, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.