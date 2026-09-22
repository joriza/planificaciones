# Planificaciones — biblioteca de plantillas + herramientas deterministas

> Este repositorio es un **meta-proyecto de generación de material docente**: una biblioteca de reglas, un archivo de datos por materia y una suite de herramientas deterministas (`tools/`) que reemplazan autoría LLM por render. La primera implementación completa del sistema es el curso [`output/LSO/`](output/LSO/README.md).

---

## Mapa del repositorio

| Ruta | Qué es |
| --- | --- |
| [`prompt-plantilla-planificacion.md`](prompt-plantilla-planificacion.md) | El encargo madre: canon del flujo (cascada data-first Fase 0-4), estructura fija del ciclo lectivo, reglas de evaluación y frenos humanos. Punto de partida de cualquier corrida. |
| [`input/estructura-de-la-clase.md`](input/estructura-de-la-clase.md) | Canon del formato de encuentro (BOPPPS + GRR): depende del tipo de materia y del alumnado. |
| [`input/materias/`](input/materias/) | Una subcarpeta por materia (nombre a elección del docente = identificador): `<nombre>/materia.md` (ficha), `<nombre>/nota-catedra.md` (prosa libre, opcional), `<nombre>/curso-data.json` (firma pedagógica), `<nombre>/convenciones-tecnicas.md` (hoja de convenciones, solo materias con código) y `<nombre>/pedido.md` (datos particulares: libro, continuidad, memoria, frenos). |
| [`input/plantillas/`](input/plantillas/) | Lo invariante entre materias: tramos del ciclo con banco de fraseos, esqueletos de composición, tabla de dominio para versiones equivalentes, digest de código y plantilla de README. |
| [`tools/`](tools/) | Las aplicaciones deterministas (PowerShell 5.1, cero dependencias): ver la tabla siguiente. |
| [`output/`](output/) | Una subcarpeta por curso (declarada en [Datos particulares] del prompt). Contiene el corpus derivado de la materia: CSV administrativos, clases y evaluaciones, y el README índice — 100% regenerable. La firma (`curso-data.json`) y la hoja de convenciones viven en `input/materias/<m>/`. |
| [`input/database-docs/`](input/database-docs/README.md) | Documentación de la base `hospital.db` usada por el curso (esquema, diccionario, scripts). |
| [`odd/`](odd/tasks/) | Evidencia de trabajo por feature (mapas maestros, instrumentación, registro de commits). |
| `z-*.md` | Anotaciones personales del docente, **no vinculantes** (convención `z-`). |

## Herramientas (`tools/`)

Todas corren con Windows PowerShell 5.1 desde la raíz del repositorio.

