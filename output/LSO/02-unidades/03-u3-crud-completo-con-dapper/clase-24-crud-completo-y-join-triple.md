# Encuentro 24 — CRUD completo y JOIN triple

> Unidad 3 — CRUD completo con Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 24 de 36 |
| Unidad | 3 — CRUD completo con Dapper |
| Eje temático | 5 — CRUD con Dapper |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | CRUD completo y JOIN triple |
| Requisitos previos | Encuentros 21-23: INSERT, DELETE, UPDATE con Dapper, códigos HTTP 201/204/404/400 |
| Uso de celular | No permitido |
| Organización del trabajo | Parejas, una computadora cada dos |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Completar los cuatro endpoints CRUD (GET, POST, PUT, DELETE) en un único `Program.cs`.
2. Construir un JOIN de 3 tablas (`admissions` + `patients` + `doctors`) para consultar datos relacionados.
3. Exponer el JOIN como endpoint GET con alias `AS` para cada columna del record.
4. Reforzar la diferencia entre `Query<T>` para lecturas y `Execute` para escrituras en un solo archivo.

## 3. Apertura y motivación (20 min)

### Charla rápida: analogía breve que ancle el concepto

Hasta ahora cada encuentro agregó un endpoint nuevo al archivo. Imaginen que el archivo `Program.cs` es el menú de un restaurante: cada endpoint es un plato del menú. El GET es la carta (leer), el POST es el pedido (crear), el PUT es la modificación del pedido (actualizar) y el DELETE es cancelar el pedido (borrar). Hoy armamos el menú completo con los cuatro platos.

### Lo mínimo indispensable

Un `Program.cs` canónico de Minimal API con Dapper tiene: los `using`, el `builder`, el `app`, los cuatro endpoints (`MapGet`, `MapPost`, `MapPut`, `MapDelete`), el `app.Run()`, y los records al final. El JOIN de 3 tablas usa `Query<T>` con un SELECT que une `admissions`, `patients` y `doctors` con alias `AS` para cada columna.

## 4. Desarrollo teórico-práctico (120 min)

### Paso 1 — El Program.cs completo con los cuatro endpoints CRUD

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var connectionString = "Data Source=hospital.db";

// Records al final del archivo, despues de app.Run() (requerido por CS8803)

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        ORDER BY patient_id"
    ).ToList();
    return Results.Ok(patients);
});

// GET /patients/{id:long} — obtener un paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// POST /patients — crear un paciente nuevo
app.MapPost("/patients", (Patient nuevoPaciente) =>
{
    if (string.IsNullOrWhiteSpace(nuevoPaciente.FirstName) ||
        string.IsNullOrWhiteSpace(nuevoPaciente.LastName))
    {
        return Results.BadRequest(new { mensaje = "El nombre y el apellido son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    long newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid();
    ", nuevoPaciente);

    var pacienteCreado = nuevoPaciente with { PatientId = newId };
    return Results.Created($"/patients/{newId}", pacienteCreado);
});

// PUT /patients/{id:long} — actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, Patient pacienteActualizado) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });

    if (existente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        UPDATE patients
        SET first_name = @FirstName, last_name = @LastName, gender = @Gender,
            city = @City, province_id = @ProvinceId, allergies = @Allergies,
            height = @Height, weight = @Weight
        WHERE patient_id = @id",
        new
        {
            pacienteActualizado.FirstName,
            pacienteActualizado.LastName,
            pacienteActualizado.Gender,
            pacienteActualizado.City,
            pacienteActualizado.ProvinceId,
            pacienteActualizado.Allergies,
            pacienteActualizado.Height,
            pacienteActualizado.Weight,
            id
        });

    return Results.NoContent();
});

// DELETE /patients/{id:long} — borrar un paciente por ID
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var paciente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });

    if (paciente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    return Results.NoContent();
});

app.Run();

