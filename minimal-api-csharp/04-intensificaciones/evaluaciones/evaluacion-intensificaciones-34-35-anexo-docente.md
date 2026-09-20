# Anexo docente — Evaluación del momento de intensificación y fortalecimiento 34-35 (versiones A y B)

> Documento docente formal. No se entrega a los estudiantes: contiene la preparación previa, la solución completa de ambas versiones con sus pedidos de prueba, el modelo de issue y de pull request de la Parte 2, la pauta Apto / No apto aún por objetivo mínimo y los errores previsibles.

## Anexo docente

Contenido reservado de este archivo: soluciones canon, modelos de issue y pull request y pauta de corrección. No se replica en ningún entregable ni se proyecta durante la aplicación.

## Preparación previa

- Verificar en cada repositorio grupal que `main` está protegida (sin push directo) y que cada alumno presente es colaborador. Sin protección activa, la Parte 2 pierde su objetivo: activarla antes del Encuentro 35.
- Correr antes de la aplicación las consultas de ambas versiones y anotar los valores reales: ingresos del médico elegido para el ejemplo de la versión A (usar un id con varios ingresos, por ejemplo el médico `3`), un paciente existente para el reporte del defecto (por ejemplo el `12`) y la cantidad real de pacientes y altura promedio de la provincia elegida para la versión B (por ejemplo `ON`). Son los valores contra los que se valida cada Parte 1 en vivo.
- Verificar que cada equipo puede crear un proyecto nuevo (`dotnet new web`), copiar `hospital.db` junto al `.csproj` y agregar los dos paquetes: es la primera tarea de la Parte 1 y es contenido aprendido en la Unidad 2, no un impedimento.
- Imprimir el enunciado base y la versión asignada por estudiante según la asignación decidida (posición en el aula o lista); llevar la planilla de registro (alumno → condición → versión → OM1 a OM6).
- Preparar la carpeta `intensificaciones-34-35/` como consigna: cada alumno crea su propio `defecto-<inicial>.cs` copiando el snippet provisto en su enunciado; no hace falta un archivo pre-cargado en los repos.
- Tener a mano el modelo de issue y de pull request de esta hoja para revisar cada PR durante la plenaria de cierre: el comentario del docente en el PR es la devolución escrita del flujo profesional.

## Solución de la versión A

### Parte 1 — `GET /doctors/{id:long}/admissions` (JOIN triple)

Va en el `Program.cs` del esqueleto, antes de `app.Run()`; el record ya está provisto al final del archivo.

```csharp
// Parte 1 - Version A: ingresos atendidos por UN medico con el paciente de cada uno.
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero el medico: 404 con mensaje si el id no existe,
    // sin ejecutar la consulta de ingresos.
    var exists = connection.ExecuteScalar<long>(
        @"SELECT doctor_id
          FROM doctors
          WHERE doctor_id = @Id",
        new { Id = id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

    // Medico existente: sus ingresos con el nombre del paciente de cada uno.
    // JOIN triple calificado: admissions al centro, patients y doctors a los lados.
    var admissions = connection.Query<AdmissionOfDoctor>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.attending_doctor_id = @Id
        ORDER BY a.admission_date DESC",
        new { Id = id }).ToList();

    return Results.Ok(admissions);
});
```

```csharp
// ---- Records: ya provistos por el esqueleto, al final del archivo ----
record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string PatientName);
```

Pedidos de prueba y respuestas esperadas:

```http
### Ingresos del medico 3 (esperar 200 con sus ingresos, mas reciente primero)
GET http://localhost:5080/doctors/3/admissions

### Medico inexistente (esperar 404 con mensaje, respuesta inmediata)
GET http://localhost:5080/doctors/9999/admissions
```

- `/doctors/3/admissions` → `200` con las filas del médico elegido (cantidad constatada en la preparación previa); cada fila con `admissionDate`, `diagnosis` (puede ser `null`) y `patientName` completos.
- `/doctors/9999/admissions` → `404` con `{"mensaje":"No existe el medico"}` y sin ejecutar el JOIN (el `404` responde al instante).
- Médico existente sin ingresos → `200` con `[]`: el recurso existe, la lista está vacía; no es un `404`. Distinguirlo es parte del criterio, igual que en la clase 21.

### Parte 2 — Defecto, issue y pull request

El defecto es de tipo: `PatientDetail` declara `int PatientId` y SQLite entrega los enteros como `long`, por lo que el mapeo falla con `500` en cualquier pedido. Es el defecto canónico del canon de tipos del curso.

