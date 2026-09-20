# Anexo docente — Encuentro 10: SQLite y Dapper, conexión a hospital.db y primera consulta

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 10 — apertura con devolución de la evaluación de la Unidad 1; contenido nuevo: conexión a `hospital.db` con Dapper y primer SELECT mapeado a records |
| Formato | Encuentro estándar del curso (BOPPPS + GRR), plantilla de clase regular (20/40/70/50/45/15) |
| Producción esperada | Proyecto `u2-api` con conexión funcionando, `GET /patients` con los 258 pacientes y `GET /doctors` del ejercicio (27 médicos) |
| Insumos | `hospital.db` distribuido por el docente; SDK de .NET 6 instalado; repositorio del grupo con remoto y push al día |

**Decisión didáctica (conexión primero):** el encuentro va directo a la conexión C# → base con la API, sin exploración previa con herramienta visual: la partición del curso asigna al Encuentro 10 la primera consulta con Dapper, y el alumno ya conoce el vocabulario de tablas y columnas de la Unidad 1 aplicado a `hospital.db` en los materiales de la unidad. Si el grupo necesita una mirada previa al archivo, el docente puede proyectar DB Browser for SQLite durante la teoría (2 minutos, modo lectura), sin convertirlo en actividad: el núcleo del encuentro es el endpoint funcionando contra datos reales.

**Verificación previa a la clase:** controlar que la copia de `hospital.db` que se distribuye coincida con los volúmenes de referencia del curso: `province_names` 13 · `doctors` 27 · `patients` 258 · `admissions` 306. Si la copia difiere, ajustar en este anexo los conteos esperados (la estructura de tablas y columnas es idéntica en todas las versiones).

## Gestión de la devolución de la evaluación de la Unidad 1 (apertura, 20 min)

| Tramo | Tiempo | Qué hacer |
| --- | --- | --- |
| Panorama general | 8 min | En el pizarrón: resultado global del curso, los 2 o 3 errores más frecuentes de la evaluación y su corrección. Sin individualizar personas ni notas frente al grupo |
| Entrega individual | 6 min | Distribuir las correcciones; lectura en silencio. Quien quiera, anota consultas para el tramo siguiente |
| Consultas | 4 min | Respuestas breves y puntuales; derivar casos complejos al afterclass |
| Puente | 2 min | Pregunta disparadora del documento del alumno: ¿dónde siguen los datos cuando la API se apaga? |

Sugerencias:

- Conectar los errores frecuentes de la evaluación con lo que viene: los errores de nombres (rutas, propiedades) reaparecen hoy como errores de mapeo por nombre entre columnas y propiedades. Lo corregido en tp-u1 vuelve con otro disfraz.
- Anunciar en este tramo cualquier recuperatorio pendiente, para no interrumpir la práctica.
- No extender la devolución más allá del bloque: la práctica guiada necesita sus 70 minutos completos.

## Solución completa del ejercicio independiente

`GET /doctors` agregado al proyecto `u2-api`. Archivo `Program.cs` completo (los cambios respecto de la práctica están marcados con comentarios `NUEVO`):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients: devuelve TODOS los pacientes de la base (258 filas)
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients");

    return Results.Ok(patients);
});

// NUEVO - GET /doctors: devuelve TODOS los medicos de la base (27 filas)
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Mismo patron que /patients: alias AS en las cuatro columnas
    // para que Dapper las encaje en las propiedades del record Doctor
    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors");

    return Results.Ok(doctors);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Paciente: una fila de la tabla patients
record Patient(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? City,
    string ProvinceId,
    string? Allergies,
    int? Height,
    int? Weight
);

// NUEVO - Medico: una fila de la tabla doctors (id long, sin fechas)
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

Salida esperada de `GET /doctors`: arreglo JSON con **27 objetos** (conteo estable de la tabla `doctors`, idéntica en todas las copias de la base). Estructura por objeto:

```json
{
  "doctorId": 7,
  "firstName": "Hazel",
  "lastName": "Patterson",
  "specialty": "Oncologist"
}
```

## Solución de la extensión

`GET /admissions` con el record canónico `Admission` (los otros endpoints quedan igual):

