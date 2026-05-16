#!/bin/bash
# Guarda esto como ~/link-models.sh

MODELS_DIR="$HOME/.local/share/llama.cpp/models"
mkdir -p "$MODELS_DIR"

# Mapeo de hashes a nombres legibles (actualiza según tus modelos)
declare -A MODEL_NAMES=(
    ["sha256-afb707b6b8fac6e475acc42bc8380fc0b8d2e0e4190be5a969fbf62fcc897db5"]="qwen-1b.gguf"
    ["sha256-4c27e0f5b5adf02ac956c7322bd2ee7636fe3f45a8512c9aba5385242cb6e09a"]="modelo-grande-9gb.gguf"
    ["sha256-dec52a44569a2a25341c4e4d3fee25846eed4f6f0b936278e3a3c900bb99d37c"]="modelo-medio-6gb.gguf"
)

for hash in "${!MODEL_NAMES[@]}"; do
    source_file="/usr/share/ollama/.ollama/models/blobs/$hash"
    if [ -f "$source_file" ]; then
        ln -sf "$source_file" "$MODELS_DIR/${MODEL_NAMES[$hash]}"
        echo "✓ Creado enlace: ${MODEL_NAMES[$hash]}"
    fi
done

echo ""
echo "📁 Todos los modelos están en: $MODELS_DIR"
echo "💡 Ahora puedes usarlos con: ./llama-cli -m ~/.local/share/llama.cpp/models/qwen-1b.gguf"
