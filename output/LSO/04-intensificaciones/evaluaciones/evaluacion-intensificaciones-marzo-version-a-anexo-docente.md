# Anexo docente — Evaluación del momento de intensificación y fortalecimiento marzo — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Data.SQLite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// --- U1: tickets de soporte (en memoria) ---
var tickets = new List<object>
{
    new { ticketId = 1L, ticketInput = "No funciona la impresora", priority = "alta", createdDate = "2025-01-15" },
    new { ticketId = 2L, ticketInput = "Error al guardar", priority = "media", createdDate = "2025-01-16" },
    new { ticketId = 3L, ticketInput = "Solicitud de acceso", priority = "baja", createdDate = "2025-01-17" }
};
var nextTicketId = 4L;

// --- U2: conexión a hospital.db ---
var connectionString = "Data Source=hospital.db";

// U1: Endpoints GET de tickets
app.MapGet("/tickets", () => Results.Ok(tickets));

app.MapGet("/tickets/{ticketId:long}", (long ticketId) =>
{
    var ticket = tickets.FirstOrDefault(t => t.ticketId == ticketId);
    if (ticket is null)
        return Results.NotFound(new { mensaje = "Ticket no encontrado" });
    return Results.Ok(ticket);
});

app.MapGet("/tickets", (string? priority) =>
{
    if (!string.IsNullOrEmpty(priority))
    {
        var filtered = tickets.Where(t => t.priority.Equals(priority, StringComparison.OrdinalIgnoreCase)).ToList();
        return Results.Ok(filtered);
    }
    return Results.Ok(tickets);
});

// U2: Endpoints GET con Dapper y SQLite
app.MapGet("/doctors", async (SQLiteConnection db) =>
{
    var doctors = await db.QueryAsync<Doctor>("SELECT * FROM doctors");
    return Results.Ok(doctors);
});

app.MapGet("/doctors/{doctorId:long}", async (long doctorId, SQLiteConnection db) =>
{
    var doctor = await db.QueryFirstOrDefaultAsync<Doctor>("SELECT * FROM doctors WHERE doctorId = @doctorId", new { doctorId });
    if (doctor is null)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });
    return Results.Ok(doctor);
});

app.MapGet("/admissions", async (SQLiteConnection db) =>
{
    var sql = @"
        SELECT a.*, d.firstName AS doctorFirstName, d.lastName AS doctorLastName, d.specialty AS doctorSpecialty
        FROM admissions a
        JOIN doctors d ON a.doctor_id = d.doctor_id";
    var admissions = await db.QueryAsync<AdmissionWithDoctor>(sql);
    return Results.Ok(admissions);
});

// U3: CRUD de doctors
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
record AdmissionWithDoctor(long admissionId, long doctor_id, string admissionDate, string type, string doctorFirstName, string doctorLastName, string doctorSpecialty);

app.Run();
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| `GET /tickets` | Lista completa de tickets | JSON con 3 objetos Ticket, cada uno con TicketId, TicketInput, Priority, CreatedDate | `curl http://localhost:5000/tickets` |
| `GET /tickets/1` | Ticket con ID 1 | JSON del ticket con TicketId = 1 | `curl http://localhost:5000/tickets/1` |
| `GET /tickets/99` | Ticket inexistente | `404` con `{ "mensaje": "Ticket no encontrado" }` | `curl -i http://localhost:5000/tickets/99` |
| `GET /tickets?priority=alta` | Tickets con prioridad "alta" | JSON con los tickets cuya prioridad sea "alta" | `curl http://localhost:5000/tickets?priority=alta` |
| `GET /doctors` | Lista completa de doctores | JSON con la lista de doctores de hospital.db | `curl http://localhost:5000/doctors` |
| `GET /doctors/1` | Doctor con ID 1 | JSON del doctor con DoctorId=1 | `curl http://localhost:5000/doctors/1` |
| `GET /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` | `curl -i http://localhost:5000/doctors/999` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions con datos del doctor | `curl http://localhost:5000/admissions` |
| `POST /doctors` con body válido | Nuevo doctor creado | `201` con el doctor creado incluyendo `doctorId` generado | `curl -X POST http://localhost:5000/doctors -H "Content-Type: application/json" -d '{"firstName":"Ana","lastName":"García","specialty":"Cardiología"}'` |
| `PUT /doctors/1` con body válido | Doctor actualizado | `200` con el doctor actualizado | `curl -X PUT http://localhost:5000/doctors/1 -H "Content-Type: application/json" -d '{"firstName":"Ana","lastName":"López","specialty":"Neurología"}'` |
| `DELETE /doctors/1` | Doctor eliminado | `204` sin contenido | `curl -X DELETE -i http://localhost:5000/doctors/1` |
| `DELETE /doctors/999` | Doctor inexistente | `404` con `{ "mensaje": "Doctor no encontrado" }` | `curl -X DELETE -i http://localhost:5000/doctors/999` |

## 3. Criterios de corrección ítem por ítem

- **1.1 (10 pts):** Endpoint `GET /tickets` retorna `Results.Ok(tickets)`. 10 pts si funciona correctamente.
- **1.2 (10 pts):** Endpoint `GET /tickets/{ticketId:long}` con route parameter tipado como `long`. 5 pts por retornar el ticket correcto. 5 pts por retornar `Results.NotFound` con el mensaje esperado.
- **1.3 (5 pts):** Endpoint `GET /tickets?priority=alta` con query parameter. 5 pts si filtra correctamente.
- **2.1 (10 pts):** Endpoint `GET /doctors` retorna `Results.Ok` con la lista de doctores. 10 pts si funciona correctamente.
- **2.2 (10 pts):** Endpoint `GET /doctors/{doctorId:long}` con route parameter tipado como `long`. 5 pts por retornar el doctor correcto. 5 pts por retornar `Results.NotFound`.
- **2.3 (5 pts):** Endpoint `GET /admissions` con JOIN y alias `AS`. 5 pts si retorna las admissions con datos del doctor.
- **3.1 (10 pts):** `POST /doctors` con INSERT y código 201. 5 pts por el INSERT correcto. 5 pts por la validación de `firstName` y `lastName`.
- **3.2 (10 pts):** `PUT /doctors/{doctorId:long}` con UPDATE. 5 pts por el UPDATE correcto. 5 pts por `Results.NotFound` cuando el ID no existe.
- **3.3 (10 pts):** `DELETE /doctors/{doctorId:long}` con DELETE. 5 pts por el DELETE correcto y retorno 204. 5 pts por `Results.NotFound` cuando el ID no existe y por la validación de integridad referencial.
- **4.1 (10 pts):** README de portada completo. 10 pts si incluye descripción, endpoints y instrucciones.
- **4.2 (5 pts):** Issue creado en GitHub. 5 pts si describe una mejora pendiente.
- **4.3 (5 pts):** Rama por feature y PR hacia `main`. 5 pts si se confirma la rama y el PR.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `int` en lugar de `long` para los IDs, restar 5 pts y pedir la corrección.
- Si el alumno concatena el parámetro SQL en lugar de usar `new { doctorId }`, restar 10 pts.
- Si el alumno retorna `null` en lugar de `Results.NotFound`, restar 5 pts.
- Si el alumno no crea rama por feature y hace push directo a `main`, restar 5 pts.

## 4. Pauta de devolución

La devolución se realiza al final del encuentro. Se devuelve con nota de Apto o No apto. Si el objetivo mínimo queda pendiente, se ofrece la instancia de diciembre como primera capa de recuperación. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.