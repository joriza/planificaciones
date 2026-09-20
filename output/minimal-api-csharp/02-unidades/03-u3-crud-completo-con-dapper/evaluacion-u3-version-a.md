# Evaluación U3 — Versión A: CRUD sobre doctores con JOIN triple

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | A |
| Versiones equivalentes | B (CRUD sobre pacientes con JOIN triple) |
| Dominio de datos CRUD | `doctors` |
| JOIN triple | `admissions` + `doctors` + `patients` |
| Proyecto base | `tp-u3/` |

## Consigna

Construir una Minimal API con CRUD completo sobre la tabla `doctors` de `hospital.db`, más un endpoint de lectura con JOIN triple sobre `admissions`. Usar Dapper para todas las operaciones, registros posicionales con tipos canónicos y respuestas HTTP canónicas.

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/doctors` | Lista todos los doctores. |
| GET | `/doctors/{id:long}` | Devuelve un doctor por ID; 404 si no existe. |
| POST | `/doctors` | Crea un doctor. Validar que `FirstName` no esté vacío. Devolver 201 con URL. |
| PUT | `/doctors/{id:long}` | Actualiza un doctor existente. Validar `FirstName`. Devolver 204. 404 si no existe. |
| DELETE | `/doctors/{id:long}` | Elimina un doctor. Devolver 204. 404 si no existe. |
| GET | `/admissions/{id:long}` | Devuelve una admisión con datos del doctor y del paciente (JOIN triple). 404 si no existe. |

### Records necesarios

```csharp
record DoctorInput(string FirstName, string? LastName, string? Specialty,
                   string? Phone, string? Email);

record Doctor(long DoctorId, string FirstName, string? LastName, string? Specialty,
              string? Phone, string? Email);

record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       string? DischargeDate, long DoctorId, string DoctorFirstName,
                       string? DoctorLastName, long PatientId, string PatientFirstName,
                       string? PatientLastName);
```

### Requisitos técnicos

- POST: usar `ExecuteScalar<long>` con `last_insert_rowid()`.
- PUT: verificar existencia con `QueryFirstOrDefault` antes de actualizar.
- DELETE: verificar filas afectadas con el resultado de `Execute`.
- Validación: `string.IsNullOrWhiteSpace(input.FirstName)` → `400 BadRequest`.
- JOIN triple: `admissions` → `doctors` → `patients` con alias `AS` en cada columna.
- Todos los mensajes de error en español.

### Entrega en GitHub

```bash
mkdir -p tp-u3
git add .
git commit -m "tp-u3: CRUD doctores con JOIN triple"
git push
```

## Puntaje

100 puntos según rúbrica maestra de U3.

## Criterios de corrección específicos

| Criterio | Esperado |
|---|---|
| Validación POST/PUT | `string.IsNullOrWhiteSpace` sobre `FirstName` |
| 201 Created | `Results.Created($"/doctors/{newId}", doctor)` |
| 204 NoContent | `Results.NoContent()` en PUT y DELETE exitosos |
| JOIN triple columnas | `admission_id AS AdmissionId`, `doctor_id AS DoctorId`, `patient_id AS PatientId`, más nombres |