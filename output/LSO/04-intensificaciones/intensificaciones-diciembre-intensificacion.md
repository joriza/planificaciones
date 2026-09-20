# Intensificación de diciembre — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de diciembre (fuera de la estructura anual) |
| Duración | 2 encuentros × 240 min (480 min total) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos del curso durante el ciclo lectivo |
| Requisitos | Haber cursado la totalidad del año; tener `hospital.db` y cuenta de GitHub activa; asistencia obligatoria |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite, Dapper, Git y Thunder Client |
| Evaluación | Camino mínimo completo del curso. Criterio: **Apto / No apto aún por objetivo mínimo**. No hay puntaje numérico. |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| **Contenidos** | Camino mínimo completo del curso: 1) tipos, variables y estructura de un programa C#; 2) endpoint GET con `MapGet`, parámetros de ruta y query; 3) conexión a SQLite con Dapper y `Query<T>` con mapeo a records; 4) JOIN de 2 tablas con alias; 5) POST con `ExecuteScalar` y devolución `201 Created`; 6) PUT con `Execute` y `Results.Ok`; 7) DELETE con `Execute` y `204 No Content`; 8) validación de existencia con `QueryFirstOrDefault` y `Results.NotFound`; 9) Git: rama feature, commit, PR, README de portada. |
| **Actividad / metodología** | Recorrido acelerado por los contenidos mínimos del año, con énfasis en los objetivos no alcanzados detectados en las evaluaciones de unidad. Cada estudiante reconstruye su proyecto desde cero siguiendo una guía paso a paso. Encuentro 1: endpoint GET y consulta SELECT con Dapper. Encuentro 2: CRUD completo y entrega en GitHub. |
| **Recursos** | VS Code, `hospital.db`, `dotnet new web`, Dapper NuGet, guía paso a paso del camino mínimo (impresa), Thunder Client, repo GitHub del curso, lista de verificación de objetivos por alumno. |

## Desarrollo del Encuentro 1

### Apertura (20 min)

El docente explica la modalidad de la instancia de diciembre: "No es un curso nuevo — es la oportunidad de demostrar que pueden hacer el camino mínimo. Cada objetivo que logren hoy es un objetivo aprobado." Se entrega la lista de verificación individual con los objetivos no alcanzados de cada alumno.

### Desarrollo (120 min + 80 min complementarios)

1. **(30 min)** Ejercicio 1 — programa de consola: crear un `dotnet new console`, declarar variables de distintos tipos (`string`, `int`, `bool`), leer datos con `Console.ReadLine`, convertir con `int.Parse`. Escribir una función que calcule el IMC a partir de peso y altura, y retorne si hay sobrepeso. *Objetivo: tipos, variables, condicional, función.*
2. **(30 min)** Ejercicio 2 — endpoint GET básico: crear `dotnet new web`, agregar `MapGet("/", ...)` que devuelva `"Hola mundo"`. Luego `MapGet("/health", ...)` que devuelva `{"status":"ok"}`. Probar con Thunder Client. *Objetivo: estructura de Minimal API, respuesta HTTP.*
3. **(30 min)** Ejercicio 3 — endpoint con parámetro de ruta: `MapGet("/patients/{id}", ...)` que devuelva un mensaje con el ID recibido. Luego conectarlo a `hospital.db`: agregar cadena de conexión, `SqliteConnection`, ejecutar `SELECT * FROM Patients WHERE Id = @Id` con `QueryFirstOrDefault<Patient>`. Devolver `Results.Ok` o `Results.NotFound`. *Objetivo: conexión SQLite, Dapper, parámetro, respuesta condicional.*
4. **(30 min)** Ejercicio 4 — endpoint con lista: `MapGet("/patients", ...)` con `Query<Patient>` que devuelva todos los pacientes. Probar respuesta JSON. *Objetivo: Query<T>, mapeo a record, lista como JSON.*
5. **(80 min — complementario)** Ejercicio 5 — JOIN: agregar endpoint `/patients/with-province` con `JOIN Provinces` y alias SQL. Mapear a record con dos propiedades. Probar.

### Cierre (20 min)

Verificación individual: cada estudiante muestra los endpoints que funcionan. El docente marca en la lista de verificación qué objetivos están logrados y cuáles quedan pendientes para el encuentro siguiente.

---

## Desarrollo del Encuentro 2

### Apertura (20 min)

Repaso de lo logrado en el encuentro anterior. El docente presenta los objetivos del día: las operaciones de escritura (POST, PUT, DELETE) y la entrega profesional en GitHub.

### Desarrollo (120 min + 80 min complementarios)

1. **(30 min)** Ejercicio 6 — endpoint POST: `MapPost("/patients", ...)` que reciba un `PatientRequest`, ejecute `INSERT INTO Patients (...) VALUES (...)` con `ExecuteScalar`, capture el nuevo ID y devuelva `Results.Created($"/patients/{id}", patient)`. Probar con Thunder Client. *Objetivo: INSERT con Dapper, Created 201.*
2. **(30 min)** Ejercicio 7 — endpoint PUT: `MapPut("/patients/{id}", ...)` que verifique existencia con `QueryFirstOrDefault`, ejecute `UPDATE` con `Execute`, devuelva el registro actualizado o `Results.NotFound`. *Objetivo: UPDATE, validación previa.*
3. **(30 min)** Ejercicio 8 — endpoint DELETE: `MapDelete("/patients/{id}", ...)` que verifique existencia, ejecute `DELETE` con `Execute`, devuelva `204 No Content` o `Results.NotFound`. *Objetivo: DELETE, código 204.*
4. **(30 min)** Ejercicio 9 — ciclo completo: probar POST → GET → PUT → GET → DELETE → GET (esperar 404). Verificar códigos HTTP en cada paso. *Objetivo: integración del CRUD mínimo.*
5. **(80 min — complementario)** Ejercicio 10 — profesionalización: crear repo en GitHub, rama `feature/crud-minimo`, commitear el proyecto, abrir PR. Agregar README.md con título, descripción, tecnologías y tabla de endpoints. Mergear el PR. *Objetivo: Git profesional, README.*

### Cierre con evaluación (20 min)

El docente recorre los puestos y verifica cada objetivo de la lista individual contra el proyecto en GitHub. Si el estudiante cumple todos los objetivos del camino mínimo, recibe **Apto**. Si falta alguno, se registra como **No apto aún por objetivo mínimo** y se detalla cuál(es) objetivo(s) no alcanzó. El resultado se comunica al final del encuentro y se notifica por escrito.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El proyecto en GitHub contiene: un endpoint GET con lista, un endpoint GET con ID, una operación POST, PUT y DELETE funcionales, consultas Dapper con parámetros, manejo de `NotFound` y códigos HTTP correctos, README de portada. Todos los objetivos de la lista individual están cumplidos. |
| **No apto aún por objetivo mínimo** | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se sugiere la instancia de marzo como siguiente oportunidad con el mismo estándar. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante construye una Minimal API completa con las cuatro operaciones CRUD sobre `hospital.db`, consultas parametrizadas con Dapper, códigos HTTP correctos, y entrega el proyecto en GitHub con README. Demuestra durante la verificación que comprende cada parte del código. |
| No apto | El estudiante no completa alguno de los componentes anteriores o no puede explicar el funcionamiento de su propio código. Recibe la lista de objetivos pendientes y la fecha de la instancia de marzo. |