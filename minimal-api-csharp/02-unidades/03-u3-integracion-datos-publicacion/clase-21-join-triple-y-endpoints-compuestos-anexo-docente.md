# Anexo docente — Encuentro 21: JOIN triple y endpoints compuestos

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 3 — Integración de datos y publicación

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 21 — Devolución de la evaluación de la Unidad 2; JOIN de tres tablas y endpoints compuestos (planificación anual) |
| Ejercicio evaluado | `GET /patients/{id}/admissions`: historia completa de un paciente con JOIN triple y 404 de existencia |
| Momento del bloque | Ejercicio independiente (50 min) + extensión y consolidación (45 min) + cierre (15 min) |
| Insumos | Proyecto `HospitalApi` de la práctica guiada funcionando, con `hospital.db` en la raíz y los paquetes Microsoft.Data.Sqlite + Dapper instalados |
| Apertura | Devolución del `tp-u2` y de las defensas de la Unidad 2 antes del puente; no extender más de 20 minutos en total |

## Preparación previa (gestión del aula)

- Ejecutar antes de clase los endpoints del encuentro y anotar cantidades reales: total de filas de `/admissions/full` (306 aprox.), ingresos del médico elegido para el ejemplo (usar un id con varios ingresos, por ejemplo 3) y un `patient_id` con al menos dos ingresos para validar el ejercicio en vivo.
- Tener el esquema a mano y dibujarlo en el pizarrón como cadena: `admissions` al centro con dos flechas salientes (`patient_id` → `patients`, `attending_doctor_id` → `doctors`). Es el ancla visual de todo el encuentro.
- Preparar la devolución de la Unidad 2: entrega corregida, criterios de corrección y los tres hallazgos más frecuentes para la puesta en común. La devolución abre el encuentro pero no lo domina: 20 minutos de apertura en total.
- Verificar que los equipos arrancan con Dapper funcionando de la Unidad 2; el encuentro no agrega paquetes ni archivos, solo consultas.
- Identificar en la base los casos sucios que verán en vivo (`discharge_date` NULL, «Stomache Pain», altas de 1971) para no sorprenderse ni improvisar explicaciones: son material anunciado de la clase 23, hoy solo se nombran.

## Solución esperada

El ejercicio reutiliza el molde de `/doctors/{id}/admissions`: verificación de existencia con `ExecuteScalar<long>`, 404 con mensaje si no hay fila, y después el JOIN triple filtrado. Va en el `Program.cs` de la práctica, antes de `app.Run()`; el DTO ya existe al final del archivo.

```csharp
// Solucion del ejercicio: historia completa de UN paciente con JOIN triple.
app.MapGet("/patients/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Primero el paciente: 404 con mensaje si el id no existe.
    var exists = connection.ExecuteScalar<long>(
        @"SELECT patient_id
          FROM patients
          WHERE patient_id = @Id",
        new { Id = id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    // Paciente existente: sus ingresos con los datos del medico de cada uno.
    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.patient_id = @Id
        ORDER BY a.admission_date DESC",
        new { Id = id }).ToList();

    return Results.Ok(admissions);
});
```

Pedidos de prueba:

```http
### Historia del paciente 12 (esperar 200 con sus ingresos)
GET http://localhost:5080/patients/12/admissions

### Paciente existente sin ingresos (esperar 200 con [])
GET http://localhost:5080/patients/<id sin ingresos>/admissions

### Paciente inexistente (esperar 404)
GET http://localhost:5080/patients/9999/admissions
```

Respuestas esperadas:

- `/patients/12/admissions` → 200 con los ingresos de ese paciente (verificar la cantidad en la preparación previa); cada fila con `patientName`, `doctorName` y `doctorSpecialty` completos.
- Paciente existente sin ingresos → 200 con `[]`: el recurso existe, la lista está vacía. Distinguirlo del 404 es parte del criterio.
- `/patients/9999/admissions` → 404 con `{"mensaje":"No existe el paciente"}` y SIN ejecutar el JOIN (verificable agregando un punto de interrupción o leyendo que el 404 responde al instante).

Detalles clave de la solución:

- El filtro correcto es `a.patient_id = @Id` (calificado con el alias de `admissions`). Un `WHERE p.patient_id = @Id` también funciona porque es el mismo valor, pero pierde el sentido de leer la tabla base; marcar la diferencia en la corrección.
- El ejercicio evalúa encadenar tres conceptos: JOIN triple calificado, verificación de existencia con `ExecuteScalar<long>` y reutilización del DTO compuesto. Quien copia un DTO nuevo con las mismas propiedades repite sin entender.

## Solución de la extensión

