# Encuentro 22 — Agregaciones y GROUP BY

> Unidad 3 — Integración de datos y publicación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 22 |
| Unidad | 3 — Integración de datos y publicación |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Funciones de agregación `COUNT`, `AVG` y `SUM` con `GROUP BY`; `ORDER BY` sobre el agregado; `LIMIT` parametrizado; `strftime` para agrupar por mes |
| Requisitos previos | Clase 21 completada (JOIN triple con alias calificados, DTO compuesto, verificación de existencia); proyecto `HospitalApi` funcionando |
| Uso de celular | No permitido |
| Grupos | Presentes ÷ equipos disponibles (mínimo posible); rotación de integrantes entre la práctica y la extensión |
| Planificación anual | Encuentro 22: agregaciones COUNT, AVG y SUM con GROUP BY (por especialidad, por mes) |

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

**Apertura y puente (20 min).** Recupero del encuentro anterior: `/admissions/full` devuelve una fila por ingreso, más de 300 filas de detalle. Pregunta disparadora: ¿quién lee 300 filas? El director del hospital no pregunta «mostrame los ingresos»: pregunta «¿cuántos ingresos tuvimos por especialidad?», «¿cuánto dura una internación en promedio?», «¿qué médico atendió más?». Son preguntas de números, no de filas. Hoy la API aprende a responderlas: el motor cuenta, promedia y suma sobre grupos, y devuelve una fila de resumen por grupo.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar qué hace `GROUP BY`: parte las filas en grupos y colapsa cada grupo en una fila de resumen.
2. Escribir agregaciones con `COUNT(*)`, `AVG(...)` y `SUM(...)` combinadas con JOIN y con alias AS hacia el record.
3. Ordenar por el resultado del agregado (`ORDER BY ... DESC`) y cortar la lista con `LIMIT` parametrizado.
4. Agrupar por mes con `strftime('%Y-%m', admission_date)` y exponer el resumen en un endpoint de estadísticas.
5. Calcular la duración de una internación en el motor con `julianday(discharge_date) - julianday(admission_date)`, excluyendo los ingresos sin alta.

## 3. Teoría mínima (40 min)

### Charla rápida: el resumen de la tarjeta

El resumen mensual de una tarjeta de crédito no lista las compras una por una: las agrupa por rubro —supermercado, transporte, farmacia— y al lado de cada rubro pone un total. Nadie suma a mano: el sistema parte las compras en grupos y calcula cada total. `GROUP BY` es exactamente eso: partir las filas por el valor de una columna (`GROUP BY d.specialty` parte los ingresos por especialidad) y calcular algo por grupo (`COUNT(*)` cuenta; `AVG` promedia; `SUM` suma). La respuesta ya no es la lista de compras: es el resumen por rubro.

### Lo mínimo indispensable

**COUNT + GROUP BY.** El par básico de la clase:

```sql
SELECT d.specialty AS Specialty, COUNT(*) AS TotalAdmissions
FROM admissions a
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
GROUP BY d.specialty
ORDER BY TotalAdmissions DESC
```

| Pieza | Qué hace |
| --- | --- |
| `GROUP BY d.specialty` | Un grupo por cada especialidad distinta (13 grupos) |
| `COUNT(*)` | Cuenta las filas de CADA grupo (una fila de resumen por grupo) |
| `ORDER BY TotalAdmissions DESC` | Ordena por el agregado: la especialidad con más ingresos primero |

Sin `GROUP BY`, `COUNT(*)` cuenta TODAS las filas y devuelve un único número. Con `GROUP BY`, devuelve un número por grupo. La columna agrupada y el agregado son las únicas dos cosas que el SELECT puede devolver.

**Médicos con más ingresos: el orden y el corte.** Las consultas gancho del hospital («¿qué médico tuvo más ingresos?») se responden con el agregado ordenado y cortado:

```sql
GROUP BY d.doctor_id
ORDER BY TotalAdmissions DESC
LIMIT @Top
```

`LIMIT` corta la lista a los primeros N (el Top N). Puede llevar parámetro como cualquier valor: `LIMIT @Top` con `new { Top = top }`. Se agrupa por `d.doctor_id` (el identificador, que no se repite) aunque el SELECT muestre el nombre: un grupo por médico real.

