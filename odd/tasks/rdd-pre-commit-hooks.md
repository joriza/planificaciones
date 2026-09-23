# Pre-Commit Hooks de RDD para Validación Automática

**Origen**: Configuración de pre-commit hooks para el plan de mejoras
**Estado**: ✅ IMPLEMENTADO - Pre-commit hooks funcionales
**Objetivo**: Implementar hooks pre-commit para validación automática de work-unit commits con RDD

## 1. Configuración Pre-Commit Hook

### Opción 1: Git Hook Local
```bash
# Crear pre-commit hook en .git/hooks/
mkdir -p .git/hooks
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Pre-commit hook con RDD validation
echo "🔍 Validando RDD en pre-commit..."

# Verificar si RDD está habilitado
if gentle-ai review mode status --cwd . | grep -q "on"; then
    echo "✅ RDD habilitado, ejecutando validación pre-commit..."
    
    # Validar el cambio actual
    if gentle-ai review validate --gate pre-commit --cwd . --contract gentle-ai.review-integration/v2 --agent pi; then
        echo "✅ Validación pre-commit exitosa"
        exit 0
    else
        echo "❌ Validación pre-commit fallida"
        echo "   - Revise los cambios con: gentle-ai review status --cwd ."
        echo "   - Si es un commit pequeño, puede usar: git commit --no-verify"
        echo "   - Para deshabilitar temporalmente: gentle-ai review mode disable --scope clone"
        exit 1
    fi
else
    echo "⚠️  RDD no habilitado, saltando validación"
    exit 0
fi
EOF

# Dar permisos de ejecución
chmod +x .git/hooks/pre-commit
```

### Opción 2: Script Centralizado (recomendado)
```bash
# Crear script de validación en tools/rdd-validate.sh
mkdir -p tools

cat > tools/rdd-validate.sh << 'EOF'
#!/bin/bash

# Script de validación RDD para pre-commit/pre-pr
# Uso: tools/rdd-validate.sh <gate>

GATE=${1:-pre-commit}
CWD="."

echo "🔍 Validación RDD para gate: $GATE"

# Verificar estado de RDD
STATUS=$(gentle-ai review mode status --cwd "$CWD" 2>/dev/null)
if echo "$STATUS" | grep -q "on"; then
    echo "✅ RDD habilitado"
    
    # Ejecutar validación
    if gentle-ai review validate --gate "$GATE" --cwd "$CWD" --contract gentle-ai.review-integration/v2 --agent pi; then
        echo "✅ Validación $GATE exitosa"
        exit 0
    else
        echo "❌ Validación $GATE fallida"
        
        # Proporcionar ayuda
        echo "📝 Soluciones:"
        echo "   1. Revisar estado: gentle-ai review status --cwd \"$CWD\""
        echo "   2. Verificar lineage: gentle-ai review lineage --cwd \"$CWD\""
        echo "   3. Deshabilitar temporal: gentle-ai review mode disable --scope clone"
        echo "   4. Commit sin validación: git commit --no-verify"
        
        exit 1
    fi
else
    echo "⚠️  RDD no habilitado, saltando validación"
    exit 0
fi
EOF

chmod +x tools/rdd-validate.sh
```

### Opción 3: Husky (si se usa)
```bash
# .husky/pre-commit
#!/bin/bash
. "$(dirname "$0")/_/husky.sh"

echo "🔍 Pre-commit validation with RDD..."
npx tools/rdd-validate.sh pre-commit
```

## 2. Configuración de Puertas de Entrega

### Pre-Commit (obligatorio para todos los commits)
```bash
# Validación automática antes de cada commit
gentle-ai review validate --gate pre-commit --cwd . --contract gentle-ai.review-integration/v2 --agent pi
```

### Pre-PR (recomendado para cambios grandes)
```bash
# Validación antes de crear PR
gentle-ai review validate --gate pre-pr --cwd . --contract gentle-ai.review-integration/v2 --agent pi
```

### Pre-Push (opcional para push directo)
```bash
# Validación antes de push directo
gentle-ai review validate --gate pre-push --cwd . --contract gentle-ai.review-integration/v2 --agent pi
```

## 3. Configuración Automática del Proyecto

### Archivo de Configuración
```bash
# .rdd-config.json
{
  "enabled": true,
  "gates": {
    "pre-commit": true,
    "pre-pr": true,
    "pre-push": false
  },
  "runtime": "pi",
  "contract": "gentle-ai.review-integration/v2",
  "thresholds": {
    "low": {
      "auto_approve": true,
      "lens_required": false
    },
    "medium": {
      "auto_approve": false,
      "lens_required": true,
      "lens_type": "review-readability"
    },
    "high": {
      "auto_approve": false,
      "lens_required": true,
      "lens_type": "4R-completo"
    }
  }
}
```

