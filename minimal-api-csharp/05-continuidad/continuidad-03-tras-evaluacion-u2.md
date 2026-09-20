# Continuidad pedagógica 3 — Repaso acumulativo tras la evaluación de la Unidad 2

> Curso «Minimal API con C# .NET 6». Documento de continuidad pedagógica: actividades de repaso y fijación para una clase sin presencia docente. Se entrega a la administración junto con su anexo docente (`continuidad-03-tras-evaluacion-u2-anexo-docente.md`), de uso exclusivo docente.

## 1. Datos de referencia

| Campo | Detalle |
| --- | --- |
| Curso | Minimal API con C# .NET 6 |
| Documento | Continuidad pedagógica 3 de 4 |
| Momento de uso | Tras la evaluación de la Unidad 2 (aplicable desde el encuentro 16). Repaso acumulativo con énfasis en la Unidad 2 y repaso liviano de la Unidad 1 |
| Duración teórica | 240 minutos (4 horas reloj) |
| Condiciones | Sin presencia docente; resolución en los grupos de trabajo habituales; presentación individual y manuscrita al inicio de la próxima clase |
| Requisitos | PC por grupo con SDK de .NET 6 y VS Code; terminal; navegador; `curl.exe` (PowerShell); archivo `hospital.db` (copia de la institución o del grupo); papel y lápiz para la presentación manuscrita |
| Uso del celular | No permitido |
| Contenidos que repasa | Unidad 2: conexión con `SqliteConnection`, SELECT con alias `AS`, consultas parametrizadas, `WHERE`, `ORDER BY` y query string, `LIKE` con validación 400/404, JOIN de dos tablas, escritura con Dapper (INSERT/UPDATE/DELETE con 201/204/400/404). Unidad 1 (repaso liviano): verbos HTTP y códigos de respuesta |
| Registro | Docente formal (documento institucional) |

## 2. Objetivos

Al finalizar la jornada, cada estudiante puede:

1. Reconstruir sin acompañamiento el entorno de trabajo de la Unidad 2: proyecto con `hospital.db`, paquetes `Microsoft.Data.Sqlite` y `Dapper`, y un primer GET verificado sobre la base.
2. Construir endpoints de lectura parametrizados (por id, ordenados y filtrados por query string) con alias `AS` y respuestas 200 y 404 con mensaje.
3. Buscar por partes del texto con `LIKE` parametrizado, distinguiendo 400 (pedido inválido) de 404 (pedido válido sin resultados).
4. Cruzar dos tablas con `JOIN` y exponer el resultado en un record compuesto.
5. Escribir en la base con INSERT, UPDATE y DELETE parametrizados, y repasar los verbos HTTP y sus códigos de respuesta como marco común de lectura y escritura.

## 3. Actividades (100 puntos; 240 minutos)

Las actividades se resuelven en grupo sobre una única API que crece por hitos dentro de un mismo proyecto. El puntaje de cada actividad se obtiene por verificación de funcionamiento y por lo presentado en la entrega manuscrita individual. Si un grupo no completa todas las actividades, presenta lo alcanzado: cada actividad se corrige por separado.