**Duración de una internación.** Las fechas viven como texto ISO, y el motor sabe convertirlas a días con `julianday(...)`:

```sql
julianday(discharge_date) - julianday(admission_date)
```

Esa resta es la duración en días de un ingreso. Dos cuidados: los ingresos sin alta (`discharge_date` en `NULL`) no la tienen, entonces se excluyen con `WHERE discharge_date IS NOT NULL`; y el resultado puede llevar decimales, por lo que el promedio se redondea con `ROUND(..., 1)`.

**Por mes.** `strftime` extrae la parte del mes de la fecha ISO:

```sql
strftime('%Y-%m', admission_date) AS Month
```

Agrupar por esa expresión (`GROUP BY strftime('%Y-%m', admission_date)`) da un grupo por mes: los datos cubren 13 meses, de junio de 2018 a junio de 2019.

**El record de resumen.** Igual que siempre: una propiedad por columna del SELECT, con el alias AS como puente. Los agregados numéricos son conteos y medidas: `int` para conteos, `double` para promedios (los ids siguen siendo `long` y las fechas `string`, como en toda la unidad).

```csharp
// Resumen por especialidad: el grupo y su total.
record AdmissionBySpecialty(string Specialty, int TotalAdmissions);
```

## 4. Práctica guiada (70 min)

### Paso 1 — Preparar el proyecto

Reutilizar el proyecto de la clase 21 (o recrearlo: `dotnet new web -n HospitalApi`, paquetes y `hospital.db` en la raíz). Todo el código de hoy reemplaza el contenido de `Program.cs`.

### Paso 2 — Reemplazar Program.cs

Borrar todo y pegar este código completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion canonica: hospital.db junto al .csproj.
var connectionString = "Data Source=hospital.db";

// GET /stats/admissions-by-specialty: ingresos por especialidad (las preguntas
// de numeros se responden en el motor, no en C#).
app.MapGet("/stats/admissions-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<AdmissionBySpecialty>(@"
        SELECT d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        GROUP BY d.specialty
        ORDER BY TotalAdmissions DESC").ToList();

    return Results.Ok(stats);
});

// GET /stats/top-doctors/{top}: los medicos con mas ingresos (Top N).
// LIMIT lleva parametro: el valor llega por el objeto anonimo.
app.MapGet("/stats/top-doctors/{top:int}", (int top) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<DoctorAdmissions>(@"
        SELECT d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        GROUP BY d.doctor_id
        ORDER BY TotalAdmissions DESC
        LIMIT @Top",
        new { Top = top }).ToList();

    return Results.Ok(doctors);
});

// GET /stats/stay: las tres agregaciones sobre la duracion de internacion.
// COUNT cuenta los ingresos con alta, AVG promedia sus dias y SUM los suma.
// Los ingresos sin alta (discharge_date NULL) no tienen duracion: se excluyen.
app.MapGet("/stats/stay", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // La consulta agregada sin GROUP BY devuelve SIEMPRE una sola fila:
    // FirstOrDefault la mapea al record.
    var stay = connection.QueryFirstOrDefault<StayStats>(@"
        SELECT COUNT(*) AS DischargedAdmissions,
               ROUND(AVG(julianday(discharge_date) - julianday(admission_date)), 1) AS AvgDays,
               CAST(SUM(julianday(discharge_date) - julianday(admission_date)) AS INTEGER) AS TotalDays
        FROM admissions
        WHERE discharge_date IS NOT NULL");

    return Results.Ok(stay);
});

// GET /stats/by-month: ingresos por mes (13 meses de datos).
// strftime('%Y-%m', ...) extrae el mes de la fecha ISO.
app.MapGet("/stats/by-month", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var months = connection.Query<MonthlyAdmissions>(@"
        SELECT strftime('%Y-%m', admission_date) AS Month,
               COUNT(*) AS Count
        FROM admissions
        GROUP BY strftime('%Y-%m', admission_date)
        ORDER BY Month").ToList();

    return Results.Ok(months);
});

app.Run();

// Los records van SIEMPRE al final del archivo, despues de app.Run().
// Resumen por especialidad: el grupo y su total.
record AdmissionBySpecialty(string Specialty, int TotalAdmissions);

