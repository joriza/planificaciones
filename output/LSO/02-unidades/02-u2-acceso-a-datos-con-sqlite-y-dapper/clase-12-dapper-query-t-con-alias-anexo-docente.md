# Anexo docente — Encuentro 12: Dapper: Query\<T\> con alias

**Tipo:** Anexo docente — material exclusivo para el profesorado. No se entrega a los alumnos.

---

## Encuadre

Este encuentro marca el ingreso al Eje 4. Es el primer contacto con Dapper. Los alumnos ya conocen SQLite y SQL básico (SELECT, WHERE, JOIN, ORDER BY) desde los encuentros E10 y E11, donde escribian todo el loop de `SqliteDataReader` a mano. Ahora Dapper automatiza esa transcripcion. El salto es grande: pasan de 15 líneas de lectura manual a 1 línea con `Query<T>`. El foco esta en tres conceptos: (1) instalación de Dapper, (2) records posicionales con tipos canónicos, (3) alias AS obligatorios.

---

## Qué observar durante la práctica

- **Ubicación del record**: el error CS8803 (tipo declarado antes de top-level statements) es el más frecuente. Los records deben ir después de `app.Run()`. Ayudar a los alumnos a moverlos si el proyecto no compila.
- **Alias AS**: sin alias, Dapper busca `first_name` como parámetro del constructor y falla. Verificar que todos los SELECT usen `AS PascalCase`.
- **Tipos canónicos**: `doctor_id` debe ser `long DoctorId`, no `int`. Las fechas como `string BirthDate`, no `DateTime`. Los campos nulables con `?` (`string? Allergies`).
- **`.ToList()`**: sin esto, `Query<T>` devuelve `IEnumerable<T>` y el JSON se ve bien, pero puede comportarse distinto en ciertos contextos.
- **Paquetes**: verificar que ambos paquetes (Dapper y Microsoft.Data.Sqlite) estén instalados. Si falta Dapper, la compilación falla porque `Query<T>` no se encuentra.

---

## Solución completa (ejercicio independiente)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

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

app.Run();

public record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

Probar en `http://localhost:5000/doctors`. Debe devolver 27 médicos ordenados por apellido, con campos camelCase.

---

## Errores previsibles

Incluye los defectos de la checklist de `convenciones-tecnicas.md`:

| Error | Cómo se manifiesta | Corrección |
|-------|-------------------|------------|
| **ID declarado como `int` en el record** | `InvalidOperationException`: Dapper busca constructor `(Int64, String)` pero el record ofrece `(int, String)` | Usar `long DoctorId` |
| **Fecha declarada como `DateTime`** | `InvalidOperationException`: Dapper recibe `String` de TEXT y no encuentra constructor | Usar `string BirthDate` |
| **Columna INTEGER nullable como `int?`** | `InvalidOperationException`: Dapper espera `Int64` | Usar `long? Height` |
| **SELECT sin alias AS** | `InvalidOperationException`: Dapper busca constructor con parámetros snake_case | Usar `SELECT patient_id AS PatientId, ...` |
| **Records antes de `app.Run()`** | Error CS8803 | Mover records después de `app.Run()` |
| **Olvidar `?` en campos nulables** | Dapper asigna `null` pero la propiedad no nulable lo oculta | Declarar como `string?` o `long?` |
| **Falta paquete Dapper** | `Query<T>` no se encuentra | `dotnet add package Dapper` |

---

## Criterios de logro

| Criterio | Lo evidencia |
|----------|--------------|
| Instala Dapper correctamente | Agrega el paquete NuGet sin error |
| Define un record posicional con tipos canónicos | `long`, `string`, `string?`, `long?` según corresponda |
| Usa alias AS en el SELECT | Cada columna snake_case tiene su alias PascalCase |
| Reemplaza el loop manual con `Query<T>` | El código ya no usa `SqliteDataReader` |
| Coloca los records después de `app.Run()` | El proyecto compila sin CS8803 |

---

## Agrupamiento

- **Apertura:** grupo completo. La charla rápida del "asistente" ayuda a que entiendan por qué Dapper simplifica el código.
- **Práctica guiada:** individual con proyección. El cambio de leer con Dapper en vez de `DataReader` requiere atención: pausar después del `Query<T>` para que todos vean que las 15 líneas anteriores se redujeron a 1.
- **Ejercicio independiente:** pares. Un alumno escribe el record, el otro escribe el endpoint. Intercambian roles en la actividad complementaria.
- **Actividad complementaria:** individual, con revisión del compañero.

---

## Ajustes

- **Si se atrasan:** dedicar los primeros 20 minutos a repasar el concepto de record posicional con ejemplos en pizarra. Reducir la práctica guiada a solo `patients` (sin JOIN), y dejar el JOIN para la actividad complementaria.
- **Si avanzan rápido:** como complemento, pedir que creen un record `Province` y un endpoint `/provinces` que devuelva las 13 provincias ordenadas por nombre.
- **Alumnos con dificultades:** darles el record ya escrito. Que se concentren solo en el endpoint y la consulta SQL.
- **Alumnos avanzados:** proponer que agreguen un record `Patient` sin JOIN (solo la tabla patients) y comparen la longitud del código con la versión manual de E10.