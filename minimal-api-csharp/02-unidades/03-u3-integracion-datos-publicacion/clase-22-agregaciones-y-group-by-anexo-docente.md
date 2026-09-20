# Anexo docente — Encuentro 22: agregaciones y GROUP BY

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 3 — Integración de datos y publicación

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 22 — Agregaciones COUNT, AVG y SUM con GROUP BY (por especialidad, por mes) (planificación anual) |
| Ejercicio evaluado | `GET /stats/gender` (GROUP BY + COUNT + AVG sobre `patients`) y `GET /stats/doctors-by-specialty` (GROUP BY sin JOIN) |
| Momento del bloque | Ejercicio independiente (50 min) + extensión y consolidación (45 min) + cierre (15 min) |
| Insumos | Proyecto `HospitalApi` de la práctica guiada funcionando, con `hospital.db` en la raíz y los paquetes Microsoft.Data.Sqlite + Dapper instalados |

## Preparación previa (gestión del aula)

- Ejecutar antes de clase los cuatro endpoints de la práctica y anotar los valores reales: ranking completo de especialidades, el médico del top 1 con su total, los valores de `/stats/stay` y los totales por mes. Son los valores contra los que se valida todo el encuentro en vivo.
- Calcular aparte el promedio de días con las altas imposibles excluidas (`WHERE discharge_date IS NOT NULL AND discharge_date >= admission_date`): la diferencia con el promedio «sucio» de `/stats/stay` es el argumento concreto con el que se cierra la observación del encuentro y se abre la clase 23.
- Verificar que los equipos conservan el proyecto de la clase 21; quien lo haya perdido recrea el proyecto en el paso 1 con el DTO y un endpoint de la práctica anterior.
- Tener a mano las consultas gancho del curso (médico con más ingresos, mes con más ingresos, especialidad que más atiende) para nombrar cuál se respondió con cada endpoint.

## Solución esperada

Ambos endpoints van en el `Program.cs` de la práctica, antes de `app.Run()`; los records, al final del archivo.

Punto 1 — pacientes agrupados por sexo, con conteo y altura promedio:

```csharp
// Solucion del ejercicio (1): pacientes por sexo con altura promedio.
app.MapGet("/stats/gender", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<GenderStats>(@"
        SELECT gender AS Gender,
               COUNT(*) AS Patients,
               ROUND(AVG(height), 1) AS AvgHeight
        FROM patients
        GROUP BY gender
        ORDER BY Patients DESC").ToList();

    return Results.Ok(stats);
});
```

```csharp
// Grupo, conteo y promedio: una propiedad por columna del SELECT.
record GenderStats(string Gender, int Patients, double AvgHeight);
```

Punto 2 — médicos por especialidad, sin JOIN:

```csharp
// Solucion del ejercicio (2): cuantos medicos hay por especialidad.
app.MapGet("/stats/doctors-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<SpecialtyDoctorCount>(@"
        SELECT specialty AS Specialty,
               COUNT(*) AS Total
        FROM doctors
        GROUP BY specialty
        ORDER BY Total DESC, Specialty").ToList();

    return Results.Ok(stats);
});
```

```csharp
// Conteo por grupo sin JOIN: la tabla base ya tiene la columna del grupo.
record SpecialtyDoctorCount(string Specialty, int Total);
```

Pedidos de prueba:

```http
### Pacientes por sexo con altura promedio (esperar 200 con 2 filas: M y F)
GET http://localhost:5080/stats/gender

### Medicos por especialidad (esperar 200 con hasta 13 filas)
GET http://localhost:5080/stats/doctors-by-specialty
```

Respuestas esperadas:

- `/stats/gender` → 200 con dos filas (`M` y `F`). El conteo y el promedio concretos se constatan en la preparación previa. `AVG(height)` ignora las filas con altura `NULL` (no las cuenta como cero): es exactamente el comportamiento de `AVG` que conviene nombrar en la corrección.
- `/stats/doctors-by-specialty` → 200 con una fila por especialidad con médicos (la mayoría de las 13; verificar si alguna queda fuera, porque no tiene médicos). El empate se desempata por nombre (`ORDER BY Total DESC, Specialty`) para que el orden sea estable entre corridas.

Detalles clave de la solución:

- El punto 1 evalúa combinar DOS agregados con un solo GROUP BY y mapear tipos: `COUNT` a `int`, `AVG` a `double`. Quien declara el promedio como `int` pierde los decimales del ROUND y el dato deja de ser promedio.
- El punto 2 evalúa reconocer que la agregación no siempre necesita JOIN: la columna del grupo ya vive en la tabla base. Es el mismo molde, no un problema nuevo.

## Solución de la extensión

Punto 1 — el gancho del mes (podio de meses):