| Script | Qué hace | Uso |
| --- | --- | --- |
| `validar-curso-data.ps1` | Valida `input/materias/<m>/curso-data.json` (carpeta del curso): 20 encuentros en rangos de unidad, vocabulario de carácter, cierres con TP, celdas ≤35, slots completos; avisa (sin bloquear) si detecta un `curso-data.json` duplicado en `output/<m>/` (vale el de input). | `powershell -File tools\validar-curso-data.ps1 -Materia input\materias\<m>` |
| `generar-administrativos.ps1` | Render determinista de los 3 administrativos **solo CSV** (anual + libro de aula de 1 y 2 líneas; UTF-8 con BOM, LF). Idempotente: misma entrada, mismos bytes; con `-HorasPorEncuentro <h>` escala minutos de tramos a horas de la materia (default 4). | `powershell -File tools\generar-administrativos.ps1 -Materia input\materias\<m> -Salida <curso>\01-planificacion [-Variante N] [-HorasPorEncuentro <h>]` |
| `generar-readme.ps1` | README del curso mayormente derivado: índice, links y orden desde el árbol + curso-data; fundamentación por plantilla; nota de cátedra manual si existe. Protege el archivo existente sin `-Force`. | `powershell -File tools\generar-readme.ps1 -Materia input\materias\<m> -Curso output\<curso> [-Salida <file>] [-Force]` |
| `scaffold-clase.ps1` | Esqueleto BOPPPS+GRR de una clase (y su anexo docente) desde el curso-data: headings canónicos y reparto de tiempos según `estructura` (clase/cierre), sin prosa. | `powershell -File tools\scaffold-clase.ps1 -Materia input\materias\<m> -Encuentro 22 -Salida <dir> [-Force]` |
| `scaffold-evaluacion.ps1` | Esqueletos de evaluación (base + versión A + anexo) para una instancia. | `powershell -File tools\scaffold-evaluacion.ps1 -Materia input\materias\<m> -Instancia u2 -Salida <dir>` |
| `generar-version-b.ps1` | Versiones equivalentes B/C/D por sustitución de dominio (`input/plantillas/tabla-dominio.json`) + checklist determinista de equivalencia. Falla (exit 2) si la salida sería idéntica a la base. | `powershell -File tools\generar-version-b.ps1 -Base <versión-A.md> -Salida <dir> [-Letras B,C] [-Tabla <json>]` |
| `lint-canon.ps1` | Linter de canon sobre el corpus: tipos en records (`long`/`string`), respuestas HTTP, identificadores en inglés, repartos que suman 240, correlación anual↔libro↔previews y avisos de prosa estampada. | `powershell -File tools\lint-canon.ps1 [-Curso <curso>]` |
| `impacto.ps1` | Análisis de impacto de un cambio de curso-data/canon: tres listas — (a) derivados a re-render (siempre todos, costo cero), (b) prosa afectada (la única que abre el LLM), (c) intocado. | `powershell -File tools\impacto.ps1 -Materia input\materias\<m> [-Desde <commit>] [-Json]` |
| `verificar-curso.ps1` | Suite de integridad del curso: BOM, suma de Tiempo = encuentros, filas N/2N, celdas ≤35, links del README, anexos separados, mojibake, records y cobertura informativa. | `powershell -File tools\verificar-curso.ps1 [-Curso <curso>]` |
| `convertir-a-pdf.ps1` | Convierte los .md de una materia a PDF (acción manual del docente, no parte del flujo). Usa pandoc + wkhtmltopdf. Soporta `-Combinado` (un PDF por unidad/carpeta), `-SoloAnexos` (un PDF `<carpeta>-anexo-docente.pdf` por carpeta con anexos docente, sin mezclarlos con el material de estudiantes), `-Unidad N`, y `-Css` para plantilla propia (por defecto usa `input/plantillas/print.css`; márgenes simétricos 15mm). El flag `-Force` sobrescribe PDFs existentes; sin `-Force` los omite. Los PDFs se generan en `output/<m>/pdf/`. | `powershell -File tools\\convertir-a-pdf.ps1 -Materia LPR -Combinado [-Force]` · `powershell -File tools\\convertir-a-pdf.ps1 -Materia LPR -SoloAnexos [-Force]` |

## Orden de creación y fases del flujo

Toda corrida genera el corpus en **cinco fases consecutivas** (cascada data-first: cada fase consume lo producido por la anterior). El orden de creación de los documentos es exactamente este:

