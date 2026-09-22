# Anexo docente — Encuentro 10: SQLite y SELECT básico

**Tipo:** Anexo docente — material exclusivo para el profesorado. No se entrega a los alumnos.

---

## Encuadre

Este encuentro abre la Unidad 2. Los alumnos vienen del cierre de U1 (TP-U1 entregado) y tienen experiencia con endpoints GET sin base de datos. Ahora damos el salto conceptual: de datos en memoria a datos persistentes en SQLite. El objetivo es que entiendan SQLite como un archivo consultable desde C#, no como un servidor. No se introduce Dapper aún: trabajamos con `Microsoft.Data.Sqlite` directo para que vean el mecanismo subyacente.

---

## Qué observar durante la práctica

- **Copia de hospital.db**: el error más frecuente es olvidar copiar la base o copiarla en la carpeta equivocada (dentro de `bin/` en vez de junto al `.csproj`). Verificar que `dotnet run` no tire `SQLite Error 1: 'no such table'`.
- **Uso de `using`**: observar si los alumnos declaran la conexión con `using var`. Si no, señalar que la conexión queda abierta y puede agotar el pool.
- **Lectura de columnas**: verificar que usan `GetInt64` para `patient_id` (no `GetInt32`). El error `InvalidOperationException` por tipo incorrecto aparece en este punto.
- **Manejo de NULL**: las columnas `city`, `allergies`, `height`, `weight` pueden ser NULL. Los alumnos que usen `GetString` sin `IsDBNull` van a recibir `InvalidCastException`.

---

## Solución completa (ejercicio independiente)

```csharp
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

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

app.Run();
```

Probar con:
- `http://localhost:5000/patients-from/ON` — devuelve ~200 pacientes.
- `http://localhost:5000/patients-from/BC` — devuelve ~8 pacientes.
- `http://localhost:5000/patients-from/XX` — devuelve lista vacía `[]`.

---

## Errores previsibles

Incluye los defectos de la checklist de `convenciones-tecnicas.md` que son relevantes para este encuentro:

| Error | Cómo se manifiesta | Corrección |
|-------|-------------------|------------|
| **Base no encontrada** | `SQLite Error 1: 'no such table'` | Copiar `hospital.db` junto al `.csproj`, no dentro de `bin/` ni `obj/` |
| **`int` en lugar de `long`/`Int64`** | `InvalidOperationException` al leer `patient_id` | Usar `reader.GetInt64(0)` |
| **Omitir `using` en la conexión** | La conexión no se cierra; a la tercera o cuarta request falla por pool agotado | Declarar `using var connection = new SqliteConnection(...)` |
| **Columna NULL leída sin `IsDBNull`** | `InvalidCastException` en `city`, `allergies`, `height`, `weight` | Usar `IsDBNull()` antes de leer, o `reader.GetString(5)` solo si no es NULL |
| **Concatenación de SQL** | (Intencional en esta clase) Riesgo de inyección y errores con comillas | Señalar que en E13 van a usar parámetros con `@` |
| **Olvidar `connection.Open()`** | `InvalidOperationException`: la conexión no está abierta | Llamar `connection.Open()` antes de `CreateCommand()` |
| **Ruta de proyecto incorrecta** | `dotnet run` compila pero la base no se encuentra | `dotnet run` debe ejecutarse desde la carpeta que contiene `hospital.db` |

---

## Criterios de logro

| Criterio | Lo evidencia |
|----------|--------------|
| Comprende que SQLite es un archivo único | Sabe ubicar `hospital.db` y explicar que no necesita instalación |
| Conecta y consulta con `Microsoft.Data.Sqlite` | Escribe `SqliteConnection`, `CreateCommand`, `ExecuteReader` correctamente |
| Usa SELECT con WHERE | El endpoint filtra por provincia y devuelve los registros esperados |
| Maneja tipos de datos correctamente | Usa `GetInt64` para INTEGER, `GetString` para TEXT, `IsDBNull` para columnas nulables |
| Declara la conexión con `using` | No hay fugas de conexión en la ejecución |

---

## Agrupamiento

- **Apertura y teoría mínima:** grupo completo, con preguntas al aire.
- **Práctica guiada:** individual (cada alumno en su PC). El docente proyecta el código y los alumnos lo escriben a la par. Pausar después de cada paso para verificar que todos avanzan.
- **Ejercicio independiente:** individual o pares según el ritmo del curso. Si algún alumno se atrasa, el compañero de banco puede asistir.
- **Actividad complementaria:** individual, con revisión cruzada (el compañero verifica que el endpoint devuelva JSON correcto).

---

## Ajustes

- **Si el grupo se atrasa:** saltar la actividad complementaria y dedicar el tiempo extra a la práctica guiada. El ejercicio independiente es obligatorio.
- **Si el grupo avanza rápido:** proponer como actividad complementaria agregar un segundo endpoint `/doctors-by-specialty` que filtre médicos por especialidad usando el mismo patrón.
- **Alumnos con dificultades:** entregar una guía impresa con los pasos 1 a 4 (comandos de terminal exactos). Ayudar con la copia de `hospital.db` en los primeros 10 minutos.
- **Alumnos avanzados:** pedir que agreguen `ORDER BY last_name` a la consulta (lo ven formalmente en E11, pero pueden investigar por su cuenta).