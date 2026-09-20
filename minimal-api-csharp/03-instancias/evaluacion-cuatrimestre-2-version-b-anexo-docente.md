# Anexo docente — Evaluación integradora del cuatrimestre 2 · Versión B

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Encuentro 33 — Cierre integrador del cuatrimestre 2

## Encuadre

| Campo | Detalle |
| --- | --- |
| Evaluación | Integradora cuatrimestral — Versión B (dominio: estadísticas por provincia y por mes, tablas `province_names`, `patients` y `admissions`) |
| Encuentro de aplicación | 33 — Cierre integrador del cuatrimestre 2 (120 min de resolución dentro del encuentro) |
| Alcance | Año completo con énfasis en las Unidades 3 y 4 |
| Estructura y puntaje | Parte 1: estadística con GROUP BY (30) · Parte 2: JOIN de tres tablas parametrizado (30) · Parte 3: subconsulta (15) · Parte 4: ítems conceptuales C1–C3 (25) |
| Base de resolución | Proyecto con `hospital.db` junto al `.csproj`; esqueleto provisto con la prueba (usings, cadena de conexión y records) |

## Preparación previa (gestión del aula)

- Resolver la prueba completa antes de la clase sobre la copia de `hospital.db` del aula y anotar los valores reales de cada endpoint: filas de `/stats/patients-by-province`, resultado de la búsqueda con un mes de referencia (por ejemplo `2018-09`) y lista de provincias sin pacientes. Son los valores contra los que se valida cada entrega.
- Verificar el parque informático: `hospital.db` junto al `.csproj`, paquetes Microsoft.Data.Sqlite y Dapper instalados, SDK de .NET 6 operativo.
- Imprimir o disponer el enunciado base y la versión B; confeccionar la planilla alumno → versión antes de comenzar.
- Tener a mano la versión A y su anexo, por si la asignación por posiciones la requiere en la misma mesa.

## Solución esperada

Los tres endpoints van en el `Program.cs` del esqueleto, antes de `app.Run()`; los records ya están provistos al final del archivo.

Parte 1 — cantidad de pacientes por provincia (GROUP BY sobre un JOIN):

```csharp
// Parte 1: cantidad de pacientes por provincia (COUNT + GROUP BY sobre JOIN).
app.MapGet("/stats/patients-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<PatientsByProvince>(@"
        SELECT pr.province_name AS ProvinceName,
               COUNT(*) AS Total
        FROM patients p
        JOIN province_names pr ON p.province_id = pr.province_id
        GROUP BY pr.province_name
        ORDER BY Total DESC").ToList();

    return Results.Ok(stats);
});
```

- Evalúa agrupar sobre el resultado de un JOIN: el grupo es el nombre de provincia (columna de `province_names`), no el código de la tabla base. El conteo se mapea a `int Total`.
- No requiere parámetros: sin objeto anónimo en la llamada. `ORDER BY Total DESC` usa el alias del agregado.
- Verificación: 200 con una fila por cada provincia que tenga pacientes (valores anotados en la preparación previa; la mayoría vive en `ON`). Las provincias sin pacientes no aparecen acá: es el puente natural con la Parte 3.

Parte 2 — ingresos de un mes dado (JOIN de tres tablas + filtro parametrizado):

```csharp
// Parte 2: ingresos de un mes dado en formato YYYY-MM (JOIN triple).
app.MapGet("/admissions/by-month", (string? month) =>
{
    // Validacion manual: sin mes no hay consulta que hacer (400 con mensaje).
    if (string.IsNullOrWhiteSpace(month))
    {
        return Results.BadRequest(new { mensaje = "Indique el mes en formato YYYY-MM" });
    }

    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionOfMonth>(@"
        SELECT a.admission_date AS AdmissionDate,
               p.first_name || ' ' || p.last_name AS PatientName,
               pr.province_name AS ProvinceName,
               strftime('%Y-%m', a.admission_date) AS Month
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN province_names pr ON p.province_id = pr.province_id
        WHERE strftime('%Y-%m', a.admission_date) = @Month
        ORDER BY a.admission_date",
        new { Month = month }).ToList();

    return Results.Ok(admissions);
});
```

