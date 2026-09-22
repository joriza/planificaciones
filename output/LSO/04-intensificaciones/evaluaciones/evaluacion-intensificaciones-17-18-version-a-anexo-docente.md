# Anexo docente — Evaluación del momento 17-18 — Versión A

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

app.MapGet("/admissions", (long? doctorId, SQLiteConnection db) =>
{
    if (doctorId.HasValue)
    {
        var sql = @"
            SELECT a.*, d.firstName AS doctorFirstName, d.lastName AS doctorLastName, d.specialty AS doctorSpecialty
            FROM admissions a
            JOIN doctors d ON a.doctor_id = d.doctor_id
            WHERE a.doctor_id = @doctorId";
        var admissions = db.Query<AdmissionWithDoctor>(sql, new { doctorId }).ToList();
        return Results.Ok(admissions);
    }
    return Results.Ok(db.Query<AdmissionWithDoctor>(sql));
});

// Models para U2
record Doctor(long doctorId, string firstName, string lastName, string specialty);
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
| `GET /admissions?doctorId=1` | Admissions del doctor 1 | JSON con las admissions del doctor con DoctorId=1 | `curl http://localhost:5000/admissions?doctorId=1` |

## 3. Criterios de corrección ítem por ítem

- **1.1 (10 pts):** Endpoint `GET /tickets` retorna `Results.Ok(tickets)`. 10 pts si funciona correctamente.
- **1.2 (15 pts):** Endpoint `GET /tickets/{ticketId:long}` con route parameter tipado como `long`. 10 pts por retornar el ticket correcto. 5 pts por retornar `Results.NotFound` con el mensaje esperado cuando no existe.
- **1.3 (15 pts):** Endpoint `GET /tickets?priority=alta` con query parameter. 10 pts por filtrar correctamente. 5 pts por manejar la ausencia del parámetro (retornar todos los tickets).
- **2.1 (10 pts):** Endpoint `GET /doctors` retorna `Results.Ok` con la lista de doctores. 10 pts si funciona correctamente.
- **2.2 (10 pts):** Endpoint `GET /doctors/{doctorId:long}` con route parameter tipado como `long`. 5 pts por retornar el doctor correcto. 5 pts por retornar `Results.NotFound` con el mensaje esperado cuando no existe.
- **2.3 (15 pts):** Endpoint `GET /admissions` con JOIN y alias `AS`. 10 pts por el JOIN correcto. 5 pts por los alias `AS` que permiten a Dapper mapear las columnas al record `AdmissionWithDoctor`.
- **2.4 (5 pts):** Endpoint `GET /admissions?doctorId=...` parametrizado con `new { doctorId }`. 5 pts si filtra correctamente y usa parámetros parametrizados (no string interpolation).
- **3.1-3.4 (20 pts):** 5 pts por cada verificación de endpoint funcionando y commit/push realizado.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `int` en lugar de `long` para los IDs, restar 5 pts y pedir la corrección (convención INTEGER → long).
- Si el alumno concatena el parámetro SQL en lugar de usar `new { doctorId }`, marcar como error de seguridad y restar 10 pts.
- Si el alumno retorna `null` en lugar de `Results.NotFound`, restar 5 pts.
- Si el alumno no usa alias `AS` en el JOIN y Dapper no mapea correctamente, restar 5 pts.

## 4. Pauta de devolución

La devolución se realiza en el encuentro siguiente (E19). Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia del proyecto puente (E19-20) como primera capa de recuperación y la de diciembre como segunda capa. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.
