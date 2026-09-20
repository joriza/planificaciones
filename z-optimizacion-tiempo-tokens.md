# Plan de optimización de tiempos y tokens del proyecto

> Estado: **debate COMPLETO — plan aprobado en todos sus puntos**. Pendiente únicamente la indicación del docente para aplicar. Ancla de modificaciones: este documento es la fuente de verdad de los acuerdos.
> Origen: análisis posterior a las corridas completas del curso `minimal-api-csharp` (corpus de 111 archivos + reestructuración +det21).
> Debatedero: los puntos se discuten en orden de aparición (Diagnóstico → A → B → C → D → E → no-determinizables → estimaciones → orden → preguntas 1-4).

## Diagnóstico — dónde se van los tokens y el tiempo hoy

| Fuente de costo | Evidencia medida |
| --- | --- |
| Re-lectura de canon por subagente | Cada writer relee ~900-1.000 líneas (prompt 210 + mapa maestro 176 + convenciones 237 + estructura-de-la-clase 66 + database-docs ~350) → × 14-24 subagentes por corrida |
| Salida LLM de documentos DERIVADOS | Libro de aula, CSV con BOM e índice del README son funciones puras de la anual → hoy cuestan autoría LLM cuando podrían costar 0 |
| Prosa viva (irremplazable) | 20 clases ≈ 9.400 líneas + 48 evaluaciones + 30 intensificaciones + continuidad ≈ 19.500 líneas de corpus — el valor real |
| Reportes verbosos de workers | 500-1.500 palabras por subagente → presión directa sobre el contexto del orquestador |
| Rondas de fix por inconsistencia | PUT 200/204 y renombres de +det21: defectos que un linter determinista habría atrapado antes de la revisión |
| Cascada acoplada al LLM | +det21 (cambio de canon chico) tocó ~50 archivos: los derivados se re-escribieron en vez de re-renderizarse |
| Oleadas seriales | La Fase 2 (anual, prosa) bloquea todo el resto |

Modelo a extender: `verificar-curso.ps1` — determinista, rápido, costo cero en tokens.

## Estrategia A — Apps deterministas (`tools/`)

| App | Entrada → Salida | Ahorra |
| --- | --- | --- |
| A1. `generar-administrativos.ps1` | `curso-data.json` → anual md+csv (BOM), libro 1 y 2 líneas md+csv, validación ≤35 chars automática | Toda la Fase 2+3 de LLM; desaparece el cuello de botella de la anual |
| A2. `generar-readme.ps1` | árbol del corpus + data.json → índice con links + orden de creación (prosa vía plantilla con placeholders) | ~120 links manuales + links rotos en cada cambio |
| A3. `scaffold-*.ps1` | data.json → esqueletos de clase (secciones BOPPPS + headings canónicos) y de evaluación (base/A/B/anexo) | Tokens de salida (la estructura no se re-tipea) y drift de formato por construcción |
| A4. `generar-version-b.ps1` | versión A + tabla de mapeo de dominio (doctors↔patients, specialty↔city…) → versión B + anexo + checklist de equivalencia | ~50% de la autoría de evaluaciones |
| A5. Lint de canon en código | fences `csharp` del corpus → Results/long/string/inglés-plural/sin-tildes + tiempos suman 240 + correlación anual↔libro↔previews | Rondas de fix enteras (clase PUT/TypedResults) |
| A6. `impacto.ps1` | diff de canon/prompt → lista de archivos afectados (mapa regla→archivo) | Regeneración total en cambios tipo +det21 |

## Estrategia B — Reorganización de la cascada (data-first)

Hoy la madre es prosa LLM y todo deriva leyendo prosa con LLM. Propuesto:

```
Fase 0: curso-data.json (36 encuentros: tramo, eje, carácter, tema,
        tiempos, TP) ← única firma pedagógica; se redacta UNA vez
Fase 1: administrativos → RENDER determinista (A1, A2) — instantáneo
Fase 2: prosa viva → writers paralelos que leen SOLO data.json de SU
        unidad + digest de canon (no el canon completo)
Fase 3: evaluaciones → scaffold (A3) + autoría A + generación B (A4)
Fase 4: renders finales + verificación completa (A5)
```

Cambio de canon (tipo +det21): editar `curso-data.json` → administrativos re-renderizados solos → `impacto.ps1` lista la prosa afectada → el LLM toca solo esa lista.

