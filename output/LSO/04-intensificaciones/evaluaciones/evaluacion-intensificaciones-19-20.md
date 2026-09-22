# Evaluación del momento de intensificación y fortalecimiento 19-20

> Evaluación de la instancia «Evaluación del momento de intensificación y fortalecimiento 19-20» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-19-20-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-intensificaciones-19-20-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación del momento de intensificación y fortalecimiento 19-20 |
| Momento | Intensificación y fortalecimiento — encuentros 19-20 |
| Carácter/Objetivo | Proyecto puente integrador U1+U2: única pista para todo el curso. Rúbrica de 100 puntos. Criterio de evaluación: Apto (≥60 pts) / No apto (<60 pts). |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-19-20.md` · `evaluacion-intensificaciones-19-20-version-a.md` · `evaluacion-intensificaciones-19-20-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y presentación del proyecto | 15 min | El docente presenta el proyecto puente, la rúbrica de 100 puntos y el alcance. |
| Bloque 1: Consigna y planificación | 55 min | Lectura colectiva de la consigna, planificación en parejas (records, endpoints, consultas SQL), puesta en común y definición de la estructura de datos. |
| Bloque 2: Implementación de endpoints | 115 min | Implementar endpoints GET con JOIN, verificar tipos canónicos, probar con curl/Thunder Client. |
| Cierre con defensa | 55 min | Defensa oral individual (2-3 min), registro de puntajes en la rúbrica de 100 puntos, commit final y push. |
| **Total** | **240 min** | |

## 3. Acuerdo pedagógico por grupo de condición

**Única pista para todo el curso:** Construcción progresiva de un proyecto Minimal API completa que consulta `hospital.db` con Dapper. Se articula U1 (endpoints GET, tipos C#, respuestas HTTP) y U2 (conexión SQLite, consultas Dapper parametrizadas, JOIN con alias `AS`). El docente modela cada operación en vivo y acompaña individualmente.

**Recursos:** VS Code, terminal, `hospital.db` copiado al lado del `.csproj`, repo grupal clonado, consigna del proyecto puente impresa con rúbrica de 100 puntos, ejemplos resueltos de U1 y U2, convenciones técnicas del curso a la mano.

## 4. Desarrollo de los encuentros del momento

**Encuentro 19 (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y presentación del proyecto | 15 min | El docente presenta el proyecto puente, la rúbrica de 100 puntos y el alcance.
| Bloque 1: Consigna y planificación | 55 min | Lectura colectiva de la consigna, planificación en parejas (records, endpoints, consultas SQL), puesta en común y definición de la estructura de datos.
| Bloque 2: Endpoint GET con ruta y JOIN | 55 min | Implementar `GET /patients/{id:long}` con JOIN a provinces, `GET /patients/search?name=...` con LIKE, probar con curl/Thunder Client.
| Cierre | 15 min | Puesta en común, verificación de commits, anticipación del E20.

**Encuentro 20 (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y repaso | 15 min | Repaso de lo creado en el E19, presentación de los endpoints faltantes.
| Bloque 3: Endpoint de admisiones con triple JOIN | 55 min | Implementar `GET /admissions/{id:long}` con triple JOIN, verificar tipos canónicos, probar con curl/Thunder Client.
| Bloque 4: Pulido, README y entrega | 55 min | Pulido del código, creación de README de portada, commit final y push.
| Cierre con defensa | 15 min | Defensa oral individual (2-3 min), registro de puntajes en la rúbrica de 100 puntos.

**Pistas en paralelo:** no aplica — única pista para todo el curso.

## 9. Regla de equivalencia entre versiones

Las versiones equivalentes son A/B/C/D (mínimo dos según los grupos). Misma estructura, mismos objetivos y requisitos, distinto dominio o datos. La versión A usa el dominio de tickets (sistema de soporte). Las versiones B/C/D usan el mismo dominio con datos equivalentes pero distintos (biblioteca/books, cursos/courses, canciones/songs).

## 10. Mecánica de asignación de versiones

El docente asigna la versión al inicio del encuentro y la registra en la planilla de evaluación. Las versiones se distribuyen equitativamente entre los grupos. Se anota la letra de la versión y el nombre del archivo en la planilla correspondiente.

## 11. Devolución

La devolución se realiza al final del E20. Se devuelve con nota numérica según la rúbrica de 100 puntos: Apto (≥60 pts) o No apto (<60 pts). Si el objetivo mínimo queda pendiente, se ofrece la instancia de intensificación de los encuentros 34-35 como primera capa de recuperación y la de diciembre como segunda capa.
