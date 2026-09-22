# Continuidad pedagógica 04 — Tras evaluación de U3

## Datos de referencia

| Campo | Valor |
|-------|-------|
| Curso | Minimal API con C# .NET 6 |
| Momento de uso | Tras la evaluación de U3 (encuentro 26) |
| Duración teórica | 240 minutos (4 horas reloj) |
| Requisitos | Computadora, VS Code, SDK .NET 6, terminal. Archivo `hospital.db` disponible. |

## Objetivos de aprendizaje

1. Repasar U1 y U2 como base para el trabajo con operaciones de escritura y modificación.
2. Practicar las operaciones CRUD completas con Dapper: INSERT, DELETE, UPDATE parametrizados.
3. Consolidar el uso de `MapPost`, `MapDelete`, `MapPut` y los códigos de respuesta HTTP (201, 200, 204, 404).
4. Revisar la validación de existencia previa y el manejo de errores en operaciones de escritura.
5. Practicar JOIN triple y consultas complejas que integren múltiples tablas.

## Actividades puntuadas (sobre 100)

### Actividad 1 — Repaso U1+U2 rápido (10 puntos / 20 minutos)

**Consigna:** En la computadora, respondé las siguientes preguntas breves sin escribir código nuevo (solo recordá conceptos).

a) ¿Qué tipos canónicos se usan para las columnas INTEGER y TEXT de SQLite? ¿Por qué no se usa `int` para las claves primarias?

b) ¿Qué error ocurre si se omite el alias `AS` en un SELECT con Dapper?

c) ¿Cuál es la diferencia entre `Results.Ok`, `Results.Created`, `Results.NotFound` y `Results.NoContent`?

d) Escribí la sentencia SQL parametrizada para buscar pacientes cuya ciudad coincida con un patrón dado.

**Puntos:** 10

---

### Actividad 2 — INSERT/DELETE/UPDATE parametrizados (25 puntos / 55 minutos)

**Consigna:** En la computadora, escribí los siguientes endpoints en un proyecto de Minimal API.

a) `POST /patients` — recibe un paciente (sin ID) y lo inserta en la tabla `patients`. Devolvé `Results.Created` con la URL del nuevo recurso y el ID generado. Usá `ExecuteScalar<long>` para obtener el ID.

b) `DELETE /patients/{id:long}` — elimina un paciente por ID. Si no existe, devolvé `Results.NotFound`. Si existe y se elimina, devolvé `Results.NoContent`.

c) `PUT /patients/{id:long}` — actualiza los datos de un paciente existente. Si no existe, devolvé `Results.NotFound`. Si se actualiza correctamente, devolvé `Results.NoContent`.

**Requisitos:**
- Todas las consultas SQL deben ser parametrizadas.
- Usá `Execute` para INSERT/DELETE/UPDATE.
- Usá `ExecuteScalar<long>` para obtener el ID del INSERT.
- Validá la existencia del paciente antes de DELETE y PUT.
- Comentarios en español en cada paso.

**Puntos:** 25

---

### Actividad 3 — MapPost/MapDelete/MapPut y códigos de respuesta (20 puntos / 45 minutos)

**Consigna:** En la computadora, completá las siguientes tareas.

a) Escribí el código C# para un endpoint `POST /doctors` que inserte un médico en la tabla `doctors`. La tabla tiene las columnas `first_name`, `last_name`, `specialty`. Devolvé `Results.Created` con la URL y el ID generado.

b) Escribí el código C# para un endpoint `DELETE /doctors/{id:long}` que elimine un médico. Devolvé `Results.NotFound` si no existe, `Results.NoContent` si se eliminó correctamente.

c) ¿Qué código HTTP se devuelve cuando un DELETE elimina exitosamente un recurso? ¿Y cuando el recurso no existía? ¿Por qué no se devuelve `200 OK` en el DELETE exitoso?

d) ¿Qué diferencia hay entre `Results.NoContent()` y `Results.Ok()` en un endpoint PUT? ¿Cuál es el semánticamente correcto?

**Puntos:** 20

---

### Actividad 4 — Validación de existencia y manejo de errores (15 puntos / 40 minutos)

**Consigna:** En la computadora, escribí un endpoint `POST /admissions` que cree una admisión nueva. La tabla `admissions` tiene las columnas `patient_id`, `doctor_id`, `admission_date`, `discharge_date`.

a) Antes de insertar, validá que el `patient_id` exista en la tabla `patients` y que el `doctor_id` exista en la tabla `doctors`. Si alguno no existe, devolvé `Results.BadRequest` con un mensaje en español que indique cuál no se encontró.

b) Si ambos existen, insertá la admisión y devolvé `Results.Created`.

c) ¿Qué problema podrías tener si dos grupos insertan admisiones para el mismo paciente al mismo tiempo? ¿Cómo lo mitigás? (Solo respuesta conceptual, sin código.)

**Puntos:** 15

---

### Actividad 5 — JOIN triple y consultas complejas (20 puntos / 50 minutos)

**Consigna:** En la computadora, escribí y ejecutá las siguientes consultas contra `hospital.db`.

a) Escribí un SELECT que obtenga el nombre completo del paciente, el nombre del médico y la fecha de admisión para todas las admisiones. Usá JOIN triple (admissions + patients + doctors). Usá alias `AS` para todos los campos.

b) Modificá la consulta anterior para que retorne solo las admisiones donde el médico tenga specialty = 'Cardiología'.

c) Escribí una consulta que cuente cuántas admisiones hay por médico, mostrando el nombre del médico y el conteo. Ordená por cantidad descendente.

d) ¿Qué pasa si un paciente no tiene admisiones en la consulta del inciso a)? Se pierde de los resultados? Explicá qué tipo de JOIN usarías para incluirlo y por qué.

**Puntos:** 20

---

### Actividad 6 — Integración final: CRUD completo en un endpoint (10 puntos / 30 minutos)

**Consigna:** En la computadora, creá un proyecto de Minimal API completo con un solo archivo `Program.cs` que exponga los siguientes endpoints:

a) `GET /patients` — lista completa.
b) `GET /patients/{id:long}` — uno por ID o 404.
c) `POST /patients` — alta con `Results.Created`.
d) `PUT /patients/{id:long}` — actualización o 404.
e) `DELETE /patients/{id:long}` — baja o 404.

**Requisitos:**
- Un solo archivo `Program.cs`.
- Record `Patient` después de `app.Run()`.
- Todos los SQL parametrizados con alias `AS`.
- Códigos de respuesta correctos (200, 201, 204, 404).
- Validación de existencia en PUT y DELETE.
- Comentarios en español.

**Puntos:** 10

---

## Autoevaluación para el alumno

Antes de la próxima clase, respondé con honestidad las siguientes preguntas. No hay puntos en juego; es una herramienta para que identifiques qué repasar.

- ¿Puedo escribir un INSERT parametrizado con `ExecuteScalar<long>` para obtener el ID generado?
- ¿Sé validar la existencia de un recurso antes de DELETE o UPDATE?
- ¿Puedo construir un JOIN triple que integre tres tablas con alias `AS`?
- ¿Entiendo la diferencia semántica entre los códigos 200, 201, 204 y 404?
- ¿Sé manejar errores de validación con `Results.BadRequest`?

Si respondiste "no" a alguna de estas preguntas, repasá la actividad correspondiente antes del próximo encuentro.

## Nota de registro académico

la resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
