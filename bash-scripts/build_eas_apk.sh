#!/bin/bash

# ============================================================================
# EAS Build Script - MyMedication APK Build & Download
# ============================================================================
# Este script realiza lo siguiente:
# 1. Verifica la instalación de eas-cli
# 2. Inicia sesión en Expo (si es necesario)
# 3. Configura las credenciales automáticamente
# 4. Envía el proyecto a EAS Build
# 5. Obtiene y descarga el APK compilado
# ============================================================================

set -e  # Salir al primer error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir títulos
print_title() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Función para imprimir pasos
print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

# Función para imprimir advertencias
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Función para imprimir errores
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# PASO 1: Verificar eas-cli
# ============================================================================
print_title "PASO 1: Verificar Instalación de EAS CLI"

if ! command -v eas &> /dev/null; then
    print_error "eas-cli no está instalado"
    print_warning "Instálalo con: npm install -g eas-cli@latest"
    exit 1
fi

EAS_VERSION=$(eas --version)
print_step "eas-cli encontrado: $EAS_VERSION"

# ============================================================================
# PASO 2: Verificar sesión en Expo
# ============================================================================
print_title "PASO 2: Verificar Sesión de Expo"

if ! eas whoami &> /dev/null; then
    print_warning "No hay sesión activa en Expo. Iniciando login..."
    eas login
else
    CURRENT_USER=$(eas whoami)
    print_step "Sesión activa como: $CURRENT_USER"
fi

# ============================================================================
# PASO 3: Configurar credenciales automáticamente
# ============================================================================
print_title "PASO 3: Configurar Credenciales Android"

if [ ! -f "eas.json" ]; then
    print_error "eas.json no encontrado"
    exit 1
fi

print_step "eas.json encontrado"
print_warning "Configurando credenciales de Android (esto abrirá el navegador si es necesario)..."

# Ejecutar eas build:configure para Android automáticamente
eas build:configure --platform android || {
    print_warning "La configuración puede requerir interacción manual"
    print_step "Sigue las instrucciones en el navegador para completar la configuración"
}

# ============================================================================
# PASO 4: Enviar proyecto a EAS Build
# ============================================================================
print_title "PASO 4: Enviar Proyecto a EAS Build"

print_step "Iniciando build en la nube (perfil: preview, buildType: apk)..."
print_warning "Este proceso puede tomar varios minutos (típicamente 5-15 minutos)"

BUILD_OUTPUT=$(eas build --platform android --profile preview --non-interactive 2>&1)

# Extraer el BUILD_ID del output
BUILD_ID=$(echo "$BUILD_OUTPUT" | grep -oP 'Build ID: \K[a-f0-9-]+' | head -1 || echo "")

if [ -z "$BUILD_ID" ]; then
    print_error "No se pudo obtener el BUILD_ID. Output completo:"
    echo "$BUILD_OUTPUT"
    exit 1
fi

print_step "Build enviado con éxito"
print_step "Build ID: $BUILD_ID"

# ============================================================================
# PASO 5: Monitorear el build
# ============================================================================
print_title "PASO 5: Monitorear Compilación"

print_step "Esperando que se complete el build..."
print_warning "Puedes ver el progreso en: https://expo.dev/builds/$BUILD_ID"

# Esperar a que se complete con polling
MAX_ATTEMPTS=180  # 30 minutos con 10 segundos entre intentos
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    BUILD_STATUS=$(eas build --status --platform android --profile preview --non-interactive 2>&1 || echo "")
    
    if echo "$BUILD_STATUS" | grep -q "FINISHED"; then
        print_step "¡Build completado exitosamente!"
        break
    elif echo "$BUILD_STATUS" | grep -q "FAILED"; then
        print_error "El build falló. Detalles:"
        echo "$BUILD_STATUS"
        exit 1
    fi
    
    ATTEMPT=$((ATTEMPT + 1))
    PROGRESS=$((ATTEMPT * 100 / MAX_ATTEMPTS))
    echo -ne "Progreso: ${PROGRESS}% (Intento $ATTEMPT/$MAX_ATTEMPTS)\r"
    
    sleep 10
done

# ============================================================================
# PASO 6: Descargar APK
# ============================================================================
print_title "PASO 6: Descargar APK"

# Crear directorio para descargas si no existe
DOWNLOAD_DIR="./builds/apk"
mkdir -p "$DOWNLOAD_DIR"

print_step "Descargando APK..."

# Obtener la URL de descarga del APK
APK_URL=$(eas build --platform android --profile preview --non-interactive --json 2>&1 | jq -r '.artifacts[0].url' 2>/dev/null || echo "")

if [ -z "$APK_URL" ] || [ "$APK_URL" = "null" ]; then
    print_warning "No se pudo obtener URL automática. Obtén el APK manualmente:"
    print_step "URL del build: https://expo.dev/builds/$BUILD_ID"
    print_step "O ejecuta: eas build:download --id=$BUILD_ID --platform android"
else
    APK_FILENAME="MyMedication-$(date +%Y%m%d-%H%M%S).apk"
    APK_PATH="$DOWNLOAD_DIR/$APK_FILENAME"
    
    curl -o "$APK_PATH" "$APK_URL" 2>/dev/null || {
        print_error "No se pudo descargar el APK automáticamente"
        print_step "Descárgalo manualmente desde:"
        echo "$APK_URL"
        exit 1
    }
    
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    print_step "APK descargado exitosamente: $APK_FILENAME ($APK_SIZE)"
    print_step "Ubicación: $(pwd)/$APK_PATH"
fi

# ============================================================================
# RESUMEN FINAL
# ============================================================================
print_title "COMPILACIÓN COMPLETADA"

print_step "Build ID: $BUILD_ID"
print_step "Perfil utilizado: preview (APK)"
print_step "Descarga manual: https://expo.dev/builds/$BUILD_ID"

if [ -f "$APK_PATH" ]; then
    print_step "APK local: $APK_PATH"
    print_step "Comando para instalar en dispositivo:"
    echo -e "  ${YELLOW}adb install $APK_PATH${NC}"
fi

print_title "Próximos Pasos"
echo -e "1. ${YELLOW}Instalar en dispositivo:${NC}"
echo -e "   adb install $APK_PATH"
echo ""
echo -e "2. ${YELLOW}Ver logs:${NC}"
echo -e "   adb logcat"
echo ""
echo -e "3. ${YELLOW}Ver compilaciones anteriores:${NC}"
echo -e "   eas build:list --platform android"
echo ""

print_step "¡Listo!"