| # | Documento | Fase | Cómo se crea |
|---|---|---|---|
| 1 | `input/materias/<X>/materia.md` (ficha: stack, contenidos, tiempos, institución) | previo al flujo | Docente, desde `input/plantillas/plantilla-materia.md` |
| 2 | `input/materias/<X>/pedido.md` (libro, continuidad, memoria, frenos) | previo al flujo | Docente, desde `input/plantillas/plantilla-pedido.md` |
| 3 | `input/materias/<X>/curso-data.json` (firma pedagógica: 20 encuentros + slots) | **Fase 0** | Única autoría LLM de la firma; validador en verde y propiedad del docente; si existe vigente, solo se valida y reutiliza |
| 4 | `input/materias/<X>/convenciones-tecnicas.md` (solo materias con código) | **Fase 0** | LLM con **spike de verificación** (compilar y ejecutar casos límite contra la fuente de datos real) |
| 5 | `output/<X>/01-planificacion/` — 3 CSV (anual + libro 1 y 2 líneas) | **Fase 1** | Render determinista, cero LLM (`generar-administrativos.ps1`) |
| 6 | `output/<X>/02-unidades/` — clases y anexos de las 4 unidades (E4-8, 10-14, 21-25, 27-31) | **Fase 2** | Writers LLM por carpeta (solo su slice de curso-data + hoja + estructura de la clase) |
| 7 | `output/<X>/03-encuadre-y-cierres/` (E1, 16, 33, 36) | **Fase 2** | Writers LLM por carpeta |
| 8 | `output/<X>/04-intensificaciones/` — 6 momentos (2-3, 17-20, 34-35, diciembre, marzo) | **Fase 2** | Writers LLM por carpeta |
| 9 | `output/<X>/05-continuidad/` — 4 documentos + anexos | **Fase 2** | Writers LLM por carpeta |
| 10 | Evaluaciones: una por unidad (encuentros 9, 15, 26, 32) y una por momento, en versiones equivalentes A/B | **Fase 3** | Writers LLM (consigna maestra + versiones + anexos) |
| 11 | `output/<X>/06-aprobacion/criterios-aprobacion.md` + README índice | **Fase 4** | LLM (criterios) + `generar-readme.ps1` (README derivado) |
| 12 | Puerta de salida | **Fase 4** | `verificar-curso.ps1` y `lint-canon.ps1` en verde |

Reglas transversales de la cascada: la Fase 0 es la única con autoría LLM de la firma (el curso-data queda propiedad del docente); la Fase 1 es determinista (cero LLM); los writers de las Fases 2-3 reciben solo su slice de curso-data, la hoja de convenciones (que es canon) y la estructura de la clase; los cambios posteriores entran por el modo **actualización** (nunca editando derivados). En materia nueva cuyo curso-data se redactó en la misma corrida, la cascada frena además al cerrar la Fase 1: el docente revisa la anual y los libros contra la plantilla institucional antes de derivar la prosa; los ajustes entran por el curso-data y se re-renderizan los administrativos.

## Modo de ejecución (derivado del estado del repositorio)

| Estado detectado | Modo | Freno por defecto |
| --- | --- | --- |
| Sin `input/materias/<m>/curso-data.json` | Materia nueva (Fase 0 desde cero) | Pausa tras el curso-data validado + parada post-Fase 1 (administrativos) |
| Con curso-data, sin `output/<m>/` | Regeneración completa (reusa firma y hoja) | Continua |
| Con curso-data y `output/<m>/` vigente | Actualización (solo lo afectado) | Continua |

Una declaración explícita en la orden pisa el modo derivado y los frenos por defecto.

## Crear un curso nuevo (modo corrida completa)

1. Crear `input/materias/<nombre>/materia.md` desde `input/plantillas/plantilla-materia.md`, y `input/materias/<nombre>/pedido.md` desde `input/plantillas/plantilla-pedido.md`, y completarlos. El nombre de la carpeta es el identificador de la materia.
2. **Fase 0** (única autoría LLM de la firma pedagógica): redactar `input/materias/<nombre>/curso-data.json` — los 20 encuentros de unidad + slots — según `prompt-plantilla-planificacion.md`. El JSON queda bajo propiedad del docente (versionado en git; no se re-redacta en corridas siguientes). Para materias con código, redactar también la hoja de convenciones técnicas del curso desde `input/plantillas/plantilla-convenciones-tecnicas.md`, con spike de verificación (misma regla de propiedad).
3. Validar: `tools\validar-curso-data.ps1 -Materia input\materias\<nombre>`.
4. **Fase 1** (cero LLM): render de administrativos con `tools\generar-administrativos.ps1 -Materia input\materias\<nombre> -Salida output\<nombre>\01-planificacion`; opcionalmente el README derivado con `tools\generar-readme.ps1 -Materia input\materias\<nombre> -Curso output\<nombre>`. Si el curso-data se redactó en esta corrida: parada de revisión de los administrativos antes de continuar con la Fase 2.
5. **Fases 2-3** (prosa viva): writers por carpeta — cada uno recibe solo el slice de sus encuentros, `input/plantillas/digest-codigo.md` si escribe código, la hoja de convenciones técnicas (leerla primero) y `input/estructura-de-la-clase.md`. Evaluaciones con scaffolds + consigna maestra + versiones equivalentes.
6. **Fase 4**: `tools\verificar-curso.ps1 -Curso output\<nombre>` y `tools\lint-canon.ps1 -Curso output\<nombre>` en verde.

