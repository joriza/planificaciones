# Evaluación integradora del cuatrimestre 1 — Versión A

> Dominio de esta versión: médicos y especialidades (tablas `doctors` y `admissions` de `hospital.db`). Duración: 120 minutos. Puntaje total: 100 puntos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas están en `evaluacion-cuatrimestre-1.md`.

## Antes de empezar

- Trabajás sobre un único proyecto Minimal API creado con `dotnet new web`; todo el código va en `Program.cs`.
- La Parte 1 usa una lista en memoria (Unidad 1). Las Partes 2 y 3 usan la base `hospital.db` con Dapper (Unidad 2). La Parte 4 se responde por escrito.
- El esqueleto provisto ya trae los `using`, la lista base, la cadena de conexión y todos los records: no modificarlos. Solo se agregan los endpoints pedidos.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Al terminar, dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.

## Material provisto 1 — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion integradora cuatrimestre 1 - Version A
// Parte 1: catalogo de especialidades en memoria (Unidad 1)
// Partes 2 y 3: medicos e ingresos de hospital.db (Unidad 2)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Catalogo en memoria de la Parte 1: datos provistos, no modificar
var specialties = new List<Specialty>
{
    new(1, "Cardiologia"),
    new(2, "Pediatria"),
    new(3, "Traumatologia")
};

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// a) GET /specialties/{id:long} -> 200 con la especialidad o 404 (10 puntos)

// b) POST /specialties -> valida el nombre, responde 201 o 400 (15 puntos)

// ===== Parte 2: completar a partir de aqui =====
// a) GET /doctors?text=... -> medicos cuya especialidad contiene el texto (15 puntos)

// b) GET /doctors/{id:long}/admissions -> ingresos atendidos por un medico (20 puntos)

// ===== Parte 3: completar a partir de aqui =====
// POST /doctors -> valida los campos, inserta y responde 201 o 400 (20 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record Specialty(long SpecialtyId, string Name);
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `specialty` (TEXT, obligatorio) |
| `admissions` | `patient_id` (INTEGER) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors.doctor_id`) |

## Parte 1 — Catálogo de especialidades en memoria (25 puntos)

Sobre la lista `specialties` provista, sin base de datos:

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `GET /specialties/{id:long}`: devuelve `200` con la especialidad cuyo id llega por la ruta, o `404` con un mensaje si no existe | 10 |
| b | Endpoint `POST /specialties`: recibe la especialidad por cuerpo, valida que el nombre no esté vacío (`400` con mensaje si lo está), calcula el id siguiente y responde `201` con la URL del recurso nuevo y la especialidad creada | 15 |

## Parte 2 — Consultas a `hospital.db` (35 puntos)

Sobre las tablas `doctors` y `admissions`:

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `GET /doctors?text=...`: devuelve `200` con los médicos cuya especialidad contiene el texto que llega por query string. Búsqueda parcial con `LIKE`, consulta parametrizada y columnas con alias para el record `Doctor` | 15 |
| b | Endpoint `GET /doctors/{id:long}/admissions`: devuelve `200` con todos los ingresos atendidos por ese médico. Consulta con `JOIN` de dos tablas (`admissions` + `doctors`), mapeada al record `AdmissionOfDoctor`, ordenada por fecha | 20 |

## Parte 3 — Alta de médicos en la base (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| único | Endpoint `POST /doctors`: recibe un médico por cuerpo, valida que nombre, apellido y especialidad no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado, obtiene el id generado y responde `201` con la URL del nuevo médico | 20 |

## Parte 4 — Ítems conceptuales (20 puntos)

Responder por escrito, con tus palabras.

### C1. Memoria y persistencia (5 puntos)

En la Parte 1 los datos viven en una lista en memoria y en las Partes 2 y 3 en `hospital.db`:

a) ¿Qué ocurre con las especialidades creadas por `POST` cuando se corta la API con `Ctrl+C` y se vuelve a correr `dotnet run`? (2 puntos)

b) ¿Por qué esa situación no ocurre con los médicos creados por `POST` en la Parte 3? (3 puntos)

### C2. Verbos y códigos de respuesta (8 puntos)

Para cada situación, indicar el verbo HTTP y el código de estado que corresponde:

| Situación | Verbo | Código |
| --- | --- | --- |
| El navegador pide el detalle de un médico y ese id no existe | | |
| Se da de alta un médico con todos los campos válidos | | |
| Llega un `POST` de médico sin especialidad y la API lo rechaza | | |
| La búsqueda por especialidad encuentra coincidencias y las devuelve | | |

### C3. Ciclo de entrega con git y GitHub (7 puntos)

Al terminar la clase, el grupo quiere subir el trabajo a GitHub:

a) Ordenar los comandos para una entrega ya configurada: `git push`, `git add .`, `git commit -m "..."` (3 puntos)

b) ¿Qué comando deja registrado el mensaje que describe lo hecho? (2 puntos)

c) ¿Para qué sirve el `.gitignore` y qué carpetas ignora en este curso? (2 puntos)
