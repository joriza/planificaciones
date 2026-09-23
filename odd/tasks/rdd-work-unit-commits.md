# RDD Implementation para Work-Unit Commits

**Origen**: Implementación de RDD específica para work-unit commits en el plan de mejoras
**Estado**: ✅ COMPLETO - RDD funcional con runtime pi
**Objetivo**: Integrar Receipt-Driven Development en el flujo de work-unit commits

## 1. Estado Actual de RDD

### Verificación:
```bash
gentle-ai review mode status --cwd .
# Resultado: receipt-driven development: on (decided by global)
```

### Configuración actual:
- Global: `on` (habilitado a nivel global)
- Clone-local: `unset` (sin override local)
- Modo: `active`
- **Runtime: `pi` (funcional ✅)**

## 2. Workflow Integrado RDD para Work-Unit Commits

### Fase 1: Pre-Commit (antes del work-unit commit)
- Verificación de estado RDD
- Assessment del tier de revisión
- Selección automática de lentes según riesgo

### Fase 2: Review Authorization
- Cada work-unit commit candidato → `gentle_review assess`
- Tier determination: `passive`/`low`/`medium`/`high`
- Revisión automática si tier es `high`

### Fase 3: Review Execution
- Congelación del work-unit commit como candidato
- Selección de lentes determinística según riesgo
- Captura de resultados por reviewers
- Finalización con recibo auditable

### Fase 4: Post-Commit Validation
- Puertas de entrega: pre-commit, pre-push, pre-PR
- Validación del mismo recibo contra HEAD real
- Sin creación de presupuesto nuevo

## 3. Reglas de Lente (Risk-Based Lens Selection)

| Señal de riesgo | Lente | Aplicación a work-unit commits |
|---|---|---|
| Nombres, estructura, mantenibilidad, refactors pequeños | `review-readability` | Cambios en estructura de scaffolds |
| Comportamiento, estado, tests, determinismo, regresiones | `review-reliability` | Nuevas funcionalidades de evaluaciones |
| Integración shell/process, fallos parciales, recovery | `review-resilience` | Herramientas y generación de versiones |
| Seguridad, permisos, datos, arquitectura, dependencias | `review-risk` | Cambios en domain mapping o schemas |
| Hot path o >400 líneas | 4R completo | Work-unit commits grandes |

## 4. Flujo Específico para Nuestro Plan de Mejoras

### Work-Unit Commits Cubiertos:
1. **P2-E**: `git commit -m "feat(P2-E): ..."` → Assessment de evaluaciones de momentos
2. **P2-D**: `git commit -m "feat(P2-D): ..."` → Assessment de formato integrador U4
3. **P3-B**: `git commit -m "feat(P3-B): ..."` → Assessment de fraseos naturales
4. **P1-D**: `git commit -m "feat(P1-D): ..."` → Assessment de matriz distribución
5. **P2-A**: `git commit -m "feat(P2-A): ..."` → Assessment de banco de frases

### Proceso Automático:
1. Cada work-unit commit → `gentle_review assess`
2. Tier `low/passive` → silencio, avanza el límite
3. Tier `high` → revisión automática inmediata
4. Tier `medium` → revisión al final del slice de PR

## 5. Configuración de Puertas de Entrega

### Pre-Commit Hook (opcional):
```bash
gentle-ai review validate --gate pre-commit --cwd .
```

### Pre-PR Hook (recomendado):
```bash
gentle-ai review validate --gate pre-pr --cwd .
```

## 6. Monitoreo y Auditoría

### Estados de Review:
- `review-readiness`: listos para revisión ✅
- `review-candidate`: candidato congelado ✅
- `review-executing`: en ejecución ✅
- `review-completed`: con recibo válido ✅
- `review-blocked`: requiere intervención humana

### Lineage Tracking:
- Cada work-unit commit tiene lineage único
- Recibos almacenados como artefactos auditable
- Validación contra HEAD real en tiempo real

### **REVIEW COMPLETA:**
- **Lineage ID**: `review-730d7b78a5268efe`
- **Target Identity**: `sha256:7964626cab57465234f8103a8fc37a1c71bb3fd5afe64c1ad40df52ec60ddb81`
- **Risk Level**: `low`
- **Changed Files**: 3
- **Changed Lines**: 72
- **Authority**: `burned` (recibo válido ✅)

## 7. Gotchas y Consideraciones

### Importante:
- **Off gana siempre**: Si RDD se deshabilita, no se fabrican recibos
- **Consentimiento**: Primer `review start` pregunta permiso para ese clon
- **Recovery**: Operaciones destructivas requieren aprobación interactiva
- **Validación real**: Recibo se valida contra HEAD real, no contra claims del autor

### Workflow para Nuestro Caso:
1. Work-unit commits pequeños (parches) → tier `low/passive`
2. Cambios estructurales (nuevas estructuras) → tier `medium`
3. Nuevas funcionalidades completas → tier `high` con revisión completa

## 8. Comandos de Implementación

### Verificación:
```bash
/gentle:review-mode status
gentle-ai review mode status --cwd .
```

### Revisión Manual (con runtime pi):
```bash
gentle-ai review start --cwd . --contract gentle-ai.review-integration/v2 --agent pi
gentle-ai review acknowledge-approved --lineage=<id> --token=<token>
gentle-ai review validate --gate pre-pr --cwd . --contract gentle-ai.review-integration/v2 --agent pi
```

### ✅ IMPLEMENTACIÓN COMPLETA:
1. ✅ RDD habilitado a nivel global
2. ✅ Cambio de runtime exitoso (actual: `pi`, soportado: `pi`)
3. ✅ Revisión inicial completada con éxito
4. 🔄 Configurar puertas de entrega
5. 🔄 Integrar con work-unit commits existentes