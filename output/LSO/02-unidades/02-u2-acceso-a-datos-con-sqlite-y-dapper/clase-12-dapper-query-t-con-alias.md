# Encuentro 12 — Dapper: Query<T> con alias

> Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 12 de 36 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Eje temático | 4 — Dapper y consultas parametrizadas |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Dapper: Query<T> con alias |
| Requisitos previos | Haber completado el Encuentro 11; saber ejecutar JOINs simples; conocer los tipos canónicos de mapeo (INTEGER → long, TEXT → string, nullable → ?). |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual; cada alumno tiene su proyecto con `hospital.db` en la raíz. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Crear records C# que coincidan exactamente con los tipos devueltos por las columnas de SQLite.
2. Usar alias `AS` en el SELECT para mapear columnas snake_case a las propiedades PascalCase del record.
3. Llamar a `Query<T>` de Dapper y entender cómo materializa las filas en objetos del tipo T.
4. Depurar errores de mapeo cuando los tipos o los nombres no coinciden.

## 3. Apertura y motivación (20 min)

### Recap del Encuentro 11

El docente pide que cada alumno ejecute el endpoint `/patients-with-province` que crearon en el encuentro anterior. Se pregunta: ¿qué pasa si cambiamos `long PatientId` por `int PatientId` en el record? ¿Qué pasa si olvidamos un alias `AS`?

### De SQL puro a Dapper: el mapeo es la clave

Dapper es una librería que transforma las filas de un resultado SQL en objetos C#. Pero para que esa transformación funcione, tiene que haber una coincidencia exacta entre:

1. El nombre de la columna (después del alias `AS`).
2. El nombre del parámetro en el constructor del record.
3. El tipo de la columna en la base de datos.
4. El tipo del parámetro en el constructor del record.

Si falta alguna de esas coincidencias, Dapper lanza un `InvalidOperationException`.

**Analogía rápida:** pensá en Dapper como un mensajero que entrega paquetes. Cada paquete tiene una etiqueta (el alias `AS`) y el destinatario (el parámetro del record). Si la etiqueta no coincide con el nombre del destinatario, el paquete no se entrega y hay un error.

## 4. Desarrollo teórico-práctico (120 min)

### Teoría: el mapeo de Dapper y los alias

Dapper usa la reflexión para encontrar un constructor en el tipo T cuyos parámetros coincidan con los nombres de las columnas del resultado. Si la columna se llama `patient_id` pero el record espera `PatientId`, Dapper no encuentra el constructor y lanza un error.

La solución es siempre usar alias `AS` en el SELECT:

```sql
SELECT patient_id AS PatientId, first_name AS FirstName, ...
```

Esto le dice a Dapper: "la columna `patient_id` se llama `PatientId` en el resultado".

### Práctica guiada: mapear resultados a records

Vamos a crear un record para la tabla `doctors` y un endpoint que lo use.

```csharp
// Program.cs — Ejemplo completo: Query<T> con alias para la tabla doctors
// Usar Dapper y Microsoft.Data.Sqlite para conectarse a la base

using Dapper;
using Microsoft.Data.Sqlite;

// Cadena de conexion fija: apunta al archivo hospital.db
var connectionString = "Data Source=hospital.db";

// Crear la aplicacion web con Minimal API
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /doctors — listar todos los medicos
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Query<T> devuelve IEnumerable<T>; llamamos ToList() para materializar
    // Cada columna necesita alias AS que coincida con el constructor del record
    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name, first_name
    ").ToList();

    return Results.Ok(doctors);
});

// GET /doctors/{id:long} — obtener un medico por su ID
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // QueryFirstOrDefault<T> devuelve null si no encuentra filas
    var doctor = connection.QueryFirstOrDefault<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @id", new { id });

    return doctor is null
        ? Results.NotFound(new { mensaje = "Medico no encontrado" })
        : Results.Ok(doctor);
});

// Arrancar la aplicacion
app.Run();

// Record para medicos: todos los tipos deben coincidir con lo que devuelve la BD
// doctor_id es INTEGER -> long (no int)
// first_name, last_name, specialty son TEXT -> string
public record Doctor(
    long DoctorId,
    string FirstName,
    string LastName,
    string Specialty
);
```

**Salida esperada al navegar a `http://localhost:5000/doctors` (primeros 3 registros):**

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

**Salida esperada al navegar a `http://localhost:5000/doctors/1`:**

```json
{
  "doctorId": 1,
  "firstName": "Claude",
  "lastName": "Walls",
  "specialty": "Internist"
}
```

**Salida esperada al navegar a `http://localhost:5000/doctors/999`:**

```json
{
  "mensaje": "Medico no encontrado"
}
```

### Práctica guiada: demostración de errores de mapeo

