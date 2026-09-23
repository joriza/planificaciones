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
    if gentle-ai review validate --gate "$GATE" --cwd "$CWD" --contract gentle-ai.review-integration/v2; then
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