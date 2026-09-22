# Anexo docente — Encuentro 21: INSERT con Dapper y POST

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

El ejercicio independiente no tiene una consigna explícita en el encuentro 21 (es el primer encuentro de escritura). La solución de referencia es el endpoint POST completo mostrado en el desarrollo teórico-práctico, paso 2.

```csharp
app.MapPost("/patients", (Patient nuevoPaciente) =>
{
    if (string.IsNullOrWhiteSpace(nuevoPaciente.FirstName) ||
        string.IsNullOrWhiteSpace(nuevoPaciente.LastName))
    {
        return Results.BadRequest(new { mensaje = "El nombre y el apellido son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    long newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid();
    ", nuevoPaciente);

    var pacienteCreado = nuevoPaciente with { PatientId = newId };
    return Results.Created($"/patients/{newId}", pacienteCreado);
});
```

**Salida esperada con hospital.db real** (el último patient_id antes del insert es 258):

```
> curl -X POST http://localhost:5000/patients \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Carlos","lastName":"Gomez","gender":"M","birthDate":"1985-03-15","city":"Rosario","provinceId":"SF","allergies":"Penicillin","height":178,"weight":82}'

HTTP/1.1 201 Created
Location: /patients/259
Content-Type: application/json

{
  "patientId": 259,
  "firstName": "Carlos",
  "lastName": "Gomez",
  "gender": "M",
  "birthDate": "1985-03-15",
  "city": "Rosario",
  "provinceId": "SF",
  "allergies": "Penicillin",
  "height": 178,
  "weight": 82
}
```

**Salida esperada con datos faltantes** (código 400):

```
> curl -X POST http://localhost:5000/patients \
    -H "Content-Type: application/json" \
    -d '{"firstName":"","lastName":""}'

HTTP/1.1 400 Bad Request
Content-Type: application/json

{ "mensaje": "El nombre y el apellido son obligatorios" }
```

## 2. Solución de la actividad de extensión

### Actividad 1 — INSERT con validación de unicidad

```csharp
app.MapPost("/patients", (Patient nuevoPaciente) =>
{
    if (string.IsNullOrWhiteSpace(nuevoPaciente.FirstName) ||
        string.IsNullOrWhiteSpace(nuevoPaciente.LastName))
    {
        return Results.BadRequest(new { mensaje = "El nombre y el apellido son obligatorios" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Verificar si ya existe un paciente con el mismo nombre y apellido
    var existente = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName,
               gender AS Gender, birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight
        FROM patients
        WHERE first_name = @FirstName AND last_name = @LastName
    ", nuevoPaciente);

    if (existente is not null)
    {
        return Results.StatusCode(409); // Conflict
        // Nota: Results.Conflict existe en ASP.NET Core 7+; en .NET 6 usar StatusCode(409)
    }

    long newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid();
    ", nuevoPaciente);

    var pacienteCreado = nuevoPaciente with { PatientId = newId };
    return Results.Created($"/patients/{newId}", pacienteCreado);
});
```

**Salida esperada** (paciente duplicado, código 409):

```
> curl -X POST http://localhost:5000/patients \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Donald","lastName":"Waterfield","gender":"M","birthDate":"1963-02-12","provinceId":"ON"}'

HTTP/1.1 409 Conflict
```

### Actividad 2 — Paginación simple (ya incluida en el desarrollo teórico-práctico)

La solución completa está en el paso 2 de la actividad complementaria del encuentro. La salida esperada para `GET /patients?page=1&pageSize=3`:

```json
[
  {
    "patientId": 1,
    "firstName": "Donald",
    "lastName": "Waterfield",
    "gender": "M",
    "birthDate": "1963-02-12",
    "city": "Barrie",
    "provinceId": "ON",
    "allergies": "Penicillin",
    "height": 156,
    "weight": 65
  },
  {
    "patientId": 2,
    "firstName": "Mickey",
    "lastName": "Baasha",
    "gender": "M",
    "birthDate": "2017-11-19",
    "city": null,
    "provinceId": "ON",
    "allergies": null,
    "height": null,
    "weight": null
  },
  {
    "patientId": 3,
    "firstName": "Jiji",
    "lastName": "Sharma",
    "gender": "F",
    "birthDate": "1990-07-22",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": "Sulfa",
    "height": 162,
    "weight": 55
  }
]
```

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Código |
| --- | --- | --- |
| POST /patients con datos válidos | Paciente creado con `patientId` asignado, header `Location` con la URL del recurso | 201 |
| POST /patients sin `firstName` | `{ "mensaje": "El nombre y el apellido son obligatorios" }` | 400 |
| POST /patients con `firstName` vacío | `{ "mensaje": "El nombre y el apellido son obligatorios" }` | 400 |
| GET /patients?page=1&pageSize=2 | Array de 2 pacientes ordenados por `patient_id` | 200 |
| GET /patients sin parámetros | Array de hasta 10 pacientes (valores por defecto) | 200 |

