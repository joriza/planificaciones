# Evaluación integradora del cuatrimestre 2 — Versión B

> Dominio de esta versión: estadísticas por provincia y por mes (tablas `province_names`, `patients` y `admissions` de `hospital.db`). Duración: 120 minutos. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-cuatrimestre-2.md`.

## Antes de empezar

- Trabajás sobre un único proyecto Minimal API creado con `dotnet new web`; todo el código va en `Program.cs`.
- Las Partes 1, 2 y 3 usan la base `hospital.db` con Dapper (énfasis de las Unidades 3 y 4). La Parte 4 se responde por escrito.
- El esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records: no modificarlos. Solo se agregan los endpoints pedidos.
- Convenciones del curso: rutas en inglés y plural, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Al terminar, dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion integradora cuatrimestre 2 - Version B
// Estadisticas por provincia y por mes sobre hospital.db (enfoque U3 y U4)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// GET /stats/patients-by-province -> cantidad de pacientes por provincia (30 puntos)

// ===== Parte 2: completar a partir de aqui =====
// GET /admissions/by-month?month=... -> ingresos de un mes dado (30 puntos)

// ===== Parte 3: completar a partir de aqui =====
// GET /provinces/without-patients -> provincias sin ningun paciente registrado (15 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record PatientsByProvince(string ProvinceName, int Total);
record AdmissionOfMonth(string AdmissionDate, string PatientName, string ProvinceName, string Month);
record ProvinceWithoutPatients(string ProvinceId, string ProvinceName);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `province_names` | `province_id` (TEXT, clave, por ejemplo `ON`) · `province_name` (TEXT, obligatorio) |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `gender` (TEXT `M`/`F`, obligatorio) · `birth_date` (TEXT ISO, obligatorio) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, obligatorio, referencia a `province_names`) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `admissions` | `patient_id` (INTEGER, referencia a `patients`) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors.doctor_id`) |

## Parte 1 — Estadística por provincia (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /stats/patients-by-province`: devuelve `200` con la cantidad de pacientes por provincia. Consulta con `JOIN` entre `patients` y `province_names`, `COUNT(*)` con `GROUP BY` por nombre de provincia, columnas con alias para el record `PatientsByProvince` y orden por cantidad descendente | 30 |

## Parte 2 — Consulta integrada con JOIN de tres tablas (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /admissions/by-month?month=...`: devuelve `200` con los ingresos del mes que llega por query string en formato `YYYY-MM` (por ejemplo `2018-09`). Si el mes falta o viene vacío, responde `400` con un mensaje en español. Consulta con `JOIN` de tres tablas (`admissions` + `patients` + `province_names`), filtro con `strftime('%Y-%m', ...)` parametrizado, nombre completo del paciente armado en el SELECT concatenando nombre y apellido, mapeo al record `AdmissionOfMonth` y orden por fecha de ingreso | 30 |

## Parte 3 — Consulta con subconsulta (15 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /provinces/without-patients`: devuelve `200` con las provincias que no tienen ningún paciente registrado en `patients`. Consulta con subconsulta (`NOT IN` sobre los `province_id` de `patients`), columnas con alias para el record `ProvinceWithoutPatients` y orden por nombre de provincia | 15 |

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
