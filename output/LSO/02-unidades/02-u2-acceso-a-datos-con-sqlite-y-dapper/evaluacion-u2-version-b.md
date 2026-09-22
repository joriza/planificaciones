# Evaluación de la Unidad 2 — Encuentro 15 — Versión B

> Dominio de esta versión: patients/admissions (patients y admissions de hospital.db). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u2.md`.

## Antes de empezar

- Conectar a `hospital.db` usando la cadena `"Data Source=hospital.db"`.
- Resolver la prueba en un único archivo `Program.cs`.
- Usar las convenciones del curso: tipos canónicos (`long` para INTEGER, `string` para TEXT), alias `AS` en todos los SELECT, consultas SIEMPRE parametrizadas con `new { id }`, respuestas con `Results.*`.
- No se permite concatenar datos al SQL.
- El esqueleto de `Program.cs` se provee a continuación; no se modifica la estructura base (usings, builder, app.Run()), solo se completan los endpoints y records.
- Al terminar, detener la aplicación con `Ctrl+C` y dejar el proyecto en estado limpio.

## Objetivos de la prueba

1. Consultar pacientes con Dapper usando `Query<Patient>`.
2. Consultar admissions con JOIN a patients usando alias `AS`.
3. Filtrar admissions por patient con parámetro parametrizado.
4. Contar admissions por patient con `ExecuteScalar<long>`.
5. Buscar pacientes por ciudad con `LIKE`.

## Material provisto — Esqueleto de `Program.cs`

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// TODO: definir los records Patient y Admission (después de app.Run())
// TODO: implementar los endpoints GET

app.Run();

// Records posicionales (después de app.Run())
```

## Parte 1 — Consultas a patients (40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Crear un record `Patient` con los campos: `PatientId` (long), `FirstName` (string), `LastName` (string), `City` (string). | 10 |
| 1.2 | Implementar `GET /patients` que retorne la lista completa de pacientes con `Results.Ok`. | 15 |
| 1.3 | Implementar `GET /patients/{patientId:long}` que retorne el patient con ese ID o `Results.NotFound` con `new { mensaje = "Patient no encontrado" }` si no existe. | 15 |

## Parte 2 — Consultas con JOIN a admissions (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Crear un record `Admission` con los campos: `PatientId` (long), `AdmissionDate` (string), `DischargeDate` (string?), `Diagnosis` (string?), `AttendingPatientId` (long). | 10 |
| 2.2 | Implementar `GET /admissions` que retorne todas las admissions con sus datos, usando alias `AS` en el SELECT. | 15 |
| 2.3 | Implementar `GET /admissions?patientId={patientId:long}` que retorne solo las admissions del patient indicado, parametrizando la consulta con `new { patientId }`. | 15 |

## Parte 3 — Conteo y búsqueda (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Implementar `GET /patients/count` que retorne el total de pacientes usando `ExecuteScalar<long>`. | 10 |
| 3.2 | Implementar `GET /patients?city={city}` que busque pacientes por ciudad usando `LIKE` con parámetro. | 10 |

## Parte 4 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Puntos |
| --- | --- | --- |
| 4.1 | ¿Por qué se usa `long` y no `int` para `PatientId`? (Respuesta: Dapper exige `Int64` para columnas INTEGER de SQLite; `int` produce `InvalidOperationException`.) | 5 |
| 4.2 | ¿Qué error aparece si se omite el alias `AS` en un SELECT que usa snake_case? (Respuesta: Dapper busca constructor con parámetros snake_case, pero el record usa PascalCase; falla la materialización.) | 5 |

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `GET /patients` | Lista completa de pacientes | JSON con 27 objetos Patient, cada uno con PatientId, FirstName, LastName, City |
| `GET /patients/1` | Patient con ID 1 | JSON del patient con PatientId=1 |
| `GET /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions (306+ registros) |
| `GET /admissions?patientId=1` | Admissions del patient 1 | JSON con las admissions donde attending_patient_id=1 |
| `GET /patients/count` | Conteo de pacientes | JSON con el número entero (27) |
| `GET /patients?city=Cardiologist` | Pacientes de la ciudad Cardiologist | JSON con los pacientes cuya city contenga "Cardiologist" |

## Al terminar

Dejar la aplicación detenida (`Ctrl+C`). No hacer commit ni push. El docente verificará la ejecución durante la defensa.