| Nº | Actividad | Consigna | Puntos | Tiempo |
| --- | --- | --- | --- | --- |
| 1 | Puesta a punto del proyecto | En una carpeta nueva `continuidad-u2` (no hace falta estar dentro del repositorio del grupo): crear el proyecto con `dotnet new web`, copiar `hospital.db` junto al `.csproj` y agregar los paquetes `Microsoft.Data.Sqlite` y `Dapper` con `dotnet add package`. Construir `GET /patients` con Dapper: conexión con `using var`, SELECT con los diez alias `AS` hacia el record `Patient` y respuesta con `Results.Ok`. Correr con `dotnet run` y probar en el navegador. Presentación manuscrita: anotar la cantidad de filas obtenidas (deben ser 258), dos propiedades del JSON escritas en camelCase y una línea que explique por qué los datos sobreviven aunque se apague la API. | 10 | 30 min |
| 2 | Repaso liviano de la Unidad 1: verbos y códigos | Sobre papel, completar a mano el Cuadro 1 de la sección 4.3 (verbo HTTP, para qué sirve, código de éxito típico y método de `Results`, para GET, POST, PUT y DELETE) y responder: (a) ¿qué diferencia hay entre un 400 y un 404?; (b) ¿por qué el POST responde 201 con el recurso mientras el DELETE responde 204 sin cuerpo? Presentación manuscrita: el cuadro completo y las dos respuestas. | 10 | 25 min |
| 3 | Lectura parametrizada: por id, ordenada y por query string | Sobre el mismo proyecto, construir tres endpoints: (1) `GET /patients/{id:long}` con `QueryFirstOrDefault<Patient>`, consulta parametrizada (`WHERE patient_id = @id` + `new { id }`) y 404 con mensaje si el id no existe; (2) `GET /patients` con `ORDER BY last_name, first_name` dentro del SQL; (3) `GET /patients/by-province?province=ON&limit=10` con los dos valores llegando por query string, `LIMIT @max` parametrizado, valor por defecto 10 cuando no viene `limit`, 400 con mensaje si falta la provincia y 404 con mensaje si no hay resultados. Presentación manuscrita: copiar el SELECT del endpoint por id con sus alias, la línea del objeto anónimo y una línea que explique por qué el valor nunca se pega al SQL con `+`. | 20 | 50 min |
| 4 | Búsqueda con LIKE y validación 400/404 | Agregar `GET /patients/by-allergy?allergy=Peni`: búsqueda parcial con `WHERE allergies LIKE @patron`, patrón armado en C# (`$"%{allergy}%"`) y viajando parametrizado. Validar con `string.IsNullOrWhiteSpace`: criterio ausente o vacío responde 400 con mensaje; búsqueda válida sin resultados responde 404 con mensaje (la lista vacía `[]` no es una respuesta aceptable en esta búsqueda). Probar los cuatro casos con `curl.exe -i` o navegador: `allergy=Peni` (200), sin valor (400), `allergy=Kryptonita` (404) y una alergia real como `Sulfa` (200). Presentación manuscrita: copiar el endpoint completo y una tabla de los cuatro casos probados con el código de respuesta de cada uno. | 20 | 45 min |
| 5 | JOIN de dos tablas | Agregar `GET /patients/with-province`: JOIN entre `patients p` y `province_names pn` con `ON p.province_id = pn.province_id`, cada columna calificada con su alias de tabla, y un record compuesto `PatientWithProvince` donde el código `ProvinceId` se reemplaza por el nombre `ProvinceName` (con su alias `AS`). Ordenar por apellido y nombre. Presentación manuscrita: dibujar el cruce (las dos tablas con sus columnas clave y la flecha del `ON`), copiar el record compuesto y explicar en dos líneas qué error produce pedir `province_id` a secas cuando las dos tablas tienen esa columna. | 20 | 45 min |
| 6 | Escritura con Dapper: alta, cambio y baja | Agregar el ciclo completo sobre `doctors`: (1) `POST /doctors` con record de entrada `DoctorInput`, validación de los tres campos (400 con mensaje), alta con `ExecuteScalar<long>` (`INSERT ... ; SELECT last_insert_rowid();`) y respuesta 201 con `Results.Created($"/doctors/{newId}", ...)`; (2) `PUT /doctors/{id:long}` con `Execute` y `WHERE doctor_id = @id`, respondiendo 404 con mensaje si las filas afectadas son 0 y 204 con `Results.NoContent()` si el cambio quedó hecho; (3) `DELETE /doctors/{id:long}` con la misma técnica de filas afectadas (404 o 204). Probar el ciclo con `curl.exe`: alta (201), lectura del médico nuevo, cambio de especialidad (204), baja (204) y lectura posterior (404). La baja se prueba con el médico creado en el propio alta, nunca con un médico original de la base. Presentación manuscrita: el Cuadro 2 de la sección 4.3 completo y las cuatro líneas de `curl.exe` usadas con el código recibido en cada una. | 20 | 45 min |
| | **Total** | | **100** | **240 min** |

## 4. Material de apoyo para las actividades

### 4.1 Recordatorios del canon del curso

