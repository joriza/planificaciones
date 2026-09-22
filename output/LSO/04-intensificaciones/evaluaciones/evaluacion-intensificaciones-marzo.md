# Evaluación del momento de intensificación y fortalecimiento marzo

> Evaluación de la instancia «Evaluación del momento de intensificación y fortalecimiento marzo» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-marzo-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-intensificaciones-marzo-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación del momento de intensificación y fortalecimiento marzo |
| Momento | Camino mínimo completo U1→U4 (dominios A) |
| Carácter/Objetivo | Evaluación integradora del camino mínimo: U1 (tipos, control de flujo, endpoint GET), U2 (SELECT/JOIN/LIKE sobre hospital.db), U3 (CRUD con validación y códigos HTTP), U4 (flujo git básico). Criterio de evaluación: Apto / No apto. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-marzo.md` · `evaluacion-intensificaciones-marzo-version-a.md` · `evaluacion-intensificaciones-marzo-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y presentación del camino mínimo | 15 min | El docente presenta la estructura de la evaluación integradora, los dominios A (tickets y doctors/admissions) y la rúbrica de Apto/No apto. |
| Bloque U1 — Tipos, control de flujo y endpoint GET | 60 min | Repaso de tipos canónicos, condicionales, bucles y primer endpoint GET con `MapGet`. Ejercicios de tickets en memoria. |
| Bloque U2 — SELECT, JOIN y LIKE sobre hospital.db | 60 min | Conexión a SQLite, SELECT con WHERE y parámetros, LIKE para búsqueda, JOIN con alias `AS`. |
| Bloque U3 — CRUD y U4 — Flujo git | 60 min | INSERT/UPDATE/DELETE con validación y códigos HTTP correctos; README, issue, rama y PR. |
| Cierre y verificación | 45 min | Puesta en común, verificación de commits, retroalimentación individual. |
| **Total** | **240 min** | |

## 3. Acuerdo pedagógico por grupo de condición

**Grupo de intensificación (recuperación pedagógica):** U1: tipos (`int`, `long`, `float`, `string`, `bool`), entrada/salida (`Console.WriteLine`, `Console.ReadLine`), condicionales (`if`/`else`, `switch`), bucles (`for`, `while`), métodos (`static`, parámetros, retorno), primer endpoint GET (`MapGet`), parámetros de ruta y query. U2: conexión a SQLite (`Data Source=hospital.db`), SELECT con WHERE y parámetros, JOIN de 2 tablas, ORDER BY, `Query<T>` con alias `AS`, LIKE para búsqueda por patrón. U3: INSERT con `MapPost` y código 201, DELETE con `MapDelete` y código 204/404, UPDATE con `MapPut` y código 200/404, validación de existencia antes de cada operación. U4: README de portada, issues, ramas por feature, PR revisados, `main` protegida.

**Grupo de fortalecimiento (profundización):** U1: tipos canónicos de Dapper (`long` para INTEGER, `string` para TEXT, `string?`/`long?` para nullable), registros posicionales, top-level statements, `Results.Ok`/`Results.NotFound`/`Results.Created`/`Results.BadRequest`, códigos HTTP 200/201/204/400/404. U2: `QueryFirstOrDefault<T>`, `ExecuteScalar<long>`, `Execute` para INSERT/UPDATE/DELETE, consultas parametrizadas con `new { id }`, triple JOIN, validación de existencia antes de operaciones. U3: triple JOIN en consultas de lectura, validación de integridad referencial en handlers, patrones de respuesta consistentes, manejo de errores con `try/catch` en handlers. U4: flujo profesional completo (issue → rama → PR → merge), README avanzado con badges, code review cruzado entre pares, protección de `main` con reglas de branch.

**Recursos:** VS Code, terminal, repo grupal clonado, guía impresa de núcleos U1 a U4, ejemplos resueltos de cada unidad, `hospital.db` copiado al lado del `.csproj`, consigna del camino mínimo impresa.

## 4. Desarrollo de los encuentros del momento

**Encuentro marzo (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y presentación del camino mínimo | 15 min | El docente presenta la evaluación integradora, los dominios A y la rúbrica de Apto/No apto. |
| Bloque U1 — Tipos, control de flujo y endpoint GET | 60 min | Repaso de tipos canónicos, condicionales, bucles y primer endpoint GET con `MapGet`. Ejercicios de tickets en memoria. |
| Bloque U2 — SELECT, JOIN y LIKE sobre hospital.db | 60 min | Conexión a SQLite, SELECT con WHERE y parámetros, LIKE para búsqueda, JOIN con alias `AS`. |
| Bloque U3 — CRUD y U4 — Flujo git | 60 min | INSERT/UPDATE/DELETE con validación y códigos HTTP correctos; README, issue, rama y PR. |
| Cierre y verificación | 45 min | Puesta en común, verificación de commits, retroalimentación individual. |

**Pistas en paralelo:** no aplica — camino mínimo único para todo el curso.

## 9. Regla de equivalencia entre versiones

Las versiones equivalentes son A/B/C/D (mínimo dos según los grupos). Misma estructura, mismos objetivos y requisitos, distinto dominio o datos. La versión A usa el dominio de tickets (U1) y doctors/admissions (U2). Las versiones B/C/D usan el mismo dominio con datos equivalentes pero distintos (biblioteca/books para U1, pacientes/clínicas para U2).

## 10. Mecánica de asignación de versiones

El docente asigna la versión al inicio del encuentro y la registra en la planilla de evaluación. Las versiones se distribuyen equitativamente entre los grupos. Se anota la letra de la versión y el nombre del archivo en la planilla correspondiente.

## 11. Devolución

La devolución se realiza al final del encuentro. Se devuelve con nota de Apto o No apto. Si el objetivo mínimo queda pendiente, se ofrece la instancia de diciembre como primera capa de recuperación.
