# Intensificación de diciembre — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de diciembre (fuera de la estructura anual) |
| Duración | 2 encuentros × 240 min (4 horas reloj cada uno) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos del curso durante el ciclo lectivo |
| Requisitos | Haber cursado la totalidad del año; tener cuenta de GitHub activa y repo grupal clonado; asistencia obligatoria |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |
| Evaluación | Camino mínimo completo del curso. Criterio: **Apto / No apto aún por objetivo mínimo**. No hay puntaje numérico. |
| Uso de celular | No permitido |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| **Contenidos** | Camino mínimo completo del curso: 1) tipos C# (`int`, `long`, `float`, `string`, `bool`) y entrada/salida (`Console.WriteLine`, `Console.ReadLine`); 2) control de flujo (`if`/`else`, `switch`, `for`, `while`); 3) métodos (`static`, parámetros, `return`); 4) Minimal API: endpoint GET con `MapGet`, parámetros de ruta y query; 5) conexión a SQLite (`Data Source=hospital.db`); 6) consultas Dapper parametrizadas (`Query<T>`, `QueryFirstOrDefault<T>`, `Execute`, `ExecuteScalar<long>`); 7) operaciones CRUD con `MapPost` (201), `MapPut` (200), `MapDelete` (204/404); 8) validación de existencia y códigos HTTP (200/201/204/400/404); 9) triple JOIN con alias `AS`; 10) LIKE para búsqueda por patrón; 11) entregas por GitHub del repo grupal (carpetas `tp-u1/` a `trabajo-final/`); 12) defensa oral del programa presentado. Dominio: hospital (pacientes, doctores, admisiones, provincias). |
| **Actividad / metodología** | Recorrido acelerado por los contenidos mínimos del año con énfasis en los objetivos no alcanzados. Cada estudiante reconstruye —o completa— un proyecto integrador de Minimal API que consulta `hospital.db` con Dapper, dividido en dos encuentros. Encuentro 1: tipos, control de flujo, endpoint GET, conexión a SQLite, SELECT con WHERE y LIKE. Encuentro 2: CRUD completo (POST, PUT, DELETE), triple JOIN, entregas GitHub y defensa. |
| **Recursos** | VS Code, terminal, `hospital.db` copiado al lado del `.csproj`, repo grupal clonado, guía paso a paso del camino mínimo (impresa), lista de verificación de objetivos por alumno con el registro de diciembre anterior, plantilla README. |

## Desarrollo del Encuentro 1

### Apertura (15 min)

El docente explica la modalidad de la instancia de diciembre: "No es un curso nuevo — es la oportunidad de demostrar que pueden hacer el camino mínimo. Cada objetivo que logren hoy es un objetivo aprobado." Se entrega la lista de verificación individual con los objetivos no alcanzados de cada alumno. **No se permite celular.**

### Desarrollo — Bloque 1: Tipos, control de flujo y primer endpoint (55 min)

1. **(15 min)** Ejercicio 1 — programa base: crear un archivo `Program.cs`. Declarar variables con los tipos correctos para representar un paciente (`long PatientId`, `string FirstName`, `string LastName`, `string? City`). Pedir datos con `Console.ReadLine` y convertir con `long.Parse`. Mostrar con `Console.WriteLine`.
2. **(15 min)** Ejercicio 2 — control de flujo: agregar validación. Si el paciente tiene menos de 18 años, mostrar "Menor de edad, no se puede registrar". Si el nombre está vacío, mostrar "El nombre es obligatorio". Usar `if`/`else`.
3. **(15 min)** Ejercicio 3 — métodos: refactorizar el programa anterior para que la validación de edad y la validación de nombre sean métodos `static bool` separados con retorno y parámetros. Llamarlos desde el bloque principal.
4. **(10 min)** Ejercicio 4 — primer endpoint GET: convertir el programa de consola a una Minimal API. Agregar `WebApplication.CreateBuilder`, `builder.Build()`, un endpoint `MapGet` que devuelva un mensaje de texto, y `app.Run()`. Ejecutar con `dotnet run` y probar en el navegador.

### Desarrollo — Bloque 2: Conexión a SQLite y consultas básicas (55 min)

1. **(15 min)** Ejercicio 5 — conexión a `hospital.db`: agregar `using Dapper;` y `using Microsoft.Data.Sqlite;`, cadena de conexión `"Data Source=hospital.db"`, `using var connection = new SqliteConnection(connectionString)`. El docente modela la apertura y cierre de conexión.
2. **(15 min)** Ejercicio 6 — SELECT con WHERE y parámetro: endpoint GET `/patients/{id:long}` que devuelva un paciente por ID usando `QueryFirstOrDefault<Patient>`. Verificar que funcione contra `hospital.db`.
3. **(15 min)** Ejercicio 7 — LIKE para búsqueda parcial: endpoint GET `/patients/search?name=...` que use `WHERE first_name LIKE @name` con `new { name = $"%{query}%" }` y devuelva `Results.Ok(patients)`.
4. **(10 min)** Ejercicio 8 — tipos canónicos y alias `AS`: verificar que el record use `long PatientId` (no `int`) y que el SELECT use `SELECT patient_id AS PatientId, first_name AS FirstName, ...`. El docente verifica cada implementación.

### Desarrollo — Bloque 3: Listas, diccionarios y operaciones de lectura (55 min)

1. **(15 min)** Ejercicio 9 — lista de pacientes: endpoint GET `/patients` que devuelva la lista completa de pacientes con `Query<Patient>` y `Results.Ok(patients)`. Verificar que funcione.
2. **(15 min)** Ejercicio 10 — ORDER BY: endpoint GET `/patients/sorted` que devuelva pacientes ordenados alfabéticamente por nombre con `ORDER BY first_name ASC`.
3. **(15 min)** Ejercicio 11 — COUNT: endpoint GET `/patients/count` que devuelva el total de pacientes con `ExecuteScalar<long>` y `Results.Ok(new { total = count })`.
4. **(10 min)** Ejercicio 12 — validación de existencia: endpoint GET `/patients/{id:long}` que devuelva 404 si el paciente no existe (`patient is null ? Results.NotFound(...) : Results.Ok(patient)`). El docente verifica cada implementación.