Punto 1 — JOIN de cuatro tablas con ciudad y provincia. Necesita su propio DTO (propiedad nueva por columna nueva):

```csharp
// DTO de la extension: agrega la ubicacion del paciente al detalle de ingreso.
record AdmissionWithLocation(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string? City,
    string ProvinceName,
    string DoctorName);
```

```csharp
// Solucion de la extension: JOIN de cuatro tablas con la provincia traducida.
app.MapGet("/admissions/with-location", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionWithLocation>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               p.city AS City,
               pn.province_name AS ProvinceName,
               d.first_name || ' ' || d.last_name AS DoctorName
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN province_names pn ON p.province_id = pn.province_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        ORDER BY a.admission_date DESC").ToList();

    return Results.Ok(admissions);
});
```

`/admissions/with-location` → 200 con el detalle de ingreso más `city` (nullable: algunos pacientes no tienen ciudad) y `provinceName`. Cada tabla adicional entra con su propio `ON`: la cuarta tabla no cambia la mecánica, solo añade un eslabón.

Puntos 2 y 3 (pizarrón y auditoría): no llevan código. Registrar en el libro los hallazgos de la auditoría por grupo (filas con alta nula y diagnósticos raros avistados): son el punto de partida real de la clase 23.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | `GET /patients/{id}/admissions` responde 200 con la historia completa | Cada fila muestra ingreso + paciente + médico con nombres armados, no códigos |
| 2 | Filtro calificado y parametrizado | `WHERE a.patient_id = @Id` con `new { Id = id }`, sin concatenación de strings |
| 3 | 404 de existencia con mensaje | `/patients/9999/admissions` → 404 con cuerpo `{"mensaje":"No existe el paciente"}` |
| 4 | Paciente sin ingresos distinguido de paciente inexistente | `[]` con 200 en el primer caso, 404 en el segundo |
| 5 | Orden de la historia | Filas por `admission_date DESC` |
| 6 | Canon de estructura | `AdmissionDetail` reutilizado (sin duplicarlo), records al final, `Results.Ok`/`Results.NotFound` explícitos |
| 7 | Cierre con rutina Git | `git log` muestra el commit "Clase 21: JOIN triple y endpoints compuestos" y el push al remoto |

## Qué observar en el aula

- **El experimento de la columna ambigua (paso 7) sigue siendo el corazón del encuentro**, ahora con dos tablas candidatas (`admissions` y `patients`). Verificar que todos lo provocan y lo leen antes de corregirlo.
- **La devolución de la Unidad 2 tiene fecha de vencimiento:** 20 minutos. Los hallazgos frecuentes (ids mal tipados, consultas sin parametrizar, alias faltantes) deben quedar nombrados porque los tres reaparecen en el ejercicio de hoy.
- **La auditoría de la extensión (punto 3) es la siembra de la clase 23.** Pedir que anoten literalmente lo que ven: «Stomache Pain», altas nulas, fechas de alta del año 1971. Cuando la clase 23 los trate, el material ya es propio, no teórico.
- **Señal de alerta:** grupos que filtran con `WHERE p.patient_id = @Id` sin verificar existencia primero. Funciona, pero devuelve `[]` para ids inexistentes: el 404 del ejercicio existe justamente para forzar el orden verificación → consulta.
- **Sondeo rápido:** ¿cuál de los dos `ON` traduce el médico? (`a.attending_doctor_id = d.doctor_id`). ¿Por qué `patient_id` es ambigua y `diagnosis` no? (`diagnosis` solo existe en `admissions`). ¿Qué operador arma el nombre completo? (`||` en el SELECT con alias AS).

## Errores previsibles y respuestas

- *`ambiguous column name: patient_id`* → Columna sin calificar con dos tablas candidatas. Intervención: volver al diagrama del pizarrón y nombrar la tabla dueña de cada columna.
- *Producto cruzado (miles de filas)* → Falta uno de los dos `ON`. Intervención: contar las filas esperadas (306) contra las recibidas y buscar cuál enlace quedó afuera.
- *`patientName` nulo en el JSON* → Alias AS faltante o propiedad ausente en el DTO. Intervención: comparar la lista de propiedades del record contra las columnas del SELECT, una por una.
- *404 inalcanzable (siempre `[]`)* → Falta la verificación previa con `ExecuteScalar<long>`. Intervención: probar con id 9999 en vivo y preguntar qué habría sido más correcto devolver.
- *Grupo que termina en 10 minutos* → Verificar que usó `a.patient_id` calificado y el orden `DESC`; derivarlo a la extensión (JOIN de cuatro tablas) sin esperar al resto.
