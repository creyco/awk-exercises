#!/bin/bash
# ======================================================
# Script: install_from_index.sh
# Instala una fuente usando el índice (evita duplicados)
# ======================================================

DIR="/scripts"
INDEX_FILE="$HOME$DIR/.font_index.txt"
DEST_DIR="$HOME/.local/share/fonts"
INSTALLED_LOG="$HOME$DIR/.fonts_installed.log"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Crear carpetas necesarias
mkdir -p "$DEST_DIR"

# Verificar índice
if [ ! -f "$INDEX_FILE" ]; then
    echo -e "${RED}❌ No existe el índice. Ejecuta: ./index_fonts.sh${NC}"
    exit 1
fi

# Función para mostrar uso
usage() {
    echo -e "${YELLOW}Uso:${NC}"
    echo "  $0 <número|nombre>"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 3                    # Instala la fuente número 3 del último listado"
    echo "  $0 Coolvetica           # Busca e instala la primera coincidencia"
    echo "  $0 --list               # Lista todas las fuentes NO instaladas"
    echo "  $0 --installed          # Lista las ya instaladas"
    exit 1
}

# Listar fuentes NO instaladas
if [ "$1" == "--list" ]; then
    echo -e "${BLUE}📋 Fuentes NO instaladas:${NC}"
    grep -v "$DEST_DIR" "$INDEX_FILE" | while read -r line; do
        RUTA=$(echo "$line" | cut -d'|' -f2)
        NOMBRE=$(echo "$line" | cut -d'|' -f3)
        echo -e "   ${YELLOW}○${NC} $NOMBRE → $RUTA"
    done
    exit 0
fi

# Listar fuentes YA instaladas
if [ "$1" == "--installed" ]; then
    echo -e "${GREEN}✅ Fuentes YA instaladas en $DEST_DIR:${NC}"
    grep "$DEST_DIR" "$INDEX_FILE" | while read -r line; do
        NOMBRE=$(echo "$line" | cut -d'|' -f3)
        RUTA=$(echo "$line" | cut -d'|' -f2)
        echo -e "   ${GREEN}✓${NC} $NOMBRE"
    done
    exit 0
fi

# Si el argumento es un número
if [[ "$1" =~ ^[0-9]+$ ]]; then
    # Obtener la línea número N del índice
    SELECTED_LINE=$(sed -n "${1}p" "$INDEX_FILE")
    if [ -z "$SELECTED_LINE" ]; then
        echo -e "${RED}❌ No existe la fuente número $1${NC}"
        exit 1
    fi
    SOURCE_FILE=$(echo "$SELECTED_LINE" | cut -d'|' -f2)
else
    # Buscar por nombre
    SEARCH_TERM="$1"
    RESULTS=$(grep -i "$SEARCH_TERM" "$INDEX_FILE" | head -1)
    
    if [ -z "$RESULTS" ]; then
        echo -e "${RED}❌ No se encontró: $SEARCH_TERM${NC}"
        echo -e "${YELLOW}💡 Usa './search_font.sh $SEARCH_TERM' para ver más opciones${NC}"
        exit 1
    fi
    
    SOURCE_FILE=$(echo "$RESULTS" | cut -d'|' -f2)
fi

BASENAME=$(basename "$SOURCE_FILE")
DEST_FILE="$DEST_DIR/$BASENAME"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📦 Instalando fuente: $BASENAME${NC}"
echo -e "${BLUE}📁 Origen: $SOURCE_FILE${NC}"
echo -e "${BLUE}📁 Destino: $DEST_FILE${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# ======================================================
# VERIFICACIONES ANTIDUPLICADO
# ======================================================

# Verificación 1: ¿Ya existe el archivo en destino?
if [ -f "$DEST_FILE" ]; then
    echo -e "${YELLOW}⚠️  Ya existe un archivo con el mismo nombre en destino${NC}"
    
    # Comparar contenido (MD5)
    MD5_SOURCE=$(md5sum "$SOURCE_FILE" | cut -d' ' -f1)
    MD5_DEST=$(md5sum "$DEST_FILE" | cut -d' ' -f1)
    
    if [ "$MD5_SOURCE" == "$MD5_DEST" ]; then
        echo -e "${RED}❌ La fuente YA está instalada (mismo contenido). Cancelando.${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠️  Existe pero con contenido diferente.${NC}"
        read -p "¿Sobrescribir? [s/N]: " overwrite
        if [[ ! "$overwrite" =~ ^[Ss]$ ]]; then
            echo -e "${RED}❌ Cancelado por el usuario.${NC}"
            exit 0
        fi
    fi
fi

# Verificación 2: Buscar por MD5 en todo el destino (mismo contenido, otro nombre)
echo -e "${BLUE}🔍 Verificando si el contenido ya existe...${NC}"
MD5_SOURCE=$(md5sum "$SOURCE_FILE" | cut -d' ' -f1)

EXISTING_BY_MD5=$(find "$DEST_DIR" -type f -exec md5sum {} \; 2>/dev/null | grep "$MD5_SOURCE")

if [ -n "$EXISTING_BY_MD5" ]; then
    EXISTING_FILE=$(echo "$EXISTING_BY_MD5" | cut -d' ' -f2)
    echo -e "${RED}❌ El CONTENIDO de esta fuente YA existe en:${NC}"
    echo -e "${RED}   $EXISTING_FILE${NC}"
    echo -e "${YELLOW}No se instalará para evitar duplicados.${NC}"
    exit 0
fi

# ======================================================
# INSTALACIÓN
# ======================================================

echo -e "${GREEN}📦 Copiando fuente...${NC}"
cp "$SOURCE_FILE" "$DEST_DIR/"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Fuente copiada exitosamente${NC}"
    
    # Registrar en log de instalación
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $BASENAME | $SOURCE_FILE" >> "$INSTALLED_LOG"
    
    # Actualizar caché
    echo -e "${BLUE}🔄 Actualizando caché de fuentes...${NC}"
    fc-cache -fv "$DEST_DIR" 2>/dev/null
    
    # Verificar
    FONT_NAME_CLEAN=$(basename "$BASENAME" .ttf | basename - .otf)
    if fc-list | grep -qi "$FONT_NAME_CLEAN"; then
        echo -e "${GREEN}✅ Fuente reconocida por el sistema${NC}"
    else
        echo -e "${YELLOW}⚠️  Reinicia GIMP para ver la fuente${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✨ ¡Fuente instalada sin duplicados! ✨${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
else
    echo -e "${RED}❌ Error al copiar la fuente${NC}"
    exit 1
fi
