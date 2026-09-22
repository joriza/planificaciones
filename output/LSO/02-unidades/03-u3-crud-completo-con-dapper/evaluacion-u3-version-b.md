# Evaluación de la Unidad 3 — Encuentro 26 — Versión B

> Dominio de esta versión: patients/admissions de hospital.db (mismo dominio que U2). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u3.md`.

## Antes de empezar

- Conectar a `hospital.db` usando la cadena `"Data Source=hospital.db"`.
- Resolver la prueba en un único archivo `Program.cs`.
- Usar las convenciones del curso: tipos canónicos (`long` para INTEGER, `string` para TEXT), alias `AS` en todos los SELECT, consultas SIEMPRE parametrizadas con `new { id }`, respuestas con `Results.*`.
- No se permite concatenar datos al SQL.
- El esqueleto de `Program.cs` se provee a continuación; no se modifica la estructura base (usings, builder, app.Run()), solo se completan los endpoints y records.
- Al terminar, detener la aplicación con `Ctrl+C` y dejar el proyecto en estado limpio.

## Objetivos de la prueba

1. Implementar POST para crear una admission con `MapPost` y código 201.
2. Implementar PUT para actualizar una admission con `MapPut` y código 200.
3. Implementar DELETE para borrar una admission con `MapDelete` y código 204.
4. Validar la existencia del recurso antes de cada operación.
5. Implementar un endpoint con JOIN de 3 tablas.

## Material provisto — Esqueleto de `Program.cs`

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// TODO: definir los records Patient, Admission, AdmissionDetail (después de app.Run())
// TODO: implementar los endpoints POST, PUT, DELETE y el JOIN de 3 tablas

app.Run();

// Records posicionales (después de app.Run())
```

## Parte 1 — POST (INSERT) con MapPost (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Crear un record `Patient` con los campos: `PatientId` (long), `FirstName` (string), `LastName` (string), `City` (string). | 5 |
| 1.2 | Crear un record `Admission` con los campos: `PatientId` (long), `AdmissionDate` (string), `DischargeDate` (string?), `Diagnosis` (string?), `AttendingPatientId` (long). | 5 |
| 1.3 | Crear un record `AdmissionDetail` con los campos: `AdmissionDate` (string), `Diagnosis` (string?), `PatientName` (string), `DoctorName` (string). | 5 |
| 1.4 | Implementar `POST /admissions` que inserte una nueva admission en la tabla `admissions` y retorne `Results.Created` con el ID generado y el objeto `AdmissionDetail`. Validar que el patient existe antes de insertar; si no existe, retornar `Results.NotFound` con `new { mensaje = "Patient no encontrado" }`. | 10 |

## Parte 2 — PUT (UPDATE) con MapPut (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Implementar `PUT /admissions/{patientId:long}/{admissionDate:date}` que actualice el `diagnosis` de una admission existente. Retornar `Results.Ok` si se actualizó correctamente, `Results.NotFound` con `new { mensaje = "Ingreso no encontrado" }` si no existe. | 15 |
| 2.2 | Implementar `PUT /admissions/{patientId:long}/{admissionDate:date}/discharge` que establezca la `discharge_date` de una admission. Validar que la admission existe y que no tiene ya fecha de alta. | 10 |

## Parte 3 — DELETE con MapDelete (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Implementar `DELETE /admissions/{patientId:long}/{admissionDate:date}` que borre una admission. Retornar `Results.NoContent` si se borró correctamente, `Results.NotFound` con `new { mensaje = "Ingreso no encontrado" }` si no existe. | 20 |

## Parte 4 — JOIN de 3 tablas (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 4.1 | Implementar `GET /admissions/detail` que retorne una lista de `AdmissionDetail` con JOIN de `admissions` + `patients` + `doctors`. Usar alias `AS` para todos los campos. | 20 |

## Parte 5 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Puntos |
| --- | --- | --- |
| 5.1 | ¿Qué código HTTP se retorna al crear un recurso exitosamente y por qué? (Respuesta: 201 Created, porque se creó un nuevo recurso.) | 5 |
| 5.2 | ¿Qué pasa si se intenta borrar una admission que no existe? (Respuesta: Se retorna 404 Not Found con el mensaje "Ingreso no encontrado".) | 5 |

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| `POST /admissions` | Crear nueva admission | `201` con el AdmissionDetail creado y URL de ubicación |
| `POST /admissions` con patient inexistente | Patient no encontrado | `404` con `{ "mensaje": "Patient no encontrado" }` |
| `PUT /admissions/1/2024-01-15` | Actualizar diagnosis | `200` con la admission actualizada |
| `PUT /admissions/999/2024-01-15` | Ingreso inexistente | `404` con `{ "mensaje": "Ingreso no encontrado" }` |
| `DELETE /admissions/1/2024-01-15` | Borrar admission | `204` No Content |
| `DELETE /admissions/999/2024-01-15` | Ingreso inexistente | `404` con `{ "mensaje": "Ingreso no encontrado" }` |
| `GET /admissions/detail` | Lista con JOIN de 3 tablas | JSON con AdmissionDetail (AdmissionDate, Diagnosis, PatientName, DoctorName) |

## Al terminar

Dejar la aplicación detenida (`Ctrl+C`). No hacer commit ni push. El docente verificará la ejecución durante la defensa.