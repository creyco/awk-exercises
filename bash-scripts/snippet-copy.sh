#!/bin/bash
# ~/dev-tools/snippet-copy.sh

SNIPPET_DIR="$HOME/dev-snippets"

if [ ! -d "$SNIPPET_DIR" ]; then
    mkdir -p $SNIPPET_DIR/{sql,python,js,config}
    echo "📂 Carpeta de snippets creada en $SNIPPET_DIR"
    echo "Guarda ahí tus archivos .sql, .py, .env.example"
    exit 0
fi

echo "📦 Snippets disponibles:"
find $SNIPPET_DIR -type f -name "*" | sed "s|$SNIPPET_DIR/||"
echo ""
echo "Uso: snippet-copy.sh <categoria/archivo> <destino>"
echo "Ej:  snippet-copy.sh sql/connectormysql.py ./src/db/"
