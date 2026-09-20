# Anexo docente — Evaluación integradora del cuatrimestre 2 · Versión A

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Encuentro 33 — Cierre integrador del cuatrimestre 2

## Encuadre

| Campo | Detalle |
| --- | --- |
| Evaluación | Integradora cuatrimestral — Versión A (dominio: estadísticas por especialidad, tablas `doctors` y `admissions`) |
| Encuentro de aplicación | 33 — Cierre integrador del cuatrimestre 2 (120 min de resolución dentro del encuentro) |
| Alcance | Año completo con énfasis en las Unidades 3 y 4 |
| Estructura y puntaje | Parte 1: estadística con GROUP BY (30) · Parte 2: JOIN de tres tablas parametrizado (30) · Parte 3: subconsulta (15) · Parte 4: ítems conceptuales C1–C3 (25) |
| Base de resolución | Proyecto con `hospital.db` junto al `.csproj`; esqueleto provisto con la prueba (usings, cadena de conexión y records) |

## Preparación previa (gestión del aula)

- Resolver la prueba completa antes de la clase sobre la copia de `hospital.db` del aula y anotar los valores reales de cada endpoint: filas de `/stats/admissions-by-specialty`, resultado de la búsqueda con un texto de referencia (por ejemplo `surgeon`) y lista de médicos sin ingresos. Son los valores contra los que se valida cada entrega.
- Verificar el parque informático: `hospital.db` junto al `.csproj`, paquetes Microsoft.Data.Sqlite y Dapper instalados, SDK de .NET 6 operativo.
- Imprimir o disponer el enunciado base y la versión A; confeccionar la planilla alumno → versión antes de comenzar.
- Tener a mano la versión B y su anexo, por si la asignación por posiciones la requiere en la misma mesa.

## Solución esperada

Los tres endpoints van en el `Program.cs` del esqueleto, antes de `app.Run()`; los records ya están provistos al final del archivo.

Parte 1 — cantidad de ingresos por especialidad (GROUP BY sobre un JOIN):

```csharp
// Parte 1: cantidad de ingresos por especialidad (COUNT + GROUP BY sobre JOIN).
app.MapGet("/stats/admissions-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<AdmissionsBySpecialty>(@"
        SELECT d.specialty AS Specialty,
               COUNT(*) AS Total
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        GROUP BY d.specialty
        ORDER BY Total DESC").ToList();

    return Results.Ok(stats);
});
```

- Evalúa agrupar sobre el resultado de un JOIN: el grupo es la especialidad (columna de `doctors`), no una columna de la tabla base. El conteo se mapea a `int Total`.
- No requiere parámetros: sin objeto anónimo en la llamada. `ORDER BY Total DESC` usa el alias del agregado.
- Verificación: 200 con una fila por cada especialidad que tenga ingresos (valores anotados en la preparación previa).

Parte 2 — ingresos de médicos de una especialidad (JOIN de tres tablas + filtro parametrizado):

```csharp
// Parte 2: ingresos de medicos cuya especialidad contiene el texto (JOIN triple).
app.MapGet("/admissions/by-specialty", (string? text) =>
{
    // Validacion manual: sin texto no hay busqueda que hacer (400 con mensaje).
    if (string.IsNullOrWhiteSpace(text))
    {
        return Results.BadRequest(new { mensaje = "Indique el texto de la especialidad a buscar" });
    }

    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionOfSpecialty>(@"
        SELECT a.admission_date AS AdmissionDate,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS Specialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE d.specialty LIKE @Text
        ORDER BY a.admission_date",
        new { Text = "%" + text + "%" }).ToList();

    return Results.Ok(admissions);
});
```

- Evalúa el molde completo del JOIN triple visto en la clase 21: dos `ON` correctos, nombre completo armado en el SELECT con el operador de concatenación, alias hacia el record y orden estable por fecha ISO.
- El filtro es parametrizado con comodines: `LIKE @Text` con `new { Text = "%" + text + "%" }`. La validación del query string vacío responde 400 con mensaje en español (canon de la clase 12).
- `string? text` declara el query string nullable: si no llega, la validación responde antes de tocar la base.
- Verificación: 200 con los ingresos de la especialidad buscada (texto de referencia anotado en la preparación) y 400 con mensaje cuando falta el texto.

