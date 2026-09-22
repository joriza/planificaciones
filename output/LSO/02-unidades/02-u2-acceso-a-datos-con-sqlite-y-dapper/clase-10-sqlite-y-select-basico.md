# Encuentro 10 — SQLite y SELECT básico

> Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 10 de 36 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Eje temático | 3 — SQLite y SQL básico |
| Carácter/Objetivo | Conceptual |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | SQLite y SELECT básico |
| Requisitos previos | Haber completado la Evaluación de la Unidad 1; conocer los fundamentos de C# (variables, tipos básicos, top-level statements en un único `Program.cs`); haber visto endpoints `MapGet` con Minimal API. |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual en la notebook; el docente circula y acompaña la conexión inicial con `hospital.db`. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Identificar qué es SQLite y por qué se usa como base de datos liviana en proyectos Minimal API.
2. Conectar `hospital.db` a un proyecto C# y ejecutar un `SELECT` simple con Dapper.
3. Entender el mapeo entre columnas INTEGER de SQLite y el tipo `long` en C#.
4. Leer datos de la tabla `patients` y presentarlos por endpoint.

## 3. Apertura y motivación (20 min)

### Devolución de la evaluación de la Unidad 1

El docente devuelve la evaluación de la Unidad 1 y realiza un breve cierre de los puntos más frecuentes. Se retoman los conceptos de endpoints `MapGet` y se conectan con la idea de que un endpoint no solo devuelve datos en memoria, sino que puede leerlos desde una base de datos real.

### Introducción al encuentro

Hasta ahora, nuestros endpoints devolvían datos hardcodeados o en memoria. Pero una API real necesita hablar con una base de datos. Hoy vamos a conocer SQLite, la base de datos liviana que usa un solo archivo `.db`, y vamos a aprender a consultarla desde C# con Dapper.

**Analogía rápida:** pensá en `hospital.db` como un archivador con carpetas (tablas). Cada carpeta tó fichas (filas) con datos de los pacientes, médicos o ingresos. Nosotros vamos a abrir el archivador, pedir una ficha o un montón de fichas, y traerlas al programa.

## 4. Desarrollo teórico-práctico (120 min)

### Teoría: ¿Qué es SQLite y cómo se conecta?

SQLite es un motor de base de datos que vive en un solo archivo. No necesita servidor, no necesita instalar nada extra: el archivo `hospital.db` está al lado de nuestro proyecto y listo para usar.

Para hablar con SQLite desde C# necesitamos dos paquetes NuGet:

- `Microsoft.Data.Sqlite` — el conector que abre la conexión al archivo `.db`.
- `Dapper` — la librería que transforma las filas del resultado en objetos C#.

La cadena de conexión es siempre la misma:

```csharp
// Cadena que apunta al archivo hospital.db en la carpeta del proyecto
var connectionString = "Data Source=hospital.db";
```

Cada vez que necesitamos consultar la base, abrimos una conexión con `using`, hacemos la consulta y la conexión se cierra sola al salir del bloque.

### Práctica guiada: primer SELECT desde C#

Vamos a escribir el primer endpoint que lee datos de `hospital.db`. Seguimos el esqueleto canónico del curso: `builder` → `app` → endpoints → `app.Run()` → records al final.

```csharp
// Program.cs — Ejemplo completo: SELECT simple desde hospital.db
// Usar Dapper y Microsoft.Data.Sqlite para conectarse a la base

using Dapper;
using Microsoft.Data.Sqlite;

// Cadena de conexion fija: apunta al archivo hospital.db
var connectionString = "Data Source=hospital.db";

// Crear la aplicacion web con Minimal API
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — listar todos los pacientes con un SELECT simple
app.MapGet("/patients", () =>
{
    // Abrir conexion a la base de datos; se cierra automaticamente al salir del bloque
    using var connection = new SqliteConnection(connectionString);

    // Consulta SELECT que devuelve todas las columnas de la tabla patients
    // Dapper mapea cada fila a un objeto Patient usando los alias AS
    var patients = connection.Query<Patient>(@"
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
    ").ToList();

    // Devolver la lista de pacientes con codigo HTTP 200
    return Results.Ok(patients);
});

// GET /patients/{id:long} — obtener un solo paciente por su ID
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Consulta parametrizada: @id recibe el valor del path sin concatenar strings
    var patient = connection.QueryFirstOrDefault<Patient>(@"
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
        WHERE patient_id = @id", new { id });

    // Si no existe, devolver 404; si existe, devolver 200 con el paciente
    return patient is null
        ? Results.NotFound(new { mensaje = "Paciente no encontrado" })
        : Results.Ok(patient);
});

// Arrancar la aplicacion
app.Run();

// Record posicional: los tipos deben coincidir exactamente con lo que devuelve la BD
// INTEGER de SQLite -> long en C# (nunca int)
// TEXT de SQLite -> string en C#
// Columnas nullable llevan ?
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

**Salida esperada al navegar a `http://localhost:5000/patients` (primeros 3 pacientes):**

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
    "height": 185,
    "weight": 76
  },
  {
    "patientId": 2,
    "firstName": "Mickey",
    "lastName": "Baasha",
    "gender": "M",
    "birthDate": "2017-11-19",
    "city": "Hamilton",
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
    "birthDate": "1990-05-15",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": "Sulfa",
    "height": 162,
    "weight": 55
  }
]
```

**Salida esperada al navegar a `http://localhost:5000/patients/1`:**

