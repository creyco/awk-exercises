#!/bin/bash

# script.sh - Clasificador de sitios web por contenido
# Lee URLs de sinclasificar.txt y clasifica por tema detectado

TEMP_DIR="/tmp/web_classifier_$$"

ARCHIVO_ENTRADA="sin_clasificar.txt"
ARCHIVO_SALIDA="clasificados.txt"
MAX_SIZE=1048576  # 1MB max para evitar abusos

mkdir -p "$TEMP_DIR"

# Función para limpiar al salir
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Función para descargar página (con timeout y límites)
descargar_pagina() {
    local url="$1"
    local output="$2"
    
    # Timeout de 10s, max 1MB
    curl -s -L -m 10 --max-filesize "$MAX_SIZE" --user-agent "Mozilla/5.0" "$url" -o "$output" 2>/dev/null
}

# Función para detectar categoría por palabras clave
detectar_categoria() {
    local contenido="$1"
    
    # Contar palabras clave por categoría (case insensitive)
    local ecomm_count=$(echo "$contenido" | tr '[:upper:]' '[:lower:]' | grep -c -E "(cart|buy|shop|product|price|add to cart|paypal|stripe)")
    local blog_count=$(echo "$contenido" | tr '[:upper:]' '[:lower:]' | grep -c -E "(blog|article|post|author|published|subscribe)")
    local foro_count=$(echo "$contenido" | tr '[:upper:]' '[:lower:]' | grep -c -E "(forum|thread|reply|post|user|register)")
    local login_count=$(echo "$contenido" | tr '[:upper:]' '[:lower:]' | grep -c -E "(login|sign in|password|dashboard|admin)")
    local news_count=$(echo "$contenido" | tr '[:upper:]' '[:lower:]' | grep -c -E "(news|headline|breaking|latest)")
    local porn_count=$(echo "$contenido" | tr '[:upper:]' '[:lower:]' | grep -c -E "(porn|sex|xxx|nude|adult)")
    
    # Categoría dominante
    local max_score=0
    local categoria="Otros"
    
    [ "$ecomm_count" -gt $max_score ] && { max_score=$ecomm_count; categoria="E-commerce"; }
    [ "$blog_count" -gt $max_score ] && { max_score=$blog_count; categoria="Blog"; }
    [ "$foro_count" -gt $max_score ] && { max_score=$foro_count; categoria="Foro"; }
    [ "$login_count" -gt $max_score ] && { max_score=$login_count; categoria="Login/Admin"; }
    [ "$news_count" -gt $max_score ] && { max_score=$news_count; categoria="Noticias"; }
    [ "$porn_count" -gt $max_score ] && { max_score=$porn_count; categoria="Adulto"; }
    
    echo "$categoria"
}

# Función para obtener título y descripción básica
obtener_info_basica() {
    local contenido="$1"
    local titulo=$(echo "$contenido" | grep -i "<title>" | sed 's/.*<title[^>]*>\s*\([^<]*\).* /\1/i' | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    local desc=$(echo "$contenido" | grep -i '<meta name="description"' | sed 's/.*content="\([^"]*\)".*/\1/' | head -1)
    
    [ -z "$titulo" ] && titulo="Sin título"
    [ -z "$desc" ] && desc="Sin descripción"
    
    printf "T: %s | D: %s" "$titulo" "$desc"
}

echo "[+] Iniciando clasificación de $(wc -l < "$ARCHIVO_ENTRADA") URLs..."
echo

# Procesar cada URL
declare -A categorias
total=0
exitos=0

while IFS= read -r url || [[ -n "$url" ]]; do
    url=$(echo "$url" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [ -z "$url" ] && continue
    
    total=$((total + 1))
    echo -n "[$total] Verificando: $url ... "
    
    temp_file="$TEMP_DIR/$(basename "$url" | sed 's/[^a-zA-Z0-9.-]/_/g')"
    
    if descargar_pagina "$url" "$temp_file"; then
        if [ -s "$temp_file" ]; then
            contenido=$(cat "$temp_file")
            categoria=$(detectar_categoria "$contenido")
            info_basica=$(obtener_info_basica "$contenido")
            
            echo "OK [$categoria] - $info_basica"
            exitos=$((exitos + 1))
            
            # Registrar en categoría
            categorias["$categoria"]+="$url [$info_basica]\n"
            
            # Línea para archivo de salida
            echo "$url|$categoria|$info_basica" >> "$ARCHIVO_SALIDA"
        else
            echo "VACÍO"
        fi
    else
        echo "ERROR/NO EXISTE"
    fi
done < "$ARCHIVO_ENTRADA"

echo
echo "[+] Resumen:"
echo "   Procesadas: $total"
echo "   Exitosas: $exitos"
echo "   Archivo consolidado: $ARCHIVO_SALIDA"

# Mostrar resumen por categoría
echo
echo "=== RESUMEN POR CATEGORÍA ==="
for cat in "${!categorias[@]}"; do
    count=$(echo -e "${categorias[$cat]}" | wc -l)
    echo "[$cat]: $count sitios"
done | sort -k2 -nr

echo
echo "[+] Detalles por categoría guardados en $ARCHIVO_SALIDA (formato: url|categoria|info)"
echo "[+] Archivos temporales limpiados automáticamente"