## Estrategia C — Dieta de contexto de subagentes

1. Digest de canon por rol (~35 líneas vs 237+210 actuales); el linter (A5) es la red de seguridad.
2. Reporte compacto obligatorio (≤15 líneas): rutas + verificaciones + desvíos, sin prosa.
3. Sub-especie embebida: cada writer recibe solo las filas de data.json de sus encuentros.
4. Modo background + polling para solapar oleadas (hoy bloqueantes).

## Estrategia D — Incrementalidad (modo actualización)

Con data-first + generadores idempotentes, el modo normal pasa de "desde cero" a **actualización**: nada vigente se re-escribe. Hash de canon leído por writer → solo re-leen si el canon cambió.

## Estrategia E — Alternativas complementarias

- Routing de modelos: prosa en modelo principal; verificación/scaffolding en modelos chicos (`z-modelos-zen`) o 0-LLM.
- Instrumentación de costo por fase (usage registrado en el odd doc): medir antes de optimizar.
- Batching de writers: 1 writer por unidad completa (clases+evals) para amortizar arranque en frío; contrapartida: más blast radius.

## Qué NO determinizar (y por qué)

Prosa pedagógica: contenido de clases, evaluaciones en sí, acuerdos pedagógicos, continuidad, fundamentación del README. Ahí vive el juicio docente; solo su **andamiaje** (scaffolds) y sus **derivados** (administrativos, índice, versión B) son deterministas.

## Estimación de ahorro (estimativa, a validar con instrumentación)

| Medida | Ahorro estimado |
| --- | --- |
| A1+A2 (administrativos + índice) | 25-35% de tokens de una corrida completa |
| C (dieta de contexto + reportes) | 15-25% adicional |
| A4 (versión B generada) | ~40% del costo de evaluaciones |
| B+D en cambios tipo +det21 | 60-70% del costo de cascada |
| A5 (lint) | elimina 1-2 rondas de fix por corrida |

## Orden de implementación propuesto (pendiente de aprobación)

1. Instrumentación (baseline) → 2. A1 data-first + administrativos (mayor ROI) → 3. A5 lint → 4. C dieta → 5. A3+A4 scaffolds/versión B → 6. A6+D incrementalidad → 7. E routing (opcional).

## Registro del debate

### Punto 1 — Diagnóstico y frontera derivado/prosa viva: CERRADO

Decisiones:
1. **Administrativos solo CSV** (reformulada R1): `planificacion-anual.csv` + `libro-de-aula-1-linea.csv` + `libro-de-aula-2-lineas.csv`. Sin vistas MD. Los `.md` existentes del corpus se retiran cuando se aplique el plan. El FRENO de Fase 2 se revisa sobre CSV.
2. **Anual «20 + invariantes»** (reformulada R2): autoría solo de los 4 tramos de unidad (20 encuentros) + slots globales (celular, recursos, TPs, denominaciones). Los 12 tramos invariantes via plantillas con slots + banco de variantes redaccionales (2-3 por tramo, rotación determinista curso/año).
3. **Evaluaciones en 4 versiones** (reformulada R3): consigna maestra A contra abstracción de dominio + tabla de mapeo → B/C/D y sus anexos generados. Equivalencia por REGLAS (no cantidades); check determinista de equivalencia + pasada de lectura natural. Motivación: más variantes para comparar la realización práctica en las primeras ejecuciones.
   - Ajuste de canon al aplicar: [Evaluaciones] y [Momentos de intensificación] pasan de «dos versiones (A y B)» a «versiones equivalentes (A/B/C/D; mínimo dos según grupos)».
4. Consecuencias: correlación anual↔libro total por construcción; superficie de revisión del FRENO 2 reducida a 4 tramos + slots; estimación de ahorro de los administrativos revisada al alza (35-45% de una corrida).

### Punto 2 — Estrategia A (residual): CERRADO

