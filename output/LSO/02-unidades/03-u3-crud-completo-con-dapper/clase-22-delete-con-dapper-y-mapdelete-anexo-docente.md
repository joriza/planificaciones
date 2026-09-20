# Encuentro 22 — Anexo docente: DELETE con Dapper y MapDelete

## Resumen de la clase

| Bloque | Duracion | Actividad |
|---|---|---|
| Apertura y motivacion | 20 min | Analogia del paciente que se va del hospital. Repasar POST y `ExecuteScalar<long>` del encuentro anterior. |
| Teoria minima con ejemplo completo | 50 min | Explicar `MapDelete`, `Execute`, `Results.NoContent`. Codificar `DELETE /patients/{id:long}`. |
| Ejercicio progresivo | 120 min | Etapa 1: DELETE /doctors (guiada, 40 min). Etapa 2: DELETE /provinces con restriccion (semiguiada, 40 min). Etapa 3: DELETE /admissions (independiente, 40 min). |
| Puesta en comun y correccion de errores | 30 min | Revisar soluciones. Destacar errores del anexo. |
| Cierre | 20 min | Takeaway y preview del proximo encuentro (UPDATE con PUT). |

## Solucion completa del ejemplo

`DELETE /patients/{id:long}`:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar todos (reposo)
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City, province_id AS ProvinceId,
               allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients").ToList();
    return Results.Ok(patients);
});

// POST /patients — del encuentro anterior
app.MapPost("/patients", (PatientInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });
    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid() AS NewId;", input);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender, birth_date AS BirthDate,
               city AS City, province_id AS ProvinceId,
               allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients WHERE patient_id = @id", new { id = newId });
    return Results.Created($"/patients/{newId}", patient);
});

// DELETE /patients/{id:long} — eliminar por ID
app.MapDelete("/patients/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);
    int filasAfectadas = connection.Execute(
        "DELETE FROM patients WHERE patient_id = @id", new { id });

    if (filasAfectadas == 0)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    return Results.NoContent();
});

app.Run();

// --- records al final ---
record PatientInput(string FirstName, string? LastName, string Gender, string BirthDate,
                    string? City, long? ProvinceId, string? Allergies, long? Height, long? Weight);
record Patient(long PatientId, string FirstName, string? LastName, string Gender,
               string BirthDate, string? City, long? ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

## Soluciones del ejercicio progresivo

### Etapa 1 — DELETE /doctors/{id:long}

```csharp
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);
    int filasAfectadas = connection.Execute(
        "DELETE FROM doctors WHERE doctor_id = @id", new { id });

    if (filasAfectadas == 0)
        return Results.NotFound(new { mensaje = "Doctor no encontrado" });

    return Results.NoContent();
});
```

### Etapa 2 — DELETE /provinces/{id:long} con restriccion

```csharp
app.MapDelete("/provinces/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);

    // Verificar si la provincia esta referenciada por algun paciente
    long? count = connection.ExecuteScalar<long>(
        "SELECT COUNT(*) FROM patients WHERE province_id = @id", new { id });

    if (count > 0)
        return Results.BadRequest(new { mensaje = "No se puede eliminar una provincia con pacientes asociados" });

    int filasAfectadas = connection.Execute(
        "DELETE FROM province_names WHERE province_id = @id", new { id });

    if (filasAfectadas == 0)
        return Results.NotFound(new { mensaje = "Provincia no encontrada" });

    return Results.NoContent();
});
```

### Etapa 3 — DELETE /admissions/{id:long}

```csharp
app.MapDelete("/admissions/{id:long}", (long id) =>
{
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);
    int filasAfectadas = connection.Execute(
        "DELETE FROM admissions WHERE admission_id = @id", new { id });

    if (filasAfectadas == 0)
        return Results.NotFound(new { mensaje = "Admision no encontrada" });

    return Results.NoContent();
});
```

## Errores anticipados y correccion

| Error esperado | Donde aparece | Correccion en clase |
|---|---|---|
| Usar `ExecuteScalar<long>` para DELETE | Cualquier DELETE | Explicar que DELETE no genera un ID. `Execute` es el metodo adecuado. |
| No verificar `filasAfectadas` | DELETE sin `if (filas == 0)` | Mostrar que DELETE sobre ID inexistente no falla ni avisa. |
| Devolver `Results.Ok(patient)` en DELETE | Confundir con GET | Recordar que DELETE devuelve `204`, no `200` con cuerpo. |
| Validar `id` despues de la conexion | Orden de validacion | Abrir conexion es costoso; validar antes. |
| Borrar provincia referenciada sin advertir | DELETE /provinces sin chequeo previo | SQLite con FK habilitadas da error. Mostrar el chequeo preventivo. |
| Mensaje `"Patient not found"` en ingles | Copiar de ejemplo externo | La convencion del curso pide mensajes en espanol. |