# Anexo docente — Encuentro 14: Cierre U2: repaso y TP

**Tipo:** Anexo docente — material exclusivo para el profesorado. No se entrega a los alumnos.

---

## Encuadre

Encuentro de cierre de la Unidad 2. No hay contenido nuevo: es integración y evaluación. La práctica guiada construye la base del TP-U2 (3 endpoints canónicos: listar pacientes, buscar por ID, listar médicos). El ejercicio independiente es el TP-U2 en sí: 4 endpoints adicionales que los alumnos deben completar y entregar. El carácter actitudinal implica que se evalua también la entrega en GitHub (compromiso, orden, commit semántico).

El TP-U2 se entrega en la carpeta `tp-u2/` del repositorio grupal. Evaluar como aprobado/desaprobado con devolución escrita.

---

## Qué observar durante la práctica

- **Records duplicados**: algunos alumnos pueden repetir records en vez de declararlos una sola vez. Señalar que `Patient` y `Doctor` ya están definidos en la práctica guiada; los endpoints del TP pueden reutilizarlos.
- **`QueryFirstOrDefault` sin `?`**: si el record `Patient` no es nullable (`Patient?`) y el paciente no existe, Dapper devuelve `null` pero el tipo no lo admite. La firma del endpoint `(long id)` y el chequeo `patient is null` funcionan si `Patient` es class/record no nullable? Sí, con `QueryFirstOrDefault<Patient>` devuelve `Patient?` (nullable implícito para records de referencia). Verificar.
- **Commit de los alumnos**: el commit debe ser `"tp-u2: consultas con Dapper y SQLite"` (español, sin tildes, dos puntos). Si no, pedir que corrijan el mensaje con `git commit --amend`.
- **Carpeta tp-u2**: el proyecto debe estar dentro de `tp-u2/`, no en la raíz del repositorio ni en otra carpeta.

---

## Solución completa (TP-U2)

El proyecto base es el de la práctica guiada. Los 4 endpoints del TP se agregan después de `app.Run()`, antes de los records. Código completo del `Program.cs`:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// Records al final del archivo

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients
        ORDER BY last_name
    ").ToList();
    return Results.Ok(patients);
});

// GET /patients/{id:long} — buscar paciente por ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients
        WHERE patient_id = @id
    ", new { id });
    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// GET /doctors — listar todos los medicos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name
    ").ToList();
    return Results.Ok(doctors);
});

// --- TP-U2: 4 endpoints del alumno ---

// 1. GET /patients/by-name/{lastName} — buscar por apellido con LIKE
app.MapGet("/patients/by-name/{lastName}", (string lastName) =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients
        WHERE last_name LIKE @patron
        ORDER BY last_name
    ", new { patron = $"%{lastName}%" }).ToList();
    return Results.Ok(patients);
});

// 2. GET /patients/with-province — pacientes con nombre de provincia
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               pn.province_name AS ProvinceName,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.last_name, p.first_name
    ").ToList();
    return Results.Ok(patients);
});

// 3. GET /doctors/by-specialty/{specialty} — buscar medicos por especialidad
app.MapGet("/doctors/by-specialty/{specialty}", (string specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE specialty LIKE @patron
        ORDER BY last_name
    ", new { patron = $"%{specialty}%" }).ToList();
    return Results.Ok(doctors);
});

// 4. GET /doctors/{id:long} — buscar medico por ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @id
    ", new { id });
    return doctor is null
        ? Results.NotFound(new { mensaje = "Medico no encontrado" })
        : Results.Ok(doctor);
});

app.Run();