Decisiones:
1. Se mantienen **A2** (generar-readme), **A3** (scaffold-*), **A5** (lint de canon) y **A6** (impacto, se construye al final: depende de R1/R2).
2. A2 ampliado: el README pasa a ser mayormente **derivado** — índice, links y orden generados del árbol + curso-data; fundamentación pedagógica por plantilla con slots (casi invariante entre materias: el modelo didáctico es el mismo; las decisiones específicas viven en curso-data.json); solo queda manual la prosa materia-específica corta.
3. **Plataforma: PowerShell para todas las tools** (mismo lenguaje del verificador, cero dependencias nuevas, chequeos de texto/estructura).
4. **Estructura de carpetas aprobada**:
   - `tools/` → verificar-curso.ps1 + generar-*.ps1 + scaffold-*.ps1 + impacto.ps1
   - `plantillas/` → tramos invariantes (fraseos + slots), banco de variantes, scaffolds, tablas de dominio
   - `materias/` → `<materia>.md` + `<materia>.json` (curso-data de esa materia)
5. Consecuencias: con A3 los chequeos estructurales pasan a ser por construcción (scaffolds canónicos); A5 elimina las rondas de fix tipo PUT 200/204 del ciclo LLM.

### Punto 3 — Estrategia B (cascada data-first): CERRADO

Decisiones:
1. **Modalidad de autoría del `curso-data.json`**: lo redacta el LLM UNA vez (desde `materias/<materia>.md` + estructura del ciclo) → **FRENO: el docente valida/edita** (20 bloques + slots, ~10-15 min) → desde ahí el archivo es del docente (versionado en git). Cursos nuevos arrancan del JSON anterior como plantilla.
2. **Esquema del JSON aprobado** (Anexo A): identificación + slots globales + 20 bloques de encuentro. Los 12 tramos invariantes NO viven en el JSON.
3. **Validador del JSON** (PowerShell, en `tools/`): al guardar aplica las reglas por el docente — ≤35 chars en tema/actividadesLibro, carácter dentro del vocabulario, ejes existentes, ordinales en rango, TP solo donde corresponde.
4. **Regeneración parcial confirmada por el docente**: modificar + re-validar → regenerar solo las partes de la cascada afectadas (pre-acuerda el corazón de la Estrategia D).

#### Anexo A — Esquema de `materias/<materia>.json`

```jsonc
{
  "materia": "minimal-api-csharp",
  "denominacion": "Minimal API con C# .NET 6",
  "varianteFraseos": 1,
  "slots": {
    "celular": "Sin uso de celular",
    "recursos": ["Aula-taller", "PC por grupo", "VS Code", "terminal", "hospital.db", "navegador", "GitHub", "proyector"],
    "tps": { "u1": "tp-u1", "u2": "tp-u2", "u3": "tp-u3", "u4": "trabajo-final" },
    "unidades": { "u1": "…", "u2": "…", "u3": "…", "u4": "…" },
    "ejes": { "1": ["nombre", "unidad", "u1"], "5": ["nombre", "transversal"] }
  },
  "encuentros": [
    {
      "n": 4, "unidad": "u1", "eje": 1, "caracter": "Procedimental",
      "tema": "Primer proyecto Minimal API",
      "actividadesLibro": ["Crear, ejecutar y probar API", "Primer endpoint GET"],
      "contenido": "…",
      "expectativas": ["…", "…"],
      "tp": null
    }
  ]
}
```

Derivación: `tema`/`actividadesLibro`/`eje`/`caracter` → filas del libro; `contenido`/`expectativas` → fila del tramo en la anual (composición de los 5 bloques) + insumo del writer de la clase; `slots` → tramos invariantes; `varianteFraseos` → banco de fraseos.

### Punto 4 — Estrategia C (dieta de contexto): CERRADO

Decisiones:
1. **C1 aprobado — digest flaco y versionado**: `plantillas/digest-codigo.md` (~30 líneas esenciales del canon de código), versionado en git y controlado por el docente; solo lo leen los writers con código. La estructura de clase la da el scaffold (A3) y los datos el slice del JSON: el digest canónico completo queda solo como referencia.
2. **C2 aprobado — reporte compacto**: prosa narrativa mínima en los reportes de writers; el sobre estructurado del paquete se conserva (no depende de nosotros).
3. **C3 absorbido por diseño** (slice del JSON por writer).
4. **C4 aprobado — background + polling** para solapar oleadas; se mantiene un writer por carpeta.

