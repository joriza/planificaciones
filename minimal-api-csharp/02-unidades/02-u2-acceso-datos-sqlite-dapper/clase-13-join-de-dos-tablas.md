# Encuentro 13 — JOIN de dos tablas y records compuestos

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 13 de 36 |
| Unidad | Unidad didáctica 2: Acceso a datos con SQLite y Dapper (clase 4 de 4) |
| Momento | Clase regular de unidad |
| Eje temático | Nº 2 — Acceso a datos con Dapper |
| Carácter/Objetivo | Procedimental: cruzar dos tablas en una consulta |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | `JOIN ... ON` para cruzar dos tablas por su clave; alias de tabla (`p`, `pn`, `a`, `d`); record compuesto que mezcla columnas de dos tablas; concatenación de textos en SQL para nombres completos |
| Requisitos previos | Clases 10 a 12 completas: SELECT con alias `AS`, consultas parametrizadas, `LIKE` y validación 400/404; conocer las cuatro tablas de `hospital.db` y sus claves |
| Uso de celular | No permitido |
| Registro | Didáctico: material de clase dirigido al estudiante (el anexo docente va en archivo separado) |
| Grupos | Alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar; rotación de integrantes en la práctica y el ejercicio |
| Planificación anual | Encuentro 13: JOIN de dos tablas (`patients`+`province_names`, `admissions`+`doctors`), records compuestos |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (20 min).** Los endpoints de hoy responden dos preguntas que la API todavía no sabe responder: ¿cómo se **llama** la provincia del paciente (no su código `ON`)? y ¿cómo se llama el **médico** de cada ingreso (no solo su id)? El dato está en la base, pero repartido en dos tablas conectadas por una clave. Pregunta disparadora: si el dato está en dos planillas distintas, ¿quién las cruza, el código C# o la base? Hoy se aprende a pedirle el cruce a la base con `JOIN`, que lo hace en su terreno y a su velocidad.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar qué tablas cruza un `JOIN` y por qué columna se emparejan (`ON p.province_id = pn.province_id`).
2. Escribir un SELECT con alias de tabla (`p`, `pn`) para desambiguar columnas de las dos tablas.
3. Declarar un record compuesto que combine columnas de las dos tablas y mapearlo con alias `AS`.
4. Concatenar nombre y apellido en SQL con `||` para construir `DoctorName`.
5. Publicar dos endpoints con JOIN (`/patients/with-province`, `/admissions/with-doctor`), conservando la validación y el 404 con mensaje de la clase 12.

## 3. Teoría mínima (40 min)

### Charla rápida: las dos planillas del área de Personal

El hospital tiene la planilla de pacientes y, aparte, la planilla de provincias con el nombre completo de cada código. En papel, para armar "paciente con su provincia", el empleado apoya una planilla al lado de la otra y va emparejando filas: donde el código coincide, copia el nombre. El cruce no inventa nada: **empareja por la clave que comparten**.

`JOIN` es esa orden: `FROM patients p JOIN province_names pn ON p.province_id = pn.province_id` pega cada paciente con la fila de su provincia, y la consulta resultante tiene las columnas de las dos.

### Anatomía del JOIN

```sql
FROM patients p                                  -- la tabla principal, con alias p
JOIN province_names pn                           -- la tabla que aporta datos, con alias pn
     ON p.province_id = pn.province_id           -- la regla de emparejamiento
```

- **Alias de tabla** (`p`, `pn`): nombres cortos para no escribir `patients.` y `province_names.` en cada columna. Con dos columnas `province_id` en juego (una por tabla), el alias dice de dónde sale cada una: `p.province_id` es la del paciente.
- **`ON`**: la condición de emparejamiento. Si falla (columna mal escrita), el JOIN no rompe: devuelve cruces absurdos o vacíos. Por eso se lee despacio.
- **Sin alias, ambigüedad**: `province_id` a secas ya no alcanza porque existe en las dos tablas; la base lo rechaza con un error de "columna ambigua".

### El record compuesto: el resultado del cruce

El cruce produce filas nuevas, con columnas de las dos tablas. Necesitan un record a medida, **compuesto**: `PatientWithProvince` tiene los datos del paciente más `ProvinceName` (que vive en `province_names`). El mapeo no cambia: cada columna del SELECT lleva su alias `AS` y Dapper encaja por nombre, exactamente igual que desde la clase 10.