### Cierre (15 min)

Verificación individual: el docente recorre los puestos y marca en la lista de verificación qué objetivos están logrados (1 a 12) y cuáles quedan pendientes para el encuentro siguiente. Cada estudiante hace commit del avance con mensaje `"feat: camino mínimo encuentro 1 — tipos, GET y SQLite"`.

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

Repaso de lo logrado en el encuentro anterior. El docente presenta los objetivos del día: operaciones de escritura (POST, PUT, DELETE), triple JOIN, validación de existencia, entrega en GitHub y defensa. **No se permite celular.**

### Desarrollo — Bloque 4: CRUD completo — POST, PUT, DELETE (55 min)

1. **(15 min)** Ejercicio 13 — INSERT con `MapPost`: endpoint POST `/patients` que agregue un paciente a `hospital.db` usando `Execute`, obtenga el ID generado con `ExecuteScalar<long>`, y devuelva `Results.Created($"/patients/{newId}", paciente)`. El docente modela el endpoint en vivo.
2. **(15 min)** Ejercicio 14 — UPDATE con `MapPut`: endpoint PUT `/patients/{id:long}` que actualice un paciente existente. Devolver 200 si se actualizó, 404 si no existía. El docente verifica cada implementación.
3. **(15 min)** Ejercicio 15 — DELETE con `MapDelete`: endpoint DELETE `/patients/{id:long}` que elimine un paciente. Devolver 204 si se eliminó, 404 si no existía. Validar existencia antes de eliminar.
4. **(10 min)** Ejercicio 16 — validación de existencia antes de cada operación de escritura: verificar con `QueryFirstOrDefault` que el recurso exista antes de UPDATE o DELETE. Si no existe, devolver 404.

### Desarrollo — Bloque 5: Triple JOIN y operaciones avanzadas (55 min)

1. **(15 min)** Ejercicio 17 — triple JOIN: endpoint GET `/admissions/{id:long}` que devuelva una admisión con los datos completos del paciente y el doctor usando `JOIN patients` y `JOIN doctors`. Alias `AS` para cada columna. El docente modela el endpoint en vivo.
2. **(15 min)** Ejercicio 18 — LIKE en escritura: endpoint GET `/patients-by-province/{provinceId:long}` que use JOIN entre patients y provinces y devuelva la lista de pacientes de una provincia específica.
3. **(15 min)** Ejercicio 19 — `ExecuteScalar<long>` para conteos avanzados: endpoint GET `/admissions/count-by-doctor/{doctorId:long}` que devuelva el número de admisiones de un doctor.
4. **(10 min)** Ejercicio 20 — prueba completa de endpoints: cada estudiante prueba los endpoints POST, PUT, DELETE y triple JOIN con `curl` o Thunder Client contra `hospital.db`.

### Desarrollo — Bloque 6: Entrega GitHub y defensa (55 min)

1. **(15 min)** Ejercicio 21 — README de portada: crear `README.md` en la raíz del repo con título, descripción ("Minimal API Hospital — Camino Mínimo"), tecnologías (C# .NET 6, Dapper, SQLite), cómo ejecutar (`dotnet run`, `curl`) y ejemplo de uso para cada endpoint.
2. **(15 min)** Ejercicio 22 — commit final: `git add .`, `git commit -m "feat: camino mínimo completo — CRUD, triple JOIN y README"`, `git push`. Verificar que GitHub muestre el archivo `Program.cs` y el `README.md`.
3. **(15 min)** Ejercicio 23 — defensa oral: cada estudiante explica brevemente (2-3 minutos): qué hace el proyecto, cómo conecta los conocimientos de cada unidad, y una operación CRUD que le haya costado más.
4. **(10 min)** Ejercicio 24 — cierre: el docente recorre los puestos con la lista de verificación y marca cada objetivo como logrado o pendiente.

### Cierre con evaluación (15 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente:
- Qué hace el proyecto
- Cómo valida los datos de entrada
- Cómo conecta U1 (endpoints Minimal API) con U2 (consultas Dapper a SQLite)
- Una operación CRUD que le haya costado implementar

Si el estudiante cumple todos los objetivos (1 a 24), recibe **Apto**. Si falta alguno, se registra como **No apto aún por objetivo mínimo** y se detalla qué objetivo(s) no alcanzó, junto con la sugerencia de la instancia de marzo como siguiente oportunidad con el mismo estándar.

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
| **Apto** | El proyecto compila y ejecuta. Usa `input()`/`print()` (o equivalente en C#), condicionales, bucles, listas, diccionarios, funciones, bloque principal, `try`/`except`, f-strings y menú en memoria. El repo tiene commit y README. El estudiante explica su código durante la defensa. |
| **No apto aún por objetivo mínimo** | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se sugiere la instancia de marzo como siguiente oportunidad con el mismo estándar. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante construye un proyecto Minimal API completo (entrada validada, control de flujo, CRUD con Dapper, triple JOIN, respuestas HTTP correctas) contra `hospital.db`. Entrega el código en GitHub con README. Durante la defensa explica el funcionamiento general y la lógica de al menos una operación CRUD. |
| No apto | El estudiante no completa alguno de los componentes del camino mínimo, no puede explicar el funcionamiento de su propio código, o no entregó el programa en GitHub. Recibe la lista de objetivos pendientes y la fecha de la instancia de marzo. |
