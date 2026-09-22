# Anexo docente — Encuentro 11: SQL: JOIN y ORDER BY

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Consigna 1 — `/patients-by-province/{provinceId}`

```csharp
// GET /patients-by-province/{provinceId} — pacientes de una provincia especifica
app.MapGet("/patients-by-province/{provinceId}", (string provinceId) =>
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
        WHERE pn.province_id = @provinceId
        ORDER BY p.last_name, p.first_name
    ", new { provinceId }).ToList();

    return Results.Ok(patients);
});
```

**Salida esperada al navegar a `http://localhost:5000/patients-by-province/ON` (primeros 2 registros):**

```json
[
  {
    "patientId": 1,
    "firstName": "Donald",
    "lastName": "Waterfield",
    "gender": "M",
    "birthDate": "1963-02-12",
    "city": "Barrie",
    "provinceName": "Ontario",
    "allergies": "Penicillin",
    "height": 185,
    "weight": 76
  },
  {
    "patientId": 2,
    "firstName": "Mickey",
    "lastName": "Baasha",
    "gender": "M",
    "birthDate": "2017-11-19",
    "city": "Hamilton",
    "provinceName": "Ontario",
    "allergies": null,
    "height": null,
    "weight": null
  }
]
```

### Consigna 2 — `/admissions-by-specialty/{specialty}`

```csharp
// GET /admissions-by-specialty/{specialty} — ingresos filtrados por especialidad del medico
app.MapGet("/admissions-by-specialty/{specialty}", (string specialty) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE d.specialty LIKE @specialty
        ORDER BY a.admission_date DESC
    ", new { specialty = $"%{specialty}%" }).ToList();

    return Results.Ok(admissions);
});
```

**Salida esperada al navegar a `http://localhost:5000/admissions-by-specialty/Cardiologist` (primeros 2 registros):**

```json
[
  {
    "admissionDate": "2019-06-01",
    "dischargeDate": null,
    "diagnosis": "Asthma",
    "patientName": "Mickey Baasha",
    "doctorName": "Joshua Green",
    "doctorSpecialty": "Cardiologist"
  },
  {
    "admissionDate": "2019-05-28",
    "dischargeDate": "2019-05-30",
    "diagnosis": "Myocardial Infarction",
    "patientName": "Ramiro Gonzalez",
    "doctorName": "Simon Santiago",
    "doctorSpecialty": "Cardiologist"
  }
]
```

### Consigna 3 — `/top-patients/{count}`

```csharp
// GET /top-patients/{count} — pacientes con mas ingresos
app.MapGet("/top-patients/{count:long}", (long count) =>
{
    using var connection = new SqliteConnection(connectionString);
    var topPatients = connection.Query<TopPatient>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               COUNT(*) AS TotalAdmissions
        FROM patients p
        JOIN admissions a ON p.patient_id = a.patient_id
        GROUP BY p.patient_id
        ORDER BY TotalAdmissions DESC
        LIMIT @count
    ", new { count }).ToList();

    return Results.Ok(topPatients);
});
```

Record correspondiente:

```csharp
// Record para pacientes con cantidad de ingresos
public record TopPatient(
    long PatientId,
    string FirstName,
    string LastName,
    long TotalAdmissions
);
```

**Salida esperada al navegar a `http://localhost:5000/top-patients/3`:**

```json
[
  {
    "patientId": 1,
    "firstName": "Donald",
    "lastName": "Waterfield",
    "totalAdmissions": 5
  },
  {
    "patientId": 3,
    "firstName": "Jiji",
    "lastName": "Sharma",
    "totalAdmissions": 4
  },
  {
    "patientId": 6,
    "firstName": "Sofia",
    "lastName": "Ramirez",
    "totalAdmissions": 3
  }
]
```

## 2. Solución de la actividad de extensión

**Consigna 1:** Se espera que el alumno haya creado un endpoint que filtra pacientes por provincia usando `JOIN` y `WHERE`. La consulta debe usar `@provinceId` como parámetro.

**Consigna 2:** Se espera que el alumno haya creado un endpoint que filtre ingresos por especialidad usando `LIKE @specialty` con el wildcard `%` envuelto en el objeto anónimo.

