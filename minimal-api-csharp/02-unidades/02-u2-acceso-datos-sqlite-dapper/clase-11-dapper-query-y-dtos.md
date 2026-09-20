# Encuentro 11 — Dapper: Query&lt;T&gt; y primeros endpoints con datos reales

> Unidad 2 — Acceso a datos: SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 11 |
| Unidad | 2 — Acceso a datos: SQLite y Dapper |
| Carácter | Procedimental: construir, ejecutar y verificar |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Conexión con Microsoft.Data.Sqlite, consultas con Dapper (`Query<T>`), records como DTOs, mapeo de columnas con alias AS |
| Requisitos previos | Clase 10 completa (estructura de `hospital.db` explorada; base disponible); U1: endpoints `MapGet`, records, `Results.Ok` |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 11: «Dapper: Query&lt;T&gt; / SELECT con mapeo a records» · «Conexión a la base / Alias AS y DTOs» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (30 min).** En el Encuentro 10 la base `hospital.db` se miró con DB Browser: cuatro tablas, cientos de filas, datos reales. Hoy esos mismos datos salen por HTTP. Pregunta disparadora: ¿qué tiene que pasar entre un pedido GET del navegador y el archivo `hospital.db` para que la respuesta sea un JSON con datos reales? La respuesta de hoy tiene tres piezas: una conexión hacia el archivo, un traductor que ejecuta el SQL y unos records que reciben cada fila.

Al finalizar el encuentro, cada estudiante puede:

1. Agregar los paquetes Microsoft.Data.Sqlite y Dapper a un proyecto Minimal API con `dotnet add package`.
2. Abrir una conexión a una base SQLite con la cadena de conexión y `SqliteConnection`.
3. Explicar el mapeo por nombre que hace `Query<T>`: cada columna del SELECT encaja en la propiedad del record que lleva su mismo nombre.
4. Declarar records como DTOs al final de `Program.cs` y alinear columnas y propiedades con alias AS.
5. Publicar endpoints GET que devuelvan datos reales de `hospital.db` en JSON (200) y diagnosticar un 500 de mapeo leyendo el error en la terminal.

## 3. Teoría mínima (45 min)

### Charla rápida: la ventanilla del archivo

En un hospital, la recepción no baja al sótano a buscar las historias clínicas: pide en la ventanilla del archivo, y un empleado busca en las planillas y sube las fichas, ordenadas y legibles. La API es la recepción; la conexión es la puerta entre recepción y archivo; **Dapper** es el empleado de archivo: recibe el pedido en SQL, lo ejecuta contra la base y devuelve cada fila convertida en una ficha con formato uniforme. Esa ficha es un **record**.

### Las tres piezas de hoy

| Pieza | Qué es | Qué hace |
| --- | --- | --- |
| `Microsoft.Data.Sqlite` | Paquete NuGet de conexión | Abre y cierra la puerta hacia el archivo `.db` |
| `Dapper` | Paquete NuGet de acceso a datos | Ejecuta el SQL y convierte cada fila en un objeto C# |
| Records (DTOs) | Tipos declarados en `Program.cs` | La ficha destino: definen qué columnas interesan y de qué tipo |

DTO significa *Data Transfer Object*: un objeto cuya única tarea es transportar datos, sin lógica. Los records de la Unidad 1 ya lo eran; hoy se usan para recibir datos de la base.

### El recorrido del dato, en cuatro pasos

1. Entra el pedido GET al endpoint.
2. Se abre la conexión hacia el archivo: `new SqliteConnection("Data Source=hospital.db")`.
3. `Query<Province>(sql)` envía el SELECT y, por cada fila que vuelve, crea un record encajando los valores **por nombre**: la columna `ProvinceId` va a la propiedad `ProvinceId`.
4. `.ToList()` arma la lista y `Results.Ok(...)` la devuelve en JSON con código 200.

### El mapeo por nombre y el alias AS

Las columnas de la base están escritas en minúscula con guión bajo (`province_id`) y las propiedades C# van en PascalCase (`ProvinceId`). Dapper encaja por nombre, pero el guión bajo rompe la coincidencia. La solución es el alias `AS` de SQL: renombrar cada columna **en el resultado** para que coincida con la propiedad.

| En la tabla | Con alias AS | En el record |
| --- | --- | --- |
| `province_id` | `SELECT province_id AS ProvinceId` | `ProvinceId` |
| `province_name` | `SELECT province_name AS ProvinceName` | `ProvinceName` |

