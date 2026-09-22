# Anexo docente — Encuentro 13: Parámetros y LIKE en Dapper

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Consigna 1 — `/doctors/by-specialty?specialty=Card`

```csharp
// GET /doctors/by-specialty — buscar medicos por especialidad (búsqueda parcial)
app.MapGet("/doctors/by-specialty", (string specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE specialty LIKE @specialty
        ORDER BY last_name, first_name
    ", new { specialty = $"%{specialty}%" }).ToList();

    return Results.Ok(doctors);
});
```

**Salida esperada al navegar a `http://localhost:5000/doctors/by-specialty?specialty=Card`:**

```json
[
  {
    "doctorId": 2,
    "firstName": "Joshua",
    "lastName": "Green",
    "specialty": "Cardiologist"
  },
  {
    "doctorId": 7,
    "firstName": "Simon",
    "lastName": "Santiago",
    "specialty": "Cardiologist"
  },
  {
    "doctorId": 15,
    "firstName": "Douglas",
    "lastName": "Brooks",
    "specialty": "Cardiologist"
  }
]
```

### Consigna 2 — `/admissions/search?diagnosis=Heart`

```csharp
// GET /admissions/search — buscar admisiones por diagnostico
app.MapGet("/admissions/search", (string diagnosis) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<AdmissionSearchResult>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.diagnosis LIKE @diagnosis
        ORDER BY a.admission_date DESC
    ", new { diagnosis = $"%{diagnosis}%" }).ToList();

    return Results.Ok(admissions);
});
```

Record correspondiente:

```csharp
// Record para resultados de busqueda de admisiones
public record AdmissionSearchResult(
    string AdmissionDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName
);
```

**Salida esperada al navegar a `http://localhost:5000/admissions/search?diagnosis=Heart`:**

```json
[
  {
    "admissionDate": "2018-11-06",
    "diagnosis": "Congestive Heart Failure",
    "patientName": "Donald Waterfield",
    "doctorName": "Claude Walls"
  },
  {
    "admissionDate": "2018-10-15",
    "diagnosis": "Myocardial Infarction",
    "patientName": "Mickey Baasha",
    "doctorName": "Joshua Green"
  }
]
```

### Consigna 3 — `/patients/filter` con múltiples filtros opcionales

```csharp
// GET /patients/filter — filtrar pacientes con parametros opcionales
app.MapGet("/patients/filter", (
    string? gender,
    string? city,
    string? provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Construir la consulta con WHERE 1=1 y agregar condiciones segun corresponda
    var sql = @"
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
        WHERE 1=1";

    var parameters = new {};

    // Agregar filtros solo si los parametros no son nulos
    if (!string.IsNullOrEmpty(gender))
    {
        sql += " AND gender = @gender";
        parameters = new { gender };
    }

    if (!string.IsNullOrEmpty(city))
    {
        sql += " AND city LIKE @city";
        parameters = new { city = $"%{city}%" };
    }

    if (!string.IsNullOrEmpty(provinceId))
    {
        sql += " AND province_id = @provinceId";
        parameters = new { provinceId };
    }

    sql += " ORDER BY last_name, first_name";

    var patients = connection.Query<Patient>(sql, parameters).ToList();

    return Results.Ok(patients);
});
```

**Salida esperada al navegar a `http://localhost:5000/patients/filter?gender=F&provinceId=ON`:**

```json
[
  {
    "patientId": 3,
    "firstName": "Jiji",
    "lastName": "Sharma",
    "gender": "F",
    "birthDate": "1990-05-15",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": "Sulfa",
    "height": 162,
    "weight": 55
  },
  {
    "patientId": 5,
    "firstName": "Valeria",
    "lastName": "Lopez",
    "gender": "F",
    "birthDate": "1985-03-22",
    "city": "Mendoza",
    "provinceId": "ON",
    "allergies": null,
    "height": 158,
    "weight": 54
  }
]
```

**Salida esperada al navegar a `http://localhost:5000/patients/filter` (sin filtros):**

Devuelve todos los 258 pacientes ordenados por apellido y nombre.

## 2. Solución de la actividad de extensión

**Consigna 1:** Se espera que el alumno haya creado un endpoint `GET /doctors/by-specialty` que use `LIKE` con comodines `%` envueltos en el objeto anónimo.

**Consigna 2:** Se espera que el alumno haya creado un endpoint `GET /admissions/search` que use `LIKE` con `JOIN` entre `admissions`, `patients` y `doctors`.

