#!/bin/bash
# Script para descargar libros de IA/LLM/Agents
# Ejecuta con: bash download_books.sh

echo "🚀 Iniciando descarga de libros de IA..."

mkdir -p "AI_Books"
cd "AI_Books" || exit 1

# Lista de links (agrega aquí los enlaces DIRECTOS a PDFs cuando los tengas)
declare -A books

books["Understanding_Deep_Learning"]="https://udlbook.github.io/udlbook/"   # Página del libro (MIT Press - no PDF directo gratuito)
books["Building_an_LLM_from_Scratch"]="https://www.manning.com/books/build-a-large-language-model-from-scratch"
books["The_LLM_Engineering_Handbook"]="https://www.oreilly.com/library/view/llm-engineers-handbook/9781836200079/"
books["AI_Agents_The_Definitive_Guide"]="https://www.oreilly.com/library/view/ai-agents-the/0642572247775/"
books["Building_Applications_with_AI_Agents"]="https://www.oreilly.com/library/view/building-applications-with/9781098176495/"
books["AI_Agents_with_MCP"]="https://www.oreilly.com/library/view/ai-agents-with/9798341639546/"

for book in "${!books[@]}"; do
    url="${books[$book]}"
    
    echo "📥 Descargando: $book"
    
    # Intenta descargar con wget (más robusto)
    if command -v wget >/dev/null 2>&1; then
        wget -q --show-progress --content-disposition "$url" -O "${book}.pdf" 2>/dev/null || \
        echo "   ⚠️  No se pudo descargar directamente (posiblemente requiere login o no es PDF directo)"
    # Alternativa con curl
    elif command -v curl >/dev/null 2>&1; then
        curl -L -J -O "$url" 2>/dev/null || \
        echo "   ⚠️  No se pudo descargar directamente"
    else
        echo "   ❌ Error: ni wget ni curl están instalados"
        exit 1
    fi
done

echo ""
echo "✅ Descarga finalizada."
echo "📁 Los archivos se guardaron en la carpeta: $(pwd)"
echo ""
echo "Nota: La mayoría de estos libros (especialmente los de O'Reilly y Manning) requieren compra o suscripción."
echo "      Solo 'Understanding Deep Learning' tiene material gratuito en la página, pero no un PDF completo directo."