La comparación ignora mayúsculas y minúsculas (`provinceid` también encaja con `ProvinceId`), pero el guión bajo no perdona: `province_id` no encaja con `ProvinceId`. Regla del curso: cada columna que no coincida exactamente con su propiedad lleva su `AS`.

### Dos detalles que evitan errores

- **Los enteros viajan como `long`.** SQLite entrega todo número entero como `long` (entero largo). Los ids de las tablas se declaran `long` en los records: si se declara `int`, el mapeo falla con un 500. Los textos son `string` y las fechas, en esta etapa, también `string` (SQLite las guarda como texto `AAAA-MM-DD`).
- **El SQL va en un texto con `@"..."`.** El símbolo `@` antes de las comillas permite escribir el SELECT en varias líneas, y `ORDER BY` ordena el resultado. La conexión se declara con `using`: se cierra sola al terminar el handler.

## 4. Práctica guiada (90 min)

### Paso 1 — Crear el proyecto y agregar los paquetes

```powershell
dotnet new web -n HospitalApi
cd HospitalApi
code .
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

El último comando descarga cada paquete y lo registra en `HospitalApi.csproj` (aparecen como `PackageReference`).

### Paso 2 — Copiar la base al proyecto

Copiar `hospital.db` (el del Encuentro 10) a la raíz del proyecto, junto al archivo `HospitalApi.csproj`:

```text
HospitalApi
├── HospitalApi.csproj
├── hospital.db      ← junto al .csproj
└── Program.cs
```

La cadena de conexión del próximo paso busca el archivo ahí. Verificar con `dir` que quedó copiado antes de continuar.

### Paso 3 — Reemplazar Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este código completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion: dice donde esta el archivo de la base.
// "Data Source=hospital.db" = el archivo hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /provincias: las 13 provincias y territorios de la base
app.MapGet("/provincias", () =>
{
    // using: la conexion se cierra sola al salir del bloque
    using var connection = new SqliteConnection(connectionString);

    // Query<Province> ejecuta el SELECT y encaja cada fila
    // en un record Province, columna por propiedad, por nombre
    var provincias = connection.Query<Province>(
        @"SELECT province_id AS ProvinceId,
                 province_name AS ProvinceName
          FROM province_names
          ORDER BY province_name").ToList();

    return Results.Ok(provincias);
});

// GET /medicos: los 27 medicos ordenados por apellido
app.MapGet("/medicos", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var medicos = connection.Query<Doctor>(
        @"SELECT doctor_id AS DoctorId,
                 first_name AS FirstName,
                 last_name AS LastName,
                 specialty AS Specialty
          FROM doctors
          ORDER BY last_name, first_name").ToList();

    return Results.Ok(medicos);
});

app.Run();

// ---- Records DTO: la ficha donde Dapper encaja cada fila ----
// Van al final del archivo, despues de las instrucciones del programa.
// Los ids van con long: SQLite entrega los enteros como long.
record Province(string ProvinceId, string ProvinceName);
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

### Paso 4 — Levantar la API

```powershell
dotnet run
```

Anotar el puerto de la línea `Now listening on:` (en los ejemplos de abajo se usa `http://localhost:5080`; reemplazar por el puerto propio).

### Paso 5 — Probar los dos endpoints

- `http://localhost:5080/provincias`
- `http://localhost:5080/medicos`

### Salidas esperadas

**GET /provincias** → 200, un arreglo JSON con 13 elementos:

```json
[
  {"provinceId":"AB","provinceName":"Alberta"},
  {"provinceId":"BC","provinceName":"British Columbia"},
  {"provinceId":"MB","provinceName":"Manitoba"},
  ...
]
```

**GET /medicos** → 200, un arreglo JSON con 27 elementos (ordenados por apellido):

```json
[
  {"doctorId":23,"firstName":"Heather","lastName":"Beck","specialty":"Pediatrician"},
  {"doctorId":15,"firstName":"Marie","lastName":"Brinkman","specialty":"Urologist"},
  {"doctorId":11,"firstName":"Douglas","lastName":"Brooks","specialty":"Respirologist"},
  ...
]
```

Observaciones: las claves viajan en camelCase (convención ya vista en la clase 6) y los datos son los reales de `hospital.db`: los mismos que el Encuentro 10 mostró en DB Browser, ahora servidos por la API.