```csharp
// NUEVO - GET /admissions: devuelve TODOS los ingresos (306 filas)
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // admission y alta son fechas: string ISO. discharge_date acepta NULL:
    // null = el paciente sigue internado (sin fecha de alta)
    var admissions = connection.Query<Admission>(
        @"SELECT patient_id          AS PatientId,
                 admission_date      AS AdmissionDate,
                 discharge_date      AS DischargeDate,
                 diagnosis           AS Diagnosis,
                 attending_doctor_id AS AttendingDoctorId
          FROM admissions");

    return Results.Ok(admissions);
});
```

```csharp
// NUEVO - Ingreso hospitalario: fechas string ISO, ids long
record Admission(
    long PatientId,          // id de paciente: long (es un id, nunca int)
    string AdmissionDate,    // fecha: string ISO "yyyy-MM-dd"
    string? DischargeDate,   // nullable: sin alta = aun internado
    string? Diagnosis,
    long AttendingDoctorId   // id del medico tratante: long
);
```

Puntos para la puesta en común de la extensión: la respuesta trae 306 ingresos (conteo de referencia); `dischargeDate` es `null` en los ingresos sin alta (pacientes aún internados); un mismo `patientId` aparece en varias filas (múltiples ingresos del mismo paciente); hay diagnósticos con errores de tipeo reales (`Amigima`, `Stomache Pain`), materia prima de las clases 12 y 13.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Conexión correcta con cierre automático | `using var connection = new SqliteConnection(connectionString);` dentro del handler; `hospital.db` junto al `.csproj` |
| 2 | Paquetes instalados por CLI | `.csproj` con las referencias de `Microsoft.Data.Sqlite` y `Dapper`, agregadas con `dotnet add package` |
| 3 | Mapeo completo por alias | Los cuatro alias de `GET /doctors` presentes; ninguna propiedad del record llega vacía |
| 4 | Tipos canónicos en el record | `long DoctorId`; sin `int` en ids ni `DateTime`/`DateOnly` en fechas |
| 5 | Records al final del archivo | Declaraciones de tipos después de `app.Run()`; compila sin CS8803 |
| 6 | Respuesta canónica | `Results.Ok(...)` explícito; el navegador muestra el JSON con 27 médicos |
| 7 | Comentarios abundantes y sin tildes | Cada bloque del código tiene comentario explicativo; sin tildes ni eñes dentro del código |

## Errores esperados e intervención

| Error esperado | Causa probable | Intervención docente |
| --- | --- | --- |
| 500 en `GET /patients` | Record con `int PatientId` | Pedir leer el error de la terminal; guiar a `long`. Es el error canon de la unidad: conviene que lo vea una vez |
| Propiedades vacías en el JSON | Alias `AS` faltante o mal escrito | Volver al experimento del Paso 6; comparar carácter por carácter alias y propiedad |
| `no such table` | `hospital.db` fuera de la raíz del proyecto | Revisar el árbol de carpetas con el grupo; el archivo va junto al `.csproj` |
| CS8803 | Record intercalado entre instrucciones | Mostrar la regla del canon: tipos siempre al final |
| `CS0246: The type or namespace 'Dapper'...` | Paquete agregado fuera de la carpeta del proyecto | Verificar el `.csproj` juntos; volver a correr `dotnet add package` parados en `u2-api/` |
| No alcanza el tiempo de la práctica | Primer contacto con dos paquetes y mapeo nuevo | Reducir el Paso 6 a observación docente proyectada; el ejercicio independiente conserva su tiempo |

## Respuestas esperadas (verificación de comprensión)

- **¿Por qué los datos sobreviven ahora al reinicio?** Porque viven en un archivo del disco (`hospital.db`) y no en la memoria del proceso: la API los lee en cada pedido. Con palabras propias basta; el término "persistencia" se celebra si aparece, no se exige.
- **¿Qué rompe el mapeo por nombre?** El guion bajo de las columnas (`patient_id` frente a `PatientId`): Dapper ignora mayúsculas/minúsculas pero no perdona el guion; el alias `AS` lo resuelve.
- **¿Por qué `long` y no `int` en el id?** SQLite entrega los enteros como `long`; con `int` el mapeo falla en ejecución con un 500, no en compilación: por eso conviene fijar la regla antes que diagnosticarla.
- **¿Qué significa `null` en `allergies`?** Dato ausente en la base (la columna acepta `NULL`); viaja al JSON como `null`. Distinto de un texto vacío con significado.
