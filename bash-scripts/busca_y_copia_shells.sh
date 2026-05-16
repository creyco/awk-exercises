#!/bin/bash

# Directorio de origen (ajusta la ruta según tu caso)
origen="/mnt/sd3"

# Directorio destino
destino="/mnt/sd2/scripts"

# Crear directorio destino si no existe
# mkdir -p "$destino"

# Buscar archivos *.sh y copiarlos
find "$origen" -type f -name "*.sh" -exec cp {} "$destino" \;

# Mensaje de confirmación
echo "Archivos .sh copiados de $origen a $destino"
