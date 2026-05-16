#!/bin/bash

# Script para crear el proyecto LinkScanner
# Uso: ./linkscanner-setup.sh

echo "🔗 Instalando LinkScanner..."

# Crear estructura de carpetas
PROJECT_DIR="$HOME/linkscanner"
mkdir -p "$PROJECT_DIR"/{public,server,scripts,data}

echo "📁 Estructura creada en: $PROJECT_DIR"

# Copiar archivos del skill
SKILL_DIR="$HOME/.agents/skills/extraer-links-whatsapp/proyecto-web"

# Copiar frontend
if [ -d "$SKILL_DIR/public" ]; then
    cp -r "$SKILL_DIR/public/"* "$PROJECT_DIR/public/"
    echo "✓ Frontend copiado"
fi

# Copiar server
if [ -d "$SKILL_DIR/server" ]; then
    cp -r "$SKILL_DIR/server/"* "$PROJECT_DIR/server/"
    echo "✓ Server copiado"
fi

# Copiar scripts de extracción
if [ -d "$SKILL_DIR" ]; then
    cp "$SKILL_DIR/extraer_links.sh" "$PROJECT_DIR/scripts/" 2>/dev/null
    cp "$SKILL_DIR/extraer_metadata_creds.sh" "$PROJECT_DIR/scripts/" 2>/dev/null
    cp "$SKILL_DIR/.env.example" "$PROJECT_DIR/" 2>/dev/null
    cp "$SKILL_DIR/.env" "$PROJECT_DIR/" 2>/dev/null
    echo "✓ Scripts copiados"
fi

# Copiar SQL de Supabase
cp "$HOME/Descargas/Chat-WhatsApp/supabase_sql.txt" "$PROJECT_DIR/data/" 2>/dev/null
echo "✓ SQL copiado"

# Copiar links existentes
if [ -f "$HOME/Descargas/Chat-WhatsApp/links.txt" ]; then
    cp "$HOME/Descargas/Chat-WhatsApp/links.txt" "$PROJECT_DIR/data/"
    echo "✓ Links existentes copiados"
fi

# Crear README
cat > "$PROJECT_DIR/README.md" << 'EOF'
# LinkScanner

Aplicación web para guardar y organizar tus enlaces guardados.

## Estructura
```
linkscanner/
├── public/         # Frontend (HTML/JS/CSS)
├── server/         # Backend (API)
├── scripts/        # Scripts de extracción local
├── data/           # Datos (links, SQL)
└── README.md
```

## Setup

1. **Base de datos**: Ejecutá el SQL en Supabase
   - Archivo: `data/supabase_sql.txt`

2. **Frontend**: Subir a Vercel
   - Carpeta: `public/`
   - URL: https://vercel.com

3. **Scripts locales** (para extraer metadata):
   ```bash
   cd scripts
   chmod +x *.sh
   ./extraer_links.sh <chat.txt> <salida.txt>
   ```

## Credenciales
El archivo `.env` ya tiene configuradas las credenciales de Supabase.

## Uso
1. Registrate en la app web
2. Subí tus links o agregalos uno por uno
3. Ver historial y tendencias
EOF

echo ""
echo "========================================="
echo "🎉 LinkScanner instalado!"
echo "========================================="
echo ""
echo "Ubicación: $PROJECT_DIR"
echo ""
echo "Próximos pasos:"
echo "1. Ir a Supabase → SQL Editor → ejecutar data/supabase_sql.txt"
echo "2. Subir carpeta 'public' a Vercel"
echo "3. Listo!"
echo ""
ls -la "$PROJECT_DIR"