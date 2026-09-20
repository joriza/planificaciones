# Anexo docente — Encuentro 23: subconsultas y datos sucios

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 3 — Integración de datos y publicación

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 23 — Subconsultas simples; datos sucios reales (NULL, errores de tipeo, fechas erróneas): robustez y manejo de errores (planificación anual) |
| Ejercicio evaluado | `GET /patients/never-admitted` (subconsulta con `NOT IN`) y `GET /admissions/long-stays/{days}` (gancho de internaciones largas con alta verdadera) |
| Momento del bloque | Ejercicio independiente (50 min) + extensión y consolidación (45 min) + cierre (15 min) |
| Insumos | Proyecto `HospitalApi` de la práctica guiada funcionando, con `hospital.db` en la raíz y los paquetes Microsoft.Data.Sqlite + Dapper instalados |
| Deuda pedagógica previa | Cerrar al inicio la observación de la clase 22 (promedio «extraño» de `/stats/stay`): el puente del encuentro es la causa de esa anomalía |

## Preparación previa (gestión del aula)

- Ejecutar antes de clase las consultas del encuentro y anotar cantidades reales: pacientes con más de N ingresos (probar N = 0, 1 y 2), ranking de `/stats/seniors-by-specialty`, cantidad de ingresos abiertos, de typos por variante y de altas imposibles (incluidas las de `1971-01-05`). Estas cantidades son la contracara de verificación de todo el encuentro.
- Verificar en la base los casos visibles que van a aparecer en vivo: un diagnóstico «Stomache Pain», un «Amigima», un «Rheumataoid Arthritis» y al menos una alta de 1971, para poder señalarlos sin buscarlos en el momento.
- Identificar un `patient_id` cuya historia muestre los tres estados (ingreso cerrado normal, abierto y alta imposible) para el experimento del paso 5; si no existe uno solo que los reúna, usar dos pacientes distintos y mostrar ambos.
- Repasar la convención de edad por año (`strftime('%Y', ...)`) y tener a mano la aclaración: es una aproximación por año de nacimiento, suficiente para agrupar en 60+, no un cálculo de edad exacta.

## Solución esperada

Ambos endpoints van en el `Program.cs` de la práctica, antes de `app.Run()`; los records, al final del archivo.

Punto 1 — pacientes que nunca tuvieron un ingreso:

```csharp
// Solucion del ejercicio (1): pacientes sin NINGUN ingreso (NOT IN).
app.MapGet("/patients/never-admitted", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientBrief>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName
        FROM patients p
        WHERE p.patient_id NOT IN (
                SELECT a.patient_id
                FROM admissions a)
        ORDER BY p.last_name, p.first_name").ToList();

    return Results.Ok(patients);
});
```

```csharp
// DTO propio del ejercicio: id, nombre y apellido del paciente.
record PatientBrief(long PatientId, string FirstName, string LastName);
```

Punto 2 — internaciones de más de N días, solo con alta verdadera:

```csharp
// Solucion del ejercicio (2): internaciones largas (el gancho: mas de 10 dias).
// La duracion se calcula en el motor por fila y la alta debe ser verdadera.
app.MapGet("/admissions/long-stays/{days:int}", (int days) =>
{
    using var connection = new SqliteConnection(connectionString);

    var stays = connection.Query<LongStay>(@"
        SELECT a.patient_id AS PatientId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               CAST(julianday(a.discharge_date) - julianday(a.admission_date) AS INTEGER) AS Days
        FROM admissions a
        WHERE a.discharge_date IS NOT NULL
          AND a.discharge_date >= a.admission_date
          AND a.discharge_date NOT LIKE '1971-%'
          AND (julianday(a.discharge_date) - julianday(a.admission_date)) > @Days
        ORDER BY Days DESC",
        new { Days = days }).ToList();

    return Results.Ok(stays);
});
```

```csharp
// Internacion larga: el ingreso y su duracion calculada en dias.
record LongStay(long PatientId, string AdmissionDate, string DischargeDate, int Days);
```

Pedidos de prueba:

```http
### Pacientes sin ingresos (esperar 200 con la lista, ordenada por apellido)
GET http://localhost:5080/patients/never-admitted

### Internaciones de mas de 10 dias (esperar 200; el gancho del hospital)
GET http://localhost:5080/admissions/long-stays/10

### Caso borde: mas de 0 dias (esperar 200 con todas las internaciones validas)
GET http://localhost:5080/admissions/long-stays/0
```

Respuestas esperadas:

- `/patients/never-admitted` → 200 con los pacientes sin ningún ingreso (cantidad a constatar en la preparación previa; hay pacientes de los 258 que nunca ingresaron). Con `/patients/multiple-admissions/0` de la práctica se verifica el complemento: «los que ingresaron» y «los que nunca ingresaron» suman 258.
- `/admissions/long-stays/10` → 200 con las internaciones de más de 10 días reales, la más larga primero. Es la respuesta directa al gancho «¿quiénes estuvieron internados más de 10 días?». Verificar que NINGUNA fila muestre una alta de 1971 o anterior al ingreso: si aparece, falta una de las tres condiciones del WHERE.
- `/admissions/long-stays/0` → 200 con todas las internaciones cerradas válidas: el corte `> @Days` con 0 se comporta como «cualquier duración positiva».

Detalles clave de la solución:

- El punto 1 evalúa la subconsulta como lista (`NOT IN`) y el punto 2 combina la duración calculada de la clase 22 con el filtro de alta verdadera de la práctica. Ambos reutilizan exactamente las herramientas del encuentro: quien inventa una lógica nueva en C# para filtrar (traer todo y filtrar en la lista) está resolviendo en el lugar equivocado.
- El error sutil del punto 2: calcular la duración con la columna con alias (`Days`) dentro del WHERE. En SQLite no conviene: repetir la expresión `julianday(...) - julianday(...)` es la forma segura y es lo que se espera en la corrección.