## 4. Criterios de corrección (lista de verificación)

- [ ] El record `Patient` usa `long` para `PatientId` (no `int`)
- [ ] El record `Patient` usa `string` para `BirthDate` (no `DateTime`)
- [ ] Los campos nullable (`City`, `Allergies`, `Height`, `Weight`) llevan `?`
- [ ] El SQL del INSERT usa `@FirstName`, `@LastName`, etc. (parámetros, no concatenación)
- [ ] El SQL termina con `SELECT last_insert_rowid()`
- [ ] Se usa `ExecuteScalar<long>` (no `Execute` ni `ExecuteScalar<int>`)
- [ ] Se usa `using var connection = new SqliteConnection(connectionString)`
- [ ] El endpoint usa `MapPost` (no `MapGet` ni `MapPut`)
- [ ] La respuesta exitosa es `Results.Created(url, dato)` con código 201
- [ ] La validación de campos obligatorios devuelve `Results.BadRequest` con `mensaje` en español
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes dentro del código fuente
- [ ] El record está después de `app.Run()` en el archivo final

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException`: no constructor matches | `PatientId` declarado como `int` en el record. Dapper devuelve `Int64` y no encuentra constructor con `int`. | Cambiar a `long PatientId`. Recordar: INTEGER en SQLite siempre es `long` en C#. |
| `InvalidOperationException`: no constructor matches (fecha) | `BirthDate` declarado como `DateTime` o `DateOnly`. Dapper recibe `String` y no encuentra constructor que acepte `DateTime`. | Cambiar a `string BirthDate`. Convertir con `DateTime.Parse()` solo al presentar. |
| `null` en `PatientId` del response | Se usó `Execute` en vez de `ExecuteScalar<long>`. `Execute` devuelve `int` (filas afectadas), no el ID. | Cambiar a `ExecuteScalar<long>` y agregar `SELECT last_insert_rowid()` al SQL. |
| SQL error: no such column | Se usó el nombre de columna en inglés del record (`PatientId`) en el SQL sin alias `AS`. | Agregar alias: `patient_id AS PatientId`. Siempre usar alias `AS` con el nombre exacto del parámetro del constructor. |
| `400` inesperado al enviar JSON válido | El model binder no puede mapear `birthDate` del JSON a `BirthDate` del record (casing). | Explicar que ASP.NET Core deserializa JSON con nombres camelCase por defecto y los mapea a propiedades PascalCase del record. |
| Conexión no se cierra | Falta `using` antes de `var connection`. | Agregar `using var connection = new SqliteConnection(...)`. |

## 6. Registro de la clase

| Grupo | Participación en la devolución de U2 | Pudo ejecutar el POST correctamente | Usó parámetros en el SQL | Manejó el error 400 | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | Activa, identificó el error de `int` vs `long` | Sí | Sí | Sí | |
| Grupo 2 | Pasiva, no revisó la devolución | Sí (con ayuda) | Sí | No, no validó campos vacíos | Requiere refuerzo en validación |
| Grupo 3 | Activa, pregunta sobre `last_insert_rowid` | Sí | Sí | Sí | |
| Grupo 4 | Ausente (licencia) | — | — | — | Reintegro pendiente |

**Notas para la evaluación de proceso:** verificar que cada grupo pueda explicar por qué se usa `ExecuteScalar<long>` y no `Execute` para obtener el ID. Evaluar si el grupo entiende la diferencia entre `201` (recurso creado) y `200` (actualización). Registrar qué grupos necesitaron apoyo adicional con la validación de campos obligatorios.
