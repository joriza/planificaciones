# Encuentro 10 — SQLite y SELECT básico

**Unidad 2:** Acceso a datos con SQLite y Dapper  
**Duración:** 240 minutos  
**Carácter:** Conceptual  
**Eje 3:** SQLite y SQL básico  

---

## Objetivos de aprendizaje

- Comprender qué es SQLite y cómo se diferencia de otros motores de base de datos.
- Conectar una base SQLite desde C# usando `Microsoft.Data.Sqlite`.
- Escribir consultas SELECT con filtro WHERE.
- Ejecutar una consulta desde un endpoint GET y devolver los resultados como JSON.

---

## Charla rápida

Imaginen una biblioteca. Hasta ahora usaban una lista de libros escrita en una hoja (los datos en memoria, dentro del código). Pero una biblioteca real tiene un archivo con fichas ordenadas: se puede buscar libros por autor, por género, por año. Ese archivo es la base de datos. SQLite es un archivo único (`hospital.db`) que se consulta desde C# sin necesidad de instalar un servidor. Es como tener la biblioteca entera dentro de un cuaderno que cabe en el bolsillo.

---

## Teoría mínima

### ¿Qué es SQLite?

SQLite es un motor de base de datos que guarda todo en un solo archivo. No necesita instalación ni servicio: el archivo `hospital.db` se copia junto al proyecto y C# lo abre directamente.

### ¿Cómo consultamos desde C#?

El paquete `Microsoft.Data.Sqlite` permite enviar comandos SQL a ese archivo y leer los resultados. Los pasos son siempre los mismos:

1. Crear una conexión con `SqliteConnection("Data Source=hospital.db")`.
2. Abrir la conexión.
3. Crear un comando con el texto SQL.
4. Ejecutar el comando y leer los resultados con `ExecuteReader()`.
5. Cerrar la conexión (automaticamente con `using`).

### SELECT con WHERE

```sql
SELECT columnas FROM tabla WHERE condicion
```

Ejemplo real:

```sql
SELECT patient_id, first_name, last_name FROM patients WHERE province_id = 'ON'
```

Eso devuelve solo los pacientes de Ontario.

---

## Práctica guiada

Van a crear un proyecto nuevo y escribir un endpoint GET que consulte la base `hospital.db` y devuelva los pacientes de Ontario.

### Paso 1: Crear el proyecto

```bash
dotnet new web -o consulta-sqlite
cd consulta-sqlite
```

### Paso 2: Copiar la base de datos

Copiar `hospital.db` a la carpeta del proyecto (`consulta-sqlite/`), junto al archivo `.csproj`.

### Paso 3: Agregar el paquete NuGet

```bash
dotnet add package Microsoft.Data.Sqlite
```

### Paso 4: Escribir el código

Reemplazar todo el `Program.cs` con el siguiente código:

```csharp
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// GET /patients-on — listar pacientes de Ontario
app.MapGet("/patients-on", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    connection.Open();

    // Crear comando con la consulta SQL
    var command = connection.CreateCommand();
    command.CommandText = "SELECT patient_id, first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight FROM patients WHERE province_id = 'ON'";

    // Ejecutar la consulta y leer resultados
    var patients = new List<object>();
    using var reader = command.ExecuteReader();
    while (reader.Read())
    {
        patients.Add(new
        {
            PatientId = reader.GetInt64(0),       // patient_id es INTEGER → Int64
            FirstName = reader.GetString(1),
            LastName = reader.GetString(2),
            Gender = reader.GetString(3),
            BirthDate = reader.GetString(4),       // fecha como string ISO
            City = reader.IsDBNull(5) ? null : reader.GetString(5),
            ProvinceId = reader.GetString(6),
            Allergies = reader.IsDBNull(7) ? null : reader.GetString(7),
            Height = reader.IsDBNull(8) ? null : reader.GetInt64(8),
            Weight = reader.IsDBNull(9) ? null : reader.GetInt64(9)
        });
    }

    return Results.Ok(patients);
});

app.Run();
```

### Paso 5: Probar

```bash
dotnet run
```

Abrir el navegador en `http://localhost:5000/patients-on`. Debería verse un JSON con los pacientes de Ontario (alrededor de 200 registros). Si hay menos, revisar que la base esté en la carpeta correcta.

---

## Ejercicio independiente

**Consigna:** Crear un endpoint `/patients-from` que acepte un parámetro de ruta con el código de provincia (ej: `ON`, `BC`, `AB`) y devuelva todos los pacientes de esa provincia.

**Pista:** Usar `{provinceId}` en la ruta y concatenar el valor en el SQL con el operador `+` (por ahora; en próximas clases verán parametros con `@`).

**Solución esperada:**

```csharp
// GET /patients-from/{provinceId} — pacientes por provincia
app.MapGet("/patients-from/{provinceId}", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);
    connection.Open();

    var command = connection.CreateCommand();
    command.CommandText = "SELECT patient_id, first_name, last_name FROM patients WHERE province_id = '" + provinceId + "'";

    var patients = new List<object>();
    using var reader = command.ExecuteReader();
    while (reader.Read())
    {
        patients.Add(new
        {
            PatientId = reader.GetInt64(0),
            FirstName = reader.GetString(1),
            LastName = reader.GetString(2)
        });
    }

    return Results.Ok(patients);
});
```

> **Nota:** La concatenación directa en el SQL es intencional para esta clase. En encuentros siguientes van a aprender a parametrizar con `@` y Dapper.

---

## Cierre

**Qué te llevás:** SQLite es un archivo, no un servidor. `Microsoft.Data.Sqlite` permite enviar SQL desde C#. SELECT con WHERE filtra filas. Cada columna se lee con el método Get que corresponde a su tipo.

**Lo que viene:** En la próxima clase van a combinar datos de dos tablas con JOIN y ordenar resultados con ORDER BY.

---

## Errores comunes y trampas

| Error | Causa | Solución |
|-------|-------|----------|
| `Microsoft.Data.Sqlite` no se encuentra | Falta el paquete NuGet | Ejecutar `dotnet add package Microsoft.Data.Sqlite` |
| `SQLite Error 1: 'no such table'` | La base no se llama `hospital.db` o no está en la raiz del proyecto | Verificar que `hospital.db` esté junto al `.csproj` |
| `Cannot open database` | La ruta de conexion es incorrecta | Usar exactamente `"Data Source=hospital.db"` desde la carpeta del proyecto |
| No devuelve resultados | La condicion WHERE no coincide con ningún registro | Probar `WHERE province_id = 'ON'` (Ontario tiene datos) |
| `GetInt64` lanza excepción | Se intenta leer una columna NULL con `GetInt64` | Usar `IsDBNull()` antes de leer o tratar el valor nullable |

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|--------|---------|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |
| **Total** | **240** |