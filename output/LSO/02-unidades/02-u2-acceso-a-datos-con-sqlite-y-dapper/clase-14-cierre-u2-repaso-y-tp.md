# Encuentro 14 — Cierre U2: repaso y TP

**Unidad 2:** Acceso a datos con SQLite y Dapper  
**Duración:** 240 minutos  
**Carácter:** Actitudinal — cierre de unidad  
**Eje 4:** Dapper y consultas parametrizadas  

---

## Objetivos de aprendizaje

- Integrar los conceptos de la Unidad 2 (SQLite, SELECT, JOIN, ORDER BY, Dapper, records, parámetros, LIKE).
- Implementar un sistema de consultas contra `hospital.db` usando Dapper.
- Publicar el trabajo en GitHub dentro de la carpeta `tp-u2/`.

---

## Charla rápida

Esta clase es como el ensayo general antes de la función. Ya tienen todas las piezas: SELECT, JOIN, Dapper, records, parámetros, LIKE. Ahora van a construir un conjunto de endpoints que consulten la base desde distintos ángulos — como si fueran los reportes de un sistema hospitalario real. No hay contenido nuevo: es todo integración y práctica. Al final, entregan el TP-U2 en GitHub.

---

## Teoría mínima — Mapa conceptual de la Unidad 2

```
SQLite (hospital.db)
  └─ Microsoft.Data.Sqlite (conexión)
       └─ Dapper (mapeo automático)
            ├─ Query<T>(sql)         → lista de objetos
            ├─ QueryFirstOrDefault<T>(sql, params) → un objeto o null
            ├─ parámetros @var       → new { var = valor }
            └─ alias AS Siempre      → snake_case → PascalCase

Records posicionales:
  public record Paciente(long Id, string Nombre, string? Alergia)
                                       ↑            ↑           ↑
                                    Int64        String    String? si es NULL
```

---

## Práctica guiada

Van a construir el proyecto base del TP-U2 paso a paso. Este proyecto va a contener los endpoints que despues van a completar en el TP.

### Paso 1: Crear el proyecto

```bash
dotnet new web -o tp-u2
cd tp-u2
```

Copiar `hospital.db` junto al `.csproj`. Agregar paquetes:

```bash
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 2: Escribir los records

Reemplazar `Program.cs`:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// Records canonicos
public record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, string ProvinceId, string? Allergies, long? Height, long? Weight);

public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

public record Province(string ProvinceId, string ProvinceName);

public record PatientWithProvince(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, string ProvinceName, string? Allergies, long? Height, long? Weight);

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients
        ORDER BY last_name
    ").ToList();

    return Results.Ok(patients);
});

// GET /patients/{id:long} — buscar paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients
        WHERE patient_id = @id
    ", new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// GET /doctors — listar todos los medicos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name
    ").ToList();

    return Results.Ok(doctors);
});

app.Run();
```

### Paso 3: Probar los endpoints

```bash
dotnet run
```

Probar:
- `http://localhost:5000/patients` — 258 pacientes.
- `http://localhost:5000/patients/1` — paciente con ID 1.
- `http://localhost:5000/patients/9999` — `{"mensaje":"Paciente no encontrado"}` con 404.
- `http://localhost:5000/doctors` — 27 médicos.

---

## Ejercicio independiente — TP-U2

**Consigna del TP-U2 — SQLite y Dapper básico**

Completar el proyecto iniciado en la práctica guiada agregando los siguientes endpoints en `Program.cs`:

1. `GET /patients/by-name/{lastName}` — buscar pacientes por apellido usando LIKE (ej: `/patients/by-name/Smi` encuentra "Smith", "Smithers").
2. `GET /patients/with-province` — devolver pacientes con nombre de provincia (JOIN + `PatientWithProvince`).
3. `GET /doctors/by-specialty/{specialty}` — buscar médicos por especialidad con LIKE.
4. `GET /doctors/{id:long}` — buscar médico por ID, devolver 404 si no existe.

**Requisitos técnicos:**
- Todos los endpoints deben usar Dapper y records posicionales.
- Todas las consultas deben estar parametrizadas (ni una concatenación).
- Los alias AS son obligatorios en todas las columnas.
- Los records van después de `app.Run()`.
- Los campos nulables deben declararse con `?`.

**Entrega en GitHub:**
```bash
git init
git add .
git commit -m "tp-u2: consultas con Dapper y SQLite"
git remote add origin <url-del-repo-grupal>
git push -u origin main
```

(El proyecto debe estar dentro de la carpeta `tp-u2/` del repositorio grupal.)

---

### Qué te llevás

- SQLite es un archivo de base de datos que se consulta desde C#.
- Dapper mapea automáticamente filas a objetos.
- Los alias AS enlazan snake_case con PascalCase.
- Los parámetros `@` con objetos anónimos evitan inyección SQL.
- `LIKE` con `%` busca texto parcial.

### Lo que viene

En el Encuentro 15, evaluación de la Unidad 2: defensa oral y prueba A/B. Después, en la Unidad 3, CRUD completo: crear, actualizar y borrar datos en la base usando POST, PUT y DELETE con Dapper.

## Errores comunes y trampas

| Error | Causa | Solución |
|-------|-------|----------|
| `InvalidOperationException` | Tipo incorrecto en el record (int en vez de long, DateTime en vez de string) | Usar `long` para INTEGER, `string` para TEXT |
| `InvalidOperationException` por alias faltante | SELECT sin AS y Dapper no encuentra el constructor | Usar `SELECT patient_id AS PatientId, ...` |
| CS8803: tipo antes del código | Record declarado antes de `app.Run()` | Mover los records después de `app.Run()` |
| LIKE sin `%` | Busca coincidencia exacta en vez de parcial | `new { apellido = $"%{texto}%" }` |
| Git: `remote origin already exists` | Ya hay un remote configurado | Usar `git remote set-url origin <url>` |
| La base no se encuentra al hacer `dotnet run` | `hospital.db` no está junto al `.csproj` | Copiar el archivo a la raíz del proyecto |

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|--------|---------|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |
| **Total** | **240** |