**Consigna 3:** Se espera que el alumno haya creado un endpoint con `GROUP BY` y `COUNT(*)` para contar ingresos por paciente, ordenado con `DESC` y limitado con `LIMIT`.

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Verificación |
| --- | --- | --- |
| `/patients-by-province/ON` filtra por provincia | Array de pacientes con `"provinceName": "Ontario"` | Verificar que todos los objetos tengan `"provinceName": "Ontario"` |
| `/admissions-by-specialty/Cardiologist` filtra por especialidad | Array de admisiones con `"doctorSpecialty": "Cardiologist"` | Verificar que todos los objetos tengan la especialidad correcta |
| `/top-patients/3` devuelve top 3 | Array de 3 objetos con `PatientId`, `FirstName`, `LastName`, `TotalAdmissions` | Verificar que estén ordenados de mayor a menor por `totalAdmissions` |
| Los endpoints compilan y corren | Sin errores de compilación ni runtime | Navegar a cada endpoint y verificar JSON válido |
| Los parámetros son parametrizados | Sin concatenación de strings en el SQL | Verificar que se usa `@param` y `new { param }` |

## 4. Criterios de corrección (lista de verificación)

- [ ] El archivo `Program.cs` compila sin errores ni advertencias.
- [ ] Se usa `JOIN` con la sintaxis correcta `FROM tabla_a JOIN tabla_b ON ...`.
- [ ] Cada columna del SELECT tiene alias `AS` que coincide con el record.
- [ ] Los records usan `long` para columnas INTEGER y `string?` para columnas nullable.
- [ ] `ORDER BY` está presente y al final de la consulta.
- [ ] `LIMIT` usa un parámetro `@count` y no un valor hardcodeado.
- [ ] Los endpoints devuelven `Results.Ok(...)` (nunca el objeto crudo).
- [ ] La concatenación de nombres usa `||` (operador de SQLite), no `+`.
- [ ] Los comentarios en el código están en español y no contienen tildes ni eñes.
- [ ] Los records están declarados después de `app.Run();`.
- [ ] Cada endpoint abre la conexión con `using var connection = new SqliteConnection(...)`.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException` en el endpoint de JOIN | Falta alias `AS` para alguna columna del SELECT. | Pedir al alumno que verifique que cada columna tenga `AS NombrePropiedad` coincidiendo con el record. |
| Los resultados no tienen orden | Falta `ORDER BY` o está mal posicionado. | Indicar que `ORDER BY` debe ir al final, después de `JOIN` y `WHERE`. |
| `LIMIT` con valor fijo en el SQL | Se escribió `LIMIT 5` en vez de `LIMIT @count`. | Mostrar que `LIMIT` también debe parametrizarse con `@count` y `new { count }`. |
| La concatenación de nombres devuelve `0` o error | Se usó `+` en vez de `||` para concatenar en SQLite. | Explicar que en SQL el operador de concatenación es `||`, no `+`. |
| `null` en `DischargeDate` causa error | El record no declara `DischargeDate` como `string?`. | Indicar que las columnas nullable de la BD requieren `?` en el record. |
| El JOIN devuelve más filas de las esperadas | Se usó un `JOIN` incorrecto o falta la condición `ON`. | Revisar la condición del `ON` y verificar que la relación FK→PK sea correcta. |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Comprensión del JOIN | Observar si los alumnos entienden que el JOIN une filas de dos tablas por una columna compartida. |
| Uso de ORDER BY | Verificar que los alumnos colocan `ORDER BY` al final de la consulta y no en medio. |
| Uso de LIMIT con parámetros | Registrar si los alumnos parametrizan `LIMIT` o usan valores hardcodeados. |
| Errores de alias | Documentar qué alumnos tuvieron errores por falta de alias `AS` y cómo los resolvieron. |
| Concatenación con `||` | Anotar si los alumnos usaron `+` en vez de `||` para concatenar en SQLite. |
| Trabajo en pareja | Observar la distribución de roles en cada pareja y registrar quiénes lideraron la escritura del SQL. |
