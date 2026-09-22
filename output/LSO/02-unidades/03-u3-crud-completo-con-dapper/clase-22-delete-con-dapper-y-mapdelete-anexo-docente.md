# Anexo docente — Encuentro 22: DELETE con Dapper y MapDelete

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

La solución de referencia es el endpoint DELETE con verificación previa de existencia (Paso 1 del desarrollo teórico-práctico).

```csharp
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var paciente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    if (paciente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    return Results.NoContent();
});
```

**Salida esperada con hospital.db real**:

```
> curl -X DELETE http://localhost:5000/patients/259

HTTP/1.1 204 No Content
```

Verificación de que se borró:

```
> curl http://localhost:5000/patients/259

HTTP/1.1 404 Not Found
Content-Type: application/json

{ "mensaje": "Paciente no encontrado" }
```

**Salida esperada para ID inexistente**:

```
> curl -X DELETE http://localhost:5000/patients/9999

HTTP/1.1 404 Not Found
Content-Type: application/json

{ "mensaje": "Paciente no encontrado" }
```

## 2. Solución de la actividad de extensión

### Actividad 1 — DELETE con verificación de dependencias

```csharp
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Verificar si el paciente tiene ingresos registrados
    var tieneIngresos = connection.QueryFirstOrDefault<dynamic>(@"
        SELECT 1 FROM admissions WHERE patient_id = @id
    ", new { id }) is not null;

    if (tieneIngresos)
    {
        return Results.StatusCode(409);
    }

    // Verificar que el paciente exista
    var paciente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    if (paciente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    return Results.NoContent();
});
```

**Salida esperada** (paciente con ingresos, código 409):

```
> curl -X DELETE http://localhost:5000/patients/1

HTTP/1.1 409 Conflict
```

### Actividad 2 — Filtros combinados en DELETE

```csharp
app.MapDelete("/patients", (string? provinceId = null, string? gender = null) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Construir SQL solo con las condiciones que llegan
    var sql = "DELETE FROM patients WHERE 1 = 1";
    var parameters = new Dictionary<string, object>();

    if (!string.IsNullOrWhiteSpace(provinceId))
    {
        sql += " AND province_id = @provinceId";
        parameters.Add("provinceId", provinceId);
    }

    if (!string.IsNullOrWhiteSpace(gender))
    {
        sql += " AND gender = @gender";
        parameters.Add("gender", gender);
    }

    int filasAfectadas = connection.Execute(sql, parameters);

    // Canon de la hoja de convenciones: el borrado responde 204 sin cuerpo.
    return Results.NoContent();
});
```

**Salida esperada** (borrar todos los pacientes de BC):

```
> curl -X DELETE "http://localhost:5000/patients?provinceId=BC"

HTTP/1.1 204 No Content
```

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Código |
| --- | --- | --- |
| DELETE /patients/259 (existe) | Sin body, header Location no aplica | 204 |
| DELETE /patients/9999 (no existe) | `{ "mensaje": "Paciente no encontrado" }` | 404 |
| DELETE /patients/1 (tiene ingresos) | Sin body | 409 (con Actividad 1) |
| DELETE /patients?provinceId=BC | Sin body | 204 (con Actividad 2) |
| DELETE /patients sin filtros | Borra todos los pacientes | 204 (con Actividad 2) |

## 4. Criterios de corrección (lista de verificación)

- [ ] El endpoint usa `MapDelete` (no `MapGet` ni `MapPost`)
- [ ] Se valida la existencia del recurso antes de borrar (o se verifica `filasAfectadas == 0`)
- [ ] Si el recurso no existe, se devuelve `Results.NotFound` con `mensaje` en español
- [ ] Si el borrado es exitoso, se devuelve `Results.NoContent()` con código 204
- [ ] El SQL usa `@id` como parámetro y `new { id }` como objeto anónimo
- [ ] La conexión se abre con `using var connection = new SqliteConnection(connectionString)`
- [ ] No se concatena el ID al SQL
- [ ] No se devuelve el objeto borrado en el body (204 no tiene body)
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes dentro del código fuente
- [ ] En la variante de Actividad 1, se verifican las dependencias antes de borrar

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `204` devuelto para un ID inexistente | No se verificó la existencia antes del DELETE. Se asumió que `Execute` devuelve 0 para IDs inexistentes pero no se manejó ese caso. | Mostrar que `Execute` devuelve 0 filas afectadas y que eso debe traducirse en `404`. |
| `404` devuelto para un ID que sí existe | El `QueryFirstOrDefault` no tiene el alias `AS` correcto y Dapper no materializa el record. | Verificar que el SELECT use `AS PatientId`, `AS FirstName`, etc. |
| `500` al ejecutar el DELETE | `hospital.db` no está en la carpeta correcta o la cadena de conexión es incorrecta. | Verificar que el archivo esté junto al `.csproj` y que la cadena sea `"Data Source=hospital.db"`. |
| Error de sintaxis SQL | Se usó `DELETE FROM patients WHERE id = @id` en vez de `patient_id`. | Verificar que el nombre de columna en el WHERE coincida con el nombre real en la tabla. |
| `Results.NoContent()` no compila | Se usó `Results.NoContent()` en .NET 5 o anterior donde no existe. | `Results.NoContent()` está disponible en .NET 6+. Verificar la versión del SDK. |
| Conexión sin `using` | Se creó `var connection` sin `using`. | Agregar `using var connection = new SqliteConnection(...)`. |

## 6. Registro de la clase

| Grupo | Entendió la diferencia 404 vs 204 | Implementó la validación de existencia | Probo con ID inexistente | Entendió `Results.NoContent()` | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | Sí | Sí | Sí | Sí | |
| Grupo 2 | Sí | Sí | No (solo probó con ID válido) | Sí | Falta probar el caso 404 |
| Grupo 3 | No, confundía 204 con 200 | Sí | Sí | No, devolvía 200 en vez de 204 | Requiere refuerzo en códigos HTTP |
| Grupo 4 | Sí | No, no validó existencia | Sí | Sí | Requiere refuerzo en validación previa |

**Notas para la evaluación de proceso:** verificar que cada grupo pueda explicar por qué se devuelve `404` y no `204` cuando el recurso no existe. Evaluar si el grupo entiende la diferencia entre `Execute` (filas afectadas) y `QueryFirstOrDefault` (verificación previa). Registrar qué grupos confundieron los códigos 204 y 200.
