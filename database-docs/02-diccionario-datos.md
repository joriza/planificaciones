# Diccionario de Datos — hospital.db

## province_names

| Campo | Tipo | Longitud | Nulos | Clave | Descripción | Valores ejemplo |
|-------|------|----------|-------|-------|-------------|-----------------|
| province_id | TEXT | 2 | NO | PK | Código postal canadiense de 2 letras | 'ON', 'BC', 'QC', 'AB' |
| province_name | TEXT | 50 | NO | | Nombre oficial de la provincia/territorio | 'Ontario', 'British Columbia', 'Quebec', 'Alberta' |

**Valores completos (13)**:
- AB — Alberta
- BC — British Columbia
- MB — Manitoba
- NB — New Brunswick
- NL — Newfoundland and Labrador
- NS — Nova Scotia
- NT — Northwest Territories
- NU — Nunavut
- ON — Ontario
- PE — Prince Edward Island
- QC — Quebec
- SK — Saskatchewan
- YT — Yukon

---

## doctors

| Campo | Tipo | Longitud | Nulos | Clave | Descripción | Valores ejemplo |
|-------|------|----------|-------|-------|-------------|-----------------|
| doctor_id | INTEGER | — | NO | PK | Identificador único autoincremental | 1, 2, 3, ..., 27 |
| first_name | TEXT | 50 | NO | | Nombre del médico | 'Claude', 'Joshua', 'Miriam' |
| last_name | TEXT | 50 | NO | | Apellido del médico | 'Walls', 'Green', 'Tregre' |
| specialty | TEXT | 100 | NO | | Especialidad médica | 'Internist', 'Cardiologist', 'General Surgeon' |

**Distribución de especialidades** (27 médicos):
- Cardiologist: 3 (Joshua Green, Simon Santiago, Douglas Brooks)
- Gastroenterologist: 2 (Scott Hill, Irene Brooks)
- General Surgeon: 2 (Miriam Tregre, Ralph Wilson)
- Obstetrician/Gynecologist: 2 (James Russo, Lisa Cuddy)
- Oncologist: 2 (Hazel Patterson, Stephanie Cohen)
- Nuclear Medicine: 2 (Angelica Noe, Mary Walker)
- Gerontologist: 2 (Tyrone Smart, Bobbi Estrada)
- Pediatrician: 2 (Mickey Duval, Heather Beck)
- Neurologist: 2 (Jon Nelson, Jenny Pulaski)
- Psychiatrist: 2 (Tasha Phillips, Jeanette Sites)
- Cardiovascular Surgeon: 2 (Monica Singleton, Larry Miller)
- Respirologist: 2 (Douglas Brooks, Donna Greenwood)
- Internist: 1 (Claude Walls)
- Orthopaedic Surgeon: 1 (Monica Singleton)
- Urologist: 1 (Marie Brinkman)

---

## patients

| Campo | Tipo | Longitud | Nulos | Clave | Descripción | Valores ejemplo |
|-------|------|----------|-------|-------|-------------|-----------------|
| patient_id | INTEGER | — | NO | PK | Identificador único | 1, 2, 3, ..., 258 |
| first_name | TEXT | 50 | NO | | Nombre del paciente | 'Donald', 'Mickey', 'Jiji' |
| last_name | TEXT | 50 | NO | | Apellido del paciente | 'Waterfield', 'Baasha', 'Sharma' |
| gender | TEXT | 1 | NO | | Sexo: 'M' o 'F' | 'M', 'F' |
| birth_date | TEXT | 10 | NO | | Fecha nacimiento (ISO YYYY-MM-DD) | '1963-02-12', '2017-11-19' |
| city | TEXT | 50 | SÍ | | Ciudad de residencia | 'Barrie', 'Hamilton', 'Toronto' |
| province_id | TEXT | 2 | NO | FK | Provincia (→ province_names) | 'ON', 'NS', 'BC', 'AB', 'SK' |
| allergies | TEXT | 100 | SÍ | | Alergias conocidas (texto libre) | 'Penicillin', 'Sulfa', 'Codeine', NULL |
| height | INTEGER | — | SÍ | | Altura en centímetros | 156, 185, 194, 47 |
| weight | INTEGER | — | SÍ | | Peso en kilogramos | 65, 76, 106, 10 |

