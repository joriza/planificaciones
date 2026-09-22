# Encuentro 11 — SQL: JOIN y ORDER BY

> Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 11 de 36 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Eje temático | 3 — SQLite y SQL básico |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | SQL: JOIN y ORDER BY |
| Requisitos previos | Haber completado el Encuentro 10; saber ejecutar un SELECT simple con Dapper; conocer la estructura de `hospital.db` (tablas `patients`, `doctors`, `province_names`, `admissions`). |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo en parejas; cada pareja tiene su copia del proyecto con `hospital.db` en la raíz. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Explicar qué es un JOIN en SQL y cuándo se necesita combinar datos de dos tablas.
2. Escribir un JOIN entre `patients` y `province_names` para obtener el nombre completo de la provincia.
3. Usar `ORDER BY` para ordenar resultados y `LIMIT` para restringir la cantidad de filas devueltas.
4. Combinar `JOIN`, `ORDER BY` y `LIMIT` en una sola consulta parametrizada con Dapper.

## 3. Apertura y motivación (20 min)

### Recap del Encuentro 10

El docente pide que cada pareja abra su proyecto y navegue a `http://localhost:5000/patients`. Se pregunta: ¿qué pasa si necesitamos saber el nombre de la provincia de cada paciente? La tabla `patients` solo tiene `province_id` (como `ON`, `BC`), no el nombre completo. Necesitamos traer datos de otra tabla.

### Introducción al JOIN

Cuando los datos están repartidos en varias tablas, necesitamos unirlos. En SQL esto se hace con un `JOIN`. Pensalo como una reunión: tenés una mesa con las fichas de pacientes y otra mesa con las fichas de provincias. El `JOIN` es el acto de juntar ambas mesas y buscar la ficha que coincide.

## 4. Desarrollo teórico-práctico (120 min)

### Teoría: JOIN entre dos tablas

Un `JOIN` conecta dos tablas a través de una columna que comparten. En nuestra base, `patients.province_id` es una clave foránea que apunta a `province_names.province_id`.

La sintaxis canónica es:

```sql
SELECT columnas_de_la_tabla_1, columnas_de_la_tabla_2
FROM tabla_1
JOIN tabla_2 ON tabla_1.columna_fk = tabla_2.columna_pk
ORDER BY alguna_columna
LIMIT cantidad;
```

**Reglas importantes:**
- Siempre se usa `AS` para renombrar las columnas y que coincidan con los nombres del record C#.
- `ORDER BY` va al final de la consulta (después del `JOIN` y el `WHERE` si lo hubiera).
- `LIMIT` restringe la cantidad de filas devueltas; es útil para probar sin traer todos los registros.

### Práctica guiada: JOIN patients + province_names

Vamos a crear un endpoint que devuelva cada paciente con el nombre de su provincia. Esto requiere unir las tablas `patients` y `province_names`.

```csharp
// Program.cs — Ejemplo completo: JOIN entre patients y province_names
// Usar Dapper y Microsoft.Data.Sqlite para conectarse a la base

using Dapper;
using Microsoft.Data.Sqlite;

// Cadena de conexion fija: apunta al archivo hospital.db
var connectionString = "Data Source=hospital.db";

// Crear la aplicacion web con Minimal API
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients-with-province — listar pacientes con el nombre de su provincia
// Usa un JOIN entre la tabla patients y la tabla province_names
app.MapGet("/patients-with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN entre patients y province_names usando province_id como clave
    // El alias AS ProvinceName permite que Dapper mapee a la propiedad del record
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

// GET /patients-with-province/top/{count} — top N pacientes ordenados por apellido
app.MapGet("/patients-with-province/top/{count:long}", (long count) =>
{
    using var connection = new SqliteConnection(connectionString);

    // LIMIT usa un parametro para evitar inyeccion SQL
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
        LIMIT @count", new { count }).ToList();

    return Results.Ok(patients);
});

// Arrancar la aplicacion
app.Run();

// Record para pacientes con nombre de provincia
public record PatientWithProvince(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    string ProvinceName,
    string? Allergies,
    long? Height,
    long? Weight
);
```

**Salida esperada al navegar a `http://localhost:5000/patients-with-province` (primeros 3 registros, ordenados por apellido):**

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
  },
  {
    "patientId": 3,
    "firstName": "Jiji",
    "lastName": "Sharma",
    "gender": "F",
    "birthDate": "1990-05-15",
    "city": "Toronto",
    "provinceName": "Ontario",
    "allergies": "Sulfa",
    "height": 162,
    "weight": 55
  }
]
```

**Salida esperada al navegar a `http://localhost:5000/patients-with-province/top/2`:**

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

### Práctica guiada: JOIN patients + doctors a través de admissions

Ahora vamos a conectar pacientes con los médicos que los atendieron. Esto requiere unir `admissions` con `patients` y con `doctors`.

