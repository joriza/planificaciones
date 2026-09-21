# Perfiles en gentle-pi

> Gentle-PI: paquete del ecosistema Gentle-AI que convierte Pi en "el Gentleman".
> Los perfiles son **snapshots nombrados del routing global de modelos por agente**.

## Cómo funcionan

- **Base**: `/gentle:models` asigna modelo + effort (`thinking`) por agente SDD/custom. Ese routing se guarda en `~/.pi/gentle-ai/models.json` y se materializa en `.pi/subagents.json` (proyecto) o `~/.pi/agent/subagents.json` (global/built-in).
- **Perfiles**: `/gentle:profiles` son snapshots de ESE routing. Se guardan en `~/.pi/gentle-ai/profiles.json`.
- **Regla clave**: un perfil es un snapshot **completo** — todo agente que el perfil NO mencione vuelve a "inherit". O sea, al aplicar un perfil no sobrevive routing viejo en silencio.
- **`orchestrator` es una reserva**: si el perfil lo define, escribe `defaultProvider`/`defaultModel`/`defaultThinkingLevel` en el `settings.json` global de Pi (preservando el resto). Nunca va a `subagents.json` ni es un agente.

## Cómo crear un perfil nuevo y asignarle modelos

Flujo recomendado (todo desde el panel `/gentle:profiles`):

1. **Configurá el routing primero**: salí al `/gentle:models` y asigná modelo + thinking a los agentes que te importan (spec/design/tasks → modelo fuerte con `medium`-`high`; explore/propose/archive → rápido y barato; verify/review → `high`).
2. **Volvé a `/gentle:profiles`**:
   - `c` → crea el perfil nuevo (vacío)
   - `s` → **snapshotea el routing actual** dentro del perfil seleccionado (incluye el orchestrator que esté activo en `settings.json`)
   - `enter` → lo aplica en vivo
3. Si después querés retocarlo: aplicá el perfil, cambiá routing con `/gentle:models`, y volvé a pulsar `s` para actualizar el snapshot.

Otras teclas: `d` duplica, `r` renombra, `x` borra (refusa el activo), `e`/`i` exporta/importa a `~/.pi/gentle-ai/profiles.export.json`, `esc` cierra. En versiones nuevas también podés **pinear un repositorio a un perfil con `p`** para que ese proyecto deje de seguir el perfil global activo.

También podés editar a mano `~/.pi/gentle-ai/profiles.json` (misma forma por agente que `models.json`):

```json
{
  "kind": "gentle-pi.agent_model_profiles",
  "version": 1,
  "active": "deep-work",
  "profiles": {
    "deep-work": {
      "orchestrator": { "model": "anthropic/claude-sonnet-4", "thinking": "high" },
      "sdd-design": { "model": "anthropic/claude-sonnet-4", "thinking": "high" }
    }
  }
}
```

## Gotchas que te van a morder

- **Un launch de lag**: al aplicar un perfil, el próximo lanzamiento de subagente todavía rutea con el routing viejo — el cambio se ve recién al siguiente.
- **Nombres**: slugs de 1-64 chars ASCII (letras, números, `.`, `_`, `-`); nada de espacios ni acentos, y `__proto__`/`constructor`/`prototype` están prohibidos.
- **Borrar el activo**: `x` lo refusa a propósito.
- **`s` lee el routing EFECTIVO** (models.json + lo que resuelve `subagents.json`/frontmatter), así un `models.json` disperso no esconde routing que sigue vivo.