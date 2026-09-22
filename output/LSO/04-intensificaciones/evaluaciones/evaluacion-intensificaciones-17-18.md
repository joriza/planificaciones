# Evaluación del momento de intensificación y fortalecimiento 17-18

> Evaluación de la instancia «Evaluación del momento de intensificación y fortalecimiento 17-18» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-17-18-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-intensificaciones-17-18-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación del momento de intensificación y fortalecimiento 17-18 |
| Momento | Intensificación y fortalecimiento — encuentros 17-18 |
| Carácter/Objetivo | Primera instancia de pistas intensificación (núcleos mínimos) y fortalecimiento (extensión) de U1 y U2. Criterio de evaluación: Apto / No apto aún por objetivo mínimo. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-17-18.md` · `evaluacion-intensificaciones-17-18-version-a.md` · `evaluacion-intensificaciones-17-18-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y asignación de pistas | 15 min | El docente recorre los núcleos de U1 y U2 y asigna cada estudiante a su pista según el desempeño en los TP-U1 y TP-U2. |
| Pista intensificación — U1 y U2 núcleos mínimos | 105 min | U1: tipos, control de flujo, primer endpoint GET (tickets de soporte en memoria). U2: SELECT, WHERE, parámetros, LIKE sobre hospital.db (doctors/admissions). |
| Pista fortalecimiento — U1 y U2 profundizado | 105 min | U1: tipos canónicos de Dapper, registros posicionales, Results.*. U2: JOIN, alias, QueryFirstOrDefault, ExecuteScalar, triple JOIN. |
| Cierre y verificación de commits | 15 min | Verificación de repositorios, repaso de errores comunes, anticipación del proyecto puente. |
| **Total** | **240 min** | |

## 3. Acuerdo pedagógico por grupo de condición

**Grupo de intensificación (recuperación pedagógica):** U1: tipos (`int`, `long`, `float`, `string`, `bool`), entrada/salida (`Console.WriteLine`, `Console.ReadLine`), condicionales (`if`/`else`, `switch`), bucles (`for`, `while`), métodos (`static`, parámetros, retorno), primer endpoint GET (`MapGet`), parámetros de ruta y query. U2: conexión a SQLite (`Data Source=hospital.db`), SELECT con WHERE y parámetros, JOIN de 2 tablas, ORDER BY, `Query<T>` con alias `AS`, LIKE para búsqueda por patrón.

**Grupo de fortalecimiento (profundización):** U1: tipos canónicos de Dapper (`long` para INTEGER, `string` para TEXT, `string?`/`long?` para nullable), registros posicionales, top-level statements, `Results.Ok`/`Results.NotFound`/`Results.Created`/`Results.BadRequest`, códigos HTTP 200/201/204/400/404. U2: `QueryFirstOrDefault<T>`, `ExecuteScalar<long>`, `Execute` para INSERT/UPDATE/DELETE, consultas parametrizadas con `new { id }`, triple JOIN, validación de existencia antes de operaciones.

**Recursos:** VS Code, terminal, repo grupal clonado, guía impresa de núcleos U1 y U2, ejemplos resueltos del TP-U1 y TP-U2, lista de verificación de objetivos por alumno, `hospital.db` copiado al lado del `.csproj` (intensificación); VS Code, terminal, repo grupal, consignas de desafío impresas, documentación de convenciones técnicas del curso, `hospital.db` copiado al lado del `.csproj` (fortalecimiento).

## 4. Desarrollo de los encuentros del momento

**Encuentro 17 (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura conjuna y asignación de pistas | 15 min | El docente recorre los núcleos de U1 y U2 con un mapa conceptual. Se asigna cada estudiante a su pista según el desempeño registrado en los TP-U1 y TP-U2.
| Pista intensificación — U1: tipos, control de flujo y primer endpoint GET | 50 min | Repaso de variables y tipos, condicionales con `if`/`else`, primer endpoint GET con `MapGet`.
| Pista fortalecimiento — U1 profundizado: tipos canónicos y registros posicionales | 50 min | Tipos canónicos de Dapper, records posicionales, `Results.*`.
| Pista intensificación — U2: SELECT, WHERE y parámetros | 50 min | Conexión a SQLite, SELECT con WHERE y parámetro, LIKE para búsqueda parcial.
| Pista fortalecimiento — U2 profundizado: JOIN y alias | 50 min | JOIN de 2 tablas, alias `AS`, record `PatientWithProvince`, endpoint GET con triple JOIN.
| Pista intensificación — U1: métodos y control de flujo avanzado | 50 min | Métodos en C#, bucles `for`/`while`, integrador U1.
| Pista fortalecimiento — U2 profundizado: ORDER BY, QueryFirstOrDefault y ExecuteScalar | 50 min | ORDER BY, `QueryFirstOrDefault<T>`, `ExecuteScalar<long>` para conteos.
| Pista intensificación — Integración y práctica | 45 min | Ejercicio integrador U1+U2: endpoint GET `/patients` con Dapper, commit y push.
| Pista fortalecimiento — Desafíos de integración | 45 min | Desafíos U1+U2: endpoint GET con parámetros, LIKE, commit y push.
| Cierre conjunto | 15 min | Puesta en común, repaso de errores comunes, anticipación del E18.

**Encuentro 18 (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura conjuna y repaso relámpago | 15 min | Repaso de U1 y U2, anuncio de operaciones de escritura.
| Pista intensificación — U2: INSERT y DELETE | 50 min | INSERT con `Execute`, DELETE con `MapDelete`, validación de existencia.
| Pista fortalecimiento — U2 profundizado: INSERT con retorno de ID y operaciones completas | 50 min | `ExecuteScalar<long>` para IDs generados, UPDATE con `Execute`, triple JOIN.
| Pista intensificación — U1: métodos y estructura del proyecto | 50 min | Repaso de la estructura de `Program.cs`, parámetros de ruta y query, integrador U1.
| Pista fortalecimiento — U2: validación y manejo de errores | 50 min | Validación de entrada, manejo de errores con `try/catch`, desafío completo PUT.
| Pista intensificación — Integración y cierre Git | 45 min | Ejercicio integrador U1+U2, commit y push, repaso de errores comunes.
| Pista fortalecimiento — Desafíos de integración y cierre Git | 45 min | Desafíos U1+U2: endpoint GET con JOIN, conteo con `ExecuteScalar`, commit y push.
| Cierre conjunto | 15 min | Verificación de repositorios, anticipación del proyecto puente.

**Pistas en paralelo:** intensificación y fortalecimiento trabajan simultáneamente en bloques distintos con actividades diferenciadas.

## 9. Regla de equivalencia entre versiones

Las versiones equivalentes son A/B/C/D (mínimo dos según los grupos). Misma estructura, mismos objetivos y requisitos, distinto dominio o datos. La versión A usa el dominio de tickets (U1) y hospital.db doctors/admissions (U2). Las versiones B/C/D usan el mismo dominio con datos equivalentes pero distintos (biblioteca/books para U1, pacientes/clínicas/enfermeras para U2).

## 10. Mecánica de asignación de versiones

El docente asigna la versión al inicio del encuentro y la registra en la planilla de evaluación. Las versiones se distribuyen equitativamente entre los grupos. Se anota la letra de la versión y el nombre del archivo en la planilla correspondiente.

## 11. Devolución

La devolución se realiza en el encuentro siguiente (E19). Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia del proyecto puente (E19-20) como primera capa de recuperación y la de diciembre como segunda capa.
