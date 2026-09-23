# Plan de mejoras por etapas

**Origen**: secuencia §10 del plan-de-mejoras-del-proyecto.md (2026-09-22, aprobada).
**Objetivo**: implementar las mejoras pendientes según la secuencia priorizada, cada una como una feature separada con su odd doc propio.
**Estado**: rama creada desde main, lista para implementar la secuencia.

## Secuencia de implementación

| Paso | Item | Estado | Tareas | ¿Completado? |
|------|------|--------|--------|-------------|
| 1 | **P2-E** — Consistencia soluciones evaluaciones momentos | 🔄 En progreso | [x] Verificar estandarización base=docente, versiones=alumno | ✅ |
| 2 | **P2-D** — Canonizar formato U4 sprint/mentoría + regla linter | ⏳ Pendiente | [ ] Presentar formato integrador al docente, [ ] Actualizar estructura-de-la-clase.md, [ ] Regla de supresión del linter | |
| 3 | **P3-B** — Pasada de lectura natural: fraseos v2/v3 + tabla dominio | ⏳ Pendiente | [ ] Pulir 24 reescrituras del banco, [ ] Completar filas D de dominio | |
| 4 | **P1-D** — Distribución por destinatario + guías de camino | ⏳ Pendiente | [ ] matriz destinos.json, [ ] -PorDestinatario en PDF, [ ] 3 guías camino | |
| 5 | **P2-A** — Banco frases estructurales + scaffolds | ⏳ Pendiente | [ ] frases-estructurales.json, [ ] scaffolds actualizados | |

## Reglas

- Cada paso es una **feature separada** con su commit work-unit y su propio odd doc.
- Orden estricto: P2-E → P2-D → P3-B → P1-D → P2-A (no se salta, no reordena).
- Micro-tareas: solo el paso 3 tiene una micro-tarea pulida (PSScriptAnalyzer).
- Dependencias: P1-D necesita LSO regenerada (validar matriz contra 2 corpus).

## Tareas actuales

### P2-E: Consistencia de soluciones en evaluaciones de momentos
**Qué implica**: Verificar y estandarizar en el corpus: base = docente, versiones A/B = alumno; paridad del principio "la solución nunca en la hoja"

**Tasks:**
- [x] Verificar estandarización: base=docente, versiones A/B=alumno
- [x] Documentar hallazgos (inconsistencia LAP vs LSO)
- [x] Crear archivo anexo-docente 02-03 versión A
- [ ] Crear 11 archivos anexo-docente restantes (momentos LAP)
- [ ] Commit work-unit con corrección completa

**Evidencia**: Las 18 evaluaciones de intensificación deben tener estructura consistente con las 4 de unidad.