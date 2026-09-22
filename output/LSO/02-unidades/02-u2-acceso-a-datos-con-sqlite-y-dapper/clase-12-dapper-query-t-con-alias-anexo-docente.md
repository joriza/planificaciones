# Anexo docente — Encuentro 12: Dapper: Query<T> con alias

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Consigna 1 — `/provinces`

```csharp
// GET /provinces — listar todas las provincias
app.MapGet("/provinces", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var provinces = connection.Query<Province>(@"
        SELECT province_id AS ProvinceId,
               province_name AS ProvinceName
        FROM province_names
        ORDER BY province_name
    ").ToList();

    return Results.Ok(provinces);
});
```

Record correspondiente:

```csharp
// Record para provincias: province_id es TEXT -> string (no nullable, es PK)
// province_name es TEXT -> string (not null)
public record Province(
    string ProvinceId,
    string ProvinceName
);
```

**Salida esperada al navegar a `http://localhost:5000/provinces`:**

```json
[
  {
    "provinceId": "AB",
    "provinceName": "Alberta"
  },
  {
    "provinceId": "BC",
    "provinceName": "British Columbia"
  },
  {
    "provinceId": "MB",
    "provinceName": "Manitoba"
  },
  {
    "provinceId": "NB",
    "provinceName": "New Brunswick"
  },
  {
    "provinceId": "NL",
    "provinceName": "Newfoundland and Labrador"
  },
  {
    "provinceId": "NS",
    "provinceName": "Nova Scotia"
  },
  {
    "provinceId": "NT",
    "provinceName": "Northwest Territories"
  },
  {
    "provinceId": "NU",
    "provinceName": "Nunavut"
  },
  {
    "provinceId": "ON",
    "provinceName": "Ontario"
  },
  {
    "provinceId": "PE",
    "provinceName": "Prince Edward Island"
  },
  {
    "provinceId": "QC",
    "provinceName": "Quebec"
  },
  {
    "provinceId": "SK",
    "provinceName": "Saskatchewan"
  },
  {
    "provinceId": "YT",
    "provinceName": "Yukon"
  }
]
```

### Consigna 2 — `/admissions` y `/admissions/patient/{patientId}`

```csharp
// GET /admissions — listar los primeros 10 ingresos
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_doctor_id AS AttendingDoctorId
        FROM admissions
        ORDER BY admission_date DESC
        LIMIT 10
    ").ToList();

    return Results.Ok(admissions);
});

// GET /admissions/patient/{patientId:long} — ingresos de un paciente
app.MapGet("/admissions/patient/{patientId:long}", (long patientId) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<Admission>(@"
        SELECT patient_id AS PatientId,
               admission_date AS AdmissionDate,
               discharge_date AS DischargeDate,
               diagnosis AS Diagnosis,
               attending_doctor_id AS AttendingDoctorId
        FROM admissions
        WHERE patient_id = @patientId
        ORDER BY admission_date DESC
    ", new { patientId }).ToList();

    return Results.Ok(admissions);
});
```

Record correspondiente:

```csharp
// Record para admisiones: patient_id y attending_doctor_id son INTEGER -> long
// admission_date y discharge_date son TEXT -> string (nullable para discharge_date)
// diagnosis es TEXT -> string nullable
public record Admission(
    long PatientId,
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    long AttendingDoctorId
);
```

**Salida esperada al navegar a `http://localhost:5000/admissions` (primeros 2 registros):**

```json
[
  {
    "patientId": 1,
    "admissionDate": "2019-06-02",
    "dischargeDate": "2019-06-05",
    "diagnosis": "Pneumonia",
    "attendingDoctorId": 1
  },
  {
    "patientId": 2,
    "admissionDate": "2019-06-01",
    "dischargeDate": null,
    "diagnosis": "Asthma",
    "attendingDoctorId": 2
  }
]
```

**Salida esperada al navegar a `http://localhost:5000/admissions/patient/1`:**

```json
[
  {
    "patientId": 1,
    "admissionDate": "2019-06-02",
    "dischargeDate": "2019-06-05",
    "diagnosis": "Pneumonia",
    "attendingDoctorId": 1
  },
  {
    "patientId": 1,
    "admissionDate": "2019-05-28",
    "dischargeDate": "2019-05-30",
    "diagnosis": "Appendicitis",
    "attendingDoctorId": 3
  },
  {
    "patientId": 1,
    "admissionDate": "2019-05-15",
    "dischargeDate": "2019-05-18",
    "diagnosis": "Fractured Hip",
    "attendingDoctorId": 5
  }
]
```

### Consigna 3 — Depuración de mapeo

**Paso 3a — Cambiar `long DoctorId` por `int DoctorId`:**

```csharp
// ESTO FALLA: doctor_id es INTEGER -> Int64 -> long, no int
public record DoctorWrong(
    int DoctorId,    // ERROR: debe ser long
    string FirstName,
    string LastName,
    string Specialty
);
```

**Error en la terminal:**

```
InvalidOperationException: No constructor matching type 'System.Int64' found on type 'DoctorWrong'
```

**Corrección:** cambiar `int DoctorId` por `long DoctorId`.

**Paso 3b — Cambiar `string BirthDate` por `DateTime BirthDate`:**

