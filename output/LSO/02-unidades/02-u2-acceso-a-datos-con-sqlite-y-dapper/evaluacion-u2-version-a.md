# Evaluación de la Unidad 2 — Encuentro 15 — Versión A

> Dominio de esta versión: doctors/admissions (doctors y admissions de hospital.db). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u2.md`.

## Antes de empezar

- Conectar a `hospital.db` usando la cadena `"Data Source=hospital.db"`.
- Resolver la prueba en un único archivo `Program.cs`.
- Usar las convenciones del curso: tipos canónicos (`long` para INTEGER, `string` para TEXT), alias `AS` en todos los SELECT, consultas SIEMPRE parametrizadas con `new { id }`, respuestas con `Results.*`.
- No se permite concatenar datos al SQL.
- El esqueleto de `Program.cs` se provee a continuación; no se modifica la estructura base (usings, builder, app.Run()), solo se completan los endpoints y records.
- Al terminar, detener la aplicación con `Ctrl+C` y dejar el proyecto en estado limpio.

## Objetivos de la prueba

1. Consultar doctores con Dapper usando `Query<Doctor>`.
2. Consultar admissions con JOIN a doctors usando alias `AS`.
3. Filtrar admissions por doctor con parámetro parametrizado.
4. Contar admissions por doctor con `ExecuteScalar<long>`.
5. Buscar doctores por especialidad con `LIKE`.

## Material provisto — Esqueleto de `Program.cs`

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// TODO: definir los records Doctor y Admission (después de app.Run())
// TODO: implementar los endpoints GET

app.Run();

// Records posicionales (después de app.Run())
```

## Parte 1 — Consultas a doctors (40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Crear un record `Doctor` con los campos: `DoctorId` (long), `FirstName` (string), `LastName` (string), `Specialty` (string). | 10 |
| 1.2 | Implementar `GET /doctors` que retorne la lista completa de doctores con `Results.Ok`. | 15 |
| 1.3 | Implementar `GET /doctors/{doctorId:long}` que retorne el doctor con ese ID o `Results.NotFound` con `new { mensaje = "Doctor no encontrado" }` si no existe. | 15 |

## Parte 2 — Consultas con JOIN a admissions (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Crear un record `Admission` con los campos: `PatientId` (long), `AdmissionDate` (string), `DischargeDate` (string?), `Diagnosis` (string?), `AttendingDoctorId` (long). | 10 |
| 2.2 | Implementar `GET /admissions` que retorne todas las admissions con sus datos, usando alias `AS` en el SELECT. | 15 |
| 2.3 | Implementar `GET /admissions?doctorId={doctorId:long}` que retorne solo las admissions del doctor indicado, parametrizando la consulta con `new { doctorId }`. | 15 |

## Parte 3 — Conteo y búsqueda (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Implementar `GET /doctors/count` que retorne el total de doctores usando `ExecuteScalar<long>`. | 10 |
| 3.2 | Implementar `GET /doctors?specialty={specialty}` que busque doctores por especialidad usando `LIKE` con parámetro. | 10 |

## Parte 4 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Puntos |
| --- | --- | --- |
| 4.1 | ¿Por qué se usa `long` y no `int` para `DoctorId`? (Respuesta: Dapper exige `Int64` para columnas INTEGER de SQLite; `int` produce `InvalidOperationException`.) | 5 |
| 4.2 | ¿Qué error aparece si se omite el alias `AS` en un SELECT que usa snake_case? (Respuesta: Dapper busca constructor con parámetros snake_case, pero el record usa PascalCase; falla la materialización.) | 5 |

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `GET /doctors` | Lista completa de doctores | JSON con 27 objetos Doctor, cada uno con DoctorId, FirstName, LastName, Specialty |
| `GET /doctors/1` | Doctor con ID 1 | JSON del doctor con DoctorId=1 |
| `GET /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions (306+ registros) |
| `GET /admissions?doctorId=1` | Admissions del doctor 1 | JSON con las admissions donde attending_doctor_id=1 |
| `GET /doctors/count` | Conteo de doctores | JSON con el número entero (27) |
| `GET /doctors?specialty=Cardiologist` | Doctores cardiólogos | JSON con los doctores cuya specialty contenga "Cardiologist" |

## Al terminar

Dejar la aplicación detenida (`Ctrl+C`). No hacer commit ni push. El docente verificará la ejecución durante la defensa.