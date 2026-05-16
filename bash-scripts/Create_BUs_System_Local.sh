#!/usr/bin/env bash
# =============================================================================
# Update_BUs_System_Local.sh - Generador Business Units
# Usa archivos prompt JSON locales generados por Kimi
# =============================================================================

set -euo pipefail   # Mucho más seguro: errores + variables no definidas + pipefail

# =============================================================================
# CONFIGURACIÓN GLOBAL
# =============================================================================
SISTEMA="Business Units Control System"
NAME="BUs_System"
VERSION="2.0.0"

# Ruta al archivo prompt JSON local (generado por Kimi)
PROMPT_JSON_PATH="${PROMPT_JSON_PATH:-./latest-prompt.json}"

# Colores para output (ANSI)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# FUNCIONES UTILITARIAS
# =============================================================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1   # ← agrego exit para que falle fuerte en errores
}

log_section() {
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
}

# =============================================================================
# VERIFICAR DEPENDENCIAS
# =============================================================================

check_dependencies() {
    log_section "VERIFICANDO DEPENDENCIAS"
    
    local deps=("node" "npm" "jq")   # ← agrego jq que se usa después
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Faltan dependencias: ${missing[*]}"
        # Podrías agregar aquí cómo instalarlas si querés
        exit 1
    fi
    
    log_success "Todas las dependencias están instaladas"
}

# =============================================================================
# COPIAR PROMPT JSON LOCAL
# =============================================================================

copy_prompt_json() {
    log_section "CONFIGURANDO PROMPT JSON"
    
    local prompts_dir=".docs/prompts"
    mkdir -p "$prompts_dir"
    
    # Verificar si existe el archivo local
    if [ -f "$PROMPT_JSON_PATH" ]; then
        cp "$PROMPT_JSON_PATH" "$prompts_dir/latest-prompt.json"
        log_success "Prompt JSON copiado desde: $PROMPT_JSON_PATH"
        
        # Extraer información del prompt (si jq está disponible)
        if command -v jq &> /dev/null; then
            local prompt_name
            prompt_name=$(jq -r '.prompt.name // "unknown"' "$prompts_dir/latest-prompt.json" 2>/dev/null)
            
            local prompt_version
            prompt_version=$(jq -r '.prompt.version // "unknown"' "$prompts_dir/latest-prompt.json" 2>/dev/null)
            
            log_info "Prompt: $prompt_name v$prompt_version"
        fi
    else
        log_warning "No se encontró archivo prompt en: $PROMPT_JSON_PATH"
        log_info "Creando prompt por defecto..."
        create_default_prompt "$prompts_dir/latest-prompt.json"
    fi
    
    # Crear prompts adicionales
    create_additional_prompts "$prompts_dir"
    
    log_success "Prompts configurados en: $prompts_dir"
}

create_default_prompt() {
    local output_path="$1"
    
    cat > "$output_path" << 'EOF'
{
  "prompt": {
    "name": "BUs_Default_Prompt",
    "version": "1.0.0",
    "description": "Prompt por defecto para Business Units",
    "system_role": "Eres un experto desarrollador React Native Expo.",
    "rules": [
      "SIEMPRE usa useTheme() para colores",
      "NUNCA uses estilos inline",
      "Usa TypeScript con tipos estrictos"
    ],
    "architecture": {
      "pattern": "Hexagonal",
      "layers": ["domain", "application", "infrastructure", "ui"]
    }
  }
}
EOF
}