## Solución de la extensión

Punto 1 — radiografía de la base: tres subconsultas escalares en un solo SELECT:

```csharp
// Extension (1): informe de calidad de datos en una sola fila.
record DataQualityReport(int OpenAdmissions, int StrangeDischarges, int SuspiciousDiagnoses);
```

```csharp
// Solucion de la extension: tres conteos de auditoria, un endpoint.
app.MapGet("/admissions/data-quality", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var report = connection.QueryFirstOrDefault<DataQualityReport>(@"
        SELECT (SELECT COUNT(*)
                FROM admissions
                WHERE discharge_date IS NULL) AS OpenAdmissions,
               (SELECT COUNT(*)
                FROM admissions
                WHERE discharge_date IS NOT NULL
                  AND (discharge_date < admission_date
                       OR discharge_date LIKE '1971-%')) AS StrangeDischarges,
               (SELECT COUNT(*)
                FROM admissions
                WHERE diagnosis LIKE '%Stomache%'
                   OR diagnosis LIKE '%Amigima%'
                   OR diagnosis LIKE '%Rheumataoid%') AS SuspiciousDiagnoses");

    return Results.Ok(report);
});
```

`/admissions/data-quality` → 200 con una fila, por ejemplo `{"openAdmissions":28,"strangeDischarges":7,"suspiciousDiagnoses":6}` (los valores exactos se constatan en la preparación previa y deben coincidir con los endpoints individuales de la práctica: es la validación cruzada del informe).

Punto 2 (mapa de la unidad) y punto 3 (discusión corregir/exponer): no llevan código. Registrar las posiciones de cada grupo en la discusión con su justificación; el criterio de cierre esperado: la API expone y reporta, la corrección de la base es tarea de quien la administra — pero cualquier postura defendida vale, porque el objetivo es argumentar con la evidencia de los endpoints.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | `GET /patients/never-admitted` con subconsulta `NOT IN` | 200 con los pacientes sin ingresos; el complemento con `/patients/multiple-admissions/0` suma los 258 |
| 2 | DTO propio con tipos canónicos | `PatientBrief(long PatientId, ...)`; ids `long`, fechas `string` en todo el archivo |
| 3 | `GET /admissions/long-stays/{days}` responde el gancho | `/long-stays/10` → 200 con las internaciones de más de 10 días, ordenadas por duración |
| 4 | Alta verdadera verificada en el filtro | `IS NOT NULL` + `>= admission_date` + `NOT LIKE '1971-%'` presentes en el WHERE |
| 5 | Duración calculada en el motor | `julianday(discharge_date) - julianday(admission_date)` con alias AS; sin filtros en C# |
| 6 | Robustez general del archivo | Consultas parametrizadas, `Results.Ok`/`Results.NotFound`, records al final, comentarios en español sin tildes |
| 7 | Cierre con rutina Git | `git log` muestra el commit "Clase 23: subconsultas y datos sucios" y el push al remoto |

## Qué observar en el aula

- **Cerrar primero la deuda de la clase 22.** El experimento del paso 5 y `/admissions/strange-discharges` explican el promedio bajo de `/stats/stay`; nombrar explícitamente que la promesa se cumplió cierra el arco narrativo de la unidad.
- **El 404 del endpoint robusto se prueba SIEMPRE** (`/patients/9999/admissions`): es el mismo patrón de existencia de la clase 21, ahora sobre el endpoint limpio. Su ausencia es el descuento más frecuente.
- **La discusión del punto 3 (corregir o exponer) es evaluación formativa pura:** escuchar si los argumentos citan la evidencia (los conteos de la auditoría) o quedan en impresiones. Anotar las posturas: reaparecen en la defensa de la Unidad 3.
- **Señal de alerta:** historias que muestran `1971-01-05` después del «arreglo» (el filtro quedó mal parenizado), y `long-stays` que incluye altas imposibles (una de las tres condiciones del WHERE falta).
- **Sondeo rápido:** ¿qué devuelve `= NULL` como comparación? (nunca verdadero). ¿Qué garantiza `COALESCE` para el tipo del record? (valor no nulo → `string` sin `?`). ¿Cuál de los dos tipos de subconsulta usó cada endpoint del ejercicio? (`NOT IN` lista; conteo escalar en la práctica).

## Errores previsibles y respuestas

- *`never-admitted` devuelve vacío o todos* → `IN` en lugar de `NOT IN` (o el paréntesis de la subconsulta mal cerrado). Intervención: leer la consulta en voz alta: «pacientes cuyo id NO esté en la lista de ingresos».
- *`long-stays` con altas de 1971 incluidas* → Falta una de las tres condiciones de alta verdadera. Intervención: comparar el WHERE del grupo contra el de la práctica línea por línea.
- *`Days` negativo o enorme* → La resta con `julianday` sobre altas imposibles: el filtro y el cálculo deben convivir en el mismo WHERE. Intervención: mostrar la fila culpable con `/admissions/strange-discharges`.
- *`mensaje` 404 ausente en el endpoint robusto* → Se borró la verificación de existencia al reemplazar el endpoint de la clase 21. Intervención: probar id 9999 en vivo; el orden verificación → consulta es diseño, no adorno.
- *Grupo que termina antes* → Derivar a la extensión (radiografía de la base) y encargarle la validación cruzada: los tres conteos del informe contra los endpoints individuales.
