# Evaluación del especial de marzo — Versión B

> Dominio de esta versión: provincias (tablas `province_names` y `patients` de `hospital.db`). Duración: 90 minutos. Resolución individual, sin celular, sin material consultable salvo lo provisto con esta prueba. Las condiciones completas y el criterio de resultado están en `evaluacion-especiales-marzo.md`.

## Antes de empezar

- El trabajo va en el repositorio del grupo, en la carpeta `especial-marzo/` (o en tu subcarpeta, si rinde más de un integrante del grupo).
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
git commit -m "especial-marzo: primera version de la api"
git push -u origin feature/marzo
# En GitHub web: abrir el pull request de feature/marzo hacia main,
# revisarlo con el docente y fusionarlo. main queda protegida: sin push directo.
```

## Material provisto 2 — Records de la versión (pegar al final de `Program.cs`)

```csharp
record ProvinceCard(string ProvinceId, string ProvinceName);
record PatientSearch(string FirstName, string LastName, string ProvinceName);
record AdmissionsByGender(string Gender, int Total);
record ProvinceInput(string ProvinceId, string ProvinceName);
```

## Material provisto 3 — Columnas de las tablas

| Tabla | Columnas |
| --- | --- |
| `province_names` | `province_id` (TEXT, clave, por ejemplo `ON`) · `province_name` (TEXT, obligatorio) |
| `patients` | `patient_id` (INTEGER, clave) · `first_name` (TEXT, obligatorio) · `last_name` (TEXT, obligatorio) · `gender` (TEXT `M`/`F`, obligatorio) · `birth_date` (TEXT ISO, obligatorio) · `city` (TEXT, puede ser NULL) · `province_id` (TEXT, obligatorio, referencia a `province_names`) · `allergies` (TEXT, puede ser NULL) · `height`, `weight` (INTEGER, pueden ser NULL) |
| `admissions` | `patient_id` (INTEGER, referencia a `patients`) · `admission_date` (TEXT ISO, obligatorio) · `discharge_date` (TEXT ISO, puede ser NULL: ingreso abierto) · `diagnosis` (TEXT, puede ser NULL) · `attending_doctor_id` (INTEGER, referencia a `doctors`) |

## El ejercicio — Mini API de provincias (camino mínimo completo)

| Ítem | Consigna | Tiempo |
| --- | --- | --- |
| 1 | Crear la mini API: dentro de la carpeta `especial-marzo/`, creá el proyecto con los comandos de la hoja, instalá los paquetes, copiá `hospital.db` junto al `.csproj` y corré la API: debe quedar escuchando sin errores | 10 min |
| 2 | Endpoint `GET /provinces/{provinceId}`: devuelve `200` con la provincia cuyo código llega por la ruta (record `ProvinceCard`, SELECT con alias de columnas) o `404` con un mensaje si no existe. Consulta parametrizada, conexión con `using` dentro del handler | 15 min |
| 3 | Endpoint `GET /patients?text=...`: devuelve `200` con los pacientes cuya alergia contiene el texto que llega por query string (búsqueda parcial con `LIKE` parametrizado), cada uno con nombre, apellido y nombre de la provincia (`JOIN` de `patients` con `province_names`, record `PatientSearch`), ordenados por apellido. Los pacientes sin alergia registrada no coinciden con la búsqueda | 15 min |
| 4 | Endpoint `GET /reports/admissions-by-gender`: devuelve `200` con la cantidad de ingresos por género del paciente. La consulta une las tres tablas (`admissions` con `patients` y con `province_names`), agrupa con `GROUP BY` y cuenta con `COUNT(*)` (record `AdmissionsByGender`), ordenada de más a menos ingresos. Dato sucio: los ingresos abiertos todavía no tienen fecha de alta (`discharge_date` en NULL) y quedan fuera del conteo | 25 min |
| 5 | Endpoint `POST /provinces`: recibe una provincia por cuerpo, valida que el código y el nombre no estén vacíos (`400` con mensaje si falta alguno), inserta con `INSERT` parametrizado y responde `201` con la URL de la provincia nueva (`/provinces/{provinceId}`; la clave es el código de texto que llega en el cuerpo: la tabla `province_names` no genera ids numéricos) | 15 min |
| 6 | Constancia en el repositorio del grupo: crear primero el issue «Especial de marzo» en GitHub web (una línea con qué resuelve la API); trabajar en la rama `feature/marzo` con commits referentes; agregar un `README.md` breve en la carpeta del ejercicio (qué resuelve la API y cómo probarla); abrir el pull request, revisarlo con el docente y fusionarlo a `main`; dejar el push hecho | 10 min |
