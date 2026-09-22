# Anexo docente — Evaluación del momento 34-35 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Data.SQLite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// --- U3: CRUD completo sobre hospital.db ---
var connectionString = "Data Source=hospital.db";

app.MapPost("/doctors", async (DoctorInput input, SQLiteConnection db) =>
{
    if (string.IsNullOrWhiteSpace(input.firstName) || string.IsNullOrWhiteSpace(input.lastName))
        return Results.BadRequest(new { mensaje = "firstName y lastName son obligatorios" });

    var id = await db.ExecuteScalarAsync<long>(
        "INSERT INTO doctors (firstName, lastName, specialty) VALUES (@firstName, @lastName, @specialty)",
        input);
    var doctor = await db.QueryFirstOrDefaultAsync<Doctor>("SELECT * FROM doctors WHERE doctorId = @doctorId", new { doctorId = id });
    return Results.Created($"/doctors/{id}", doctor);
});

app.MapPut("/doctors/{doctorId:long}", async (long doctorId, DoctorInput input, SQLiteConnection db) =>
{
    var existing = await db.QueryFirstOrDefaultAsync<Doctor>("SELECT * FROM doctors WHERE doctorId = @doctorId", new { doctorId });
    if (existing is null)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    await db.ExecuteAsync(
        "UPDATE doctors SET firstName = @firstName, lastName = @lastName, specialty = @specialty WHERE doctorId = @doctorId",
        new { input.firstName, input.lastName, input.specialty, doctorId });
    var updated = await db.QueryFirstOrDefaultAsync<Doctor>("SELECT * FROM doctors WHERE doctorId = @doctorId", new { doctorId });
    return Results.Ok(updated);
});

app.MapDelete("/doctors/{doctorId:long}", async (long doctorId, SQLiteConnection db) =>
{
    var existing = await db.QueryFirstOrDefaultAsync<Doctor>("SELECT * FROM doctors WHERE doctorId = @doctorId", new { doctorId });
    if (existing is null)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    var admissionCount = await db.ExecuteScalarAsync<long>(
        "SELECT COUNT(*) FROM admissions WHERE doctor_id = @doctorId", new { doctorId });
    if (admissionCount > 0)
        return Results.BadRequest(new { mensaje = "No se puede eliminar un doctor con admissions asociadas" });

    await db.ExecuteAsync("DELETE FROM doctors WHERE doctorId = @doctorId", new { doctorId });
    return Results.NoContent();
});

// Models
record DoctorInput(string firstName, string lastName, string? specialty);
record Doctor(long doctorId, string firstName, string lastName, string? specialty);

app.Run();
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| `POST /doctors` con body válido | Nuevo doctor creado | `201` con el doctor creado incluyendo `doctorId` generado | `curl -X POST http://localhost:5000/doctors -H "Content-Type: application/json" -d '{"firstName":"Ana","lastName":"García","specialty":"Cardiología"}'` |
| `POST /doctors` con body vacío | Validación fallida | `400` con mensaje de error | `curl -X POST http://localhost:5000/doctors -H "Content-Type: application/json" -d '{}'` |
| `PUT /doctors/1` con body válido | Doctor actualizado | `200` con el doctor actualizado | `curl -X PUT http://localhost:5000/doctors/1 -H "Content-Type: application/json" -d '{"firstName":"Ana","lastName":"López","specialty":"Neurología"}'` |
| `PUT /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` | `curl -X PUT http://localhost:5000/doctors/999 -H "Content-Type: application/json" -d '{"firstName":"X","lastName":"Y"}'` |
| `DELETE /doctors/1` | Doctor eliminado | `204` sin contenido | `curl -X DELETE -i http://localhost:5000/doctors/1` |
| `DELETE /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` | `curl -X DELETE -i http://localhost:5000/doctors/999` |
| `DELETE /doctors/1` (con admissions) | Doctor con admissions | `400` con mensaje de integridad referencial | `curl -X DELETE -i http://localhost:5000/doctors/1` |

## 3. Criterios de corrección ítem por ítem

- **1.1 (15 pts):** `POST /doctors` con INSERT y código 201. 10 pts por el INSERT correcto y el retorno del doctor creado. 5 pts por la validación de `firstName` y `lastName`.
- **1.2 (15 pts):** `PUT /doctors/{doctorId:long}` con UPDATE. 10 pts por el UPDATE correcto y retorno del doctor actualizado. 5 pts por `Results.NotFound` cuando el ID no existe.
- **1.3 (10 pts):** `DELETE /doctors/{doctorId:long}` con DELETE. 5 pts por el DELETE correcto y retorno 204. 5 pts por `Results.NotFound` cuando el ID no existe.
- **1.4 (10 pts):** Validación de integridad referencial antes de DELETE. 5 pts por verificar admissions asociadas. 5 pts por retornar `Results.BadRequest` con el mensaje correcto.
- **2.1 (10 pts):** README de portada completo. 10 pts si incluye descripción, endpoints y instrucciones.
- **2.2 (5 pts):** Issue creado en GitHub. 5 pts si describe una mejora pendiente.
- **2.3 (10 pts):** Rama por feature y PR hacia `main`. 5 pts por la rama. 5 pts por el PR.
- **2.4 (5 pts):** Protección de `main` verificada. 5 pts si se confirma que no se puede hacer push directo.
- **3.1-3.4 (20 pts):** 5 pts por cada verificación de endpoint funcionando y commit/push realizado.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno retorna 200 en POST en lugar de 201, restar 5 pts y pedir la corrección.
- Si el alumno no valida la existencia antes de DELETE y genera un error de base de datos, restar 5 pts.
- Si el alumno concatena SQL en lugar de usar parámetros parametrizados, restar 10 pts.
- Si el alumno no crea rama por feature y hace push directo a `main`, restar 5 pts.

## 4. Pauta de devolución

La devolución se realiza al final del E35. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de diciembre como primera capa de recuperación y la de marzo como segunda capa. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.