// Records despues de app.Run() — requerido por CS8803
public record Patient(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    string ProvinceId,
    string? Allergies,
    long? Height,
    long? Weight
);
```

> Comentario: este es el archivo completo. Cada endpoint usa `using var connection` para abrir y cerrar la conexión automáticamente. Los records van después de `app.Run()`.

### Paso 2 — El record para el JOIN de 3 tablas

```csharp
// Record para la consulta con JOIN de 3 tablas: admissions + patients + doctors
public record AdmissionDetail(
    long PatientId,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty,
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis
);
```

> Comentario: el record `AdmissionDetail` tiene campos calculados (`PatientName`, `DoctorName`) que no existen como columnas en ninguna tabla. Se construyen con `||` en el SQL.

### Paso 3 — El endpoint GET con JOIN de 3 tablas

```csharp
// GET /admissions/detail — listar ingresos con nombre del paciente y del medico
app.MapGet("/admissions/detail", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.patient_id AS PatientId,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        ORDER BY a.admission_date DESC"
    ).ToList();

    return Results.Ok(admissions);
});
```

> Comentario: el JOIN une 3 tablas: `admissions` (alias `a`), `patients` (alias `p`) y `doctors` (alias `d`). Las columnas de nombre se concatenan con `||` y se aliasean como `PatientName` y `DoctorName` para que coincidan con los parámetros del record.

### Paso 4 — Probar el endpoint con JOIN

```bash
curl http://localhost:5000/admissions/detail | head -c 1000
```

Salida esperada (primeros registros):

```json
[
  {
    "patientId": 258,
    "patientName": "Zoe Anderson",
    "doctorName": "Monica Singleton",
    "doctorSpecialty": "Cardiologist",
    "admissionDate": "2019-06-02",
    "dischargeDate": null,
    "diagnosis": "Pregnancy"
  },
  {
    "patientId": 257,
    "patientName": "Yvonne Fisher",
    "doctorName": "Larry Miller",
    "doctorSpecialty": "Cardiovascular Surgeon",
    "admissionDate": "2019-06-01",
    "dischargeDate": "2019-06-05",
    "diagnosis": "Myocardial Infarction"
  }
]
```

> Comentario: `patientName` y `doctorName` son campos calculados con `||` (concatenación de strings en SQLite). `dischargeDate` es `null` para ingresos que aún no tienen fecha de alta.

### Paso 5 — JOIN de 3 tablas con filtro por provincia (consolidación)

```csharp
// GET /admissions/detail?provinceId=ON — ingresos de pacientes de Ontario
app.MapGet("/admissions/detail", (string? provinceId = null) =>
{
    using var connection = new SqliteConnection(connectionString);

    var sql = @"
        SELECT a.patient_id AS PatientId,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id";

    var parameters = new { provinceId };

    if (!string.IsNullOrWhiteSpace(provinceId))
    {
        sql += " WHERE p.province_id = @provinceId";
    }

    sql += " ORDER BY a.admission_date DESC";

    var admissions = connection.Query<AdmissionDetail>(sql, parameters).ToList();

    return Results.Ok(admissions);
});
```

> Comentario: el `WHERE` se agrega dinámicamente solo cuando `provinceId` no es nulo. El parámetro `@provinceId` se pasa siempre en el objeto anónimo, pero solo se usa si la cláusula WHERE existe en el SQL.

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- Un `Program.cs` completo con los cuatro endpoints CRUD usa: `MapGet`, `MapPost`, `MapPut`, `MapDelete`.
- El JOIN de 3 tablas se construye con `JOIN ... ON` y alias en el SELECT con `AS` para cada columna.
- Los campos calculados (como `PatientName` con `||`) se aliasean con `AS` para coincidir con los nombres del record.
- `ExecuteScalar<long>` devuelve el ID del INSERT, `Execute` devuelve filas afectadas, `Query<T>` devuelve listas, `QueryFirstOrDefault<T>` devuelve un solo registro o `null`.
- Los records van siempre después de `app.Run()`.

## Lo que viene

Encuentro 25: Cierre de la Unidad 3. Repasamos el CRUD completo, entregamos el TP-U3 en GitHub y nos preparamos para la evaluación de la Unidad 3.
