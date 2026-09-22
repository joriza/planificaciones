# Feature: lso-corrida-completa

## Goal

Ejecutar `prompt-plantilla-planificacion.md` para la materia **LSO** (Minimal API con C# .NET 6) en modo derivado **regeneración completa**: existe `input/materias/LSO/curso-data.json` (firma del docente, se valida sin re-redactar) y `output/LSO/` fue borrado a propósito (el corpus anterior arrastraba 16 errores de lint conocidos). Corrida continua sin frenos (el pedido declara "Frenos: ninguno"; la parada post-Fase 1 no aplica porque el curso-data no se redacta en esta corrida).

## Contexto

- Rama de trabajo: `regen/lso` (procedimiento del README). Bootstrap = commit de los 102 borrados de `output/LSO/` (recuperables en git desde `feature/lap-completo`). La modificación de `z-pdt-planificaciones.md` es del docente: NO se commitea.
- Fase 0: validar `input/materias/LSO/curso-data.json` (20 encuentros, varianteFraseos 1) y reusar `convenciones-tecnicas.md` tal cual (ambos propiedad del docente). Sin duplicado en `output/LSO/` (carpeta vacía).
- Fase 1: render determinista de los 3 CSV con horas default (4 h/encuentro → sin `-HorasPorEncuentro`).
- Fase 2: 7 writers en paralelo, uno por carpeta, con dieta canónica (slice de curso-data + hoja de convenciones leída primero + digest-código si produce código + `input/estructura-de-la-clase.md`), reporte ≤15 líneas. Repartos de tiempos = los declarados por encuentro en el curso-data (suman 240 min). Registro voseo didáctico; escuela técnica → E1 con seguridad e higiene y EPP; celular no permitido.
- Fase 3: 2 writers — evaluaciones de unidad (u1..u4: base + A/B + anexos, `scaffold-evaluacion.ps1` + `generar-version-b.ps1` con `input/plantillas/tabla-dominio.json`) y evaluaciones de los 6 momentos (18 archivos en `04-intensificaciones/evaluaciones/`).
- Fase 4: criterios de aprobación + README (`generar-readme.ps1`, con nota de cátedra) + `.gitignore` del curso + puerta de salida: `verificar-curso.ps1` y `lint-canon.ps1` (horas default 4) en verde, corrigiendo hallazgos.
- Continuidad: 4 documentos (saberes previos + tras evaluaciones u1, u2, u3 — encuentros 9, 15, 26), con anexo docente separado.
- Estructura objetivo del corpus (espejo del corpus anterior, recuperable de git): `01-planificacion` (3 CSV), `02-unidades/01..04` (15 archivos c/u), `03-encuadre-y-cierres` (4), `04-intensificaciones` (6 momentos + evaluaciones/), `05-continuidad` (4+4), `06-aprobacion/criterios-aprobacion.md`, `README.md`, `.gitignore`.
- Memorias de corridas previas aplicables: writers reemplazan el reparto del scaffold por el del slice; lint case-sensitive con "Encuentro N"; los INTEGER de hospital.db exigen long/long?/ExecuteScalar<long> (hoja de convenciones vigente ya lo fija).

## Tasks

- [x] T0: bootstrap — rama `regen/lso`, commit de borrados (`13a922e`), odd doc + espejo Engram.
- [x] T1 (Fase 0): validar curso-data + hoja vigentes (sin re-redactar) — validador EXIT=0: 20 encuentros, slots u1..u4 y ejes 1-6, cierres con tp, celdas ≤35. Sin duplicado en output.
- [x] T2 (Fase 1): render 3 CSV (`cb20b5d`) — anual 16 filas, libros 36/72, BOM UTF-8, LF, variante v1, horas default 4. Sin parada post-Fase 1 (modo regeneración).
- [x] T3 (Fase 2): writers W1..W4 (unidades u1..u4: 5 clases + 5 anexos c/u), W5 (encuadre y cierres: 4 docs), W6 (intensificaciones: 6 momentos), W7 (continuidad: 4 docs + 4 anexos) — ✅ completada y commiteada (`0579415`, 58 archivos); verificación estructural del orquestador: reparto 240×15 clases, agendas 240×4 encuadre/cierres, continuidad 100 pts + 240 min + nota obligatoria.
- [x] T4 (Fase 3): evaluaciones de unidad (20 archivos) y de momentos (30 archivos con anexos) — `537e643`; agendas de 19-20/diciembre/marzo extendidas a 240 reales (`c02edeb`); completamiento por 3 pases de writer + anexo B 02-03 inline.
- [x] T5 (Fase 4): criterios-aprobacion.md (10 instancias, sin placeholders) + README derivado (`generar-readme.ps1`, 114 documentos) + `.gitignore` del curso + `verificar-curso.ps1` TODO OK + `lint-canon.ps1` 0 errores / 4 avisos prosa-estampada (por diseño del scaffold, igual que LAP) — `6c13b8b`.
- [x] T6: cierre — evidencia en este doc, espejo Engram, resumen de sesión.
- [ ] T4 (Fase 3): W8 (evaluaciones de unidad) y W9 (evaluaciones de momentos).
- [ ] T5 (Fase 4): criterios + README + `.gitignore` + `verificar-curso.ps1` y `lint-canon.ps1` en verde (corregir hallazgos).
- [ ] T6: cierre — evidencia en este doc, espejo Engram, resumen de sesión.

## Evidencia

- T0 (2026-09-22): bootstrap `13a922e` en `regen/lso` — 102 archivos borrados (11.697 líneas), recuperables en git. `z-pdt-planificaciones.md` modificado por el docente queda sin commitear.
- T1 (2026-09-22): `validar-curso-data.ps1` EXIT=0. Firma y hoja reusadas tal cual (propiedad del docente).
- T2 (2026-09-22): `generar-administrativos.ps1` EXIT=0 → 3 CSV (17/37/73 líneas con header, BOM OK, LF). Verificación rápida en python.
- T3 (2026-09-22): 7 writers OK. Verificación de integración del orquestador: 15 clases con reparto 240 exacto y cierres «Qué te llevás»/«Lo que viene» correctos; 4 encuadre/cierres con agendas 240; continuidad 8/8 (100 pts + 240 min + nota). **Hallazgo 1 (defecto de herramienta)**: `scaffold-evaluacion.ps1` deja una línea con variables PowerShell sin expandir (`$((...))`, `$nombreAnexo`) en el doc base — los writers la reemplazan por prosa limpia; pendiente de decisión docente (fix del scaffold). **Hallazgo 2 (desvío de writers, en corrección)**: agendas de 19-20 (140/encuentro), diciembre (195) y marzo (140/195) por debajo de los 240 declarados — W-fix los extiende con actividades reales. **Hallazgo 3 (mejora de canon)**: el corpus viejo no tenía anexos docentes en las evaluaciones de momentos; la regeneración los agrega (30 archivos en 04-intensificaciones/evaluaciones/ siguiendo scaffold + generar-version-b).
- T4 (2026-09-22): W8 evaluaciones de unidad (20 archivos, scaffold + generar-version-b con tabla-dominio LSO); W9 evaluaciones de momentos requirió 3 pases de completamiento (los writers reportaron éxito prematuro dos veces; el orquestador verificó en disco cada vez): 30 archivos finales, 0 placeholders; anexo B 02-03 escrito inline (último faltante). W-fix: agendas 19-20/diciembre/marzo extendidas a 240/encuentro con actividades reales.
- T5 (2026-09-22): criterios-aprobacion.md (W10, tabla de 10 instancias, capas de recuperación en orden canon); README derivado con 114 documentos indexados; `.gitignore` restaurado desde git (`13a922e^`). Puerta de salida: `verificar-curso.ps1` TODO OK (BOM, filas, suma 36, celdas ≤35, links, anexos separados, cobertura 20/20+4+6); `lint-canon.ps1`: 2 errores → corregidos (POST 201 Created / DELETE 204 NoContent según convenciones §6) → **0 errores, 4 avisos prosa-estampada por diseño** (blockquote de unidad del scaffold, mismo patrón aceptado en LAP y baseline viejo). Lint final EXIT=0.
- **Hallazgo 4 (defecto de herramienta, no bloqueante)**: `lint-canon.ps1` regla results-http — `rxFinHandler` (`^\s*\}\)\s*;`) no reconoce handlers arrow de una expresión multilínea (`Results.Created(...));`), la ventana del MapPost se extiende y atribuye al POST el Results de otro verbo. Workaround: escribir handlers MapPost/MapDelete en una sola línea (cierre `);` en la misma línea del Map). Candidato a fix de la regex.

## Registro de commits (rama regen/lso)

- `13a922e` bootstrap borrados · `cb20b5d` CSVs + odd doc · `0579415` Fase 2 (58) · `c02edeb` agendas 240 · `537e643` evaluaciones (50) · `6c13b8b` Fase 4 + lint verde. Sin push (decisión del docente).
- Commit final de evidencia: docs(odd) de este archivo.