```csharp
// ESTO FALLA: birth_date es TEXT -> string, no DateTime
public record PatientWrong(
    long PatientId,
    string FirstName,
    DateTime BirthDate   // ERROR: debe ser string
);
```

**Error en la terminal:**

```
InvalidOperationException: No constructor matching type 'System.String' found on type 'PatientWrong'
```

**Corrección:** cambiar `DateTime BirthDate` por `string BirthDate`.

## 2. Solución de la actividad de extensión

**Consigna 1:** Se espera que el alumno haya creado un record `Province` con `string ProvinceId` y `string ProvinceName`, y un endpoint `/provinces` que devuelva las 13 provincias.

**Consigna 2:** Se espera que el alumno haya creado un record `Admission` con los tipos canónicos correctos (`long` para IDs INTEGER, `string` para TEXT, `string?` para nullable) y dos endpoints para la tabla `admissions`.

**Consigna 3:** Se espera que el alumno haya podido identificar y corregir los errores de mapeo (`int` vs `long`, `string` vs `DateTime`) y explicar por qué ocurren.

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Verificación |
| --- | --- | --- |
| `/provinces` devuelve 13 provincias | Array de 13 objetos con `ProvinceId` y `ProvinceName` | Verificar la cantidad y los valores |
| `/admissions` devuelve 10 ingresos | Array de 10 objetos con `PatientId`, `AdmissionDate`, `DischargeDate`, `Diagnosis`, `AttendingDoctorId` | Verificar que `DischargeDate` sea null para ingresos activos |
| `/admissions/patient/1` devuelve los ingresos del paciente 1 | Array de objetos con `PatientId: 1` | Verificar que todos los objetos tengan `patientId: 1` |
| El record usa `long` para INTEGER | Sin `InvalidOperationException` | Compilar y ejecutar sin errores |
| Los alias `AS` coinciden con el record | Sin `InvalidOperationException` | Compilar y ejecutar sin errores |
| Los campos nullable llevan `?` | `null` se serializa correctamente en el JSON | Verificar que las propiedades nullable aparecen como `null` y no como cadena vacía |

## 4. Criterios de corrección (lista de verificación)

- [ ] El archivo `Program.cs` compila sin errores ni advertencias.
- [ ] Se usa `using Dapper;` y `using Microsoft.Data.Sqlite;` al inicio.
- [ ] La cadena de conexión es `"Data Source=hospital.db"`.
- [ ] Cada endpoint abre la conexión con `using var connection = new SqliteConnection(...)`.
- [ ] Todas las columnas del SELECT tienen alias `AS` que coinciden con el record.
- [ ] Los records usan `long` para columnas INTEGER (no `int`).
- [ ] Los campos nullable llevan `?` (`string?`, `long?`).
- [ ] Los records están declarados después de `app.Run();`.
- [ ] Los endpoints devuelven `Results.Ok(...)`, `Results.NotFound(...)` o `Results.BadRequest(...)` (nunca el objeto crudo).
- [ ] Los comentarios en el código están en español y no contienen tildes ni eñes.
- [ ] Se demostraron los 3 errores de mapeo (int vs long, falta de alias, DateTime vs string).
- [ ] Los alumnos pudieron identificar y corregir cada error de mapeo.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException`: no constructor match | El record usa `int` para una columna INTEGER de SQLite. | Indicar que SQLite INTEGER siempre devuelve `Int64` (long) y el record debe usar `long`. |
| `InvalidOperationException`: no constructor match | Falta alias `AS` en el SELECT; Dapper busca `doctor_id` pero el record tiene `DoctorId`. | Mostrar que cada columna necesita `AS NombrePropiedad` que coincida exactamente con el parámetro del constructor del record. |
| `InvalidOperationException`: no constructor match | Se usó `DateTime` para una columna TEXT. | Explicar que Dapper recibe `String` de SQLite para columnas TEXT y no encuentra constructor que acepte `DateTime`. Usar `string` y convertir solo al presentar. |
| `null` aparece como cadena vacía en el JSON | La propiedad nullable no lleva `?` en la declaración del record. | Declarar como `string?` o `long?` según el tipo canónico. |
| El endpoint devuelve un error 500 | La base `hospital.db` no está en la carpeta de salida del proyecto. | Verificar que `hospital.db` esté en la raíz del proyecto y que la cadena de conexión sea `"Data Source=hospital.db"`. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Comprensión del mapeo | Observar si los alumnos entienden la relación entre tipos de columna SQLite y tipos C#. |
| Uso de alias `AS` | Verificar que los alumnos usan alias en todas las columnas del SELECT. |
| Errores de mapeo | Documentar qué alumnos tuvieron errores por tipo incorrecto (`int` vs `long`, `DateTime` vs `string`) y cómo los resolvieron. |
| Depuración | Registrar si los alumnos pudieron identificar y corregir los errores intencionales mostrados por el docente. |
| Trabajo individual | Anotar quiénes completaron las 3 consignas de la actividad complementaria y cuáles necesitaron más tiempo. |
| Errores frecuentes | Documentar los errores más comunes encontrados durante la clase para ajustar la retroalimentación de la próxima sesión. |
