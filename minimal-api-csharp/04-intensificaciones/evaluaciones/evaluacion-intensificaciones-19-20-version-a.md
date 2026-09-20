# Proyecto puente U1-U2 — Versión A: API de turnos e ingresos

> Dominio de esta versión: turnos (en memoria) e ingresos y médicos (tablas `admissions` y `doctors` de `hospital.db`). Proyecto grupal desarrollado en los Encuentros 19 y 20 (240 minutos teóricos cada uno). Entrega por GitHub en la carpeta `puente-u1-u2/` del repositorio del grupo. Puntaje total: 100 puntos con la rúbrica única. Las condiciones completas están en `evaluacion-intensificaciones-19-20.md`.

## El proyecto

Cada grupo construye **una única Minimal API** que integra las dos unidades: la agenda de turnos vive en memoria (Unidad 1) y las consultas y el alta de médicos se resuelven sobre `hospital.db` (Unidad 2). Todo el código va en `Program.cs`, con los records al final del archivo.

## Paso 0 — Preparar la carpeta del proyecto

Dentro de la raíz del repositorio del grupo (`repo-grupo`):

```powershell
dotnet new web -o puente-u1-u2
cd puente-u1-u2
Copy-Item ..\tp-u2\hospital.db .
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

Verificar que `hospital.db` quedó junto al `.csproj` y que la API corre con `dotnet run`. Primer commit del proyecto:

```powershell
git add .
git commit -m "puente-u1-u2: proyecto creado con la base y los paquetes"
```

## Parte 1 — Agenda de turnos en memoria (Unidad 1) — 30 puntos

Recurso: `appointments` (turnos). La lista se llena con **datos propios del grupo** (5 o 6 turnos iniciales).

Record de la entidad (id `long` + tres campos; la fecha viaja como `string` ISO `yyyy-MM-dd`):

```csharp
record Appointment(long AppointmentId, string PatientName, string Date, string Reason);
```

| Endpoint | Qué hace | Respuestas |
| --- | --- | --- |
| `GET /appointments` | Devuelve la agenda completa | `200` con la lista |
| `GET /appointments/{id:long}` | Devuelve un turno por id | `200`, o `404` con mensaje |
| `POST /appointments` | Da de alta un turno con validación | `201` con la URL del turno nuevo y el turno en el cuerpo, o `400` con mensaje |
| `PUT /appointments/{id:long}` | Reemplaza los datos de un turno | `200`, `400` con mensaje o `404` con mensaje |
| `DELETE /appointments/{id:long}` | Da de baja un turno | `204`, o `404` con mensaje |

Requisitos de la parte:

1. Record de entrada (DTO) para POST y PUT, **sin id**: el id lo asigna la API con un contador.
2. Validación manual: los tres campos obligatorios no pueden quedar vacíos; `400` con mensaje en español y sin tildes.
3. Códigos correctos en todos los casos, siempre con `Results`.
4. La lista vive una sola vez, arriba de los endpoints, compartida por todos.

## Parte 2 — La base `hospital.db` (Unidad 2) — 40 puntos

Cadena de conexión canónica: `"Data Source=hospital.db"`, con la conexión abierta dentro de cada handler y consultas **siempre parametrizadas**.

### 2a — Ingresos de un médico (JOIN de dos tablas) — 15 puntos

| Requisito | Detalle |
| --- | --- |
| Endpoint | `GET /admissions/by-doctor/{id:long}`: los ingresos atendidos por ese médico, con el **nombre completo del médico** en cada fila |
| Consulta | `JOIN` de dos tablas (`admissions` + `doctors`) con `ON` por la clave compartida, columnas con alias y orden por fecha de ingreso |
| Record compuesto | `record AdmissionOfDoctor(string AdmissionDate, string? Diagnosis, string DoctorName);` |
| Respuestas | `200` con la lista, o `404` con mensaje si el médico no tiene ingresos registrados |

### 2b — Buscar médicos por especialidad (LIKE) — 10 puntos

| Requisito | Detalle |
| --- | --- |
| Endpoint | `GET /doctors?text=...`: los médicos cuya especialidad contiene el texto que llega por query string |
| Consulta | Búsqueda parcial con `LIKE` y comodines alrededor del parámetro (nunca concatenada), columnas con alias, orden por especialidad |
| Record | `record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);` |
| Respuestas | `200` con la lista (vacía si no hay coincidencias) |

### 2c — Alta de médico (escritura validada) — 15 puntos

| Requisito | Detalle |
| --- | --- |
| Endpoint | `POST /doctors`: da de alta un médico en la base |
| Cuerpo | Record de entrada `record DoctorInput(string FirstName, string LastName, string Specialty);` |
| Validación | Los tres campos obligatorios no pueden quedar vacíos: `400` con mensaje **antes** de escribir |
| Consulta | `INSERT` parametrizado, con el id generado por la base (`ExecuteScalar<long>` + `last_insert_rowid()`) |
| Respuestas | `201` con la URL del médico nuevo (`/doctors/{id}`) y el médico creado en el cuerpo, o `400` con mensaje |

## Requisitos transversales — 30 puntos

**Convenciones del curso (10 puntos):**

- `Results` explícito en todas las respuestas (nunca el objeto crudo).
- Ids `long` y fechas `string` ISO `yyyy-MM-dd`; `int` solo para conteos.
- Rutas en inglés y en plural, con el filtro `{id:long}` donde va el id.
- Records siempre al final del archivo, después de `app.Run()`.
- Comentarios abundantes en español y sin tildes: el código se tiene que poder leer solo.

**Entrega por GitHub (12 puntos):**

- La carpeta `puente-u1-u2/` queda en la raíz del repositorio del grupo, con el proyecto, `hospital.db` y los dos paquetes.
- Al menos 3 commits de avance con mensajes `puente-u1-u2: resumen de lo hecho` (un requisito funcionando, un commit).
- El `.gitignore` con `bin/` y `obj/` queda en la raíz del repositorio y ninguno de los dos aparece en GitHub.
- El push está hecho y la entrega completa es visible en `github.com` al cierre del bloque de entrega del Encuentro 20.

**Batería de pruebas (4 puntos):**

- Tabla anotada en el cuaderno con cada prueba: URL o comando `curl.exe`, código esperado y código observado. La API está terminada cuando la tabla pasó completa (navegador para los GET, `curl.exe` para el resto).

**Puesta en común (4 puntos):**

- En la plenaria de cierre del Encuentro 20, demo breve del proyecto: cada integrante explica una parte y el grupo comunica decisiones y pendientes.

## Cómo se califica

La misma rúbrica de 100 puntos se aplica a las dos versiones (los criterios 1 a 4 se califican sobre los endpoints de esta consigna; los criterios 5 a 8 son iguales para todos los grupos):

| # | Criterio | Puntos |
| --- | --- | --- |
| 1 | API en memoria: CRUD completo de `appointments` con códigos y validación | 30 |
| 2 | JOIN `admissions` + `doctors` con record compuesto | 15 |
| 3 | Búsqueda con `LIKE` parametrizada sobre `specialty` | 10 |
| 4 | Alta de médico: validación 400, `INSERT` parametrizado, 201 con URL | 15 |
| 5 | Convenciones del curso | 10 |
| 6 | Entrega por GitHub | 12 |
| 7 | Batería de pruebas | 4 |
| 8 | Puesta en común | 4 |
| **Total** | | **100** |
