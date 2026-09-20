# Encuentro 21 — JOIN triple y endpoints compuestos

> Unidad 3 — Integración de datos y publicación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 21 |
| Unidad | 3 — Integración de datos y publicación |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | JOIN de tres tablas encadenadas (`admissions` + `patients` + `doctors`), calificación de columnas en cadena y DTO compuesto con alias AS |
| Requisitos previos | Clase 13 completada (JOIN de dos tablas con alias, DTO combinado, parámetros con objeto anónimo); evaluación de la Unidad 2 rendida |
| Uso de celular | No permitido |
| Grupos | Presentes ÷ equipos disponibles (mínimo posible); rotación de integrantes entre la práctica y la extensión |
| Planificación anual | Encuentro 21: devolución de la evaluación de la Unidad 2; JOIN de tres tablas (admissions, patients y doctors) y endpoints compuestos |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente (incluye devolución U2) | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (20 min).** Devolución de la evaluación de la Unidad 2: cada grupo recibe la devolución de su entrega (`tp-u2`) y de la defensa individual, con los criterios de la corrección a la vista. Puesta en común breve de los tres hallazgos más frecuentes de la corrección (por lo general: ids mal tipados, consultas sin parametrizar y DTOs con alias faltantes) para cerrar la unidad anterior con la lección aprendida. El puente hacia hoy: la clase 13 encadenó `patients` con `province_names` y el JSON mostró la traducción. El esquema de hospital.db tiene una relación todavía más interesante: cada fila de `admissions` apunta a un paciente Y a un médico. ¿Cómo devuelve la API un ingreso con las dos historias completas? Hoy se resuelve encadenando dos JOIN.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar la cadena de relaciones del esquema: `admissions.patient_id` → `patients.patient_id` y `admissions.attending_doctor_id` → `doctors.doctor_id`.
2. Escribir un JOIN triple con alias cortos (`a`, `p`, `d`) y calificar cada columna para evitar la ambigüedad.
3. Definir el record DTO compuesto `AdmissionDetail` y mapear cada columna con su alias AS, incluyendo el nombre armado con el operador `||`.
4. Implementar endpoints compuestos GET (`/admissions/full`, `/doctors/{id}/admissions`) con verificación de existencia y 404 con mensaje.
5. Aplicar la regla de los parámetros con objeto anónimo también sobre consultas con JOIN triple.

## 3. Teoría mínima (40 min)

### Charla rápida: la mesa de entradas

En la mesa de entradas del hospital llega la hoja de ingreso: trae el diagnóstico, las fechas y DOS códigos, el del paciente y el del médico tratante. El empleado de mesa de entradas no adivina nombres: por cada código consulta su cuaderno. El código del paciente lo traduce en el registro de pacientes; el código del médico, en el directorio médico. Hace la traducción dos veces, una por código, y arma la hoja completa. El JOIN triple es exactamente eso: leer la hoja (`admissions`) y traducir cada uno de sus dos códigos en su tabla respectiva (`patients`, `doctors`). La clase 13 ya tradujo un código; hoy se encadena la segunda traducción.

### Lo mínimo indispensable

**La cadena de relaciones.** El esquema de hospital.db la define así:

```
admissions.patient_id           ── referencia ──>  patients.patient_id
 (el código del paciente)                        (la ficha del paciente)

admissions.attending_doctor_id  ── referencia ──>  doctors.doctor_id
 (el código del médico)                          (la ficha del médico)
```

`admissions` es la tabla del medio: cada ingreso apunta a un paciente y a un médico. 306 ingresos, 258 pacientes, 27 médicos.

**El JOIN encadenado.** Cada JOIN añade una tabla y su condición:

```sql
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
```

| Pieza | Qué hace |
| --- | --- |
| `FROM admissions a` | Tabla base (la hoja de ingreso), alias `a` |
| `JOIN patients p ON ...` | Primera traducción: el código del paciente |
| `JOIN doctors d ON ...` | Segunda traducción: el código del médico |

El orden de lectura es el orden de la traducción: primero la tabla base, después cada tabla traducida con su `ON`. Cada `ON` compara SIEMPRE un código de `a` con la clave de la tabla que entra.

**Calificación obligatoria, ahora con más motivo.** La columna `patient_id` existe en `admissions` Y en `patients`. Sin calificar, SQLite corta con `ambiguous column name: patient_id`. Con tres tablas en juego, la regla de la clase 13 se vuelve estricta: todo identificador lleva su alias de tabla.

**El DTO compuesto.** El resultado mezcla columnas de las tres tablas: un record con una propiedad por columna que el SELECT devuelve, cada columna con su alias AS:

```csharp
// Columnas de admissions + la traduccion de patients + la traduccion de doctors.
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);
```