- Evalúa el molde del JOIN por cadena visto en las clases 21 y 22: dos `ON` correctos (`admissions` → `patients` → `province_names`), nombre completo armado en el SELECT con el operador de concatenación, alias hacia el record y orden estable por fecha ISO.
- El filtro usa `strftime('%Y-%m', ...)` (clase 22) comparado contra un parámetro: `WHERE strftime('%Y-%m', a.admission_date) = @Month`. La validación del query string vacío responde 400 con mensaje en español (canon de la clase 12).
- `string? month` declara el query string nullable: si no llega, la validación responde antes de tocar la base. El formato del mes lo aporta el enunciado (`YYYY-MM`), igual que en la práctica de la clase 22.
- Verificación: 200 con los ingresos del mes pedido (mes de referencia anotado en la preparación; los datos cubren de junio de 2018 a junio de 2019) y 400 con mensaje cuando falta el mes.

Parte 3 — provincias sin ningún paciente (subconsulta):

```csharp
// Parte 3: provincias sin ningun paciente (subconsulta con NOT IN).
app.MapGet("/provinces/without-patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var provinces = connection.Query<ProvinceWithoutPatients>(@"
        SELECT province_id AS ProvinceId,
               province_name AS ProvinceName
        FROM province_names
        WHERE province_id NOT IN (SELECT province_id FROM patients)
        ORDER BY ProvinceName").ToList();

    return Results.Ok(provinces);
});
```

- Evalúa la subconsulta como lista de comparación: las provincias cuyo código no está en la lista de `province_id` de `patients`. Es la negación del patrón `IN` trabajado en la clase 23 (`/patients/never-admitted`).
- Solución equivalente aceptada: subconsulta escalar correlacionada con conteo cero, `WHERE (SELECT COUNT(*) FROM patients p WHERE p.province_id = pr.province_id) = 0`.
- `province_id` es NOT NULL en la base (clave primaria de `province_names` y columna obligatoria de `patients`), por lo que `NOT IN` no presenta el caso límite del `NULL` en la lista: si un alumno lo nombra en la defensa, es una observación de excelencia.
- Verificación: 200 con las provincias sin pacientes (lista anotada en la preparación previa; complementa las filas de la Parte 1), ordenadas por nombre.

Pedidos de prueba:

```powershell
curl http://localhost:5080/stats/patients-by-province
curl "http://localhost:5080/admissions/by-month?month=2018-09"
curl -i "http://localhost:5080/admissions/by-month"
curl http://localhost:5080/provinces/without-patients
```

## Respuestas esperadas — ítems conceptuales

(Ítems idénticos en ambas versiones: la equivalencia A/B solo cambia el dominio práctico.)

### C1. Del año: memoria, base y datos sucios (10 puntos)

- **a) (3 puntos).** La lista en memoria se vacía: al cortar el proceso con `Ctrl+C` se pierden los datos creados en memoria y al volver a correr la lista vuelve a su estado inicial. Los datos de `hospital.db` en cambio persisten, porque quedan guardados en el archivo: persistencia.
- **b) (3 puntos).** Con una comparación de fechas ISO en el WHERE: `WHERE discharge_date < admission_date` (alta anterior al ingreso). También se acepta la auditoría por patrón vista en clase: `WHERE discharge_date LIKE '1971-%'`.
- **c) (4 puntos).** `COALESCE` devuelve el primer valor no nulo: si `diagnosis` tiene valor lo devuelve tal cual; si es `NULL` devuelve el texto `'Sin diagnostico'`. Sirve para que el JSON no exponga `null` sino un texto explícito y legible; además, como el SELECT garantiza un valor, la propiedad del record puede declararse `string` sin el `?`.

### C2. Configuración y publicación (8 puntos)

