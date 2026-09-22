# Encuentro 12 — Dapper: Query\<T\> con alias

**Unidad 2:** Acceso a datos con SQLite y Dapper  
**Duración:** 240 minutos  
**Carácter:** Procedimental  
**Eje 4:** Dapper y consultas parametrizadas  

---

## Objetivos de aprendizaje

- Instalar el paquete Dapper y entender qué problema resuelve.
- Definir un record posicional en C# que refleje una tabla de la base de datos.
- Escribir una consulta SELECT con alias AS para que Dapper lo mapee automaticamente.
- Usar `Query<T>` para obtener una lista de objetos.

---

## Charla rápida

Hasta ahora leían la base de datos como si tuvieran que copiar a mano cada ficha de la biblioteca: abrían el archivo, leían fila por fila, extraían cada campo con `GetInt64`, `GetString`, verificaban NULL... Es mucho trabajo repetitivo. Dapper es un asistente que hace toda esa transcripción de forma automática: se le pasa la consulta SQL y el tipo de objeto que se espera, y él devuelve una lista ya mapeada. Menos código, menos errores.

---

## Teoría mínima

### ¿Qué es Dapper?

Dapper es un "micro-ORM" (Object-Relational Mapper) que convierte automaticamente filas de la base de datos en objetos de C#. Se agrega como paquete NuGet y se usa junto con `Microsoft.Data.Sqlite`.

### Records posicionales

Un record posicional declara propiedades inmutables en una sola línea. El orden y tipo de los parametros del constructor deben coincidir con las columnas del SELECT:

```csharp
public record Patient(long PatientId, string FirstName, string LastName);
```

### Alias AS: la regla de oro

Las columnas en la base usan `snake_case` (`patient_id`). C# usa `PascalCase` (`PatientId`). Para que Dapper pueda mapear, **siempre** se usa alias AS en el SELECT:

```sql
SELECT patient_id AS PatientId, first_name AS FirstName FROM patients
```

Sin alias, Dapper busca un constructor con parametros llamados `patient_id` y `first_name`, que no existen.

### Query\<T\> y QueryFirstOrDefault\<T\>

| Método | Devuelve | Uso |
|--------|----------|-----|
| `connection.Query<T>(sql)` | `List<T>` con todas las filas | Lectura de muchas filas |
| `connection.QueryFirstOrDefault<T>(sql, new { id })` | Una fila o `null` | Lectura de una fila por ID |

---

## Práctica guiada

Van a crear un proyecto con Dapper, definir un record `Patient` y escribir un endpoint que devuelva todos los pacientes con el nombre de su provincia.

### Paso 1: Crear el proyecto

```bash
dotnet new web -o dapper-basico
cd dapper-basico
```

Copiar `hospital.db` junto al `.csproj`. Agregar los dos paquetes:

```bash
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 2: Escribir el código

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// Record posicional: coincide con la consulta JOIN
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

// GET /patients-with-province — todos los pacientes con nombre de provincia
app.MapGet("/patients-with-province", () =>
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
        ORDER BY p.last_name, p.first_name
    ").ToList();

    return Results.Ok(patients);
});

app.Run();
```

### Paso 3: Probar

```bash
dotnet run
```

Ir a `http://localhost:5000/patients-with-province`. Observar:
- El JSON usa camelCase automaticamente (`patientId`, `firstName`, `provinceName`).
- No hay ningun `SqliteDataReader`, `while`, `reader.Read()` ni `GetString`.
- Dapper hizo todo el mapeo con solo `Query<T>(sql).ToList()`.

---

## Ejercicio independiente

**Consigna:** Crear un endpoint `/doctors` que devuelva todos los médicos de la tabla `doctors` usando Dapper y un record `Doctor`. Incluir las cuatro columnas: `doctor_id`, `first_name`, `last_name`, `specialty`.

**Pista:** El record va después de `app.Run()`. Los alias AS son obligatorios. Usar `Query<Doctor>(sql).ToList()`.

**Solución esperada:**

```csharp
// Record y endpoint al final del archivo
public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// GET /doctors — listado de medicos con Dapper
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name
    ").ToList();

    return Results.Ok(doctors);
});
```

---

### Qué te llevás

- Dapper elimina el código repetitivo de lectura de datos.
- Los records posicionales definen la estructura.
- Los alias AS enlazan las columnas snake_case con las propiedades PascalCase.
- `Query<T>` devuelve una lista ya mapeada.

### Lo que viene

En el Encuentro 13 se filtran datos con parámetros y `LIKE`, usando `@` y objetos anónimos.

## Errores comunes y trampas

| Error | Causa | Solución |
|-------|-------|----------|
| `InvalidOperationException`: no constructor coincide | Un tipo de columna no coincide con el parametro del record | Verificar que `patient_id` (INTEGER) se lea como `long`, no `int`. Fechas como `string`, no `DateTime` |
| `InvalidOperationException`: constructor no encontrado | El alias AS no se usó y Dapper busca `patient_id` en el record | Agregar `SELECT patient_id AS PatientId, ...` |
| `CS8803`: record antes de `app.Run()` | Las top-level statements deben preceder a las declaraciones de tipos | Mover el record después de `app.Run()` |
| Dapper no devuelve filas | La consulta SQL no coincide con ningún registro | Probar el SQL directamente contra la base con `sqlite3 hospital.db` |
| El record usa `int` para `DoctorId` | `InvalidOperationException` por tipo `Int64` de SQLite | Usar `long DoctorId` |
| Se olvida el `.ToList()` | `Query<T>` devuelve `IEnumerable<T>`, no falla pero no es una lista concreta | Agregar `.ToList()` |

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|--------|---------|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |
| **Total** | **240** |