## Actualizar un corpus existente (modo actualización)

1. Editar `input/materias/<nombre>/curso-data.json` (o el canon/plantillas) y validar.
2. `tools\impacto.ps1 -Materia input\materias\<nombre>` → plan de regeneración en tres listas (registrar el plan en el odd doc).
3. Re-render de derivados: siempre todos (idempotentes, costo cero).
4. El LLM toca **solo** la lista (b) de prosa afectada.

## Regenerar un corpus completo (materia existente)

> Corrida completa de `prompt-plantilla-planificacion.md` sobre una materia cuyo curso-data ya está validado: rehace **todos** los documentos derivados con generación reciente. Los CSV salen byte-idénticos (render determinista); la prosa es texto nuevo, equivalente en estructura y canon. El corpus anterior queda en git para comparar (`git diff`).

1. **Rama de seguridad:** `git switch -c regen/<curso>` y `git status` limpio. Todo lo eliminado es recuperable desde git.
2. **Limpieza:** borrar TODO el contenido de la carpeta del curso (p. ej. `output/LSO/`) — 100% regenerable —, conservando los archivos en `input/materias/` (`curso-data.json`, `convenciones-tecnicas.md`, `materia.md`, `pedido.md` — propiedad del docente, no se regeneran), y no tocar `input/plantillas/`, `tools/`, `input/estructura-de-la-clase.md` ni el prompt plantilla.
3. **Fase 0:** el curso-data ya es del docente: validarlo (`tools\validar-curso-data.ps1 -Materia input\materias\<nombre>`) y reutilizarlo tal cual; no se re-redacta ni se edita. La hoja de convenciones técnicas (`input/materias/<nombre>/convenciones-tecnicas.md`) también es del docente: se reutiliza tal cual, sin re-redactar.
4. **Fases 1-4** del prompt plantilla, sin saltear ninguna: render de los 3 CSV (`tools\generar-administrativos.ps1`), writers por carpeta (slice de curso-data + digest de código + hoja de convenciones + `input/estructura-de-la-clase.md`), evaluaciones con scaffolds, criterios + README + verificación final.
5. **Puerta de salida:** `tools\verificar-curso.ps1` en verde y `tools\lint-canon.ps1` sin regresiones contra su baseline documentada (`odd/tasks/`).
6. **Contexto del agente ejecutor:** raíz del repositorio, `input/database-docs/`, `input/materias/`, `input/plantillas/` y `tools/`; ignorar el resto de carpetas (otros proyectos). Sub-agentes por carpeta, mismo modelo que el principal, reporte compacto ≤ 15 líneas.
7. **Frenos:** por defecto la corrida es continua; detenerse solo si el pedido o la orden declaran frenos explícitos.

## Convenciones operativas

- Administrativos **solo CSV** (UTF-8 con BOM, separador `;`); no se corrigen a mano: el cambio se hace en el curso-data y se re-renderiza.
- `verificar-curso.ps1` y `lint-canon.ps1` son la puerta de salida de toda corrida; la baseline vigente de `output/LSO` está documentada en `odd/tasks/optimizacion-tiempo-tokens.md`.
- Las evaluaciones usan versiones equivalentes (A/B/C/D; mínimo dos según los grupos); la equivalencia se genera por reglas y se verifica con checklist determinista + pasada de lectura natural del docente.
- `curso-data.json` vive en `input/materias/<m>/`; si apareciera un duplicado en `output/<m>/` es involuntario: vale el de input (el validador lo avisa) y se sugiere eliminarlo; nunca se borra automáticamente.
