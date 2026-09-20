# Anexo docente — Encuentro 11: SQL: JOIN y ORDER BY

**Tipo:** Anexo docente — material exclusivo para el profesorado. No se entrega a los alumnos.

---

## Encuadre

Segundo encuentro de la Unidad 2, aún sin Dapper. Los alumnos ya saben conectar SQLite y hacer SELECT con WHERE. Ahora aprenden a cruzar tablas (JOIN) y ordenar resultados (ORDER BY). Es un encuentro procedimental: el foco está en la sintaxis SQL y en cómo se escribe la consulta, no en el código C# de conexion (que repiten del encuentro anterior). El ejercicio independiente introduce GROUP BY + COUNT, que anticipa agregaciones y prepara el terreno para Dapper en E12.

---

## Qué observar durante la práctica

- **JOIN sin condición ON**: los alumnos pueden escribir `JOIN province_names` y olvidar el `ON p.province_id = pn.province_id`. El resultado es un producto cartesiano (258 × 13 filas). Si ven muchas filas de más, ese es el diagnóstico.
- **Alias de tabla**: algunos pueden escribir `FROM patients JOIN province_names` y luego `patients.province_id`. Funciona pero es verboso. Mostrar que `p` y `pn` son más cortos.
- **GROUP BY incompleto**: en el ejercicio independiente, olvidar incluir `d.first_name`, `d.last_name`, `d.specialty` en el GROUP BY provoca error de SQLite.
- **ORDER BY con alias**: `ORDER BY TotalAdmissions DESC` funciona, pero si alguien escribe `ORDER BY 5 DESC` (número de columna) también funciona; aclarar que el número de columna es frágil si se agregan columnas después.

---

## Solución completa (ejercicio independiente)

```csharp
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

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

app.Run();
```

El médico con más ingresos suele ser el de mayor volumen de pacientes. Verificar que `TotalAdmissions` sume 306 (total de ingresos en la base).

---

## Errores previsibles

Incluye los defectos de la checklist de `convenciones-tecnicas.md` relevantes para este encuentro:

| Error | Cómo se manifiesta | Corrección |
|-------|-------------------|------------|
| **Producto cartesiano por falta de ON** | Devuelve 258 x 13 = 3354 filas en vez de 258 | Agregar `ON p.province_id = pn.province_id` |
| **`int` en lugar de `long`/`Int64`** | `InvalidOperationException` al leer `doctor_id` o `COUNT(*)` | Usar `reader.GetInt64(0)` |
| **GROUP BY incompleto** | `SqliteException`: columnas no agregadas fuera del GROUP BY | Incluir todas las columnas no agregadas en GROUP BY |
| **Columna ambigua** | `ambiguous column name: doctor_id` | Usar prefijo de tabla: `d.doctor_id` |
| **Omitir `using` en la conexión** | Fuga de conexión; se agota el pool | Verificar `using var connection` |
| **Alias AS en SELECT pero no en ORDER BY** | ORDER BY con posición funciona, pero es frágil | Usar `ORDER BY TotalAdmissions DESC` |
| **Concatenación en SQL** | (Señalar) Riesgo de inyección | En E13 verán parámetros con Dapper |

---

## Criterios de logro

| Criterio | Lo evidencia |
|----------|--------------|
| Escribe un JOIN entre dos tablas | La consulta incluye `JOIN ... ON ...` y devuelve datos combinados |
| Usa alias de tabla | Escribe `FROM patients p` y referencias `p.patient_id` |
| Ordena con ORDER BY | Los resultados llegan en el orden esperado (ASC o DESC) |
| Agrupa con GROUP BY | El endpoint de conteo devuelve un número por médico |
| Lee tipos correctamente | Usa `GetInt64` para INTEGER, `GetString` para TEXT, maneja NULL |

---

## Agrupamiento

- **Apertura:** grupo completo. La charla rápida sobre JOIN puede incluir una analogía con dos hojas de cálculo.
- **Práctica guiada:** individual, con proyección. Pausar en la consulta JOIN para que todos vean la sintaxis.
- **Ejercicio independiente:** pares. Cada pareja escribe el endpoint de médicos y compara resultados.
- **Actividad complementaria:** individual. Revisión cruzada al final de la clase.

---

## Ajustes

- **Si se atrasan:** reducir la práctica guiada a solo JOIN (sin ORDER BY ni GROUP BY). El ejercicio independiente pasa a ser solo JOIN + ORDER BY (sin GROUP BY).
- **Si avanzan rápido:** como complemento, pedir un endpoint `/provinces-with-patients` que muestre cada provincia con su cantidad de pacientes, ordenado alfabeticamente por provincia.
- **Alumnos con dificultades:** entregar la consulta JOIN escrita en un archivo `.sql` para que la copien textual y se concentren solo en el código C#. Luego modificar progresivamente.
- **Alumnos avanzados:** proponer un JOIN triple que muestre ingresos con nombre de paciente y especialidad del médico (lo ven formalmente en U3, pero pueden intentarlo).