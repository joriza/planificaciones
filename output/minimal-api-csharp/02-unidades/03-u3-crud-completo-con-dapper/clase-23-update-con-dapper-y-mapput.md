# Encuentro 23 — UPDATE con Dapper y MapPut

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duracion** | 240 minutos |
| **Unidad** | 3 — CRUD completo con Dapper |
| **Eje** | 5 — CRUD con Dapper |
| **Tipo** | Procedimental |
| **Requiere** | Encuentro 21 (POST, `ExecuteScalar<long>`) y Encuentro 22 (DELETE, `Execute`), proyecto con Dapper + Sqlite y `hospital.db` |
| **Nuevo concepto** | Endpoint PUT con `MapPut`, `Execute` para actualizacion, verificacion de existencia previa, respuesta `Results.NoContent` (204) para PUT sobre BD |

## Reparto de tiempos (240 minutos)

| Bloque | Duracion |
|---|---|
| Apertura y motivacion | 20 min |
| Teoria minima con ejemplo completo | 50 min |
| Ejercicio progresivo | 120 min |
| Puesta en comun y correccion de errores | 30 min |
| Cierre | 20 min |

## Objetivos de aprendizaje

- Crear un endpoint PUT usando `MapPut` que recibe ID por ruta y nuevos datos por cuerpo.
- Verificar que el recurso existe antes de actualizar usando `QueryFirstOrDefault`.
- Ejecutar un UPDATE parametrizado con Dapper y verificar filas afectadas.
- Distinguir entre `Results.NoContent` (PUT sobre BD) y `Results.Ok` (PUT en memoria), segun el canon.

## Charla rapida / analogia

Un paciente cambio de domicilio y hay que **actualizar su ficha**. No se crea una nueva (POST) ni se borra la anterior (DELETE): se **modifica** el registro existente. En HTTP eso se hace con PUT. PUT reemplaza el recurso completo con los datos nuevos. Es el tercer verbo de escritura y completa el trio junto con POST y DELETE.

## Teoria minima

### PUT no es parcial

PUT reemplaza el recurso **completo**. Si el cliente envia solo `firstName`, el resto de los campos del registro se deberian actualizar tambien (aunque algunos queden como `null` si la columna lo permite). Para actualizaciones parciales existe PATCH, pero en este curso usamos PUT con todos los campos.

### Verificacion de existencia

Actualizar un registro que no existe no tiene sentido. SQLite ejecuta el UPDATE igual pero afecta 0 filas. La practica recomendada es:

1. Leer el registro existente con `QueryFirstOrDefault`.
2. Si no existe, devolver `404`.
3. Si existe, ejecutar el UPDATE.

### Respuesta canonica para PUT

| Situacion | Respuesta | Codigo |
|---|---|---|
| Recurso actualizado en BD | `Results.NoContent()` | `204` |
| Recurso no encontrado | `Results.NotFound(mensaje)` | `404` |
| Dato invalido o faltante | `Results.BadRequest(mensaje)` | `400` |

## Practica guiada: endpoint PUT /patients/{id:long}

Agregamos este `MapPut` a `Program.cs`, **antes** de `app.Run()`:

```csharp
// PUT /patients/{id:long} — actualizar un paciente existente
app.MapPut("/patients/{id:long}", (long id, PatientInput input) =>
{
    // Validar que el nombre no este vacio
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);

    // Verificar que el paciente existe
    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate,
               city AS City,
               province_id AS ProvinceId,
               allergies AS Allergies,
               height AS Height,
               weight AS Weight
        FROM patients WHERE patient_id = @id", new { id });

    if (existente is null)
        return Results.NotFound(new { mensaje = "Paciente no encontrado" });

    // Actualizar todos los campos
    connection.Execute(@"
        UPDATE patients
        SET first_name = @FirstName,
            last_name = @LastName,
            gender = @Gender,
            birth_date = @BirthDate,
            city = @City,
            province_id = @ProvinceId,
            allergies = @Allergies,
            height = @Height,
            weight = @Weight
        WHERE patient_id = @Id", new
    {
        input.FirstName,
        input.LastName,
        input.Gender,
        input.BirthDate,
        input.City,
        input.ProvinceId,
        input.Allergies,
        input.Height,
        input.Weight,
        Id = id
    });

    return Results.NoContent();
});
```

