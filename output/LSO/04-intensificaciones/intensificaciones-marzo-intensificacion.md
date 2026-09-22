# Intensificación de marzo — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de marzo (fuera de la estructura anual, previa al nuevo ciclo) |
| Duración | 2 encuentros × 240 min (480 min total) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en la instancia de diciembre |
| Requisitos | Haber cursado la totalidad del año y la instancia de diciembre; contar con `hospital.db` y cuenta de GitHub; asistencia obligatoria |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite, Dapper, Git y Thunder Client |
| Evaluación | Camino mínimo completo del curso (mismo estándar que diciembre). Criterio: **Apto / No apto aún por objetivo mínimo**. No baja el estándar; cambia el tiempo de preparación del estudiante. |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| **Contenidos** | Camino mínimo completo del curso (idéntico al de diciembre): 1) tipos, variables y estructura de un programa C#; 2) endpoint GET con `MapGet`, parámetros de ruta y query; 3) conexión a SQLite con Dapper y `Query<T>` con mapeo a records; 4) JOIN de 2 tablas con alias; 5) POST con `ExecuteScalar` y devolución `201 Created`; 6) PUT con `Execute` y `Results.Ok`; 7) DELETE con `Execute` y `204 No Content`; 8) validación de existencia con `QueryFirstOrDefault` y `Results.NotFound`; 9) Git: rama feature, commit, PR, README de portada. |
| **Actividad / metodología** | El estudiante tiene más tiempo para prepararse (diciembre a marzo). La instancia presencial se organiza como taller de verificación: el docente revisa el proyecto que el estudiante trae preparado y asiste en los puntos que todavía presenten dificultad. Encuentro 1: verificación de objetivos 1 a 5 (lectura). Encuentro 2: verificación de objetivos 6 a 9 (escritura y entrega). |
| **Recursos** | VS Code, `hospital.db`, `dotnet new web`, Dapper NuGet, guía paso a paso del camino mínimo (impresa desde diciembre), lista de verificación de objetivos por alumno con el registro de diciembre. |

## Desarrollo del Encuentro 1

### Apertura (20 min)

El docente da la bienvenida a la instancia de marzo. Explica que el estándar es el mismo que en diciembre: "No bajamos la exigencia — ustedes tuvieron más tiempo para preparar cada objetivo. Hoy verificamos lo que traen." Cada estudiante recibe su lista de verificación individual actualizada con los objetivos pendientes desde diciembre.

### Desarrollo (120 min + 80 min complementarios)

1. **(25 min)** Verificación 1 — programa de consola: el estudiante muestra un `dotnet new console` con variables, `Console.ReadLine`, conversión de tipos, una función con parámetro y retorno. El docente revisa el código y marca el objetivo como logrado en la lista.
2. **(25 min)** Verificación 2 — endpoint GET básico: el estudiante muestra `MapGet("/")` y `MapGet("/health")` en su proyecto. Verifica con Thunder Client.
3. **(30 min)** Verificación 3 — endpoint con parámetro y Dapper: mostrar `/patients/{id}` con `SqliteConnection`, `QueryFirstOrDefault` y `Results.NotFound`. Verificar con un ID existente y uno inexistente.
4. **(40 min)** Verificación 4 — endpoint con lista: mostrar `/patients` con `Query<Patient>`. Si no está implementado, el docente guía su creación en vivo.
5. **(80 min — complementario)** Verificación 5 — JOIN: mostrar `/patients/with-province`. Si está pendiente, se implementa con ayuda del docente. El estudiante explica el alias SQL y el record de mapeo.

### Cierre (20 min)

El docente registra los objetivos logrados en el encuentro. Si un estudiante completó todos los objetivos de lectura (1 a 5), recibe el pase al encuentro 2 para escritura y entrega. Si no, se le asigna trabajo adicional para el segundo encuentro.

---

## Desarrollo del Encuentro 2

### Apertura (20 min)

Repaso de los objetivos de escritura: POST, PUT, DELETE. El docente muestra en vivo el ciclo completo y recuerda que el README y el PR son parte de la evaluación.

### Desarrollo (120 min + 80 min complementarios)

1. **(30 min)** Verificación 6 — endpoint POST: el estudiante muestra `MapPost("/patients")` en su proyecto. Ejecuta una inserción y verifica el `201 Created` con el ID devuelto.
2. **(25 min)** Verificación 7 — endpoint PUT: mostrar el endpoint de actualización. Verificar que devuelva `Results.Ok` con el registro modificado y `NotFound` si el ID no existe.
3. **(25 min)** Verificación 8 — endpoint DELETE: mostrar el endpoint de borrado. Verificar `204 No Content` y luego `404` al consultar el mismo ID.
4. **(30 min)** Verificación 9 — ciclo CRUD completo: ejecutar POST → GET → PUT → GET → DELETE → GET (último debe dar 404). Verificar cada código HTTP.
5. **(80 min — complementario)** Verificación 10 — Git profesional: mostrar el repo en GitHub con rama feature, PR mergeado y README.md que documente los endpoints. Si falta algo, se completa en el encuentro.

### Cierre con evaluación (20 min)

El docente recorre los puestos con la lista de verificación. Si el estudiante cumple todos los objetivos (1 a 10), recibe **Apto**. Si falta alguno, se registra como **No apto aún por objetivo mínimo** y se detalla cuáles objetivos no alcanzó, junto con la recomendación de recursar la materia si el período lo permite.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El proyecto en GitHub contiene: endpoint GET con lista, endpoint GET con ID con manejo de `NotFound`, POST con `201`, PUT con validación previa, DELETE con `204`, consultas Dapper parametrizadas, README de portada y flujo Git con PR. Todos los objetivos de la lista individual están cumplidos. |
| **No apto aún por objetivo mínimo** | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se informa al estudiante junto con la notificación a dirección. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante presenta una Minimal API completa con CRUD funcional sobre `hospital.db`, consultas Dapper parametrizadas sin concatenación SQL, códigos HTTP correctos, repositorio profesional en GitHub con README y PR. Durante la verificación explica cada endpoint y las decisiones de implementación. |
| No apto | El estudiante no completa alguno de los componentes del camino mínimo o no puede sostener una explicación coherente de su propio código. Recibe el detalle de objetivos pendientes y la comunicación formal del resultado. |