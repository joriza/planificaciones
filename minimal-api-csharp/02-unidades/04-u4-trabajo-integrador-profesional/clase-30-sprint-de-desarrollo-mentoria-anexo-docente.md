# Anexo docente — Encuentro 30: sprint de desarrollo mentorizado

> Registro docente formal. Documento interno del docente: no se entrega a los alumnos.

| Campo | Detalle |
| --- | --- |
| Encuentro | 30 — Unidad didáctica 4 (4 de 5) |
| Contenido | Sprint mentorizado; endpoint modelado con subconsulta; integración continua vía PRs |
| Insumos | Issues abiertos de cada grupo; consigna canónica (encuentro 27); checklist de revisión (encuentro 29) |

## 1. Solución de referencia: endpoint modelado `/admissions/long-stays`

Fragmento completo como queda en `Program.cs` (el endpoint antes de `app.Run()`, el record al final). Asume el `connectionString` canonico ya declarado en el encuentro 27.

```csharp
// GET /admissions/long-stays?days=10: ingresos largos de pacientes con reingresos
app.MapGet("/admissions/long-stays", (int? days) =>
{
    // Validacion manual del parametro: sin days (o no positivo) no hay estadistica
    if (days is null || days <= 0)
    {
        return Results.BadRequest(new { mensaje = "Indique una cantidad de dias positiva, por ejemplo ?days=10" });
    }

    using var connection = new SqliteConnection(connectionString);

    var stays = connection.Query<LongStay>(
        @"SELECT p.first_name || ' ' || p.last_name AS PatientName,
                 a.admission_date AS AdmissionDate,
                 a.discharge_date AS DischargeDate,
                 CAST(julianday(a.discharge_date) - julianday(a.admission_date) AS int) AS StayDays
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          WHERE a.patient_id IN (
                    SELECT patient_id FROM admissions
                    GROUP BY patient_id
                    HAVING COUNT(*) > 1)
            AND a.discharge_date IS NOT NULL
            AND (julianday(a.discharge_date) - julianday(a.admission_date)) >= @days
          ORDER BY StayDays DESC",
        new { days });

    return Results.Ok(stays);
});

app.Run();

// ---- Records: SIEMPRE al final ----
record LongStay(string PatientName, string AdmissionDate, string? DischargeDate, int StayDays);
```

Pruebas con resultados esperados:

| Comando | Respuesta esperada |
| --- | --- |
| `curl "http://localhost:5080/admissions/long-stays?days=10"` | 200 con arreglo JSON ordenado por `stayDays` descendente; los valores concretos dependen de la base del grupo |
| `curl -i http://localhost:5080/admissions/long-stays` | 400 con `{"mensaje":"Indique una cantidad de dias positiva, por ejemplo ?days=10"}` |
| `curl -i "http://localhost:5080/admissions/long-stays?days=0"` | 400 con el mismo mensaje |
| `curl -i "http://localhost:5080/admissions/long-stays?days=abc"` | 400 generado por el propio framework (no se puede convertir el texto a número) |

Puntos didácticos para narrar en el modelado:

1. **La subconsulta resuelve dos preguntas en una:** «¿qué pacientes se internaron más de una vez?» (la subconsulta) y «¿cuánto duró cada estadía de esos pacientes?» (el JOIN con el cálculo).
2. **`julianday` y el canon de fechas:** las fechas siguen siendo `string` ISO en el record; el cálculo ocurre en la consulta, no en C#.
3. **La suciedad también estadifica:** las altas `'1971-01-05'` dan estadía negativa y quedan fuera del filtro; los ingresos sin alta se excluyen con `IS NOT NULL`. Conectar con el requisito (e): los datos sucios no se esconden, se explican.
4. **Respuesta 200 aunque la lista venga vacía:** una estadística sin filas es un resultado válido, no un error (a diferencia de la búsqueda del requisito c, donde la ausencia de coincidencia es 404 por criterio de la consigna).

## 2. Soluciones de referencia para mentoría de los requisitos abiertos

Material de apoyo para desbloquear a los grupos durante el sprint sin resolverles el trabajo.

### Requisito (c) — búsqueda con LIKE (si algún grupo la traba)

Validación manual del término, `LIKE` con patrón parametrizado `@filter = $"%{term}%"`, 400 sin término, 404 sin coincidencias. El desarrollo completo está modelado en la práctica guiada del encuentro 28.

### Requisito (d) — alta y baja validadas

Solución de referencia del docente (los grupos la construyen con sus validaciones):

