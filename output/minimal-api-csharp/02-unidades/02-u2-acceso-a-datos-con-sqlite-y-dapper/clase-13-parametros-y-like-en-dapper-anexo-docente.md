# Anexo docente — Encuentro 13: Parámetros y LIKE en Dapper

**Tipo:** Anexo docente — material exclusivo para el profesorado. No se entrega a los alumnos.

---

## Encuadre

Cuarto encuentro de la Unidad 2. Los alumnos ya usan Dapper con records y alias. Este encuentro cierra el dominio de lectura consultas: aprenden a parametrizar con `@` (en lugar de concatenar) y a usar `LIKE` con comodines para búsqueda de texto parcial. Es el último encuentro procedimental antes del cierre de unidad. El ejercicio independiente combina JOIN + parametro + ORDER BY, integrando lo aprendido en E10-E13.

---

## Qué observar durante la práctica

- **`%` en el lugar equivocado**: los alumnos tienden a escribir `LIKE '%@patron%'` pensando que Dapper va a reemplazar `@patron` dentro del string. Explicar que el `%` debe ir en el valor de C#, no en el SQL.
- **Nombre del parámetro**: `new { patron = ... }` es la forma correcta. Algunos escriben `new { @patron = ... }` (el `@` en C# es un prefijo para palabras reservadas, no necesario acá).
- **Lista vacía vs 404**: en la práctica guiada devolvemos `Results.Ok(listaVacia)` en vez de `Results.NotFound`. Discutir cuándo corresponde cada uno: si el endpoint busca por alergia, una lista vacía es un resultado válido (no encontró), no un error de recurso inexistente.
- **LIKE case-sensitive**: SQLite es case-insensitive para caracteres ASCII en LIKE, pero conviene mencionarlo porque otros motores se comportan distinto.

---

## Solución completa (ejercicio independiente)

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

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

// GET /patients/by-province/{provinceId} — pacientes por provincia con Dapper
app.MapGet("/patients/by-province/{provinceId}", (string provinceId) =>
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
        WHERE p.province_id = @prov
        ORDER BY p.last_name, p.first_name
    ", new { prov = provinceId }).ToList();

    return Results.Ok(patients);
});

app.Run();
```

Probar: `http://localhost:5000/patients/by-province/ON` (197 pacientes), `http://localhost:5000/patients/by-province/BC` (8, aprox.), `http://localhost:5000/patients/by-province/XX` (0, lista vacía).

---

## Errores previsibles

Incluye los defectos de la checklist de `convenciones-tecnicas.md`:

| Error | Cómo se manifiesta | Corrección |
|-------|-------------------|------------|
| **ID declarado como `int` en el record** | `InvalidOperationException` | Usar `long PatientId` |
| **Fecha declarada como `DateTime`** | `InvalidOperationException` | Usar `string BirthDate` |
| **Columna INTEGER nullable como `int?`** | `InvalidOperationException` | Usar `long? Height` |
| **SELECT sin alias AS** | `InvalidOperationException` | Usar `SELECT patient_id AS PatientId, ...` |
| **Records antes de `app.Run()`** | Error CS8803 | Mover records después de `app.Run()` |
| **Olvidar `?` en campos nulables** | Dapper asigna null a campo no nulable | Declarar como `string?` o `long?` |
| **Concatenar datos al SQL** | Riesgo de inyección y errores con comillas | Usar `@prov` y `new { prov }` |
| **`%` en el SQL en vez del valor** | LIKE busca literal `@patron` | Poner `%` en C#: `$"%{texto}%"` |
| **Nombre del parámetro mal escrito** | Dapper no matchea y la consulta falla | Coincidencia exacta entre `@xxx` en SQL y `new { xxx }` en C# |

---

## Criterios de logro

| Criterio | Lo evidencia |
|----------|--------------|
| Parametriza consultas con `@` | Usa `@prov` en SQL y `new { prov }` en C# |
| Usa LIKE con comodín `%` | La búsqueda por alergia encuentra coincidencias parciales |
| Combina JOIN + parámetro | El endpoint de provincia usa JOIN y WHERE parametrizado juntos |
| Diferencia lista vacía de 404 | Devuelve `Results.Ok(lista)` en vez de `Results.NotFound` para consultas sin resultados |
| Sigue el patrón Dapper canónico | `Query<T>`, alias AS, record después de `app.Run()` |

---

## Agrupamiento

- **Apertura:** grupo completo. Mostrar en la pizarra la diferencia entre concatenación (clase 10) y parametrización (esta clase). Incluso mostrar un ejemplo de inyección: `' OR '1'='1`.
- **Práctica guiada:** individual con proyección. Pausar en el objeto anónimo: mostrar que `new { patron = $"%{allergyText}%" }` es donde sucede la magia.
- **Ejercicio independiente:** pares. El que termina primero ayuda al compañero.
- **Actividad complementaria:** individual, con prueba cruzada de endpoints.

---

## Ajustes

- **Si se atrasan:** simplificar la práctica guiada: eliminar el JOIN, usar solo `patients` con LIKE. El JOIN puede ir como actividad complementaria.
- **Si avanzan rápido:** proponer como complemento un endpoint `/patients/search` que acepte query strings: `?allergy=Penicillin&province=ON`. Usar dos parámetros en el mismo objeto anónimo.
- **Alumnos con dificultades:** darles una plantilla con el SQL ya escrito; que solo completen el objeto anónimo.
- **Alumnos avanzados:** proponer que implementen `QueryFirstOrDefault<T>` para buscar un paciente por ID usando parámetro, y devolver 404 si no existe.