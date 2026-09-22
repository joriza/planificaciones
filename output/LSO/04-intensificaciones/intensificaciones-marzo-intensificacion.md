# Intensificación de marzo — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de marzo (fuera de la estructura anual, previa al nuevo ciclo) |
| Duración | 2 encuentros × 240 min (4 horas reloj cada uno) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en la instancia de diciembre |
| Requisitos | Haber cursado la totalidad del año y la instancia de diciembre; contar con cuenta de GitHub activa y repo grupal clonado; asistencia obligatoria |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |
| Evaluación | Camino mínimo completo del curso (mismo estándar que diciembre). Criterio: **Apto / No apto aún por objetivo mínimo**. No baja el estándar; cambia el tiempo de preparación del estudiante (diciembre → marzo). |
| Uso de celular | No permitido |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| **Contenidos** | Camino mínimo completo del curso (idéntico al de diciembre): 1) tipos C# (`int`, `long`, `float`, `string`, `bool`) y entrada/salida (`Console.WriteLine`, `Console.ReadLine`); 2) control de flujo (`if`/`else`, `switch`, `for`, `while`); 3) métodos (`static`, parámetros, `return`); 4) Minimal API: endpoint GET con `MapGet`, parámetros de ruta y query; 5) conexión a SQLite (`Data Source=hospital.db`); 6) consultas Dapper parametrizadas (`Query<T>`, `QueryFirstOrDefault<T>`, `Execute`, `ExecuteScalar<long>`); 7) operaciones CRUD con `MapPost` (201), `MapPut` (200), `MapDelete` (204/404); 8) validación de existencia y códigos HTTP (200/201/204/400/404); 9) triple JOIN con alias `AS`; 10) LIKE para búsqueda por patrón; 11) entregas por GitHub del repo grupal (carpetas `tp-u1/` a `trabajo-final/`); 12) defensa oral del programa presentado. Dominio: hospital (pacientes, doctores, admisiones, provincias). |
| **Actividad / metodología** | El estudiante tuvo más tiempo para prepararse (diciembre a marzo). La instancia presencial se organiza como taller de verificación: el docente revisa el programa que el estudiante trae preparado y asiste en los puntos que todavía presenten dificultad. Encuentro 1: verificación de objetivos 1 a 6 (tipos, control de flujo, métodos, endpoint GET, conexión a SQLite, SELECT con WHERE y LIKE). Encuentro 2: verificación de objetivos 7 a 12 (CRUD completo, triple JOIN, entrega GitHub y defensa). |
| **Recursos** | VS Code, terminal, `hospital.db` copiado al lado del `.csproj`, repo grupal clonado, guía paso a paso del camino mínimo (impresa desde diciembre), lista de verificación de objetivos por alumno con el registro de diciembre, plantilla README. |

## Desarrollo del Encuentro 1

### Apertura (15 min)

El docente da la bienvenida a la instancia de marzo. Explica que el estándar es el mismo que en diciembre: "No bajamos la exigencia — ustedes tuvieron más tiempo para preparar cada objetivo. Hoy verificamos lo que traen." Cada estudiante recibe su lista de verificación individual actualizada con los objetivos pendientes desde diciembre. **No se permite celular.**

### Desarrollo — Bloque 1: Verificación de tipos, control de flujo y primer endpoint (55 min)

1. **(15 min)** Verificación 1 — programa base: el estudiante muestra su archivo `Program.cs`. El docente revisa que declare variables correctamente con tipos canónicos (`long`, `string`, `string?`), use `Console.ReadLine` con conversión de tipos y muestre con `Console.WriteLine`. Marca objetivo como logrado en la lista.
2. **(15 min)** Verificación 2 — control de flujo: mostrar la validación de edad (menor de 18) y nombre vacío con `if`/`else`. Si no está implementado, se guía su creación en vivo.
3. **(15 min)** Verificación 3 — métodos: mostrar la refactorización del programa anterior para que la validación de edad y la validación de nombre sean métodos `static` separados con retorno y parámetros. El docente verifica que los métodos tengan firma correcta.
4. **(10 min)** Verificación 4 — primer endpoint GET: el estudiante ejecuta `dotnet run` y muestra el endpoint funcionando en el navegador o con `curl`. Si falta, se completa con asistencia.

### Desarrollo — Bloque 2: Verificación de conexión a SQLite y consultas básicas (55 min)

