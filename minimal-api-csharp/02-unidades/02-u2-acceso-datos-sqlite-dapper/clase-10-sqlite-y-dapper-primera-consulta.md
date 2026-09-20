# Encuentro 10 — SQLite y Dapper: conexión a hospital.db y primera consulta

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 10 de 36 |
| Unidad | Unidad didáctica 2: Acceso a datos con SQLite y Dapper (clase 1 de 4) |
| Momento | Clase regular de unidad |
| Eje temático | Nº 2 — Acceso a datos con Dapper |
| Carácter/Objetivo | Procedimental: conectar, consultar y verificar |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | SQLite como base en un archivo; cadena de conexión; paquetes `Microsoft.Data.Sqlite` y `Dapper`; `SqliteConnection` con `using`; `Query<T>` con mapeo a records; alias `AS` para columnas `snake_case` |
| Requisitos previos | Unidad 1 completa y evaluada (tp-u1, Encuentro 8); ciclo de entrega por GitHub conocido (carpeta, commits, push); VS Code + terminal con SDK de .NET 6; archivo `hospital.db` (lo distribuye el docente) |
| Uso de celular | No permitido |
| Registro | Didáctico: material de clase dirigido al estudiante (el anexo docente va en archivo separado) |
| Grupos | Alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar; rotación de integrantes en la práctica y el ejercicio |
| Planificación anual | Encuentro 10: devolución de la evaluación de la Unidad 1; SQLite `hospital.db` primera mirada; Dapper: conexión + primer SELECT mapeado a records (`long`/`string`) |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente: devolución de la evaluación U1 + puente | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (20 min).** El encuentro abre con la devolución de la evaluación de la Unidad 1: panorama general de resultados del curso, los errores más frecuentes y su corrección, y entrega de la corrección individual (la gestión detallada del bloque está en el anexo docente). Después, el puente hacia la unidad nueva con una pregunta disparadora: cuando el hospital cierra y la API se apaga, ¿dónde siguen los datos? En la Unidad 1 la lista de pacientes vivía en la memoria del programa y desaparecía con cada reinicio. Hoy los datos pasan a vivir en un archivo: `hospital.db`, la base real de un hospital canadiense, y la API la lee con Dapper.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar qué aporta SQLite frente a la lista en memoria de la Unidad 1: la base entera es un archivo que sobrevive al programa.
2. Copiar `hospital.db` al proyecto y agregar los paquetes `Microsoft.Data.Sqlite` y `Dapper` con `dotnet add package`.
3. Abrir una conexión con `SqliteConnection` y la cadena de conexión, usando `using` para que se cierre sola.
4. Ejecutar un primer `SELECT` con `Query<T>` mapeado a un record, alineando columnas y propiedades con alias `AS`.
5. Publicar un endpoint GET que devuelva los pacientes reales de `hospital.db` como JSON con `Results.Ok`.

## 3. Teoría mínima (40 min)

### Charla rápida: el empleado del archivo de historias clínicas

Todo hospital tiene un archivo físico de historias clínicas: estanterías, legajos numerados y planillas con formato uniforme. Nadie memoriza dónde está cada historia: pide "la historia número 47" y el empleado del archivo va, busca y entrega la planilla. El médico nunca toca la estantería.

Hoy la API contrata a ese empleado: **Dapper** recibe la orden SQL, la lleva a la base, y vuelve con las filas ya acomodadas dentro de los records de C#. El programa nunca toca el archivo `hospital.db` directamente: le pide al empleado.

### SQLite: la base entera en un archivo

**SQLite** es un motor de bases de datos que no necesita instalación ni servidor: el programa lo incorpora como una biblioteca y la base completa es **un solo archivo**. En este curso ese archivo es `hospital.db`: los datos reales de un hospital canadiense (pacientes, médicos e ingresos de un año de actividad). Copiar la base es copiar el archivo; respaldarla es respaldar el archivo.

Frente a la `List<T>` de la Unidad 1:

