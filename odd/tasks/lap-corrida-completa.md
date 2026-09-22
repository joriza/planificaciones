# Feature: lap-corrida-completa

## Goal

Ejecutar `prompt-plantilla-planificacion.md` para la materia LAP en modo **regeneración completa** (el curso-data validado existe en `input/materias/LAP/` y `output/LAP/` no existía): render de todo el corpus derivado, corrida continua sin frenos (el pedido declara "Frenos: ninguno"; la parada post-Fase 1 no aplica porque el curso-data no se redacta en esta corrida).

## Contexto

- La Fase 0 original (cancelada tras el freno) dejó curso-data.json, convenciones-tecnicas.md y digest-codigo.md ya commiteados (`440c1ff`): se reusan tal cual tras validación.
- Fase 1 renderizada en esta corrida: `output/LAP/01-planificacion/` (anual 16 filas + libros 36/72, `-HorasPorEncuentro 2`).
- Nueva en esta corrida: `input/materias/LAP/tabla-dominio.json` (dominios kiosco/biblioteca, club/taller, pizzería/veterinaria, verdulería/videoteca) para `generar-version-b.ps1` — mecanismo materia-local, no toca la tabla compartida de LSO.
- Deuda conocida de la firma (reportada en el freno anterior, sin decisión del docente): la escala `-HorasPorEncuentro 2` infla +5 min las cajas impares de tramos invariantes (secuencias escaladas suman 125 ≠ 120 en encuadre, previos, cierres c1/c2 y secuencia fija de unidades). Pendiente de decisión; no bloquea esta corrida.
- Los documentos de momento y evaluaciones de momentos reusan los dominios u1..u4 de la tabla (sin tokens propios).

## Tasks

- [x] F0: validar curso-data (OK, reutilizado) + render Fase 1 (`-HorasPorEncuentro 2`).
- [ ] F2: prosa viva en paralelo por carpeta — W1..W4 (unidades u1..u4: 5 clases + 5 anexos c/u), W5 (encuadre y cierres: 4 docs), W6 (intensificaciones: 6 momentos), W7 (continuidad: 4 docs + 4 anexos). Reparto de tiempos 120 min exacto por encuentro (clase 10/20/35/25/20/10; cierre 10/40/45/15/10); scaffold-clase para estructura + ajuste de tabla.
- [ ] F3: evaluaciones — W8 (4 evaluaciones de unidad: base + versiones A/B + anexos, con tabla-dominio LAP y generar-version-b), W9 (6 evaluaciones de momentos: base + A/B).
- [ ] F4: criterios de aprobación + README (`generar-readme.ps1`) + `verificar-curso.ps1 -Curso output/LAP` y `lint-canon.ps1 -Curso output/LAP -HorasPorEncuentro 2` en verde (corregir hallazgos).

## Evidencia

- F2 (2026-09-21): 7 writers en paralelo — 20 clases + 20 anexos (4 unidades), 4 encuadre/cierres, 6 momentos, 4 continuidades + 4 anexos. Verificaciones internas de cada writer: py_compile de fences, tablas de tiempos = 120, cierre "Qué te llevás" + preview del Encuentro N+1, sin persistencia. W5 detectó y corrigió un error de suma del encargo (encuadre 130→120).
- F3 (2026-09-21): W8 (4 evaluaciones de unidad: base + A + anexos A/B, generador exit 0) y W9 (18 archivos de momentos, generador exit 0 en las 6). W9 corrigió en la tabla de dominio el token A duplicado "productos" (u1→articulos) — defecto de diseño de la tabla original.
- Fix de integración (2026-09-21): la A de u1 y 17-18 aún usaban "productos" (mapeaba a películas de u4) → B incoherentes. Corregido: A u1 5× y A 17-18 6× "productos"→"articulos", B regeneradas (exit 0, PASS), ejemplo de regla de la tabla actualizado. Residual para pasada fina del docente: `kiosco_club.py`→`biblioteca_taller.py` en B 17-18 (limitación whole-word del generador).
- F4 (2026-09-21): criterios-aprobacion.md (W10 + mini-fix: faltaba la instancia 02-03; ahora 4 unidades + 6 momentos = 10 instancias); `generar-readme.ps1` → README con 146 documentos; `verificar-curso.ps1 -Curso output/LAP` → TODO OK (BOM, filas, suma 36, celdas ≤35, links, anexos separados, cobertura 20/20+4/4+6/6); `lint-canon.ps1 -Curso output/LAP -HorasPorEncuentro 2` → 0 errores. Pulido de previews u2/u3 y slug B 17-18: avisos preview-libro 7→0.
- Avisos finales del lint (4, no bloquean): prosa-estampada por la línea de cita de unidad que genera el scaffold compartido (mismo patrón que el corpus LSO).
- Pendientes del docente: pasada fina de prosa natural en las versiones B (diseño del generador), commit/push de la corrida, decisión sobre escala +5 min, pedido +det35 (plan de conversión a PDF) anotado en z-pdt.
