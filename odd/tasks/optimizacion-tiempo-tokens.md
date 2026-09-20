# Feature: optimización de tiempos y tokens — tools deterministas + cascada data-first

> Mapa maestro de la implementación del plan aprobado. **Fuente de verdad de los acuerdos: `z-optimizacion-tiempo-tokens.md`** (puntos 1-6, todos CERRADOS). Indicación de aplicación del docente: 2026-09-20 — «continue hasta el final sin detenciones parciales». Todo subagente lee ESTE documento y el plan antes de escribir.

## Reglas de oro para subagentes

1. El subagente NO commitea: commitea el orquestador tras verificar.
2. Reporte compacto ≤15 líneas: archivos escritos, verificaciones ejecutadas (comando + resultado), desvíos de la spec, uso de tokens si lo conocés.
3. Artifacts en español (prosa docente, datos JSON, plantillas); comentarios de scripts PowerShell en español (convención de `verificar-curso.ps1`); compatibilidad **Windows PowerShell 5.1** (sin `?:`, `??`, `&&` de PS7); CSV siempre UTF-8 con BOM.
4. Leer antes de escribir: este doc, `z-optimizacion-tiempo-tokens.md` (Anexo A incluido) y las fuentes listadas por tarea.

## Decisiones de implementación (consolidadas del plan)

- Carpetas aprobadas: `tools/` (verificar-curso.ps1, validar-curso-data.ps1, generar-administrativos.ps1, lint-canon.ps1, scaffold-*.ps1, generar-version-b.ps1, impacto.ps1) · `plantillas/` (tramos invariantes, banco de fraseos, esqueletos, tablas de dominio, digest) · `materias/` (`<materia>.md` + `<materia>.json`).
- `curso-data.json` contiene SOLO los **20 encuentros de unidad** (4-8, 10-14, 21-25, 27-31) + slots globales. Los **12 tramos invariantes** viven en `plantillas/` y NO están en el JSON.
- Administrativos **solo CSV**: `planificacion-anual.csv`, `libro-de-aula-1-linea-por-encuentro.csv`, `libro-de-aula-2-lineas-por-encuentro.csv` (se mantienen los nombres vigentes). Las vistas .md administrativas se retiran en T5.
- **Regla de fidelidad (crítica): el primer render desde JSON + plantillas debe reproducir los 3 CSV vigentes BYTE A BYTE** (diff vacío). Garantiza extracción fiel al canon ya validado y regeneración oficial no-op.
- Banco de fraseos: **v1 = texto vigente VERBATIM** con slots `{{...}}`; **v2/v3 = reescrituras nuevas** (mismo registro docente formal, misma estructura y cajas de tiempo, sin contenido nuevo). No se usan con `varianteFraseos: 1`.
- FRENO del plan (validación docente del JSON, Punto 3): cubierto por la regla de fidelidad + revisión final T10, según indicación explícita del docente de continuar sin detenciones.
- Canon de versiones (R3, se aplica en T8): «dos versiones (A y B)» pasa a «versiones equivalentes (A/B/C/D; mínimo dos según grupos)» SOLO en prompt plantilla y tools; el corpus vigente (A/B) sigue válido sin reescritura.

## Extensiones de esquema respecto del Anexo A (a sancionar en T10)

- Por encuentro: `actividadesLibro1` (celda ≤35 del libro 1 línea), `actividadesLibro2` (array de 2 celdas ≤35 del libro 2 líneas — textos DISTINTOS, no un split), `actividadesAnual` (frase para la narrativa de Actividades del tramo, sin prefijo «encuentro N, »), `estructura` (`clase` | `cierre`).
- `slots.unidades.uX` = `{denominacion, expectativas, transversales, nota, actividadesApertura, extension}` — todos verbatim del renglón del tramo en el CSV anual (expectativas unitarias; apertura y extensión para componer la columna Actividades).
- Composición de la celda Contenidos del tramo de unidad (verificada 4/4): `join(contenido de los 5 encuentros, "; ") + ". " + transversales + (nota != "" ? "; " + nota + "." : ".")` — fragmentos, transversales y nota SIN punto final propio.
- `plantillas/libro-filas-invariantes.json`: las filas de libro de los 16 encuentros invariantes (tema/actividades verbatim de ambos libros).

## Mapa de tareas

| T | Qué | Criterio de aceptación | Commit |
|---|---|---|---|
| T1 | Rama + este doc + status del plan | doc commiteado | `docs(odd): open optimizacion-tiempo-tokens feature map` |
| T2 | `materias/minimal-api-csharp.json` (worker) | schema + 20 encuentros + composiciones verificables | `feat(data): add minimal-api-csharp curso-data.json` |
| T3 | `plantillas/` tramos invariantes + banco fraseos + esqueletos + filas libro (worker) | v1 reproduce textos vigentes tras sustituir slots | `feat(plantillas): extract invariant tramos and phrase bank` |
| T4 | `tools/` validador + generador + mudanza de verificar-curso (worker) | validador verde; regen en scratch BYTE-IDÉNTICA ×3; verificar verde desde `tools/` | `feat(tools): add curso-data validator and admin CSV generators` |
| T5 | Aplicación oficial: regen oficial (diff vacío), retiro de 3 .md administrativos, barrido de referencias, README del curso | verificar verde; sin links rotos | `feat(course): render admins from curso-data, retire md views` |
| T6 | `tools/lint-canon.ps1` (worker) | corre sobre el corpus; hallazgos = baseline documentada | `feat(tools): add canon linter` |
| T7 | `plantillas/digest-codigo.md` + ajustes del prompt plantilla (carpetas, solo-CSV, flujo data-first, reporte compacto, slices) | prompt autoconsistente con el flujo nuevo | `docs(canon): align prompt template with data-first cascade` |
| T8 | `tools/scaffold-*.ps1` + `generar-version-b.ps1` + tabla de dominio + canon A/B/C/D (worker) | scaffolds canónicos; canon actualizado; corpus intacto | `feat(tools): add scaffolds and equivalent-version generator` |
| T9 | `tools/impacto.ps1` + modo actualización en el prompt (worker) | caso de prueba produce listas (a)(b)(c) correctas | `feat(tools): add canon-change impact analyzer` |
| T10 | Cierre: instrumentación final, status del plan, sanción de extensiones | plan doc actualizado a APLICADO | `docs(odd): close optimizacion-tiempo-tokens feature` |

## Instrumentación (medir antes de optimizar)

Baseline del Diagnóstico del plan: cada writer releía ~900-1.000 líneas de canon × 14-24 subagentes por corrida; los administrativos costaban autoría LLM completa; los derivados se re-escribían en cada cambio de canon.

| Tarea | Fecha | Tokens (informados) | Notas |
|---|---|---|---|
| T1 | 2026-09-20 | — | orquestador inline |

## Registro de commits

Se completa por tarea (hash + tarea).

## Mirror Engram

`mem_save` falló en T1 (servidor Engram caído en 127.0.0.1:7437). Reintento programado en T10. Respaldo: este documento es la fuente durable del estado.
