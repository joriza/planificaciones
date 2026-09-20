# Evaluación de la intensificación de marzo — Versión A

> Dominio de esta versión: ingresos (tablas `admissions` y `doctors` de `hospital.db`). Duración: 90 minutos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas y el criterio de resultado están en `evaluacion-intensificaciones-marzo.md`.

## Antes de empezar

- El trabajo va en el repositorio del grupo, en la carpeta `intensificaciones-marzo/` (o en tu subcarpeta, si rinde más de un integrante del grupo).
- Todo el código va en `Program.cs`; los records provistos se pegan siempre al final del archivo, después de `app.Run()`.
- Convenciones del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results`, consultas siempre parametrizadas, comentarios en el código.
- Probás los GET en el navegador y el resto de los verbos con `curl` de una línea.
- Al terminar (o al agotarse el tiempo), avisá al docente y dejá el repositorio con el push hecho.

## Material provisto 1 — Hoja de comandos

Comandos de creación de la API (dentro de la carpeta del ejercicio):

```powershell
dotnet new web
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
# Copiar hospital.db junto al .csproj y correr la API (Ctrl+C la corta)
dotnet run
```

Comandos del flujo del repositorio (ítem 6), desde la raíz del repositorio del grupo:

```powershell
git checkout main
git checkout -b feature/marzo
git add .
git commit -m "intensificaciones-marzo: primera version de la api"
git push -u origin feature/marzo
# En GitHub web: abrir el pull request de feature/marzo hacia main,
# revisarlo con el docente y fusionarlo. main queda protegida: sin push directo.
```

## Material provisto 2 — Records de la versión (pegar al final de `Program.cs`)

```csharp
record AdmissionDetails(string AdmissionDate, string? DischargeDate, string? Diagnosis);
record AdmissionSearch(string AdmissionDate, string? Diagnosis, string DoctorName);
record AdmissionsByDoctor(string DoctorName, int Total);
record AdmissionInput(long PatientId, string AdmissionDate, string? Diagnosis, long AttendingDoctorId);
```

## Material provisto 3 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `admissions` | `patient_id` (INTEGER, referencia a `patients`) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL: ingreso abierto) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors`). La clave del ingreso es compuesta (`patient_id` + `admission_date`): no hay columna de id |
| `doctors` | `doctor_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `specialty` (TEXT, obligatorio) |
| `patients` | `patient_id` (INTEGER, clave) · `first_name`, `last_name` (TEXT, obligatorios) · `province_id` (TEXT, referencia a `province_names`) · resto demográfico |

## El ejercicio — Mini API de ingresos (camino mínimo completo)

| Ítem | Consigna | Tiempo |
| --- | --- | --- |
| 1 | Crear la mini API: dentro de la carpeta `intensificaciones-marzo/`, creá el proyecto con los comandos de la hoja, instalá los paquetes, copiá `hospital.db` junto al `.csproj` y corré la API: debe quedar escuchando sin errores | 10 min |
| 2 | Endpoint `GET /admissions/{patientId:long}/{admissionDate}`: devuelve `200` con el ingreso del paciente cuya fecha llega por la ruta (record `AdmissionDetails`, SELECT con alias de columnas: fecha de ingreso, fecha de alta y diagnóstico) o `404` con un mensaje si no existe. Consulta parametrizada, conexión con `using` dentro del handler | 15 min |
| 3 | Endpoint `GET /admissions?text=...`: devuelve `200` con los ingresos cuyo médico tratante tiene un apellido que contiene el texto que llega por query string (búsqueda parcial con `LIKE` parametrizado), cada uno con fecha de ingreso, diagnóstico y nombre completo del médico (`JOIN` de `admissions` con `doctors`, record `AdmissionSearch`), ordenados por fecha de ingreso | 15 min |
| 4 | Endpoint `GET /reports/admissions-by-doctor`: devuelve `200` con la cantidad de ingresos por médico tratante (nombre completo). La consulta une las tres tablas (`admissions` con `patients` y con `doctors`), agrupa con `GROUP BY` y cuenta con `COUNT(*)` (record `AdmissionsByDoctor`), ordenada de más a menos ingresos. Dato sucio: los ingresos abiertos todavía no tienen fecha de alta (`discharge_date` en NULL) y quedan fuera del conteo | 25 min |
| 5 | Endpoint `POST /admissions`: recibe un ingreso por cuerpo, valida que el paciente y el médico tratante estén indicados (ids distintos de 0) y que la fecha de ingreso no esté vacía (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado y responde `201` con la URL del ingreso nuevo (`/admissions/{patientId}/{admissionDate}`; la clave es compuesta y no hay id generado). Para probar, usá ids de paciente y de médico que existan en la base | 15 min |
| 6 | Constancia en el repositorio del grupo: crear primero el issue «Intensificación de marzo» en GitHub web (una línea con qué resuelve la API); trabajar en la rama `feature/marzo` con commits referentes; agregar un `README.md` breve en la carpeta del ejercicio (qué resuelve la API y cómo probarla); abrir el pull request, revisarlo con el docente y fusionarlo a `main`; dejar el push hecho | 10 min |
