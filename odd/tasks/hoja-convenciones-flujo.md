# Feature: hoja-convenciones-flujo

## Goal

Hacer reproducible la creación de `convenciones-tecnicas.md` por el LLM dentro del flujo del prompt plantilla (como en la corrida original, donde la hoja nació de ejecutar y verificar código), sin protegerla como archivo del docente.

## Contexto

- Decisión del docente (2026-09-20): "necesito que lo cree el modelo llm, como lo hace el flujo original. no es un archivo fácil de crear".
- Diagnóstico previo: la hoja es canon de la materia (declarado en la ficha), LLM-generada, acoplada a la carpeta del curso y sin fase de autoría en la cascada.
- Descartado: reubicar la hoja a `materias/` (pieza A de la propuesta anterior) — el docente quiere que el LLM la cree en cada corrida.
- El README raíz tiene la sección "Regenerar un corpus completo" (sin commit) que hoy EXCEPCIONA la hoja: se simplifica.

## Tasks

- [x] T1: Crear `plantillas/plantilla-convenciones-tecnicas.md` — esqueleto stack-agnostic con las 9 secciones probadas (espejo de `minimal-api-csharp/convenciones-tecnicas.md`), marcadores ⟨⟩ al estilo de `materias/plantilla-materia.md`, e instrucciones del spike de verificación (compilar/ejecutar casos límite antes de escribir tipos/acceso/respuestas). — writer (gentle-ai-worker), 139 líneas.
- [x] T2: Actualizar `0-prompt-plantilla-planificacion.md` — Fase 0 gana la autoría de la hoja para materias con código (plantilla + spike + reuso si existe vigente + FRENO conjunto JSON/hoja); dieta de writers de Fase 2 e [Indicaciones finales] incluye la hoja declarada en la ficha. — writer, 3 ediciones quirúrgicas (líneas 93, 95, 185).
- [x] T3: Actualizar `README.md` — regeneración sin excepción (la carpeta del curso se borra entera; la hoja se recrea en Fase 0 con spike); "Crear un curso nuevo" menciona la hoja. — writer + ajuste de coherencia inline del orquestador (dieta de writers en pasos 5 y 4).
- [x] T4: Verificación cruzada de coherencia (sin referencias residuales a la excepción) y cierre. — checks en verde (ver Evidencia).

## Evidencia

- Verificación (2026-09-20): `grep "excepto convenciones" README.md` sin coincidencias; plantilla referenciada en README (2×) y prompt Fase 0 (1×); hoja en ambas dietas de writers (Fase 2 línea 95, [Indicaciones finales] línea 185); FRENO conjunto "JSON y la hoja" en línea 93; 5 menciones de la hoja en README. Diff total: plantilla nueva (139 líneas) + prompt (6 líneas) + README (16 líneas).
- Work-unit commit (2026-09-20): `62e9bca` — `docs(canon): add LLM-authoring flow for technical conventions sheet` en `feature/optimizacion-tiempo-tokens` (README.md + 0-prompt-plantilla-planificacion.md + plantillas/plantilla-convenciones-tecnicas.md; 3 archivos, +156/−5), autorizado por el docente.
- Nota de alcance: la pieza A (reubicar la hoja a `materias/`) quedó descartada por decisión del docente; el acoplamiento restante del digest de código (100 % C# en `plantillas/`) quedó documentado como nota en la plantilla, no reestructurado.
