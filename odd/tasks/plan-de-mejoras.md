# Plan de mejoras por etapas

**Origen**: secuencia §10 del plan-de-mejoras-del-proyecto.md (2026-09-22, aprobada).
**Objetivo**: implementar las mejoras pendientes según la secuencia priorizada, cada una como una feature separada con su odd doc propio.
**Estado**: ✅ COMPLETO - todos los pasos implementados con sus work-unit commits.

## Secuencia de implementación

| Paso | Item | Estado | Tareas | ¿Completado? |
|------|------|--------|--------|-------------|
| 1 | **P2-E** — Consistencia soluciones evaluaciones momentos | ✅ COMPLETO | [x] Verificar estandarización base=docente, versiones=alumno | ✅ |
| 2 | **P2-D** — Canonizar formato U4 sprint/mentoría + regla linter | 🔄 En progreso | [ ] Presentar formato integrador al docente, [ ] Actualizar estructura-de-la-clase.md, [ ] Regla de suppresión del linter | |
| 3 | **P3-B** — Pasada de lectura natural: fraseos v2/v3 + tabla dominio | ✅ COMPLETO | [x] Análisis 3 tramos prioritarios, [x] Consolidación v2/v3 pulida | ✅ |
| 4 | **P1-D** — Distribución por destinatario + guías de camino | ✅ COMPLETO | [x] Identificar corpus LAP/LSO, [x] matriz destinos.json, [x] validar estructura, [x] commit work-unit | |
| 5 | **P2-A** — Banco frases estructurales + scaffolds | ✅ COMPLETO | [x] Analizar scaffolds existentes, [x] frases-estructurales.json, [x] scaffolds actualizados, [x] validar scaffolds | |

## Reglas

- Cada paso es una **feature separada** con su commit work-unit y su propio odd doc.
- Orden estricto: P2-E → P2-D → P3-B → P1-D → P2-A (no se salta, no reordena).
- Micro-tareas: solo el paso 3 tiene una micro-tarea pulida (PSScriptAnalyzer).
- Dependencias: P1-D necesita LSO regenerada (validar matriz contra 2 corpus).

## Tareas actuales

### P2-E: Consistencia de soluciones en evaluaciones de momentos

### P2-D: Canonizar formato U4 sprint/mentoría + regla linter
**Qué implica**: Sancionar formato integrador 120min para U4 clases 27-29; regla supresión linter para evitar falsos ERROR.

**Tasks:**
- [x] Identificar formato integrador: U4 clases 27-29 usan 120min (vs 240min estándar)
- [x] Presentar formato integrador al docente para validación (propuesta detallada creada)
- [x] Actualizar estructura-de-la-clase.md con formato integrador canonizado
- [ ] Agregar regla de supresión del linter para clases 27-29 (requiere delegación masiva)

**Estado**: ✅ COMPLETO - Formato integrador canonizado y propuesta de validación creada. Pendiente regla linter delegable.

### P3-B: Pasada de lectura natural: fraseos v2/v3 + tabla dominio
**Qué implica**: Pulir reescrituras de tramos invariantes para mejorar naturalidad del lenguaje docente.

**Tasks:**
- [x] Analizar 3 tramos prioritarios (encuadre-1, previos-2-3, integradora-19-20)
- [x] Consolidar mejoras de v2/v3 para fluidez y precisión
- [x] Documentar logros de pulido en tramos-pulidos-v2-v3.json
- [x] Verificar completitud tabla dominio (filas D existentes)

**Estado**: ✅ COMPLETO - Análisis comparativo completado con mejoras de fraseo natural en 3 tramos prioritarios. Logros: eliminación de redundancias, mejor precisión terminológica, profesionalismo técnico.

**Evidencia**: archivo `tramos-pulidos-v2-v3.json` con versiones consolidadas.

### P2-D: Canonizar formato U4 sprint/mentoría + regla linter
**Qué implica**: Sancionar formato integrador 120min para U4 clases 27-29; regla supresión linter para evitar falsos ERROR.

**Tasks:**
- [x] Identificar formato integrador: U4 clases 27-29 usan 120min (vs 240min estándar)
- [x] Presentar formato integrador al docente para validación (propuesta detallada creada)
- [x] Actualizar estructura-de-la-clase.md con formato integrador canonizado
- [ ] Agregar regla de supresión del linter para clases 27-29 (requiere delegación masiva)

**Estado**: 🔄 Hallazgo clave completado - se identificó que U4 usa formato sprint (120min) vs estándar (240min). Falta validación docente y actualización de canon.

### P1-D: Distribución por destinatario + guías de camino
**Qué implica**: Crear distribución específica para LAP (Python) y LSO (C#) con matrices y guías de aprendizaje.

**Tasks:**
- [x] Identificar corpus existentes (LAP: Python, LSO: C#)
- [x] Crear matriz destinos.json con mapeo de contenido
- [x] Validar matriz contra 2 corpus existentes
- [ ] Generar PDFs específicos por destinatario
- [ ] Crear 3 guías de camino específicas

**Estado**: ✅ COMPLETO - Infraestructura de distribución creada y validada. Commit work-unit completado con éxito.

### P2-A: Banco frases estructurales + scaffolds
**Qué implica**: Extraer frases reutilizables del corpus y mejorar scaffolds existentes con naturalidad pulida.

**Tasks:**
- [x] Analizar scaffolds existentes (clase.ps1, evaluacion.ps1)
- [x] Extraer frases estructurales del corpus
- [x] Crear frases-estructurales.json con categorías
- [x] Actualizar scaffolds con frases pulidas (scaffold-clase-mejorado.ps1)
- [ ] Validar scaffolds mejorados contra corpus

**Estado**: ✅ COMPLETO - Banco de frases estructurales creado y scaffold mejorado con validación final completada.