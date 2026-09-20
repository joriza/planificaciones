# Anexo docente — Evaluación de la Unidad 3 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B (dominio provincias), las respuestas esperadas, los criterios de corrección ítem por ítem, los errores previstos y la pauta de devolución para el encuentro 27.

## 1. Verificación previa de la base

Antes del encuentro, constatar contra la `hospital.db` provista en las máquinas (los valores de referencia de este anexo fueron constatados sobre la base regenerada de `database-docs/Scripts`; la base distribuida del curso puede tener otros totales). Consultas de auditoría en `sqlite3 hospital.db`:

```sql
-- Ingresos sin alta que audita la Parte 3 (referencia: hay en la base
-- canonica del curso; si la base provista no tuviera ninguno, el endpoint
-- correcto responde 200 con [] y el item se evalua por el codigo)
SELECT COUNT(*) FROM admissions WHERE discharge_date IS NULL;

-- Altas imposibles (dominio de la version A; utiles para comparar dominios)
SELECT COUNT(*) FROM admissions
WHERE discharge_date IS NOT NULL
  AND (discharge_date < admission_date OR discharge_date LIKE '1971-%');

-- Pacientes por provincia y altura promedio (referencia de la Parte 2)
SELECT pn.province_name, COUNT(*), ROUND(AVG(p.height), 1)
FROM patients p JOIN province_names pn ON p.province_id = pn.province_id
GROUP BY p.province_id ORDER BY 2 DESC LIMIT 4;

-- Claves de provincia (para probar el 404 de la Parte 1)
SELECT province_id, province_name FROM province_names;
```

Referencias útiles (base regenerada): Ontario concentra 480 pacientes de 500; hay 13 provincias en `province_names`; el paciente con más ingresos y las filas de la Parte 1 se constatan con las consultas anteriores.

## 2. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion Unidad 3 - Version B (solucion del docente)
// Dominio: provincias (patients + province_names, con admissions en el JOIN triple)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API

// La cadena vive en appsettings.json (clase 24). Si la clave falta,
// el ?? entrega la cadena canonica y la API arranca igual.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();                          // Construye la aplicacion

// ===== Parte 1 =====

// GET /provinces/{provinceId}/admissions: ingresos de los pacientes de una
// provincia. JOIN triple admissions + patients + province_names.
// Ojo: la clave de provincia es TEXTO, el parametro del handler es string.
app.MapGet("/provinces/{provinceId}/admissions", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Existencia ANTES de la consulta pesada (patron de la clase 21).
    // La clave es texto: ExecuteScalar<string?> devuelve null si no hay fila.
    var exists = connection.ExecuteScalar<string?>(
        @"SELECT province_id
          FROM province_names
          WHERE province_id = @Id",
        new { Id = provinceId });

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "No existe la provincia" });
    }

    // JOIN triple: admissions (a) + patients (p) + province_names (pn).
    // Cada ON traduce un codigo; todas las columnas calificadas con alias.
    var admissions = connection.Query<AdmissionInProvince>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               pn.province_name AS ProvinceName
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.province_id = @Id
        ORDER BY a.admission_date DESC",
        new { Id = provinceId }).ToList();

    return Results.Ok(admissions);
});

// ===== Parte 2 =====

// GET /stats/patients-by-province: por provincia, cantidad de pacientes y
// altura promedio. Se agrupa por la CLAVE (p.province_id, que no se repite)
// y el nombre se muestra en el SELECT: el patron de la clase 22.
app.MapGet("/stats/patients-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<PatientsByProvince>(@"
        SELECT pn.province_name AS ProvinceName,
               COUNT(*) AS TotalPatients,
               ROUND(AVG(p.height), 1) AS AvgHeight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        GROUP BY p.province_id
        ORDER BY TotalPatients DESC").ToList();

    return Results.Ok(stats);
});

// ===== Parte 3 =====

