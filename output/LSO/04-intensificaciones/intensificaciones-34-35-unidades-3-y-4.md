# Intensificación y fortalecimiento de las Unidades 3 y 4 — Encuentros 34 y 35

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 3 y 4 |
| Encuentros | 34 y 35 |
| Duración | 2 encuentros × 240 min (4 horas reloj cada uno) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Haber cursado las unidades 3 y 4; tener TP-U3 commiteado y trabajo final en progreso o pendiente; repo grupal GitHub clonado |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |
| Uso de celular | No permitido |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | U3: INSERT con `MapPost` y código 201, DELETE con `MapDelete` y código 204/404, UPDATE con `MapPut` y código 200/404, validación de existencia antes de cada operación. U4: README de portada, issues, ramas por feature, PR revisados, `main` protegida, trabajo final: API completa con Dapper. | U3: triple JOIN en consultas de lectura, validación de integridad referencial en handlers, patrones de respuesta consistentes (siempre `Results.*`, nunca objetos crudos), manejo de errores con `try/catch` en handlers. U4: flujo profesional completo (issue → rama → PR → merge), README avanzado con badges, code review cruzado entre pares, protección de `main` con reglas de branch. |
| **Actividad / metodología** | Ejercicios guiados paso a paso: corregir errores comunes en operaciones CRUD, refactorizar programas existentes del TP-U3, completar el trabajo final con README y PR, cerrar el ciclo Git (commit + push). El docente modela cada operación en vivo y acompaña individualmente. | Desafíos de profundización autónomos: extender el CRUD con validación de integridad referencial, implementar triple JOIN en endpoints de lectura, completar el flujo profesional completo (issue → rama → PR → merge). Trabajo en parejas con revisión entre pares. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de núcleos U3 y U4, ejemplos resueltos del TP-U3, plantilla README, lista de verificación de objetivos por alumno, `hospital.db` copiado al lado del `.csproj`. | VS Code, terminal, repo grupal, consignas de desafío impresas, documentación de convenciones técnicas del curso, `hospital.db` copiado al lado del `.csproj`, plantilla README avanzado. |

## Desarrollo del Encuentro 34

### Apertura conjunta (15 min)

Plenaria: el docente recorre los núcleos de U3 (CRUD con Dapper, MapPost/MapPut/MapDelete, códigos HTTP, validación de existencia) y U4 (flujo profesional). Explica que hoy se enfocan en U3 y que el trabajo final se retoma en el Encuentro 35. Se asigna cada estudiante a su pista según el desempeño en TP-U3 y el estado del trabajo final. Se recuerda que **no se permite celular**.

### Pista intensificación — Bloque 1 (50 min)

**U3: INSERT con MapPost y validación (50 min)**

1. **(15 min)** Repaso del esqueleto de `Program.cs` para operaciones de escritura: `MapPost`, `MapPut`, `MapDelete`. El docente modela la estructura de un handler POST con conexión a `hospital.db`.
2. **(15 min)** INSERT con `Execute` y código 201: `INSERT INTO patients (...) VALUES (...)` con parámetros parametrizados, `ExecuteScalar<long>` para obtener el ID generado, `Results.Created($"/patients/{newId}", paciente)`. Ejercicio guiado: endpoint POST `/patients` que agregue un paciente.
3. **(20 min)** Validación de existencia antes de INSERT: verificar que no exista ya un paciente con el mismo nombre antes de insertar. Si existe, devolver `Results.BadRequest(new { mensaje = "Ya existe un paciente con ese nombre" })`. El docente verifica cada implementación.

### Pista fortalecimiento — Bloque 1 (50 min)

**U3 profundizado: triple JOIN y validación de integridad (50 min)**

1. **(15 min)** Triple JOIN en lectura: `SELECT ... FROM admissions JOIN patients ON ... JOIN doctors ON ...`. El docente explica la relación entre las tres tablas y la necesidad de alias `AS` para cada columna.
2. **(15 min)** Record `AdmissionDetail` con tipos canónicos: `long` para IDs, `string` para textos, `string?` para nullable. Ejercicio: declarar el record y verificar que compile.
3. **(20 min)** Endpoint GET `/admissions/{id:long}` con triple JOIN y alias `AS`: `QueryFirstOrDefault<AdmissionDetail>`, devolver 404 si no existe. Verificar que los tipos se mapean correctamente contra `hospital.db`.

### Pista intensificación — Bloque 2 (50 min)

**U3: DELETE con MapDelete y UPDATE con MapPut (50 min)**

