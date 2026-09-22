# Anexo docente — Encuentro 10: SQLite y SELECT básico

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Paso 2 — Endpoint `/patients/count`

```csharp
// GET /patients/count — devolver el total de pacientes
app.MapGet("/patients/count", () =>
{
    using var connection = new SqliteConnection(connectionString);
    // ExecuteScalar<long> devuelve el valor de COUNT(*) como long
    var total = connection.ExecuteScalar<long>("SELECT COUNT(*) FROM patients");
    return Results.Ok(new { total });
});
```

**Salida esperada al navegar a `http://localhost:5000/patients/count`:**

```json
{
  "total": 258
}
```

### Paso 2 — Endpoint `/patients/gender/{gender}`

```csharp
// GET /patients/gender/{gender} — filtrar pacientes por sexo
app.MapGet("/patients/gender/{gender}", (string gender) =>
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
        WHERE gender = @gender", new { gender }).ToList();

    return Results.Ok(patients);
});
```

**Salida esperada al navegar a `http://localhost:5000/patients/gender/F` (primeros 2 registros):**

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

### Paso 3 — Consulta sobre `doctors`

```csharp
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
    ").ToList();

    return Results.Ok(doctors);
});
```

Record correspondiente:

```csharp
public record Doctor(
    long DoctorId,
    string FirstName,
    string LastName,
    string Specialty
);
```

**Salida esperada (primeros 3 registros):**

```json
[
  {
    "doctorId": 1,
    "firstName": "Claude",
    "lastName": "Walls",
    "specialty": "Internist"
  },
  {
    "doctorId": 2,
    "firstName": "Joshua",
    "lastName": "Green",
    "specialty": "Cardiologist"
  },
  {
    "doctorId": 3,
    "firstName": "Miriam",
    "lastName": "Tregre",
    "specialty": "General Surgeon"
  }
]
```

## 2. Solución de la actividad de extensión

**Paso 1 — Exploración con sqlite3:** Los alumnos deben poder listar las 4 tablas (`doctors`, `patients`, `province_names`, `admissions`) y ejecutar un `SELECT` básico en cada una.

**Paso 2 — Endpoints extendidos:** Se espera que el alumno haya creado al menos 2 endpoints nuevos (`/patients/count` y `/patients/gender/{gender}`) que compilen y devuelvan datos correctos.

**Paso 3 — Consulta libre:** Se espera que el alumno haya creado un endpoint para una tabla distinta de `patients` con su record correspondiente.

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Verificación |
| --- | --- | --- |
| `/patients/count` devuelve el total | `{ "total": 258 }` | Navegar al endpoint y verificar el JSON |
| `/patients/gender/F` filtra por sexo | Array de pacientes con `"gender": "F"` | Verificar que todos los objetos tengan `"gender": "F"` |
| `/doctors` lista los medicos | Array de 27 objetos con `DoctorId`, `FirstName`, `LastName`, `Specialty` | Verificar que la cantidad sea 27 |
| El record usa `long` para IDs | Sin `InvalidOperationException` | Compilar y ejecutar sin errores |
| Los alias `AS` coinciden con el record | Sin `InvalidOperationException` | Compilar y ejecutar sin errores |

## 4. Criterios de corrección (lista de verificación)

- [ ] El archivo `Program.cs` compila sin errores ni advertencias.
- [ ] Se usa `using Dapper;` y `using Microsoft.Data.Sqlite;` al inicio.
- [ ] La cadena de conexión es `"Data Source=hospital.db"`.
- [ ] Cada endpoint abre la conexión con `using var connection = new SqliteConnection(...)`.
- [ ] Todas las consultas usan alias `AS` para mapear columnas snake_case a PascalCase.
- [ ] Los records usan `long` para columnas INTEGER (no `int`).
- [ ] Los campos nullable llevan `?` (`string?`, `long?`).
- [ ] Los records están declarados después de `app.Run();`.
- [ ] Los endpoints devuelven `Results.Ok(...)`, `Results.NotFound(...)` o `Results.BadRequest(...)` (nunca el objeto crudo).
- [ ] Los comentarios en el código están en español y no contienen tildes ni eñes.
- [ ] El endpoint `/patients/count` usa `ExecuteScalar<long>`.
- [ ] El endpoint `/patients/gender/{gender}` usa parámetro `@gender` con `new { gender }`.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException`: no constructor match | El record usa `int PatientId` en vez de `long PatientId`. | Indicar que SQLite INTEGER siempre devuelve `Int64` y el record debe usar `long`. |
| `InvalidOperationException`: no constructor match | Falta un alias `AS` en el SELECT; Dapper busca `patient_id` pero el record tiene `PatientId`. | Mostrar que cada columna necesita `AS NombreDelCampo` que coincida exactamente con el parámetro del constructor del record. |
| La lista devuelve 0 pacientes | `hospital.db` no está en la carpeta de salida del proyecto (no se copió al `bin/Debug/net6.0/`). | Verificar que el archivo `.db` esté en la raíz del proyecto y que `Copy to Output Directory` esté en `Copy if newer` (o usar la ruta relativa directa). |
| CS8803 al compilar | El record está antes de `app.Run()`. | Indicar que los records deben ir siempre después de `app.Run();` en top-level statements. |
| El endpoint devuelve el objeto crudo sin `Results` | Se devolvió `patient` directamente en vez de `Results.Ok(patient)`. | Recordar que siempre se debe envolver la respuesta con `Results.Ok()`, `Results.NotFound()`, etc. |
| `NullReferenceException` en `allergies` | La propiedad `Allergies` no lleva `?` y la columna tiene `NULL` en la BD. | Declarar `string? Allergies` en el record para aceptar valores nulos. |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Conexión inicial | Porcentaje de grupos que lograron abrir `hospital.db` desde la terminal sin errores de `sqlite3`. |
| Primer SELECT | Observar si los alumnos usan alias `AS` correctamente o intentan `SELECT *` y luego tienen problemas de mapeo. |
| Mapeo de tipos | Registrar cuántos grupos tuvieron el error `int` vs `long` y cuántos lo resolvieron con la intervención. |
| Comprensión de `using` | Verificar que cada grupo incluye `using var connection` y no deja conexiones abiertas. |
| Trabajo en pareja | Anotar qué parejas completaron los 3 pasos de la actividad complementaria y cuáles necesitaron más tiempo. |
| Errores frecuentes | Documentar los errores más comunes encontrados durante la clase para ajustar la retroalimentación de la próxima sesión. |