**Estadísticas clave**:
- **Total pacientes**: 258
- **Rango edad**: 1 año (2017) a 98 años (1918) — nacido en 1918
- **Género**: Aprox. 50% M / 50% F
- **Provincias**: 95%+ en ON, resto distribuido en NS, BC, AB, SK
- **Con alergias**: ~40% tienen alergias registradas
- **Alergias más frecuentes**: Penicillin (~30), Sulfa (~15), Codeine (~10), Peanuts (~8)

---

## admissions

| Campo | Tipo | Longitud | Nulos | Clave | Descripción | Valores ejemplo |
|-------|------|----------|-------|-------|-------------|-----------------|
| patient_id | INTEGER | — | NO | FK | Paciente (→ patients) | 1, 3, 6, 7, 8 |
| admission_date | TEXT | 10 | NO | | Fecha ingreso (ISO YYYY-MM-DD) | '2018-09-20', '2018-11-06' |
| discharge_date | TEXT | 10 | SÍ | | Fecha alta (ISO YYYY-MM-DD) | '2018-09-20', '2018-11-08', NULL |
| diagnosis | TEXT | 200 | SÍ | | Diagnóstico médico | 'Congestive Heart Failure', 'Cancer' |
| attending_doctor_id | INTEGER | — | NO | FK | Médico tratante (→ doctors) | 24, 21, 8, 2 |

**Estadísticas clave**:
- **Total ingresos**: 306+
- **Pacientes con múltiples ingresos**: Varios (p.ej., patient_id 1, 3, 6, 9, 10, 16, 17, 18, 20, 21, 22, 23, 24, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45, 46, 47, 48, 49, 51, 52, 53, 54, 56, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 86, 87, 88, 90, 91, 92, 93, 94, 97, 98, 100, 101, 102, 103, 104, 105, 106, 108, 110, 111, 112, 113, 114, 115, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 135, 137, 139, 143, 145, 147, 148, 150, 151, 152, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 170, 171, 172, 173, 174, 176, 177, 178, 179, 180, 182, 183, 185, 186, 191, 193, 194, 197, 199, 200, 201, 202, 205, 206, 207, 208, 209, 210, 211, 212, 213, 215, 216, 221, 222, 223, 224, 226, 227, 228, 229, 230, 231, 232, 234, 235, 236, 237, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 256, 257, 258)
- **Rango temporal**: Junio 2018 – Junio 2019
- **Diagnósticos frecuentes**: Pregnancy, Appendicitis, Myocardial Infarction, Congestive Heart Failure, Cancer, Pneumonia, Asthma, Fractured Hip/Femur

---

## Consultas típicas para el curso

### 1. Pacientes con sus provincias
```sql
SELECT p.patient_id, p.first_name, p.last_name, p.city, pn.province_name
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id;
```

### 2. Ingresos con paciente y médico
```sql
SELECT a.admission_date, a.discharge_date, a.diagnosis,
       p.first_name || ' ' || p.last_name AS patient,
       d.first_name || ' ' || d.last_name AS doctor, d.specialty
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
ORDER BY a.admission_date;
```

### 3. Pacientes por especialidad del médico tratante
```sql
SELECT d.specialty, COUNT(*) as total_admissions
FROM admissions a
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
GROUP BY d.specialty
ORDER BY total_admissions DESC;
```

### 4. Pacientes con alergia a Penicillin
```sql
SELECT patient_id, first_name, last_name, allergies
FROM patients
WHERE allergies LIKE '%Penicillin%';
```

### 5. Ingresos por mes
```sql
SELECT strftime('%Y-%m', admission_date) as mes, COUNT(*) as ingresos
FROM admissions
GROUP BY strftime('%Y-%m', admission_date)
ORDER BY mes;
```