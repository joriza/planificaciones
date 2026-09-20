# Evaluación del momento especial 34-35 — Versión B

> Dominio de esta versión: pacientes agrupados por provincia (tablas `patients` + `province_names` de `hospital.db`). Duración: 90 minutos de resolución (Parte 1, 45 min · Parte 2, 35 min · cierre, 10 min). Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. El criterio Apto / No apto aún por objetivo mínimo está en `evaluacion-especiales-34-35.md`.

## Antes de empezar

- La Parte 1 se resuelve en un proyecto nuevo creado con `dotnet new web`: reemplazás el `Program.cs` por el esqueleto provisto, copiás `hospital.db` junto al `.csproj` y agregás los paquetes `Microsoft.Data.Sqlite` y `Dapper`.
- La Parte 2 se resuelve sobre el repositorio del grupo en GitHub: creás tu issue, tu rama y tu pull request propios; `main` está protegida y el pull request **no se fusiona**.
- Convenciones del curso: rutas en inglés y plural, ids `long`, respuestas siempre con `Results`, consultas siempre parametrizadas, alias `AS` en cada columna, records al final del archivo, comentarios en español sin tildes.
- Al terminar, dejás el `Program.cs` de la Parte 1 guardado en la carpeta indicada y avisás al docente.

## Material provisto 1 — Esqueleto de `Program.cs` (Parte 1)

```csharp
// Program.cs - Evaluacion del momento especial 34-35 - Version B
// Parte 1: estadistica de pacientes de una provincia (GROUP BY sobre hospital.db)
// Parte 2: sobre el repositorio del grupo (issue + rama + PR), no en este archivo

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// ===== Parte 1: completar a partir de aqui =====
// GET /stats/provinces/{provinceId}
//   -> 200 con UNA fila: nombre de la provincia, cantidad de pacientes
//      y altura promedio de esos pacientes (redondeada a 1 decimal)
//   -> 404 con mensaje en espanol si el codigo de provincia no existe

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos por la prueba, SIEMPRE al final del archivo ----
record ProvinceStats(string ProvinceName, int Patients, double AvgHeight);
```

## Material provisto 2 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT) · `last_name` (TEXT) · `gender` (TEXT) · `birth_date` (TEXT ISO) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, referencia a `province_names.province_id`) · `allergies` (TEXT, puede ser NULL) · `height` (INTEGER, puede ser NULL) · `weight` (INTEGER, puede ser NULL) |
| `province_names` | `province_id` (TEXT, clave, código de 2 letras) · `province_name` (TEXT, nombre completo) |

## Parte 1 — Endpoint de estadística con GROUP BY (45 minutos)

| Ítem | Consigna |
| --- | --- |
| único | Endpoint `GET /stats/provinces/{provinceId}`: devuelve `200` con una sola fila, con el nombre completo de la provincia, la cantidad de pacientes (`COUNT`, en `int`) y la altura promedio de esos pacientes (`AVG` con `ROUND` a 1 decimal, en `double`). Si el código de provincia no existe en `province_names`, responde `404` con un mensaje en español. La consulta une `patients` con `province_names`, agrupa con `GROUP BY`, usa el parámetro `@Province` y mapea al record `ProvinceStats` provisto |

Casos para probar tu endpoint antes de avisar al docente:

- Un código de provincia con pacientes (por ejemplo `ON`): esperar `200` con la fila completa.
- Un código que no existe (por ejemplo `ZZ`): esperar `404` con mensaje.

## Parte 2 — Issue y pull request de arreglo (35 minutos)

El grupo recibió este reporte y este código quedó guardado en el archivo `defecto-<tu-inicial>.cs` de la carpeta `especiales-34-35/` del repositorio:

```csharp
// Snippet provisto: la busqueda de provincias esta armada de forma insegura.
app.MapGet("/provinces/{provinceId}", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // DEFECTO: el SQL se concatena con el dato recibido
    var provinces = connection.Query<Province>(
        @"SELECT province_id   AS ProvinceId,
                 province_name AS ProvinceName
          FROM province_names
          WHERE province_id = '" + provinceId + "'").ToList();

    return provinces.Count == 0
        ? Results.NotFound(new { mensaje = "No existe la provincia" })
        : Results.Ok(provinces);
});

record Province(string ProvinceId, string ProvinceName);
```

Síntoma reportado: `GET /provinces/ON` responde `200`, pero cualquier valor con una comilla (por ejemplo `ON'`) corta la API con `500`, y el patrón viola el canon del curso.

Pasos que se evalúan, en este orden:

| # | Paso |
| --- | --- |
| 1 | Crear en el repositorio del grupo un **issue** con título breve, descripción del síntoma y **criterios de aceptación** como lista de verificación: la consulta usa el parámetro `@ProvinceId` con su objeto anónimo; `GET /provinces/ON` responde `200` con la provincia; un código inexistente responde `404` con mensaje; el commit referencia el issue |
| 2 | Crear la rama `feature/fix-eval-<tu-inicial>` desde `main` actualizada (`git switch main`, `git pull`, `git switch -c ...`) |
| 3 | Detectar el defecto, corregirlo en el archivo `defecto-<tu-inicial>.cs` y verificar los criterios de aceptación probando el endpoint |
| 4 | Hacer commit(s) con el número del issue entre paréntesis, por ejemplo `(#4): fix de consulta parametrizada en provincias` |
| 5 | Hacer push de la rama y abrir el **pull request** vinculado al issue. **No fusionar**: `main` está protegida y el PR queda abierto para la revisión del docente |

## Cierre y entrega

- El `Program.cs` de la Parte 1 queda guardado en la carpeta indicada de la máquina.
- El pull request de la Parte 2 queda abierto, con su issue vinculado y los commits referenciándolo.
- Avisar al docente al terminar o al agotarse el tiempo: se registra la evidencia parcial alcanzada.
