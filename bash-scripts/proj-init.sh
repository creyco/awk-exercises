#!/bin/bash
# ~/dev-tools/proj-init.sh

if [ -z "$1" ]; then
    echo "Uso: proj-init.sh <nombre-proyecto>"
    exit 1
fi

PROJECT_NAME=$1
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Crear estructura
mkdir -p src/{frontend,backend}
mkdir -p db/{migrations,seeds}
mkdir -p docs
mkdir -p scripts
mkdir -p tests

# Inicializar Git
git init

# Crear archivo de contexto inicial
echo "# Estado Actual del Proyecto" > .context.md
echo "- **Última tarea:** Pendiente" >> .context.md
echo "- **Delegado a:** Nadie" >> .context.md
echo "- **Notas:**" >> .context.md

# Crear README
echo "# $PROJECT_NAME" > README.md

echo "✅ Proyecto '$PROJECT_NAME' inicializado con estructura Fullstack."
echo "💡 Tip: Edita '.context.md' antes de salir del proyecto."