1. **(15 min)** Verificación 5 — conexión a `hospital.db`: el estudiante muestra la cadena de conexión, la apertura de conexión con `using var connection = new SqliteConnection(...)` y la ejecución de un SELECT simple. El docente verifica que la conexión se cierra correctamente.
2. **(15 min)** Verificación 6 — SELECT con WHERE y parámetro: el estudiante ejecuta el endpoint GET `/patients/{id:long}` y muestra que devuelve el paciente correcto o 404 si no existe. El docente verifica que use `QueryFirstOrDefault` y tipos canónicos.
3. **(15 min)** Verificación 7 — LIKE para búsqueda parcial: el estudiante ejecuta el endpoint GET `/patients/search?name=...` y muestra que devuelve la lista filtrada. El docente verifica que use parámetros parametrizados (`@name` con `new { name = $"%{query}%" }`).
4. **(10 min)** Verificación 8 — alias `AS` y tipos canónicos: el docente revisa que el record use `long PatientId` (no `int`) y que el SELECT use `SELECT patient_id AS PatientId, first_name AS FirstName, ...`. Marca objetivo como logrado o pendiente.

### Cierre (15 min)

El docente registra los objetivos logrados en el encuentro. Si un estudiante completó todos los objetivos 1 a 8, recibe el pase al encuentro 2 para CRUD, triple JOIN y defensa. Si no, se le asigna trabajo adicional para el segundo encuentro. Cada estudiante hace commit si hubo modificaciones.

### Errores comunes y trampas

1. **Declarar el ID como `int` en el record.** Causa: `InvalidOperationException`: Dapper busca constructor `(Int64, String)` porque SQLite INTEGER devuelve `Int64`, pero el record ofrece `(int, String)`. Fix: usar `long PatientId` en todos los records.
2. **SELECT sin alias `AS` en snake_case.** Causa: `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` (snake_case) en lugar de `PatientId` (PascalCase). Fix: usar `SELECT patient_id AS PatientId, ...`.
3. **Concatenar el parámetro de búsqueda al SQL en lugar de usar LIKE con parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis. Fix: usar `WHERE first_name LIKE @name` con `new { name = $"%{query}%" }`.
4. **No cerrar la conexión con `using`.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint.
5. **Devolver el objeto crudo sin `Results`.** Causa: viola la convención del curso. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.
6. **Records antes de `app.Run()`.** Causa: Error CS8803. Fix: escribir `app.Run();` y después los records.

---

## Desarrollo del Encuentro 2

### Apertura (15 min)

Repaso de los objetivos de CRUD, triple JOIN y entrega. El docente muestra en vivo la estructura esperada del proyecto completo y recuerda que el README y la defensa son parte de la evaluación. **No se permite celular.**

### Desarrollo — Bloque 3: Verificación de CRUD — POST, PUT, DELETE (55 min)

1. **(15 min)** Verificación 9 — INSERT con `MapPost`: el estudiante muestra el endpoint POST `/patients` que agrega un paciente a `hospital.db` con `Execute`, obtiene el ID generado con `ExecuteScalar<long>`, y devuelve `Results.Created`. El docente verifica que use parámetros parametrizados.
2. **(15 min)** Verificación 10 — UPDATE con `MapPut`: el estudiante muestra el endpoint PUT `/patients/{id:long}` que actualice un paciente existente. Devuelve 200 si se actualizó, 404 si no existía. El docente verifica cada implementación.
3. **(15 min)** Verificación 11 — DELETE con `MapDelete`: el estudiante muestra el endpoint DELETE `/patients/{id:long}` que elimine un paciente. Devuelve 204 si se eliminó, 404 si no existía. El docente verifica la validación de existencia antes de eliminar.
4. **(10 min)** Verificación 12 — validación de existencia antes de cada operación de escritura: el docente revisa que el estudiante verifique con `QueryFirstOrDefault` que el recurso exista antes de UPDATE o DELETE. Si no existe, debe devolver 404.

### Desarrollo — Bloque 4: Verificación de triple JOIN y operaciones avanzadas (55 min)

1. **(15 min)** Verificación 13 — triple JOIN: el estudiante muestra el endpoint GET `/admissions/{id:long}` que devuelva una admisión con los datos completos del paciente y el doctor usando JOIN y alias `AS`. El docente verifica que los tipos se mapean correctamente.
2. **(15 min)** Verificación 14 — LIKE en lectura avanzada: el estudiante muestra el endpoint GET `/patients-by-province/{provinceId:long}` que use JOIN entre patients y provinces. El docente verifica que funcione contra `hospital.db`.
3. **(15 min)** Verificación 15 — `ExecuteScalar<long>` para conteos: el estudiante muestra el endpoint GET `/patients/count` o `/admissions/count-by-doctor/{doctorId:long}` que devuelva un conteo. El docente verifica que use `ExecuteScalar<long>`.
4. **(10 min)** Verificación 16 — prueba completa de endpoints: cada estudiante prueba los endpoints POST, PUT, DELETE y triple JOIN con `curl` o Thunder Client. El docente verifica que cada endpoint funcione correctamente.

