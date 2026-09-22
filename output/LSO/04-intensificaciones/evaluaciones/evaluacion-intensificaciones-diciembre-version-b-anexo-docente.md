# Anexo docente — Evaluación del momento diciembre — Versión B

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

// U3: CRUD de patients
app.MapPost("/patients", async (PatientInput input, SQLiteConnection db) =>
{
    if (string.IsNullOrWhiteSpace(input.firstName) || string.IsNullOrWhiteSpace(input.lastName))
        return Results.BadRequest(new { mensaje = "firstName y lastName son obligatorios" });

    var id = await db.ExecuteScalarAsync<long>(
        "INSERT INTO patients (firstName, lastName, city) VALUES (@firstName, @lastName, @city)",
        input);
    var patient = await db.QueryFirstOrDefaultAsync<Patient>("SELECT * FROM patients WHERE patientId = @patientId", new { patientId = id });
    return Results.Created($"/patients/{id}", patient);
});

app.MapPut("/patients/{patientId:long}", async (long patientId, PatientInput input, SQLiteConnection db) =>
{
    var existing = await db.QueryFirstOrDefaultAsync<Patient>("SELECT * FROM patients WHERE patientId = @patientId", new { patientId });
    if (existing is null)
        return Results.NotFound(new { mensaje = "Patient no encontrado" });

    await db.ExecuteAsync(
        "UPDATE patients SET firstName = @firstName, lastName = @lastName, city = @city WHERE patientId = @patientId",
        new { input.firstName, input.lastName, input.city, patientId });
    var updated = await db.QueryFirstOrDefaultAsync<Patient>("SELECT * FROM patients WHERE patientId = @patientId", new { patientId });
    return Results.Ok(updated);
});

app.MapDelete("/patients/{patientId:long}", async (long patientId, SQLiteConnection db) =>
{
    var existing = await db.QueryFirstOrDefaultAsync<Patient>("SELECT * FROM patients WHERE patientId = @patientId", new { patientId });
    if (existing is null)
        return Results.NotFound(new { mensaje = "Patient no encontrado" });

    var admissionCount = await db.ExecuteScalarAsync<long>(
        "SELECT COUNT(*) FROM admissions WHERE patient_id = @patientId", new { patientId });
    if (admissionCount > 0)
        return Results.BadRequest(new { mensaje = "No se puede eliminar un patient con admissions asociadas" });

    await db.ExecuteAsync("DELETE FROM patients WHERE patientId = @patientId", new { patientId });
    return Results.NoContent();
});

// Models
record PatientInput(string firstName, string lastName, string? city);
record Patient(long patientId, string firstName, string lastName, string? city, string? allergies, long? height, long? weight);
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
| `POST /patients` con body válido | Nuevo patient creado | `201` con el patient creado incluyendo `patientId` generado | `curl -X POST http://localhost:5000/patients -H "Content-Type: application/json" -d '{"firstName":"Ana","lastName":"García","city":"Buenos Aires"}'` |
| `PUT /patients/1` con body válido | Patient actualizado | `200` con el patient actualizado | `curl -X PUT http://localhost:5000/patients/1 -H "Content-Type: application/json" -d '{"firstName":"Ana","lastName":"López","city":"Córdoba"}'` |
| `DELETE /patients/1` | Patient eliminado | `204` sin contenido | `curl -X DELETE -i http://localhost:5000/patients/1` |
| `DELETE /patients/999` | Patient inexistente | `404` con `{ "mensaje": "Patient no encontrado" }` | `curl -X DELETE -i http://localhost:5000/patients/999` |

## 3. Criterios de corrección ítem por ítem

- **1.1 (10 pts):** Endpoint `GET /books` retorna `Results.Ok(books)`. 10 pts si funciona correctamente.
- **1.2 (10 pts):** Endpoint `GET /books/{bookId:long}` con route parameter tipado como `long`. 5 pts por retornar el book correcto. 5 pts por retornar `Results.NotFound` con el mensaje esperado.
- **1.3 (5 pts):** Endpoint `GET /books?author=alta` con query parameter. 5 pts si filtra correctamente.
- **2.1 (10 pts):** Endpoint `GET /patients` retorna `Results.Ok` con la lista de pacientes. 10 pts si funciona correctamente.
- **2.2 (10 pts):** Endpoint `GET /patients/{patientId:long}` con route parameter tipado como `long`. 5 pts por retornar el patient correcto. 5 pts por retornar `Results.NotFound`.
- **2.3 (5 pts):** Endpoint `GET /admissions` con JOIN y alias `AS`. 5 pts si retorna las admissions con datos del patient.
- **3.1 (10 pts):** `POST /patients` con INSERT y código 201. 5 pts por el INSERT correcto. 5 pts por la validación de `firstName` y `lastName`.
- **3.2 (10 pts):** `PUT /patients/{patientId:long}` con UPDATE. 5 pts por el UPDATE correcto. 5 pts por `Results.NotFound` cuando el ID no existe.
- **3.3 (10 pts):** `DELETE /patients/{patientId:long}` con DELETE. 5 pts por el DELETE correcto y retorno 204. 5 pts por `Results.NotFound` cuando el ID no existe y por la validación de integridad referencial.
- **4.1 (10 pts):** README de portada completo. 10 pts si incluye descripción, endpoints y instrucciones.
- **4.2 (5 pts):** Issue creado en GitHub. 5 pts si describe una mejora pendiente.
- **4.3 (5 pts):** Rama por feature y PR hacia `main`. 5 pts si se confirma la rama y el PR.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `int` en lugar de `long` para los IDs, restar 5 pts y pedir la corrección.
- Si el alumno concatena el parámetro SQL en lugar de usar `new { patientId }`, restar 10 pts.
- Si el alumno retorna `null` en lugar de `Results.NotFound`, restar 5 pts.
- Si el alumno no crea rama por feature y hace push directo a `main`, restar 5 pts.

## 4. Pauta de devolución

La devolución se realiza al final del encuentro. Se devuelve con nota de Apto o No apto. Si el objetivo mínimo queda pendiente, se ofrece la instancia de marzo como segunda capa de recuperación. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.