| | `List<T>` en memoria (U1) | `hospital.db` (desde hoy) |
| --- | --- | --- |
| Dónde vive | En la memoria del programa mientras corre | En un archivo del disco |
| Al apagar o reiniciar | Se pierde todo | Sigue ahí |
| Cómo se consulta | Con código C# | Con SQL, el idioma de las consultas |
| Cuántos datos | Los que el programa cargue | 258 pacientes, 27 médicos, 306 ingresos, 13 provincias |

### El viaje de un dato: del pedido HTTP a la fila de la base

Cuando el navegador pide `GET /patients`, dentro del handler pasan tres cosas:

1. **Conexión**: `new SqliteConnection("Data Source=hospital.db")` abre el camino hacia el archivo. Con `using var`, la conexión se cierra sola al terminar el handler, aunque haya un error.
2. **Consulta**: Dapper ejecuta el SQL del `SELECT` sobre esa conexión.
3. **Mapeo**: cada fila que devuelve la base se encaja en un record de C#, propiedad por propiedad, **por nombre**.

### El mapeo por nombre y el alias AS

Las columnas de la base están en `snake_case` (`patient_id`) y las propiedades C# en `PascalCase` (`PatientId`). Dapper encaja por nombre: la comparación ignora mayúsculas y minúsculas, **pero no perdona el guion bajo**. Por eso cada columna se renombra en el SELECT con un alias:

```sql
SELECT patient_id AS PatientId, first_name AS FirstName, ...
```

Sin los alias, el record llega con las propiedades vacías: el mapeo no encontró coincidencia.

### Los tipos canónicos que ya no se negocian

Desde hoy, para toda la unidad: los **ids son `long`** (SQLite entrega enteros como `long`; con `int` el mapeo falla con un 500) y las **fechas son `string`** en formato ISO `yyyy-MM-dd` (viajan como texto, tal como están guardadas). Lo que en la Unidad 1 era convención, hoy es la regla que evita los errores más caros de la unidad.

## 4. Práctica guiada (70 min)

### Paso 1 — Crear el proyecto de la unidad

Dentro de la carpeta del repositorio del grupo, crear la carpeta del proyecto de la unidad y el proyecto:

```powershell
mkdir u2-api
cd u2-api
dotnet new web
```

Abrir la carpeta en VS Code (`File → Open Folder`). El proyecto de la unidad es uno solo: en las próximas clases se le agregan endpoints al mismo `Program.cs`.

### Paso 2 — Copiar hospital.db junto al .csproj

Copiar el archivo `hospital.db` que entrega el docente dentro de `u2-api/`, al mismo nivel que el `.csproj`. La cadena de conexión `"Data Source=hospital.db"` busca el archivo **junto al proyecto**: si queda en otra carpeta, la conexión no encuentra las tablas.

```text
u2-api/
├── hospital.db     <- la base, junto al .csproj
├── Program.cs
└── minimal.csproj
```

### Paso 3 — Agregar los paquetes

En la terminal, parados en `u2-api/`, agregar los dos paquetes de la unidad:

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

`Microsoft.Data.Sqlite` sabe abrir el archivo; `Dapper` ejecuta el SQL y mapea las filas a records. El `.csproj` queda con las dos referencias: no se edita a mano.

### Paso 4 — Reemplazar Program.cs completo

Reemplazar todo el contenido de `Program.cs` por este archivo (última versión completa del encuentro):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients: devuelve TODOS los pacientes de la base (258 filas)
app.MapGet("/patients", () =>
{
    // using var: la conexion se abre y se cierra sola al salir del handler
    using var connection = new SqliteConnection(connectionString);

    // Primer SELECT con Dapper: cada columna snake_case lleva un alias AS
    // para coincidir con la propiedad PascalCase del record Patient.
    // Dapper encaja columna con propiedad por nombre (ignora mayusculas,
    // pero no perdona el guion bajo).
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
          FROM patients");

    // La lista completa viaja como JSON; Results.Ok responde 200
    return Results.Ok(patients);
});