Parte 3 — médicos sin ningún ingreso (subconsulta):

```csharp
// Parte 3: medicos sin ningun ingreso (subconsulta con NOT IN).
app.MapGet("/doctors/without-admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<DoctorWithoutAdmissions>(@"
        SELECT first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id NOT IN (SELECT attending_doctor_id FROM admissions)
        ORDER BY LastName").ToList();

    return Results.Ok(doctors);
});
```

- Evalúa la subconsulta como lista de comparación: los médicos cuyo id no está en la lista de `attending_doctor_id` de `admissions`. Es la negación del patrón `IN` trabajado en la clase 23 (`/patients/never-admitted`).
- Solución equivalente aceptada: subconsulta escalar correlacionada con conteo cero, `WHERE (SELECT COUNT(*) FROM admissions a WHERE a.attending_doctor_id = d.doctor_id) = 0`.
- `attending_doctor_id` es NOT NULL en la base, por lo que `NOT IN` no presenta el caso límite del `NULL` en la lista: si un alumno lo nombra en la defensa, es una observación de excelencia.
- Verificación: 200 con los médicos sin ingresos (lista anotada en la preparación previa), ordenados por apellido.

Pedidos de prueba:

```powershell
curl http://localhost:5080/stats/admissions-by-specialty
curl "http://localhost:5080/admissions/by-specialty?text=surgeon"
curl -i "http://localhost:5080/admissions/by-specialty"
curl http://localhost:5080/doctors/without-admissions
```

## Respuestas esperadas — ítems conceptuales

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
| Parte 1 | JOIN entre `admissions` y `doctors` con `ON` correcto | 8 |
| Parte 1 | `COUNT(*)` con `GROUP BY` por especialidad | 8 |
| Parte 1 | Alias de columnas hacia el record (`PascalCase`) | 6 |
| Parte 1 | `ORDER BY` por cantidad descendente y `200` con `Results.Ok` | 8 |
| Parte 2 | Validación del texto vacío: `400` con mensaje en español | 4 |
| Parte 2 | JOIN de tres tablas con sus dos `ON` correctos | 8 |
| Parte 2 | Filtro `LIKE` parametrizado con comodines (nunca concatenado) | 6 |
| Parte 2 | Nombres completos armados en el SELECT y alias hacia el record | 6 |
| Parte 2 | Orden por fecha de ingreso y `200` con `Results.Ok` | 6 |
| Parte 3 | Subconsulta correcta (`NOT IN` o equivalente con conteo cero) | 7 |
| Parte 3 | Alias hacia el record y orden por apellido | 4 |
| Parte 3 | `200` con `Results.Ok` | 4 |
| C1 | a) memoria vs. persistencia (3) · b) auditoría del dato sucio (3) · c) `COALESCE` (4) | 10 |
| C2 | a) `appsettings.json` y `??` (4) · b) `dotnet publish` y la base junto al DLL (4) | 8 |
| C3 | a) orden del flujo (3) · b) `Closes #N` (2) · c) `main` protegida (2) | 7 |
| **Total** | | **100** |

Observaciones de corrección:

- Defectos típicos a vigilar: `GROUP BY` sobre una columna sin JOIN previo, `LIKE` sin comodines o concatenado con el dato, validación `400` omitida, `IN` en lugar de `NOT IN`, alias faltantes (el mapeo de Dapper devuelve propiedades en null sin fallar) y records redeclarados antes de `app.Run()`.
- La versión B se corrige con su propio anexo, con la misma escala y los mismos criterios por parte: la equivalencia garantiza que la versión aplicada no modifique el resultado.

## Pauta de devolución

- Corrección con la planilla por ítem de la tabla anterior; un comentario escrito por parte (práctica y conceptual), no solo el puntaje.
- Devolución al inicio del encuentro 34 (dentro de los primeros 15 minutos): corrección escrita individual y comentarios generales al curso con los aciertos y errores más frecuentes.
- Registro: planilla de resultados con alumno → versión → puntos por parte; los núcleos no alcanzados se marcan para los encuentros especiales 34 y 35 (pistas de refuerzo), con resultado aún provisorio de Apto o No apto.
- El archivo `Program.cs` de cada alumno queda como evidencia de la prueba junto a la planilla del encuentro.
