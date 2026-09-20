# Anexo docente — Evaluación de la Unidad 3 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A (dominio especialidades), las respuestas esperadas, los criterios de corrección ítem por ítem, los errores previstos y la pauta de devolución para el encuentro 27.

## 1. Verificación previa de la base

Antes del encuentro, constatar contra la `hospital.db` provista en las máquinas (los valores de referencia de este anexo fueron constatados sobre la base regenerada de `database-docs/Scripts`; la base distribuida del curso puede tener otros totales). Consultas de auditoría en `sqlite3 hospital.db`:

```sql
-- Altas imposibles que audita la Parte 3 (referencia: 5 filas en la base regenerada)
SELECT COUNT(*) FROM admissions
WHERE discharge_date IS NOT NULL
  AND (discharge_date < admission_date OR discharge_date LIKE '1971-%');

-- Ingresos sin alta (no los pide la versión A; son el dominio de la B)
SELECT COUNT(*) FROM admissions WHERE discharge_date IS NULL;

-- Existencia de médicos y su especialidad (para probar la Parte 1)
SELECT doctor_id, first_name || ' ' || last_name, specialty FROM doctors LIMIT 5;
```

Referencias útiles (base regenerada): el médico 2 (Joshua Green, Cardiologist) tiene 25 ingresos; hay 27 médicos y 13 especialidades; 500 ingresos.

## 2. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion Unidad 3 - Version A (solucion del docente)
// Dominio: especialidades (admissions + doctors, con patients en el JOIN triple)

using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API

// La cadena vive en appsettings.json (clase 24). Si la clave falta,
// el ?? entrega la cadena canonica y la API arranca igual.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();                          // Construye la aplicacion

// ===== Parte 1 =====

// GET /doctors/{id:long}/admissions: ingresos atendidos por un medico.
// JOIN triple admissions + patients + doctors con verificacion previa.
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Existencia ANTES de la consulta pesada (patron de la clase 21):
    // ExecuteScalar<long> devuelve el id si existe, o 0 si no hay fila.
    var exists = connection.ExecuteScalar<long>(
        @"SELECT doctor_id
          FROM doctors
          WHERE doctor_id = @Id",
        new { Id = id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

    // JOIN triple: admissions (a) es la tabla del medio; cada ON traduce
    // uno de sus codigos. Todas las columnas calificadas con el alias.
    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.attending_doctor_id = @Id
        ORDER BY a.admission_date DESC",
        new { Id = id }).ToList();

    return Results.Ok(admissions);
});

// ===== Parte 2 =====

// GET /stats/stay-by-specialty: por especialidad, ingresos con alta y
// promedio de dias de internacion. COUNT y AVG se calculan en el motor.
app.MapGet("/stats/stay-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<SpecialtyStay>(@"
        SELECT d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions,
               ROUND(AVG(julianday(a.discharge_date) - julianday(a.admission_date)), 1) AS AvgDays
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.discharge_date IS NOT NULL
        GROUP BY d.specialty
        ORDER BY TotalAdmissions DESC").ToList();

    return Results.Ok(stats);
});

// ===== Parte 3 =====

