# Intensificación y fortalecimiento de las Unidades 3 y 4 — Encuentros 34 y 35

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 3 y 4 |
| Encuentros | 34 y 35 |
| Duración | 2 encuentros × 240 min (480 min total) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Haber cursado las unidades 3 y 4; tener resueltos o intentados el TP-U3 y el Trabajo Final; disponer de `hospital.db` y repositorio GitHub |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite, Dapper, Git y GitHub |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | U3: operaciones CRUD completas — POST con `ExecuteScalar`, DELETE con `Execute`, PUT con `Execute`, validación de existencia con `QueryFirstOrDefault`. U4: Git profesional (ramas feature, pull request, main protegida), README de portada, organización del repositorio. | U3: JOIN triple en operaciones CRUD, validaciones combinadas, respuestas HTTP detalladas (`201 Created`, `204 No Content`, `409 Conflict`). U4: testing de integración básico con la API, issues con milestones, CI/CD conceptual. |
| **Actividad / metodología** | Ejercicios guiados: reconstruir paso a paso cada operación CRUD sobre la tabla `Patients`, verificar con Thunder Client. Luego configurar rama feature y abrir PR en repo de práctica. | Desafíos autónomos: extender CRUD a `Admissions` con validación cruzada (doctor y paciente existen), agregar tests de integración con `Microsoft.AspNetCore.Mvc.Testing`, documentar con README avanzado. |
| **Recursos** | VS Code, `hospital.db`, `dotnet new web`, Dapper, Thunder Client, repo GitHub de práctica, guía de comandos Git con capturas de pantalla. | VS Code, `hospital.db`, xUnit, `Microsoft.AspNetCore.Mvc.Testing`, repo GitHub grupal, consignas de desafío. |

## Desarrollo del Encuentro 34

### Apertura conjunta (20 min)

Plenaria: el docente presenta el mapa de U3 y U4. "Por un lado, el CRUD completo — la API ya no solo lee, también escribe. Por el otro, Git profesional — el código ya no es individual, se integra con el equipo." Se asignan las pistas según el desempeño en las evaluaciones U3 y U4.

### Pista intensificación (120 min + 80 min complementarios)

1. **(40 min)** POST con Dapper: crear endpoint `/patients` con `MapPost`. Recibir JSON con `PatientRequest`, ejecutar `INSERT INTO Patients (...) VALUES (...)` con `ExecuteScalar` y devolver `Results.Created`.
2. **(40 min)** DELETE: endpoint `/patients/{id}` con `MapDelete`. Verificar existencia con `QueryFirstOrDefault`, luego `Execute` DELETE, devolver `204 No Content`.
3. **(40 min)** PUT: endpoint `/patients/{id}` con `MapPut`. Verificar existencia, ejecutar `UPDATE` con `Execute`, devolver `Results.Ok` con el registro actualizado.
4. **(80 min — complementario)** Integrar los tres endpoints y probar el ciclo completo: POST → GET → PUT → DELETE. Verificar cada código HTTP en Thunder Client.

### Pista fortalecimiento (120 min + 80 min complementarios)

1. **(35 min)** Validación cruzada: endpoint POST `/admissions` que verifique que `PatientId` y `DoctorId` existan antes de insertar. Devolver `409 Conflict` si falta alguno.
2. **(35 min)** JOIN triple en escritura: endpoint GET `/admissions/details` que devuelva admisiones con nombre de paciente y doctor mediante JOIN de 3 tablas.
3. **(50 min)** Tests de integración: configurar xUnit con `WebApplicationFactory<Program>`. Escribir tests para GET `/patients` y POST `/patients` que verifiquen códigos HTTP y cuerpo JSON.
4. **(80 min — complementario)** Agregar test para DELETE `/patients/{id}` que verifique `204` y luego `404` al consultar el mismo ID.

### Cierre conjunto (20 min)

Puesta en común: cada grupo muestra la operación CRUD que más le haya costado. El docente repasa los verbos HTTP (`MapGet`, `MapPost`, `MapPut`, `MapDelete`) y sus correspondientes códigos de respuesta.

---

## Desarrollo del Encuentro 35

### Apertura conjunta (20 min)

Repaso de Git: el docente muestra en vivo cómo crear una rama, hacer commits y abrir un PR. Pregunta: "¿Cómo hacemos para que nadie pueda pushear directo a main?" (main protegida). Se asigna la pista.

### Pista intensificación (120 min + 80 min complementarios)

1. **(40 min)** Git: crear repositorio (o clonar existente), configurar rama `main` protegida en GitHub (Settings → Branches → Branch protection rules). Ejercicio: crear rama `feature/readme`, agregar archivo README.md, commit, push y abrir PR.
2. **(40 min)** README de portada: título, descripción del proyecto, tecnologías usadas, instrucciones para ejecutar, endpoints documentados (tabla con método, ruta y descripción).
3. **(40 min)** Flujo PR: revisar el PR propio y el de un compañero. Agregar comentarios, mergear, eliminar rama. Ejercicio: repetir el ciclo con una rama `feature/crud-test`.
4. **(80 min — complementario)** Issues: crear 3 issues en GitHub con etiquetas (`enhancement`, `bug`, `docs`), asignarlas, cerrarlas con commits que incluyan "Closes #n".

### Pista fortalecimiento (120 min + 80 min complementarios)

1. **(35 min)** Milestones: crear un milestone "Sprint 1", asignar issues con fechas, cerrar milestone al completar.
2. **(35 min)** CI/CD conceptual: agregar un archivo `.github/workflows/dotnet.yml` que corra `dotnet build` y `dotnet test` en cada push. Explicar qué hace cada paso sin ejecutarlo (GitHub Actions requiere permisos).
3. **(50 min)** README avanzado: agregar badges de build, sección de arquitectura con diagrama de flujo, tabla de endpoints con ejemplos de request/response, sección de contribución.
4. **(80 min — complementario)** Code review en PR: revisar el repo del compañero, buscar SQL injection potencial, falta de `using`, nombres inconsistentes. Dejar al menos 3 comentarios constructivos.

### Cierre conjunto (20 min)

Plenaria final: el docente conecta todo el ciclo: "Arrancaron escribiendo `if` en consola y terminaron con una API profesional en GitHub con PR, issues y readme. El camino mínimo es este: un endpoint que lee, escribe, y se comparte con el equipo."

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante implementa las tres operaciones de escritura (POST, PUT, DELETE) con Dapper y verifica cada una con Thunder Client. Crea un repositorio Git con rama feature, README y PR mergeado. Resuelve al menos 3 de los 4 ejercicios de cada encuentro. |
| Fortalecimiento | El estudiante implementa validaciones cruzadas en operaciones CRUD, escribe tests de integración que verifican códigos HTTP, y configura un repositorio profesional con milestones, issues y plantilla de CI. Resuelve los desafíos completos. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, y puede explicar el ciclo completo de una operación CRUD (cliente → endpoint → Dapper → SQLite → respuesta) y el flujo de integración con Git. |