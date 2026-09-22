# Anexo docente — Encuentro 23: UPDATE con Dapper y MapPut

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

La solución de referencia es el endpoint PUT completo con validación de existencia y devolución del recurso actualizado (Paso 1 del desarrollo teórico-práctico).

```csharp
app.MapPut("/patients/{id:long}", (long id, Patient pacienteActualizado) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    if (existente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        UPDATE patients
        SET first_name = @FirstName,
            last_name = @LastName,
            gender = @Gender,
            city = @City,
            province_id = @ProvinceId,
            allergies = @Allergies,
            height = @Height,
            weight = @Weight
        WHERE patient_id = @id",
        new
        {
            pacienteActualizado.FirstName,
            pacienteActualizado.LastName,
            pacienteActualizado.Gender,
            pacienteActualizado.City,
            pacienteActualizado.ProvinceId,
            pacienteActualizado.Allergies,
            pacienteActualizado.Height,
            pacienteActualizado.Weight,
            id
        });

    var pacienteActualizadoConId = pacienteActualizado with { PatientId = id };
    return Results.Ok(pacienteActualizadoConId);
});
```

**Salida esperada con hospital.db real** (paciente 259 existe tras el INSERT del encuentro 21):

```
> curl -X PUT http://localhost:5000/patients/259 \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Carlos","lastName":"Gomez","gender":"M","birthDate":"1985-03-15","city":"Buenos Aires","provinceId":"BA","allergies":"Penicillin","height":178,"weight":82}'

HTTP/1.1 200 OK
Content-Type: application/json

{
  "patientId": 259,
  "firstName": "Carlos",
  "lastName": "Gomez",
  "gender": "M",
  "birthDate": "1985-03-15",
  "city": "Buenos Aires",
  "provinceId": "BA",
  "allergies": "Penicillin",
  "height": 178,
  "weight": 82
}
```

**Salida esperada para ID inexistente** (código 404):

```
> curl -X PUT http://localhost:5000/patients/9999 \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Juan","lastName":"Perez","gender":"M","birthDate":"1990-01-01","provinceId":"ON"}'

HTTP/1.1 404 Not Found
Content-Type: application/json

{ "mensaje": "Paciente no encontrado" }
```

**Salida esperada con variante `Results.NoContent()`** (código 204, sin body):

```
> curl -X PUT http://localhost:5000/patients/259 \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Carlos","lastName":"Gomez","gender":"M","birthDate":"1985-03-15","city":"Buenos Aires","provinceId":"BA","allergies":"Penicillin","height":178,"weight":82}' \
    -v

> PATCH /patients/259 HTTP/1.1
< HTTP/1.1 204 No Content
```

## 2. Solución de la actividad de extensión

### Actividad 1 — PUT parcial: solo actualizar la ciudad

La solución completa está en la Actividad 1 del encuentro. La salida esperada:

```
> curl -X PUT http://localhost:5000/patients/259/city \
    -H "Content-Type: application/json" \
    -d '"Rosario"'

HTTP/1.1 200 OK
Content-Type: application/json

{
  "patientId": 259,
  "firstName": "Carlos",
  "lastName": "Gomez",
  "gender": "M",
  "birthDate": "1985-03-15",
  "city": "Rosario",
  "provinceId": "BA",
  "allergies": "Penicillin",
  "height": 178,
  "weight": 82
}
```

### Actividad 2 — Paginación con filtros combinados

```csharp
app.MapGet("/patients", (string? provinceId = null, string? gender = null, string? city = null, int page = 1, int pageSize = 10) =>
{
    using var connection = new SqliteConnection(connectionString);

    var sql = new System.Text.StringBuilder(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE 1 = 1");

    var parameters = new System.Collections.Generic.Dictionary<string, object>();

    if (!string.IsNullOrWhiteSpace(provinceId))
    {
        sql.Append(" AND province_id = @provinceId");
        parameters.Add("provinceId", provinceId);
    }

    if (!string.IsNullOrWhiteSpace(gender))
    {
        sql.Append(" AND gender = @gender");
        parameters.Add("gender", gender);
    }

    if (!string.IsNullOrWhiteSpace(city))
    {
        sql.Append(" AND city = @city");
        parameters.Add("city", city);
    }

    sql.Append(" ORDER BY patient_id OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY");
    parameters.Add("Offset", (page - 1) * pageSize);
    parameters.Add("PageSize", pageSize);

    var patients = connection.Query<Patient>(sql.ToString(), parameters).ToList();

    return Results.Ok(patients);
});
```

