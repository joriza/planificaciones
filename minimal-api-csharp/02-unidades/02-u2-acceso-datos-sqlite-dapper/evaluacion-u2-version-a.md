# Evaluación de la Unidad 2 — Versión A: Médicos del hospital

## Datos

| Campo | Detalle |
|---|---|
| Grupo | ................................ |
| Versión | A — Médicos del hospital |
| Encuentro | 15 — Evaluación de la Unidad 2 |
| Duración teórica | 4 h |
| Entrega | Carpeta `tp-u2` del repositorio del grupo (commit y push antes del cierre, con `hospital.db` incluido) |

## Consigna

El hospital necesita consultar su cuerpo médico y la cartera de pacientes que atiende cada médico. Construir en Program.cs una Minimal API con endpoints GET que respondan con los datos reales de `hospital.db`, usando Dapper y records DTO.

## Requisitos

1. Dentro de la carpeta `tp-u2` del repositorio del grupo, crear el proyecto (`dotnet new web -n HospitalApi`) o copiar el proyecto `HospitalApi` de la clase 14. Verificar que `hospital.db` queda junto al `.csproj` y que `dotnet run` funciona: la entrega debe funcionar en otra máquina después de clonar.
2. `GET /doctors`: listado de los 27 médicos con `doctor_id`, `first_name`, `last_name` y `specialty`, ordenados por apellido y nombre. DTO: record `Doctor(long DoctorId, string FirstName, string LastName, string Specialty)`.
3. `GET /doctors/{id:int}`: un médico por Id; 404 con mensaje en JSON si no existe.
4. `GET /doctors/by-specialty/{specialty}`: filtro exacto por especialidad (`WHERE specialty = @Specialty` con objeto anónimo). Responde 200 con la lista, incluso si viene vacía.
5. `GET /doctors/search?lastName=xxx`: búsqueda parcial con LIKE por apellido del médico. El patrón con `%` se arma en el valor del parámetro, nunca dentro del texto SQL. Responde 200 con la lista, incluso si viene vacía.
6. `GET /doctors/{id:int}/patients`: los pacientes atendidos por ese médico. Primero se verifica que el médico exista (404 si no); después, JOIN de `admissions` con `patients` filtrando por `attending_doctor_id`. DTO: record `PatientBrief(long PatientId, string FirstName, string LastName, string Gender)`. Atención: un paciente con varios ingresos atendidos por el mismo médico aparece repetido; la pista está en una palabra: `DISTINCT`.
7. Los records DTO se declaran al final de Program.cs, después de `app.Run()`, y los ids van con `long` (SQLite entrega los enteros como Int64).
8. Entregar con Git: commits con mensajes referentes y push antes del cierre del encuentro, con `hospital.db` incluido en el repositorio.

## Referencia rápida de hospital.db

| Tabla | Columnas principales | Filas |
|---|---|---|
| doctors | doctor_id, first_name, last_name, specialty | 27 |
| patients | patient_id, first_name, last_name, gender, city, province_id | 258 |
| admissions | patient_id, admission_date, diagnosis, attending_doctor_id | 306 |
| province_names | province_id, province_name | 13 |

Relaciones: `admissions.patient_id` referencia a `patients.patient_id`; `admissions.attending_doctor_id` referencia a `doctors.doctor_id`; `patients.province_id` referencia a `province_names.province_id`.

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
