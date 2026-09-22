# Encuentro 22 — DELETE con Dapper y MapDelete

> Unidad 3 — CRUD completo con Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 22 de 36 |
| Unidad | 3 — CRUD completo con Dapper |
| Eje temático | 5 — CRUD con Dapper |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | DELETE con Dapper y MapDelete |
| Requisitos previos | Encuentro 21: INSERT con Dapper y POST, `ExecuteScalar<long>`, `Results.Created` |
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

1. Borrar un registro de la tabla `patients` usando Dapper con SQL parametrizado.
2. Validar la existencia del recurso antes de borrar y devolver `404` si no existe.
3. Exponer el DELETE como endpoint con `MapDelete` y responder con código `204` (éxito) o `404` (no encontrado).
4. Entender la semántica de `Results.NoContent()` como respuesta a un borrado exitoso.

## 3. Apertura y motivación (20 min)

### Charla rápida: analogía breve que ancle el concepto

Cuando un paciente se da de alta definitiva del hospital, su ficha se retira del sistema. No se puede borrar una ficha que no existe: primero hay que buscarla en el archivo, confirmar que está ahí, y recién entonces sacarla. Eso es exactamente lo que hace nuestro endpoint DELETE: primero verificamos que el paciente exista, y si existe lo borramos.

### Lo mínimo indispensable

El método Dapper para DELETE es `Execute`, que devuelve la cantidad de filas afectadas. La diferencia clave con INSERT es que antes de borrar debemos verificar que el recurso exista. Si no existe, devolvemos `404` con `Results.NotFound`. Si existe y lo borramos correctamente, devolvemos `204` con `Results.NoContent()`. El endpoint se define con `MapDelete`.

## 4. Desarrollo teórico-práctico (120 min)

### Paso 1 — El endpoint DELETE con validación de existencia

```csharp
// DELETE /patients/{id:long} — borrar un paciente por ID
// Primero verificamos que exista, luego borramos
app.MapDelete("/patients/{id:long}", (long id) =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);

    // Buscar el paciente antes de borrar para validar que exista
    var paciente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE patient_id = @id", new { id });

    // Si no existe, devolver 404
    if (paciente is null)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    // Borrar el paciente con SQL parametrizado
    int filasAfectadas = connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    // filasAfectadas deberia ser 1 si el delete fue exitoso
    // Devolver 204 No Content (sin cuerpo en la respuesta)
    return Results.NoContent();
});
```

> Comentario: `QueryFirstOrDefault` devuelve `null` si no encuentra ninguna fila. Esa es la señal para devolver `404` antes de intentar el DELETE.

### Paso 2 — Probar el DELETE con un paciente que existe

```bash
curl -X DELETE http://localhost:5000/patients/259
```

Salida esperada (código 204, sin body):

```
HTTP/1.1 204 No Content
```

Si intentamos verificar que se borró:

```bash
curl http://localhost:5000/patients/259
```

Salida esperada (código 404):

```json
{ "mensaje": "Paciente no encontrado" }
```

### Paso 3 — Probar el DELETE con un paciente que no existe

```bash
curl -X DELETE http://localhost:5000/patients/9999
```

Salida esperada (código 404):

```json
{ "mensaje": "Paciente no encontrado" }
```

> Comentario: el código 404 indica que el recurso solicitado no existe. No devolvemos 200 ni 204 cuando el recurso no está, porque eso sería ambiguo: ¿se borró o simplemente no existía?

### Paso 4 — DELETE con verificación del conteo de filas afectadas

Una variante más robusta verifica que `Execute` haya afectado exactamente una fila:

```csharp
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    int filasAfectadas = connection.Execute(@"
        DELETE FROM patients
        WHERE patient_id = @id", new { id });

    // Si no se borro ninguna fila, el id no existia
    if (filasAfectadas == 0)
    {
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });
    }

    // Se borro exactamente una fila
    return Results.NoContent();
});
```

> Comentario: esta variante no hace SELECT previo, sino que confía en que `Execute` devuelve 0 si no se encontró ninguna fila que coincida. Es más eficiente (una sola consulta a la BD) pero no permite devolver un mensaje más detallado.

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- `MapDelete` expone un endpoint DELETE y `Results.NoContent()` responde con código `204` (sin cuerpo).
- Antes de borrar siempre se valida la existencia del recurso. Si no existe, se devuelve `404` con `Results.NotFound(new { mensaje = "..." })`.
- `Execute` devuelve `int` con la cantidad de filas afectadas; si es 0, el recurso no existía.
- El SQL siempre usa `@id` como parámetro y `new { id }` como objeto anónimo.
- La conexión se abre con `using var` para garantizar su cierre automático.

## Lo que viene

Encuentro 23: UPDATE con Dapper y MapPut. Modificaremos registros existentes con SQL parametrizado y aprenderemos a devolver el recurso actualizado.
