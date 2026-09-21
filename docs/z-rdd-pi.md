# RDD (Receipt-Driven Development) en gentle-pi

> RDD = **Receipt-Driven Development** — el "desarrollo guiado por recibos". Es la columna vertebral de revisión del ecosistema Gentle-AI. En gentle-pi se controla con `/gentle:review-mode` y el binario nativo `gentle-ai`.

## Qué es RDD

Todo cambio que llega a una **puerta de entrega** (commit, push, PR, release) debe estar respaldado por un **recibo de revisión válido**, atado al contenido EXACTO del cambio. Sin recibo válido → la puerta se cierra (fail closed).

El recibo NO es una opinión ("esto se ve bien") sino una cadena de artefactos firmes:

- **Operación de review acotada**: se dispara explícitamente (`review/start(target)`) sobre un snapshot inmutable, de solo lectura, con un resultado terminal. Un reviewer jamás edita código ni abre otro review.
- **Ledger de hallazgos congelados**: cada hallazgo es neutral (claim + evidencia, no narrativa persuasiva), con severidad, clase de evidencia y estado (`refuted`/`corroborated`/`inconclusive`...). Los BLOCKER/CRITICAL inferenciales pasan por un refuter independiente; los determinísticos se corroboran con prueba directa.
- **Corrección acotada**: si hubo corrección, una sola transacción de unidades de trabajo mapeadas a IDs congelados, y después una validación scoped del delta — nunca un loop infinito de revisar.
- **Gates de ciclo de vida**: pre-commit, pre-push, pre-PR y release **validan el mismo recibo** con `review-validate` (nativo). Nunca crean un presupuesto nuevo ni lanzan un review al pasar por la puerta. Si el recibo está invalidado, `scope-changed` o escalado → se detiene y requiere acción explícita.
- **Kill switch**: si RDD está deshabilitado, no se fabrican recibos ni claims de aprobación — política ordinaria, estado `disabled/unmanaged`.

**Por qué importa**: separa **autoridad de revisión** de opinión. "Un agente miró el diff y dijo que está bien" no es un recibo. El recibo ata identidad del cambio, lineage, ledger, evidencia de pruebas y contexto de puerta en un solo paquete auditable — y el validador lo verifica contra el HEAD real, sin confiar en árboles ni hashes que te pase el autor.

## Estado actual (verificado 2026-09-20)

```
receipt-driven development: on (decided by global)
  global:      on
  clone-local: unset
```

Activado con: `gentle-ai review mode enable --scope=global` (binario nativo 2.4.0).

## Cómo se activa

El kill switch es **solo del usuario** — Pi jamás lo togglea solo. Dos niveles:

