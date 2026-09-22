# Continuidad pedagógica 03 — Tras evaluación de U2

## Datos de referencia

| Campo | Valor |
|-------|-------|
| Curso | Minimal API con C# .NET 6 |
| Momento de uso | Tras la evaluación de U2 (encuentro 15) |
| Duración teórica | 240 minutos (4 horas reloj) |
| Requisitos | Computadora, VS Code, SDK .NET 6, terminal. Archivo `hospital.db` disponible. |

## Objetivos de aprendizaje

1. Consolidar los conocimientos de U1 (tipos, control de flujo, métodos, endpoint GET) como base para el trabajo con bases de datos.
2. Repasar las operaciones SQL fundamentales: SELECT, WHERE, ORDER BY.
3. Practicar el uso de Dapper con `Query<T>`, alias `AS` y parámetros.
4. Aplicar `LIKE` en consultas parametrizadas y construir endpoints GET que integren Dapper con filtrado.

## Actividades puntuadas (sobre 100)

### Actividad 1 — Repaso tipos y control de flujo de U1 (10 puntos / 25 minutos)

**Consigna:** En la computadora, escribí un método `string ClassifyPatient(long? height, long? weight)` que clasifique a un paciente según su IMC aproximado.

- Si `height` o `weight` son nulos, devolvé `"Datos incompletos"`.
- Si `height ≤ 0` o `weight ≤ 0`, devolvé `"Datos inválidos"`.
- Calcular IMC ≈ `weight / (height * height) * 10000` (peso en gramos, altura en centímetros).
- Si IMC < 18.5 → `"Bajo peso"`, 18.5 ≤ IMC < 25 → `"Normal"`, 25 ≤ IMC < 30 → `"Sobrepeso"`, IMC ≥ 30 → `"Obesidad"`.

Probá con estos datos:
a) height = 175, weight = 75000 → esperado: `"Normal"`
b) height = null, weight = 75000 → esperado: `"Datos incompletos"`
c) height = 160, weight = 95000 → esperado: `"Obesidad"`

**Puntos:** 10

---

### Actividad 2 — Repaso métodos y endpoint GET de U1 (10 puntos / 25 minutos)

**Consigna:** En la computadora, creá un endpoint `GET /doctors` que retorne la lista de médicos con los campos `doctor_id AS DoctorId`, `first_name AS FirstName`, `last_name AS LastName`, `specialty AS Specialty`. Usá `Query<Doctor>` con alias `AS`.

Luego creá un segundo endpoint `GET /doctors/{id:long}` que retorne un médico por ID o `Results.NotFound` si no existe.

**Requisitos:**
- El record `Doctor` debe ir después de `app.Run()`.
- Toda consulta debe ser parametrizada.
- Tipos canónicos: `long` para INTEGER, `string` para TEXT.

**Puntos:** 10

---

### Actividad 3 — SQL básico: SELECT, WHERE, ORDER BY (20 puntos / 50 minutos)

**Consigna:** En la computadora, abrí la base `hospital.db` con una herramienta SQLite o desde código y ejecutá las siguientes consultas. Escribí la consulta SQL y el resultado esperado.

a) Escribí un SELECT que obtenga `first_name`, `last_name` y `city` de la tabla `patients` donde `city = 'Buenos Aires'`, ordenado por `last_name` ascendente.

b) Escribí un SELECT que obtenga `first_name`, `last_name` y `birth_date` de `patients` donde `birth_date >= '1990-01-01'`, ordenado por `birth_date` descendente.

c) ¿Qué diferencia hay entre `WHERE city = 'Buenos Aires'` y `WHERE city LIKE 'Buenos Aires'`? ¿Cuándo usarías cada uno?

d) Escribí un SELECT que cuente cuántos pacientes hay por ciudad. Agrupá por `city` y ordená por cantidad descendente. Usá `ExecuteScalar<long>` o `Query` con un tipo apropiado.

**Puntos:** 20

---

### Actividad 4 — Dapper: Query<T> con alias AS y parámetros (25 puntos / 55 minutos)

**Consigna:** En la computadora, escribí un endpoint `GET /patients/search` que reciba dos parámetros de query string: `city` (opcional) y `minHeight` (opcional, tipo `long?`). El endpoint debe:

a) Si se proporciona `city`, filtrar pacientes por ciudad con `LIKE @city` (usando `%valor%`).
b) Si se proporciona `minHeight`, filtrar pacientes con `height >= @minHeight`.
c) Si no se proporciona ninguno, retornar todos los pacientes.
d) Usar siempre alias `AS` en el SELECT y parámetros `@city`, `@minHeight`.

**Requisitos:**
- Construir la consulta SQL dinámicamente o con condicionales en C#.
- Toda consulta debe ser parametrizada (nunca concatenar).
- El record `Patient` debe estar después de `app.Run()`.
- Comentarios en español en cada paso.

**Puntos:** 25

---

### Actividad 5 — LIKE y consultas con parámetros (15 puntos / 40 minutos)

**Consigna:** En la computadora, escribí y ejecutá las siguientes consultas parametrizadas contra `hospital.db`.

a) Buscar pacientes cuyo `first_name` empiece con la letra 'M'. Usá `LIKE @name` con el parámetro `new { name = "M%" }`.

b) Buscar pacientes cuya `city` contenga la subcadena 'san' (sin importar mayúsculas/minúsculas). Usá `LIKE @city` con el patrón apropiado. ¿Qué problema podés tener con mayúsculas/minúsculas en SQLite? ¿Cómo lo resolvés?

c) Escribí un endpoint `GET /patients/bycity/{city}` que use `LIKE` con el patrón `%city%` y retorne `Results.NotFound(new { mensaje = "No se encontraron pacientes en esa ciudad" })` si la lista está vacía.

**Puntos:** 15

---

### Actividad 6 — Integración: endpoint GET con Dapper y filtrado (20 puntos / 45 minutos)

**Consigna:** En la computadora, creá un proyecto de Minimal API completo que exponga los siguientes endpoints:

a) `GET /patients` — lista completa de pacientes con todos los campos.
b) `GET /patients/{id:long}` — un paciente por ID o 404.
c) `GET /patients/search?city={city}&minHeight={minHeight}` — filtrado combinado (ambos parámetros opcionales).

**Requisitos:**
- Un solo archivo `Program.cs`.
- Record `Patient` después de `app.Run()`.
- Todos los SQL parametrizados con alias `AS`.
- Códigos de respuesta correctos (200, 404).
- Comentarios en español.

**Puntos:** 20

---

## Autoevaluación para el alumno

Antes de la próxima clase, respondé con honestidad las siguientes preguntas. No hay puntos en juego; es una herramienta para que identifiques qué repasar.

- ¿Puedo escribir una consulta SQL con WHERE, ORDER BY y GROUP BY?
- ¿Sé usar Dapper para ejecutar `Query<T>` con alias `AS` y parámetros `@nombre`?
- ¿Puedo construir un endpoint GET que filtre por parámetros de query string?
- ¿Entiendo por qué `LIKE` con `%` permite búsquedas parciales y cómo parametrizarlo correctamente?
- ¿Sé manejar valores nulos (`long?`, `string?`) en los parámetros de entrada?

Si respondiste "no" a alguna de estas preguntas, repasá la actividad correspondiente antes del próximo encuentro.

## Nota de registro académico

la resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
