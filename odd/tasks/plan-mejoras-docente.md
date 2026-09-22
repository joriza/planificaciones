# Feature: análisis del proyecto y plan de mejoras (vista docente anual)

> Encargo (+det42 de z-pdt-planificaciones.md): análisis profundo del proyecto desde su propósito original
> (ayudar al docente a crear TODA la documentación anual, con el trabajo programado previamente), mejoras
> pedagógicas/funcionales/de implementación, optimización de tiempos y tokens, y generalización de frases
> entre materias. Entregable: plan documentado en `docs/`. **Plan-only: no se implementa ningún cambio.**

## Contexto de ejecución

- Rama actual: `regen/lso` — **ocupada por otra sesión** (regeneración de LSO en curso, 102 archivos en
  borrado de trabajo, 3 CSV nuevos en índice). Por eso esta feature **no commitea ni cambia de rama**:
  los archivos quedan en el árbol para que el docente commitee cuando la regeneración lo permita.
- Respuestas del docente (2026-09-22): LSO no se restaura (se compara vía git; el corpus viejo vive en `main`);
  la clase se imparte en pizarrón y los documentos de alumnos se entregan solo excepcionalmente;
  alcance = ciclo anual completo (incluye documentos no cubiertos); determinismo = moderado.

## Tareas

| # | Tarea | Estado |
|---|---|---|
| T0 | Consultas al docente antes de comenzar (4 decisiones registradas) | ✅ |
| T1 | Exploración y evidencia: corpus LPR (98 .md / 884 KB, 32 anexos = 288 KB), plantillas, canon, git (LSO v1 en `main`), deuda linter | ✅ |
| T2 | Redactar `docs/plan-de-mejoras-del-proyecto.md` (análisis + plan priorizado) | ✅ |
| T3 | Verificación final del documento (cifras, rutas, coherencia con canon) | ✅ |
| T4 | Cierre y reporte (sin commit: rama compartida con la sesión de regeneración) | ✅ |

## Decisiones de esta feature

- La recomendación central sobre anexos docentes es **regla por destino** (docente/alumno/administración),
  no una regla universal; la fusionabilidad de los anexos de clase se apoya en la respuesta del docente
  (entrega excepcional de documentos a alumnos).
- La comparación LSO↔LPR para generalizar frases usa LSO v1 solo como evidencia de deriva de formato;
  el banco de frases debe anclarse al canon vigente (corpus v2: LPR + LSO regenerada).
- Entregable verificado: cifras cruzadas (32 anexos = 288 KB = 32% de 884 KB; anexos de clase 176 KB vs
  clases 228 KB), tablas balanceadas (MD060 del linter = falso positivo, verificado con awk), rutas
  existentes. Sin commits ni cambios de rama: `regen/lso` está en uso por la otra sesión.

## Mirror Engram

- topic_key: `odd/plan-mejoras-docente/tasks`
