# Feature: det21 — reestructuración de fuentes y limpieza de evaluaciones

Decisiones confirmadas por el usuario (2025, +det21):
1. **Evaluaciones**: exclusivamente una por unidad didáctica + una por momento de intensificación/fortalecimiento. Las `evaluacion-cuatrimestre-1/2` (10 archivos en 03-instancias) son un ERROR → eliminar. E16/E33 = cierre sin examen (síntesis + metacognición + devolución). El término "instancias" queda para las evaluaciones de la intensificación.
2. **Archivo por materia**: (Curso, stack y contenidos mínimos) + (Tiempo) + (Institución) salen de [Datos particulares] y van a `materias/<materia>.md` (+ `materias/plantilla-materia.md`). La línea "Evaluación: … 2 versiones para cada instancia de evaluación" se elimina (era la fuente de la redundancia; la regla vive en [Evaluaciones — regla fija]).
3. **Fusión de canónicos**: contenido de `estructura-anual-36.md` y `encuentros-especiales.md` pasa AL prompt principal (son cuestiones generales de cualquier materia); `estructura-de-la-clase.md` queda separado (depende del tipo de materia y del alumnado). Los dos archivos absorbidos se eliminan.
4. **Renombre**: carpeta `especiales` → `intensificaciones`, archivos `especiales-*` → `intensificaciones-*` y `evaluacion-especiales-*` → `evaluacion-intensificaciones-*`; `verificar-curso.ps1` actualizado.
5. **Cascada**: propagar ahora al corpus `minimal-api-csharp/` (correlación exacta).

## Cambios en corpus (detalle)

- 03-instancias → `03-encuadre-y-cierres/`: borrar 10 evaluaciones cuatrimestrales; renombrar instancia-01→encuadre-01-diagnostico, instancia-16→cierre-16-cuatrimestre-1, instancia-33→cierre-33-cuatrimestre-2, instancia-36→cierre-36-integral; rework de 16/33 sin examen (apertura y devolución 60 / síntesis 75 / metacognición 75 / cierre 30 = 240).
- 04-especiales → `04-intensificaciones/` con renombre de los 30 archivos (6 momentos + 24 evaluaciones) y referencias internas.
- 01-planificacion: anual md+csv (filas E16/E33 sin evaluación; terminología intensificaciones), libro md+csv (filas 16/33; ≤35 chars; BOM).
- criterios-aprobacion + README: sin evaluaciones cuatrimestrales; links renombrados; orden de creación actualizado.
- Referencias a `estructura-anual-36`/`encuentros-especiales` en 9 archivos del corpus → apuntar al prompt principal.

## Tareas

| # | Tarea | Estado |
|---|---|---|
| 1 | Fusión de canónicos en el prompt + materias/ (2 archivos nuevos) + borrar absorbidos | done (2fe03eb) |
| 2 | verificar-curso.ps1: patrón intensificaciones + comentarios | done (2fe03eb + febd7d9) |
| 3 | Corpus: 03-encuadre-y-cierres (borrado evals + rework 16/33) | done (febd7d9) |
| 4 | Corpus: 04-intensificaciones (renombres + referencias internas) | done (febd7d9) |
| 5 | Corpus: anual + libro (E16/E33 + terminología) | done (0fce817) |
| 6 | Corpus: criterios + README + referencias globales | done (0fce817) |
| 7 | Verificación final (verificar-curso + links + correlación) | done: TODO OK · 6/6 momentos · 0 patrones viejos · 111 archivos |

## Hallazgo del linter sobre verificar-curso.ps1

El diagnóstico pi-lens L26/L27 (`$Curso = ''` en `param()`) es un falso positivo verificado con tres evidencias: diff contra HEAD solo en líneas de comentario, parser oficial de PowerShell con 0 errores y ejecución completa del script. El hallazgo histórico del session cache no se reprodujo con LSP activo (timeout del servidor).