**Nombres armados con `||`.** El nombre completo no vive en ninguna columna: vive partido en `first_name` y `last_name`. SQLite pega textos con el operador `||`, y el resultado lleva su alias AS como cualquier columna:

```sql
p.first_name || ' ' || p.last_name AS PatientName
```

**Los parámetros no cambian.** Filtrar el JOIN triple usa la regla de siempre: marcador en el SQL fijo + objeto anónimo.

```sql
WHERE a.patient_id = @Id
```

```csharp
new { Id = id }
```

## 4. Práctica guiada (70 min)

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n HospitalApi
cd HospitalApi
code .
```

### Paso 2 — Agregar los paquetes

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 3 — Copiar hospital.db a la raíz del proyecto

El mismo archivo de toda la Unidad 2. Verificar que `hospital.db` queda junto al `.csproj`.

### Paso 4 — Reemplazar Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este código completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion canonica: hospital.db junto al .csproj.
var connectionString = "Data Source=hospital.db";

// GET /admissions/full: JOIN triple admissions + patients + doctors.
// Cada ingreso sale con los datos del paciente y del medico tratante.
app.MapGet("/admissions/full", () =>
{
    using var connection = new SqliteConnection(connectionString);

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
        ORDER BY a.admission_date DESC").ToList();

    return Results.Ok(admissions);
});

// GET /doctors/{id}/admissions: el mismo JOIN triple, filtrado por medico.
// Primero se verifica que el medico exista: 404 con mensaje si no existe.
app.MapGet("/doctors/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // ExecuteScalar<long> devuelve el id si existe, o 0 si no encontro fila.
    var exists = connection.ExecuteScalar<long>(
        @"SELECT doctor_id
          FROM doctors
          WHERE doctor_id = @Id",
        new { Id = id });

    if (exists == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

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
        WHERE a.attending_doctor_id = @Id
        ORDER BY a.admission_date DESC",
        new { Id = id }).ToList();

    return Results.Ok(admissions);
});

app.Run();

// Los records van SIEMPRE al final del archivo, despues de app.Run().
// Detalle de ingreso: columnas de las tres tablas, un alias AS por propiedad.
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);
```

### Paso 5 — Levantar la API

```powershell
dotnet run
```

Anotar el puerto de la línea `Now listening on:` (en los ejemplos se usa `http://localhost:5080`; reemplazar por el propio).

### Paso 6 — Probar los endpoints en el navegador

- `http://localhost:5080/admissions/full` → 200 con la lista completa de ingresos; cada fila muestra el nombre del paciente, el del médico y su especialidad.
- `http://localhost:5080/doctors/3/admissions` → 200 con los ingresos atendidos por el médico 3.
- `http://localhost:5080/doctors/9999/admissions` → 404 con mensaje en JSON.

### Paso 7 — Experimento: provocar la columna ambigua del JOIN triple

El experimento es seguro: no toca los datos, solo corta la consulta.

1. En el primer endpoint, reemplazar el enlace `ON a.patient_id = p.patient_id` por `ON patient_id = p.patient_id`.
2. Reiniciar (`dotnet run`) y pedir `/admissions/full` → 500. En la terminal aparece la causa exacta: `SQLite Error 1: 'ambiguous column name: patient_id'`.
3. Leerlo: `patient_id` existe en `admissions` y en `patients`; con dos JOIN en juego, SQLite no adevina a cuál se refiere. Devolver la calificación `a.patient_id` y verificar que todo vuelve a funcionar.

### Salidas esperadas

**GET /admissions/full** → 200 con la lista de ingresos (respuesta similar a; los valores concretos dependen de los datos):

```json
[
  {
    "admissionDate": "2019-06-02",
    "dischargeDate": null,
    "diagnosis": "Stomache Pain",
    "patientName": "Emily Watson",
    "doctorName": "Robert Kim",
    "doctorSpecialty": "Cardiologist"
  }
]
```

Dos observaciones sobre esta fila de ejemplo: `dischargeDate` en `null` significa ingreso sin fecha de alta (el tema central de la clase 23) y el diagnóstico muestra un error de tipeo real de la base (también de la clase 23). Hoy se exponen tal cual; la unidad los va a tratar.

**GET /doctors/3/admissions** → 200 con los ingresos de ese médico, misma estructura por fila.

**GET /doctors/9999/admissions** → 404:

```json
{
  "mensaje": "No existe el medico"
}
```

Observación sobre el endpoint filtrado: la verificación de existencia y la consulta de ingresos son DOS consultas al mismo handler. Primero el 404 corta; solo si el médico existe corre el JOIN triple. El orden importa: no tiene sentido traer ingresos de alguien que no existe.

## 5. Ejercicio independiente (50 min)

