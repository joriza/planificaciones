# Encuentro 22 — DELETE con Dapper y MapDelete

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duracion** | 240 minutos |
| **Unidad** | 3 — CRUD completo con Dapper |
| **Eje** | 5 — CRUD con Dapper |
| **Tipo** | Procedimental |
| **Requiere** | Encuentro 21 (POST, `ExecuteScalar<long>`, validacion basica), proyecto con paquetes Dapper + Sqlite y `hospital.db` |
| **Nuevo concepto** | Endpoint DELETE con `MapDelete`, `Execute` para borrado, respuesta `Results.NoContent` (204) |

## Reparto de tiempos (240 minutos)

| Bloque | Duracion |
|---|---|
| Apertura y motivacion | 20 min |
| Teoria minima con ejemplo completo | 50 min |
| Ejercicio progresivo | 120 min |
| Puesta en comun y correccion de errores | 30 min |
| Cierre | 20 min |

## Objetivos de aprendizaje

- Crear un endpoint DELETE usando `MapDelete` para eliminar recursos por ID.
- Ejecutar DELETE parametrizado con Dapper usando el metodo `Execute`.
- Verificar existencia del recurso antes de borrar y devolver `404` si no existe.
- Devolver `Results.NoContent` (204) cuando el borrado se completa exitosamente.

## Charla rapida / analogia

Imaginate que un paciente fue dado de alta por error y hay que **eliminar su ficha** del sistema. No alcanza con ocultarla: hay que borrarla definitivamente. En HTTP eso se hace con el verbo DELETE. A diferencia del POST, DELETE no devuelve el recurso borrado: solo confirma que ya no existe con un `204 No Content`.

## Teoria minima

### DELETE con Dapper

DELETE es la operacion mas simple del CRUD en cuanto a codigo: recibe un ID por ruta, ejecuta `DELETE FROM tabla WHERE id = @id`, y devuelve `204`. La unica decision es si **verificar existencia** antes de borrar o confiar en las filas afectadas.

### `Execute` de Dapper

El metodo `Execute` de Dapper ejecuta cualquier comando SQL y devuelve la cantidad de **filas afectadas** como `int`. Es el metodo indicado para DELETE, pero tambien se usa para INSERT (cuando no necesitas el ID) y UPDATE.

```csharp
int filas = connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });
if (filas == 0) return Results.NotFound(...);
```

### Respuesta canonica para DELETE

| Situacion | Respuesta | Codigo |
|---|---|---|
| El recurso existia y se borro | `Results.NoContent()` | `204` |
| El recurso no existia | `Results.NotFound(mensaje)` | `404` |
| El ID es invalido (negativo, cero) | `Results.BadRequest(mensaje)` | `400` |

### DELETE sin cuerpo

DELETE es un verbo que no requiere cuerpo en la peticion. Todo lo que necesita es el ID en la ruta:

```
DELETE /patients/5
```

## Practica guiada: endpoint DELETE /patients/{id:long}

Agregamos este `MapDelete` a `Program.cs`, **antes** de `app.Run()`:

```csharp
// DELETE /patients/{id:long} — eliminar un paciente por ID
app.MapDelete("/patients/{id:long}", (long id) =>
{
    // El ID debe ser positivo
    if (id <= 0)
        return Results.BadRequest(new { mensaje = "El ID debe ser un numero positivo" });

    using var connection = new SqliteConnection(connectionString);
    int filasAfectadas = connection.Execute(
        "DELETE FROM patients WHERE patient_id = @id", new { id });

    // Si ninguna fila fue afectada, el paciente no existia
    if (filasAfectadas == 0)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    return Results.NoContent();
});
```

### ¿Que hace cada linea?

1. `MapDelete("/patients/{id:long}", (long id) => ...)` captura el ID de la ruta.
2. Valida que el ID sea positivo. Si es `0` o negativo, `400` sin tocar la base.
3. Abre la conexion y ejecuta `DELETE FROM patients WHERE patient_id = @id`.
4. Si `filasAfectadas` es `0`, el registro no existe y responde `404`.
5. Si el DELETE se ejecuto, responde `204` sin cuerpo.

### Salida esperada

```bash
# Borrar el paciente con ID 5
curl -X DELETE http://localhost:5000/patients/5

# Respuesta: 204 No Content (sin cuerpo)

# Intentar borrar un ID inexistente (999)
curl -X DELETE http://localhost:5000/patients/999

# Respuesta: 404 Not Found
# Cuerpo: { "mensaje": "Paciente no encontrado" }
```

## Ejercicio progresivo

### Etapa 1 — DELETE /doctors/{id:long} (guiada)

Crea un endpoint `MapDelete` para la tabla `doctors`. Sigue el mismo patron: validar ID, ejecutar DELETE, verificar filas afectadas, devolver `204` o `404`.

**Pista:** solo cambia el nombre de la tabla y el record referido.

### Etapa 2 — DELETE /provinces/{id:long} con restriccion (semiguiada)

Crea un endpoint DELETE para `province_names`. Pero ademas de verificar existencia, considera: ¿que pasa si hay pacientes que referencian esa provincia en `province_id`? SQLite no va a dejar borrar una provincia referenciada por una restriccion de clave foranea (si esta habilitada).

**Pista:** si el DELETE falla por restriccion, `Execute` devuelve `0` o puede lanzar una excepcion. Explica en un comentario que las provincias referenciadas no pueden eliminarse.

### Etapa 3 — DELETE /admissions/{id:long} con validacion de ID negativo (independiente)

Crea un endpoint DELETE para `admissions`. Agrega validacion de que el ID sea positivo y maneja el caso `404`.

**Pista:** la tabla `admissions` tiene `admission_id` como clave primaria. No hay restricciones adicionales que considerar.

### Qué te llevás

- DELETE es el verbo HTTP para **eliminar** recursos.
- `Execute` devuelve filas afectadas; si es `0`, el recurso no existía.
- La respuesta canónica para DELETE exitoso es `204 No Content`.
- Conviene validar el ID antes de ejecutar la consulta.

### Lo que viene

En el Encuentro 23 vas a modificar recursos existentes con UPDATE y `MapPut`, completando el trío de escritura junto con POST y DELETE.

## Errores comunes y trampas

| Error | Causa | Solucion |
|---|---|---|
| Devolver `200` con el objeto borrado en lugar de `204` | Confundir DELETE con GET. | Recordar que DELETE confirma, no devuelve el recurso. Usar `Results.NoContent()`. |
| No verificar `filasAfectadas == 0` y devolver `204` aunque no existiera | El DELETE sobre ID inexistente no falla, solo afecta 0 filas. | Verificar filas afectadas y devolver `404` si es 0. |
| Usar `ExecuteScalar<long>` en lugar de `Execute` | Repetir el patron de POST sin pensar. | DELETE no devuelve un ID nuevo; `Execute` es el metodo correcto. |
| Olvidar `@id` y concatenar el valor al SQL | Riesgo de inyeccion. | Usar `DELETE FROM patients WHERE patient_id = @id` con `new { id }`. |
| Responder `404` con mensaje en ingles | Copiar de documentacion externa. | Usar `new { mensaje = "Paciente no encontrado" }` en espanol. |