# Feature: autodetect horasPorEncuentro desde curso-data

El docente autoriza en el historial de higiene (L1/L2) derivar `slots.horasPorEncuentro` automáticamente cuando no está explícito en el JSON. Meta: que `tools/generar-curso.ps1` no pida `-HorasPorEncuentro` manualmente; que el flag siga existiendo como override para materias excepcionales.

## Specs

- **S1** — `curso-data.json` se completa en ambos cursos: LPR ya tiene `slots.horasPorEncuentro: 2`; LSO se le agrega `slots.horasPorEncuentro: 4` (suma de tiempos = 240 min → factor 1.0 → render byte-idéntico). Commit separado, sin tocar scripts.
- **S2** — `tools/_comun.psm1` recibe una función nueva `Get-HorasPorEncuentro($materia)` que devuelve el valor de `slots.horasPorEncuentro` cuando existe; si falta, deriva sumando `tiempos[].min` del primer encuentro (todos los encuentros de una materia tienen el mismo total). Exporta la función.
- **S3** — `tools/generar-curso.ps1`: quita el parámetro `-HorasPorEncuentro` de la signatura (se mantiene por compatibilidad como override): cuando no viene explícito, lee de la materia; si el usuario lo pasa, ese valor gana. Actualiza el README.
- **S4** — Verificación: baseline byte-idéntica de administrativos y lint de ambos cursos; linter sigue en verde.

## Tasks

| ID | Specs | Ruta | Commit |
| --- | --- | --- | --- |
| T1 | S1 | inline | `07a36d5` |
| T2 | S2 | inline | `9e59ed1` |
| T3 | S3 | inline | `4b87570` |
| T4 | S1-S3 | inline | `b6ddb3b` |

Baseline de verificación: capturar antes de T1: renders administrativos LPR/LSO + lint LPR/LSO con el flag actual (`-HorasPorEncuentro 2` para LPR, default 4 para LSO). Después de T1/T2/T3 re-renderizar los mismos y comparar con `cmp`. La puerta de salida de cada materia debe permanecer en verde (0 errores).

## Log

- L1 (pedido original): "analiza el proyecto y evalua como se puede optimizar."
- L2 (autorización): "ok. realice las tareas de higiene de los puntos 1 a 5"
- L3 (post-higiene, autorización explicita del docente para deriva de horas): ver historial.
- L4 (evidencia): suma de `tiempos[].min` constante por materia: LPR 120 min (2h), LSO 240 min (4h). Agregar el campo es seguro porque el factor de escala es 1.0 para LSO.
- L5 (gotcha corregida): splatting de hashtable — usar array pasaba los tokens como posicionales y rompía el binding de `-Materia`. Solución: hashtable con `@{}` y `@argumentos`.
- L6 (verificación T4): admin CSVs byte-idénticos contra HEAD para ambos cursos (LPR y LSO) al regenerar sin flag; puerta verde: LPR 0E/9A, LSO 0E/4A. Diff contenido vacío, warnings LF→CRLF son normalización git preexistente.