```json
{
  "patientId": 1,
  "firstName": "Donald",
  "lastName": "Waterfield",
  "gender": "M",
  "birthDate": "1963-02-12",
  "city": "Barrie",
  "provinceId": "ON",
  "allergies": "Penicillin",
  "height": 185,
  "weight": 76
}
```

**Salida esperada al navegar a `http://localhost:5000/patients/999`:**

```json
{
  "mensaje": "Paciente no encontrado"
}
```

### Práctica guiada: explorar hospital.db desde la terminal

Antes de seguir con más endpoints, vamos a abrir la base directamente desde la terminal para ver qué hay adentro. Esto nos ayuda a entender la estructura de las tablas antes de escribir consultas.

```bash
# Abrir la terminal en la carpeta del proyecto (donde está hospital.db)
# Si no estamos en la carpeta del proyecto, navegar hasta ella:
cd ruta/al/proyecto

# Abrir la base de datos con la herramienta sqlite3
sqlite3 hospital.db

# Dentro de sqlite3, listar las tablas disponibles:
.tables

# Ver la estructura de la tabla patients:
.schema patients

# Ejecutar un SELECT simple para ver los primeros registros:
SELECT patient_id, first_name, last_name, gender FROM patients LIMIT 5;

# Salir de sqlite3:
.quit
```

**Salida esperada de `.tables`:**

```
doctors          patients         province_names   admissions
```

**Salida esperada de `.schema patients`:**

```sql
CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    city TEXT,
    province_id TEXT NOT NULL,
    allergies TEXT,
    height INTEGER,
    weight INTEGER,
    FOREIGN KEY (province_id) REFERENCES province_names(province_id)
);
```

**Salida esperada del SELECT:**

```
1|Donald|Waterfield|M
2|Mickey|Baasha|M
3|Jiji|Sharma|F
4|Ramiro|Gonzalez|M
5|Valeria|Lopez|F
```

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- SQLite guarda toda la base en un solo archivo `.db`; no necesita servidor.
- La cadena de conexión `"Data Source=hospital.db"` apunta a ese archivo.
- Dapper traduce las filas del resultado a objetos C# usando `Query<T>` y `QueryFirstOrDefault<T>`.
- Las columnas INTEGER de SQLite se mapean a `long` en C# (nunca `int`).
- Siempre se usa alias `AS` en el SELECT para que los nombres de columna coincidan con los parámetros del record.
- La conexión se abre con `using var connection = new SqliteConnection(...)` y se cierra sola.

### Lo que viene

Encuentro 11: SQL: JOIN y ORDER BY — vamos a aprender a unir datos de dos tablas y a ordenar los resultados.

## 6. Actividad complementaria (80 min)

### Explorar hospital.db y practicar SELECTs

En esta actividad vas a trabajar en parejas con la terminal sqlite3 y con tu proyecto C#. El objetivo es familiarizarte con la base de datos antes de escribir consultas más complejas.

**Paso 1 — Explorar la base desde la terminal (20 min):**
1. Abrí `hospital.db` con `sqlite3` en la terminal.
2. Ejecutá `.tables` y `.schema` en cada tabla (`doctors`, `province_names`, `admissions`).
3. Ejecutá `SELECT * FROM doctors LIMIT 3;` y observá los datos.
4. Ejecutá `SELECT * FROM province_names;` y contá cuántas provincias hay.
5. Salí de sqlite3 con `.quit`.

**Paso 2 — Extender el endpoint `/patients` (30 min):**
1. Agregá un nuevo endpoint `GET /patients/count` que devuelva el total de pacientes usando `ExecuteScalar<long>`.
2. Agregá un endpoint `GET /patients/gender/{gender}` que filtre por género (`M` o `F`) usando un parámetro `@gender`.
3. Probalos desde el navegador o con `curl`.

**Paso 3 — Consulta libre (30 min):**
1. Elegí una tabla que te llame la atención (`doctors` o `province_names`).
2. Escribí un `SELECT` que devuelva todas las columnas de esa tabla.
3. Creá el record C# correspondiente y el endpoint `MapGet` asociado.
4. Probalo y verificá que la salida sea la esperada.

## 7. Errores comunes y trampas

| Error observable | Causa probable | Cómo intervenir |
| --- | --- | --- |
| `InvalidOperationException` al ejecutar el endpoint | El record usa `int` para `PatientId` pero SQLite devuelve `Int64` (long). | Cambiar `int PatientId` por `long PatientId` en el record. |
| La conexión no se cierra y agota el pool | Falta el `using` en la declaración de la conexión. | Siempre usar `using var connection = new SqliteConnection(...)`. |
| El endpoint devuelve una lista vacía | El archivo `hospital.db` no está en la carpeta correcta del proyecto. | Verificar que `hospital.db` esté junto al `.csproj` y que la cadena de conexión sea `"Data Source=hospital.db"`. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |
| Las columnas aparecen con nombres como `patient_id` en el JSON | Falta el alias `AS` en el SELECT. | Agregar `patient_id AS PatientId` para cada columna en el SELECT. |
| `null` aparece como cadena vacía en el JSON | La propiedad nullable no lleva `?` en la declaración del record. | Declarar como `string? City` o `long? Height` según el tipo. |
