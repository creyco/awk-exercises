#!/bin/bash

INPUT="bookmark_ok.html"
OUTPUT="bookmarks_ordenados.html"

echo "Procesando bookmarks..."

# Header HTML
cat > $OUTPUT <<EOF
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks Ordenados</H1>
<DL><p>
EOF

# Función para clasificar
clasificar() {
    local text="$1"

    if [[ "$text" =~ (chatgpt|claude|gemini|grok|perplexity) ]]; then
        echo "IA/Chat"
    elif [[ "$text" =~ (openrouter|deepseek|api|model) ]]; then
        echo "IA/APIs"
    elif [[ "$text" =~ (image|video|art|diffusion) ]]; then
        echo "IA/Generacion"
    elif [[ "$text" =~ (angular|react|node|js|javascript) ]]; then
        echo "Desarrollo/JavaScript"
    elif [[ "$text" =~ (firebase|supabase|mysql|sql) ]]; then
        echo "Desarrollo/Databases"
    elif [[ "$text" =~ (vercel|netlify|aws|cloudflare) ]]; then
        echo "Desarrollo/DevOps"
    else
        echo "Otros"
    fi
}

# Procesar bookmarks
grep -oP '<A[^>]*HREF="[^"]*"[^>]*>[^<]*</A>' "$INPUT" | while read -r line; do
    url=$(echo "$line" | grep -oP 'HREF="\K[^"]+')
    title=$(echo "$line" | sed -E 's/.*>(.*)<\/A>/\1/')

    categoria=$(clasificar "$title $url")

    echo "<DT><H3>$categoria</H3>" >> $OUTPUT
    echo "<DL><p>" >> $OUTPUT
    echo "<DT><A HREF=\"$url\">$title</A>" >> $OUTPUT
    echo "</DL><p>" >> $OUTPUT

done

# Footer
echo "</DL><p>" >> $OUTPUT

echo "Listo: $OUTPUT"