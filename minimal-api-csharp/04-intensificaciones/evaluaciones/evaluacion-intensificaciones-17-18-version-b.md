# Evaluación del momento de intensificación y fortalecimiento 17-18 — Versión B

> Dominio de esta versión: pacientes y ciudades (tablas `patients` y `admissions` de `hospital.db`). Duración: 90 minutos de resolución + 15 minutos de entrega. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-intensificaciones-17-18.md`.

## Antes de empezar

- Vas a crear un único proyecto Minimal API con `dotnet new web`; todo el código va en `Program.cs`.
- El esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records: no modificarlos. Solo se agregan los endpoints pedidos.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Cada ítem se verifica con su caso de prueba antes de pasar al siguiente (navegador para GET, `curl` para POST).
- Al terminar, subí el trabajo a la carpeta `intensificaciones-17-18/` del repositorio del grupo, con commits referentes y push (Ítem 6).

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - intensificaciones-17-18 - Version B
// Nucleos de las Unidades 1 y 2 sobre hospital.db: pacientes y sus ingresos

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Item 2: completar a partir de aqui =====
// GET /patients/{id:long} -> 200 con el paciente o 404 con mensaje

// ===== Item 3: completar a partir de aqui =====
// GET /patients?city=... -> 400 si el texto llega vacio;
// 200 con los pacientes cuya ciudad contiene el texto

// ===== Item 4: completar a partir de aqui =====
// GET /patients/{id:long}/admissions -> 200 con los ingresos del paciente

// ===== Item 5: completar a partir de aqui =====
// POST /patients -> valida los campos, inserta y responde 201 o 400

app.Run();   // Deja la API escuchando pedidos

// ---- Records provistos por la prueba: SIEMPRE al final del archivo ----
record PatientCard(long PatientId, string FirstName, string LastName, string? City);
record AdmissionOfPatient(string AdmissionDate, string? Diagnosis, string PatientName);
record PatientInput(string FirstName, string LastName, string Gender, string BirthDate, string ProvinceId);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `gender` (TEXT, obligatorio) · `birth_date` (TEXT ISO, obligatorio) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, obligatorio) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `admissions` | `patient_id` (INTEGER, referencia a `patients.patient_id`) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER) |

## Ítem 1 — Proyecto en marcha (OM1)

| Paso | Consigna |
| --- | --- |
| 1 | Crear el proyecto con `dotnet new web` en la carpeta indicada por el docente |
| 2 | Agregar los paquetes `Microsoft.Data.Sqlite` y `Dapper` con `dotnet add package` |
| 3 | Copiar `hospital.db` junto al `.csproj` |
| 4 | Reemplazar el `Program.cs` por el esqueleto provisto, correr con `dotnet run` y verificar en la terminal que la API quedó escuchando (y saber detenerla con `Ctrl+C`) |

## Ítem 2 — Paciente por id (OM2, OM3)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 2 | Endpoint `GET /patients/{id:long}`: devuelve `200` con el paciente (`PatientCard`) cuyo id llega por la ruta, o `404` con un mensaje si no existe. Probar los dos casos en el navegador | OM2, OM3 |

## Ítem 3 — Búsqueda por ciudad (OM4, OM3)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 3 | Endpoint `GET /patients?city=...`: devuelve `200` con los pacientes cuya ciudad **contiene** el texto que llega por query string. Si el texto llega vacío, responde `400` con un mensaje. Búsqueda parcial con `LIKE`, consulta parametrizada y columnas con alias para el record `PatientCard` | OM4, OM3 |

## Ítem 4 — Ingresos del paciente (OM5)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 4 | Endpoint `GET /patients/{id:long}/admissions`: devuelve `200` con todos los ingresos de ese paciente. Consulta con `JOIN` de dos tablas (`admissions` + `patients`), mapeada al record `AdmissionOfPatient` y ordenada por fecha de ingreso | OM5 |

## Ítem 5 — Alta de paciente (OM6, OM3)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 5 | Endpoint `POST /patients`: recibe un paciente por cuerpo (`PatientInput`), valida que los cinco campos obligatorios de la tabla (`first_name`, `last_name`, `gender`, `birth_date`, `province_id`) no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado, obtiene el id generado y responde `201` con la URL del nuevo paciente | OM6, OM3 |

## Ítem 6 — Entrega por GitHub (OM7)

| Ítem | Consigna | Objetivo |
| --- | --- | --- |
| 6 | Subir el trabajo a la carpeta `intensificaciones-17-18/` del repositorio del grupo en GitHub: commits referentes por ítem (formato del curso: `intensificaciones-17-18: resumen de lo hecho`) y push final | OM7 |
