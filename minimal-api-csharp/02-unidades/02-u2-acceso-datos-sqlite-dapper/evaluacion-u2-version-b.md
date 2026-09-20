# Evaluación de la Unidad 2 — Versión B: Pacientes y provincias del hospital

## Datos

| Campo | Detalle |
|---|---|
| Grupo | ................................ |
| Versión | B — Pacientes y provincias del hospital |
| Encuentro | 15 — Evaluación de la Unidad 2 |
| Duración teórica | 4 h |
| Entrega | Carpeta `tp-u2` del repositorio del grupo (commit y push antes del cierre, con `hospital.db` incluido) |

## Consigna

El hospital necesita consultar sus pacientes con la provincia a la que pertenecen y el historial de ingresos de cada uno. Construir en Program.cs una Minimal API con endpoints GET que respondan con los datos reales de `hospital.db`, usando Dapper y records DTO.

## Requisitos

1. Dentro de la carpeta `tp-u2` del repositorio del grupo, crear el proyecto (`dotnet new web -n HospitalApi`) o copiar el proyecto `HospitalApi` de la clase 14. Verificar que `hospital.db` queda junto al `.csproj` y que `dotnet run` funciona: la entrega debe funcionar en otra máquina después de clonar.
2. `GET /patients`: listado de los 258 pacientes con `patient_id`, `first_name`, `last_name`, `city` y el nombre de la provincia (`JOIN` de `patients` con `province_names`), ordenados por apellido y nombre. DTO: record `PatientWithProvince(long PatientId, string FirstName, string LastName, string? City, string ProvinceName)`.
3. `GET /patients/{id:int}`: un paciente con su provincia por Id; 404 con mensaje en JSON si no existe.
4. `GET /patients/by-city/{city}`: filtro exacto por ciudad (`WHERE p.city = @City` con objeto anónimo, columna calificada con el alias de tabla). Responde 200 con la lista, incluso si viene vacía.
5. `GET /patients/search?lastName=xxx`: búsqueda parcial con LIKE por apellido del paciente. El patrón con `%` se arma en el valor del parámetro, nunca dentro del texto SQL. Responde 200 con la lista, incluso si viene vacía.
6. `GET /patients/{id:int}/admissions`: los ingresos reales del paciente. Primero se verifica que el paciente exista (404 si no); después, JOIN de `admissions` con `doctors` armando el nombre del médico tratante en el SELECT con el operador `||` (`d.first_name || ' ' || d.last_name AS DoctorName`). DTO: record `AdmissionWithDoctor(string AdmissionDate, string Diagnosis, string DoctorName)` — las fechas son TEXT en SQLite: viajan como `string`. Si el paciente existe pero no tiene ingresos, la respuesta es 200 con un arreglo vacío.
7. Los records DTO se declaran al final de Program.cs, después de `app.Run()`, y los ids van con `long` (SQLite entrega los enteros como Int64).
8. Entregar con Git: commits con mensajes referentes y push antes del cierre del encuentro, con `hospital.db` incluido en el repositorio.

## Referencia rápida de hospital.db

| Tabla | Columnas principales | Filas |
|---|---|---|
| patients | patient_id, first_name, last_name, gender, city, province_id | 258 |
| province_names | province_id, province_name | 13 |
| admissions | patient_id, admission_date, diagnosis, attending_doctor_id | 306 |
| doctors | doctor_id, first_name, last_name, specialty | 27 |

Relaciones: `patients.province_id` referencia a `province_names.province_id`; `admissions.patient_id` referencia a `patients.patient_id`; `admissions.attending_doctor_id` referencia a `doctors.doctor_id`.

## Pautas de trabajo

- Todo el código va en Program.cs, tal como se trabajó en la unidad: endpoints arriba y records DTO al final del archivo.
- Los parámetros SQL viajan SIEMPRE en objetos anónimos (`new { Id = id }`): nunca se concatenan valores dentro del texto SQL.
- Incluir comentarios que expliquen las decisiones tomadas (qué consulta resuelve cada endpoint y por qué se eligió cada código de respuesta).
- Las consultas al docente son solo sobre la consigna, no sobre el código.
- El trabajo se realiza en grupo sobre el repositorio propio; no se comparte código con otros grupos.
- Celular: no permitido.

## Qué se evalúa

| Criterio | Puntaje |
|---|---|
| API funcionando sobre hospital.db | 25 |
| Consultas SQL correctas | 20 |
| DTOs y mapeo con Dapper (alias AS, ids long) | 15 |
| Códigos de respuesta correctos (200 / 200 con [] / 404) | 10 |
| Entrega por Git (carpeta tp-u2, commits referentes, push) | 15 |
| Defensa individual (explicar, modificar algo menor y referir devoluciones previas) | 15 |
| **Total** | **100** |

Se aprueba con 60 puntos o más y defensa individual realizada.

---

Nota: la versión asignada no cambia la exigencia. Las versiones A y B tienen las mismas técnicas (listado, detalle por Id, filtro exacto, LIKE, JOIN integrador), la misma rúbrica y la misma dificultad; solo cambian el dominio y las tablas involucradas.