// Resumen por medico: el grupo es el id (no se repite), el nombre se muestra.
record DoctorAdmissions(string DoctorName, string Specialty, int TotalAdmissions);

// Estadistica de internacion: conteo, promedio y suma de dias.
record StayStats(int DischargedAdmissions, double AvgDays, int TotalDays);

// Resumen por mes: el mes como texto "YYYY-MM" y su total.
record MonthlyAdmissions(string Month, int Count);
```

### Paso 3 — Levantar la API

```powershell
dotnet run
```

### Paso 4 — Probar los cuatro endpoints en el navegador

- `http://localhost:5080/stats/admissions-by-specialty` → 200 con 13 filas (una por especialidad), ordenadas de mayor a menor.
- `http://localhost:5080/stats/top-doctors/5` → 200 con los 5 médicos con más ingresos. Probar también `/stats/top-doctors/1` (el gancho: «¿qué médico tuvo más ingresos?») y `/stats/top-doctors/100` (devuelve los 27 que hay: `LIMIT` corta, nunca inventa).
- `http://localhost:5080/stats/stay` → 200 con UN objeto: ingresos con alta, promedio de días y suma total de días.
- `http://localhost:5080/stats/by-month` → 200 con 13 filas, de `2018-06` a `2019-06`.

### Paso 5 — Experimento: quitar el GROUP BY

1. En `/stats/admissions-by-specialty`, borrar la línea `GROUP BY d.specialty`.
2. Reiniciar y pedir el endpoint → 500. La terminal muestra la causa: `SQLite Error: '... d.specialty ...'` (una columna agrupada sin GROUP BY no tiene sentido para el motor).
3. Reponer el `GROUP BY` y verificar que vuelve a funcionar. Conclusión: el SELECT de una agregación solo puede contener la columna de agrupación y agregados.

### Salidas esperadas

**GET /stats/admissions-by-specialty** → 200 con 13 filas (estructura; los totales concretos se constatan en clase y se anotan en el anexo):

```json
[
  {
    "specialty": "Cardiologist",
    "totalAdmissions": 41
  },
  {
    "specialty": "General Surgeon",
    "totalAdmissions": 33
  }
]
```

**GET /stats/top-doctors/1** → 200 con una sola fila: el médico con más ingresos, con `doctorName`, `specialty` y `totalAdmissions`.

**GET /stats/stay** → 200 con un objeto:

```json
{
  "dischargedAdmissions": 278,
  "avgDays": 7.3,
  "totalDays": 2029
}
```

**GET /stats/by-month** → 200 con 13 filas:

```json
[
  {
    "month": "2018-06",
    "count": 22
  },
  {
    "month": "2018-07",
    "count": 30
  }
]
```

Observación sobre `/stats/stay`: el promedio de días de internación puede resultar más bajo de lo que esperarían mirando el detalle de la base. No es un error del cálculo: hay fechas de alta imposibles mezcladas entre los datos reales (altas del año 1971, anteriores al propio ingreso). La clase 23 construye exactamente las herramientas para detectarlas y filtrarlas; por hoy, anotar la observación.

## 5. Ejercicio independiente (50 min)

Trabajo por grupos: presentes ÷ equipos disponibles, un equipo por PC. Rotación de roles a mitad del bloque: quien observa y anota los totales pasa a conducir.

### Consigna

Agregar al mismo proyecto dos endpoints de estadística propios:

1. `GET /stats/gender`: los pacientes agrupados por sexo — por cada grupo, la cantidad de pacientes y la altura promedio (en cm). Un solo endpoint, un record con tres propiedades: el grupo, el conteo y el promedio.
2. `GET /stats/doctors-by-specialty`: cuántos médicos hay por especialidad (la tabla `doctors` completa, sin JOIN: son 27 filas y 13 grupos).

### Pista

El punto 1 es el molde de `/stats/admissions-by-specialty` cambiando la tabla base (`FROM patients`, sin JOIN), la columna de agrupación (`GROUP BY gender`) y el agregado (`COUNT(*)` y `AVG(height)`; el promedio conviene redondearlo con `ROUND(..., 1)`). El punto 2 es el mismo molde sobre `doctors`. El record del punto 1: el promedio es `double` porque es medida, no conteo. La solución completa está en el anexo docente.