// GET /admissions/strange-discharges: altas imposibles. Con alta registrada
// (IS NOT NULL), pero de 1971 o ANTERIOR al propio ingreso. El parentesis
// agrupa las dos condiciones imposibles dentro del AND principal.
app.MapGet("/admissions/strange-discharges", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var discharges = connection.Query<StrangeDischarge>(@"
        SELECT a.patient_id AS PatientId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.discharge_date IS NOT NULL
          AND (a.discharge_date < a.admission_date
               OR a.discharge_date LIKE '1971-%')
        ORDER BY a.discharge_date").ToList();

    return Results.Ok(discharges);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo (despues de app.Run()) ----
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);

record SpecialtyStay(string Specialty, int TotalAdmissions, double AvgDays);

record StrangeDischarge(long PatientId, string AdmissionDate, string DischargeDate, string DoctorName, string DoctorSpecialty);
```

Aceptaciones válidas menores: verificación de existencia con `QueryFirstOrDefault<long?>` (o sobre un record corto) en lugar de `ExecuteScalar<long>`; `GROUP BY Specialty` (por el alias) en lugar de `GROUP BY d.specialty`; `WHERE` con la condición del paréntesis antes que el `IS NOT NULL`; en la Parte 2, la variante «limpia» de la clase 23 (`AND a.discharge_date >= a.admission_date AND a.discharge_date NOT LIKE '1971-%'`) puntúa completo: los totales cambian levemente y los promedios pasan a ser positivos (ver sección 3). No se acepta `TypedResults` (el canon del curso en .NET 6 es `Results`), SQL concatenado ni columnas sin calificar que rompan la consulta.

## 3. Respuestas esperadas

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`) y `hospital.db` junto al `.csproj`:

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/doctors/2/admissions` | `200` con los 25 ingresos del médico 2 (Joshua Green, Cardiologist), el más reciente primero. Primera fila (base regenerada): `{"admissionDate":"2019-06-02","dischargeDate":"1971-01-05","patientName":"Morgan Harkness","doctorName":"Joshua Green","doctorSpecialty":"Cardiologist"}` |
| `GET http://localhost:5080/doctors/9999/admissions` | `404` con `{"mensaje":"No existe el medico"}` |
| `GET http://localhost:5080/stats/stay-by-specialty` | `200` con 13 filas (una por especialidad), la de más ingresos primero. Base regenerada, dos primeras filas: `{"specialty":"Cardiovascular Surgeon","totalAdmissions":47,"avgDays":-372.2}` y `{"specialty":"Cardiologist","totalAdmissions":44,"avgDays":-799.2}` |
| `GET http://localhost:5080/admissions/strange-discharges` | `200` con las altas imposibles (5 en la base regenerada), ordenadas por fecha de alta. Primera fila: `{"patientId":35,"admissionDate":"2019-06-05","dischargeDate":"1971-01-05","doctorName":"Mickey Duval","doctorSpecialty":"Pediatrician"}` |

Sobre el promedio negativo de la Parte 2: es el resultado correcto del criterio pedido (solo `IS NOT NULL`). Las 5 altas de 1971 restan cientos de días cada una y arrastran el promedio hacia abajo. Es la evidencia exacta del arco de las clases 22 y 23, y conecta las Partes 2 y 3 de la prueba. Con la variante «limpia» aceptada, el resultado pasa a `{"specialty":"Cardiovascular Surgeon","totalAdmissions":46,"avgDays":4.0}` en la primera fila. Cualquiera de las dos salidas acredita el ítem; lo que no se acepta es «arreglar» el promedio fuera del SQL.

## 4. Criterios de corrección ítem por ítem

### Parte 1 — Ingresos por médico (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1a | Ruta `GET /doctors/{id:long}/admissions` con `long id` en el handler | 4 |
| 1b | Verificación de existencia ANTES del JOIN, con consulta parametrizada; `404` con `{"mensaje":"No existe el medico"}` si no hay fila | 10 |
| 1c | JOIN triple con los dos `ON` completos (`a.patient_id = p.patient_id`, `a.attending_doctor_id = d.doctor_id`) y columnas calificadas con alias | 8 |
| 1d | Alias `AS` en cada columna hacia `AdmissionDetail`, nombres armados con `\|\|`, `ORDER BY a.admission_date DESC` y `Results.Ok` | 8 |

### Parte 2 — Días de internación por especialidad (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2a | Ruta `GET /stats/stay-by-specialty` | 3 |
| 2b | JOIN `admissions` + `doctors` con `ON` correcto | 4 |
| 2c | `GROUP BY` por especialidad y `COUNT(*)` con alias hacia el record | 8 |
| 2d | `WHERE discharge_date IS NOT NULL` y `ROUND(AVG(julianday(...) - julianday(...)), 1)` calculada en el motor | 6 |
| 2e | `ORDER BY TotalAdmissions DESC` y `Results.Ok` con `Query<SpecialtyStay>` (conteo `int`, promedio `double`) | 4 |

