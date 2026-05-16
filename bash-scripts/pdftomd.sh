#!/bin/bash

# 1. Capturamos el archivo de entrada
INPUT="$1"
[ ! -f "$INPUT" ] && echo "Archivo no encontrado" && exit 1

# 2. Generamos el nombre de salida cambiando .pdf por .md
# ${INPUT%.pdf} quita la extensión .pdf del nombre original
OUTPUT="${INPUT%.pdf}.md"

# 3. Ejecutamos la conversión
# Usamos comillas "$..." por si el nombre tiene espacios
pdftotext -layout "$INPUT" "$OUTPUT"

echo "Convertido: $INPUT -> $OUTPUT"




