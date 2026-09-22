# Anexo docente — Evaluación del momento 17-18 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`Program.cs`)

```csharp
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Data.SQLite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// --- U1: books de soporte (en memoria) ---
var books = new List<object>
{
    new { bookId = 1L, bookInput = "No funciona la impresora", author = "alta", publishedDate = "2025-01-15" },
    new { bookId = 2L, bookInput = "Error al guardar", author = "media", publishedDate = "2025-01-16" },
    new { bookId = 3L, bookInput = "Solicitud de acceso", author = "baja", publishedDate = "2025-01-17" }
};
var nextBookId = 4L;

// --- U2: conexión a hospital.db ---
var connectionString = "Data Source=hospital.db";

// U1: Endpoints GET de books
app.MapGet("/books", () => Results.Ok(books));

app.MapGet("/books/{bookId:long}", (long bookId) =>
{
    var book = books.FirstOrDefault(b => b.bookId == bookId);
    if (book is null)
        return Results.NotFound(new { mensaje = "Book no encontrado" });
    return Results.Ok(book);
});

app.MapGet("/books", (string? author) =>
{
    if (!string.IsNullOrEmpty(author))
    {
        var filtered = books.Where(b => b.author.Equals(author, StringComparison.OrdinalIgnoreCase)).ToList();
        return Results.Ok(filtered);
    }
    return Results.Ok(books);
});

// U2: Endpoints GET con Dapper y SQLite
app.MapGet("/patients", async (SQLiteConnection db) =>
{
    var patients = await db.QueryAsync<Patient>("SELECT * FROM patients");
    return Results.Ok(patients);
});

app.MapGet("/patients/{patientId:long}", async (long patientId, SQLiteConnection db) =>
{
    var patient = await db.QueryFirstOrDefaultAsync<Patient>("SELECT * FROM patients WHERE patientId = @patientId", new { patientId });
    if (patient is null)
        return Results.NotFound(new { mensaje = "Patient no encontrado" });
    return Results.Ok(patient);
});

app.MapGet("/admissions", async (SQLiteConnection db) =>
{
    var sql = @"
        SELECT a.*, p.firstName AS patientFirstName, p.lastName AS patientLastName, p.city AS patientCity
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id";
    var admissions = await db.QueryAsync<AdmissionWithPatient>(sql);
    return Results.Ok(admissions);
});

app.MapGet("/admissions", (long? patientId, SQLiteConnection db) =>
{
    if (patientId.HasValue)
    {
        var sql = @"
            SELECT a.*, p.firstName AS patientFirstName, p.lastName AS patientLastName, p.city AS patientCity
            FROM admissions a
            JOIN patients p ON a.patient_id = p.patient_id
            WHERE a.patient_id = @patientId";
        var admissions = db.Query<AdmissionWithPatient>(sql, new { patientId }).ToList();
        return Results.Ok(admissions);
    }
    return Results.Ok(db.Query<AdmissionWithPatient>(sql));
});

// Models para U2
record Patient(long patientId, string firstName, string lastName, string city, string? allergies, long? height, long? weight);
record AdmissionWithPatient(long admissionId, long patient_id, string admissionDate, string type, string patientFirstName, string patientLastName, string patientCity);

app.Run();
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| `GET /books` | Lista completa de books | JSON con 3 objetos Book, cada uno con BookId, BookInput, Author, PublishedDate | `curl http://localhost:5000/books` |
| `GET /books/1` | Book con ID 1 | JSON del book con BookId = 1 | `curl http://localhost:5000/books/1` |
| `GET /books/99` | Book inexistente | `404` con `{ "mensaje": "Book no encontrado" }` | `curl -i http://localhost:5000/books/99` |
| `GET /books?author=alta` | Books con author "alta" | JSON con los books cuya author sea "alta" | `curl http://localhost:5000/books?author=alta` |
| `GET /patients` | Lista completa de pacientes | JSON con la lista de pacientes de hospital.db | `curl http://localhost:5000/patients` |
| `GET /patients/1` | Patient con ID 1 | JSON del patient con PatientId=1 | `curl http://localhost:5000/patients/1` |
| `GET /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` | `curl -i http://localhost:5000/patients/999` |
| `GET /admissions` | Lista completa de admissions | JSON con todas las admissions con datos del patient | `curl http://localhost:5000/admissions` |
| `GET /admissions?patientId=1` | Admissions del patient 1 | JSON con las admissions del patient con PatientId=1 | `curl http://localhost:5000/admissions?patientId=1` |

## 3. Criterios de corrección ítem por ítem

- **1.1 (10 pts):** Endpoint `GET /books` retorna `Results.Ok(books)`. 10 pts si funciona correctamente.
- **1.2 (15 pts):** Endpoint `GET /books/{bookId:long}` con route parameter tipado como `long`. 10 pts por retornar el book correcto. 5 pts por retornar `Results.NotFound` con el mensaje esperado cuando no existe.
- **1.3 (15 pts):** Endpoint `GET /books?author=alta` con query parameter. 10 pts por filtrar correctamente. 5 pts por manejar la ausencia del parámetro (retornar todos los books).
- **2.1 (10 pts):** Endpoint `GET /patients` retorna `Results.Ok` con la lista de pacientes. 10 pts si funciona correctamente.
- **2.2 (10 pts):** Endpoint `GET /patients/{patientId:long}` con route parameter tipado como `long`. 5 pts por retornar el patient correcto. 5 pts por retornar `Results.NotFound` con el mensaje esperado cuando no existe.
- **2.3 (15 pts):** Endpoint `GET /admissions` con JOIN y alias `AS`. 10 pts por el JOIN correcto. 5 pts por los alias `AS` que permiten a Dapper mapear las columnas al record `AdmissionWithPatient`.
- **2.4 (5 pts):** Endpoint `GET /admissions?patientId=...` parametrizado con `new { patientId }`. 5 pts si filtra correctamente y usa parámetros parametrizados (no string interpolation).
- **3.1-3.4 (20 pts):** 5 pts por cada verificación de endpoint funcionando y commit/push realizado.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `int` en lugar de `long` para los IDs, restar 5 pts y pedir la corrección (convención INTEGER → long).
- Si el alumno concatena el parámetro SQL en lugar de usar `new { patientId }`, marcar como error de seguridad y restar 10 pts.
- Si el alumno retorna `null` en lugar de `Results.NotFound`, restar 5 pts.
- Si el alumno no usa alias `AS` en el JOIN y Dapper no mapea correctamente, restar 5 pts.

## 4. Pauta de devolución

La devolución se realiza en el encuentro siguiente (E19). Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia del proyecto puente (E19-20) como primera capa de recuperación y la de diciembre como segunda capa. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.