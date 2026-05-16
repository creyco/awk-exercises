#!/bin/bash

# 1. Stop any running Gradle daemons (forces restart with new JAVA_HOME)
echo "🛑 Deteniendo demonios de Gradle..."
cd android && ./gradlew --stop && cd ..

# 2. Set JAVA_HOME to the compatible JDK 21 (found on your system)
echo "☕ Configurando Java 21..."
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH=$JAVA_HOME/bin:$PATH

# 3. Verify version
echo "🔍 Verificando versión de Java (debe ser 21)..."
java -version

# 4. Set ANDROID_HOME (Found at /home/tunga/Android/Sdk)
echo "📱 Configurando Android SDK..."
export ANDROID_HOME="/home/tunga/Android/Sdk"
export PATH=$ANDROID_HOME/platform-tools:$PATH

# 5. Clean Prebuild (Fixes Reference Linking Errors)
echo "🧹 Regenerando proyecto nativo (Prebuild)..."
npx expo prebuild --platform android --clean

# 6. Run the build targeting the connected device
echo "🚀 Iniciando compilación en dispositivo físico..."

