# Encuentro 11 — SQL: JOIN y ORDER BY

**Unidad 2:** Acceso a datos con SQLite y Dapper  
**Duración:** 240 minutos  
**Carácter:** Procedimental  
**Eje 3:** SQLite y SQL básico  

---

## Objetivos de aprendizaje

- Combinar datos de dos tablas con INNER JOIN.
- Ordenar resultados con ORDER BY ascendente y descendente.
- Mostrar el nombre de la provincia en lugar del código dentro de un listado de pacientes.
- Ejecutar consultas JOIN desde un endpoint GET.

---

## Charla rápida

En la clase anterior consultaban una sola tabla, como leer una sola ficha de la biblioteca. Pero un paciente vive en una provincia, y el código `ON` no les dice nada. Para saber que `ON` significa "Ontario" necesitan cruzar dos fichas: la del paciente y la de la provincia. Eso es un JOIN: sentar dos tablas al lado y decirle "si el `province_id` del paciente coincide con el `province_id` de la provincia, juntá las filas".

---

## Teoría mínima

### INNER JOIN

```sql
SELECT columna1, columna2, ...
FROM tablaA
JOIN tablaB ON tablaA.columna_comun = tablaB.columna_comun
```

`INNER JOIN` (o solo `JOIN`) devuelve las filas que tienen correspondencia en ambas tablas. Si un paciente tuviera un `province_id` que no existe en `province_names`, ese paciente no aparecería.

Para nuestro caso:

```sql
SELECT p.patient_id AS PatientId,
       p.first_name AS FirstName,
       p.last_name AS LastName,
       pn.province_name AS ProvinceName
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id
```

Se usan alias de tabla (`patients p` equivale a `patients AS p`) para escribir menos.

### ORDER BY

```sql
ORDER BY columna ASC   -- ascendente (default)
ORDER BY columna DESC  -- descendente
```

Se puede ordenar por una columna, por varias o incluso por un alias.

---

## Práctica guiada

Van a crear un proyecto nuevo que devuelva pacientes con el nombre completo de su provincia, ordenados alfabeticamente por apellido.

### Paso 1: Crear el proyecto

```bash
dotnet new web -o join-provincias
cd join-provincias
```

Copiar `hospital.db` junto al `.csproj` y agregar el paquete:

```bash
dotnet add package Microsoft.Data.Sqlite
```

### Paso 2: Escribir el código

Reemplazar `Program.cs`:

```csharp
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// GET /patients-with-province — pacientes con nombre de provincia
app.MapGet("/patients-with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    connection.Open();

    var command = connection.CreateCommand();
    command.CommandText = @"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.last_name, p.first_name
    ";

    var patients = new List<object>();
    using var reader = command.ExecuteReader();
    while (reader.Read())
    {
        patients.Add(new
        {
            PatientId = reader.GetInt64(0),
            FirstName = reader.GetString(1),
            LastName = reader.GetString(2),
            ProvinceName = reader.GetString(3)
        });
    }

    return Results.Ok(patients);
});

app.Run();
```

### Paso 3: Probar

```bash
dotnet run
```

Abrir `http://localhost:5000/patients-with-province`. Verificar:
- La columna `provinceName` muestra "Ontario", "British Columbia", etc., no los códigos `ON`, `BC`.
- Los registros estan ordenados por apellido y luego por nombre.
- Hay exactamente 258 pacientes (los mismos de siempre, pero ahora con el nombre de la provincia).

---

## Ejercicio independiente

**Consigna:** Crear un endpoint `/doctors-with-admissions` que devuelva una lista de médicos con la cantidad de ingresos que atendió cada uno, ordenada de mayor a menor cantidad.

**Pista:** Necesitan JOIN entre `doctors` y `admissions`, agrupar con `GROUP BY d.doctor_id`, contar con `COUNT(*)` y ordenar con `ORDER BY total DESC`.

**Solución esperada:**

```csharp
// GET /doctors-with-admissions — medicos con cantidad de ingresos
app.MapGet("/doctors-with-admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    connection.Open();

    var command = connection.CreateCommand();
    command.CommandText = @"
        SELECT d.doctor_id AS DoctorId,
               d.first_name AS FirstName,
               d.last_name AS LastName,
               d.specialty AS Specialty,
               COUNT(a.admission_date) AS TotalAdmissions
        FROM doctors d
        JOIN admissions a ON d.doctor_id = a.attending_doctor_id
        GROUP BY d.doctor_id
        ORDER BY TotalAdmissions DESC
    ";

    var doctors = new List<object>();
    using var reader = command.ExecuteReader();
    while (reader.Read())
    {
        doctors.Add(new
        {
            DoctorId = reader.GetInt64(0),
            FirstName = reader.GetString(1),
            LastName = reader.GetString(2),
            Specialty = reader.GetString(3),
            TotalAdmissions = reader.GetInt64(4)
        });
    }

    return Results.Ok(doctors);
});
```

Probar en `http://localhost:5000/doctors-with-admissions`. El médico con más ingresos deberia aparecer primero.

---

### Qué te llevás

- JOIN combina dos tablas vinculadas por una clave común.
- ORDER BY ordena los resultados.
- GROUP BY + COUNT permite hacer resúmenes.
- Todo esto se ejecuta desde C# con el mismo patrón de conexión que ya conocen.

### Lo que viene

En el Encuentro 12 entra Dapper, un asistente que automatiza la lectura de datos y evita escribir todo el loop de `ExecuteReader` a mano.

## Errores comunes y trampas

| Error | Causa | Solución |
|-------|-------|----------|
| Faltan filas en el resultado | El JOIN no encuentra coincidencias en la otra tabla | Verificar los valores de la columna de enlace (`province_id`, `doctor_id`) |
| `ambiguous column name` | Dos tablas tienen una columna con el mismo nombre y no se usa prefijo | Usar alias de tabla: `p.patient_id`, `pn.province_id` |
| ORDER BY no ordena como se espera | Los string con SQLite se ordenan lexicograficamente (A-Z) | Verificar que no haya espacios extras. Usar `ASC` o `DESC` explicitamente |
| `no such column: TotalAdmissions` | Se intenta usar el alias en el WHERE (no existe al evaluar WHERE) | Usar el alias solo en ORDER BY; en WHERE usar la expresión original |
| El GROUP BY requiere las columnas no agregadas | SQLite exige que toda columna no agregada esté en GROUP BY | Incluir `d.doctor_id`, `d.first_name`, `d.last_name`, `d.specialty` en GROUP BY |

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|--------|---------|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |
| **Total** | **240** |