# Evaluación de la Unidad 2 — Versión A

> Dominio de esta versión: médicos e ingresos (tablas `doctors` y `admissions` de `hospital.db`). Duración: 90 minutos, dentro del Encuentro 15. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-u2.md`.

## Antes de empezar

- Trabajás sobre un único proyecto creado con `dotnet new web`; todo el código va en `Program.cs`.
- El esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records al final: no modificarlos. Solo se agregan los endpoints pedidos.
- La base `hospital.db` la provee el docente: copiala junto al `.csproj`.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Al terminar, dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion Unidad 2 - Version A
// Dominio: medicos e ingresos de hospital.db (tablas doctors y admissions)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// GET /doctors/{id:long} -> 200 con el medico o 404 con mensaje (15 puntos)

// ===== Parte 2: completar a partir de aqui =====
// GET /doctors/search?text=... -> medicos cuya especialidad contiene el texto (25 puntos)

// ===== Parte 3: completar a partir de aqui =====
// GET /doctors/{id:long}/admissions -> ingresos atendidos por un medico (25 puntos)

// ===== Parte 4: completar a partir de aqui =====
// POST /doctors -> valida los campos, inserta y responde 201 o 400 (20 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
record DoctorInput(string FirstName, string LastName, string Specialty);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `specialty` (TEXT, obligatorio) |
| `admissions` | `patient_id` (INTEGER, referencia a `patients`) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors.doctor_id`) |

## Parte 1 — Detalle de un médico (15 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /doctors/{id:long}`: devuelve `200` con el médico cuyo id llega por la ruta, o `404` con un mensaje si no existe. Consulta parametrizada con `QueryFirstOrDefault` y columnas con alias para el record `Doctor` | 15 |

## Parte 2 — Búsqueda de médicos por especialidad (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /doctors/search?text=...`: devuelve los médicos cuya `specialty` contiene el texto que llega por query string (búsqueda parcial con `LIKE`). Si falta el texto responde `400` con mensaje; si no hay resultados responde `404` con mensaje; con resultados responde `200` con la lista ordenada | 25 |

## Parte 3 — Ingresos atendidos por un médico (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /doctors/{id:long}/admissions`: devuelve `200` con todos los ingresos atendidos por ese médico. Consulta con `JOIN` de dos tablas (`admissions` + `doctors`), mapeada al record `AdmissionOfDoctor` (con el nombre completo del médico), ordenada por fecha de ingreso | 25 |

## Parte 4 — Alta de médicos en la base (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `POST /doctors`: recibe el médico por cuerpo (`DoctorInput`), valida que nombre, apellido y especialidad no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado, obtiene el id generado y responde `201` con la URL del nuevo médico | 20 |

## Parte 5 — Ítems conceptuales (15 puntos)

Responder por escrito, con tus palabras.

### C1. Parametrización (8 puntos)

En la Parte 2, el texto que llega por query string se usa así: `WHERE specialty LIKE @patron` con `new { patron = $"%{text}%" }`.

a) ¿Qué problema de seguridad evita pasar el valor como parámetro, y cuál es la regla del curso sobre el SQL? (4 puntos)

b) Además de la seguridad, ¿qué le pasaría a la consulta si el texto viniera pegado con `+` y el cliente buscara `O'Brien`? (4 puntos)

### C2. Alias `AS` (7 puntos)

Todos los `SELECT` de esta prueba renombran cada columna: `SELECT doctor_id AS DoctorId, ...`.

a) ¿Por qué este curso necesita ese alias para mapear el resultado a un record? (4 puntos)

b) Si falta el alias en una columna, ¿qué se observa en la respuesta JSON? (3 puntos)

## Salidas esperadas

La API corre con `dotnet run` (el puerto lo informa la terminal; los ejemplos usan `5080`). Los valores de fila dependen de la copia de `hospital.db`; lo que se verifica en cada pedido son los códigos de estado y la forma del JSON.

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/doctors/3` | `200` con un objeto `{"doctorId":3,"firstName":"...","lastName":"...","specialty":"..."}` |
| `GET http://localhost:5080/doctors/99999` | `404` con `{"mensaje":"..."}` |
| `GET http://localhost:5080/doctors/search?text=cardio` | `200` con los médicos cuya especialidad contiene «cardio» (en JSON camelCase) |
| `GET http://localhost:5080/doctors/search` | `400` con `{"mensaje":"..."}` (faltó el texto) |
| `GET http://localhost:5080/doctors/search?text=zzz` | `404` con `{"mensaje":"..."}` (el pedido era válido, no hay resultados) |
| `GET http://localhost:5080/doctors/7/admissions` | `200` con `[{"admissionDate":"...","diagnosis":"...","doctorName":"Nombre Apellido"}, ...]`, ordenados por fecha (lista vacía si el médico no tiene ingresos) |
| `POST http://localhost:5080/doctors` con `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` | `201`, encabezado `Location` con la URL del nuevo médico, cuerpo con el id generado |
| `POST http://localhost:5080/doctors` con `{"firstName":"Ana","lastName":"","specialty":"Cardiologist"}` | `400` con `{"mensaje":"..."}` |

La escritura se prueba con `curl` (una línea; en PowerShell usar `curl.exe`):

```powershell
curl.exe -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"
```
