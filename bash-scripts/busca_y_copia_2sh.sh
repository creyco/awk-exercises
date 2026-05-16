#!/bin/bash

origen=$1
destino=$2

# Lista de carpetas a excluir (nombres simples o rutas relativas)
excluir=(
  "scripts"
  "test"
  "deprecated"
  "temp"
)

#mkdir -p "$destino"

# Construir comando find con exclusiones
find_cmd="find \"$origen\""

for carpeta in "${excluir[@]}"; do
  find_cmd+=" -path \"$origen/$carpeta\" -prune -o"
done

find_cmd+=" -type f -name \"*.sh\" -print"

# Ejecutar y copiar
eval "$find_cmd" | while read archivo; do
  cp "$archivo" "$destino/"
  echo "Copiado: $archivo"
done

echo "Copiado completado (excluyendo: ${excluir[*]})"