### Parte 3 — Auditoría de altas imposibles (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3a | Ruta `GET /admissions/strange-discharges` | 3 |
| 3b | JOIN a `doctors` con alias calificados, médico y especialidad en el DTO | 5 |
| 3c | Filtro completo: `discharge_date IS NOT NULL` y, entre paréntesis, `< admission_date OR LIKE '1971-%'` | 8 |
| 3d | `DischargeDate` declarada `string` (sin `?`): el filtro garantiza alta presente | 4 |
| 3e | `ORDER BY discharge_date` y `Results.Ok` | 3 |
| 3f | Alias `AS` completos en todas las columnas del SELECT | 2 |

### Parte 4 — Ítems conceptuales (20 puntos)

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1 | Dos razones: (1) seguridad — el valor no se ejecuta como parte del SQL (evita la inyección); (2) el motor recibe el dato aparte, sin romper comillas ni formato del texto SQL | 6 |
| C2a | 13 filas: una por grupo (especialidad); cada fila tiene el nombre del grupo, su cantidad de ingresos y su promedio de días | 4 |
| C2b | UNA sola fila: el `COUNT` y el `AVG` calculados sobre TODAS las filas (sin grupos, la agregación cubre toda la tabla) | 3 |
| C3 | Una subconsulta es una consulta dentro de otra. La escalar correlacionada produce UN valor por fila de la consulta externa usando datos de esa fila: cuenta los ingresos de CADA paciente (compara `a.patient_id = p.patient_id` con la fila externa) y su resultado se usa como columna (`AdmissionCount`) y como filtro (`> @Min`) | 7 |

**Total: 100 puntos.** No se duplican descuentos por el mismo defecto en ítems distintos (por ejemplo, la falta de alias ya descontada en 1d no se vuelve a descontar en 2e o 3f).

## 5. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `ambiguous column name` en el JOIN triple | Columna sin calificar (`patient_id` existe en dos tablas) | Descuenta en 1c; leer el error en la terminal no invalida la prueba |
| 404 que nunca aparece (id inexistente devuelve `[]`) | Consultó los ingresos sin verificar existencia primero | Descuenta en 1b; si el 404 quedó después del JOIN, es el mismo defecto, no dos |
| Promedio con decimales infinitos | `AVG` sin `ROUND` | Descuenta en 2d; el resto del ítem puntúa |
| Promedio absurdo «corregido» desde C# o filtrando en memoria | No entendió que el cálculo va en el motor | Descuenta en 2d; conversar en la devolución |
| Filtro de la Parte 3 sin paréntesis (`OR` suelto con el `IS NOT NULL`) | Precedencia del AND/OR: devuelve filas de más | Descuenta parcial en 3c: la técnica está, la lógica no cierra |
| `DischargeDate` declarada `string?` con filtro garantizado | No conectó el tipo del record con lo que el SELECT garantiza | Descuenta en 3d (concepto de la clase 23) |
| `TypedResults` en las respuestas | Confusión de versión | Defecto de versión del canon; descuenta en el ítem donde aparece |
| Rutas en español (`/medicos`) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| 404 sin cuerpo de mensaje | `Results.NotFound()` a secas | Descuento parcial: el código puntúa, el mensaje exigido no |

## 6. Pauta de devolución (encuentro 27)

- Corrección individual escrita por ítem (qué puntúa, qué no y por qué), con el estado de cada objetivo mínimo de la unidad (U3-1 a U3-4). El encuentro 27 abre con esta devolución, junto con la de la defensa y la verificación de entrega.
- Comentarios generales al curso al abrir la clase: los aciertos más frecuentes (estructura del JOIN triple, existencia antes de consultar) y los errores comunes esperables (paréntesis del filtro de la Parte 3, `ROUND` del promedio, tipos del record contra lo que garantiza el SELECT).
- Los ítems no alcanzados se traducen en el plan de reincorporación de la capa 1 (`criterios-aprobacion.md`): cada alumno marca en su corrección los núcleos a reforzar, con vista a los encuentros especiales 34-35.
- La planilla de resultados registra: alumno, versión A, puntaje por parte (30/25/25/20) y total, resultado de la defensa y estado objetivo por objetivo.