1. **(15 min)** DELETE con `MapDelete`: `DELETE FROM patients WHERE patient_id = @id`. Ejercicio guiado: endpoint DELETE `/patients/{id:long}` que elimine un paciente. Verificar que devuelva `Results.NoContent()` si se eliminó y `Results.NotFound` si no existía.
2. **(15 min)** Validación de existencia antes de DELETE: verificar con `QueryFirstOrDefault` que el paciente exista antes de eliminar. Si no existe, devolver 404.
3. **(20 min)** UPDATE con `MapPut`: `UPDATE patients SET first_name = @firstName, last_name = @lastName WHERE patient_id = @id`. Ejercicio: endpoint PUT `/patients/{id:long}` que actualice un paciente existente. Devolver 200 si se actualizó, 404 si no existía. Verificar contra `hospital.db`.

### Pista fortalecimiento — Bloque 2 (50 min)

**U3 profundizado: manejo de errores y patrones de respuesta (50 min)**

1. **(15 min)** Manejo de errores con `try/catch` dentro del handler: capturar excepciones de SQLite y devolver `Results.BadRequest` con mensaje descriptivo. El docente modela el bloque `try/catch` dentro del handler.
2. **(15 min)** Patrón de respuesta consistente: todos los endpoints deben devolver `Results.*` y nunca objetos crudos. Ejercicio: revisar un endpoint existente y refactorizarlo para que use siempre `Results.Ok`, `Results.NotFound`, `Results.BadRequest` o `Results.Created`.
3. **(20 min)** Desafío: endpoint PUT que actualice un paciente con validación completa (404 si no existe, 400 si faltan campos obligatorios, 200 con el paciente actualizado). Verificar contra `hospital.db`.

### Pista intensificación — Bloque 3 (50 min)

**U3: integración CRUD completa (50 min)**

1. **(15 min)** Ejercicio integrador: crear un programa Minimal API completo con los cuatro endpoints CRUD (GET por ID, POST, PUT, DELETE) para la tabla `patients`. El docente verifica que cada endpoint funcione contra `hospital.db`.
2. **(15 min)** Prueba de endpoints con `curl` o Thunder Client: verificar que POST devuelve 201, GET devuelve 200, PUT devuelve 200, DELETE devuelve 204. Probar también los casos de error (404 para IDs inexistentes, 400 para datos faltantes).
3. **(20 min)** Commit y push: `git add .`, `git commit -m "feat: CRUD completo con Dapper para patients"`, `git push`. El docente verifica los commits en GitHub.

### Pista fortalecimiento — Bloque 3 (50 min)

**U3+U4: flujo profesional y trabajo final (50 min)**

1. **(15 min)** Crear un issue en GitHub para el trabajo final: descripción de la API que se va a construir, tecnologías a usar, criterios de aceptación. Asignar el issue a uno mismo.
2. **(15 min)** Crear rama por feature: `git checkout -b feature/trabajo-final`, implementar el esqueleto del proyecto final (Program.cs con al menos un endpoint GET y uno POST), commit y push.
3. **(20 min)** Abrir PR hacia `main`: descripción del PR que referencia el issue, lista de cambios realizados. El docente verifica que el PR esté correctamente formado.

### Pista intensificación — Bloque 4 (45 min)

**Integración y práctica (45 min)**

1. **(15 min)** Ejercicio integrador U3+U4: completar el proyecto con README de portada que incluya título, descripción, tecnologías, cómo ejecutar y ejemplo de uso para cada endpoint. Commit y push.
2. **(15 min)** Verificación de la protección de `main`: el docente muestra que `main` está protegida y que no se puede hacer push directo. Verificar que el PR del estudiante esté listo para revisión.
3. **(15 min)** Repaso de errores comunes: el docente recorre las trampas más frecuentes (tipos incorrectos, sin alias `AS`, conexión no cerrada, records antes de `app.Run()`, objetos crudos sin `Results`).

### Pista fortalecimiento — Bloque 4 (45 min)

**Desafíos de integración y cierre (45 min)**

1. **(15 min)** Desafío U3: crear un endpoint DELETE que primero verifique que la admisión exista y que no tenga dependencias antes de eliminar. Devolver 404 si no existe, 409 si tiene dependencias.
2. **(15 min)** Desafío U4: completar el code review cruzado: revisar el PR de un compañero, dejar al menos un comentario sustantivo (sugerencia de mejora, pregunta sobre la implementación).
3. **(15 min)** Commit y push final: cada estudiante hace commit de los desafíos con mensaje descriptivo. El docente verifica que el repo esté actualizado.