### ¿Que hace cada linea?

1. Recibe dos parametros: el `id` de la ruta y el `input` del cuerpo JSON.
2. Valida `FirstName` como obligatorio.
3. Verifica existencia con `QueryFirstOrDefault`. Si no existe, `404`.
4. Ejecuta el UPDATE con todos los campos. El `Id = id` pasa el ID de ruta al parametro `@Id` del SQL.
5. Devuelve `204` sin cuerpo.

### Salida esperada

```bash
# Actualizar el paciente con ID 5
curl -X PUT http://localhost:5000/patients/5 \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Ana Maria","lastName":"Lopez","gender":"F","birthDate":"1990-05-15",
       "city":"Buenos Aires","provinceId":1,"allergies":"Polen","height":165,"weight":62}'

# Respuesta: 204 No Content (sin cuerpo)

# Intentar actualizar un ID inexistente
curl -X PUT http://localhost:5000/patients/999 \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Test","lastName":"X","gender":"M","birthDate":"2000-01-01"}'

# Respuesta: 404 Not Found
# Cuerpo: { "mensaje": "Paciente no encontrado" }
```

## Ejercicio progresivo

### Etapa 1 — PUT /doctors/{id:long} (guiada)

Crea un endpoint `MapPut` para `doctors`. Usa `DoctorInput` como entrada y el record `Doctor` para verificar existencia. Sigue el mismo patron del ejemplo.

**Pista:** la tabla `doctors` tiene campos opcionales como `specialty`, `phone`, `email`. Asegurate de incluirlos en el UPDATE aunque sean `null`.

### Etapa 2 — PUT /provinces/{id:long} con validacion de nombre (semiguiada)

Crea un endpoint PUT para `province_names`. Solo tiene `province_name` para actualizar. Valida que el nombre no sea vacio.

### Etapa 3 — PUT /admissions/{id:long} con filtro de solo campos no nulos (independiente)

Crea un endpoint PUT para `admissions`. Pero en lugar de enviar todos los campos (incluyendo `discharge_date` que puede ser `null`), modifica solo los campos que llegan en el cuerpo. Investigá como armar un UPDATE condicional.

**Pista:** podes armar el SQL dinamicamente concatenando solo los campos que no son `null`. Usa `Execute` con parametros adaptados al SQL armado.

## Cierre

### Que te llevas

- PUT reemplaza el recurso completo. Se usa con `MapPut` y recibe ID por ruta + cuerpo JSON.
- Siempre verificar existencia antes de actualizar.
- `Execute` es el metodo de Dapper para UPDATE, igual que para DELETE.
- La respuesta canonica para PUT sobre BD es `204 No Content`.

### Lo que viene

En el proximo encuentro vas a unir todo: CRUD completo sobre una tabla + un endpoint con JOIN triple que combina `admissions`, `doctors` y `patients`.

## Errores comunes y trampas

| Error | Causa | Solucion |
|---|---|---|
| No verificar existencia antes de actualizar | El UPDATE se ejecuta igual, afecta 0 filas, y el cliente no sabe que el recurso no existia. | Usar `QueryFirstOrDefault` y devolver `404` si es `null`. |
| Devolver `Results.Ok` con el objeto actualizado | Confundir PUT con GET. Sobre BD la respuesta canonica es `204`. | Usar `Results.NoContent()` para PUT sobre BD. |
| Olvidar `Id = id` en el objeto anonimo del UPDATE | El parametro `@Id` no se pasa y el UPDATE se ejecuta sin WHERE, actualizando **todas** las filas. | Siempre incluir el ID en el objeto anonimo. |
| Poner `id` directamente en el SQL | Riesgo de inyeccion si el valor viene de la ruta (aunque .NET lo valida). | Usar siempre `@id` y el objeto anonimo. |
| Enviar los campos en el UPDATE en orden erroneo | No importa el orden, pero si falta un campo se setea a `NULL`. | Hacer el UPDATE explicito con todos los campos del record. |