# Encuentro 21 — INSERT con Dapper y POST

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duración** | 240 minutos |
| **Unidad** | 3 — CRUD completo con Dapper |
| **Eje** | 5 — CRUD con Dapper |
| **Tipo** | Procedimental |
| **Requiere** | Unidad 2 (SELECT parametrizado, QueryFirstOrDefault, alias AS), proyecto `dotnet new web` funcional con paquetes Dapper + Sqlite y base `hospital.db` |
| **Nuevo concepto** | Endpoint POST, `ExecuteScalar<long>` para `last_insert_rowid()`, respuesta `Results.Created` |

## Reparto de tiempos (240 minutos)

| Bloque | Duracion |
|---|---|
| Apertura y motivacion | 20 min |
| Teoria minima con ejemplo completo | 50 min |
| Ejercicio progresivo | 120 min |
| Puesta en comun y correccion de errores | 30 min |
| Cierre | 20 min |

## Objetivos de aprendizaje

- Crear un endpoint POST usando `MapPost` en una Minimal API.
- Ejecutar un INSERT parametrizado con Dapper usando `ExecuteScalar<long>` para recuperar el ID generado.
- Devolver `Results.Created` con la URL del recurso recién creado y el objeto completo, cumpliendo el canon de respuestas HTTP.
- Validar datos obligatorios en el cuerpo de la peticion y rechazar con `400` cuando falten.

## Charla rapida / analogia

Pensá en el recepcionista del hospital que **da de alta a un nuevo paciente**. Hasta ahora solo supimos **consultar** la ficha de pacientes que ya estaban internados (GET). Ahora vamos a ser nosotros quienes **agreguemos** una ficha nueva. En terminos HTTP, pasamos del verbo GET al verbo POST: el verbo que **crea** recursos.

## Teoria minima

### ¿Que cambia con POST?

En los encuentros anteriores siempre leimos datos. POST es el primer verbo de **escritura**: el cliente envia un objeto JSON en el cuerpo de la peticion y el servidor lo guarda en la base de datos.

### `ExecuteScalar<long>` y `last_insert_rowid()`

Dapper ofrece `ExecuteScalar<long>` para ejecutar un INSERT y devolver el valor de la primera columna de la primera fila del resultado. En SQLite escribimos:

```sql
INSERT INTO patients (first_name, last_name, gender, birth_date)
VALUES (@FirstName, @LastName, @Gender, @BirthDate);
SELECT last_insert_rowid() AS NewId;
```

La funcion `last_insert_rowid()` devuelve el `id` que SQLite acaba de asignar. Al ejecutar dos instrucciones separadas por punto y coma, Dapper toma el resultado del `SELECT` como valor de retorno.

### Record para entrada vs. record para salida

Usamos dos records distintos:

- **`PatientInput`** — solo los campos que envia el cliente (sin `PatientId`, que la base genera).
- **`Patient`** — el record completo con `PatientId` que usamos para devolver el recurso creado.

Esto evita confusion: no tiene sentido que el cliente envie un `PatientId` que aun no existe.

### POST y `Results.Created`

| Metodo | Retorno | Uso |
|---|---|---|
| `Results.Created(url, objeto)` | `201 Created` | Alta correcta. La URL senala donde se encuentra el recurso nuevo. |
| `Results.BadRequest(mensaje)` | `400 Bad Request` | El cuerpo de la peticion no paso la validacion. |

## Practica guiada: endpoint POST /patients

Agregamos el siguiente `MapPost` a `Program.cs`, **antes** de `app.Run()`:

```csharp
// POST /patients — crear un nuevo paciente
app.MapPost("/patients", (PatientInput input) =>
{
    // Validar que el nombre no este vacio
    if (string.IsNullOrWhiteSpace(input.FirstName))
        return Results.BadRequest(new { mensaje = "El nombre es obligatorio" });

    using var connection = new SqliteConnection(connectionString);
    var newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid() AS NewId;", input);

    // Recuperar el paciente recien creado para devolverlo completo
    var paciente = connection.QueryFirstOrDefault<Patient>(@"
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
        FROM patients
        WHERE patient_id = @id", new { id = newId });

    return Results.Created($"/patients/{newId}", paciente);
});
```

Record de entrada (al final del archivo, **despues** de `app.Run()`):

