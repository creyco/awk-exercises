#!/bin/bash
# ======================================================
# Script: search_font.sh
# Busca fuentes en el índice y muestra resultados
# ======================================================

DIR="/scripts"
INDEX_FILE="$HOME$DIR/.font_index.txt"
DEST_DIR="$HOME$DIR/.local/share/fonts"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Verificar que existe el índice
if [ ! -f "$INDEX_FILE" ]; then
    echo -e "${RED}❌ No existe el índice. Ejecuta primero: ./index_fonts.sh${NC}"
    exit 1
fi

# Mostrar uso si no hay argumentos
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Uso:${NC}"
    echo "  $0 <nombre_de_fuente>"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 Coolvetica"
    echo "  $0 Roboto"
    echo "  $0 \".*Mono.*\"   # Búsqueda con regex"
    echo ""
    echo -e "${BLUE}📊 Estadísticas del índice:${NC}"
    echo "   Total fuentes: $(wc -l < "$INDEX_FILE")"
    echo "   Tamaño total: $(du -h "$INDEX_FILE" | cut -f1)"
    exit 0
fi

SEARCH_TERM="$1"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🔍 Buscando: $SEARCH_TERM${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Buscar en el índice (coincidencia en nombre de archivo o ruta)
RESULTS=$(grep -i "$SEARCH_TERM" "$INDEX_FILE")

if [ -z "$RESULTS" ]; then
    echo -e "${RED}❌ No se encontraron fuentes con: $SEARCH_TERM${NC}"
    exit 1
fi

# Contar resultados
COUNT=$(echo "$RESULTS" | wc -l)

echo -e "${GREEN}✅ Encontradas $COUNT coincidencias:${NC}"
echo ""

# Mostrar resultados numerados
echo "$RESULTS" | nl -w2 -s'. ' | while read -r line; do
    # Extraer solo la ruta y el nombre para mostrar
    RUTA=$(echo "$line" | cut -d'|' -f2)
    NOMBRE=$(echo "$line" | cut -d'|' -f3)
    TAMANO=$(echo "$line" | cut -d'|' -f4)
    
    # Determinar si ya está en destino
    if [[ "$RUTA" == "$DEST_DIR"* ]]; then
        STATUS="${GREEN}[✓ INSTALADA]${NC}"
    else
        STATUS="${YELLOW}[ ] NO INSTALADA${NC}"
    fi
    
    echo -e "$line" | cut -d'|' -f2 | sed 's/^/   /'
    echo -e "      📦 Tamaño: $TAMANO | $STATUS"
    echo ""
done

echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}💡 Para instalar alguna, usa: ./install_from_index.sh <número>${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
