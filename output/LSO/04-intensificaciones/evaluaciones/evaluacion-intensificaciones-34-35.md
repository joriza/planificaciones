# Evaluación del momento de intensificación y fortalecimiento 34-35

> Evaluación de la instancia «Evaluación del momento de intensificación y fortalecimiento 34-35» · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-34-35-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-intensificaciones-34-35-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación del momento de intensificación y fortalecimiento 34-35 |
| Momento | Intensificación y fortalecimiento — encuentros 34-35 |
| Carácter/Objetivo | Tercera instancia de pistas intensificación (núcleos mínimos) y fortalecimiento (extensión) de U3 y U4. Criterio de evaluación: Apto / No apto aún por objetivo mínimo. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-34-35.md` · `evaluacion-intensificaciones-34-35-version-a.md` · `evaluacion-intensificaciones-34-35-version-a-anexo-docente.md` (más las versiones equivalentes B/C/D generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y asignación de pistas | 15 min | El docente recorre los núcleos de U3 y U4 y asigna cada estudiante a su pista según el desempeño en TP-U3 y el estado del trabajo final. |
| Pista intensificación — U3 CRUD y U4 flujo | 105 min | U3: INSERT, DELETE, UPDATE con validación y códigos HTTP (201/200/404). U4: README, issues, ramas, PR. |
| Pista fortalecimiento — U3+U4 profundizado | 105 min | U3: triple JOIN, manejo de errores, patrones de respuesta consistentes. U4: flujo profesional completo, code review cruzado. |
| Cierre y verificación del proyecto final | 15 min | Verificación del proyecto final (README, issue, rama, PR), commit y push final. |
| **Total** | **240 min** | |

## 3. Acuerdo pedagógico por grupo de condición

**Grupo de intensificación (recuperación pedagógica):** U3: INSERT con `MapPost` y código 201, DELETE con `MapDelete` y código 204/404, UPDATE con `MapPut` y código 200/404, validación de existencia antes de cada operación. U4: README de portada, issues, ramas por feature, PR revisados, `main` protegida, trabajo final: API completa con Dapper.

**Grupo de fortalecimiento (profundización):** U3: triple JOIN en consultas de lectura, validación de integridad referencial en handlers, patrones de respuesta consistentes (siempre `Results.*`, nunca objetos crudos), manejo de errores con `try/catch` en handlers. U4: flujo profesional completo (issue → rama → PR → merge), README avanzado con badges, code review cruzado entre pares, protección de `main` con reglas de branch.

**Recursos:** VS Code, terminal, repo grupal clonado, guía impresa de núcleos U3 y U4, ejemplos resueltos del TP-U3, plantilla README, lista de verificación de objetivos por alumno, `hospital.db` copiado al lado del `.csproj` (intensificación); VS Code, terminal, repo grupal, consignas de desafío impresas, documentación de convenciones técnicas del curso, `hospital.db` copiado al lado del `.csproj`, plantilla README avanzado (fortalecimiento).

## 4. Desarrollo de los encuentros del momento

**Encuentro 34 (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura conjuna y asignación de pistas | 15 min | El docente recorre los núcleos de U3 y U4. Se asigna cada estudiante a su pista según el desempeño en TP-U3 y el estado del trabajo final.
| Pista intensificación — U3: INSERT con MapPost y validación | 50 min | Repaso del esqueleto de `Program.cs` para operaciones de escritura, INSERT con `Execute` y código 201, validación de existencia antes de INSERT.
| Pista fortalecimiento — U3 profundizado: triple JOIN y validación de integridad | 50 min | Triple JOIN en lectura, record `AdmissionDetail` con tipos canónicos, endpoint GET con triple JOIN.
| Pista intensificación — U3: DELETE con MapDelete y UPDATE con MapPut | 50 min | DELETE con `MapDelete`, UPDATE con `MapPut`, validación de existencia antes de DELETE.
| Pista fortalecimiento — U3 profundizado: manejo de errores y patrones de respuesta | 50 min | Manejo de errores con `try/catch`, patrón de respuesta consistente, desafío PUT con validación completa.
| Pista intensificación — U3: integración CRUD completa | 50 min | Ejercicio integrador: programa Minimal API completo con los cuatro endpoints CRUD para `patients`.
| Pista fortalecimiento — U3+U4: flujo profesional y trabajo final | 50 min | Crear issue en GitHub, crear rama por feature, abrir PR hacia `main`.
| Pista intensificación — Integración y práctica | 45 min | Ejercicio integrador U3+U4: completar el proyecto con README, verificar protección de `main`, repaso de errores comunes.
| Pista fortalecimiento — Desafíos de integración y cierre | 45 min | Desafío U3 (DELETE con dependencias), code review cruzado, commit y push final.
| Cierre conjunto | 15 min | Puesta en común, diferencia entre `MapPost` con 201 y `MapPut` con 200, anticipación del E35.

**Encuentro 35 (240 min):**

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura conjuna y repaso | 15 min | Repaso de U3 y U4, anuncio del cierre del curso.
| Pista intensificación — U4: README profesional y cierre del repo | 50 min | Crear/actualizar README, crear issue en GitHub.
| Pista fortalecimiento — U4 avanzado: README con badges y flujo profesional | 50 min | README avanzado con badges, code review cruzado.
| Pista intensificación — U4: Trabajo final — commits, PR y main protegida | 50 min | Completar el trabajo final, verificar protección de `main`, PR revisado y mergeado.
| Pista fortalecimiento — U4: Resolución de issues con ramas y PR | 50 min | Tomar un issue, crear rama, implementar solución, PR, merge.
| Pista intensificación — Integración y cierre | 45 min | Verificación del proyecto final (README, issue, rama, PR), commit y push final.
| Pista fortalecimiento — Desafíos de integración y cierre | 45 min | Desafío U3+U4 (endpoint adicional), code review final, commit y push final.
| Cierre conjunto | 15 min | Puesta en común, cierre del curso.

**Pistas en paralelo:** intensificación y fortalecimiento trabajan simultáneamente en bloques distintos con actividades diferenciadas.

## 9. Regla de equivalencia entre versiones

Las versiones equivalentes son A/B/C/D (mínimo dos según los grupos). Misma estructura, mismos objetivos y requisitos, distinto dominio o datos. La versión A usa el dominio de hospital (pacientes, doctores, admisiones). Las versiones B/C/D usan el mismo dominio con datos equivalentes pero distintos (clínicas/provincias para C, enfermeras/departamentos para D, pacientes/ciudades para B).

## 10. Mecánica de asignación de versiones

El docente asigna la versión al inicio del encuentro y la registra en la planilla de evaluación. Las versiones se distribuyen equitativamente entre los grupos. Se anota la letra de la versión y el nombre del archivo en la planilla correspondiente.

## 11. Devolución

La devolución se realiza al final del E35. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de diciembre como primera capa de recuperación y la de marzo como segunda capa.