app.Run();   // Deja la API escuchando pedidos hasta que se corta con Ctrl+C

// ---- Records: SIEMPRE al final del archivo (antes del final, el compilador
// ---- los rechaza con el error CS8803) ----

// Paciente: una fila de la tabla patients. Id SIEMPRE long, fecha SIEMPRE string
record Patient(
    long PatientId,      // id: SIEMPRE long (con int el mapeo falla con 500)
    string FirstName,
    string LastName,
    string Gender,       // "M" o "F"
    string BirthDate,    // fecha: SIEMPRE string ISO "yyyy-MM-dd" (nunca DateTime)
    string? City,        // nullable: la columna acepta NULL
    string ProvinceId,
    string? Allergies,   // nullable: muchos pacientes no tienen alergia registrada
    int? Height,         // altura en cm (medida, no id)
    int? Weight          // peso en kg (medida, no id)
);
```

### Paso 5 — Correr y probar en el navegador

```powershell
dotnet run
```

Leer en la terminal la línea `Now listening on: http://localhost:<puerto>` (el puerto lo asigna `dotnet run`; los ejemplos asumen `5080`: usar el propio). Abrir en el navegador:

```text
http://localhost:5080/patients
```

### Salida esperada (verificada)

La base de referencia del curso tiene **258 pacientes**, y la respuesta trae los 258 objetos en un arreglo JSON. La estructura de cada objeto es exactamente esta (los valores concretos de cada fila dependen de la copia de `hospital.db`; comparar la estructura):

```json
[
  {
    "patientId": 1,
    "firstName": "Susan",
    "lastName": "Zhang",
    "gender": "F",
    "birthDate": "1955-10-13",
    "city": "Toronto",
    "provinceId": "ON",
    "allergies": null,
    "height": 165,
    "weight": 68
  }
]
```

Verificaciones pautadas:

- Los nombres del JSON salen en *camelCase* (`patientId`, `firstName`): la serialización automática de la API, sin ninguna configuración.
- Los campos que en la base están vacíos aparecen como `null` (por ejemplo `allergies` en muchos pacientes): es el `NULL` de SQL convertido a JSON.
- `birthDate` es un texto ISO `yyyy-MM-dd`: la fecha viaja tal como está guardada.
- Si en lugar del JSON se recibe un error 500, mirar el error completo en la terminal donde corre `dotnet run`: casi siempre es un alias que no coincide con la propiedad del record.

### Paso 6 — Probar qué pasa sin los alias (experimento de 2 minutos)

En el SELECT, borrar un alias (dejar `patient_id` sin `AS PatientId`), guardar, y mirar de nuevo el navegador: esa propiedad del record llega vacía (`null` o `0`) porque el mapeo por nombre no encontró coincidencia. Restaurar el alias antes de seguir. Ese es, exactamente, el error que más se va a ver en la unidad.

## 5. Ejercicio independiente (50 min)

### Consigna

Sobre el mismo proyecto `u2-api`, agregar el endpoint `GET /doctors` que devuelva todos los médicos de la base con su especialidad, orden natural de la tabla (el orden llega en la próxima clase). Requisitos:

1. Declarar el record `Doctor` **al final** de `Program.cs`, con id `long`: `DoctorId`, `FirstName`, `LastName`, `Specialty`.
2. Escribir el SELECT con los cuatro alias (`doctor_id AS DoctorId`, etc.) y comentarios que expliquen cada decisión.
3. Devolver con `Results.Ok`. La base tiene **27 médicos**: la respuesta tiene que traer 27 objetos.
4. Al terminar, probar en el navegador y verificar la estructura del JSON.

### Pista

El endpoint es gemelo del `GET /patients` de la práctica: misma conexión, mismo `Query<T>`, mismo `Results.Ok`; cambian la tabla (`doctors`), los cuatro alias y el record. No inventes nada nuevo: copiá el patrón. La solución completa está en el anexo docente y se corrige en la puesta en común del bloque siguiente.

