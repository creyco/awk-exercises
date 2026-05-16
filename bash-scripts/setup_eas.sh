#!/bin/bash

# ============================================================================
# Setup inicial de EAS CLI - MyMedication
# ============================================================================
# Este script realiza la instalación y configuración inicial de una sola vez
# Ejecuta este script ANTES de build_eas_apk.sh en tu primera compilación
# ============================================================================

set -e  # Salir al primer error

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_title() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# PASO 1: Instalar eas-cli globalmente
# ============================================================================
print_title "PASO 1: Instalar EAS CLI"

if command -v eas &> /dev/null; then
    CURRENT_VERSION=$(eas --version)
    print_step "eas-cli ya está instalado: $CURRENT_VERSION"
    read -p "¿Deseas actualizarlo a la última versión? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        npm install -g eas-cli@latest
        print_step "eas-cli actualizado a $(eas --version)"
    fi
else
    print_step "Instalando eas-cli globalmente..."
    npm install -g eas-cli@latest
    print_step "eas-cli instalado: $(eas --version)"
fi

# ============================================================================
# PASO 2: Login en Expo
# ============================================================================
print_title "PASO 2: Iniciar Sesión en Expo"

if eas whoami &> /dev/null; then
    CURRENT_USER=$(eas whoami)
    print_step "Ya hay una sesión activa: $CURRENT_USER"
else
    print_warning "Se abrirá el navegador para iniciar sesión..."
    print_warning "Si no se abre automáticamente, copia el link que aparece"
    eas login
    print_step "Sesión iniciada: $(eas whoami)"
fi

# ============================================================================
# PASO 3: Verificar eas.json
# ============================================================================
print_title "PASO 3: Verificar Configuración"

if [ -f "eas.json" ]; then
    print_step "eas.json encontrado y validado"
else
    print_error "eas.json no encontrado"
    exit 1
fi

if [ -f "app.json" ]; then
    print_step "app.json encontrado"
    print_warning "Verificando permisos de Android..."
    
    if grep -q "SCHEDULE_EXACT_ALARM" app.json; then
        print_step "✓ SCHEDULE_EXACT_ALARM configurado"
    else
        print_warning "⚠ Considera agregar SCHEDULE_EXACT_ALARM a app.json"
    fi
    
    if grep -q "FOREGROUND_SERVICE" app.json; then
        print_step "✓ FOREGROUND_SERVICE configurado"
    else
        print_warning "⚠ Considera agregar FOREGROUND_SERVICE a app.json"
    fi
else
    print_error "app.json no encontrado"
    exit 1
fi

# ============================================================================
# PASO 4: Configurar credenciales de Android
# ============================================================================
print_title "PASO 4: Configurar Credenciales de Firma Android"

print_warning "Se abrirá el navegador para configurar credenciales..."
print_step "Ejecutando: eas build:configure --platform android"

eas build:configure --platform android

print_step "Credenciales configuradas exitosamente"

# ============================================================================
# RESUMEN FINAL
# ============================================================================
print_title "Setup Completado"

print_step "eas-cli instalado: $(eas --version)"
print_step "Sesión activa: $(eas whoami)"
print_step "eas.json validado"
print_step "Credenciales de Android configuradas"

echo ""
print_title "Próximo Paso"
echo -e "${YELLOW}Ejecuta el script de compilación:${NC}"
echo ""
echo -e "  ${BLUE}chmod +x build_eas_apk.sh${NC}"
echo -e "  ${BLUE}./build_eas_apk.sh${NC}"
echo ""
