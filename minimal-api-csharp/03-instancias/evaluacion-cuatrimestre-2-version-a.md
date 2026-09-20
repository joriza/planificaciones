# Evaluación integradora del cuatrimestre 2 — Versión A

> Dominio de esta versión: estadísticas por especialidad (tablas `doctors` y `admissions` de `hospital.db`). Duración: 120 minutos. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-cuatrimestre-2.md`.

## Antes de empezar

- Trabajás sobre un único proyecto Minimal API creado con `dotnet new web`; todo el código va en `Program.cs`.
- Las Partes 1, 2 y 3 usan la base `hospital.db` con Dapper (énfasis de las Unidades 3 y 4). La Parte 4 se responde por escrito.
- El esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records: no modificarlos. Solo se agregan los endpoints pedidos.
- Convenciones del curso: rutas en inglés y plural, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Al terminar, dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion integradora cuatrimestre 2 - Version A
// Estadisticas por especialidad sobre hospital.db (enfoque U3 y U4)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// GET /stats/admissions-by-specialty -> cantidad de ingresos por especialidad (30 puntos)

// ===== Parte 2: completar a partir de aqui =====
// GET /admissions/by-specialty?text=... -> ingresos de medicos de esa especialidad (30 puntos)

// ===== Parte 3: completar a partir de aqui =====
// GET /doctors/without-admissions -> medicos sin ningun ingreso registrado (15 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record AdmissionsBySpecialty(string Specialty, int Total);
record AdmissionOfSpecialty(string AdmissionDate, string PatientName, string DoctorName, string Specialty);
record DoctorWithoutAdmissions(string FirstName, string LastName, string Specialty);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `specialty` (TEXT, obligatorio) |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `gender` (TEXT `M`/`F`, obligatorio) · `birth_date` (TEXT ISO, obligatorio) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, obligatorio) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `admissions` | `patient_id` (INTEGER, referencia a `patients`) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors.doctor_id`) |

## Parte 1 — Estadística por especialidad (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /stats/admissions-by-specialty`: devuelve `200` con la cantidad de ingresos por especialidad médica. Consulta con `JOIN` entre `admissions` y `doctors`, `COUNT(*)` con `GROUP BY` por especialidad, columnas con alias para el record `AdmissionsBySpecialty` y orden por cantidad descendente | 30 |

## Parte 2 — Consulta integrada con JOIN de tres tablas (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /admissions/by-specialty?text=...`: devuelve `200` con los ingresos atendidos por médicos cuya especialidad contiene el texto que llega por query string. Si el texto falta o viene vacío, responde `400` con un mensaje en español. Consulta con `JOIN` de tres tablas (`admissions` + `patients` + `doctors`), filtro con `LIKE` parametrizado, nombre completo de paciente y de médico armado en el SELECT con el operador `\|\|`, mapeo al record `AdmissionOfSpecialty` y orden por fecha de ingreso | 30 |

## Parte 3 — Consulta con subconsulta (15 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /doctors/without-admissions`: devuelve `200` con los médicos que no tienen ningún ingreso registrado en `admissions`. Consulta con subconsulta (`NOT IN` sobre los `attending_doctor_id` de `admissions`), columnas con alias para el record `DoctorWithoutAdmissions` y orden por apellido | 15 |

## Parte 4 — Ítems conceptuales (25 puntos)

Responder por escrito, con tus palabras.

### C1. Del año: memoria, base y datos sucios (10 puntos)

a) En la Unidad 1 los datos vivían en una lista en memoria y desde la Unidad 2 viven en `hospital.db`. ¿Qué diferencia aparece al cortar la API con `Ctrl+C` y volver a correr `dotnet run`? (3 puntos)

b) La base tiene ingresos reales con fecha de alta `'1971-01-05'`, anterior a la propia fecha de ingreso. ¿Cómo los detectarías con una consulta SQL? (3 puntos)

c) ¿Qué devuelve `COALESCE(diagnosis, 'Sin diagnostico')` en un SELECT y para qué sirve al exponer datos? (4 puntos)

### C2. Configuración y publicación (8 puntos)

a) ¿Por qué conviene mover la cadena de conexión de `Program.cs` a `appsettings.json`? ¿Qué garantiza el `?? "Data Source=hospital.db"` de la lectura? (4 puntos)

b) ¿Qué hace `dotnet publish -c Release` y por qué hay que copiar `hospital.db` a la carpeta `publish` antes de correr la API publicada? (4 puntos)

### C3. Flujo profesional con GitHub (7 puntos)

a) Ordenar los pasos del flujo profesional del trabajo final: abrir el pull request · crear la rama `feature/...` · crear el issue con sus criterios · fusionar a `main` · commitear en la rama · revisión y aprobación de un compañero. (3 puntos)

b) ¿Qué hace `Closes #3` escrita en la descripción de un pull request? (2 puntos)

c) ¿Qué significa que `main` esté protegida y qué exige cada cambio? (2 puntos)