| Nivel | Comando | Efecto |
|---|---|---|
| Global | `gentle-ai review mode enable --scope=global` | Opt-in real, vale para todos los clones |
| Clone-local | `/gentle:review-mode enable` en Pi | **OJO**: Pi siempre pasa `--scope clone` (Design Decision #7), solo limpia/crea un override por clon. NO puede encender RDD global cuando global está off o unset |

- Verificar: `/gentle:review-mode status` o `gentle-ai review mode status [--cwd <repo>]` → `on (decided by global)`. El status nunca muta.
- Apagar: `/gentle:review-mode disable` o `gentle-ai review mode disable --scope=global`. **Off gana siempre**; ninguna clon hereda un override sobre un global off.
- RDD es **opt-in**: off por default hasta que se habilite explícitamente.

## Cómo se usa (el ciclo completo)

RDD no es un comando que corrés: es un protocolo que **el orquestador (el Gentleman) ejecuta sobre tu trabajo**. Vos trabajás normal (ODD/SDD con work-unit commits) y el harness hace esto:

1. **Cada work-unit commit**, con RDD encendido, asesora el tier:
   `gentle_review {"operation":"assess","baseRef":"<último límite revisado>","committedOnly":true}`
   - `passive`/`low` → silencio, el límite avanza
   - `high` (o assess fallido/no disponible) → revisa ESE commit ya mismo contra ese base
   - `medium` → difiere al cierre del slice de PR (límite ~400 líneas, commits acumulados desde el último límite)
   - Cada límite revisado se vuelve el nuevo `baseRef`; el primero es el branch point

2. **La revisión en sí**: congela UN candidato (work-unit commit o slice, nunca un TODO checkbox ni la feature branch acumulada), selecciona lentes por riesgo y despacha reviewers de solo lectura que capturan resultados; `finalize` escribe el **recibo**.

3. **Selección de lentes** (determinística, no a criterio):
   - Diff trivial (solo docs/comentarios/formato) → sin lente
   - Diff estándar → EXACTAMENTE 1 lente dominante según el riesgo
   - Hot path (auth/update/security/payments) o >400 líneas → 4R completo

   | Señal de riesgo | Lente |
   |---|---|
   | Naming, estructura, maintainability, refactors chicos | `review-readability` |
   | Comportamiento, estado, tests, determinismo, regresiones | `review-reliability` |
   | Integración shell/process, fallos parciales, recovery | `review-resilience` |
   | Seguridad, permisos, exposición de datos, arquitectura, dependencias | `review-risk` |
   | Hot path o >400 líneas | 4R completo (los 4) |

4. **Puertas de entrega**: pre-commit / pre-push / pre-PR / release → `gentle-ai review validate --gate <puerta>` valida el MISMO recibo atado al contenido. Nunca crea presupuesto nuevo. RDD off → estas puertas no exigen nada.

5. **Judgment Day**: la alternativa explícita de doble revisión ciega (2 jueces, 2 hashes de ejecución, acuerdo) si la seleccionás — máximo 2 rondas de fix y 2 re-juicios.

6. **Resultados informativos**: la entrega sigue la política ordinaria del repo — Pi no crea rutas de delivery. Regla de oro: *confiá en lo que el sistema deriva, no en lo que un agente afirma*.

7. **Consentimiento**: el primer `review start` que haría trabajo pregunta una vez por clon ("not now" aplica solo a ese candidato, no persiste nada). Apagar de verdad es solo con disable.

## Comandos de referencia

```text
# Estado / kill switch (Pi)
/gentle:review-mode status|enable|disable

# Estado / kill switch (binario nativo)
gentle-ai review mode status [--cwd <repo>] [--scope <global|clone>]
gentle-ai review mode enable|disable --scope <global|clone>

# Flujo de revisión nativo
gentle-ai review start [--cwd <repo>] [--base-ref <ref>] [--focus <lens>]
gentle-ai review capture-result --lineage <id> --target <id> --lens <lens> --order <n> --input <review.json>
gentle-ai review finalize [--cwd <repo>] [--captured-results] [--evidence <path>]
gentle-ai review validate --gate <pre-commit|pre-push|pre-pr|release> [--cwd <repo>]
gentle-ai review status [--cwd <repo>]
gentle-ai review repair --preflight [--cwd <repo>]
```

## Gotchas

- **`/gentle:review-mode enable` en Pi no enciende RDD global** — solo maneja el override por clon (Design Decision #7). Si el global está off/unset, el comando avisa con warning y no cambia nada.
- **Off gana**: ninguna clon hereda un override sobre un global off. Re-enable aplica solo a candidatos futuros.
- **Un launch de lag** en perfiles de modelos (ver `z-perfiles-pi.md`) — el cambio de routing se ve recién al siguiente launch.
- **El recibo se valida contra el HEAD real**, nunca contra lo que el autor dice que cambió. Trees/hashes que te pase un agente no son autoritativos.
- **Mantenimiento**: operaciones destructivas de recovery requieren aprobación interactiva fresca y fallan cerradas en modo headless; legacy nunca se migra automáticamente.