#!/bin/bash

# ============================================================================
# VALIDACIÓN DE CONFIGURACIÓN EAS BUILD
# ============================================================================
# Este script verifica que todo está correctamente configurado
# ============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ $1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
}

print_check() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# START VALIDATION
# ============================================================================

print_header "VALIDACIÓN DE CONFIGURACIÓN EAS BUILD"

echo ""
echo "VERIFICANDO ARCHIVOS DEL PROYECTO..."
echo "─────────────────────────────────────"

# Check eas.json
if [ -f "eas.json" ]; then
    print_check "eas.json encontrado"
    if grep -q '"buildType": "apk"' eas.json; then
        print_check "buildType: apk configurado (perfil preview)"
    else
        print_error "buildType: apk NO encontrado en eas.json"
    fi
else
    print_error "eas.json NO encontrado"
fi

# Check app.json
if [ -f "app.json" ]; then
    print_check "app.json encontrado"
    
    # Verificar permisos críticos
    if grep -q "SCHEDULE_EXACT_ALARM" app.json; then
        print_check "SCHEDULE_EXACT_ALARM configurado (SKILL PharmaGuard)"
    else
        print_warning "SCHEDULE_EXACT_ALARM NO encontrado (crítico para alertas exactas)"
    fi
    
    if grep -q "FOREGROUND_SERVICE" app.json; then
        print_check "FOREGROUND_SERVICE configurado (SKILL PharmaGuard)"
    else
        print_warning "FOREGROUND_SERVICE NO encontrado (crítico para servicio en background)"
    fi
    
    if grep -q "POST_NOTIFICATIONS" app.json; then
        print_check "POST_NOTIFICATIONS configurado"
    fi
    
    if grep -q "WAKE_LOCK" app.json; then
        print_check "WAKE_LOCK configurado"
    fi
    
else
    print_error "app.json NO encontrado"
fi

echo ""
echo "VERIFICANDO SCRIPTS..."
echo "──────────────────────"

# Check setup script
if [ -f "setup_eas.sh" ]; then
    print_check "setup_eas.sh encontrado"
    if [ -x "setup_eas.sh" ]; then
        print_check "setup_eas.sh es ejecutable"
    else
        print_warning "setup_eas.sh NO es ejecutable (ejecuta: chmod +x setup_eas.sh)"
    fi
else
    print_error "setup_eas.sh NO encontrado"
fi

# Check build script
if [ -f "build_eas_apk.sh" ]; then
    print_check "build_eas_apk.sh encontrado"
    if [ -x "build_eas_apk.sh" ]; then
        print_check "build_eas_apk.sh es ejecutable"
    else
        print_warning "build_eas_apk.sh NO es ejecutable (ejecuta: chmod +x build_eas_apk.sh)"
    fi
else
    print_error "build_eas_apk.sh NO encontrado"
fi

echo ""
echo "VERIFICANDO DOCUMENTACIÓN..."
echo "────────────────────────────"

docs=(
    "EAS_BUILD_SETUP.md"
    "EAS_BUILD_STATUS.md"
    "CHECKLIST.md"
    "INSTALL_EAS_CLI.sh"
    "QUICK_REFERENCE.sh"
    "INDEX.md"
)

for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        size=$(du -h "$doc" | cut -f1)
        print_check "$doc ($size)"
    else
        print_warning "$doc NO encontrado"
    fi
done

echo ""
echo "VERIFICANDO HERRAMIENTAS DEL SISTEMA..."
echo "────────────────────────────────────────"

# Check npm
if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
    print_check "npm instalado (v$npm_version)"
else
    print_error "npm NO está instalado"
fi

# Check eas-cli
if command -v eas &> /dev/null; then
    eas_version=$(eas --version)
    print_check "eas-cli instalado ($eas_version)"
else
    print_warning "eas-cli NO está instalado (necesario ejecutar: npm install -g eas-cli@latest)"
fi

# Check adb
if command -v adb &> /dev/null; then
    print_check "adb instalado (necesario para instalar APK en dispositivo)"
else
    print_warning "adb NO está instalado (necesario para instalar APK)"
fi

# Check node
if command -v node &> /dev/null; then
    node_version=$(node --version)
    print_check "Node.js instalado ($node_version)"
else
    print_error "Node.js NO está instalado"
fi

echo ""
echo "VERIFICANDO SESIÓN EXPO..."
echo "──────────────────────────"

if command -v eas &> /dev/null; then
    if eas whoami &> /dev/null; then
        user=$(eas whoami)
        print_check "Sesión Expo activa: $user"
    else
        print_warning "NO hay sesión Expo activa (ejecuta: eas login)"
    fi
else
    print_info "eas-cli no está instalado aún (no se puede verificar sesión)"
fi

echo ""
echo "RESUMEN DE CONFIGURACIÓN..."
echo "──────────────────────────"

echo -e ""
echo -e "Configuración del Proyecto:"
echo -e "  Package: $(grep '"package"' app.json | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
echo -e "  App Name: $(grep '"name"' app.json | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
echo -e "  Version: $(grep '"version"' app.json | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"

echo ""
echo "Build Profiles:"
echo "  • preview → buildType: apk (Desarrollo/Testing)"
echo "  • production → buildType: aab (Play Store)"

echo ""
echo "Permisos Configurados:"
permisos=$(grep -o '"android\.permission\.[^"]*"' app.json | sort -u | wc -l)
echo "  • Total: $permisos permisos"
echo "  • Críticos (SKILL): SCHEDULE_EXACT_ALARM, FOREGROUND_SERVICE"

echo ""
echo "─────────────────────────────────────────────────────────"
echo ""

# Final status
print_header "RESULTADO FINAL"

if [ -f "eas.json" ] && [ -f "setup_eas.sh" ] && [ -x "setup_eas.sh" ] && [ -f "build_eas_apk.sh" ] && [ -x "build_eas_apk.sh" ]; then
    print_check "✅ CONFIGURACIÓN VÁLIDA - Todo está listo"
    echo ""
    echo "Próximos pasos:"
    echo "  1. npm install -g eas-cli@latest"
    echo "  2. eas login"
    echo "  3. ./setup_eas.sh"
    echo "  4. ./build_eas_apk.sh"
    echo ""
else
    print_error "❌ CONFIGURACIÓN INCOMPLETA - Revisa los errores arriba"
    echo ""
    echo "Acciones necesarias:"
    echo "  • Asegúrate que todos los archivos existan"
    echo "  • Ejecuta: chmod +x *.sh"
    echo "  • Consulta: INDEX.md para más ayuda"
    echo ""
fi

echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