### Script de Configuración Automática
```bash
#!/bin/bash

# tools/setup-rdd-hooks.sh
echo "🔧 Configurando hooks de RDD..."

# Crear directorio tools si no existe
mkdir -p tools

# Crear script de validación
cat > tools/rdd-validate.sh << 'EOF'
#!/bin/bash
GATE=${1:-pre-commit}
CWD="."

if gentle-ai review mode status --cwd "$CWD" | grep -q "on"; then
    if gentle-ai review validate --gate "$GATE" --cwd "$CWD" --contract gentle-ai.review-integration/v2 --agent pi; then
        echo "✅ Validación $GATE exitosa"
        exit 0
    else
        echo "❌ Validación $GATE fallida"
        exit 1
    fi
else
    echo "⚠️  RDD no habilitado"
    exit 0
fi
EOF

chmod +x tools/rdd-validate.sh

# Crear pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "🔍 Validación RDD pre-commit..."
if [ -f "tools/rdd-validate.sh" ]; then
    ./tools/rdd-validate.sh pre-commit
else
    echo "⚠️  Script de validación no encontrado"
fi
EOF

chmod +x .git/hooks/pre-commit

echo "✅ Hooks configurados exitosamente"
```

## 4. Pruebas y Validación

### Test del Hook
```bash
# Probar el hook sin commit real
touch test-file.txt
git add test-file.txt
git commit -m "test: archivo de prueba" --dry-run

# Ejecutar manualmente
tools/rdd-validate.sh pre-commit

# Verificar estado
gentle-ai review status --cwd . --contract gentle-ai.review-integration/v2 --agent pi
```

### Escenarios de Prueba

#### Escenario 1: Commit pequeño (low risk)
```bash
# Expected: validación exitosa automática
git add small-change.md
git commit -m "feat: pequeña mejora"
```

#### Escenario 2: Commit grande (high risk)
```bash
# Expected: requiere revisión manual
git add big-structural-change/
git commit -m "feat: cambio estructural grande"
```

#### Escenario 3: RDD deshabilitado
```bash
# Expected: skip validation
gentle-ai review mode disable --scope clone
git commit -m "test: sin rdd"
```

## 5. Monitoreo y Registro

### Log de Validaciones
```bash
# Crear log directory
mkdir -p .git/rdd-logs

# Modificar el hook para logging
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
LOG_FILE=".git/rdd-logs/pre-commit-$(date +%Y%m%d-%H%M%S).log"
echo "[$(date)] Pre-commit validation started" > "$LOG_FILE"

if ./tools/rdd-validate.sh pre-commit >> "$LOG_FILE" 2>&1; then
    echo "[$(date)] ✅ Success" >> "$LOG_FILE"
    exit 0
else
    echo "[$(date)] ❌ Failed" >> "$LOG_FILE"
    exit 1
fi
EOF
```

### Script de Resumen de Reviews
```bash
#!/bin/bash

# tools/rdd-summary.sh
echo "📊 Resumen de Reviews RDD"

# Obtener reviews recientes
gentle-ai review status --cwd . --contract gentle-ai.review-integration/v2 --agent pi | jq -r '
  .entries[] | 
  "\(.lineage_id): \(.status) - \(.revision)"
'

echo "📁 Logs en .git/rdd-logs/"
ls -la .git/rdd-logs/ | head -10
```

## 6. Integración con Work-Unit Commits del Plan

### Aplicación a nuestro plan:
- **P2-E**: Validación pre-commit de corrección de evaluaciones
- **P2-D**: Validación de formato integrador U4
- **P3-B**: Validación de fraseos naturales
- **P1-D**: Validación de matriz de distribución
- **P2-A**: Validación de banco de frases estructurales

### Script Específico para el Plan
```bash
#!/bin/bash

# tools/validate-plan-commits.sh
echo "🎯 Validando commits del plan de mejoras..."

# Archivos específicos del plan
PLAN_FILES=(
    "odd/tasks/p2e-correccion-evaluaciones.md"
    "odd/tasks/p2d-canonizar-formato-u4.md"
    "odd/tasks/p3b-pasada-lectura-natural.md"
    "odd/tasks/p1d-distribucion-destinatarios.md"
    "odd/tasks/p2a-banco-frases-estructurales.md"
    "odd/tasks/rdd-work-unit-commits.md"
)

# Validar archivos del plan
for file in "${PLAN_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "📝 Validando: $file"
        git add "$file"
        if tools/rdd-validate.sh pre-commit; then
            echo "✅ $file validado"
        else
            echo "❌ $file falló validación"
        fi
    else
        echo "⚠️  $file no encontrado"
    fi
done

echo "🎯 Validación del plan completada"
```

## 7. Desinstalación y Mantenimiento

### Deshabilitar Temporalmente
```bash
# Deshabilitar RDD temporalmente
gentle-ai review mode disable --scope clone

# Commit sin validación
git commit --no-verify

# Rehabilitar
gentle-ai review mode enable --scope clone
```

### Limpiar Hooks
```bash
# Remover pre-commit hook
rm .git/hooks/pre-commit

# Remover scripts
rm tools/rdd-validate.sh tools/rdd-summary.sh
```

## 8. Próximos Pasos

1. ✅ Implementar script de configuración automática
2. ✅ Probar hooks en commits reales
3. ✅ Configurar logging y monitoreo
4. 🔄 Integrar con CI/CD pipeline
5. 🔄 Documentar para el equipo