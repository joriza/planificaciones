# Feature: parada-post-fase1-y-duplicado-curso-data

## Goal

Incorporar al canon dos cambios decididos por el docente: (1) una parada adicional post-Fase 1 (administrativos renderizados, antes de la prosa viva) aplicable SOLO a materia nueva cuyo curso-data fue redactado en la misma ejecución; (2) regla de precedencia para curso-data.json duplicado entre `input/materias/<m>/` y `output/<m>/`: vale siempre el de input, con aviso no bloqueante y sin borrado automático. Incluye formalizar el contenido obligatorio del reporte de freno (estilo aprobado por el docente en la corrida LAP).

## Contexto

- Decisión del docente (2026-09-21, consulta con 3 respuestas): parada «Post-Fase 1 (Recomendada)», duplicado «Aviso sin borrar (Recomendada)», alcance «Plan + aplicar (Recomendada)».
- Origen del duplicado: historial del repo (+det31 pidió curso-data en output; la reorganización posterior lo movió a input — commits 6bf7868/78d051b); pueden quedar restos involuntarios en output.
- Menores resueltos por el orquestador, **APROBADOS por el docente (2026-09-21: «si están aplicadas está bien. Comparto tu criterio.»)**:
  - La parada post-Fase 1 NO aplica a regeneración completa ni actualización (la firma ya fue revisada por el docente en corridas previas).
  - El aviso del validador es WARN: no cambia el exit code.
  - El contenido de reporte de freno formalizado aplica a TODAS las paradas (Fase 0, post-Fase 1 y frenos declarados en pedidos).
  - Nunca se borra automáticamente el duplicado.
  - Sub-agentes: sin cambio de canon (ya es obligatorio en [Indicaciones finales]); queda como práctica de ejecución reforzada.
  - El README raíz se actualiza como parte de la aplicación (práctica del repo, +det30).

## Tasks

- [x] T1: Canon — 4 ediciones en `prompt-plantilla-planificacion.md` (parada de administrativos tras Fase 1, reporte de freno como regla fija, segunda parada en modo materia nueva, regla de duplicado en [Datos particulares]). — worker, verificado con diff propio: textos exactos, sin reformulaciones.
- [x] T2: `tools/validar-curso-data.ps1` — bloque de aviso de duplicado tras la carga del JSON. — worker falló al reportar pero el bloque quedó aplicado y el cleanup hecho; verificación completada por el orquestador: sin duplicado → OK limpio exit 0; con duplicado fake en `output/LAP/` → AVISO + OK exit 0; cleanup confirmado (output/ solo LSO).
- [x] T3: `README.md` — 5 ediciones (E5-E9): fila del validador, tabla de modos, reglas transversales, paso 4 de curso nuevo, bullet de convenciones. — worker, verificado con diff propio.
- [x] T4: Verificación completa: greps de coherencia en verde (worker + propios), tabla de modos con 3 filas válidas, corrida del validador en ambos escenarios. Cerrado sin freno adicional: la corrida fue de canon, no de curso.

## Evidencia

- (2026-09-21) T1-T3 aplicados por writers en paralelo (superficies disjuntas); diffs verificados por el orquestador: 20 inserciones / 6 borrados en 3 archivos, textos exactos sin reformulación.
- (2026-09-21) T4: `validar-curso-data.ps1 -Materia input/materias/LAP` → OK exit 0 sin aviso; con fake `output/LAP/curso-data.json` → «AVISO: curso-data duplicado en output\LAP\curso-data.json (vale el de input; considere eliminar el duplicado).» + OK exit 0; cleanup verificado.
- Incidente: worker del validador (task mubx3uar-5-t6mw) falló sin reporte final tras aplicar el cambio y limpiar; verificación restante completada inline por el orquestador.
- Work-unit commit (2026-09-21): `c7c2001` — `feat(canon): add post-Fase-1 stop and duplicated curso-data rule` en `regen/minimal-api-csharp` (4 archivos, +50/−6), autorizado por el docente. Notas del docente registradas aparte en `29c5804`.