### Desarrollo — Bloque 5: Verificación de entrega GitHub y defensa (55 min)

1. **(15 min)** Verificación 17 — README de portada: el estudiante muestra el `README.md` con título, descripción, tecnologías, cómo ejecutar y ejemplo de uso para cada endpoint. Si falta, se completa en el encuentro.
2. **(15 min)** Verificación 18 — commit final y push: el estudiante muestra el commit final (`"feat: camino mínimo completo — CRUD, triple JOIN y README"`) en el repo grupal. Verificar que GitHub muestre el archivo `Program.cs` y el `README.md`.
3. **(15 min)** Verificación 19 — defensa oral: cada estudiante explica brevemente (2-3 minutos): qué hace el proyecto, cómo conecta los conocimientos de cada unidad, y una operación CRUD que le haya costado más.
4. **(10 min)** Verificación 20 — cierre: el docente recorre los puestos con la lista de verificación y marca cada objetivo como logrado o pendiente.

### Cierre con evaluación (15 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente:
- Qué hace el proyecto
- Cómo valida los datos de entrada
- Cómo conecta U1 (endpoints Minimal API) con U2 (consultas Dapper a SQLite)
- Una operación CRUD que le haya costado implementar

Si el estudiante cumple todos los objetivos (1 a 20), recibe **Apto**. Si falta alguno, se registra como **No apto aún por objetivo mínimo** y se detalla qué objetivo(s) no alcanzó, junto con la recomendación de recursar la materia si el período lo permite.

### Errores comunes y trampas

1. **Declarar el ID como `int` en el record.** Causa: `InvalidOperationException`: Dapper busca constructor `(Int64, String)` porque SQLite INTEGER devuelve `Int64`, pero el record ofrece `(int, String)`. Fix: usar `long PatientId` en todos los records.
2. **Fecha declarada como `DateTime` o `DateOnly`.** Causa: `InvalidOperationException`: Dapper recibe `String` de la columna TEXT y no encuentra constructor que acepte `DateTime`/`DateOnly`. Fix: usar `string BirthDate` en el record. Convertir con `DateTime.Parse()` solo al presentar.
3. **SELECT sin alias `AS` en snake_case.** Causa: `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` (snake_case) en lugar de `PatientId` (PascalCase). Fix: usar `SELECT patient_id AS PatientId, ...`.
4. **Concatenar datos al SQL en lugar de parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis. Fix: usar `@id` y `new { id }` en toda consulta.
5. **No cerrar la conexión con `using`.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint.
6. **Devolver el objeto crudo sin `Results`.** Causa: ASP.NET serializa con nombres del record sin configuración adicional, pero viola la convención del curso. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.
7. **No proteger `main` con ramas por feature.** Causa: los alumnos hacen push directo a `main` y generan conflictos. Fix: se refuerza que desde la Unidad 4 se usan ramas por feature y PR revisados.

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El estudiante presenta un proyecto Minimal API completo (tipos canónicos, control de flujo, CRUD con Dapper, triple JOIN, respuestas HTTP correctas) contra `hospital.db`. El código está en GitHub con README. Durante la defensa explica el funcionamiento general, cómo valida los datos y al menos una operación CRUD en detalle. |
| **No apto aún por objetivo mínimo** | El estudiante no completa alguno de los componentes del camino mínimo, no puede sostener una explicación coherente de su propio código, o no entregó el programa en GitHub. Recibe el detalle de objetivos pendientes y la comunicación formal del resultado. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante presenta un proyecto Minimal API completo (entrada validada, control de flujo, CRUD con Dapper, triple JOIN, respuestas HTTP correctas) contra `hospital.db`. El código está en GitHub con README. Durante la defensa explica el funcionamiento general, cómo valida los datos y al menos una operación CRUD en detalle. |
| No apto | El estudiante no completa alguno de los componentes del camino mínimo, no puede sostener una explicación coherente de su propio código, o no entregó el programa en GitHub. Recibe el detalle de objetivos pendientes y la comunicación formal del resultado. |
