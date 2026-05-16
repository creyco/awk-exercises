#!/bin/bash

# =============================================
# Script para crear la estructura completa del proyecto SFI-SaaS
# Multi-tenant POS System (FastAPI + React)
# =============================================

PROJECT_NAME="sfi-saas"
echo "🚀 Creando estructura completa del proyecto: $PROJECT_NAME"

# Crear directorio principal
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# ====================== BACKEND ======================
echo "📁 Creando estructura del Backend..."

mkdir -p backend/app/core
mkdir -p backend/app/models
mkdir -p backend/app/schemas
mkdir -p backend/app/crud
mkdir -p backend/app/routers
mkdir -p backend/app/utils

mkdir -p backend/alembic/versions

# Archivos vacíos importantes del backend
touch backend/app/__init__.py
touch backend/app/core/__init__.py
touch backend/app/models/__init__.py
touch backend/app/schemas/__init__.py
touch backend/app/crud/__init__.py
touch backend/app/routers/__init__.py
touch backend/app/utils/__init__.py

touch backend/main.py
touch backend/requirements.txt
touch backend/Dockerfile
touch backend/.env.example
touch backend/alembic.ini
touch backend/alembic/env.py

# ====================== FRONTEND ======================
echo "📁 Creando estructura del Frontend (React + Vite)..."

mkdir -p frontend/src/components
mkdir -p frontend/src/pages
mkdir -p frontend/src/store
mkdir -p frontend/src/lib
mkdir -p frontend/src/hooks
mkdir -p frontend/public

touch frontend/src/main.tsx
touch frontend/src/App.tsx
touch frontend/vite.config.ts
touch frontend/package.json
touch frontend/Dockerfile
touch frontend/.env.example

# ====================== RAÍZ DEL PROYECTO ======================
echo "📁 Creando archivos raíz..."

touch docker-compose.yml
touch README.md
touch .gitignore
touch .env.example

# ====================== Contenido inicial de archivos clave ======================

cat > README.md << EOF
# SFI-SaaS - Sistema de Facturación e Inventarios (Multi-Tenant)

Sistema POS completo inspirado en SFI v5.6, desarrollado como SaaS con soporte multi-empresa (subdominios).

## Tecnologías
- Backend: FastAPI + SQLAlchemy 2.0 + PostgreSQL
- Frontend: React 19 + TypeScript + Tailwind + shadcn/ui
- Multi-tenancy: Tenant por subdominio

## Cómo ejecutar

\`\`\`bash
docker-compose up --build
\`\`\`
EOF

cat > .gitignore << EOF
__pycache__/
*.pyc
.env
node_modules/
dist/
.env.local
EOF

echo "✅ Estructura completa creada exitosamente!"
echo ""
echo "📂 Estructura generada:"
tree -L 3 2>/dev/null || echo "(Instala tree con: sudo apt install tree si quieres ver el árbol)"

echo ""
echo "🔥 Próximo paso:"
echo "cd $PROJECT_NAME"
echo "Luego puedes pegar los modelos SQLAlchemy que te di anteriormente en backend/app/models/"