**Salida esperada** (filtrar pacientes de ON con paginación):

```
> curl "http://localhost:5000/patients?provinceId=ON&page=1&pageSize=2"

HTTP/1.1 200 OK
Content-Type: application/json

[
  { "patientId": 1, "firstName": "Donald", "lastName": "Waterfield", ... },
  { "patientId": 2, "firstName": "Mickey", "lastName": "Baasha", ... }
]
```

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Código |
| --- | --- | --- |
| PUT /patients/259 con datos válidos | Paciente actualizado con `patientId` = 259 | 200 |
| PUT /patients/259 variante `NoContent` | Sin body | 204 |
| PUT /patients/9999 (no existe) | `{ "mensaje": "Paciente no encontrado" }` | 404 |
| PUT /patients/259/city con ciudad vacía | `{ "mensaje": "La ciudad es obligatoria" }` | 400 |
| GET /patients?provinceId=ON&page=1&pageSize=2 | Array de 2 pacientes de ON | 200 |

## 4. Criterios de corrección (lista de verificación)

- [ ] El endpoint usa `MapPut` (no `MapGet` ni `MapPost`)
- [ ] Se valida la existencia del recurso antes de actualizar
- [ ] Si el recurso no existe, se devuelve `Results.NotFound` con `mensaje` en español
- [ ] La respuesta exitosa usa `Results.Ok(dato)` con código 200 o `Results.NoContent()` con código 204
- [ ] El SQL de UPDATE usa `SET campo = @Campo` para cada columna
- [ ] El objeto de parámetros del UPDATE incluye `id` para el `WHERE`
- [ ] No se incluye `id` en el `SET` (solo en el `WHERE`)
- [ ] El SQL siempre usa parámetros (`@FirstName`, `@LastName`, etc.) y nunca concatenación
- [ ] Se usa `using var connection = new SqliteConnection(connectionString)`
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes dentro del código fuente
- [ ] El record está después de `app.Run()` en el archivo final

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `patientId` es 0 en la respuesta | Se devolvió el objeto del body sin asignarle el `id` de la ruta. | Usar `pacienteActualizado with { PatientId = id }` para incluir el ID. |
| `UPDATE` no modifica ningún campo | Se incluyó `id` en el objeto del `SET` y Dapper lo usó para el `SET` en vez del `WHERE`. | El objeto del `SET` no debe tener `id`; `id` solo va en el `WHERE`. |
| `0` filas afectadas sin `404` | No se verificó la existencia previa y el UPDATE no encontró coincidencias. | Agregar `QueryFirstOrDefault` antes del UPDATE o verificar `filasAfectadas == 0` después. |
| `InvalidOperationException` al materializar | El SELECT previo no tiene alias `AS` correctos. | Verificar que el SELECT use `AS PatientId`, `AS FirstName`, etc. |
| `Results.NoContent()` devuelve `200` | Se confundió `Results.NoContent()` con `Results.Ok()`. | `Results.NoContent()` = `204`. `Results.Ok()` = `200`. Probar con `curl -v`. |
| Error de sintaxis en el UPDATE | Se olvidó una coma entre campos en el `SET` o se usó `=` en vez de `,`. | Revisar la sintaxis: `SET col1 = @val1, col2 = @val2, ...`. |

## 6. Registro de la clase

| Grupo | Entendió la diferencia 200 vs 204 | Implementó la validación de existencia | Devolvió el recurso actualizado en la respuesta | Probo con PUT parcial (solo city) | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | Sí | Sí | Sí | Sí | |
| Grupo 2 | No, confundía 200 con 204 | Sí | No, devolvía 204 siempre | Sí | Requiere refuerzo en códigos de respuesta |
| Grupo 3 | Sí | No, no validó existencia | Sí | No | Requiere refuerzo en validación previa |
| Grupo 4 | Sí | Sí | Sí | No | |

**Notas para la evaluación de proceso:** verificar que cada grupo pueda explicar cuándo usar `Results.Ok` (200) y cuándo `Results.NoContent` (204) en un PUT. Evaluar si el grupo entiende por qué se incluye `id` en el objeto de parámetros del `WHERE` pero no en el `SET`. Registrar qué grupos confundieron los códigos 200 y 204.
