# Encuentro 23 — UPDATE con Dapper y MapPut

> Unidad 3 — CRUD completo con Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 23 de 36 |
| Unidad | 3 — CRUD completo con Dapper |
| Eje temático | 5 — CRUD con Dapper |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | UPDATE con Dapper y MapPut |
| Requisitos previos | Encuentro 22: DELETE con Dapper y MapDelete, validación de existencia, códigos 404/204 |
| Uso de celular | No permitido |
| Organización del trabajo | Parejas, una computadora cada dos |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Modificar un registro existente en la tabla `patients` usando Dapper con SQL parametrizado.
2. Validar que el recurso exista antes de actualizar y devolver `404` si no existe.
3. Exponer el UPDATE como endpoint `PUT` con `MapPut` y responder con el recurso actualizado o `204`.
4. Entender la diferencia entre devolver el recurso actualizado (`200`) y devolver sin body (`204`) en una actualización sobre base de datos.

## 3. Apertura y motivación (20 min)

### Charla rápida: analogía breve que ancle el concepto

Cuando el médico de un paciente cambia la diagnóstico o la ciudad de residencia, se abre la ficha, se modifican los campos y se guarda. No se crea una ficha nueva ni se borra la vieja: se actualiza. Eso es exactamente un UPDATE: buscar el registro, cambiar los valores que corresponda, y guardar.

### Lo mínimo indispensable

El método Dapper para UPDATE es `Execute`, que devuelve la cantidad de filas afectadas. Antes de actualizar siempre se verifica que el recurso exista. Si no existe, se devuelve `404`. Si la actualización es exitosa, se puede devolver el recurso actualizado con `Results.Ok` (código `200`) o `Results.NoContent()` (código `204`). El endpoint se define con `MapPut`.

## 4. Desarrollo teórico-práctico (120 min)

### Paso 1 — El endpoint PUT con validación de existencia y devolución del recurso actualizado

```csharp
// PUT /patients/{id:long} — actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, Patient pacienteActualizado) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);

    // Buscar el paciente actual para validar que exista
    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    // Si no existe, devolver 404
    if (existente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    // Actualizar solo los campos que se quieren cambiar
    // La fecha de nacimiento no se modifica en este ejemplo
    int filasAfectadas = connection.Execute(@"
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

    // Devolver el recurso actualizado con codigo 200
    var pacienteActualizadoConId = pacienteActualizado with { PatientId = id };
    return Results.Ok(pacienteActualizadoConId);
});
```

> Comentario: en el UPDATE se incluye `id` en el objeto de parámetros para que el WHERE `WHERE patient_id = @id` encuentre la columna correcta. El `SET` usa los campos del record recibido por el body.

### Paso 2 — Probar el PUT con un paciente que existe

```bash
curl -X PUT http://localhost:5000/patients/259 \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Carlos","lastName":"Gomez","gender":"M","birthDate":"1985-03-15","city":"Buenos Aires","provinceId":"BA","allergies":"Penicillin","height":178,"weight":82}'
```

Salida esperada (código 200):

```json
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

> Comentario: el `city` cambió de "Rosario" a "Buenos Aires" y el `provinceId` de "SF" a "BA". El `patientId` permanece 259.

### Paso 3 — Probar el PUT con un paciente que no existe

```bash
curl -X PUT http://localhost:5000/patients/9999 \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Juan","lastName":"Perez","gender":"M","birthDate":"1990-01-01","provinceId":"ON"}'
```

Salida esperada (código 404):

```json
{ "mensaje": "Paciente no encontrado" }
```

### Paso 4 — Variante con `Results.NoContent()` (204 sin body)

Si la convención de la API no requiere devolver el recurso actualizado, se puede usar `204`:

```csharp
// Variante: PUT que devuelve 204 sin body
app.MapPut("/patients/{id:long}", (long id, Patient pacienteActualizado) =>
{
    using var connection = new SqliteConnection(connectionString);

    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId FROM patients WHERE patient_id = @id", new { id });

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

    // 204 No Content: actualizacion exitosa, sin cuerpo en la respuesta
    return Results.NoContent();
});
```

> Comentario: `Results.NoContent()` responde con código `204` y sin body. Es la convención canónica del curso para operaciones de actualización sobre base de datos (PUT con Dapper).

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- `MapPut` expone un endpoint PUT y `Results.Ok(dato)` responde con código `200` y el recurso actualizado, mientras que `Results.NoContent()` responde con código `204` sin body.
- Antes de actualizar siempre se valida la existencia del recurso. Si no existe, se devuelve `404`.
- El SQL de UPDATE usa `SET campo = @Campo` para cada columna que se quiere modificar.
- El objeto de parámetros incluye `id` para el `WHERE` y todas las propiedades del record para el `SET`.
- `Execute` devuelve `int` con la cantidad de filas afectadas; si es 0, el recurso no existía (aunque ya lo verificamos antes).

## Lo que viene

Encuentro 24: CRUD completo y JOIN triple. Integraremos los cuatro endpoints en un solo archivo y haremos consultas con JOIN de 3 tablas.