### Cierre conjunto (15 min)

Puesta en común: cada pista comparte la línea de código que más le costó resolver. El docente destaca la diferencia entre usar `MapPost` con 201 y `MapPut` con 200, y la importancia de validar la existencia antes de DELETE. Anticipa que en el próximo encuentro se cierra U4 con el flujo profesional completo (README, issues, ramas, PR, main protegida) y se completa el trabajo final quienes lo adeuden.

### Errores comunes y trampas

1. **Declarar el ID como `int` en el record.** Causa: `InvalidOperationException`: Dapper busca constructor `(Int64, String)` porque SQLite INTEGER devuelve `Int64`, pero el record ofrece `(int, String)`. Fix: usar `long PatientId` en todos los records.
2. **Fecha declarada como `DateTime` o `DateOnly`.** Causa: `InvalidOperationException`: Dapper recibe `String` de la columna TEXT y no encuentra constructor que acepte `DateTime`/`DateOnly`. Fix: usar `string BirthDate` en el record. Convertir con `DateTime.Parse()` solo al presentar.
3. **SELECT sin alias `AS` en snake_case.** Causa: `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` (snake_case) en lugar de `PatientId` (PascalCase). Fix: usar `SELECT patient_id AS PatientId, ...`.
4. **Concatenar datos al SQL en lugar de parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis. Fix: usar `@id` y `new { id }` en toda consulta.
5. **Olvidar `using` en la conexión.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint.
6. **Devolver el objeto crudo sin `Results`.** Causa: ASP.NET serializa con nombres del record sin configuración adicional, pero viola la convención del curso. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.
7. **Hacer push directo a `main`.** Causa: los alumnos no respetan la protección de rama y generan conflictos. Fix: se refuerza que desde la Unidad 4 se usan ramas por feature y PR revisados.

## Desarrollo del Encuentro 35

### Apertura conjunta (15 min)

Repaso: el docente muestra en vivo un programa Minimal API funcionando con los cuatro endpoints CRUD. Pregunta: "Esto funciona en mi PC. ¿Cómo lo comparto con el mundo y cómo trabajo en equipo?". Respuesta: con README, issues, ramas, PR y `main` protegida. Hoy cerramos U4. Se recuerda que **no se permite celular**.

### Pista intensificación — Bloque 1 (50 min)

**U4: README profesional y cierre del repo (50 min)**

