#!/bin/bash
# ======================================================
# Script: font_manager.sh
# Interfaz unificada para gestionar fuentes
# ======================================================
DIR="/scripts"
INDEX_FILE="$HOME$DIR/.font_index.txt"

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

show_menu() {
    clear
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}        🎨 GESTOR DE FUENTES - SIN DUPLICADOS 🎨${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}1)${NC} Actualizar índice de fuentes"
    echo -e "${GREEN}2)${NC} Buscar una fuente"
    echo -e "${GREEN}3)${NC} Instalar fuente (por número o nombre)"
    echo -e "${GREEN}4)${NC} Listar fuentes NO instaladas"
    echo -e "${GREEN}5)${NC} Listar fuentes YA instaladas"
    echo -e "${GREEN}6)${NC} Estadísticas del sistema"
    echo -e "${RED}0)${NC} Salir"
    echo ""
    echo -n "Opción: "
}

show_stats() {
    echo -e "${BLUE}📊 Estadísticas:${NC}"
    echo "   Total fuentes en índice: $(wc -l < "$INDEX_FILE" 2>/dev/null || echo 0)"
    echo "   Fuentes instaladas: $(grep -c "$HOME/.local/share/fonts" "$INDEX_FILE" 2>/dev/null || echo 0)"
    echo "   Espacio usado: $(du -sh ~/.local/share/fonts 2>/dev/null | cut -f1 || echo 0)"
    echo "   Archivos .ttf en home: $(find ~ -name "*.ttf" 2>/dev/null | wc -l)"
}

# Verificar/crear índice
if [ ! -f "$INDEX_FILE" ]; then
    echo -e "${YELLOW}⚠️  No existe índice. Creando...${NC}"
    ./index_fonts.sh
fi

while true; do
    show_menu
    read -r option
    case $option in
        1) ./index_fonts.sh; read -p "Presiona Enter para continuar..." ;;
        2) 
            read -p "Nombre a buscar: " search
            ./search_font.sh "$search"
            read -p "Presiona Enter para continuar..."
            ;;
        3)
            read -p "Número o nombre: " target
            ./install_from_index.sh "$target"
            read -p "Presiona Enter para continuar..."
            ;;
        4) ./install_from_index.sh --list; read -p "Presiona Enter para continuar..." ;;
        5) ./install_from_index.sh --installed; read -p "Presiona Enter para continuar..." ;;
        6) show_stats; read -p "Presiona Enter para continuar..." ;;
        0) echo -e "${GREEN}👋 ¡Hasta luego!${NC}"; exit 0 ;;
        *) echo -e "${YELLOW}Opción inválida${NC}"; sleep 1 ;;
    esac
done
