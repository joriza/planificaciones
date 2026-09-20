# Planificaciones — biblioteca de plantillas + herramientas deterministas

> Este repositorio es un **meta-proyecto de generación de material docente**: una biblioteca de reglas, un archivo de datos por materia y una suite de herramientas deterministas (`tools/`) que reemplazan autoría LLM por render. La primera implementación completa del sistema es el curso [`minimal-api-csharp/`](minimal-api-csharp/README.md).

---

## Mapa del repositorio

| Ruta | Qué es |
| --- | --- |
| [`0-prompt-plantilla-planificacion.md`](0-prompt-plantilla-planificacion.md) | El encargo madre: canon del flujo (cascada data-first Fase 0-4), estructura fija del ciclo lectivo, reglas de evaluación y frenos humanos. Punto de partida de cualquier corrida. |
| [`estructura-de-la-clase.md`](estructura-de-la-clase.md) | Canon del formato de encuentro (BOPPPS + GRR): depende del tipo de materia y del alumnado. |
| [`materias/`](materias/) | Los datos que cambian con cada curso: `<materia>.md` (ficha), `<materia>.json` (curso-data: la firma pedagógica, 20 encuentros + slots) y `nota-catedra-<materia>.md` (prosa libre). Incluye `plantilla-materia.md` para cursos nuevos. |
| [`plantillas/`](plantillas/) | Lo invariante entre materias: tramos del ciclo con banco de fraseos, esqueletos de composición, tabla de dominio para versiones equivalentes, digest de código y plantilla de README. |
| [`tools/`](tools/) | Las aplicaciones deterministas (PowerShell 5.1, cero dependencias): ver la tabla siguiente. |
| [`minimal-api-csharp/`](minimal-api-csharp/README.md) | Implementación de referencia: corpus completo de 36 encuentros. Sus administrativos son render del curso-data. |
| [`database-docs/`](database-docs/README.md) | Documentación de la base `hospital.db` usada por el curso (esquema, diccionario, scripts). |
| [`odd/`](odd/tasks/) | Evidencia de trabajo por feature (mapas maestros, instrumentación, registro de commits). |
| `z-*.md` | Anotaciones personales del docente, **no vinculantes** (convención `z-`). |

## Herramientas (`tools/`)

Todas corren con Windows PowerShell 5.1 desde la raíz del repositorio.

| Script | Qué hace | Uso |
| --- | --- | --- |
| `validar-curso-data.ps1` | Valida `materias/<materia>.json`: 20 encuentros en rangos de unidad, vocabulario de carácter, cierres con TP, celdas ≤35, slots completos. | `powershell -File tools\validar-curso-data.ps1 -Materia materias\<m>.json` |
| `generar-administrativos.ps1` | Render determinista de los 3 administrativos **solo CSV** (anual + libro de aula de 1 y 2 líneas; UTF-8 con BOM, LF). Idempotente: misma entrada, mismos bytes. | `powershell -File tools\generar-administrativos.ps1 -Materia materias\<m>.json -Salida <curso>\01-planificacion [-Variante N]` |
| `generar-readme.ps1` | README del curso mayormente derivado: índice, links y orden desde el árbol + curso-data; fundamentación por plantilla; nota de cátedra manual si existe. Protege el archivo existente sin `-Force`. | `powershell -File tools\generar-readme.ps1 -Materia materias\<m>.json -Curso <curso> [-Salida <file>] [-Force]` |
| `scaffold-clase.ps1` | Esqueleto BOPPPS+GRR de una clase (y su anexo docente) desde el curso-data: headings canónicos y reparto de tiempos según `estructura` (clase/cierre), sin prosa. | `powershell -File tools\scaffold-clase.ps1 -Materia ... -Encuentro 22 -Salida <dir> [-Force]` |
| `scaffold-evaluacion.ps1` | Esqueletos de evaluación (base + versión A + anexo) para una instancia. | `powershell -File tools\scaffold-evaluacion.ps1 -Materia ... -Instancia u2 -Salida <dir>` |
| `generar-version-b.ps1` | Versiones equivalentes B/C/D por sustitución de dominio (`plantillas/tabla-dominio.json`) + checklist determinista de equivalencia. Falla (exit 2) si la salida sería idéntica a la base. | `powershell -File tools\generar-version-b.ps1 -Base <versión-A.md> -Salida <dir> [-Letras B,C] [-Tabla <json>]` |
| `lint-canon.ps1` | Linter de canon sobre el corpus: tipos en records (`long`/`string`), respuestas HTTP, identificadores en inglés, repartos que suman 240, correlación anual↔libro↔previews y avisos de prosa estampada. | `powershell -File tools\lint-canon.ps1 [-Curso <curso>]` |
| `impacto.ps1` | Análisis de impacto de un cambio de curso-data/canon: tres listas — (a) derivados a re-render (siempre todos, costo cero), (b) prosa afectada (la única que abre el LLM), (c) intocado. | `powershell -File tools\impacto.ps1 -Materia materias\<m>.json [-Desde <commit>] [-Json]` |
| `verificar-curso.ps1` | Suite de integridad del curso: BOM, suma de Tiempo = encuentros, filas N/2N, celdas ≤35, links del README, anexos separados, mojibake, records y cobertura informativa. | `powershell -File tools\verificar-curso.ps1 [-Curso <curso>]` |

## Crear un curso nuevo (modo corrida completa)

1. Crear `materias/<nueva-materia>.md` desde `materias/plantilla-materia.md` y completarla.
2. **Fase 0** (única autoría LLM de la firma pedagógica): redactar `materias/<nueva-materia>.json` — los 20 encuentros de unidad + slots — según `0-prompt-plantilla-planificacion.md`. **FRENO: el docente valida y edita**; desde ahí el JSON es del docente (versionado en git).
3. Validar: `tools\validar-curso-data.ps1`.
4. **Fase 1** (cero LLM): render de administrativos con `tools\generar-administrativos.ps1`; opcionalmente el README derivado con `tools\generar-readme.ps1`.
5. **Fases 2-3** (prosa viva): writers por carpeta — cada uno recibe solo el slice de sus encuentros, `plantillas/digest-codigo.md` si escribe código, y `estructura-de-la-clase.md`. Evaluaciones con scaffolds + consigna maestra + versiones equivalentes.
6. **Fase 4**: `tools\verificar-curso.ps1` y `tools\lint-canon.ps1` en verde.

## Actualizar un corpus existente (modo actualización)

1. Editar `materias/<materia>.json` (o el canon/plantillas) y validar.
2. `tools\impacto.ps1` → plan de regeneración en tres listas (registrar el plan en el odd doc).
3. Re-render de derivados: siempre todos (idempotentes, costo cero).
4. El LLM toca **solo** la lista (b) de prosa afectada.

## Convenciones operativas

- Administrativos **solo CSV** (UTF-8 con BOM, separador `;`); no se corrigen a mano: el cambio se hace en el curso-data y se re-renderiza.
- `verificar-curso.ps1` y `lint-canon.ps1` son la puerta de salida de toda corrida; la baseline vigente de `minimal-api-csharp` está documentada en `odd/tasks/optimizacion-tiempo-tokens.md`.
- Las evaluaciones usan versiones equivalentes (A/B/C/D; mínimo dos según los grupos); la equivalencia se genera por reglas y se verifica con checklist determinista + pasada de lectura natural del docente.