### Concatenar textos en SQL con ||

Para mostrar "Hazel Patterson" en vez de dos columnas separadas, SQL concatena con `||`:

```sql
d.first_name || ' ' || d.last_name AS DoctorName
```

El nombre, un espacio, el apellido: una sola columna `DoctorName` para el record. Es el único lugar del curso donde se escribe texto adentro del SELECT, y es texto fijo (un espacio), no dato del cliente: no se parametriza porque no hay nada que parametrizar.

### Los dos cruces de hoy

| Consulta | Tabla principal | Tabla que aporta | Clave del cruce |
| --- | --- | --- | --- |
| Paciente con su provincia | `patients` (p) | `province_names` (pn) | `p.province_id = pn.province_id` |
| Ingreso con su médico | `admissions` (a) | `doctors` (d) | `a.attending_doctor_id = d.doctor_id` |

El esquema de la base es la guía: cada tabla de movimiento (`patients`, `admissions`) guarda el id de su tabla de referencia, y ese id es la columna del `ON`.

## 4. Práctica guiada (70 min)

### Paso 1 — Partir del proyecto de la unidad

Abrir `u2-api/` (clases 10 a 12). El archivo de hoy mantiene la base común (`GET /patients`, `GET /patients/{id:long}`) y agrega los dos endpoints con JOIN. Los endpoints de búsqueda de la clase 12 pueden seguir en tu archivo: el listado de referencia muestra la base común más lo nuevo, para no alargarlo.

### Paso 2 — Reemplazar Program.cs completo

Reemplazar todo el contenido de `Program.cs` por este archivo (última versión completa del encuentro):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients: todos los pacientes, ordenados por apellido y nombre
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          ORDER BY last_name, first_name");

    return Results.Ok(patients);
});

// GET /patients/{id}: UN paciente segun su id (404 con mensaje)
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.QueryFirstOrDefault<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE patient_id = @id",
        new { id });

    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente con ese id" });
    }

    return Results.Ok(patient);
});

// GET /patients/with-province
// JOIN de dos tablas: patients (p) + province_names (pn).
// Cada paciente sale con el NOMBRE de su provincia, no solo el codigo
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // Alias de tabla: p = patients, pn = province_names.
    // ON es la regla de emparejamiento: el codigo de la fila del paciente
    // tiene que ser igual al codigo de la fila de la provincia
    var patients = connection.Query<PatientWithProvince>(
        @"SELECT p.patient_id  AS PatientId,
                 p.first_name  AS FirstName,
                 p.last_name   AS LastName,
                 p.gender      AS Gender,
                 p.birth_date  AS BirthDate,
                 p.city        AS City,
                 pn.province_name AS ProvinceName,
                 p.allergies   AS Allergies,
                 p.height      AS Height,
                 p.weight      AS Weight
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          ORDER BY p.last_name, p.first_name");

    return Results.Ok(patients);
});