```csharp
// GET /admissions-with-details — listar ingresos con nombre de paciente y medico
app.MapGet("/admissions-with-details", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // JOIN triple: admissions + patients + doctors
    // Usamos alias para cada columna y AS para mapear al record
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
        LIMIT 5
    ").ToList();

    return Results.Ok(admissions);
});
```

Record correspondiente:

```csharp
// Record para admisiones con datos completos de paciente y medico
public record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty
);
```

**Salida esperada al navegar a `http://localhost:5000/admissions-with-details`:**

```json
[
  {
    "admissionDate": "2019-06-02",
    "dischargeDate": "2019-06-05",
    "diagnosis": "Pneumonia",
    "patientName": "Donald Waterfield",
    "doctorName": "Claude Walls",
    "doctorSpecialty": "Internist"
  },
  {
    "admissionDate": "2019-06-01",
    "dischargeDate": null,
    "diagnosis": "Asthma",
    "patientName": "Mickey Baasha",
    "doctorName": "Joshua Green",
    "doctorSpecialty": "Cardiologist"
  },
  {
    "admissionDate": "2019-05-30",
    "dischargeDate": "2019-06-01",
    "diagnosis": "Appendicitis",
    "patientName": "Jiji Sharma",
    "doctorName": "Miriam Tregre",
    "doctorSpecialty": "General Surgeon"
  }
]
```

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- Un `JOIN` conecta dos tablas a través de una columna que comparten (clave foránea → clave primaria).
- La sintaxis es `FROM tabla_a JOIN tabla_b ON tabla_a.fk = tabla_b.pk`.
- `ORDER BY` ordena los resultados; va al final de la consulta.
- `LIMIT` restringe la cantidad de filas; se usa con un parámetro `@count` para evitar inyección SQL.
- En Dapper, siempre se usa alias `AS` para que las columnas coincidan con los nombres del record.
- Se pueden encadenar varios `JOIN` (hasta 2 tablas en esta unidad).

### Lo que viene

Encuentro 12: Dapper: Query<T> con alias — vamos a profundizar en cómo Dapper mapea los resultados a records y vamos a usar alias de columnas con `AS` de forma más elaborada.

## 6. Actividad complementaria (80 min)

### Practicar JOINs y ORDER BY con diferentes combinaciones

En esta actividad vas a crear endpoints que combinen datos de distintas tablas usando `JOIN`, `ORDER BY` y `LIMIT`.

**Consigna 1 — Pacientes de una provincia específica (25 min):**
Creá un endpoint `GET /patients-by-province/{provinceId}` que devuelva los pacientes de una provincia dada, ordenados por apellido. Usá un parámetro `@provinceId` en la consulta.

Pista: el `provinceId` llega por el path y es un string (como `"ON"` o `"BC"`).

**Consigna 2 — Ingresos por especialidad del médico (25 min):**
Creá un endpoint `GET /admissions-by-specialty/{specialty}` que devuelva los ingresos filtrados por la especialidad del médico tratante. Usá un `JOIN` entre `admissions` y `doctors`.

Pista: la especialidad es un texto como `"Cardiologist"` o `"General Surgeon"`. Usá `LIKE` con el parámetro para permitir búsquedas parciales.

**Consigna 3 — Top 10 pacientes con más ingresos (30 min):**
Creá un endpoint `GET /top-patients/{count}` que devuelva los pacientes con más ingresos, ordenados de mayor a menor. Esto requiere un `GROUP BY` con `COUNT(*)` y un `ORDER BY` con `DESC`.

Pista: agrupá por `patient_id` y contá las filas en `admissions`. Limitá los resultados con `LIMIT @count`.

## 7. Errores comunes y trampas

| Error observable | Causa probable | Cómo intervenir |
| --- | --- | --- |
| `InvalidOperationException` al usar JOIN | Falta alias `AS` para alguna columna; Dapper no encuentra el constructor que coincida. | Verificar que cada columna del SELECT tenga `AS NombrePropiedad` que coincida con el record. |
| Los resultados no están ordenados | Falta `ORDER BY` en la consulta SQL. | Agregar `ORDER BY` al final del SELECT; sin él, el orden no está garantizado. |
| `LIMIT` no funciona con parámetros | Se escribió `LIMIT count` en vez de `LIMIT @count`. | Usar siempre `@count` con `new { count }` para parametrizar el LIMIT. |
| El JOIN devuelve filas duplicadas | Se usó `JOIN` en vez de `LEFT JOIN` y hay pacientes sin provincia. | Revisar si la relación es obligatoria o opcional; en este curso, usar `JOIN` cuando la relación es 1:N y todos los registros tienen la clave foránea. |
| La concatenación de nombres falla | Se usó `+` en vez de `||` para concatenar en SQLite. | En SQL de SQLite, el operador de concatenación es `||`, no `+`. |
| `null` en `DischargeDate` genera error | El record no declara `DischargeDate` como nullable (`string?`). | Declarar `string? DischargeDate` en el record para aceptar valores NULL de la BD. |
