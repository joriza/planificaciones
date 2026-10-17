# Feature: higiene de herramientas e historial (puntos 1-5 del análisis de optimización)

Deuda de mantenimiento detectada en el análisis de optimización (2026-10): helpers duplicados en `tools/`,
dos scaffolds coexistiendo, PDF personal versionado, branches fusionadas sin podar, baseline del linter
desactualizada en la doc y falta de un runner del pipeline. Higiene pura: ningún cambio de comportamiento
en los renders (verificación byte a byte contra baseline capturada antes de tocar nada).

## Specs

- **S1** — Punto 1: helpers duplicados en un solo módulo `tools/_comun.psm1`; los 6 helpers duplicados
  (`Write-Csv`, `Convert-Slug`, `Test-EsCurso`, `Read-Texto`, `Get-LineaCsv`, `Get-DenominacionUnidad`)
  viven en un único lugar y los scripts importan el módulo. Los renders deben quedar byte-idénticos.
- **S2** — Punto 2: un solo scaffold canónico. `scaffold-clase-mejorado.ps1` está corrupto (mojibake que
  rompe el parseo, nunca ejecutó) y hardcodea LSO/LAP; el canónico es `scaffold-clase.ps1` (funciona,
  general). Se elimina el corrupto y el README queda al día.
- **S3** — Punto 3: `z-evaluacion-u1-resiliente-LPR.pdf` deja de versionarse (gitignore `z-*.pdf`,
  `git rm --cached`, el archivo queda en disco); branches locales ya fusionadas a `main` podadas con `-d`;
  política de historial de regeneraciones documentada en el README. Ramas remotas: solo decisión del docente.
- **S4** — Punto 4: baseline del linter registrada con los flags correctos por materia
  (LPR: `-HorasPorEncuentro 2` → 0 errores / 9 avisos; LSO: default 4 → 0 errores / 4 avisos);
  deuda desactualizada del plan (§5.4) corregida. No se agrega mecanismo de supresión: hoy no hay ningún
  ERROR vigente que lo necesite (evitar maquinaria muerta).
- **S5** — Punto 5: `tools/generar-curso.ps1` encadena validar → administrativos → readme → verificar →
  lint con corte al primer fallo y propagación de exit code; `-HorasPorEncuentro` pasado a render y lint;
  fila nueva en el README.

## Tasks

| ID | Specs | Ruta | Commit |
| --- | --- | --- | --- |
| T1 | S1 | inline | `dd7143b` |
| T2 | S2 | inline | `476d835` |
| T3 | S3 | inline | `f29ac21` |
| T4 | S4 | inline | `350efdb` |
| T5 | S5 | inline | `0a0d5f2` |
| T6 | S1-S5 | inline | (verificación final: renders byte-idénticos vs baseline + puerta verde ambos cursos) |

Baseline de verificación: renders pre-cambio capturados en temp (validar/lint/verificar stdout+exit de
LPR y LSO; renders de administrativos, readme, cierre y scaffold LPR). Comparación por `cmp` después
de T1/T2/T5. La unificación consciente de `Get-DenominacionUnidad` (recibe `$data` por parámetro y
falla en alto si la unidad falta) no altera salida alguna con curso-data válido; queda documentada.

## Log

- L1 (pedido original, verbatim): "analiza el proyecto y evalua como se puede optimizar."
- L2 (aprobación, verbatim): "ok. realice las tareas de higiene de los puntos 1 a 5"
- L3 (hallazgos del análisis que ajustan alcance): `scaffold-clase-mejorado.ps1` corrupto (nunca ejecutó;
  parse error por mojibake) → S2 consolida en el script que funciona. `lint-canon` LPR ya está en verde
  con `-HorasPorEncuentro 2` (los "24 errores" iniciales eran del flag default 4 h) → S4 es solo doc,
  sin mecanismo de supresión. `curso-data.json` ya trae `slots.horasPorEncuentro` (LPR=2): mejora futura
  candidate — que las herramientas lo deriven solas — registrada, no implementada (cambio de contrato).
- L4 (evidencia de ejecución): T1 `dd7143b` (renders byte-idénticos: 10 archivos + 6 validadores
  stdout+exit contra baseline pre-cambio), T2 `476d835`, T3 `f29ac21` (PDF 591784 bytes queda en disco
  sin versionar; 6 branches fusionadas podadas con `-d`; borado remoto pendiente de decisión del
  docente). Baseline linter vigente: LPR 0E/9A con `-HorasPorEncuentro 2`, LSO 0E/4A default.
- L5 (frontera de slice): el contador de la plataforma reporta ~15.9k líneas en 5 commits desde
  `origin/main`, porque la rama feature nace de `regen/lpr` que arrastra los commits NO fusionados de
  la regeneración del corpus LPR. Líneas autoría de esta feature: T1 173 (111+/62-), T2/T3 menores.
  La entrega de esta feature es independiente del merge de `regen/lpr`.
- L6 (verificación T5/T6): `generar-curso.ps1` smoke-tested en copias del repo (no toca el corpus
  real): happy path 5/5 exit 0 con puerta verde LPR (0E/9A con `-HorasPorEncuentro 2`); materia
  inexistente corta en [1] con exit 1; sin `-Force` sobre corpus existente corta en [3] por README
  protegido (comportamiento canónico). El runner no duplica lógica: llama a los scripts existentes.
  Gotcha corregida en el camino: splatting de hashtable (el array pasaba los tokens como posicionales
  y rompía el binding de `-Materia`). Verificación final T1-T4 intacta: renders reales sin drift
  (`git status --short output/` vacío).
