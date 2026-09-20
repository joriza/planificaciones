# Evaluación U3 — Versión B: CRUD sobre pacientes con JOIN triple

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | B |
| Versiones equivalentes | A (CRUD sobre doctores con JOIN triple) |
| Dominio de datos CRUD | `patients` |
| JOIN triple | `admissions` + `patients` + `doctors` |
| Proyecto base | `tp-u3/` |

## Consigna

Construir una Minimal API con CRUD completo sobre la tabla `patients` de `hospital.db`, más un endpoint de lectura con JOIN triple sobre `admissions`. Usar Dapper para todas las operaciones, registros posicionales con tipos canónicos y respuestas HTTP canónicas.

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/patients` | Lista todos los pacientes ordenados por `last_name`. |
| GET | `/patients/{id:long}` | Devuelve un paciente por ID; 404 si no existe. |
| POST | `/patients` | Crea un paciente. Validar que `FirstName` no esté vacío. Devolver 201 con URL. |
| PUT | `/patients/{id:long}` | Actualiza un paciente existente. Validar `FirstName`. Devolver 204. 404 si no existe. |
| DELETE | `/patients/{id:long}` | Elimina un paciente. Devolver 204. 404 si no existe. |
| GET | `/admissions/{id:long}` | Devuelve una admisión con datos del paciente y del doctor (JOIN triple). 404 si no existe. |

### Records necesarios

```csharp
record PatientInput(string FirstName, string LastName, string Gender,
                    string BirthDate, string? City, string ProvinceId,
                    string? Allergies, long? Height, long? Weight);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);

record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       string? DischargeDate, long PatientId, string PatientFirstName,
                       string? PatientLastName, long DoctorId, string DoctorFirstName,
                       string? DoctorLastName);
```

### Requisitos técnicos

- POST: usar `ExecuteScalar<long>` con `last_insert_rowid()`.
- PUT: verificar existencia con `QueryFirstOrDefault` antes de actualizar.
- DELETE: verificar filas afectadas con el resultado de `Execute`.
- Validación: `string.IsNullOrWhiteSpace(input.FirstName)` → `400 BadRequest`.
- JOIN triple: `admissions` → `patients` → `doctors` con alias `AS` en cada columna.
- Todos los mensajes de error en español.

### Entrega en GitHub

```bash
mkdir -p tp-u3
git add .
git commit -m "tp-u3: CRUD pacientes con JOIN triple"
git push
```

## Puntaje

100 puntos según rúbrica maestra de U3.

## Criterios de corrección específicos

| Criterio | Esperado |
|---|---|
| Validación POST/PUT | `string.IsNullOrWhiteSpace` sobre `FirstName` |
| 201 Created | `Results.Created($"/patients/{newId}", patient)` |
| 204 NoContent | `Results.NoContent()` en PUT y DELETE exitosos |
| JOIN triple columnas | `admission_id AS AdmissionId`, `patient_id AS PatientId`, `doctor_id AS DoctorId` |
| Tipos canónicos | `long PatientId`, `string BirthDate`, `long? Height`/`Weight` |