1. **(15 min)** ¿Qué es un README? Estructura básica: título, descripción, tecnologías (C# .NET 6, Dapper, SQLite), cómo ejecutar (`dotnet run`, `curl`), ejemplo de uso para cada endpoint. Plantilla provista.
2. **(15 min)** Cada estudiante crea o actualiza el README del repo grupal con la plantilla. Lo commitea en una rama `docs/readme`.
3. **(20 min)** Issues: crear un issue en GitHub con la descripción de una funcionalidad faltante del proyecto final. Asignarla a un compañero o a uno mismo. El docente verifica que cada estudiante haya creado al menos un issue.

### Pista fortalecimiento — Bloque 1 (50 min)

**U4 avanzado: README con badges y flujo profesional (50 min)**

1. **(15 min)** README avanzado: badges de estado (generados con shields.io), tabla de contenidos, sección de contribución, licencia. El docente muestra un ejemplo de README avanzado en el proyector.
2. **(15 min)** Cada estudiante mejora el README del repo con badges y tabla de contenidos. Crea un issue de mejora y lo resuelve con una rama y PR.
3. **(20 min)** Code review cruzado: revisar el PR de un compañero, dejar al menos un comentario sustantivo (sugerencia de mejora, pregunta sobre la implementación). El docente verifica que cada PR tenga al menos un comentario de revisión.

### Pista intensificación — Bloque 2 (50 min)

**U4: Trabajo final — commits, PR y main protegida (50 min)**

1. **(20 min)** Quienes adeudan el trabajo final: conectarlo al repo grupal. Commit del código faltante en una rama `feature/trabajo-final`. Abrir PR hacia `main`. El docente guía paso a paso.
2. **(15 min)** El docente verifica que `main` esté protegida (no se puede pushear directo). El PR debe ser revisado y mergeado por otro compañero o el docente.
3. **(15 min)** Quienes ya completaron el trabajo final: ayudar a un compañero con su PR (code review cruzado). Verificar que el PR tenga al menos un comentario de revisión.

### Pista fortalecimiento — Bloque 2 (50 min)

**U4: Resolución de issues con ramas y PR (50 min)**

1. **(15 min)** Tomar un issue abierto del repo (propio o de un compañero), crear rama con nombre descriptivo (`fix/memoria-pedidos`, `feat/ordenar-menu`).
2. **(15 min)** Implementar la solución, commit con mensaje que referencie el issue ("Closes #3: agrega ordenamiento alfabético de pedidos"). Push, abrir PR.
3. **(20 min)** Mergear el PR tras revisión. Verificar que `main` se actualizó. Eliminar la rama de feature. Si queda tiempo, crear un segundo issue y resolverlo con otro flujo de rama → PR → merge.

### Pista intensificación — Bloque 3 (45 min)

**Integración y cierre (45 min)**

1. **(15 min)** Ejercicio integrador U3+U4: verificar que el proyecto final tenga README, al menos un issue, una rama por feature y un PR mergeado. El docente recorre el aula y verifica cada elemento.
2. **(15 min)** Commit y push final: `git add .`, `git commit -m "feat: proyecto final completo con README, issues y PR"`, `git push`. El docente verifica los commits en GitHub.
3. **(15 min)** Repaso de errores comunes: el docente recorre las trampas más frecuentes (tipos incorrectos, sin alias `AS`, conexión no cerrada, records antes de `app.Run()`, objetos crudos sin `Results`, push directo a `main`).

### Pista fortalecimiento — Bloque 3 (45 min)

**Desafíos de integración y cierre (45 min)**

1. **(15 min)** Desafío U3+U4: crear un endpoint adicional que no esté en el proyecto final (por ejemplo, un endpoint GET que devuelva estadísticas de admisiones por doctor usando `ExecuteScalar<long>` y GROUP BY). Verificar contra `hospital.db`.
2. **(15 min)** Code review final: revisar el PR de un compañero que aún no fue mergeado, dejar un comentario sustantivo y verificar que el PR cumpla con la rúbrica del curso.
3. **(15 min)** Commit y push final: cada estudiante hace commit de los desafíos con mensaje descriptivo. El docente verifica que el repo esté actualizado.

### Cierre conjunto (15 min)

Plenaria final: el docente proyecta el repo grupal y muestra los PRs mergeados, los issues resueltos, el README actualizado y la `main` protegida. "Esto es un repositorio profesional. Lo que vieron hoy es cómo se trabaja en equipo en cualquier empresa de software. Cerramos U4 y el curso."

### Errores comunes y trampas

1. **No usar alias `AS` en el SELECT del triple JOIN.** Causa: `InvalidOperationException`: Dapper busca constructor con nombres de columna snake_case en lugar de PascalCase. Fix: usar `SELECT ... AS NombreDelCampo` para cada columna.
2. **Hacer push directo a `main`.** Causa: los alumnos no respetan la protección de rama y generan conflictos. Fix: se refuerza que desde la Unidad 4 se usan ramas por feature y PR revisados.
3. **No incluir `using` en la conexión.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro de cada handler.
4. **Devolver el objeto crudo sin `Results`.** Causa: ASP.NET serializa con nombres del record sin configuración adicional, pero viola la convención del curso. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.
5. **No proteger `main` con ramas por feature.** Causa: los alumnos hacen push directo a `main` y generan conflictos. Fix: se refuerza que desde la Unidad 4 se usan ramas por feature y PR revisados.
6. **No actualizar el repo grupal.** Causa: los alumnos no entienden que GitHub es su espacio de trabajo y no hacen commit de sus avances. Fix: el docente verifica los commits al final de cada encuentro y refuerza la importancia del versionado.

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante implementa los cuatro endpoints CRUD (GET por ID, POST con 201, PUT con 200, DELETE con 204/404) con validación de existencia, tipos canónicos (`long`, `string`, `string?`), alias `AS`, parámetros parametrizados y respuestas `Results.*`. Completa el trabajo final con README, al menos un issue, una rama por feature y un PR mergeado. Resuelve al menos 3 de los 4 bloques. |
| Fortalecimiento | El estudiante implementa triple JOIN en endpoints de lectura, validación de integridad referencial, manejo de errores con `try/catch`, flujo profesional completo (issue → rama → PR → merge), README avanzado con badges, y code review cruzado. Resuelve los desafíos completos de ambos encuentros. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, actualiza el repositorio grupal, y completa el cierre del trabajo final con commits, PR y merge. |