El docente muestra intencionalmente qué pasa cuando hay errores de mapeo. Esto es fundamental para que los alumnos sepan diagnosticar problemas.

**Error 1: usar `int` en vez de `long`**

```csharp
// ESTO FALLA: doctor_id es INTEGER en SQLite, que devuelve Int64 (long)
public record DoctorWrong(
    int DoctorId,    // ERROR: debe ser long
    string FirstName,
    string LastName,
    string Specialty
);
```

**Error esperado en la terminal:**

```
InvalidOperationException: No constructor matching type 'System.Int64' found on type 'DoctorWrong'
```

**Error 2: olvidar el alias `AS`**

```csharp
// ESTO FALLA: sin alias, Dapper busca un constructor con parametro "doctor_id"
var doctors = connection.Query<Doctor>(@"
    SELECT doctor_id, first_name, last_name, specialty
    FROM doctors
").ToList();
```

**Error esperado en la terminal:**

```
InvalidOperationException: No constructor matching type 'System.Int64' found on type 'Doctor'
```

**Error 3: usar `DateTime` para una columna TEXT**

```csharp
// ESTO FALLA: birth_date es TEXT en SQLite, Dapper devuelve string
public record PatientWrong(
    long PatientId,
    string FirstName,
    DateTime BirthDate   // ERROR: debe ser string
);
```

**Error esperado en la terminal:**

```
InvalidOperationException: No constructor matching type 'System.String' found on type 'PatientWrong'
```

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- Dapper mapea filas SQL a objetos C# buscando un constructor cuyos parámetros coincidan con los nombres de las columnas del resultado.
- Siempre se usa alias `AS` en el SELECT para que los nombres de columna coincidan con los parámetros del record.
- Los tipos deben coincidir exactamente: INTEGER de SQLite → `long` en C# (nunca `int`).
- TEXT de SQLite → `string` en C# (nunca `DateTime` ni `DateOnly`).
- Si una columna puede ser NULL, la propiedad del record debe llevar `?`.
- `Query<T>` devuelve `IEnumerable<T>`; `QueryFirstOrDefault<T>` devuelve `T?` (null si no hay resultados).

### Lo que viene

Encuentro 13: Parámetros y LIKE en Dapper — vamos a aprender a usar parámetros en las consultas y a buscar con `LIKE`.

## 6. Actividad complementaria (80 min)

### Crear records y mapear resultados con Dapper

En esta actividad vas a practicar la creación de records y su mapeo con Dapper.

**Consigna 1 — Record para `province_names` (20 min):**
1. Creá un record `Province` con las columnas de la tabla `province_names`.
2. Creá un endpoint `GET /provinces` que devuelva todas las provincias.
3. Probalo y verificá que la salida sea correcta.

**Consigna 2 — Record para `admissions` (30 min):**
1. Creá un record `Admission` con las columnas de la tabla `admissions`.
2. Creá un endpoint `GET /admissions` que devuelva los primeros 10 ingresos.
3. Creá un endpoint `GET /admissions/patient/{patientId:long}` que devuelva todos los ingresos de un paciente.
4. Probalos y verificá las salidas.

**Consigna 3 — Depuración de mapeo (30 min):**
1. Tomá el endpoint `/doctors` que creaste en la práctica guiada.
2. Cambiá intencionalmente `long DoctorId` por `int DoctorId`.
3. Ejecutá el endpoint y observá el error en la terminal.
4. Corregí el error y verificá que vuelva a funcionar.
5. Repetí con `string BirthDate` → `DateTime BirthDate` en un record de pacientes.

## 7. Errores comunes y trampas

| Error observable | Causa probable | Cómo intervenir |
| --- | --- | --- |
| `InvalidOperationException`: no constructor match | El tipo del parámetro del record no coincide con el tipo de la columna (p.ej., `int` en vez de `long`). | Verificar que INTEGER → `long`, TEXT → `string`, y que los nullable lleven `?`. |
| `InvalidOperationException`: no constructor match | Falta alias `AS` en el SELECT; Dapper busca `patient_id` pero el record tiene `PatientId`. | Mostrar que cada columna necesita `AS NombrePropiedad` que coincida exactamente. |
| El JSON muestra `birthDate` como `"1963-02-12"` sin formato local | La fecha viaja como string ISO desde la BD; no se convierte en el record. | Explicar que las fechas se convierten solo al presentar, nunca en el record ni en la consulta. |
| `null` aparece como cadena vacía en el JSON | La propiedad nullable no lleva `?` en la declaración del record. | Declarar como `string?` o `long?` según el tipo canónico. |
| El endpoint devuelve una lista vacía | La consulta no tiene `WHERE` y la tabla está vacía, o la conexión no apunta a la base correcta. | Verificar que `hospital.db` esté en la carpeta correcta y que la cadena de conexión sea `"Data Source=hospital.db"`. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |
