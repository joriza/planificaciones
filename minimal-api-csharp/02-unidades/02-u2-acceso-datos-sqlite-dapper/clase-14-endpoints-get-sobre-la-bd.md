# Encuentro 14 — Endpoints GET sobre la BD y cierre de la Unidad 2

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 14 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper (cierre de unidad) |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Sin técnicas nuevas: integración. Los endpoints GET del mini-proyecto en memoria (clase 8) se migran a consultas reales sobre hospital.db. Único detalle nuevo, mínimo y de SQL: el operador `\|\|` para concatenar textos en un SELECT |
| Requisitos previos | Clase 13 completada (proyecto `HospitalApi` con el JOIN `patients` + `province_names` y el DTO combinado `PatientWithProvince` funcionando; `hospital.db` en la raíz del proyecto). Mini-proyecto `AdmisionApi` de la clase 8 como referencia del patrón en memoria |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 14: «Endpoints GET sobre la BD / Migración de endpoints» y «Cierre de la Unidad 2 / Preparación del tp-u2» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (30 min).** Dibujar en el pizarrón el mapa de la unidad: Encuentro 10 hospital.db (4 tablas relacionadas) → Encuentro 11 conexión y `Query<T>` → Encuentro 12 WHERE con parámetros y LIKE → Encuentro 13 JOIN de dos tablas → hoy, Encuentro 14: todo integrado en una sola API. Pregunta disparadora: ¿qué pasaba con la lista de ingresos del mini-proyecto cada vez que se detenía la API? Hoy ese problema se elimina definitivamente: los datos pasan a vivir en la base.

Al finalizar el encuentro, cada estudiante puede:

1. Migrar un endpoint GET de listado desde `List<T>` en memoria a `SELECT` con `Query<T>` y DTO con alias AS.
2. Migrar el GET por Id: de `FirstOrDefault` más 404 a `WHERE` con parámetro (objeto anónimo) más 404.
3. Combinar JOIN, parámetro de ruta y verificación de existencia en un endpoint integrador: el historial real de ingresos de un paciente.
4. Distinguir 404 (el recurso no existe) de 200 con arreglo vacío (el recurso existe, pero no tiene datos).
5. Dejar el repositorio listo para el tp-u2: proyecto funcionando, commits y push al día.

## 3. Teoría mínima (45 min)

### Mapa de la unidad (cierre)

Sin técnicas nuevas: hoy se reorganiza y se conecta todo lo visto.

| Encuentro | Contenido | Que hoy se usa para... |
| --- | --- | --- |
| 10 | SQLite y hospital.db: 4 tablas relacionadas | Saber de dónde salen los datos |
| 11 | Conexión `Microsoft.Data.Sqlite` y `Query<T>` con DTO | Ejecutar consultas y mapearlas a records |
| 12 | WHERE con parámetros (objeto anónimo) y LIKE | Filtrar por Id sin concatenar valores |
| 13 | JOIN de dos tablas | Unir pacientes con provincias e ingresos con médicos |
| 14 | Integración (hoy) | Migrar la API en memoria a la BD real y cerrar la unidad |

### De la memoria a la base: la tabla de traducción

Migrar no es reescribir: es traducir. Cada pieza del mini-proyecto de la clase 8 tiene un equivalente exacto.

| En memoria (clases 7 y 8) | En la base de datos (hoy) |
| --- | --- |
| `record Ingreso` inventado para la lista | DTOs que reflejan columnas reales, con alias AS |
| `new List<Ingreso>` dentro de Program.cs | Las tablas reales de hospital.db (258 pacientes, 306 ingresos) |
| `GET /ingresos` devolvía la lista completa | `GET /patients` devuelve el `SELECT` con `Query<T>` |
| `lista.FirstOrDefault(x => x.Id == id)` | `WHERE patient_id = @Id` + `new { Id = id }` |
| `null` después de `FirstOrDefault` → 404 | Igual: si no hay fila, el DTO queda en `null` → 404 |
| La lista se borra al detener la API | Los datos persisten: son los del hospital |

### Por qué no se migra `/ingresos` tal cual

El mini-proyecto de la Unidad 1 inventaba un `Id` numérico para cada ingreso. La tabla real `admissions` no tiene columna Id: un ingreso se identifica con la combinación `patient_id` + `admission_date` (clave compuesta). Al migrar a una base real, el diseño de la base manda. Por eso:

- El recurso con Id numérico simple es `patients` (columna `patient_id`): sobre él se migra el patrón completo del listado y del GET por Id (`/patients` y `/patients/{id:int}`).
- Los ingresos reales vuelven como sub-recurso: `GET /patients/{id:int}/admissions`, con JOIN de `admissions` con `doctors` — exactamente la extensión que anticipaba la clase 13.

### Charla rápida: la mudanza del archivo

Durante toda la Unidad 1, la recepción del hospital anotaba las fichas en un cuaderno: práctico, pero cada vez que cerraba, el cuaderno se perdía. La base de datos es el archivo definitivo del hospital: no se borra al apagar. Y lo que no cambia es el mostrador: mismo endpoint, misma ruta de pedido, misma respuesta en JSON. Migrar es cambiar dónde viven los datos y cómo se consultan (SQL en lugar de métodos de lista), no cambiar la API.

## 4. Práctica guiada (90 min)

Hoy el código se traduce en conjunto: cada paso termina con la prueba del endpoint migrado. Micro-rutina para cada SELECT: qué columnas quiero → de qué tablas → qué filtro → qué alias para cada propiedad del DTO.

### Paso 1 — Abrir el proyecto de la clase 13

```powershell
cd HospitalApi
code .
```

Verificar que `hospital.db` sigue en la raíz del proyecto (junto al `.csproj`) y levantar para partir de un estado que funciona:

```powershell
dotnet run
```

Probar los dos endpoints de la clase 13 en el navegador: `http://localhost:5080/patients/with-province` (200 con las 258 filas) y `http://localhost:5080/patients/1/with-province` (200 con un objeto). Anotar el puerto de la línea `Now listening on:` (en los ejemplos se usa `http://localhost:5080`; reemplazar por el puerto propio). Detener la API con Ctrl+C.

### Paso 2 — GET /patients: el listado del mini-proyecto, ahora con datos reales

Agregar a Program.cs este endpoint. El record `PatientWithProvince` ya está declarado al final del archivo desde la clase 13: se reutiliza, no se vuelve a declarar.

```csharp
// GET /patients: el listado del mini-proyecto de la Unidad 1, ahora desde la BD.
// Misma ruta-patron que GET /ingresos en AdmisionApi; los datos ya no son una List<T>.
app.MapGet("/patients", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.patient_id").ToList();

    return Results.Ok(patients);
});
```

Levantar con `dotnet run` y probar `http://localhost:5080/patients`: 200 con los 258 pacientes, la misma estructura JSON de la clase 13.

### Paso 3 — GET /patients/{id:int}: el detalle por Id

El equivalente exacto del `FirstOrDefault` + 404 del mini-proyecto:

```csharp
// GET /patients/{id:int}: el FirstOrDefault de la lista ahora es WHERE con parametro.
app.MapGet("/patients/{id:int}", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.patient_id = @Id",
        // Objeto anonimo: la clave Id completa el marcador @Id. Nunca concatenar el valor.
        new { Id = id }).FirstOrDefault();

    return patient is null ? Results.NotFound(new { mensaje = "No existe el paciente" })
                           : Results.Ok(patient);
});
```

Probar los dos caminos en el navegador: `http://localhost:5080/patients/1` (200 con datos) y `http://localhost:5080/patients/9999` (404 con mensaje en JSON).

### Paso 4 — GET /patients/{id:int}/admissions: los ingresos reales

El mini-proyecto hablaba de "ingresos": aquí están los de verdad. Primero se verifica que el paciente exista (404 si no), y después se consultan sus ingresos con JOIN contra `doctors`. Este endpoint necesita un DTO propio: agregar el record `AdmissionWithDoctor` al final del archivo, junto a los otros.

```csharp
// GET /patients/{id:int}/admissions: los ingresos reales del paciente.
// Primero se verifica que el paciente exista; despues se consultan sus ingresos.
app.MapGet("/patients/{id:int}/admissions", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // int? permite null: si la consulta no trae fila, FirstOrDefault da null.
    var exists = connection.Query<int?>(
        "SELECT patient_id FROM patients WHERE patient_id = @Id",
        new { Id = id }).FirstOrDefault();

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    // Ingresos reales con el nombre del medico tratante (JOIN de la clase 13).
    // El operador || concatena textos en SQL: nombre y apellido en una columna.
    var admissions = connection.Query<AdmissionWithDoctor>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               d.first_name || ' ' || d.last_name AS DoctorName
        FROM admissions a
        JOIN doctors d ON d.doctor_id = a.attending_doctor_id
        WHERE a.patient_id = @Id
        ORDER BY a.admission_date").ToList();

    // 200 con la lista, aunque venga vacia: el paciente existe. 404 solo si no existe.
    return Results.Ok(admissions);
});
```

```csharp
// DTO minimo del ingreso real: solo las columnas que el endpoint expone.
// Los tipos siguen a SQLite: las fechas y el diagnostico son TEXT, es decir string.
record AdmissionWithDoctor(string AdmissionDate, string Diagnosis, string DoctorName);
```

### Paso 5 — Probar los tres endpoints en el navegador

Reiniciar (`dotnet run`) y recorrer los tres caminos:

- `http://localhost:5080/patients` → el listado completo.
- `http://localhost:5080/patients/1` y `http://localhost:5080/patients/9999` → el detalle y su 404.
- `http://localhost:5080/patients/1/admissions` → el historial real de ingresos del paciente 1.

### Salidas esperadas

**GET /patients** → 200 con 258 objetos (misma estructura de la clase 13; los valores dependen de los datos):

```json
[
  {
    "patientId": 12,
    "firstName": "Emily",
    "lastName": "Watson",
    "city": "Toronto",
    "provinceName": "Ontario"
  }
]
```

**GET /patients/1** → 200 con un solo objeto con esa estructura. **GET /patients/9999** → 404:

```json
{
  "mensaje": "No existe el paciente"
}
```

**GET /patients/1/admissions** → 200 con los ingresos de ese paciente, cada uno con `admissionDate`, `diagnosis` y `doctorName` (nombre completo del médico tratante, armado en el SELECT con `||`). Si el paciente existe pero no tiene ingresos, la respuesta es **200 con un arreglo vacío `[]`**: no es 404, porque el paciente sí existe. Hay 306 ingresos entre 258 pacientes: si la lista de un Id viene vacía, probar con otro.

## 5. Ejercicio independiente (55 min)

### Consigna

Migrar el recurso médicos al mismo proyecto, replicando el patrón exacto de la práctica guiada. Cambian la tabla, las columnas y el DTO; la estructura no cambia:

1. `GET /doctors`: listado de los 27 médicos, ordenados por apellido. Necesita un DTO propio (record `Doctor` con propiedades `DoctorId`, `FirstName`, `LastName` y `Specialty`), como el record `Province` de la clase 13.
2. `GET /doctors/{id:int}`: un médico por Id; si no existe, 404 con mensaje en JSON.
3. Desafío final: `GET /doctors/{id:int}/patients`: los pacientes atendidos por ese médico (JOIN de `admissions` con `patients`, filtrando por `attending_doctor_id`). 404 si el médico no existe. Atención: un paciente con varios ingresos atendidos por el mismo médico aparece repetido; la pista está en una palabra: `DISTINCT`.

### Pista

El patrón es exactamente el de `/patients`: mismo esquema de verificación de existencia con `int?`, mismo `WHERE` con objeto anónimo, mismo 404. Cambiar tres cosas y nada más: la tabla, las columnas del SELECT (con alias AS alineado al record) y el nombre del DTO. Para el desafío, el DTO puede ser un record `PatientBrief` con `PatientId`, `FirstName`, `LastName` y `Gender`. La solución completa está en el anexo docente.

## 6. Cierre (20 min)

### Qué te llevás (cierre de la Unidad 2)

- La base de datos real: hospital.db, 4 tablas relacionadas y sus volúmenes (Encuentro 10).
- Conexión con `Microsoft.Data.Sqlite` y consultas con `Query<T>` mapeadas a records DTO con alias AS (Encuentro 11).
- Filtros `WHERE` con parámetros (objeto anónimo, nunca concatenados) y `LIKE` (Encuentro 12).
- `JOIN` de dos tablas con alias cortos y columnas calificadas (Encuentro 13).
- La migración completa: misma API y mismos códigos HTTP; lo único que cambió es de dónde vienen los datos (Encuentro 14).

### Lo que viene: tp-u2 (Encuentro 15)

- Qué es: trabajo práctico integrador de la Unidad 2 sobre hospital.db, construido sobre el proyecto de hoy: endpoints GET con listado, detalle por Id, filtro (parámetros/LIKE) y JOIN.
- Entrega: por GitHub. Carpeta `tp-u2` en el repositorio, proyecto funcionando y `hospital.db` incluido, commits y push al día: el historial de trabajo es parte de la entrega.
- Defensa: individual y oral, breve, igual que en el tp-u1: se muestran endpoints funcionando, se explica una parte del código señalada por el docente y se responden preguntas con el proyecto a la vista.
- El enunciado completo se presenta al inicio del Encuentro 15. Para prepararse: dejar la migración corriendo, repasar el mapa de la unidad y el cuadro de errores comunes, y ensayar en voz alta la explicación de un endpoint propio.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con la migración completa y el ejercicio terminado, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 14: migracion de endpoints GET a hospital.db (cierre U2)"
git push
```

Importante: verificar que `hospital.db` quedó incluido en el repositorio. El tp-u2 tiene que funcionar en otra máquina después de clonar.

## 7. Errores comunes y trampas (repaso de la unidad)

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Re-declarar `PatientWithProvince` | Copiar el record de la clase 13 cuando ya existe en el archivo | Los DTO existentes se reutilizan; solo se agregan los records nuevos (`AdmissionWithDoctor`) |
| Valor concatenado dentro del SQL (`$"... {id}"`) | Parece más corto que el objeto anónimo | Regla fija del curso desde la clase 12: siempre marcador `@Id` + `new { Id = id }`; concatenar abre la puerta a errores y a inyección SQL |
| Alias AS que no coincide con el record | El nombre de la propiedad del DTO y el de la columna difieren | Comparar columna por columna: alias = nombre exacto de la propiedad (el mapeo de Dapper es por nombre) |
| Confundir 404 con 200 y arreglo vacío | No se distingue "no existe" de "existe y no tiene datos" | 404 solo si el paciente/médico no existe; sin ingresos, 200 con `[]` |
| `hospital.db` fuera de la raíz del proyecto | El archivo quedó en otra carpeta, o falta en el repositorio clonado | Copiarlo junto al `.csproj`; commitearlo para que la entrega funcione en otra máquina |
| Cerrar el encuentro sin commit y push | Falta un encuentro para la entrega y el historial es requisito de la defensa | Rutina Git al cierre de cada encuentro: es parte del trabajo, no un extra |