**Consigna 3:** Se espera que el alumno haya creado un endpoint `GET /patients/filter` con parámetros opcionales y construcción dinámica de la consulta SQL.

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Verificación |
| --- | --- | --- |
| `/doctors/by-specialty?specialty=Card` | Array de médicos con especialidad que contiene "Card" | Verificar que todos los objetos tengan "Card" en `specialty` |
| `/admissions/search?diagnosis=Heart` | Array de admisiones con diagnóstico que contiene "Heart" | Verificar que todos los objetos tengan "Heart" en `diagnosis` |
| `/patients/filter?gender=F&provinceId=ON` | Array de pacientes femeninos de Ontario | Verificar que todos tengan `gender: "F"` y `provinceId: "ON"` |
| `/patients/filter` sin filtros | Array de todos los 258 pacientes | Verificar la cantidad |
| Los parámetros son parametrizados | Sin concatenación de strings en el SQL | Verificar que se usa `@param` y `new { param }` |
| Los comodines `%` están en el objeto anónimo | LIKE funciona para búsqueda parcial | Verificar que la búsqueda parcial devuelve resultados |

## 4. Criterios de corrección (lista de verificación)

- [ ] El archivo `Program.cs` compila sin errores ni advertencias.
- [ ] Se usa `using Dapper;` y `using Microsoft.Data.Sqlite;` al inicio.
- [ ] La cadena de conexión es `"Data Source=hospital.db"`.
- [ ] Cada endpoint abre la conexión con `using var connection = new SqliteConnection(...)`.
- [ ] Todas las consultas usan alias `AS` para mapear columnas snake_case a PascalCase.
- [ ] Los records usan `long` para columnas INTEGER y `string?` para columnas nullable.
- [ ] Los records están declarados después de `app.Run();`.
- [ ] Los endpoints devuelven `Results.Ok(...)`, `Results.NotFound(...)` o `Results.BadRequest(...)` (nunca el objeto crudo).
- [ ] Los comentarios en el código están en español y no contienen tildes ni eñes.
- [ ] Los parámetros se pasan con objetos anónimos `new { ... }` y nunca se concatenan en el SQL.
- [ ] `LIKE` usa comodines `%` envueltos en el objeto anónimo (`$"%{valor}%"`).
- [ ] `QueryFirstOrDefault<T>` se usa para buscar un solo registro y se maneja el `null`.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| LIKE no devuelve resultados parciales | Falta envolver el valor con `%` en el objeto anónimo. | Mostrar que `LIKE @nombre` requiere `new { nombre = $"%{valor}%" }` para los comodines. |
| La búsqueda con `=` no encuentra coincidencias parciales | Se usó `=` en vez de `LIKE` para búsqueda parcial. | Recordar que `=` busca coincidencia exacta y `LIKE` permite coincidencia parcial con `%`. |
| Inyección SQL en la consulta | Se concatenó el valor directamente en el SQL con `$"{valor}"`. | Explicar que siempre se debe usar `@param` con `new { param }` y nunca concatenar. |
| `null` en el JSON para campos nullable | La propiedad no lleva `?` en el record. | Declarar como `string?` o `long?` según el tipo canónico. |
| La consulta con múltiples filtros no funciona | Se usó `WHERE` sin manejar parámetros opcionales. | Mostrar la técnica de `WHERE 1=1` con `AND` condicional o construir la consulta dinámicamente. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |
| `InvalidOperationException`: no constructor match | El tipo del parámetro del record no coincide con el tipo de la columna. | Verificar que INTEGER → `long`, TEXT → `string`, y que los nullable lleven `?`. |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Comprensión de la parametrización | Observar si los alumnos entienden que los valores siempre deben ir como parámetros `@nombre` y nunca concatenados. |
| Uso de LIKE con comodines | Verificar que los alumnos envuelven los valores con `%` en el objeto anónimo y no en el SQL. |
| QueryFirstOrDefault con null | Registrar si los alumnos manejan correctamente el caso de `null` cuando no hay resultados. |
| Filtros opcionales | Anotar qué alumnos lograron construir la consulta dinámica con `WHERE 1=1` y cuáles necesitaron más ayuda. |
| Errores de inyección SQL | Documentar si algún alumno intentó concatenar valores en el SQL y cómo se corrigió. |
| Trabajo individual | Anotar quiénes completaron las 3 consignas de la actividad complementaria y cuáles necesitaron más tiempo. |
