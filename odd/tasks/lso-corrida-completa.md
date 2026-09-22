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

- [ ] T0: bootstrap — rama `regen/lso`, commit de borrados, odd doc + espejo Engram.
- [ ] T1 (Fase 0): validar curso-data + hoja vigentes (sin re-redactar).
- [ ] T2 (Fase 1): render 3 CSV (`generar-administrativos.ps1`) + verificación de filas y BOM.
- [ ] T3 (Fase 2): writers W1..W4 (unidades u1..u4: 5 clases + 5 anexos c/u), W5 (encuadre y cierres: 4 docs), W6 (intensificaciones: 6 momentos), W7 (continuidad: 4 docs + 4 anexos).
- [ ] T4 (Fase 3): W8 (evaluaciones de unidad) y W9 (evaluaciones de momentos).
- [ ] T5 (Fase 4): criterios + README + `.gitignore` + `verificar-curso.ps1` y `lint-canon.ps1` en verde (corregir hallazgos).
- [ ] T6: cierre — evidencia en este doc, espejo Engram, resumen de sesión.

## Evidencia

- (pendiente)
