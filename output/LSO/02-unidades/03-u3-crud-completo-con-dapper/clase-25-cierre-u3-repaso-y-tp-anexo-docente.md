# Encuentro 25 — Anexo docente: Cierre U3, repaso y TP

## Resumen de la clase

| Bloque | Duracion | Actividad |
|---|---|---|
| Apertura y motivacion | 20 min | Repaso general de la Unidad 3. Presentar la checklist pre-entrega y el TP-U3. |
| Repaso teorico-practico | 50 min | Recorrer la tabla de verbos HTTP + metodos Dapper. Verificar tipos canonicos. Ejemplo rapido de JOIN triple. |
| Trabajo en el TP-U3 | 120 min | Los alumnos implementan el TP de forma individual o por grupos. El docente circula resolviendo dudas. |
| Puesta en comun y cierre de unidad | 30 min | Revisar soluciones voluntarias. Checklist pre-entrega. Instrucciones de git y entrega. |
| Cierre | 20 min | Preview de la Unidad 4. Reflexion sobre lo aprendido. |

## Solucion completa del TP-U3

`Program.cs` completo del TP (ubicado en `tp-u3/`):

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — listar todos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty,
               phone AS Phone,
               email AS Email
        FROM doctors").ToList();
    return Results.Ok(doctors);
});

// GET /doctors/{id:long} — obtener un doctor
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty,
               phone AS Phone,
               email AS Email
        FROM doctors WHERE doctor_id = @id", new { id });

    return doctor is null
        ? Results.NotFound(new { mensaje = "Doctor no encontrado" })
        : Results.Ok(doctor);
});

// POST /doctors — crear un doctor
app.MapPost("/doctors", (DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO doctors (first_name, last_name, specialty, phone, email)
        VALUES (@FirstName, @LastName, @Specialty, @Phone, @Email);
        SELECT last_insert_rowid() AS NewId;", input);

    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors WHERE doctor_id = @id", new { id = newId });

    return Results.Created($"/doctors/{newId}", doctor);
});

// PUT /doctors/{id:long} — actualizar un doctor
app.MapPut("/doctors/{id:long}", (long id, DoctorInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var existente = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId, first_name AS FirstName,
               last_name AS LastName, specialty AS Specialty,
               phone AS Phone, email AS Email
        FROM doctors WHERE doctor_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    connection.Execute(@"
        UPDATE doctors SET first_name = @FirstName, last_name = @LastName,
            specialty = @Specialty, phone = @Phone, email = @Email
        WHERE doctor_id = @Id", new
    {
        input.FirstName, input.LastName, input.Specialty,
        input.Phone, input.Email, Id = id
    });

    return Results.NoContent();
});

// DELETE /doctors/{id:long} — eliminar un doctor
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);
    int filas = connection.Execute("DELETE FROM doctors WHERE doctor_id = @id", new { id });

    if (filas == 0)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    return Results.NoContent();
});

// GET /admissions/{id:long} — una admision con JOIN triple
app.MapGet("/admissions/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admision = connection.QueryFirstOrDefault<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               a.discharge_date AS DischargeDate,
               d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName,
               p.patient_id AS PatientId,
               p.first_name AS PatientFirstName,
               p.last_name AS PatientLastName
        FROM admissions a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN patients p ON a.patient_id = p.patient_id
        WHERE a.admission_id = @id", new { id });

    return admision is null
        ? Results.NotFound(new { mensaje = "Admision no encontrada" })
        : Results.Ok(admision);
});

app.Run();

// --- records al final ---
record DoctorInput(string FirstName, string? LastName, string? Specialty, string? Phone, string? Email);
record Doctor(long DoctorId, string FirstName, string? LastName, string? Specialty,
              string? Phone, string? Email);
record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       string? DischargeDate, long DoctorId, string DoctorFirstName,
                       string? DoctorLastName, long PatientId, string PatientFirstName,
                       string? PatientLastName);
```

## Errores anticipados en el TP

| Error esperado | Correccion |
|---|---|
| El alumno no incluye `DELETE /doctors` | El TP pide CRUD completo, DELETE es obligatorio. |
| El JOIN triple no incluye `discharge_date` en el SELECT | La consigna pide datos de admision: `discharge_date` es opcional pero debe estar en el SELECT. |
| Usar `DoctorInput` para PUT sin validar existencia | Recordar que PUT debe verificar existencia con `QueryFirstOrDefault`. |
| Olvidar `.gitignore` | Sin `.gitignore` se suben `bin/` y `obj/`. Mostrar como crearlo. |
| Commit con mensaje en ingles o sin formato | El canon exige espanol sin tildes: `"tp-u3: CRUD completo con Dapper"`. |
| El record `DoctorInput` usa `string` en lugar de `string?` para campos nulables | `specialty`, `phone`, `email` aceptan NULL en la BD -- deben ser `string?`. |

## Checklist de correccion del TP

| ✔ | Criterio | Puntaje |
|---|---|---|
| ☐ | GET /doctors funciona y devuelve 200 | 10% |
| ☐ | GET /doctors/{id} funciona; 404 para ID inexistente | 10% |
| ☐ | POST /doctors crea y devuelve 201 con URL | 15% |
| ☐ | POST /doctors rechaza FirstName vacio con 400 | 10% |
| ☐ | PUT /doctors/{id} actualiza y devuelve 204 | 15% |
| ☐ | PUT /doctors/{id} devuelve 404 si no existe | 10% |
| ☐ | DELETE /doctors/{id} borra y devuelve 204 | 10% |
| ☐ | GET /admissions/{id} funciona con JOIN triple | 15% |
| ☐ | Records usan `long` para IDs, `string` para fechas | 5% |
| ☐ | Todos los SELECT tienen alias `AS` | 5% |

## Notas para el docente

- **Entrega:** los alumnos deben tener el codigo en `tp-u3/Program.cs` dentro del repositorio grupal. No se aceptan archivos sueltos ni entregas por mail.
- **Git:** recordar el ciclo: `git add .` → `git commit -m "..."` → `git push`. Verificar que el commit aparezca en GitHub.
- **Tiempo de TP:** los 120 minutos de trabajo en el TP suelen ser justos. Si ves que un grupo se atrasa, sugerile completar primero los endpoints obligatorios (GET y POST) y dejar DELETE y PUT como mejora.
- **Extension:** para los que terminan antes, pueden agregar un endpoint `GET /doctors?search=texto` que busque por especialidad usando `LIKE`.