### Paso 6 — Experimento: qué pasa sin los alias

1. Detener la API (Ctrl+C).
2. En `/provincias`, borrar los dos alias: dejar `SELECT province_id, province_name FROM province_names`.
3. Ejecutar de nuevo (`dotnet run`) y recargar `/provincias`.

Resultado: **500** en el navegador y, en la terminal, un error largo que incluye el texto `... is required for Province materialization`. Ese error significa que Dapper no encontró dónde encajar las columnas: buscó las propiedades `province_id` y `province_name` y el record se llama `ProvinceId` y `ProvinceName`. El encaje es por nombre; el `AS` lo hace posible.

4. Restaurar los alias, volver a ejecutar y verificar que `/provincias` responde 200 de nuevo.

## 5. Ejercicio independiente (55 min)

### Consigna

Agregar al proyecto un endpoint `GET /especialidades` que devuelva el listado de especialidades médicas **sin repetir** y ordenado alfabéticamente, a partir de la columna `specialty` de la tabla `doctors`.

Requisitos:

- Un record propio de una sola propiedad (`Name`), declarado junto a los demás.
- Un solo elemento por especialidad (pista: la palabra clave de SQL es `DISTINCT` y va después del `SELECT`).
- `ORDER BY Name` para el orden alfabético.
- Respuesta 200 con el arreglo en JSON.

### Pista

Copiar la estructura de `/provincias` (es el endpoint más parecido: tabla chica, una o dos columnas, sin filtros) y cambiar tres cosas: el SQL, el record y la ruta. La solución completa está en el anexo docente y se corrige en la puesta en común.

## 6. Cierre (20 min)

### Qué te llevás

- `dotnet add package` incorpora bibliotecas al proyecto; `using` en el tope de `Program.cs` habilita sus tipos.
- La conexión es la puerta hacia el archivo: `"Data Source=hospital.db"` busca el `.db` junto al `.csproj`, y `using` la cierra sola al salir del handler.
- `Query<T>` ejecuta el SELECT y arma un record por fila, encajando **por nombre** de columna a propiedad.
- El alias `AS` renombra columnas para que el encaje sea posible; sin alias, `province_id` nunca va a encajar en `ProvinceId`.
- Los enteros de SQLite viajan como `long`; los ids de los records se declaran `long`.
- Un 500 significa que el handler falló: el diagnóstico empieza en la terminal del servidor, no en el navegador.

### Lo que viene

- Encuentro 12: filtros con `WHERE` y parámetros (objetos anónimos) y el operador `LIKE`. La API deja de devolver tablas completas: pasa a responder preguntas concretas, con valores que llegan desde la URL.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con los dos endpoints funcionando y el ejercicio terminado:

```powershell
git add .
git commit -m "Clase 11: la API lee hospital.db con Dapper"
git push
```

## 7. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| `The type or namespace name 'Dapper' could not be found` | Faltan los paquetes o los `using` del tope | Ejecutar los dos `dotnet add package` y verificar que `using Dapper;` y `using Microsoft.Data.Sqlite;` estén en la primera línea del archivo |
| 500 con `no such table: patients` (o cualquier tabla) | `hospital.db` no está junto al `.csproj`: Microsoft.Data.Sqlite no avisa que falta, **crea un archivo vacío** y la primera consulta falla | Copiar el `.db` a la raíz del proyecto; borrar el `.db` vacío que quedó creado por error; ejecutar `dotnet run` desde la carpeta del proyecto |
| 500 con `... one matching signature (System.Int64 ...) is required` | Un id declarado `int` en el record | SQLite entrega los enteros como `Int64`: los ids van como `long` en el record |
| 500 con `... is required for Province materialization` | Faltan alias: las columnas (`province_id`) no coinciden con las propiedades (`ProvinceId`) | Agregar el `AS` en cada columna cuyo nombre no coincida con la propiedad, y reiniciar la API |
| Error de compilación `CS1010: Nueva línea en constante` | Escribir el SQL en varias líneas dentro de comillas comunes | El SQL multilínea va entre `@"` y `"` (texto verbatim), como en los ejemplos |
| Buscar el problema en el navegador ante un 500 | Confundir códigos: 404 es "no existe", 500 es "el servidor falló" | Ante un 500, leer el error de la terminal donde corre `dotnet run`: ahí está la causa real (conexión o mapeo) |
