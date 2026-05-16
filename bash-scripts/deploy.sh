#!/bin/bash
set -e
echo "🚀 Desplegando Quant Argentina..."
echo "📦 Instalando dependencias..."
pip install -r requirements.txt --quiet
echo "✅ Deploy finalizado. Iniciando servicio..."
# uvicorn src.api.main:app --host 0.0.0.0 --port 8000