## 6. Extensión y consolidación (45 min)

Actividades explícitas del bloque, para quien terminó la consigna base (la solución de la extensión está en el anexo docente):

1. **Consolidación: explicación en voz alta.** Cada integrante del grupo explica, señalando el código, una pieza: (a) qué hace `using var connection`, (b) por qué los alias `AS` son obligatorios, (c) por qué el id es `long` y la fecha `string`, (d) por qué el record va después de `app.Run()`. Rotar hasta cubrir las cuatro.
2. **Extensión: `GET /admissions`.** Agregar el endpoint que devuelva los ingresos de la tabla `admissions` con el record canónico `Admission`: `Admission(long PatientId, string AdmissionDate, string? DischargeDate, string? Diagnosis, long AttendingDoctorId)`. Observar en la salida que `dischargeDate` es `null` en los ingresos sin fecha de alta (pacientes aún internados) y que hay pacientes repetidos con ingresos distintos: son datos reales.
3. **Conteo comparado.** Probar los tres endpoints y anotar cuántas filas trae cada uno (27 / 258 / 306). Esa escala explica por qué en la próxima clase van a importar el `WHERE` y el `LIMIT`.
4. **Commit de avance.** Con el endpoint del ejercicio funcionando, `git add .`, `git commit -m "Clase 10: conexion a hospital.db y primer select con Dapper"` y `git push` (la rutina del Encuentro 5; el ciclo completo de entrega se aprendió en el Encuentro 8).

## 7. Cierre (15 min)

### Qué te llevás

- SQLite resuelve la persistencia: la base entera es un archivo (`hospital.db`) que sobrevive al programa, a diferencia de la `List<T>` en memoria de la Unidad 1.
- Dapper es el mensajero: recibe el SQL, lo ejecuta sobre la conexión y devuelve las filas ya mapeadas a records.
- El mapeo es **por nombre**: cada columna `snake_case` necesita su alias `AS` para encajar en la propiedad `PascalCase` del record.
- Tipos que no se negocian: ids `long`, fechas `string` ISO. Con `int` en el id, el mapeo falla con 500.
- `using var connection` abre y cierra la conexión dentro del handler, y `Results.Ok` entrega la lista como JSON en camelCase.

### Lo que viene

- Encuentro 11: consultas parametrizadas: WHERE, ORDER BY, parámetros de ruta y query string sobre la base. Hoy la API trajo los 258 pacientes siempre completos; la próxima clase empieza a pedirle a la base exactamente lo que se necesita: uno por id, ordenado, y recortado por `?limit=`.

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 10: conexion a hospital.db y primer select con Dapper"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| 500 al pedir `/patients` | Id declarado `int` en el record: SQLite entrega enteros como `long` y el mapeo falla | Declarar `long PatientId` (y `long` en todo id); el error completo está en la terminal de `dotnet run` |
| Propiedad del record llega vacía (`null` o `0`) | Falta el alias `AS` en el SELECT: `patient_id` no coincide con `PatientId` por el guion bajo | Alias en cada columna `snake_case`; recordar el experimento del Paso 6 |
| `no such table: patients` en la terminal | `hospital.db` no está junto al `.csproj` (quedó en otra carpeta) | Mover el archivo a la raíz del proyecto, junto al `.csproj`, y reintentar |
| Error CS8803 al compilar | Record declarado antes de `app.Run()` o entre instrucciones | Los records van SIEMPRE al final del archivo, después de `app.Run()` |
| El paquete no se encuentra (`Dapper` no existe como clase) | `dotnet add package` se corrió fuera de la carpeta del proyecto | Correr los dos `dotnet add package` parado en `u2-api/`, donde está el `.csproj` |
| Conectar y conectar de nuevo a mano | Abrir la conexión sin `using` y olvidar cerrarla | `using var connection = new SqliteConnection(connectionString);`: se cierra sola al salir del handler |