```csharp
// POST /patients: alta de paciente con validaciones (201 / 400)
app.MapPost("/patients", (PatientInput input) =>
{
    // Validaciones manuales: obligatorios, genero y fecha
    if (string.IsNullOrWhiteSpace(input.FirstName) || string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Gender) || string.IsNullOrWhiteSpace(input.BirthDate))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos obligatorios del paciente" });
    }
    if (input.Gender != "M" && input.Gender != "F")
    {
        return Results.BadRequest(new { mensaje = "El genero debe ser M o F" });
    }
    if (!DateTime.TryParseExact(input.BirthDate, "yyyy-MM-dd", null,
            System.Globalization.DateTimeStyles.None, out _))
    {
        return Results.BadRequest(new { mensaje = "La fecha debe tener formato yyyy-MM-dd" });
    }

    using var connection = new SqliteConnection(connectionString);

    // La provincia debe existir en la tabla de referencia
    var province = connection.QueryFirstOrDefault<long?>(
        "SELECT province_id FROM province_names WHERE province_id = @provinceId",
        new { input.ProvinceId });
    if (province is null)
    {
        return Results.BadRequest(new { mensaje = "La provincia indicada no existe" });
    }

    // Insert parametrizado; last_insert_rowid() devuelve el id recien creado
    var newId = connection.ExecuteScalar<long>(
        @"INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
          VALUES (@FirstName, @LastName, @Gender, @BirthDate, @City, @ProvinceId, @Allergies, @Height, @Weight);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Gender, input.BirthDate,
              input.City, input.ProvinceId, input.Allergies, input.Height, input.Weight });

    // 201 con la URL del recurso nuevo
    return Results.Created($"/patients/{newId}", new { id = newId, input.FirstName, input.LastName });
});

// DELETE /patients/{id}: baja con reglas (204 / 400 / 404)
app.MapDelete("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var exists = connection.QueryFirstOrDefault<long?>(
        "SELECT patient_id FROM patients WHERE patient_id = @id", new { id });
    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    // Regla de negocio: no se da de baja a un paciente con ingresos
    var admissions = connection.ExecuteScalar<long>(
        "SELECT COUNT(*) FROM admissions WHERE patient_id = @id", new { id });
    if (admissions > 0)
    {
        return Results.BadRequest(new { mensaje = "El paciente tiene ingresos registrados" });
    }

    connection.Execute("DELETE FROM patients WHERE patient_id = @id", new { id });
    return Results.NoContent();
});
```

```csharp
// ---- Records: al final del archivo ----
record PatientInput(string FirstName, string LastName, string Gender, string BirthDate,
    string? City, string ProvinceId, string? Allergies, int? Height, int? Weight);
```

### Requisito (e) — dato sucio

Comparación directa de fechas ISO como texto (`WHERE discharge_date < admission_date`); con las filas reales de alta `'1971-01-05'` el endpoint devuelve resultados verificables. Desarrollo modelado en la matriz de la consigna (anexo del encuentro 27).

## 3. Plan de acompañamiento decreciente (GRR del sprint)

| Ronda | Bloque | Rol docente | Intervención permitida |
| --- | --- | --- | --- |
| 1 | Primer tercio | Yo hago / hacemos: modelado narrado del ciclo completo | Preguntas guía antes de respuestas; no se toca el teclado del grupo |
| 2 | Segundo tercio | Hacemos: control de avance por muestra | Cada grupo muestra un PR fusionado y explica una decisión; corrección por demostración |
| 3 | Último tercio | Hacés vos: desbloqueo puntual | Solo trabas reales; la pregunta debe venir con lo intentado y el error exacto |

Señales de alerta para intensificar apoyo: grupo con cero merges al segundo tercio; PRs aprobados sin revisión real; `main` rota sin hotfix.

## 4. Criterios de observación del sprint

| Criterio | Se observa cuando |
| --- | --- |
| Flujo sin cortes | Issue → rama → PR → merge se repite sin pasos salteados ni push directo a `main` |
| Criterios antes del push | Los `curl` de los criterios corren en local antes de cada PR |
| Integración continua | Después de cada merge, `main` pasa la pasada de humo; no hay ramas acumuladas sin fusionar |
| Gestión del tablero | El orden de issues es decidido por el grupo y los cerrados coinciden con los merges |
| Autonomía creciente | Las consultas al docente bajan en cantidad y suben en precisión (error exacto + lo intentado) |

## 5. Errores esperados e intervención

| Error esperado | Intervención docente |
| --- | --- |
| El grupo pide «el código del endpoint X» | Devolver la pregunta al criterio de aceptación y al endpoint modelado; mostrar el patrón, nunca el entregable completo |
| PR que mezcla dos issues | No fusionar: dividir el trabajo (ramas desde la primera rama o esperar el primer merge); reforzar rama corta |
| Estadística con ids `int` que revienta en 500 | Leer el 500 juntos en la terminal; recordar el canon: ids `long`, conteos `int` |
| Merge de un PR no probado que rompe `main` | Ejercicio de hotfix: issue urgente, rama, PR, merge; medir el costo frente al minuto de prueba previa |
| Un solo integrante escribe todo el sprint | Rotación forzada por ronda; en la ronda 2, el que muestra el PR debe ser quien NO programó ese feature |
| Grupo termina y se desconecta | Revisión cruzada de PRs de otro grupo, o issue extra del sprint (ingresos por mes con `strftime`) |
