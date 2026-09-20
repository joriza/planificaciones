# Evaluación de la Unidad 3 — Versión A

> Dominio de esta versión: especialidades (tablas `admissions` + `doctors`, con `patients` en el JOIN triple de `hospital.db`). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-u3.md`.

## Antes de empezar

- Creá el proyecto y prepará todo antes de escribir endpoints: `dotnet new web -n HospitalApi`, `dotnet add package Microsoft.Data.Sqlite`, `dotnet add package Dapper`, y copiá `hospital.db` a la raíz del proyecto (junto al `.csproj`).
- Todo el código va en `Program.cs`: pegá el esqueleto de abajo tal cual. **No se modifican** los `using`, la lectura de la cadena de conexión, los comentarios de consigna ni los records provistos. Solo se agregan los endpoints pedidos donde indica cada parte.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- La Parte 4 se responde **por escrito, con tus palabras**, en la hoja de la prueba.
- Al terminar (o al agotarse el tiempo), dejá el `Program.cs` guardado en la carpeta indicada y avisá al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion Unidad 3 - Version A
// Dominio: especialidades (admissions + doctors, con patients en el JOIN triple)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API

// La cadena vive en appsettings.json (clase 24). Si la clave falta,
// el ?? entrega la cadena canonica y la API arranca igual.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();                          // Construye la aplicacion

// ===== Parte 1: completar a partir de aqui (30 puntos) =====
// GET /doctors/{id:long}/admissions -> ingresos atendidos por un medico,
// JOIN triple admissions + patients + doctors. Medico inexistente -> 404.

// ===== Parte 2: completar a partir de aqui (25 puntos) =====
// GET /stats/stay-by-specialty -> por especialidad: cantidad de ingresos con
// alta y promedio de dias de internacion (COUNT y AVG con GROUP BY).

// ===== Parte 3: completar a partir de aqui (25 puntos) =====
// GET /admissions/strange-discharges -> altas imposibles: con fecha de alta,
// pero de 1971 o anteriores al propio ingreso.

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);

record SpecialtyStay(string Specialty, int TotalAdmissions, double AvgDays);

record StrangeDischarge(long PatientId, string AdmissionDate, string DischargeDate, string DoctorName, string DoctorSpecialty);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT) · `last_name` (TEXT) · `specialty` (TEXT) |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT) · `last_name` (TEXT) · `birth_date` (TEXT ISO) |
| `admissions` | `patient_id` (INTEGER, referencia a patients) · `admission_date` (TEXT ISO, obligatoria) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a doctors) |

## Parte 1 — Ingresos atendidos por un médico (30 puntos)

Endpoint `GET /doctors/{id:long}/admissions`: cada ingreso atendido por ese médico, con el nombre del paciente, el nombre del médico y su especialidad. Consulta con **JOIN de tres tablas** (`admissions` + `patients` + `doctors`), mapeada al record `AdmissionDetail` (el nombre completo se arma en el SELECT con `||`), ordenada por fecha de ingreso descendente. Si el médico no existe, el endpoint responde `404` con un mensaje en español; la verificación de existencia va **antes** de la consulta del JOIN.

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Ruta `GET /doctors/{id:long}/admissions` con el parámetro tipado en el handler | 4 |
| b | Verificación de existencia del médico antes de la consulta (el id no está → `404` con mensaje) | 10 |
| c | JOIN triple con los dos `ON` correctos y columnas calificadas con alias de tabla | 8 |
| d | DTO mapeado con alias `AS` en cada columna, nombre completo armado con `\|\|`, orden por fecha descendente y respuesta `200` con `Results.Ok` | 8 |

Salida esperada (estructura; los valores concretos dependen de la base):

```json
[
  {
    "admissionDate": "2019-06-02",
    "dischargeDate": "1971-01-05",
    "patientName": "Morgan Harkness",
    "doctorName": "Joshua Green",
    "doctorSpecialty": "Cardiologist"
  }
]
```

## Parte 2 — Días de internación por especialidad (25 puntos)

Endpoint `GET /stats/stay-by-specialty`: por cada especialidad, la **cantidad** de ingresos con alta y el **promedio** de días de internación. Consulta con JOIN (`admissions` + `doctors`), `GROUP BY` por especialidad, `COUNT(*)` y `AVG` de la duración calculada en el motor con `julianday(discharge_date) - julianday(admission_date)`, redondeada a 1 decimal. Los ingresos sin alta no tienen duración: quedan afuera. Ordenada de mayor a menor cantidad de ingresos. Mapeada al record `SpecialtyStay` (el conteo es `int`, el promedio `double`).

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Ruta `GET /stats/stay-by-specialty` | 3 |
| b | JOIN `admissions` + `doctors` con `ON` correcto | 4 |
| c | `GROUP BY` por especialidad con `COUNT(*)` | 8 |
| d | Exclusión de los ingresos sin alta y `ROUND(AVG(julianday(...) - julianday(...)), 1)` | 6 |
| e | Orden por el total descendente y `200` con `Results.Ok` mapeado a `SpecialtyStay` | 4 |

Salida esperada (una fila por especialidad, la de más ingresos primero):

```json
[
  {
    "specialty": "Cardiovascular Surgeon",
    "totalAdmissions": 47,
    "avgDays": -372.2
  }
]
```

Observación: un promedio negativo no es un error del endpoint. Hay altas imposibles mezcladas entre los datos reales: exactamente las que audita la Parte 3.

## Parte 3 — Auditoría de altas imposibles (25 puntos)

Endpoint `GET /admissions/strange-discharges`: los ingresos cuya fecha de alta es **imposible** — tienen alta registrada, pero es del año 1971 o es **anterior** a la propia fecha de ingreso. Consulta sobre `admissions` con JOIN a `doctors` (para mostrar el médico y su especialidad de cada fila sospechosa), mapeada al record `StrangeDischarge`, ordenada por fecha de alta.

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Ruta `GET /admissions/strange-discharges` | 3 |
| b | JOIN a `doctors` con alias calificados hacia `StrangeDischarge` | 5 |
| c | Filtro del dato sucio: alta presente (`IS NOT NULL`) y, entre paréntesis, `1971` o anterior al ingreso | 8 |
| d | Tipos del record consistentes con lo que garantiza el filtro (ninguna propiedad de fecha queda en `null`) | 4 |
| e | Orden por fecha de alta y `200` con `Results.Ok` | 3 |
| f | Alias `AS` completos en todas las columnas del SELECT | 2 |

Salida esperada (lista con las filas imposibles; puede ser corta, pero no vacía en la base del curso):

```json
[
  {
    "patientId": 35,
    "admissionDate": "2019-06-05",
    "dischargeDate": "1971-01-05",
    "doctorName": "Mickey Duval",
    "doctorSpecialty": "Pediatrician"
  }
]
```

## Parte 4 — Ítems conceptuales (20 puntos)

Responder por escrito, con tus palabras.

### C1. Consultas parametrizadas (6 puntos)

En los tres endpoints de la prueba el valor del filtro llega con un marcador `@Id` y un objeto anónimo. ¿Por qué el curso exige parametrizar en lugar de concatenar el valor dentro del texto del SQL? Dar las dos razones vistas en clase.

### C2. Qué devuelve una agregación (7 puntos)

En la Parte 2, la consulta lleva `COUNT(*)` y `AVG(...)` con `GROUP BY d.specialty`:

a) ¿Cuántas filas devuelve la consulta y qué representa cada fila? (4 puntos)

b) Si la misma consulta **sin** `GROUP BY` pero con `COUNT(*)` y `AVG(...)`, ¿cuántas filas devolvería y qué representarían? (3 puntos)

### C3. Subconsulta simple (7 puntos)

En la clase 23 se construyó el endpoint de «pacientes con más de N ingresos»: una consulta de pacientes que adentro cuenta los ingresos de cada uno con una subconsulta. ¿Qué es una subconsulta y qué aporta la subconsulta escalar correlacionada en ese endpoint: de dónde toma el dato y cómo se usa su resultado?
