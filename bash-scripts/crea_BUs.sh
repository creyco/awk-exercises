#!/bin/bash

# 1. Crear la aplicación con el template de TypeScript
npx create-expo-app@latest BusinessUnits --template blank-typescript
cd BusinessUnits

# 2. Instalar dependencias esenciales
# SQLite para persistencia local, Expo Router para navegación, y dependencias de UI
npx expo install expo-sqlite expo-notifications expo-linking expo-constants expo-router react-native-safe-area-context react-native-screens react-native-gesture-handler

# 3. Crear estructura de carpetas (Arquitectura Hexagonal enfocada a BI)
# Se separa 'domain' (reglas de negocio), 'application' (casos de uso) e 'infrastructure' (conexión POS/DB)
mkdir -p .docs
mkdir -p src/{domain/{entities,value-objects,repositories},application/{use-cases,services},infrastructure/{db,repositories,analytics,api},ui/{components,screens,theme,hooks,constants}}

# 4. Crear archivos de base para el contexto de BI
touch .docs/business-rules.json      # Reglas de cálculo (IVA, Ratios)
touch .docs/bi-strategy.json         # KPIs: Ticket Promedio, Venta Total
touch .docs/data-mapping.json        # Mapeo de tablas CounterPoint
touch src/infrastructure/db/init.sql  # Esquema de tablas: Ventas y Tickets

# 5. Configuración para soporte Web (Para visualización en oficina/gerencia)
npx expo install react-native-web react-dom @expo/metro-runtime

# 6. Crear estructura de navegación base para Expo Router
mkdir -p app
touch app/_layout.tsx
touch app/index.tsx

echo "--------------------------------------------------"
echo "Proyecto 'BusinessUnits' creado con éxito"
echo "Enfoque: Gestión de Ingresos y Ventas (Restaurantes)"
echo "Arquitectura: Hexagonal / Clean Architecture"
echo "--------------------------------------------------"

# 7. Simulación de copia de archivos maestros (Ajustado a la nueva lógica)
# Asumiendo que tienes los nuevos archivos en tu carpeta HUB
cp -r /home/tunga/HUB/BU/.docs .docs/ 2>/dev/null || echo "Info: No se encontraron archivos JSON previos."
# Nota: Aquí deberás colocar tus nuevos scripts de SQL y Repositorios de Ventas
# cp /media/tunga/NVME1tB/PRJ/HUB/Sales/init_bi.sql ./src/infrastructure/db/init.sql
# cp /media/tunga/NVME1tB/PRJ/HUB/Sales/ISalesRepository.ts src/domain/repositories/ISalesRepository.ts
