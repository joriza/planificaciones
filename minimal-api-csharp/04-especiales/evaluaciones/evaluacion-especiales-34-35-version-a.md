# Evaluación del momento especial 34-35 — Versión A

> Dominio de esta versión: ingresos hospitalarios con el médico y el paciente de cada uno (tablas `admissions` + `patients` + `doctors` de `hospital.db`). Duración: 90 minutos de resolución (Parte 1, 45 min · Parte 2, 35 min · cierre, 10 min). Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. El criterio Apto / No apto aún por objetivo mínimo está en `evaluacion-especiales-34-35.md`.

## Antes de empezar

- La Parte 1 se resuelve en un proyecto nuevo creado con `dotnet new web`: reemplazás el `Program.cs` por el esqueleto provisto, copiás `hospital.db` junto al `.csproj` y agregás los paquetes `Microsoft.Data.Sqlite` y `Dapper`.
- La Parte 2 se resuelve sobre el repositorio del grupo en GitHub: creás tu issue, tu rama y tu pull request propios; `main` está protegida y el pull request **no se fusiona**.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, alias `AS` en cada columna, records al final del archivo, comentarios en español sin tildes.
- Al terminar, dejás el `Program.cs` de la Parte 1 guardado en la carpeta indicada y avisás al docente.

## Material provisto 1 — Esqueleto de `Program.cs` (Parte 1)

```csharp
// Program.cs - Evaluacion del momento especial 34-35 - Version A
// Parte 1: ingresos atendidos por un medico (JOIN triple sobre hospital.db)
// Parte 2: sobre el repositorio del grupo (issue + rama + PR), no en este archivo

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// GET /doctors/{id:long}/admissions
//   -> 200 con los ingresos atendidos por ese medico
//      (cada fila: fecha de ingreso, diagnostico y nombre del paciente),
//      ordenados por fecha, de la mas reciente a la mas antigua
//   -> 404 con mensaje en espanol si el medico no existe

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string PatientName);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `admissions` | `patient_id` (INTEGER) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors.doctor_id`) |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT) · `last_name` (TEXT) · `gender` (TEXT) · `birth_date` (TEXT ISO) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT) · `last_name` (TEXT) · `specialty` (TEXT) |

## Parte 1 — Endpoint con JOIN triple (45 minutos)

| Ítem | Consigna |
| --- | --- |
| único | Endpoint `GET /doctors/{id:long}/admissions`: devuelve `200` con todos los ingresos atendidos por ese médico, cada fila con la fecha de ingreso, el diagnóstico y el nombre completo del paciente (`nombre apellido`), ordenados por fecha descendente. Si el médico no existe, responde `404` con un mensaje en español y sin ejecutar la consulta de ingresos. La consulta une las tres tablas (`admissions` + `patients` + `doctors`), usa el parámetro `@Id`, alias `AS` por columna y mapea al record `AdmissionOfDoctor` provisto |

Casos para probar tu endpoint antes de avisar al docente:

- Un médico que tenga ingresos (por ejemplo el médico `3`): esperar `200` con su lista.
- Un id que no existe (por ejemplo `9999`): esperar `404` con mensaje.

## Parte 2 — Issue y pull request de arreglo (35 minutos)

El grupo recibió este reporte y este código quedó guardado en el archivo `defecto-<tu-inicial>.cs` de la carpeta `especiales-34-35/` del repositorio:

```csharp
// Snippet provisto: el detalle de un paciente no responde.
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.QueryFirstOrDefault<PatientDetail>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName
          FROM patients
          WHERE patient_id = @id",
        new { id });

    return patient is null
        ? Results.NotFound(new { mensaje = "No existe el paciente" })
        : Results.Ok(patient);
});

record PatientDetail(int PatientId, string FirstName, string LastName);
```

Síntoma reportado: `GET /patients/12` responde `500` en lugar del detalle del paciente.

Pasos que se evalúan, en este orden:

| # | Paso |
| --- | --- |
| 1 | Crear en el repositorio del grupo un **issue** con título breve, descripción del síntoma y **criterios de aceptación** como lista de verificación: el detalle de un paciente existente responde `200`; un id inexistente responde `404` con mensaje; la causa del `500` queda corregida; el commit referencia el issue |
| 2 | Crear la rama `feature/fix-eval-<tu-inicial>` desde `main` actualizada (`git switch main`, `git pull`, `git switch -c ...`) |
| 3 | Detectar el defecto, corregirlo en el archivo `defecto-<tu-inicial>.cs` y verificar los criterios de aceptación probando el endpoint |
| 4 | Hacer commit(s) con el número del issue entre paréntesis, por ejemplo `(#3): fix de mapeo del id del paciente` |
| 5 | Hacer push de la rama y abrir el **pull request** vinculado al issue. **No fusionar**: `main` está protegida y el PR queda abierto para la revisión del docente |

## Cierre y entrega

- El `Program.cs` de la Parte 1 queda guardado en la carpeta indicada de la máquina.
- El pull request de la Parte 2 queda abierto, con su issue vinculado y los commits referenciándolo.
- Avisar al docente al terminar o al agotarse el tiempo: se registra la evidencia parcial alcanzada.
