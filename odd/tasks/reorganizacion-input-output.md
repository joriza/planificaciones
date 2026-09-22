# Feature: reorganización input/output del repositorio

Decisiones confirmadas por el usuario (2026-09-21):
1. **Partición input/output**: todo lo que alimenta al corpus vive en `input/` y subcarpetas; todo lo generado vive en `output/` y subcarpetas. Criterio fino: `input/` = lo que duele perder (authored), `output/` = 100% regenerable/desechable.
2. **curso-data.json y convenciones-tecnicas.md** vuelven al lado input: `input/materias/<m>/` concentra TODO lo authored (ficha, pedido, nota-cátedra, firma, convenciones). Se descarta el refactor pendiente curso-data→output/ (8 archivos sin commitear, subsumidos acá).
3. **estructura-de-la-clase.md** → `input/estructura-de-la-clase.md` (alimenta al corpus; la raíz queda en 3 archivos).
4. **Rename del prompt madre**: `0-prompt-plantilla-planificacion.md` → `prompt-plantilla-planificacion.md`.
5. **tools/, docs/, odd/ quedan como carpetas en la raíz** (infraestructura / notas z-* / evidencia de proceso). `docs/z-*.md` y `odd/tasks/*.md` NO se tocan (evidencia histórica).
6. **Raíz final**: `prompt-plantilla-planificacion.md`, `README.md`, `z-pdt-planificaciones.md` + carpetas `input/ output/ tools/ docs/ odd/`.

## Estructura objetivo

```
input/
├── estructura-de-la-clase.md
├── materias/{LAP,LSO}/  → materia.md, pedido.md, nota-catedra.md [+ curso-data.json, convenciones-tecnicas.md en LSO]
├── plantillas/  (10 archivos)
└── database-docs/ (+ Scripts/)
output/
└── LSO/  (corpus derivado puro: 01-06 + README)
```

## Bugs residuales corregidos en la misma pasada

1. `tools/generar-readme.ps1:197` — `rutaData = 'materias/<m>.json'`: ruta pre-carpeta-materia inexistente; el README generado de LSO apuntaba a un archivo que no existe → `input/materias/<m>/curso-data.json`.
2. `plantillas/plantilla-convenciones-tecnicas.md:4` — `materias/<materia>.md` (pre-carpeta-materia) → `input/materias/<materia>/materia.md`.
3. `plantillas/readme-descripciones.json` — 2 refs `materias/<materia>.json` stale → `input/materias/{{materia}}/curso-data.json`.

## Tareas

| # | Tarea | Estado |
|---|---|---|
| T0 | Descartar refactor pendiente (git checkout -- .) | done |
| T1 | Moves con git mv (rename prompt + 4 carpetas → input/ + traer curso-data y convenciones de LSO) | done: 31 renames |
| T2 | Retarget de referencias (~15 archivos / ~70 refs: prompt, README, 9 tools, plantillas, fichas, z-pdt + 3 bugs) | done: 104 refs / 17 archivos (writer) + 2 fixes de generador (parent): slot {{materia}} y rutaData derivados del identificador de carpeta; link a convenciones vía {{linkConvenciones}} + indexación relativa |
| T3 | Verificación: validar-curso-data + generar-administrativos (idempotencia) + generar-readme -Force + verificar-curso + lint-canon + grep de huérfanas | done: validar OK · CSVs byte-idénticos · verificar-curso TODO OK (102 docs, links OK) · grep huérfanas 0 (solo z-pdt:156 histórico, no vinculante) · lint-canon 16E/2A PRE-EXISTENTES del corpus (no regresión) |
| T4 | Commit atómico `refactor(structure): split input/output layout, rename master prompt` | done |

## Pendientes de follow-up (fuera de estos commits)

1. **lint-canon 16 errores / 2 avisos** en corpus LSO (pre-existentes, verificados sin regresión): repartos que suman 0 min en clases de u1/u2/u4 + 1 registro-tipos `int patient_id` en continuidad-02. → El docente los corrige manualmente (documentos pedagógicos, fuera de alcance del agente por pedido explícito).
2. **Observación de identidad**: `input/materias/LSO/curso-data.json` declara materia="Minimal API con C# .NET 6" (denominación display) con carpeta LSO — el corpus de output/LSO es el curso Minimal API. Decisión de contenido del docente, no de esta reestructura.

## Follow-up ejecutado: consistencia direccional (commit 78d051b, review approved + ack quemado)

Residuos de la era 6bf7868 ("curso-data en output/") que el grep de rutas viejas no podía ver por ser dirección equivocada, no ruta inexistente:
- 21 ediciones en 7 archivos (worker): texto de uso de 5 tools (ejemplos `-Materia output\LSO`, descripciones y errores "carpeta del curso en output"), prompt L8 (output/ = corpus derivado; firma y hoja en input), README L16/L79/L80 (fila output/, contradicción limpieza-vs-hoja resuelta: la hoja es del docente y NO se borra en la limpieza), fila input/materias/ completa.
- 1 edición parent: prompt L105 (`impacto.ps1 -Materia output/<materia>` → input) que el inventario inicial omitió y el worker señaló fuera de alcance.
- Verificación 8/8 PASS: grep direccional 0; smoke tests a temp de impacto (plan 3 listas OK), scaffold-clase (2 archivos), scaffold-evaluacion (3 archivos), generar-version-b (checklist 3 PASS + 1 SUSPECT benigno); corpus output/ intacto (git status limpio).
- RDD: linaje review-bf55adcfb9adcf6d, tier medium, lens review-reliability, APPROVED, ack quemado.

Regla de commiteo: T1+T2+T3 van en UN commit (el move sin referencias rompe todo: no hay estado intermedio funcional).