```csharp
// Arreglo canonico: el id vuelve a ser long, igual que en todo el curso.
record PatientDetail(long PatientId, string FirstName, string LastName);
```

Modelo de issue esperado (los números de issue dependen del repositorio):

```markdown
Titulo: El detalle de paciente responde 500 por el tipo del id
Etiqueta: endpoint

## Que se pide
Corregir el mapeo del id del paciente para que GET /patients/{id}
devuelva el detalle en lugar de un 500.

## Criterios de aceptacion
- [ ] GET /patients/12 responde 200 con el detalle del paciente
- [ ] GET /patients/9999 responde 404 con mensaje en espanol
- [ ] La causa del 500 queda corregida (tipo del id en el record)
- [ ] El commit referencia este issue
```

Modelo de pull request esperado: título referente, descripción con la causa (`int` → `long`), issue vinculado, diff mínimo (una línea del record), rama `feature/fix-eval-<inicial>` y **sin merge**. Un commit con `(#N)` en el mensaje es suficiente; más de uno es válido si queda claro el arreglo.

## Solución de la versión B

### Parte 1 — `GET /stats/provinces/{provinceId}` (GROUP BY + JOIN)

Va en el `Program.cs` del esqueleto, antes de `app.Run()`; el record ya está provisto al final del archivo.

```csharp
// Parte 1 - Version B: estadistica de pacientes de UNA provincia.
app.MapGet("/stats/provinces/{provinceId}", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero la provincia: 404 con mensaje si el codigo no existe.
    var exists = connection.ExecuteScalar<long>(
        @"SELECT COUNT(*)
          FROM province_names
          WHERE province_id = @Province",
        new { Province = provinceId });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe la provincia" });
    }

    // Provincia existente: conteo de pacientes y altura promedio del grupo.
    // JOIN con province_names para devolver el nombre, no el codigo.
    var stats = connection.QueryFirstOrDefault<ProvinceStats>(@"
        SELECT pn.province_name AS ProvinceName,
               COUNT(*) AS Patients,
               ROUND(AVG(p.height), 1) AS AvgHeight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE pn.province_id = @Province
        GROUP BY pn.province_name",
        new { Province = provinceId });

    return Results.Ok(stats);
});
```

```csharp
// ---- Records: ya provistos por el esqueleto, al final del archivo ----
record ProvinceStats(string ProvinceName, int Patients, double AvgHeight);
```

Pedidos de prueba y respuestas esperadas:

```http
### Estadistica de Ontario (esperar 200 con nombre, cantidad y altura promedio)
GET http://localhost:5080/stats/provinces/ON

### Codigo inexistente (esperar 404 con mensaje, respuesta inmediata)
GET http://localhost:5080/stats/provinces/ZZ
```

- `/stats/provinces/ON` → `200` con una fila: `provinceName` completo, `patients` entero y `avgHeight` con un decimal (valor constatado en la preparación previa). `COUNT` en `int` y `AVG` con `ROUND` en `double`: el mismo criterio de tipos de la clase 22.
- `/stats/provinces/ZZ` → `404` con `{"mensaje":"No existe la provincia"}`.
- Caso borde: un código válido sin pacientes devuelve `200` con cuerpo vacío (`QueryFirstOrDefault` da `null`). No se exige tratarlo; observar el caso suma en la corrección.

### Parte 2 — Defecto, issue y pull request

El defecto es de seguridad: el SQL se concatena con el dato recibido (`'" + provinceId + "'`), viola el canon de consultas parametrizadas del curso y corta con `500` ante cualquier valor con comilla.

```csharp
// Arreglo canonico: el valor viaja como parametro, nunca concatenado.
var provinces = connection.Query<Province>(
    @"SELECT province_id   AS ProvinceId,
             province_name AS ProvinceName
      FROM province_names
      WHERE province_id = @ProvinceId",
    new { ProvinceId = provinceId }).ToList();
```

Modelo de issue esperado:

```markdown
Titulo: La busqueda de provincias concatena el SQL con el dato recibido
Etiqueta: endpoint

## Que se pide
Parametrizar la consulta de GET /provinces/{provinceId} para que
no se concatene el valor recibido con el SQL.

## Criterios de aceptacion
- [ ] La consulta usa @ProvinceId con su objeto anonimo
- [ ] GET /provinces/ON responde 200 con la provincia
- [ ] Un codigo inexistente responde 404 con mensaje en espanol
- [ ] El commit referencia este issue
```

