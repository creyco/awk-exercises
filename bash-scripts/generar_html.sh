#!/bin/bash
# generar_html.sh - Crea archivo HTML compatible con Chrome/Firefox

BASE_DIR="${1:-bookmarks_organizados}"
OUTPUT="${2:-bookmarks_export.html}"

cat > "$OUTPUT" << 'HEADER'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks Organizados - Cris</TITLE>
<H1>Bookmarks</H1>
<DL><p>
HEADER

# Función para agregar carpeta con bookmarks
agregar_carpeta() {
    local nombre="$1"
    local ruta="$2"
    
    echo "    <DT><H3 ADD_DATE=\"$(date +%s)\" LAST_MODIFIED=\"$(date +%s)\">$nombre</H3>" >> "$OUTPUT"
    echo "    <DL><p>" >> "$OUTPUT"
    
    if [ -f "$ruta/bookmarks.txt" ]; then
        while IFS= read -r url; do
            [ -z "$url" ] && continue
            # Extraer título simple del dominio
            titulo=$(echo "$url" | sed -E 's|https?://(www\.)?([^/]+).*|\2|' | sed 's/\.[^.]*$//')
            echo "        <DT><A HREF=\"$url\" ADD_DATE=\"$(date +%s)\">$titulo</A>" >> "$OUTPUT"
        done < "$ruta/bookmarks.txt"
    fi
    
    echo "    </DL><p>" >> "$OUTPUT"
}

# Agregar carpetas en orden de prioridad
agregar_carpeta "🚀 01_FLUJO_TRABAJO_IA" "$BASE_DIR/01_FLUJO_TRABAJO_IA"
agregar_carpeta "💻 02_DESARROLLO_ARQUITECTURA" "$BASE_DIR/02_DESARROLLO_ARQUITECTURA"
agregar_carpeta "🎮 03_JUEGOS_RECURSOS" "$BASE_DIR/03_JUEGOS_RECURSOS"
agregar_carpeta "📚 04_APRENDIZAJE_IDIOMAS" "$BASE_DIR/04_APRENDIZAJE_IDIOMAS"
agregar_carpeta "📋 05_PERSONAL_ADMIN" "$BASE_DIR/05_PERSONAL_ADMIN"

# URLs sin clasificar (si existen)
if [ -d "$BASE_DIR/00_SIN_CLASIFICAR" ] && [ -f "$BASE_DIR/00_SIN_CLASIFICAR/bookmarks.txt" ]; then
    agregar_carpeta "❓ 00_SIN_CLASIFICAR" "$BASE_DIR/00_SIN_CLASIFICAR"
fi

echo "</DL><p>" >> "$OUTPUT"
echo "✅ HTML generado: $OUTPUT (listo para importar en Chrome/Firefox)"