Trabajo por grupos: presentes ÷ equipos disponibles, un equipo por PC. Rotación de roles cada 20 minutos: quien conduce el teclado pasa a observar y corrige el siguiente paso en papel antes de escribirse.

### Consigna

Agregar al mismo proyecto un endpoint nuevo:

- `GET /patients/{id}/admissions`: la historia completa de UN paciente — cada uno de sus ingresos con los datos del médico que lo atendió (mismo DTO `AdmissionDetail` de la práctica), ordenado por fecha de ingreso descendente. Si el paciente no existe → 404 con mensaje; si existe pero no tiene ingresos → 200 con `[]`.

### Pista

El endpoint `/doctors/{id}/admissions` de la práctica es el molde exacto: verificación de existencia con `ExecuteScalar<long>` (con `patients` y `patient_id` ahora), 404 si devuelve 0, y después el JOIN triple filtrado por `a.patient_id = @Id`. La solución completa está en el anexo docente.

## 6. Extensión y consolidación (45 min)

Para los grupos que completan la consigna base. Los demás consolidan terminando el ejercicio con acompañamiento y releyendo la práctica.

1. **JOIN de cuatro tablas.** Agregar `GET /admissions/with-location`: además del paciente y el médico, la ciudad y el nombre de la provincia del paciente (encadenar `province_names` con un tercer JOIN sobre `p.province_id = pn.province_id`). Necesita un DTO nuevo con las propiedades correspondientes; cada columna nueva lleva su alias AS.
2. **Consolidación en el pizarrón.** Cada grupo dibuja su cadena de relaciones del ejercicio (dos flechas: `admissions` → `patients` → `doctors`) y explica cuál código traduce cada `ON`. Rotación: explica quien no condujo el teclado.
3. **Auditoría de la respuesta.** Abrir `/admissions/full` y contar en la primera pantalla cuántas filas muestran `dischargeDate` en `null` y cuántos diagnósticos lucen «raros». Anotar los hallazgos: son el material de trabajo de la clase 23.

## 7. Cierre (15 min)

### Qué te llevás

- El JOIN triple encadena traducciones: `admissions` es la tabla del medio y cada `ON` traduce uno de sus códigos con la clave de la tabla que entra.
- Con tres tablas, la calificación con alias (`a.`, `p.`, `d.`) deja de ser recomendación: `patient_id` existe en dos tablas y sin calificar corta con `ambiguous column name`.
- El DTO compuesto define el JSON: una propiedad por columna del SELECT, y el nombre completo se arma en el SELECT con `first_name || ' ' || last_name AS PatientName`.
- Verificación de existencia primero (`ExecuteScalar<long>`), 404 con mensaje si no hay fila, y solo entonces la consulta pesada: el orden de las consultas dentro del handler también es diseño.
- La base tiene datos imperfectos a la vista (`dischargeDate` nulo, diagnósticos mal tipeados): la API de hoy los expone tal cual porque todavía no sabe tratarlos.

### Lo que viene

Encuentro 22: «Agregaciones COUNT, AVG y SUM con GROUP BY (por especialidad, por mes)». Hoy la API devuelve filas: cada ingreso, uno junto al otro. Las preguntas reales de un hospital son de números: ¿cuántos ingresos por especialidad?, ¿cuánto dura una internación en promedio?, ¿qué médico atendió más? La clase 22 agrega: contar, promediar y sumar en el motor, con GROUP BY, y responder con filas de resumen en lugar de filas de detalle.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con el ejercicio funcionando, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 21: JOIN triple y endpoints compuestos"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| `ambiguous column name: patient_id` | La columna existe en `admissions` y en `patients` y quedó sin calificar | Calificar SIEMPRE con el alias: `a.patient_id`, `p.first_name`, `d.specialty` |
| Respuesta con millones de filas absurdas | Falta uno de los `ON` (o quedó incompleto): las tablas se multiplican entre sí | Escribir los dos enlaces completos, uno por tabla que entra al JOIN |
| `patientName` en `null` en todas las filas | Falta un alias AS (o la propiedad no existe en el DTO) | Una columna con alias AS por cada propiedad: Dapper mapea por nombre exacto |
| El JSON no separa nombre y apellido | Se eligió exponer `firstName` y `lastName` crudos en el DTO compuesto | Armar el nombre en el SELECT con `||` y un alias AS (`AS PatientName`), como el canon |
| 404 que nunca aparece (devuelve `[]` con id inexistente) | Se consultaron los ingresos sin verificar primero que el recurso exista | Verificar existencia con `ExecuteScalar<long>` ANTES de la consulta del JOIN |
| Record `AdmissionDetail` declarado antes de `app.Run()` | CS8803: el compilador rechaza tipos entre instrucciones de nivel superior | Records SIEMPRE al final del archivo |
