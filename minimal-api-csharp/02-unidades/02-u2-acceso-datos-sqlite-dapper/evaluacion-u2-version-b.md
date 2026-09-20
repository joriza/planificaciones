# Evaluación de la Unidad 2 — Versión B

> Dominio de esta versión: pacientes y provincias (tablas `patients` y `province_names` de `hospital.db`). Duración: 90 minutos, dentro del Encuentro 15. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-u2.md`.

## Antes de empezar

- Trabajás sobre un único proyecto creado con `dotnet new web`; todo el código va en `Program.cs`.
- El esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records al final: no modificarlos. Solo se agregan los endpoints pedidos.
- La base `hospital.db` la provee el docente: copiala junto al `.csproj`.
- Convenciones del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Al terminar, dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion Unidad 2 - Version B
// Dominio: pacientes y provincias de hospital.db (tablas patients y province_names)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// GET /patients/{id:long} -> 200 con el paciente o 404 con mensaje (15 puntos)

// ===== Parte 2: completar a partir de aqui =====
// GET /patients/search?text=... -> pacientes cuya ciudad contiene el texto (25 puntos)

// ===== Parte 3: completar a partir de aqui =====
// GET /provinces/{provinceId}/patients -> pacientes de una provincia (25 puntos)

// ===== Parte 4: completar a partir de aqui =====
// POST /patients -> valida los campos, inserta y responde 201 o 400 (20 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record PatientCard(long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City);
record PatientInProvince(string FirstName, string LastName, string? City, string ProvinceName);
record PatientInput(string FirstName, string LastName, string Gender, string BirthDate,
    string ProvinceId);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `gender` (TEXT, obligatorio) · `birth_date` (TEXT ISO, obligatorio) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, obligatorio, referencia a `province_names.province_id`) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `province_names` | `province_id` (TEXT, clave: código como `ON`) · `province_name` (TEXT, obligatorio: nombre completo como `Ontario`) |

## Parte 1 — Detalle de un paciente (15 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /patients/{id:long}`: devuelve `200` con el paciente cuyo id llega por la ruta, o `404` con un mensaje si no existe. Consulta parametrizada con `QueryFirstOrDefault` y columnas con alias para el record `PatientCard` | 15 |

## Parte 2 — Búsqueda de pacientes por ciudad (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /patients/search?text=...`: devuelve los pacientes cuya `city` contiene el texto que llega por query string (búsqueda parcial con `LIKE`). Si falta el texto responde `400` con mensaje; si no hay resultados responde `404` con mensaje; con resultados responde `200` con la lista ordenada | 25 |

## Parte 3 — Pacientes de una provincia (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `GET /provinces/{provinceId}/patients`: devuelve `200` con todos los pacientes de esa provincia (el código llega por la ruta, por ejemplo `ON`). Consulta con `JOIN` de dos tablas (`patients` + `province_names`), mapeada al record `PatientInProvince` (con el nombre completo de la provincia), ordenada por apellido | 25 |

## Parte 4 — Alta de pacientes en la base (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `POST /patients`: recibe el paciente por cuerpo (`PatientInput`), valida que los cinco campos no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado (solo esas cinco columnas; el resto queda sin dato), obtiene el id generado y responde `201` con la URL del nuevo paciente. El código de provincia debe ser uno existente en `province_names` (por ejemplo `ON`) | 20 |

## Parte 5 — Ítems conceptuales (15 puntos)

Responder por escrito, con tus palabras.

### C1. Parametrización (8 puntos)

En la Parte 2, el texto que llega por query string se usa así: `WHERE city LIKE @patron` con `new { patron = $"%{text}%" }`.

a) ¿Qué problema de seguridad evita pasar el valor como parámetro, y cuál es la regla del curso sobre el SQL? (4 puntos)

b) Además de la seguridad, ¿qué le pasaría a la consulta si el texto viniera pegado con `+` y el cliente buscara `O'Brien`? (4 puntos)

### C2. Alias `AS` (7 puntos)

Todos los `SELECT` de esta prueba renombran cada columna: `SELECT patient_id AS PatientId, ...`.

a) ¿Por qué este curso necesita ese alias para mapear el resultado a un record? (4 puntos)

b) Si falta el alias en una columna, ¿qué se observa en la respuesta JSON? (3 puntos)

## Salidas esperadas

La API corre con `dotnet run` (el puerto lo informa la terminal; los ejemplos usan `5080`). Los valores de fila dependen de la copia de `hospital.db`; lo que se verifica en cada pedido son los códigos de estado y la forma del JSON.

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/patients/7` | `200` con un objeto `{"patientId":7,"firstName":"...","lastName":"...","gender":"...","birthDate":"...","city":"..."}` |
| `GET http://localhost:5080/patients/99999` | `404` con `{"mensaje":"..."}` |
| `GET http://localhost:5080/patients/search?text=tor` | `200` con los pacientes cuya ciudad contiene «tor» (en JSON camelCase) |
| `GET http://localhost:5080/patients/search` | `400` con `{"mensaje":"..."}` (faltó el texto) |
| `GET http://localhost:5080/patients/search?text=zzz` | `404` con `{"mensaje":"..."}` (el pedido era válido, no hay resultados) |
| `GET http://localhost:5080/provinces/ON/patients` | `200` con `[{"firstName":"...","lastName":"...","city":"...","provinceName":"Ontario"}, ...]`, ordenados por apellido |
| `GET http://localhost:5080/provinces/ZZ/patients` | `200` con `[]` (el cruce no encontró pacientes con ese código) |
| `POST http://localhost:5080/patients` con los cinco campos válidos | `201`, encabezado `Location` con la URL del nuevo paciente, cuerpo con el id generado |
| `POST http://localhost:5080/patients` con `{"firstName":"Ana","lastName":"","gender":"F","birthDate":"2001-03-14","provinceId":"ON"}` | `400` con `{"mensaje":"..."}` |

La escritura se prueba con `curl` (una línea; en PowerShell usar `curl.exe`):

```powershell
curl.exe -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"
```