```csharp
record PatientInput(string FirstName, string? LastName, string Gender, string BirthDate,
                    string? City, long? ProvinceId, string? Allergies, long? Height, long? Weight);
```

### ¿Que hace cada linea?

1. `MapPost` espera el cuerpo JSON en `input` y lo deserializa automaticamente.
2. Valida que `FirstName` no este vacio. Si lo esta, devuelve `400` sin tocar la base.
3. Abre la conexion y ejecuta el INSERT con `ExecuteScalar<long>`.
4. `last_insert_rowid()` devuelve el ID generado; Dapper lo asigna a `newId` como `long`.
5. Vuelve a leer el registro completo para devolverlo como `Patient`.
6. `Results.Created` produce `201` con la URL del recurso y el cuerpo JSON.

### Salida esperada

```bash
curl -X POST http://localhost:5000/patients \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Ana","lastName":"Lopez","gender":"F","birthDate":"1990-05-15"}'

# Respuesta: 201 Created
# Location: /patients/226 (el id puede variar)
# Cuerpo: { "patientId": 226, "firstName": "Ana", ... }
```

## Ejercicio progresivo

### Etapa 1 — Agregar endpoint POST /doctors (guiada)

Crea un endpoint `MapPost` para la tabla `doctors`. Usa el mismo patron que el ejemplo. La tabla `doctors` tiene estas columnas: `doctor_id` (autonumerico), `first_name`, `last_name`, `specialty`, `phone`, `email`.

**Pista:** crea un record `DoctorInput` con los campos que envia el cliente (sin `DoctorId`). Usa `ExecuteScalar<long>` con `last_insert_rowid()`.

### Etapa 2 — Agregar endpoint POST /provinces (semiguiada)

Crea un endpoint POST para la tabla `province_names`. Columnas: `province_id` (autonumerico), `province_name`.

**Pista:** la validacion debe verificar que `ProvinceName` no este vacio. No tiene campos nulables, asi que `ProvinceInput` es simple.

### Etapa 3 — Endpoint POST /admissions (independiente)

Crea un endpoint POST para la tabla `admissions`. Columnas: `admission_id` (autonumerico), `patient_id`, `doctor_id`, `admission_date`, `diagnosis`, `discharge_date` (puede ser nulo).

**Pistas:**
- `AdmissionInput` recibe `PatientId`, `DoctorId`, `AdmissionDate`, `Diagnosis`, `DischargeDate?`.
- La validacion debe verificar `PatientId > 0` y que `AdmissionDate` no este vacia.
- La respuesta incluye la URL `/admissions/{newId}`.

### Qué te llevás

- POST es el verbo HTTP para **crear** recursos.
- `ExecuteScalar<long>` con `last_insert_rowid()` recupera el ID generado por SQLite.
- `Results.Created` devuelve `201` con la URL del nuevo recurso.
- Conviene tener un record de entrada separado del record completo.

### Lo que viene

En el Encuentro 22 vas a borrar pacientes con DELETE, otro verbo de escritura que responde con `204`.

## Errores comunes y trampas

| Error | Causa | Solucion |
|---|---|---|
| `InvalidOperationException`: no hay constructor que acepte los parametros | Olvidaste el alias `AS` en el SELECT que recupera el paciente creado. | Agregar `patient_id AS PatientId, first_name AS FirstName, ...` |
| El INSERT se ejecuta pero devuelve `0` en lugar del ID | Usaste `conn.Execute(sql)` en vez de `conn.ExecuteScalar<long>(sql)`. | Cambiar a `ExecuteScalar<long>` que captura el resultado del `SELECT last_insert_rowid()`. |
| Error `400` aunque enviaste todos los datos | El nombre de la propiedad JSON no coincide con el record (case-sensitive en algunos clientes). | Revisar que el JSON use camelCase (`firstName`, no `FirstName`). |
| El record `PatientInput` esta declarado **antes** de `app.Run()` | Error CS8803: las top-level statements deben preceder a las declaraciones de tipo. | Mover el record despues de `app.Run()`. |
| El campo `birth_date` se envia como `DateTime` en lugar de `"yyyy-MM-dd"` | El record espera `string`, pero el cliente manda un objeto fecha. | El cliente debe enviar el string ISO: `"1990-05-15"`. |