Modelo de pull request esperado: igual estructura que la versión A (causa, issue vinculado, diff mínimo de la consulta, rama propia, sin merge). La equivalencia de la Parte 2 es exacta: mismo flujo, mismo criterio, distinto defecto (tipo vs. parametrización).

## Pauta Apto / No apto aún por objetivo mínimo

Planilla sugerida: alumno · condición · versión · OM1 a OM6 (A / NA) · observaciones.

| # | Objetivo mínimo | Evidencia para Apto | Evidencia que fuerza No apto aún |
| --- | --- | --- | --- |
| OM1 | JOIN triple (versión A, Parte 1) | JOIN triple calificado con alias `AS`, record compuesto, existencia con `ExecuteScalar<long>` y `404` con mensaje; `200` verificado con el médico de prueba | Sin verificación de existencia, `404` sin mensaje, filtros por columnas equivocadas o mapeo que no compila sin ayuda dirigida |
| OM2 | GROUP BY (versión B, Parte 1) | `GROUP BY` con JOIN a `province_names`, `COUNT` en `int`, `AVG` con `ROUND` en `double` y `404` de existencia previo | Consulta que no agrupa, promedio en `int` sin decimales, código en lugar del nombre del grupo o `404` ausente |
| OM3 | Dato sucio y manejo de errores (ambas versiones) | Los casos límite responden `404` o mensaje en español, nunca `500`; en la Parte 2 el defecto queda detectado, documentado en el issue con criterios y corregido con prueba | Algún caso límite responde `500`, o el arreglo se copia sin diagnóstico ni criterios de aceptación |
| OM4 | Configuración y publicación (bloques del momento) | Evidencia del Encuentro 34 completa: cadena en `appsettings.json`, `dotnet publish` y corrida en release observada por el docente, con commit de respaldo | Evidencia incompleta, corrida solo en desarrollo o sin poder explicar qué cambia en release |
| OM5 | Flujo profesional (Parte 2, ambas versiones) | Secuencia completa issue → rama → commits `(#N)` → push → PR abierto; issue con criterios de aceptación verificables; PR sin fusionar y con la causa explicada | Eslabones faltantes (issue sin criterios, commits sin `(#N)`, push ausente), merge propio o arreglo fuera de rama |
| OM6 | README de portada (repositorio al cierre del Encuentro 35) | README con descripción, integrantes y tabla de endpoints; en profundización, además un ejemplo `curl` por endpoint con sus casos 200, 400 y 404 | README inexistente, sin tabla de endpoints o desactualizado respecto del trabajo final |

Para la pista de profundización, el resultado esperado es Apto en todos los objetivos observables: un No apto aún en profundización activa la misma revisión dirigida que en recuperación, porque señala un sostenimiento perdido.

## Errores previsibles y respuestas

- *Parte 1 A: filtro por nombre o apellido del médico en vez del id* → El parámetro de ruta es el id; intervenir preguntando qué identifica la ruta (`{id:long}`).
- *Parte 1 A: JOIN de solo dos tablas* → Sin `doctors` no hay JOIN triple; el JOIN con `doctors` es exigible aunque el filtro ya seleccione al médico, igual que en el molde de la clase 21.
- *Parte 1 B: agrupar por `province_id` y devolver el código* → El enunciado pide el nombre completo; el JOIN con `province_names` es parte del criterio.
- *Parte 1 B: `avgHeight` sin decimales* → Propiedad `int` o falta de `ROUND`; comparar la salida antes y después, como en la clase 22.
- *Verificación de existencia omitida* → El `404` de existencia es parte de ambas versiones: `ExecuteScalar<long>` primero, consulta principal después.
- *`TypedResults` o objeto crudo como respuesta* → Defecto de versión: el canon del curso es `Results` explícito.
- *Records antes de `app.Run()`* → Error CS8803; recordar el esqueleto: records siempre al final.
- *Parte 2: issue sin criterios de aceptación o commit sin `(#N)`* → No es un detalle formal: son los eslabones evaluables del flujo profesional; pedir la corrección antes de registrar Apto en OM5.
- *Parte 2: merge propio del PR* → `main` está protegida: el merge sin revisión fuerza No apto aún en OM5 y deja el error documentado para la devolución.
- *Tiempo agotado con Parte 1 sin probar* → Registrar la evidencia parcial: el código que compila y la consulta correcta valen; el faltante queda en observaciones.
