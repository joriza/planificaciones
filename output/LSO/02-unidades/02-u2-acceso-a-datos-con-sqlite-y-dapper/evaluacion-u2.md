# Evaluación de la Unidad 2 — Encuentro 15

> Evaluación de la instancia «Evaluación de la Unidad 2 — Encuentro 15» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-u2-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-u2-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación de la Unidad 2 — Encuentro 15 |
| Unidad evaluada | 2 — Acceso a datos con SQLite y Dapper |
| Eje temático | Consultas SELECT con Dapper: parametrización, alias AS, tipos canónicos |
| Carácter/Objetivo | Evaluación de la capacidad de consultar una base SQLite con Dapper usando consultas parametrizadas, alias AS para mapeo de columnas, y los tipos canónicos INTEGER→long/long?. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-u2.md` · `evaluacion-u2-version-a.md` · `evaluacion-u2-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Entrega del TP por GitHub + defensa individual | 60 min | Cada alumno presenta su TP-U2 (consultas a hospital.db) al docente; el docente verifica las consultas funcionando y pregunta por decisiones de diseño. |
| Devolución y retroalimentación | 60 min | El docente devuelve la evaluación con comentarios individuales; se registran los puntos de mejora en la planilla. |
| Cierre y registro | 60 min | Se consolidan las notas de la defensa en la planilla de evaluación; se anuncian los criterios de la próxima evaluación (U3). |
| Apertura del encuentro siguiente | 60 min | Se presenta el TP-U3 y se resuelven preguntas sobre la transición de U2 a U3 (INSERT, UPDATE, DELETE). |
| **Total** | **240 min** | |

## 3. Regla canónica de la instancia

La entrega del TP-U2 se realiza por GitHub antes del encuentro. La defensa individual se realiza en este encuentro (E15). La devolución de evaluaciones abre el encuentro siguiente (E16). Si la entrega está incompleta, el alumno defiende solo lo entregado y recibe devolución condicionada; la entrega pendiente se resuelve en el encuentro siguiente con extensión de 48 horas.

## 4. Defensa individual del TP (modalidad)

El alumno presenta sus consultas a hospital.db funcionando. El docente pregunta: (1) por qué se usa `long` y no `int` para las claves primarias, (2) qué pasa si se omite el alias `AS` en un SELECT, (3) cómo se parametrizan las consultas y por qué no se concatena, (4) qué diferencia hay entre `Query<T>` y `ExecuteScalar<long>`, (5) cómo se maneja un resultado nulo con `QueryFirstOrDefault`. Se registra por objetivo: correctitud de consultas (0-30), tipos canónicos y alias (0-25), parametrización (0-20), explicación de diseño (0-15), Git y entrega (0-10).

## 5. Alcance

Núcleos incluidos: SELECT con WHERE, ORDER BY, JOIN entre 2 tablas, `Query<T>` con alias `AS`, parámetros con `new { id }`, `LIKE` para búsqueda parcial, tipos canónicos INTEGER→`long`/`long?`, `ExecuteScalar<long>` para conteos, `QueryFirstOrDefault<T>` para lectura de una fila. No incluye: INSERT/UPDATE/DELETE, endpoints POST/PUT/DELETE, JOIN de 3 tablas.

## 6. Prueba práctica individual (versiones equivalentes)

Cada alumno recibe una versión equivalente (A o B) al azar. La prueba dura 90 minutos, es individual, con computadora, sin celular. El alumno debe completar el esqueleto de `Program.cs` provisto en la versión recibida conectando a `hospital.db`. La prueba evalúa los objetivos de la unidad con distinto dominio para evitar copia.

## 7. Criterios de calificación

Se evalúan: correctitud de las consultas SQL (30 puntos), uso de tipos canónicos y alias `AS` (25 puntos), parametrización de consultas (20 puntos), explicación de decisiones de diseño (15 puntos), entrega Git con .gitignore y commits (10 puntos). La nota mínima para aprobar es 60 puntos.

## 8. Condiciones de resolución de la prueba

Resolución individual. Se permite el uso de la hoja de convenciones técnicas (`convenciones-tecnicas.md`) y la documentación de la base (`database-docs/`) como material consultable. No se permite consultar soluciones de compañeros ni usar IA generativa. El código debe estar en un único archivo `Program.cs`. La base de datos `hospital.db` se provee en la carpeta del proyecto. El alumno debe cerrar la aplicación (`Ctrl+C`) y dejar el proyecto en estado limpio al terminar.

## 9. Regla de equivalencia entre versiones

Las versiones A y B tienen los mismos objetivos y los mismos requisitos, con distinto dominio y datos. Ninguna versión tiene reglas que la otra no tenga. Ambas versiones evalúan lo mismo: consultas SELECT a hospital.db con Dapper, uso de alias AS, tipos canónicos, y parametrización.

## 10. Mecánica de asignación de versiones

Se asigna una versión (A o B) a cada alumno al azar en el momento de la prueba. El docente registra la versión asignada en la planilla de evaluación junto al nombre del alumno. Los alumnos no pueden cambiar de versión una vez asignada.

## 11. Devolución

La devolución se realiza en el encuentro siguiente (E16). Se devuelve la evaluación con los puntos obtenidos por cada criterio y los comentarios del docente. Si un alumno no alcanza el objetivo mínimo (60 puntos), se le asigna la versión alternativa (B) para recuperación. Se registra la nota en la planilla con los comentarios del docente.