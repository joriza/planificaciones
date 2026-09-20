# Evaluación del momento especial 17-18 — Versión A

> Dominio de esta versión: médicos y especialidades (tablas `doctors` y `admissions` de `hospital.db`). Duración: 90 minutos de resolución + 15 minutos de entrega. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-especiales-17-18.md`.

## Antes de empezar

- Vas a crear un único proyecto Minimal API con `dotnet new web`; todo el código va en `Program.cs`.
- El esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records: no modificarlos. Solo se agregan los endpoints pedidos.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Cada ítem se verifica con su caso de prueba antes de pasar al siguiente (navegador para GET, `curl` para POST).
- Al terminar, subí el trabajo a la carpeta `especial-17-18/` del repositorio del grupo, con commits referentes y push (Ítem 6).

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Momento especial 17-18 - Version A
// Nucleos de las Unidades 1 y 2 sobre hospital.db: medicos y sus ingresos

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2: completar a partir de aqui =====
// GET /doctors/{id:long} -> 200 con el medico o 404 con mensaje

// ===== Item 3: completar a partir de aqui =====
// GET /doctors?specialty=... -> 400 si el texto llega vacio;
// 200 con los medicos cuya especialidad contiene el texto

// ===== Item 4: completar a partir de aqui =====
// GET /doctors/{id:long}/admissions -> 200 con los ingresos del medico

// ===== Item 5: completar a partir de aqui =====
// POST /doctors -> valida los campos, inserta y responde 201 o 400

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record DoctorCard(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
record DoctorInput(string FirstName, string LastName, string Specialty);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `specialty` (TEXT, obligatorio) |
| `admissions` | `patient_id` (INTEGER) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors.doctor_id`) |

## Ítem 1 — Proyecto en marcha (OM1)

| Paso | Consigna |
| --- | --- |
| 1 | Crear el proyecto con `dotnet new web` en la carpeta indicada por el docente |
| 2 | Agregar los paquetes `Microsoft.Data.Sqlite` y `Dapper` con `dotnet add package` |
| 3 | Copiar `hospital.db` junto al `.csproj` |
| 4 | Reemplazar el `Program.cs` por el esqueleto provisto, correr con `dotnet run` y verificar en la terminal que la API quedó escuchando (y saber detenerla con `Ctrl+C`) |

## Ítem 2 — Médico por id (OM2, OM3)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 2 | Endpoint `GET /doctors/{id:long}`: devuelve `200` con el médico (`DoctorCard`) cuyo id llega por la ruta, o `404` con un mensaje si no existe. Probar los dos casos en el navegador | OM2, OM3 |

## Ítem 3 — Búsqueda por especialidad (OM4, OM3)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 3 | Endpoint `GET /doctors?specialty=...`: devuelve `200` con los médicos cuya especialidad **contiene** el texto que llega por query string. Si el texto llega vacío, responde `400` con un mensaje. Búsqueda parcial con `LIKE`, consulta parametrizada y columnas con alias para el record `DoctorCard` | OM4, OM3 |

## Ítem 4 — Ingresos del médico (OM5)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 4 | Endpoint `GET /doctors/{id:long}/admissions`: devuelve `200` con todos los ingresos atendidos por ese médico. Consulta con `JOIN` de dos tablas (`admissions` + `doctors`), mapeada al record `AdmissionOfDoctor` y ordenada por fecha de ingreso | OM5 |

## Ítem 5 — Alta de médico (OM6, OM3)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 5 | Endpoint `POST /doctors`: recibe un médico por cuerpo (`DoctorInput`), valida que nombre, apellido y especialidad no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado, obtiene el id generado y responde `201` con la URL del nuevo médico | OM6, OM3 |

## Ítem 6 — Entrega por GitHub (OM7)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 6 | Subir el trabajo a la carpeta `especial-17-18/` del repositorio del grupo en GitHub: commits referentes por ítem (formato del curso: `especial-17-18: resumen de lo hecho`) y push final | OM7 |