## 6. Extensión y consolidación (45 min)

Para los grupos que completan la consigna base. Los demás consolidan terminando el ejercicio con acompañamiento.

1. **El gancho del mes.** `GET /stats/top-months`: los 3 meses con más ingresos — la consulta de `/stats/by-month` con `ORDER BY Count DESC LIMIT 3`. Comparar en vivo: el mismo GROUP BY responde «la serie completa» y «el podio», solo cambia el orden y el corte.
2. **Filtrar grupos con HAVING.** `GET /stats/specialties-over/{min:int}`: solo las especialidades con MÁS de `min` ingresos. La diferencia con `WHERE`: `WHERE` filtra filas ANTES de agrupar; `HAVING` filtra grupos DESPUÉS de agregar. Probar con `/stats/specialties-over/30`.
3. **Consolidación: el cuadro de agregaciones.** Cada grupo completa en papel una tabla de tres columnas — pregunta del hospital / función de agregación / GROUP BY — con los cinco endpoints de la unidad vistos hoy. Rotación: completa la tabla quien no condujo el teclado. Ese cuadro es el material de repaso para la evaluación de la unidad.

## 7. Cierre (15 min)

### Qué te llevás

- `GROUP BY` parte las filas en grupos y las funciones de agregación colapsan cada grupo en una fila de resumen: `COUNT` cuenta, `AVG` promedia, `SUM` suma.
- El SELECT de una agregación solo admite la columna de agrupación y agregados; sin `GROUP BY`, el agregado cubre toda la tabla en una sola fila.
- Las preguntas gancho del hospital se resuelven con orden y corte sobre el agregado: `ORDER BY TotalAdmissions DESC LIMIT @Top`, con el `LIMIT` parametrizado como cualquier valor.
- La duración de una internación se calcula en el motor con `julianday(discharge_date) - julianday(admission_date)`, excluyendo los ingresos sin alta con `IS NOT NULL`; el mes se extrae con `strftime('%Y-%m', ...)`.
- Un dato raro en el promedio (`avgDays` más bajo de lo esperado) no es un bug del endpoint: es la base real avisando que tiene datos sucios. La clase 23 los caza.

### Lo que viene

Encuentro 23: «Subconsultas simples; datos sucios reales (valores NULL, errores de tipeo, fechas erróneas): robustez y manejo de errores». Hoy las consultas respondieron con números limpios sobre una base que no lo es: altas nulas, diagnósticos mal tipeados («Stomache Pain») y fechas imposibles de 1971. La clase 23 agrega dos herramientas: la consulta dentro de la consulta (subconsulta) y el control de calidad sobre los datos antes de exponerlos.

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 22: agregaciones y group by"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| `SQLite Error: columna no válida en el SELECT agregado` | El SELECT mezcla la columna de agrupación con columnas sueltas sin agregado | El SELECT solo lleva la columna del GROUP BY y agregados (`COUNT`, `AVG`, `SUM`) |
| Promedio de días absurdo (negativo o cercano a cero) | Las altas imposibles de 1971 entran al promedio | Por hoy, dejar la observación anotada: la clase 23 introduce el filtro (`discharge_date >= admission_date`) |
| El Top N devuelve más filas que N | Falta el `LIMIT @Top` o quedó sin su parámetro | `LIMIT @Top` + `new { Top = top }`, y la ruta con restricción `{top:int}` |
| Duración que incluye ingresos sin alta | Falta `WHERE discharge_date IS NOT NULL`: `julianday(NULL)` resta `NULL` y arrastra el agregado | Excluir los sin alta antes de promediar o sumar |
| Promedio con muchos decimales en el JSON | `AVG` devuelve el valor exacto sin redondear | Envolver con `ROUND(AVG(...), 1)` y mapear a `double` |
| Agrupar médicos por nombre (`GROUP BY DoctorName`) | Dos médicos pueden llamarse igual; el nombre es texto, no identidad | Agrupar por la clave (`GROUP BY d.doctor_id`) y mostrar el nombre con el `||` y su alias |
