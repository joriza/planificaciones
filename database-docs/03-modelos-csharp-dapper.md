# Modelos C# para Dapper — hospital.db

> **Nota para el curso**: Estos modelos van en `Program.cs` para mantener la restricción de un solo archivo. Se usan `record` (C# 9+) por inmutabilidad y simplicidad.
> Tipos canónicos según `minimal-api-csharp/convenciones-tecnicas.md`: ids `long` para columnas INTEGER de SQLite; fechas `string` ("YYYY-MM-DD").

## Registros (Records)

```csharp
// Provincia / Territorio
public record Province(string ProvinceId, string ProvinceName);

// Médico
public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// Paciente
public record Patient(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,           // "M" o "F"
    string BirthDate,        // "YYYY-MM-DD" (TEXT en SQLite)
    string? City,
    string ProvinceId,
    string? Allergies,
    int? Height,             // cm
    int? Weight              // kg
);

// Ingreso hospitalario
public record Admission(
    long PatientId,
    string AdmissionDate,    // "YYYY-MM-DD" (TEXT en SQLite)
    string? DischargeDate,
    string? Diagnosis,
    long AttendingDoctorId
);

// DTOs para consultas con JOINs
public record PatientWithProvince(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,        // "YYYY-MM-DD" (TEXT en SQLite)
    string? City,
    string ProvinceName,
    string? Allergies,
    int? Height,
    int? Weight
);

public record AdmissionDetail(
    string AdmissionDate,    // "YYYY-MM-DD" (TEXT en SQLite)
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty
);

public record AdmissionBySpecialty(string Specialty, int TotalAdmissions);

public record MonthlyAdmissions(string Month, int Count);
```

## Consultas Dapper (ejemplos para clase)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

// Conexión (una sola vez al inicio)
var connectionString = "Data Source=hospital.db";
using var connection = new SqliteConnection(connectionString);
connection.Open();

// 1. Todos los pacientes con su provincia
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

// 2. Ingresos con detalle de paciente y médico
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
    ORDER BY a.admission_date DESC
").ToList();

// 3. Conteos por especialidad
var bySpecialty = connection.Query<AdmissionBySpecialty>(@"
    SELECT d.specialty AS Specialty, COUNT(*) AS TotalAdmissions
    FROM admissions a
    JOIN doctors d ON a.attending_doctor_id = d.doctor_id
    GROUP BY d.specialty
    ORDER BY TotalAdmissions DESC
").ToList();

// 4. Pacientes con alergia específica (parámetro)
string allergy = "Penicillin";
var allergicPatients = connection.Query<Patient>(@"
    SELECT * FROM patients
    WHERE allergies LIKE @allergy
", new { allergy = $"%{allergy}%" }).ToList();

// 5. Ingresos por mes
var monthly = connection.Query<MonthlyAdmissions>(@"
    SELECT strftime('%Y-%m', admission_date) AS Month, COUNT(*) AS Count
    FROM admissions
    GROUP BY strftime('%Y-%m', admission_date)
    ORDER BY Month
").ToList();

// 6. Insertar nuevo paciente (ejemplo)
long newId = connection.ExecuteScalar<long>(@"
    INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
    VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
    SELECT last_insert_rowid();
", new {
    FirstName = "Juan",
    LastName = "Pérez",
    Gender = "M",
    BirthDate = "1990-05-15",
    City = "Toronto",
    ProvinceId = "ON",
    Allergies = "Penicillin",
    Height = 175,
    Weight = 70
});

// 7. Insertar ingreso
connection.Execute(@"
    INSERT INTO admissions (patient_id, admission_date, discharge_date, diagnosis, attending_doctor_id)
    VALUES (@PatientId, @AdmissionDate, @DischargeDate, @Diagnosis, @AttendingDoctorId)
", new {
    PatientId = newId,
    AdmissionDate = "2024-01-15",
    DischargeDate = "2024-01-20",
    Diagnosis = "Appendicitis",
    AttendingDoctorId = 3
});
```

## Fechas: convención del curso

```csharp
// SQLite guarda fechas como TEXT 'YYYY-MM-DD'.
// Los records exponen la fecha como string: mapeo 1:1 con la BD, sin conversión en el acceso a datos.
// Convertir recién al presentar:

string nacimiento = "1990-05-15";                      // tal como sale de la BD
var fecha = DateTime.Parse(nacimiento);                 // para operar o mostrar en otro formato
string enFormatoLocal = fecha.ToString("dd/MM/yyyy");   // "15/05/1990"
```

## Patrones recomendados para el curso

1. **Una conexión por request** (o using block)
2. **Parámetros con objeto anónimo** para evitar inyección SQL
3. **`Query<T>`** para SELECT, **Execute** para INSERT/UPDATE/DELETE
4. **Records** para DTOs inmutables
5. **Fechas como `string`** en los records (TEXT de SQLite); convertir solo al presentar
6. **Nombres de columnas en SQL** que coincidan con propiedades (o usar alias AS)