#!/bin/bash
# ~/dev-tools/dev-status.sh

echo "🔍 ANALIZANDO ENTORNO ACTUAL..."
echo ""

# 1. Estado Git
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "🌿 Git Branch: $(git branch --show-current)"
    echo "📦 Últimos commits:"
    git log --oneline -n 3
else
    echo "⚠️ No es un repositorio Git"
fi

echo ""

# 2. Archivo de Contexto Local
if [ -f .context.md ]; then
    echo "📄 ESTADO LOCAL (.context.md):"
    cat .context.md
else
    echo "⚠️ No existe .context.md (Usa proj-init.sh)"
fi

echo ""
echo "🌍 ACTIVIDAD GLOBAL (Últimos registros):"
python3 ~/dev-tools/dev-track.py