// GET /admissions/with-doctor?limit=10
// JOIN de dos tablas: admissions (a) + doctors (d).
// Cada ingreso sale con el nombre y la especialidad del medico tratante
app.MapGet("/admissions/with-doctor", (string? limit) =>
{
    // Validacion heredada de la clase 12: si viene ?limit= tiene que
    // ser numero entero (long, el entero de SQLite); si no viene, 20
    long max = 20;
    if (limit is not null && !long.TryParse(limit, out max))
    {
        return Results.BadRequest(new { mensaje = "El limite debe ser un numero entero" });
    }

    using var connection = new SqliteConnection(connectionString);

    // || concatena textos en SQL: nombre, espacio, apellido.
    // DoctorName es una sola columna nueva para el record compuesto
    var admissions = connection.Query<AdmissionWithDoctor>(
        @"SELECT a.patient_id          AS PatientId,
                 a.admission_date      AS AdmissionDate,
                 a.discharge_date      AS DischargeDate,
                 a.diagnosis           AS Diagnosis,
                 d.first_name || ' ' || d.last_name AS DoctorName,
                 d.specialty           AS DoctorSpecialty
          FROM admissions a
          JOIN doctors d ON a.attending_doctor_id = d.doctor_id
          ORDER BY a.admission_date DESC
          LIMIT @max",
        new { max });

    return Results.Ok(admissions);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Paciente: una fila de la tabla patients (sin cambios desde la clase 10)
record Patient(
    long PatientId,      // id: SIEMPRE long (nunca int)
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd" (nunca DateTime)
    string? City,
    string ProvinceId,
    string? Allergies,
    int? Height,
    int? Weight
);

// Record COMPUESTO: columnas de patients + ProvinceName de province_names
record PatientWithProvince(
    long PatientId,      // id: SIEMPRE long
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? City,
    string ProvinceName, // NUEVO: vive en province_names, llega por el JOIN
    string? Allergies,
    int? Height,
    int? Weight
);

// Record COMPUESTO: columnas de admissions + nombre y especialidad de doctors
record AdmissionWithDoctor(
    long PatientId,      // id del paciente internado: SIEMPRE long
    string AdmissionDate,     // fecha: SIEMPRE string ISO "yyyy-MM-dd"
    string? DischargeDate,    // nullable: sin alta = aun internado
    string? Diagnosis,
    string DoctorName,        // construido con || en el SELECT
    string DoctorSpecialty
);
```

### Paso 3 — Probar los dos JOIN en el navegador

| Pedido | Qué esperar |
| --- | --- |
| `/patients/with-province` | Los 258 pacientes, cada uno con `provinceName` completo (`"Ontario"`, no `"ON"`) |
| `/admissions/with-doctor` | Hasta 20 ingresos (límite por defecto) con `doctorName` y `doctorSpecialty` |
| `/admissions/with-doctor?limit=5` | 5 ingresos, los más recientes primero (`ORDER BY ... DESC`) |
| `/admissions/with-doctor?limit=hola` | 400 con mensaje: la validación de la clase 12 sigue en pie |

Observaciones pautadas:

- En `/patients/with-province` ya no está `provinceId`: el record compuesto lo reemplazó por `provinceName`. El record define qué sale en el JSON.
- El orden del JSON en `provinceName` es camelCase (`provinceName`, `doctorName`): la serialización automática no cambia con los JOIN.
- Los ingresos salen del más nuevo al más viejo (`DESC`): el rango de la base es junio 2018 – junio 2019.

### Salida esperada (verificada)

`GET /admissions/with-doctor?limit=1` devuelve un arreglo con 1 objeto con esta estructura exacta (los valores de fila dependen de la copia de la base; la forma es estable):

```json
[
  {
    "patientId": 178,
    "admissionDate": "2019-06-02",
    "dischargeDate": null,
    "diagnosis": "Pneumonia",
    "doctorName": "Hazel Patterson",
    "doctorSpecialty": "Oncologist"
  }
]
```

Verificaciones pautadas: `dischargeDate` `null` en los ingresos aún abiertos; `doctorName` con nombre y apellido en un solo campo; `patientId` es el id del paciente internado (cruzable con `/patients/{id}`).

## 5. Ejercicio independiente (50 min)

### Consigna

Sobre el mismo proyecto `u2-api`:

1. Agregar `GET /provinces`: las 13 provincias y territorios de la tabla `province_names`, con el record `Province(string ProvinceId, string ProvinceName)`, ordenadas por nombre. Es la tabla de referencia más chica de la base: el endpoint sirve para que el cliente elija un código válido.
2. Agregar `GET /admissions/by-doctor/{id:long}`: los ingresos atendidos por UN médico, con el record compuesto `AdmissionWithDoctor` (nombre del médico incluido vía JOIN), ordenados por fecha descendente. Si el médico no tiene ingresos, responder 404 con mensaje. No hace falta validar si el médico existe: sin ingresos o inexistente, la respuesta es la misma (404 con mensaje).

Requisitos: alias de tabla en ambos JOIN, `ON` comentado, records compuestos al final del archivo, y prueba en el navegador de un médico con ingresos y de uno sin ellos (o con un id inexistente como `9999`).

### Pista

El ítem 2 es el `/admissions/with-doctor` de la práctica + un `WHERE a.doctor...` cuidado: el filtro es por la columna del JOIN (`a.attending_doctor_id = @id`), parametrizado con `new { id }`. Para el 404, la herramienta es la de la clase 12 (`Count() == 0` → `Results.NotFound(new { mensaje = ... })`). La solución completa está en el anexo docente y se corrige en la puesta en común del bloque siguiente.

## 6. Extensión y consolidación (45 min)

Actividades explícitas del bloque (la solución de la extensión está en el anexo docente):

1. **Consolidación: el dibujo del cruce.** En papel, cada grupo dibuja las dos tablas del ejercicio (`admissions` y `doctors`) con sus columnas, marca la clave del cruce y explica en voz alta qué fila se pega con cuál. Rotación: cada integrante explica un JOIN distinto del archivo (el de pacientes y el de ingresos).
2. **Extensión: JOIN con filtro por provincia.** Agregar `?province=ON` a `/patients/with-province`: el `WHERE` filtra por `p.province_id` (validación y `LIKE` opcional a criterio del grupo; con igualdad exacta alcanza). Ontario concentra la mayoría de la base: el filtro se nota.
3. **Extensión: buscar ingresos por diagnóstico con JOIN.** Sobre `/admissions/with-doctor`, agregar `?diagnosis=pain` (parcial, con `LIKE` y validación de la clase 12). Combinado con `?limit=`, es el primer reporte real de la API: ingresos recientes con diagnóstico que contiene "pain", con nombre del médico.
4. **Commit de avance.** `git add .`, `git commit -m "Clase 13: join de dos tablas y records compuestos"` y `git push`.

## 7. Cierre (15 min)

### Qué te llevás

- `JOIN ... ON` cruza dos tablas emparejando su clave compartida: el cruce lo hace la base, adentro del SELECT.
- Los alias de tabla (`p`, `pn`, `a`, `d`) evitan la ambigüedad cuando las dos tablas tienen columnas con el mismo nombre.
- El resultado de un cruce necesita un record compuesto a medida (`PatientWithProvince`, `AdmissionWithDoctor`): el mapeo por alias `AS` funciona igual que siempre.
- `d.first_name || ' ' || d.last_name` construye el nombre completo en SQL y lo entrega como una columna más.
- Todo lo aprendido sigue valiendo con JOIN: parametrización, `ORDER BY`, `LIMIT`, validación 400 y 404 con mensaje.

### Lo que viene

- Encuentro 14: escritura con Dapper (INSERT/UPDATE/DELETE parametrizados, 201/400/404); consolidación; cierre U2 y entrega del tp-u2. Hasta hoy la API solo leyó la base; la próxima clase escribe sobre ella (altas, cambios y bajas de médicos), consolida toda la unidad y cierra con la entrega del tp-u2 por GitHub.

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 13: join de dos tablas y records compuestos"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| "ambiguous column name: province_id" | La columna existe en las dos tablas y el SELECT no dice de cuál | Calificar toda columna compartida con el alias: `p.province_id`, `pn.province_id` |
| JOIN con resultado vacío sin explicación | `ON` mal escrito (columnas invertidas o nombres errados): el emparejamiento no encuentra nada | Leer el `ON` en voz alta con el esquema al lado: `a.attending_doctor_id = d.doctor_id`; revisar singular/plural y guiones bajos |
| Propiedades del record compuesto en `null` o `0` | Alias `AS` del SELECT que no coincide con la propiedad nueva del record | El mapeo es por nombre y no cambia con JOIN: cada columna nueva lleva su alias exacto |
| `DoctorName` sale cortado o pegado | Olvidar el espacio al concatenar nombre y apellido en el SELECT | El espacio va como texto entre las dos concatenaciones de `DoctorName`; comparar con la versión del anexo docente |
| Filtrar con `WHERE doctor_id = @id` en el JOIN de ingresos | `doctor_id` es de `doctors`; sin alias, la columna es ambigua o no existe en `admissions` | Usar la columna de la tabla principal con su alias: `WHERE a.attending_doctor_id = @id` |
| Reemplazar `provinceId` por `provinceName` en el record `Patient` | Modificar el record viejo en vez de crear el compuesto | El record `Patient` queda intacto; el cruce usa su propio record (`PatientWithProvince`) |