| Tema | Regla del curso |
| --- | --- |
| Respuestas | Siempre con `Results`: `Results.Ok(...)` (200), `Results.Created(url, dato)` (201), `Results.NoContent()` (204), `Results.BadRequest(new { mensaje = ... })` (400) y `Results.NotFound(new { mensaje = ... })` (404) |
| Tipos | Ids `long`; fechas `string` en ISO `yyyy-MM-dd`; columnas que admiten `NULL`: `string?` o `int?`; conteos `int` |
| Mapeo | Cada columna `snake_case` con alias `AS` hacia la propiedad PascalCase del record; los records van SIEMPRE al final del archivo, después de `app.Run()` |
| Parametrización | Hueco `@nombre` en el SQL + `new { ... }` con el dato; nunca se concatena el SQL con datos recibidos |
| Rutas | En inglés y en plural: `/patients`, `/doctors`; ids con `{id:long}` y parámetro del handler `(long id)` |
| Conexión | `using var connection = new SqliteConnection(connectionString);` dentro de cada handler: se cierra sola |
| Comentarios | En español, sin tildes ni eñes, explicando cada acción |

### 4.2 Prueba de los endpoints

GET se prueba en el navegador; los demás verbos, con `curl.exe` (en PowerShell, `curl` solo puede ser un alias de `Invoke-WebRequest`). Reemplazar `5080` por el puerto de la línea `Now listening on:` de la terminal. `-i` muestra el código de estado de cualquier pedido.

```powershell
curl.exe -i http://localhost:5080/patients/7
curl.exe -i "http://localhost:5080/patients/by-province?province=ON&limit=3"
curl.exe -i "http://localhost:5080/patients/by-allergy?allergy=Peni"
curl.exe -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"
curl.exe -X PUT http://localhost:5080/doctors/28 -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Neurologist\"}"
curl.exe -X DELETE http://localhost:5080/doctors/28
```

### 4.3 Cuadros para completar a mano

**Cuadro 1 — Actividad 2: verbos y códigos.**

| Verbo | Para qué sirve en la API | Código de éxito típico | Método de `Results` |
| --- | --- | --- | --- |
| GET | | | |
| POST | | | |
| PUT | | | |
| DELETE | | | |

**Cuadro 2 — Actividad 6: escritura con Dapper.**

| Operación | Método de Dapper | Respuesta si todo sale bien | Respuesta si el id no existe |
| --- | --- | --- | --- |
| Alta (POST /doctors) | | | |
| Cambio (PUT /doctors/{id}) | | | |
| Baja (DELETE /doctors/{id}) | | | |

## 5. Autoevaluación del alumno

Cada estudiante completa esta autoevaluación al cierre de la jornada y la adjunta a su presentación manuscrita. Marcar una sola columna por fila; las filas en «Todavía no» son la consulta prioritaria para la próxima clase.

| Nº | Puedo... | Con confianza | Con dudas | Todavía no |
| --- | --- | --- | --- | --- |
| 1 | Reconstruir el proyecto con `hospital.db` y Dapper sin ayuda | | | |
| 2 | Explicar por qué el id va con `long` y la fecha con `string` | | | |
| 3 | Escribir un SELECT con los alias `AS` sin mirar la clase | | | |
| 4 | Parametrizar una consulta (`@id` + `new { id }`) y explicar por qué nunca se concatena | | | |
| 5 | Distinguir cuándo responder 400 y cuándo 404 | | | |
| 6 | Armar un JOIN de dos tablas con alias de tabla y record compuesto | | | |
| 7 | Implementar POST, PUT y DELETE con Dapper eligiendo 201, 204, 400 o 404 | | | |
| 8 | Explicar qué hace `last_insert_rowid()` y qué significa que las filas afectadas sean 0 | | | |

Preguntas de cierre (respuestas breves, a mano):

1. ¿Qué actividad me costó más y por qué?
2. ¿Qué error apareció durante la jornada y cómo lo resolvió el grupo?
3. ¿Qué quiero consultarle al docente cuando vuelva a clase?

## 6. Nota

**Nota (registro académico).** La resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.

Las soluciones completas y los criterios de corrección de esta continuidad constan únicamente en el anexo docente separado (`continuidad-03-tras-evaluacion-u2-anexo-docente.md`), de uso exclusivo docente.
