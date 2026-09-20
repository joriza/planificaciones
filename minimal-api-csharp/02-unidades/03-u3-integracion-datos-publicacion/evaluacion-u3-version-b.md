# Evaluación de la Unidad 3 — Versión B

> Dominio de esta versión: provincias (tablas `patients` + `province_names`, con `admissions` en el JOIN triple de `hospital.db`). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-u3.md`.

## Antes de empezar

- Creá el proyecto y prepará todo antes de escribir endpoints: `dotnet new web -n HospitalApi`, `dotnet add package Microsoft.Data.Sqlite`, `dotnet add package Dapper`, y copiá `hospital.db` a la raíz del proyecto (junto al `.csproj`).
- Todo el código va en `Program.cs`: pegá el esqueleto de abajo tal cual. **No se modifican** los `using`, la lectura de la cadena de conexión, los comentarios de consigna ni los records provistos. Solo se agregan los endpoints pedidos donde indica cada parte.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- La Parte 4 se responde **por escrito, con tus palabras**, en la hoja de la prueba.
- Al terminar (o al agotarse el tiempo), dejá el `Program.cs` guardado en la carpeta indicada y avisá al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion Unidad 3 - Version B
// Dominio: provincias (patients + province_names, con admissions en el JOIN triple)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API

// La cadena vive en appsettings.json (clase 24). Si la clave falta,
// el ?? entrega la cadena canonica y la API arranca igual.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();                          // Construye la aplicacion

// ===== Parte 1: completar a partir de aqui (30 puntos) =====
// GET /provinces/{provinceId}/admissions -> ingresos de los pacientes de una
// provincia, JOIN triple admissions + patients + province_names.
// Provincia inexistente -> 404. Ojo: la clave de provincia es TEXTO ("ON").

// ===== Parte 2: completar a partir de aqui (25 puntos) =====
// GET /stats/patients-by-province -> por provincia: cantidad de pacientes y
// altura promedio (COUNT y AVG con GROUP BY).

// ===== Parte 3: completar a partir de aqui (25 puntos) =====
// GET /admissions/open -> ingresos sin fecha de alta: los pacientes
// aun internados, con el nombre y el diagnostico siempre presente.

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record AdmissionInProvince(
    string AdmissionDate,
    string? Diagnosis,
    string PatientName,
    string ProvinceName);

record PatientsByProvince(string ProvinceName, int TotalPatients, double AvgHeight);

record OpenAdmission(string PatientName, string AdmissionDate, string Diagnosis);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT) · `last_name` (TEXT) · `height` (INTEGER, cm, puede ser NULL) · `province_id` (TEXT, referencia a province_names) |
| `province_names` | `province_id` (TEXT, clave: `"ON"`, `"BC"`, ...) · `province_name` (TEXT) |
| `admissions` | `patient_id` (INTEGER, referencia a patients) · `admission_date` (TEXT ISO, obligatoria) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) |

## Parte 1 — Ingresos de los pacientes de una provincia (30 puntos)

Endpoint `GET /provinces/{provinceId}/admissions`: cada ingreso de un paciente de esa provincia, con el nombre del paciente y el **nombre completo** de la provincia. Consulta con **JOIN de tres tablas** (`admissions` + `patients` + `province_names`), mapeada al record `AdmissionInProvince` (el nombre del paciente se arma en el SELECT con `||`), ordenada por fecha de ingreso descendente. Si la provincia no existe en `province_names`, el endpoint responde `404` con un mensaje en español; la verificación va **antes** de la consulta del JOIN. Atención: la clave de provincia es **texto** (`"ON"`), el parámetro del handler es `string provinceId`.

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Ruta `GET /provinces/{provinceId}/admissions` con `string provinceId` en el handler | 4 |
| b | Verificación de existencia de la provincia antes de la consulta (no está → `404` con mensaje) | 10 |
| c | JOIN triple con los dos `ON` correctos y columnas calificadas con alias de tabla | 8 |
| d | DTO mapeado con alias `AS` en cada columna, nombre del paciente armado con `\|\|`, orden por fecha descendente y respuesta `200` con `Results.Ok` | 8 |

Salida esperada (estructura; los valores concretos dependen de la base):

```json
[
  {
    "admissionDate": "2019-06-05",
    "diagnosis": "Possible Renal Calculi",
    "patientName": "Anthony Maxwell",
    "provinceName": "Ontario"
  }
]
```

## Parte 2 — Pacientes por provincia (25 puntos)

Endpoint `GET /stats/patients-by-province`: por cada provincia, la **cantidad** de pacientes y la **altura promedio** en cm. Consulta con JOIN (`patients` + `province_names`), `GROUP BY` por la clave `p.province_id` (la clave no se repite; el nombre se muestra en el SELECT, como en la clase 22), `COUNT(*)` y `AVG(height)` redondeada a 1 decimal. Ordenada de mayor a menor cantidad de pacientes. Mapeada al record `PatientsByProvince` (el conteo es `int`, el promedio `double`).

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Ruta `GET /stats/patients-by-province` | 3 |
| b | JOIN `patients` + `province_names` con `ON` correcto | 4 |
| c | `GROUP BY p.province_id` con `COUNT(*)` | 8 |
| d | `ROUND(AVG(p.height), 1)` con alias hacia el record | 6 |
| e | Orden por el total descendente y `200` con `Results.Ok` mapeado a `PatientsByProvince` | 4 |

Salida esperada (una fila por provincia con pacientes, la de más pacientes primero):

```json
[
  {
    "provinceName": "Ontario",
    "totalPatients": 480,
    "avgHeight": 159.5
  }
]
```

## Parte 3 — Pacientes aún internados (25 puntos)

Endpoint `GET /admissions/open`: los ingresos **sin fecha de alta** — un alta ausente no es un error: significa que el paciente todavía está internado. Consulta sobre `admissions` con JOIN a `patients` (para mostrar el nombre), filtrando con `IS NULL`, mapeada al record `OpenAdmission` y con el diagnóstico garantizado: `COALESCE(diagnosis, 'Sin diagnostico')` para que ningún `null` llegue al JSON. Ordenada por fecha de ingreso.

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Ruta `GET /admissions/open` | 3 |
| b | JOIN a `patients` con alias calificados hacia `OpenAdmission` | 5 |
| c | Filtro del dato sucio: `WHERE discharge_date IS NULL` (nunca `= NULL`) | 8 |
| d | Diagnóstico sin `null`: `COALESCE` en el SELECT y record `OpenAdmission` sin `?` en `Diagnosis` | 4 |
| e | Orden por fecha de ingreso y `200` con `Results.Ok` | 3 |
| f | Alias `AS` completos en todas las columnas del SELECT | 2 |

Salida esperada (lista con los aún internados; `diagnosis` nunca es `null`):

```json
[
  {
    "patientName": "Marcus Reed",
    "admissionDate": "2019-05-28",
    "diagnosis": "Pneumonia"
  }
]
```

## Parte 4 — Ítems conceptuales (20 puntos)

Responder por escrito, con tus palabras.

### C1. Consultas parametrizadas (6 puntos)

En los tres endpoints de la prueba el valor del filtro llega con un marcador `@Id` y un objeto anónimo. ¿Por qué el curso exige parametrizar en lugar de concatenar el valor dentro del texto del SQL? Dar las dos razones vistas en clase.

### C2. Qué devuelve una agregación (7 puntos)

En la Parte 2, la consulta lleva `COUNT(*)` y `AVG(...)` con `GROUP BY p.province_id`:

a) ¿Cuántas filas devuelve la consulta y qué representa cada fila? (4 puntos)

b) Si la misma consulta **sin** `GROUP BY` pero con `COUNT(*)` y `AVG(...)`, ¿cuántas filas devolvería y qué representarían? (3 puntos)

### C3. Subconsulta simple (7 puntos)

En la clase 23 se construyó el endpoint de «pacientes con más de N ingresos»: una consulta de pacientes que adentro cuenta los ingresos de cada uno con una subconsulta. ¿Qué es una subconsulta y qué aporta la subconsulta escalar correlacionada en ese endpoint: de dónde toma el dato y cómo se usa su resultado?
