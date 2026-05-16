#!/bin/bash

# ============================================================================
# INSTALACIÓN DE EAS CLI - Paso a Paso
# ============================================================================

cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║          INSTALACIÓN DE EAS CLI - MyMedication                            ║
║          (Sigue los pasos exactos a continuación)                         ║
╚════════════════════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════════════════════════════
PASO 1: INSTALAR EAS CLI GLOBALMENTE
═══════════════════════════════════════════════════════════════════════════════

Comando:
───────
  npm install -g eas-cli@latest

Qué hace:
─────────
✓ Descarga eas-cli desde npm
✓ Instala globalmente en tu sistema (accesible desde cualquier carpeta)
✓ Instala su última versión estable

Tiempo estimado: 1-2 minutos

Salida esperada:
────────────────
  added XXX packages in X.XXs
  npm notice created a lockfile as package-lock.json
  ...
  eas@X.X.X added XXX packages, and audited XXXX packages in Xs


═══════════════════════════════════════════════════════════════════════════════
PASO 2: VERIFICAR INSTALACIÓN
═══════════════════════════════════════════════════════════════════════════════

Comando:
───────
  eas --version

Salida esperada:
────────────────
  eas/X.XX.X (linux-x64) node-X.XX.X


═══════════════════════════════════════════════════════════════════════════════
PASO 3: INICIAR SESIÓN EN EXPO (eas login)
═══════════════════════════════════════════════════════════════════════════════

Comando:
───────
  eas login

Qué pasa:
────────
1. Se abrirá automáticamente tu navegador predeterminado
2. Si no se abre, se mostrará un link para copiar/pegar:
   
   ✓ Please open the following URL in your browser:
     https://expo.dev/auth/cli/...

3. En el navegador:
   ├─ Si ya tienes cuenta Expo → Login
   ├─ Si no tienes → Crear cuenta (es gratis)
   └─ Autoriza a eas-cli

Salida esperada:
────────────────
  ✓ Authentication successful
  ✓ Logged in as: tu_usuario@email.com


═══════════════════════════════════════════════════════════════════════════════
PASO 4: NAVEGA A TU PROYECTO
═══════════════════════════════════════════════════════════════════════════════

Comando:
───────
  cd /media/tunga/NVME1tB/PRJ/HUB/MyMedication


═══════════════════════════════════════════════════════════════════════════════
PASO 5: EJECUTAR SETUP AUTOMÁTICO
═══════════════════════════════════════════════════════════════════════════════

Comando:
───────
  ./setup_eas.sh

Qué hace este script:
──────────────────────
1. Verifica que eas-cli esté instalado
2. Verifica que haya sesión en Expo
3. Ejecuta: eas build:configure --platform android --type managed
4. Configura credenciales de firma automáticamente
   └─ Se abrirá navegador (si es primera vez)
5. Valida eas.json y app.json

Salida esperada:
────────────────
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 1: Verificar Instalación de EAS CLI
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ eas-cli encontrado: eas/X.XX.X

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 2: Verificar Sesión de Expo
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Sesión activa como: tu_usuario@email.com

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 3: Verificar Configuración
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ eas.json encontrado y validado
  ✓ app.json encontrado
  ✓ SCHEDULE_EXACT_ALARM configurado
  ✓ FOREGROUND_SERVICE configurado

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 4: Configurar Credenciales de Firma Android
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Ejecutando: eas build:configure --platform android --type managed
  
  [Se abrirá navegador para generar claves]
  
  ✓ Credenciales configuradas exitosamente

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Setup Completado
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ eas-cli instalado: eas/X.XX.X
  ✓ Sesión activa: tu_usuario@email.com
  ✓ eas.json validado
  ✓ Credenciales de Android configuradas


═══════════════════════════════════════════════════════════════════════════════
PASO 6: COMPILAR APK
═══════════════════════════════════════════════════════════════════════════════

Comando:
───────
  ./build_eas_apk.sh

Qué hace este script:
──────────────────────
1. Verifica sesión en Expo
2. Envía el proyecto a EAS Build en la nube
3. Monitorea el progreso (5-15 minutos)
4. Descarga automáticamente el APK
5. Guarda en ./builds/apk/MyMedication-TIMESTAMP.apk

Salida esperada (Resumen):
──────────────────────────
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 4: Enviar Proyecto a EAS Build
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Iniciando build en la nube (perfil: preview, buildType: apk)...

  ✓ Build ID: a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 5: Monitorear Compilación
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Progreso: 10% (Intento 1/180)
  Progreso: 20% (Intento 2/180)
  ...
  ✓ ¡Build completado exitosamente!

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASO 6: Descargar APK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ APK descargado: MyMedication-20260123-184530.apk (45.2M)
  ✓ Ubicación: /media/tunga/NVME1tB/PRJ/HUB/MyMedication/builds/apk/...

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COMPILACIÓN COMPLETADA
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Build ID: a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6
  ✓ APK local: ./builds/apk/MyMedication-20260123-184530.apk
  ✓ Comando para instalar: adb install ./builds/apk/MyMedication-20260123-184530.apk


═══════════════════════════════════════════════════════════════════════════════
PASO 7: INSTALAR EN DISPOSITIVO
═══════════════════════════════════════════════════════════════════════════════

Comando 1: Verificar dispositivo conectado
──────────────────────────────────────────
  adb devices

Salida esperada:
────────────────
  List of attached devices
  XXXXXXXXXXXXXXXX	device

  (Si dice "unauthorized", desbloquea el teléfono y permite USB Debugging)

Comando 2: Instalar APK
───────────────────────
  adb install ./builds/apk/MyMedication-20260123-184530.apk

Salida esperada:
────────────────
  Performing Streamed Install
  Success

Comando 3 (Opcional): Desinstalar y reinstalar limpio
──────────────────────────────────────────────────────
  adb uninstall com.tunga.mymedication
  adb install ./builds/apk/MyMedication-20260123-184530.apk

✓ ¡Listo! MyMedication está instalado en tu dispositivo


═══════════════════════════════════════════════════════════════════════════════
ALTERNATIVA: SIN SCRIPT (Comandos Manuales)
═══════════════════════════════════════════════════════════════════════════════

Si prefieres no usar los scripts, puedes ejecutar manualmente:

  npm install -g eas-cli@latest
  eas login
  eas build:configure --platform android --type managed
  eas build --platform android --profile preview
  eas build:download --id=<BUILD_ID> --platform android
  adb install ./MyMedication-*.apk


═══════════════════════════════════════════════════════════════════════════════
SOPORTE Y RECURSOS
═══════════════════════════════════════════════════════════════════════════════

Documentación completa:
  ./EAS_BUILD_SETUP.md

Referencia rápida:
  ./QUICK_REFERENCE.sh

Docs oficiales Expo:
  https://docs.expo.dev/eas-update/getting-started/

Dashboard de Expo:
  https://expo.dev/

Ver builds anteriores:
  eas build:list --platform android

Ver logs de un build:
  https://expo.dev/builds/<BUILD_ID>


═══════════════════════════════════════════════════════════════════════════════
¡SETUP COMPLETADO!
═══════════════════════════════════════════════════════════════════════════════

Próximas veces solo necesitas ejecutar:
  ./build_eas_apk.sh

Y eso es todo. EAS Build se encarga del resto.

EOF