```csharp
// Extension (1): los 3 meses con mas ingresos (el gancho del mes).
app.MapGet("/stats/top-months", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var months = connection.Query<MonthlyAdmissions>(@"
        SELECT strftime('%Y-%m', admission_date) AS Month,
               COUNT(*) AS Count
        FROM admissions
        GROUP BY strftime('%Y-%m', admission_date)
        ORDER BY Count DESC
        LIMIT 3").ToList();

    return Results.Ok(months);
});
```

Punto 2 — filtrar grupos con HAVING:

```csharp
// Extension (2): solo los grupos que superan el minimo (HAVING filtra grupos).
app.MapGet("/stats/specialties-over/{min:int}", (int min) =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<AdmissionBySpecialty>(@"
        SELECT d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        GROUP BY d.specialty
        HAVING COUNT(*) > @Min
        ORDER BY TotalAdmissions DESC",
        new { Min = min }).ToList();

    return Results.Ok(stats);
});
```

- `/stats/top-months` → 200 con exactamente 3 filas, encabezadas por el mes con más ingresos (valor constatado en la preparación previa). Es la respuesta directa al gancho «¿qué mes tuvo más ingresos?».
- `/stats/specialties-over/30` → 200 solo con las especialidades que superan los 30 ingresos. Comparar con las 13 filas de `/stats/admissions-by-specialty`: HAVING achicó la lista, WHERE no podía hacerlo porque filtra filas antes de agrupar.

Punto 3 (cuadro de agregaciones): no lleva código. Verificar que cada grupo completó las cinco filas — ingresos por especialidad (COUNT + GROUP BY), Top N médicos (COUNT + ORDER BY + LIMIT), estadística de estadía (COUNT/AVG/SUM), serie por mes (COUNT + strftime) y los ejercicios propios — y guardar el cuadro: es material de repaso directo para la prueba de la Unidad 3.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | `GET /stats/gender` devuelve grupos, no filas | 200 con dos filas (`M`, `F`), una por valor de `gender`, con `patients` y `avgHeight` |
| 2 | Tipos correctos en el record del ejercicio | `int Patients` (conteo) y `double AvgHeight` (promedio, con decimales del ROUND) |
| 3 | `GET /stats/doctors-by-specialty` agrupa sin JOIN | `FROM doctors ... GROUP BY specialty`, una fila por especialidad |
| 4 | ORDER BY sobre el agregado en ambos endpoints | Orden descendente por el total; el empate resuelto con criterio explícito |
| 5 | Consultas parametrizadas y DTOs con alias AS | Sin concatenación de strings; una columna con alias AS por propiedad |
| 6 | Canon de estructura | Records al final del archivo, `Results.Ok` explícito, comentarios en español sin tildes |
| 7 | Cierre con rutina Git | `git log` muestra el commit "Clase 22: agregaciones y group by" y el push al remoto |

## Qué observar en el aula

- **El experimento de quitar el GROUP BY (paso 5) enseña el límite del SELECT agregado.** Todos deben verlo y leerlo; es el error más repetido del tema.
- **La anomalía de `/stats/stay` es el puente hacia la clase 23.** Dejar que los grupos la descubran solos («¿el promedio no les parece bajo?»), validar la observación y comprometer la resolución para el próximo encuentro. No adelantar la solución: la sorpresa es parte del diseño de la unidad.
- **Distinguir en la corrección conteo de promedio:** `COUNT` nunca lleva ROUND ni decimales; `AVG` casi siempre los quiere. Es la confusión de tipos más frecuente del ejercicio.
- **Sondeo rápido:** ¿por qué `GROUP BY d.doctor_id` y no por nombre? (identidad, no texto). ¿Qué filtra antes de agrupar y qué después? (WHERE y HAVING). ¿Cuántas filas devuelve una consulta agregada sin GROUP BY? (una).
- **Señal de alerta:** `avgHeight` con muchos decimales (falta ROUND) o `patients` en 0 para un sexo (algo filtró filas en vez de grupos).

## Errores previsibles y respuestas

- *Error de columna en el SELECT agregado* → Columna suelta sin agregado ni GROUP BY. Intervención: preguntar qué representa esa columna para un grupo entero; no hay respuesta, por eso el motor la rechaza.
- *Promedio sin decimales* → Propiedad `int` para `AvgHeight`. Intervención: cambiar a `double` y comparar la salida antes y después.
- *LIMIT sin efecto* → Parámetro no pasado en el objeto anónimo. Intervención: recordar el par marcador `@Top` + `new { Top = top }`; el corte es un valor como cualquier otro.
- *`HAVING COUNT(*) > @Min` tipeado como `WHERE`* → WHERE filtra filas y el conteo no existe todavía. Intervención: dibujar la línea de tiempo de la consulta: filas → WHERE → grupos → HAVING → ORDER/LIMIT.
- *Grupo que termina antes* → Derivar a la extensión (podio de meses y HAVING) y encargarle anotar el top 1 real del gancho para la corrección en el pizarrón.
