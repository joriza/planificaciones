# Esquema de la Base de Datos — hospital.db

## Resumen
Base de datos SQLite para un sistema hospitalario con 4 tablas principales que modelan pacientes, médicos, ingresos hospitalarios y provincias/territorios canadienses.

## Tablas

### province_names
Tabla de referencia para provincias y territorios de Canadá.

| Columna | Tipo | Restricciones | Descripción |
|---------|------|---------------|-------------|
| province_id | TEXT | PRIMARY KEY | Código de 2 letras (p.ej., 'ON', 'BC') |
| province_name | TEXT | NOT NULL | Nombre completo de la provincia/territorio |

**Registros**: 13 (todas las provincias y territorios de Canadá)

---

### doctors
Médicos del hospital con su especialidad.

| Columna | Tipo | Restricciones | Descripción |
|---------|------|---------------|-------------|
| doctor_id | INTEGER | PRIMARY KEY | Identificador único |
| first_name | TEXT | NOT NULL | Nombre |
| last_name | TEXT | NOT NULL | Apellido |
| specialty | TEXT | NOT NULL | Especialidad médica |

**Registros**: 27 médicos

**Especialidades representadas**:
- Internist, Cardiologist, General Surgeon, Obstetrician/Gynecologist
- Gastroenterologist, Psychiatrist, Oncologist, Pediatrician
- Neurologist, Orthopaedic Surgeon, Respirologist
- Cardiovascular Surgeon, Nuclear Medicine, Gerontologist
- Urologist

---

### patients
Pacientes del hospital con información demográfica y clínica.

| Columna | Tipo | Restricciones | Descripción |
|---------|------|---------------|-------------|
| patient_id | INTEGER | PRIMARY KEY | Identificador único |
| first_name | TEXT | NOT NULL | Nombre |
| last_name | TEXT | NOT NULL | Apellido |
| gender | TEXT | NOT NULL | 'M' o 'F' |
| birth_date | TEXT | NOT NULL | Fecha ISO 'YYYY-MM-DD' |
| city | TEXT | NULLABLE | Ciudad de residencia |
| province_id | TEXT | NOT NULL, FK → province_names | Provincia/territorio |
| allergies | TEXT | NULLABLE | Alergias conocidas |
| height | INTEGER | NULLABLE | Altura en cm |
| weight | INTEGER | NULLABLE | Peso en kg |

**Registros**: 258 pacientes

**Distribución por provincia**: Mayoría en ON (Ontario), algunos en NS (Nova Scotia), BC (British Columbia), AB (Alberta), SK (Saskatchewan)

**Alergias comunes**: Penicillin, Sulfa, Codeine, Peanuts, Eggs, Wheat, ASA, Tylenol, y varias otras

---

### admissions
Ingresos hospitalarios que vinculan pacientes con médicos.

| Columna | Tipo | Restricciones | Descripción |
|---------|------|---------------|-------------|
| patient_id | INTEGER | NOT NULL, FK → patients | Paciente ingresado |
| admission_date | TEXT | NOT NULL | Fecha ingreso (ISO 'YYYY-MM-DD') |
| discharge_date | TEXT | NULLABLE | Fecha alta (ISO 'YYYY-MM-DD') |
| diagnosis | TEXT | NULLABLE | Diagnóstico |
| attending_doctor_id | INTEGER | NOT NULL, FK → doctors | Médico tratante |

**Registros**: 306+ ingresos

**Rango de fechas**: 2018-06-07 a 2019-06-02

**Clave compuesta implícita**: (patient_id, admission_date) — un paciente puede tener múltiples ingresos

---

## Relaciones

```
province_names (1) ───< (N) patients
    │
    └─ province_id

doctors (1) ───< (N) admissions
    │
    └─ doctor_id

patients (1) ───< (N) admissions
    │
    └─ patient_id
```

**Integridad referencial**: SQLite tiene `PRAGMA foreign_keys = ON` activado en el script de creación.

---

## Notas técnicas para el curso

- **Motor**: SQLite (archivo único `hospital.db`)
- **Acceso a datos**: Dapper (no Entity Framework)
- **Archivo principal**: Solo `Program.cs` — evitar archivos adicionales
- **Fechas**: Formato ISO 'YYYY-MM-DD' para ordenamiento correcto
- **Tipos**: SQLite usa tipado dinámico; TEXT para strings y fechas, INTEGER para números enteros