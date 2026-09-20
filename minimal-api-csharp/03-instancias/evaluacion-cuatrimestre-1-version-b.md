# Evaluación integradora del cuatrimestre 1 — Versión B

> Dominio de esta versión: pacientes y ciudades (tablas `patients` y `province_names` de `hospital.db`). Duración: 120 minutos. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-cuatrimestre-1.md`.

## Antes de empezar

- Trabajás sobre un único proyecto Minimal API creado con `dotnet new web`; todo el código va en `Program.cs`.
- La Parte 1 usa una lista en memoria (Unidad 1). Las Partes 2 y 3 usan la base `hospital.db` con Dapper (Unidad 2). La Parte 4 se responde por escrito.
- El esqueleto provisto ya trae los `using`, la lista base, la cadena de conexión y todos los records: no modificarlos. Solo se agregan los endpoints pedidos.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Al terminar, dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion integradora cuatrimestre 1 - Version B
// Parte 1: catalogo de ciudades en memoria (Unidad 1)
// Partes 2 y 3: pacientes y provincias de hospital.db (Unidad 2)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Catalogo en memoria de la Parte 1: datos provistos, no modificar
var cities = new List<City>
{
    new(1, "Rosario"),
    new(2, "Cordoba"),
    new(3, "Mendoza")
};

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// a) GET /cities/{id:long} -> 200 con la ciudad o 404 (10 puntos)

// b) POST /cities -> valida el nombre, responde 201 o 400 (15 puntos)

// ===== Parte 2: completar a partir de aqui =====
// a) GET /patients?text=... -> pacientes cuya ciudad contiene el texto (15 puntos)

// b) GET /provinces/{provinceId}/patients -> pacientes de una provincia (20 puntos)

// ===== Parte 3: completar a partir de aqui =====
// POST /patients -> valida los campos, inserta y responde 201 o 400 (20 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record City(long CityId, string Name);
record Patient(
    long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City, string ProvinceId, string? Allergies,
    int? Height, int? Weight);
record PatientCard(long PatientId, string FirstName, string LastName, string? City);
record PatientInProvince(long PatientId, string FirstName, string LastName, string ProvinceName);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `gender` (TEXT `M`/`F`, obligatorio) · `birth_date` (TEXT ISO, obligatorio) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, obligatorio, referencia a `province_names`) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `province_names` | `province_id` (TEXT, clave, por ejemplo `ON`) · `province_name` (TEXT, obligatorio) |

## Parte 1 — Catálogo de ciudades en memoria (25 puntos)

Sobre la lista `cities` provista, sin base de datos:

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `GET /cities/{id:long}`: devuelve `200` con la ciudad cuyo id llega por la ruta, o `404` con un mensaje si no existe | 10 |
| b | Endpoint `POST /cities`: recibe la ciudad por cuerpo, valida que el nombre no esté vacío (`400` con mensaje si lo está), calcula el id siguiente y responde `201` con la URL del recurso nuevo y la ciudad creada | 15 |

## Parte 2 — Consultas a `hospital.db` (35 puntos)

Sobre las tablas `patients` y `province_names`:

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `GET /patients?text=...`: devuelve `200` con los pacientes cuya ciudad contiene el texto que llega por query string. Búsqueda parcial con `LIKE`, consulta parametrizada, columnas con alias y mapeo al record `PatientCard` | 15 |
| b | Endpoint `GET /provinces/{provinceId}/patients`: devuelve `200` con todos los pacientes de esa provincia (el código llega por la ruta, por ejemplo `ON`). Consulta con `JOIN` de dos tablas (`patients` + `province_names`), mapeada al record `PatientInProvince`, ordenada por apellido | 20 |

## Parte 3 — Alta de pacientes en la base (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `POST /patients`: recibe un paciente por cuerpo (con nombre, apellido, género, fecha de nacimiento y provincia; el resto puede no llegar), valida que esos cinco campos obligatorios no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado, obtiene el id generado y responde `201` con la URL del nuevo paciente | 20 |

## Parte 4 — Ítems conceptuales (20 puntos)

Responder por escrito, con tus palabras.

### C1. Memoria y persistencia (5 puntos)

En la Parte 1 los datos viven en una lista en memoria y en las Partes 2 y 3 en `hospital.db`:

a) ¿Qué ocurre con las ciudades creadas por `POST` cuando se corta la API con `Ctrl+C` y se vuelve a correr `dotnet run`? (2 puntos)

b) ¿Por qué esa situación no ocurre con los pacientes creados por `POST` en la Parte 3? (3 puntos)

### C2. Verbos y códigos de respuesta (8 puntos)

Para cada situación, indicar el verbo HTTP y el código de estado que corresponde:

| Situación | Verbo | Código |
| --- | --- | --- |
| El navegador pide el detalle de un paciente y ese id no existe | | |
| Se da de alta un paciente con todos los campos obligatorios válidos | | |
| Llega un `POST` de paciente sin fecha de nacimiento y la API lo rechaza | | |
| La búsqueda por ciudad encuentra coincidencias y las devuelve | | |

### C3. Ciclo de entrega con git y GitHub (7 puntos)

Al terminar la clase, el grupo quiere subir el trabajo a GitHub:

a) Ordenar los comandos para una entrega ya configurada: `git push`, `git add .`, `git commit -m "..."` (3 puntos)

b) ¿Qué comando deja registrado el mensaje que describe lo hecho? (2 puntos)

c) ¿Para qué sirve el `.gitignore` y qué carpetas ignora en este curso? (2 puntos)
