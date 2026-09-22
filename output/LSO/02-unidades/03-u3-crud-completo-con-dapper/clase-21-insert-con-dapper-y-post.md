# Encuentro 21 — INSERT con Dapper y POST

> Unidad 3 — CRUD completo con Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 21 de 36 |
| Unidad | 3 — CRUD completo con Dapper |
| Eje temático | 5 — CRUD con Dapper |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | INSERT con Dapper y POST |
| Requisitos previos | Encuentros 19-20: GET con Dapper, SELECT parametrizado, registros posicionales |
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

1. Insertar un registro en la tabla `patients` usando Dapper con SQL parametrizado.
2. Devolver el ID generado con `ExecuteScalar<long>` y usarlo en la respuesta.
3. Exponer el INSERT como endpoint `POST` con `MapPost` y responder con código `201`.
4. Validar que los campos obligatorios estén presentes antes de insertar y devolver `400` si faltan.

## 3. Apertura y motivación (20 min)

### Charla rápida: analogía breve que ancle el concepto

Imaginen que son recepcionistas de un hospital. Cuando llega un paciente nuevo, ustedes no escriben el nombre en cualquier lado: lo anotan en el libro de registro, con todos los campos completos, y le asignan un número de ficha. Esa ficha es el `INSERT`: un registro nuevo, completo y verificado, que queda almacenado para siempre.

### Devolución de la evaluación de la Unidad 2

Se devuelve la evaluación de la Unidad 2. Se revisan los errores más frecuentes (IDs como `int` en lugar de `long`, fechas como `DateTime`, SELECT sin alias `AS`). Se recuerda que la regla de oro es: INTEGER en SQLite siempre es `long` en C#.

### Lo mínimo indispensable

Hasta ahora solo leíamos datos con `Query<T>` y `QueryFirstOrDefault<T>`. Hoy vamos a escribir datos. El método Dapper para INSERT es `Execute`, y cuando necesitamos el ID que se acaba de generar usamos `ExecuteScalar<long>` con `SELECT last_insert_rowid()` al final del SQL. El endpoint correspondiente es `MapPost`, y la respuesta correcta es `Results.Created(url, dato)` con código `201`.

## 4. Desarrollo teórico-práctico (120 min)

### Paso 1 — El record y la cadena de conexión

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var connectionString = "Data Source=hospital.db";

// Record posicional para pacientes: ids long, fechas string, nulables con ?
public record Patient(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    string ProvinceId,
    string? Allergies,
    long? Height,
    long? Weight
);
```

> Comentario: el record va **después** de `app.Run()` en el archivo final. Acá lo ponemos arriba para leerlo cómodo.

### Paso 2 — El endpoint POST con INSERT parametrizado

```csharp
// POST /patients — crear un paciente nuevo y devolver 201 con la URL del recurso
app.MapPost("/patients", (Patient nuevoPaciente) =>
{
    // Validar que los campos obligatorios no sean nulos o vacios
    if (string.IsNullOrWhiteSpace(nuevoPaciente.FirstName) ||
        string.IsNullOrWhiteSpace(nuevoPaciente.LastName))
    {
        return Results.BadRequest(new { mensaje = "El nombre y el apellido son obligatorios" });
    }

    // Abrir conexion a la base de datos con using para que se cierre automaticamente
    using var connection = new SqliteConnection(connectionString);

    // INSERT parametrizado: nunca concatenar datos al SQL
    // last_insert_rowid() devuelve el ID del ultimo insert en la conexion actual
    long newId = connection.ExecuteScalar<long>(@"
        INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
        VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
        SELECT last_insert_rowid();
    ", nuevoPaciente);

    // Asignar el ID generado al objeto para la respuesta
    var pacienteCreado = nuevoPaciente with { PatientId = newId };

    // 201 Created con la URL del recurso recien creado
    return Results.Created($"/patients/{newId}", pacienteCreado);
});
```

> Comentario: `ExecuteScalar<long>` lee el primer valor de la primera fila del resultado como `Int64`. Esto es canónico para obtener el ID autoincremental en SQLite con Dapper.

### Paso 3 — Probar el endpoint

Desde Thunder Client o curl:

```bash
curl -X POST http://localhost:5000/patients \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Carlos","lastName":"Gomez","gender":"M","birthDate":"1985-03-15","city":"Rosario","provinceId":"SF","allergies":"Penicillin","height":178,"weight":82}'
```

Salida esperada (código 201, body con el paciente creado incluyendo su `patientId`):

```json
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

El header `Location` del response contiene `/patients/259`.

### Paso 4 — Qué pasa si falta un campo obligatorio

```bash
curl -X POST http://localhost:5000/patients \
  -H "Content-Type: application/json" \
  -d '{"firstName":"","lastName":"","gender":"M","birthDate":"1985-03-15"}'
```

Salida esperada (código 400):

```json
{ "mensaje": "El nombre y el apellido son obligatorios" }
```

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- `ExecuteScalar<long>` es el método canónico para obtener el ID generado por un INSERT en SQLite con Dapper.
- El SQL debe terminar con `SELECT last_insert_rowid()` para devolver el ID.
- `MapPost` expone un endpoint POST y `Results.Created(url, dato)` responde con código `201` y la URL del recurso nuevo en el header `Location`.
- Siempre se validan los campos obligatorios antes de tocar la base de datos y se devuelve `400` con un `mensaje` en español si faltan.
- Los comentarios en el código van en español, sin tildes ni eñes dentro del código fuente.

## Lo que viene

Encuentro 22: DELETE con Dapper y MapDelete. Aprenderemos a borrar registros validando primero que existan, diferenciando `404` (no encontrado) de `204` (borrado exitoso).