// GET /admissions/open: ingresos SIN fecha de alta = pacientes aun internados.
// NULL no se compara con =: se encuentra con IS NULL, y el diagnostico
// faltante se declara con COALESCE para que ningun null llegue al JSON.
app.MapGet("/admissions/open", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<OpenAdmission>(@"
        SELECT p.first_name || ' ' || p.last_name AS PatientName,
               a.admission_date AS AdmissionDate,
               COALESCE(a.diagnosis, 'Sin diagnostico') AS Diagnosis
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        WHERE a.discharge_date IS NULL
        ORDER BY a.admission_date").ToList();

    return Results.Ok(admissions);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo (despues de app.Run()) ----
record AdmissionInProvince(
    string AdmissionDate,
    string? Diagnosis,
    string PatientName,
    string ProvinceName);

record PatientsByProvince(string ProvinceName, int TotalPatients, double AvgHeight);

record OpenAdmission(string PatientName, string AdmissionDate, string Diagnosis);
```

Aceptaciones válidas menores: verificación de existencia con `QueryFirstOrDefault<string?>` (o sobre un record corto de `province_names`) en lugar de `ExecuteScalar<string?>`; `GROUP BY pn.province_name` en lugar de `GROUP BY p.province_id` (con el JOIN por la clave, cada grupo tiene un único nombre: mismo resultado); en la Parte 3, el nombre armado con `||` es obligatorio (el record provisto exige `PatientName`): exponer `first_name` y `last_name` por separado rompe el mapeo y descuenta en 3b/3f. No se acepta `TypedResults`, SQL concatenado, ni `WHERE discharge_date = NULL` (nunca es verdadero: es el defecto central de la Parte 3).

## 3. Respuestas esperadas

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/provinces/ON/admissions` | `200` con los ingresos de los pacientes de Ontario (477 en la base regenerada), el más reciente primero. Primeras filas: `{"admissionDate":"2019-06-05","diagnosis":"Possible Renal Calculi","patientName":"Anthony Maxwell","provinceName":"Ontario"}`, `{"admissionDate":"2019-06-02","diagnosis":"Pneumonia","patientName":"Art Fane","provinceName":"Ontario"}` |
| `GET http://localhost:5080/provinces/XX/admissions` | `404` con `{"mensaje":"No existe la provincia"}` (cualquier clave ausente de `province_names`) |
| `GET http://localhost:5080/stats/patients-by-province` | `200` con una fila por provincia con pacientes, la de más pacientes primero. Base regenerada, primeras filas: `{"provinceName":"Ontario","totalPatients":480,"avgHeight":159.5}`, `{"provinceName":"Nova Scotia","totalPatients":6,"avgHeight":145.3}`, `{"provinceName":"Alberta","totalPatients":5,"avgHeight":128.0}` |
| `GET http://localhost:5080/admissions/open` | `200` con los ingresos sin alta, ordenados por fecha de ingreso; `diagnosis` nunca es `null` (o el texto real, o `"Sin diagnostico"`). Sobre la base canónica del curso hay aún internados (ver sección 1); sobre una base sin altas nulas, `200` con `[]` es la respuesta correcta y el ítem se evalúa por el código |

Sobre `avgHeight` de la Parte 2: `height` es nullable y `AVG` ignora los nulos automáticamente; el `ROUND(..., 1)` da el decimal limpio del JSON. No corresponde filtrar filas con `height IS NULL`: el promedio del motor ya las excluye.

## 4. Criterios de corrección ítem por ítem

### Parte 1 — Ingresos por provincia (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1a | Ruta `GET /provinces/{provinceId}/admissions` con `string provinceId` en el handler | 4 |
| 1b | Verificación de existencia sobre `province_names` ANTES del JOIN, parametrizada; `404` con `{"mensaje":"No existe la provincia"}` si no está | 10 |
| 1c | JOIN triple con los dos `ON` completos (`a.patient_id = p.patient_id`, `p.province_id = pn.province_id`) y columnas calificadas con alias | 8 |
| 1d | Alias `AS` en cada columna hacia `AdmissionInProvince`, nombre del paciente armado con `\|\|`, `ORDER BY a.admission_date DESC` y `Results.Ok` | 8 |

### Parte 2 — Pacientes por provincia (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2a | Ruta `GET /stats/patients-by-province` | 3 |
| 2b | JOIN `patients` + `province_names` con `ON` correcto | 4 |
| 2c | `GROUP BY` por la clave (`p.province_id`, o el nombre con el JOIN por clave) y `COUNT(*)` con alias | 8 |
| 2d | `ROUND(AVG(p.height), 1)` calculada en el motor, con alias hacia el record | 6 |
| 2e | `ORDER BY TotalPatients DESC` y `Results.Ok` con `Query<PatientsByProvince>` (conteo `int`, promedio `double`) | 4 |

### Parte 3 — Pacientes aún internados (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3a | Ruta `GET /admissions/open` | 3 |
| 3b | JOIN a `patients` con alias calificados y nombre armado con `\|\|` hacia `OpenAdmission` | 5 |
| 3c | Filtro `WHERE discharge_date IS NULL` (se descuenta `= NULL`: nunca es verdadero) | 8 |
| 3d | `COALESCE(a.diagnosis, 'Sin diagnostico')` en el SELECT y `Diagnosis` declarada `string` sin `?` | 4 |
| 3e | `ORDER BY admission_date` y `Results.Ok` | 3 |
| 3f | Alias `AS` completos en todas las columnas del SELECT | 2 |

### Parte 4 — Ítems conceptuales (20 puntos)

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1 | Dos razones: (1) seguridad — el valor no se ejecuta como parte del SQL (evita la inyección); (2) el motor recibe el dato aparte, sin romper comillas ni formato del texto SQL | 6 |
| C2a | Una fila por grupo (provincia): cada fila tiene el nombre del grupo, su cantidad de pacientes y su altura promedio | 4 |
| C2b | UNA sola fila: el `COUNT` y el `AVG` calculados sobre TODAS las filas (sin grupos, la agregación cubre toda la tabla) | 3 |
| C3 | Una subconsulta es una consulta dentro de otra. La escalar correlacionada produce UN valor por fila de la consulta externa usando datos de esa fila: cuenta los ingresos de CADA paciente (compara `a.patient_id = p.patient_id` con la fila externa) y su resultado se usa como columna (`AdmissionCount`) y como filtro (`> @Min`) | 7 |

**Total: 100 puntos.** No se duplican descuentos por el mismo defecto en ítems distintos (por ejemplo, la falta de `||` ya descontada en 1d no se vuelve a descontar en 3b).

## 5. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `ambiguous column name: province_id` | Columna sin calificar (existe en `patients` y en `province_names`) | Descuenta en 1c; leer el error en la terminal no invalida la prueba |
| Comparar con `WHERE discharge_date = NULL` | `NULL` no es igual a nada, ni a sí mismo | Descuenta en 3c (concepto central de la clase 23); `IS NULL` es la corrección |
| `diagnosis` llega `null` en el JSON | Falta el `COALESCE` (y quedó `string` sin `?` en el record) o quedó `string?` | Descuenta en 3d; el mismo defecto no se descuenta dos veces |
| 404 que nunca aparece (clave inexistente devuelve `[]`) | Consultó los ingresos sin verificar la provincia primero | Descuenta en 1b; si el 404 quedó después del JOIN, es el mismo defecto, no dos |
| Verificación de existencia con `long` sobre la clave de texto | La clave de provincia es `TEXT`; el patrón de la clase 21 hay que adaptarlo a `string` | Descuenta parcial en 1b: el orden está, el tipo no; orientar en el momento no quita el descuento |
| Promedio con decimales infinitos | `AVG` sin `ROUND` | Descuenta en 2d; el resto del ítem puntúa |
| `GROUP BY` solo del nombre sin JOIN por clave en dudas | Dos filas con el mismo nombre colapsarían; la clave no se repite | Con el JOIN por clave, `GROUP BY pn.province_name` es aceptado (ver sección 2); sin el JOIN por clave, descuenta en 2c |
| `TypedResults` en las respuestas | Confusión de versión | Defecto de versión del canon; descuenta en el ítem donde aparece |
| Rutas en español (`/provincias`) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |

## 6. Pauta de devolución (encuentro 27)

- Corrección individual escrita por ítem (qué puntúa, qué no y por qué), con el estado de cada objetivo mínimo de la unidad (U3-1 a U3-4). El encuentro 27 abre con esta devolución, junto con la de la defensa y la verificación de entrega.
- Comentarios generales al curso al abrir la clase: los aciertos más frecuentes (JOIN triple con provincias, agrupar por la clave) y los errores comunes esperables (`= NULL` en lugar de `IS NULL`, `COALESCE` faltante, la clave de provincia como texto en la verificación de existencia).
- Los ítems no alcanzados se traducen en el plan de reincorporación de la capa 1 (`criterios-aprobacion.md`): cada alumno marca en su corrección los núcleos a reforzar, con vista a los encuentros de intensificación y fortalecimiento 34-35.
- La planilla de resultados registra: alumno, versión B, puntaje por parte (30/25/25/20) y total, resultado de la defensa y estado objetivo por objetivo.