- **a) (4 puntos).** Porque la cadena de conexión es configuración, no lógica: pertenece a un archivo que el programa lee al arrancar, y cambiarla (otra carpeta, otro servidor) no debe obligar a tocar el código ni a recompilar. El `??` garantiza un valor por defecto seguro: si la clave falta o está mal escrita en `appsettings.json`, la API arranca igual con la cadena canónica en lugar de quedar con un `null`.
- **b) (4 puntos).** `dotnet publish -c Release` compila en modo optimizado (Release) y junta en la carpeta `publish` todo lo necesario para correr sin `dotnet run` (se ejecuta con `dotnet ./HospitalApi.dll`). La cadena `Data Source=hospital.db` es una ruta relativa a la carpeta desde la que corre el programa: si la base no se copia junto al DLL, SQLite crea una base vacía con ese nombre y el primer pedido falla con `no such table`.

### C3. Flujo profesional con GitHub (7 puntos)

- **a) (3 puntos).** Orden correcto: crear el issue con sus criterios → crear la rama `feature/...` → commitear en la rama → abrir el pull request (con `Closes #N`) → revisión y aprobación de un compañero → fusionar a `main`.
- **b) (2 puntos).** Al fusionar el pull request, GitHub cierra automáticamente el issue `#3`: la trazabilidad issue → PR → `main` queda completa sin pasos manuales.
- **c) (2 puntos).** Que `main` no acepta push directo: todo cambio entra por pull request con al menos una aprobación. El push directo se rechaza (por ejemplo con `GH006`): esa es la protección funcionando.

## Criterios de corrección

| Parte | Ítem de evaluación | Puntos |
| --- | --- | --- |
| Parte 1 | JOIN entre `patients` y `province_names` con `ON` correcto | 8 |
| Parte 1 | `COUNT(*)` con `GROUP BY` por nombre de provincia | 8 |
| Parte 1 | Alias de columnas hacia el record (`PascalCase`) | 6 |
| Parte 1 | `ORDER BY` por cantidad descendente y `200` con `Results.Ok` | 8 |
| Parte 2 | Validación del mes vacío: `400` con mensaje en español | 4 |
| Parte 2 | JOIN de tres tablas con sus dos `ON` correctos | 8 |
| Parte 2 | Filtro con `strftime` parametrizado (nunca concatenado) | 6 |
| Parte 2 | Nombre completo armado en el SELECT y alias hacia el record | 6 |
| Parte 2 | Orden por fecha de ingreso y `200` con `Results.Ok` | 6 |
| Parte 3 | Subconsulta correcta (`NOT IN` o equivalente con conteo cero) | 7 |
| Parte 3 | Alias hacia el record y orden por nombre de provincia | 4 |
| Parte 3 | `200` con `Results.Ok` | 4 |
| C1 | a) memoria vs. persistencia (3) · b) auditoría del dato sucio (3) · c) `COALESCE` (4) | 10 |
| C2 | a) `appsettings.json` y `??` (4) · b) `dotnet publish` y la base junto al DLL (4) | 8 |
| C3 | a) orden del flujo (3) · b) `Closes #N` (2) · c) `main` protegida (2) | 7 |
| **Total** | | **100** |

Observaciones de corrección:

- Defectos típicos a vigilar: agrupar por código de provincia en lugar del nombre (o por la columna de la tabla base sin JOIN), `strftime` mal escrito o comparado sin parámetro, validación `400` omitida, `IN` en lugar de `NOT IN`, alias faltantes (el mapeo de Dapper devuelve propiedades en null sin fallar) y records redeclarados antes de `app.Run()`.
- La versión A se corrige con su propio anexo, con la misma escala y los mismos criterios por parte: la equivalencia garantiza que la versión aplicada no modifique el resultado.

## Pauta de devolución

- Corrección con la planilla por ítem de la tabla anterior; un comentario escrito por parte (práctica y conceptual), no solo el puntaje.
- Devolución al inicio del encuentro 34 (dentro de los primeros 15 minutos): corrección escrita individual y comentarios generales al curso con los aciertos y errores más frecuentes.
- Registro: planilla de resultados con alumno → versión → puntos por parte; los núcleos no alcanzados se marcan para los encuentros especiales 34 y 35 (pistas de refuerzo), con resultado aún provisorio de Apto o No apto.
- El archivo `Program.cs` de cada alumno queda como evidencia de la prueba junto a la planilla del encuentro.