**Principio de diseño «plantilla para el esqueleto, prosa para la voz»** (salvaguarda del docente contra el efecto formulario):
- Las plantillas poseen SOLO estructura e invariantes (headings, metadatos, tramos administrativos que la escuela lee como formulario de todos modos) — nunca oraciones del cuerpo.
- El ~85% del corpus (cuerpo de clases, evaluaciones, acuerdos, continuidad) sigue siendo prosa autorizada: analogías, registro didáctico y voz docente viven en la parte variable.
- El banco de fraseos (2-3 variantes por tramo invariante) existe precisamente para que lo invariante no se lea estampado.
- El README conserva una «nota de la cátedra» de prosa libre por materia (2-3 párrafos), fuera de toda plantilla.
- Opcional en A5: aviso de similitud de aperturas entre clases (detección de prosa estampada).

### Punto 5 — Estrategia D (incrementalidad): CERRADO

Decisiones:
1. Dos modos: **corrida completa** (materia nueva / pruebas) y **actualización** (modo normal con corpus existente).
2. Flujo de actualización: editar JSON/canon → validador → `impacto.ps1` produce tres listas: (a) derivados a re-renderizar — automático y gratis, SIEMPRE todos (generadores idempotentes); (b) prosa afectada por el diff — encuentros/tramos/slots cambiados → sus clases/evaluaciones/README → LLM; (c) intocado — nadie lo abre.
3. **Sin cachés de hashes** para derivados: la astillez se concentra solo en la lista (b), que sale del diff del JSON + versión de canon. Plan de regeneración registrado en el odd doc (auditable).

### Nota técnica — ¿Oleadas seriales ahorran tokens por caché?

Consulta del docente (prioridad: tokens primero, velocidad después). Respuesta analizada:
- **Serial NO ahorra tokens**: la cuenta de tokens es idéntica; el caché de prompt solo DESCUENTA el precio del prefijo repetido si el proveedor factura más barato el cache-hit, y solo mientras el caché esté vivo (TTL de minutos).
- **En esta arquitectura el descuento sería mínimo**: el prefijo compartido entre writers es pequeño (system prompt + breve preámbulo); el bloque grande repetido (lecturas de canon) entra DESPUÉS del texto de tarea, en posiciones distintas por conversación → no es prefijo cacheable entre writers.
- **La palanca real de ahorro de cuenta de tokens es el BATCHING**: menos writers con alcance mayor (p. ej. 1 writer por unidad con clases+evaluaciones) elimina lecturas duplicadas de canon y de las clases. Costo: mayor blast radius por writer y menos paralelismo. Se adopta como **perilla de ajuste por corrida**: oleadas paralelas por defecto (velocidad); batching grueso cuando la ventana de uso esté ajustada (tokens).
- Los ahorros de tokens ya acordados siguen siendo los estructurales: digests, slices del JSON, determinismo, reportes compactos y modo actualización (D).

### Punto 6 — Estrategia E (complementarias) y orden final: CERRADO

Decisiones:
1. **Instrumentación de costo por fase**: SÍ, primera del orden (usage por fase registrado en el odd doc; medir antes de optimizar).
2. **Routing de modelos**: FUERA de esta etapa. Recién con números reales de la instrumentación se decide si verificar/scaffold justifican modelos chicos.
3. **Orden final de implementación aprobado**: 1) instrumentación → 2) R1/R2 (curso-data.json + generadores administrativos CSV) → 3) A5 lint de canon → 4) C dieta de contexto → 5) A3+R3 scaffolds y versiones A/B/C/D → 6) A6+D incrementalidad → 7) E routing solo si los números lo piden.

## Cierre del debate

Plan aprobado por el docente en los puntos 1 a 6. Ajustes de canon a aplicar el día de la implementación: evaluaciones en versiones A/B/C/D (mínimo dos según grupos); administrativos solo CSV; carpetas tools/ y plantillas/; ajustes de referencias en el prompt plantilla. No aplicar nada hasta indicación explícita del docente.

## Preguntas abiertas del debate

1. **La firma pedagógica** (`curso-data.json`): RESUELTA (punto 3) → LLM redacta una vez; el docente valida/edita; desde ahí el archivo es del docente.
2. **Plataforma de las tools**: RESUELTA (punto 2) → PowerShell.
3. **Derivados "bonitos"**: RESUELTA (punto 1) → solo CSV funcional, sin vistas MD.
4. **Routing de modelos**: RESUELTA (punto 6) → fuera de esta etapa; se decide con datos de la instrumentación.
