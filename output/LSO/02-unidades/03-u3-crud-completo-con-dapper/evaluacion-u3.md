# Evaluación de la Unidad 3 — Encuentro 26

> Evaluación de la instancia «Evaluación de la Unidad 3 — Encuentro 26» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-u3-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-u3-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación de la Unidad 3 — Encuentro 26 |
| Unidad evaluada | 3 — CRUD completo con Dapper |
| Eje temático | Operaciones CRUD completas con Dapper: INSERT, DELETE, UPDATE, validación de existencia |
| Carácter/Objetivo | Evaluación de la capacidad de implementar las cuatro operaciones CRUD vía endpoints HTTP con Dapper, incluyendo validación de existencia y JOIN de 3 tablas. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-u3.md` · `evaluacion-u3-version-a.md` · `evaluacion-u3-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Entrega del TP por GitHub + defensa individual | 60 min | Cada alumno presenta su TP-U3 (API CRUD completa con hospital.db) al docente; el docente verifica los endpoints funcionando y pregunta por decisiones de diseño. |
| Devolución y retroalimentación | 60 min | El docente devuelve la evaluación con comentarios individuales; se registran los puntos de mejora en la planilla. |
| Cierre y registro | 60 min | Se consolidan las notas de la defensa en la planilla de evaluación; se anuncian los criterios de la próxima evaluación (U4). |
| Apertura del encuentro siguiente | 60 min | Se presenta el trabajo final de U4 y se resuelven preguntas sobre la transición de U3 a U4 (profesionalización, ramas, PR). |
| **Total** | **240 min** | |

## 3. Regla canónica de la instancia

La entrega del TP-U3 se realiza por GitHub antes del encuentro. La defensa individual se realiza en este encuentro (E26). La devolución de evaluaciones abre el encuentro siguiente (E27). Si la entrega está incompleta, el alumno defiende solo lo entregado y recibe devolución condicionada; la entrega pendiente se resuelve en el encuentro siguiente con extensión de 48 horas.

## 4. Defensa individual del TP (modalidad)

El alumno presenta su API CRUD completa funcionando. El docente pregunta: (1) cómo se implementa la validación de existencia antes de INSERT/UPDATE/DELETE, (2) qué código HTTP se retorna en cada operación y por qué, (3) cómo se parametrizan las consultas y por qué no se concatena, (4) cómo se maneja un JOIN de 3 tablas, (5) qué pasa si se intenta borrar un recurso inexistente. Se registra por objetivo: correctitud de CRUD (0-30), códigos HTTP y validación (0-25), JOIN triple (0-20), explicación de diseño (0-15), Git y entrega (0-10).

## 5. Alcance

Núcleos incluidos: INSERT con `ExecuteScalar<long>` y `MapPost`, DELETE con `MapDelete` y código 204, UPDATE con `MapPut` y código 200, validación de existencia con `QueryFirstOrDefault`, códigos 201/200/404, JOIN de 3 tablas (admissions + doctors + patients), consultas parametrizadas con `new {}`. No incluye: autenticación, paginación avanzada, tests de integración.

## 6. Prueba práctica individual (versiones equivalentes)

Cada alumno recibe una versión equivalente (A o B) al azar. La prueba dura 90 minutos, es individual, con computadora, sin celular. El alumno debe completar el esqueleto de `Program.cs` provisto en la versión recibida conectando a `hospital.db`. La prueba evalúa los objetivos de la unidad con distinto dominio para evitar copia.

## 7. Criterios de calificación

Se evalúan: correctitud de las operaciones CRUD (30 puntos), códigos HTTP y validación de existencia (25 puntos), JOIN de 3 tablas (20 puntos), explicación de decisiones de diseño (15 puntos), entrega Git con .gitignore y commits (10 puntos). La nota mínima para aprobar es 60 puntos.

## 8. Condiciones de resolución de la prueba

Resolución individual. Se permite el uso de la hoja de convenciones técnicas (`convenciones-tecnicas.md`) y la documentación de la base (`database-docs/`) como material consultable. No se permite consultar soluciones de compañeros ni usar IA generativa. El código debe estar en un único archivo `Program.cs`. La base de datos `hospital.db` se provee en la carpeta del proyecto. El alumno debe cerrar la aplicación (`Ctrl+C`) y dejar el proyecto en estado limpio al terminar.

## 9. Regla de equivalencia entre versiones

Las versiones A y B tienen los mismos objetivos y los mismos requisitos, con distinto dominio y datos. Ninguna versión tiene reglas que la otra no tenga. Ambas versiones evalúan lo mismo: operaciones CRUD completas con Dapper sobre hospital.db, validación de existencia, códigos HTTP correctos, y JOIN de 3 tablas.

## 10. Mecánica de asignación de versiones

Se asigna una versión (A o B) a cada alumno al azar en el momento de la prueba. El docente registra la versión asignada en la planilla de evaluación junto al nombre del alumno. Los alumnos no pueden cambiar de versión una vez asignada.

## 11. Devolución

La devolución se realiza en el encuentro siguiente (E27). Se devuelve la evaluación con los puntos obtenidos por cada criterio y los comentarios del docente. Si un alumno no alcanza el objetivo mínimo (60 puntos), se le asigna la versión alternativa (B) para recuperación. Se registra la nota en la planilla con los comentarios del docente.