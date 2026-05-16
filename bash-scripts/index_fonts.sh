#!/bin/bash
# ======================================================
# Script: index_fonts.sh
# Genera un archivo con todas las fuentes .ttf existentes
# ======================================================

INDEX_FILE="$HOME/.font_index.txt"
DEST_DIR="$HOME/.local/share/fonts"

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📊 Generando índice de fuentes TrueType (.ttf)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Crear archivo de índice (vacío o sobrescribir)
> "$INDEX_FILE"

# Contador
TOTAL=0

echo -e "${YELLOW}🔍 Escaneando...${NC}"

# Buscar todos los .ttf en el home (excluyendo .cache y .snap para velocidad)
find "$HOME" -type f -name "*.ttf" 2>/dev/null | while read -r font; do
    # Obtener información del archivo
    BASENAME=$(basename "$font")
    SIZE=$(du -h "$font" | cut -f1)
    MD5=$(md5sum "$font" | cut -d' ' -f1)
    
    # Formato: MD5|RUTA|NOMBRE|TAMAÑO
    echo "$MD5|$font|$BASENAME|$SIZE" >> "$INDEX_FILE"
    TOTAL=$((TOTAL + 1))
    
    # Mostrar progreso cada 50 fuentes
    if [ $((TOTAL % 50)) -eq 0 ]; then
        echo -e "${BLUE}   Procesadas: $TOTAL fuentes${NC}"
    fi
done

# Contar líneas finales
FINAL_COUNT=$(wc -l < "$INDEX_FILE" 2>/dev/null)

echo -e "${GREEN}✅ Índice generado: $INDEX_FILE${NC}"
echo -e "${GREEN}📊 Total de fuentes indexadas: $FINAL_COUNT${NC}"
echo -e "${BLUE}📁 Tamaño del índice: $(du -h "$INDEX_FILE" | cut -f1)${NC}"

# Mostrar primeras líneas como preview
echo ""
echo -e "${YELLOW}📋 Vista previa (primeras 3 líneas):${NC}"
head -3 "$INDEX_FILE" | while read -r line; do
    echo "   $line"
done

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ Índice creado exitosamente ✨${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
