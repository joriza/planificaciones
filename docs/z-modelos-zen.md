# z-pdt-modelos-zen.md

> **PERSONAL — borrador de uso personal, NO vinculante.**
> Este documento NO forma parte de la planificación ni de la documentación docente.
> Convención `z-pdt*`: anotaciones personales del docente; no se corrigen con el estándar institucional.

**Actualizado:** 2026-09-20 · **Fuente:** `https://opencode.ai/zen/v1/models` (lista viva)

---

## Contexto del proyecto

Tipo de carga: núcleo de **texto pedagógico en español** (registro formal institucional + didáctico con voseo) con **ejemplos simples de codificación** (C# console, Minimal API, SQLite/Dapper, PowerShell, CSV/Markdown) y **correlación cruzada** entre decenas de documentos de planificación.

## Criterios de selección (por orden de peso)

1. **Calidad de prosa pedagógica en español** (el ~80% del trabajo).
2. **Instrucción fina** para reglas de documentos (cascada, correlación, formatos fijos).
3. **Contexto largo** para pasadas de consistencia de todo el curso.
4. **Código simple correcto** (no requiere ingeniería pesada).

## Modelos gratuitos vigentes en Zen (2026-09-19)

Fuente: endpoint vivo `/zen/v1/models` — los tiers gratuitos son promocionales y cambian; re-verificar antes de confiar en esta lista.

| Modelo | ID | Ventaja principal |
|---|---|---|
| **Nemotron 3 Ultra** (gratis) | `opencode/nemotron-3-ultra-free` | 1M contexto, 128k salida, multilingüe fuerte |
| Big Pickle | `opencode/big-pickle` | Stealth, probado empíricamente en este proyecto |
| DeepSeek V4 Flash (gratis) | `opencode/deepseek-v4-flash-free` | El más fuerte en código (128k salida) |
| Muse Spark 1.3 (gratis) | `opencode/muse-spark-1.3-contributor-free` | 1M contexto |
| Muse Spark 1.2 (gratis) | `opencode/muse-spark-1.2-contributor-free` | 1M contexto |
| Nemotron 3.5 Lightning (gratis) | `opencode/nemotron-3.5-lightning-free` | Rápido, 262k de salida |
| GPT-5.4 Nano (gratis) | `opencode/gpt-5.4-nano` | Texto corto, liviano |
| GPT-5 Nano (gratis) | `opencode/gpt-5-nano` | Texto corto, generación previa |
| Ling 3.0 Flash Fin (gratis) | `opencode/ling-3.0-flash-fin-free` | Flash — tareas rápidas |
| MiMo V2.5 (gratis) | `opencode/mimo-v2.5-free` | Chico — descartado para prosa |
| JEV 1.13 (gratis) | `opencode/jev-1.13-free` | Stealth, sin spec pública |

## Recomendación

| Caso | Modelo |
|---|---|
| **Default del proyecto** | **`nemotron-3-ultra-free`** — 1M de contexto (verificar el curso entero de una pasada) + español cuidado + 128k de salida |
| Alternativa principal | `big-pickle` — el modelo que construyó todo el curso; evidencia empírica |
| Generación/verificación de código puro | `deepseek-v4-flash-free` |
| Pasadas masivas de consistencia | `muse-spark-1.3-contributor-free` (1M) |
| Tareas cortas de texto | `gpt-5.4-nano` |
| Descartados | `ling-3.0-flash-fin-free`, `mimo-v2.5-free`, `gpt-5-nano` (pulido de prosa menor) |

## Cómo quedó configurado

> Al 2026-09-20 el `opencode.json` del proyecto ya no existe; la configuración de Zen de arriba queda como referencia histórica.

- Config **global** (`C:\Users\USER\.config\opencode\opencode.json`), proveedor manual `z-ai` apuntando al plan Z.AI Coding: modelos seleccionables **`glm-5.3`** y **`glm-5.3-flash`** (retirados glm-4.7/5.0/5.1/5.2/5-turbo).
- **Default**: `z-ai/glm-5.3` — ídem agentes `plan`, `gentle-Orchestrator` y `sdd-orchestrator-pru01`.
- **Subagentes**: TODOS en `z-ai/glm-5.3-flash` — SDD, reviews 4R, judgment-day, fixer y los integrados `general`/`explore` (pinnados explícitamente para que no hereden el default).
- Backup: `opencode.json.bak-20260920-004947`.