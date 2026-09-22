# Evaluación de la Unidad 1 — Encuentro 9

> Evaluación de la instancia «Evaluación de la Unidad 1 — Encuentro 9» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-u1-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-u1-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación de la Unidad 1 — Encuentro 9 |
| Unidad evaluada | 1 — Fundamentos de C# y Minimal API |
| Eje temático | Introducción a C# y Minimal API: tipos, control de flujo, métodos, primer endpoint GET |
| Carácter/Objetivo | Evaluación diagnóstica de fundamentos de C# y creación del primer endpoint GET con MapGet; verifica la transición de la lógica procedural de las clases previas al patrón Minimal API. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-u1.md` · `evaluacion-u1-version-a.md` · `evaluacion-u1-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Entrega del TP por GitHub + defensa individual | 60 min | Cada alumno presenta su TP-U1 (mini API GET) al docente; el docente verifica el endpoint funcionando y pregunta por decisiones de diseño. |
| Devolución y retroalimentación | 60 min | El docente devuelve la evaluación con comentarios individuales; se registran los puntos de mejora en la planilla. |
| Cierre y registro | 60 min | Se consolidan las notas de la defensa en la planilla de evaluación; se anuncian los criterios de la próxima evaluación (U2). |
| Apertura del encuentro siguiente | 60 min | Se presenta el TP-U2 y se resuelven preguntas sobre la transición de U1 a U2 (sqlite, Dapper). |
| **Total** | **240 min** | |

## 3. Regla canónica de la instancia

La entrega del TP-U1 se realiza por GitHub antes del encuentro. La defensa individual se realiza en este encuentro (E9). La devolución de evaluaciones abre el encuentro siguiente (E10). Si la entrega está incompleta, el alumno defiende solo lo entregado y recibe devolución condicionada; la entrega pendiente se resuelve en el encuentro siguiente con extensión de 48 horas.

## 4. Defensa individual del TP (modalidad)

El alumno presenta su endpoint GET funcionando en un navegador o curl. El docente pregunta: (1) qué hace el endpoint y qué retorna, (2) cómo se declaró el record y por qué se usa `Results.Ok`, (3) qué pasa si se cambia un tipo de dato en el record, (4) cómo se probó la aplicación. Se registra por objetivo: cumplimiento del endpoint (0-25), convenciones de código (0-25), explicación de diseño (0-25), Git y entrega (0-25).

## 5. Alcance

Núcleos incluidos: tipos básicos de C# (int, string, bool, long), control de flujo (if/else, switch), métodos con parámetros y retorno, creación de un proyecto con `dotnet new web`, primer endpoint GET con `MapGet`, parámetros de ruta (`{id:long}`) y query string, convenciones de respuesta HTTP (`Results.Ok`, `Results.NotFound`), estructura de `Program.cs` con top-level statements, records posicionales después de `app.Run()`. No incluye: base de datos, Dapper, operaciones CRUD, endpoints POST/PUT/DELETE.

## 6. Prueba práctica individual (versiones equivalentes)

Cada alumno recibe una versión equivalente (A o B) al azar. La prueba dura 90 minutos, es individual, con computadora, sin celular. El alumno debe completar el esqueleto de `Program.cs` provisto en la versión recibida. La prueba evalúa los objetivos de la unidad con distinto dominio para evitar copia.

## 7. Criterios de calificación

Se evalúan: correctitud del endpoint (40 puntos), uso de convenciones del curso (tipos canónicos, `Results.*`, record posicional, `app.Run()` antes de records) (30 puntos), código limpio y comentarios en español (15 puntos), entrega Git con .gitignore y commits (15 puntos). La nota mínima para aprobar es 60 puntos.

## 8. Condiciones de resolución de la prueba

Resolución individual. Se permite el uso de la hoja de convenciones técnicas (`convenciones-tecnicas.md`) como material consultable. No se permite consultar soluciones de compañeros ni usar IA generativa. El código debe estar en un único archivo `Program.cs`. El alumno debe cerrar la aplicación (`Ctrl+C`) y dejar el proyecto en estado limpio al terminar.

## 9. Regla de equivalencia entre versiones

Las versiones A y B tienen los mismos objetivos y los mismos requisitos, con distinto dominio y datos. Ninguna versión tiene reglas que la otra no tenga. Ambas versiones evalúan lo mismo: creación de un endpoint GET en una mini API en memoria, uso de records posicionales, y convenciones del curso.

## 10. Mecánica de asignación de versiones

Se asigna una versión (A o B) a cada alumno al azar en el momento de la prueba. El docente registra la versión asignada en la planilla de evaluación junto al nombre del alumno. Los alumnos no pueden cambiar de versión una vez asignada.

## 11. Devolución

La devolución se realiza en el encuentro siguiente (E10). Se devuelve la evaluación con los puntos obtenidos por cada criterio y los comentarios del docente. Si un alumno no alcanza el objetivo mínimo (60 puntos), se le asigna una capa de recuperación: debe rehacer la prueba con la versión alternativa en el encuentro de recuperación programado.