// Records
public record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, string ProvinceId, string? Allergies, long? Height, long? Weight);
public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
public record Province(string ProvinceId, string ProvinceName);
public record PatientWithProvince(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, string ProvinceName, string? Allergies, long? Height, long? Weight);
```

Verificar que cada endpoint responde correctamente:
- `GET /patients/by-name/Smi` → pacientes con apellido que contiene "Smi".
- `GET /patients/with-province` → cada paciente con `provinceName` en vez de `provinceId`.
- `GET /doctors/by-specialty/Cardio` → médicos con especialidad que contiene "Cardio".
- `GET /doctors/1` → médico con ID 1. `GET /doctors/9999` → 404.

---

## Errores previsibles

Incluye los defectos de la checklist de `convenciones-tecnicas.md`:

| Error | Cómo se manifiesta | Corrección |
|-------|-------------------|------------|
| **ID como `int` en el record** | `InvalidOperationException` | Usar `long PatientId` |
| **Fecha como `DateTime`** | `InvalidOperationException` | Usar `string BirthDate` |
| **Columna INTEGER nullable como `int?`** | `InvalidOperationException` | Usar `long? Height` |
| **SELECT sin alias AS** | `InvalidOperationException` | Usar `SELECT patient_id AS PatientId, ...` |
| **Records antes de `app.Run()`** | Error CS8803 | Mover records después de `app.Run()` |
| **Olvidar `?` en campos nulables** | Dapper asigna null a campo no nulable | Declarar como `string?` o `long?` |
| **Concatenar datos al SQL** | Riesgo de inyección | Usar `@patron`, `@id` con `new { ... }` |
| **LIKE sin `%` en el valor** | Busca coincidencia exacta |  `new { patron = $"%{texto}%" }` |
| **Proyecto fuera de `tp-u2/`** | El TP no se evalua en la carpeta correcta | Mover todo `tp-u2` a la carpeta correcta |
| **Mensaje de commit incorrecto** | No sigue la convención | Usar `git commit --amend -m "tp-u2: consultas con Dapper y SQLite"` |

---

## Criterios de logro (TP-U2)

| Criterio | Puntos (aprox.) | Lo evidencia |
|----------|----------------|--------------|
| Usa Dapper con records | 20% | `Query<T>`, `QueryFirstOrDefault<T>`, records posicionales |
| Parametriza todas las consultas | 20% | Ninguna concatenación en el código |
| Usa alias AS en SELECT | 20% | Todas las columnas snake_case tienen su alias PascalCase |
| LIKE con % para búsqueda parcial | 15% | Los endpoints de nombre y especialidad usan LIKE con comodín |
| Maneja 404 correctamente | 15% | `QueryFirstOrDefault` + `Results.NotFound` para IDs inexistentes |
| Entrega en GitHub (carpeta tp-u2) | 10% | Repositorio con `tp-u2/`, commit semántico, push exitoso |

---

## Agrupamiento

- **Apertura (20 min):** grupo completo. Repaso general de la Unidad 2, mapa conceptual en pizarra. Resolver dudas globales.
- **Práctica guiada (60 min):** individual. Cada alumno construye el proyecto base desde cero. El docente circula y asiste. Proyectar los records y el primer endpoint (`/patients`) como referencia.
- **TP-U2 (60 min):** individual o pares (según definición del curso). Los alumnos completan los 4 endpoints faltantes. El docente asiste puntualmente.
- **Consolidación y cierre (20 min):** grupo completo. Verificar que todos tienen los endpoints funcionando. Explicar el flujo de entrega en GitHub.
- **Actividad complementaria (80 min):** tiempo para entrega en GitHub, resolución de problemas de git, y alumnos que necesitan más tiempo.

---

## Ajustes

- **Si el grupo se atrasa en la práctica guiada:** acortar el repaso de apertura a 10 minutos. El TP sigue siendo obligatorio aunque se entregue después de clase (fecha límite: 48 hs).
- **Si hay problemas técnicos con GitHub:** dedicar los 20 minutos de consolidación a resolver git. Si un alumno no puede hacer push, que entregue el código comprimido por correo como plan de contingencia.
- **Alumnos con dificultades:** darles el archivo `Program.cs` completo de la práctica guiada (sin los endpoints del TP) para que solo agreguen los 4 endpoints. Asistencia personalizada en el uso de LIKE.
- **Alumnos avanzados:** proponer como actividad complementaria que agreguen un quinto endpoint: `GET /doctors/{id:long}/admissions` que devuelva los ingresos atendidos por ese médico (JOIN admissions + patients, filtrado por doctor_id).