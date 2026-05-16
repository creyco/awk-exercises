#!/bin/bash

# ====================================================
# Update_BUs_System_Local.sh - Generador Business Units
# Usa archivos prompt JSON locales generados por Kimi
# ====================================================

set -e  # Detener en caso de error

# ============================================
# CONFIGURACIÓN GLOBAL
# ============================================
SISTEM="Business Units Control System"
NAME="BUs_System"
VERSION="2.0.0"

# Ruta al archivo prompt JSON local (generado por Kimi)
PROMPT_JSON_PATH="${PROMPT_JSON_PATH:-./latest-prompt.json}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# FUNCIONES UTILITARIAS
# ============================================

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
}

log_section() {
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
}

# ============================================
# VERIFICAR DEPENDENCIAS
# ============================================

check_dependencies() {
    log_section "VERIFICANDO DEPENDENCIAS"
    
    local deps=("node" "npm")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            missing+=($dep)
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Faltan dependencias: ${missing[*]}"
        exit 1
    fi
    
    log_success "Todas las dependencias están instaladas"
}

# ============================================
# COPIAR PROMPT JSON LOCAL
# ============================================

copy_prompt_json() {
    log_section "CONFIGURANDO PROMPT JSON"
    
    local prompts_dir=".docs/prompts"
    mkdir -p "$prompts_dir"
    
    # Verificar si existe el archivo local
    if [ -f "$PROMPT_JSON_PATH" ]; then
        cp "$PROMPT_JSON_PATH" "$prompts_dir/latest-prompt.json"
        log_success "Prompt JSON copiado desde: $PROMPT_JSON_PATH"
        
        # Extraer información del prompt
        if command -v jq &> /dev/null; then
            local prompt_name=$(jq -r '.prompt.name // "unknown"' "$prompts_dir/latest-prompt.json" 2>/dev/null)
            local prompt_version=$(jq -r '.prompt.version // "unknown"' "$prompts_dir/latest-prompt.json" 2>/dev/null)
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
    local output_path=$1
    
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

create_additional_prompts() {
    local prompts_dir=$1
    
    # Agent Prompt
    cat > "$prompts_dir/agent-prompt.json" << 'EOF'
{
  "agent": {
    "name": "BUs_Control_Agent",
    "role": "Controlador de calidad de código",
    "responsibilities": [
      "Validar que se use ThemeProvider",
      "Verificar tipado estricto",
      "Revisar estructura de carpetas",
      "Asegurar manejo de errores"
    ],
    "validation_rules": [
      "NO inline styles",
      "SIEMPRE useTheme()",
      "TODOS los componentes tipados",
      "Manejo de errores implementado"
    ]
  }
}
EOF

    # UI Prompt
    cat > "$prompts_dir/ui-prompt.json" << 'EOF'
{
  "ui": {
    "design_system": {
      "colors": {
        "primary": "#007AFF",
        "background": "#F8F9FA",
        "surface": "#FFFFFF",
        "text": "#1C1C1E"
      },
      "spacing": { "xs": 4, "sm": 8, "md": 16, "lg": 24 },
      "borderRadius": { "sm": 4, "md": 8, "lg": 12 }
    },
    "components": {
      "required": ["Button", "Card", "Input", "Modal"],
      "patterns": {
        "button": "Usar globalStyles.button",
        "card": "Usar globalStyles.card",
        "input": "Usar globalStyles.input"
      }
    }
  }
}
EOF

    # System Prompt
    cat > "$prompts_dir/system-prompt.json" << 'EOF'
{
  "system": {
    "name": "BUs_Cash_Control",
    "stack": ["React Native", "Expo", "TypeScript", "SQLite"],
    "architecture": "Hexagonal",
    "patterns": [
      "Clean Architecture",
      "Repository Pattern",
      "Dependency Injection"
    ],
    "conventions": {
      "naming": "PascalCase para componentes, camelCase para funciones",
      "files": "index.ts para exports, types.ts para tipos",
      "folders": "kebab-case para carpetas"
    }
  }
}
EOF

    # Business Rules Prompt
    cat > "$prompts_dir/business-rules-prompt.json" << 'EOF'
{
  "business_rules": {
    "entities": {
      "BusinessUnit": {
        "fields": ["id", "name", "type", "cashBalance", "isActive"],
        "rules": [
          "name: requerido, min 3 caracteres",
          "cashBalance: no puede ser negativo",
          "type: debe ser 'store', 'office' o 'warehouse'"
        ]
      },
      "CashTransaction": {
        "fields": ["id", "businessUnitId", "type", "amount", "category"],
        "rules": [
          "amount: debe ser mayor a 0",
          "type: 'income' o 'expense'",
          "category: requerido"
        ]
      }
    },
    "validations": {
      "required_fields": ["id", "name", "createdAt"],
      "numeric_fields": ["amount", "cashBalance"],
      "date_fields": ["createdAt", "updatedAt", "date"]
    }
  }
}
EOF
}

# ============================================
# CREAR SKILLS DE CONTROL
# ============================================

create_agent_skills() {
    log_section "CREANDO SKILLS DE CONTROL PARA AGENTES"
    
    local skills_dir="src/skills"
    mkdir -p "$skills_dir"
    
    # Skill: Validación de Datos
    cat > "$skills_dir/validation.skill.json" << 'EOF'
{
  "skill": {
    "name": "Validación de Datos",
    "type": "validation",
    "version": "1.0.0",
    "description": "Validación de entradas y datos de negocio",
    "rules": [
      "Validar tipos de datos antes de procesar",
      "Verificar campos requeridos",
      "Validar rangos numéricos",
      "Sanitizar strings de entrada"
    ],
    "validators": {
      "required": "campo !== null && campo !== undefined && campo !== ''",
      "string": "typeof valor === 'string'",
      "number": "typeof valor === 'number' && !isNaN(valor)",
      "positive": "valor > 0",
      "email": "/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/.test(valor)",
      "uuid": "/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(valor)"
    },
    "config": {
      "enabled": true,
      "strictMode": true,
      "throwOnError": false
    }
  }
}
EOF

    # Skill: Seguridad
    cat > "$skills_dir/security.skill.json" << 'EOF'
{
  "skill": {
    "name": "Seguridad y Autenticación",
    "type": "security",
    "version": "1.0.0",
    "description": "Control de acceso y seguridad",
    "rules": [
      "Verificar autenticación antes de operaciones sensibles",
      "Validar permisos de usuario",
      "Encriptar datos sensibles",
      "Implementar rate limiting"
    ],
    "permissions": [
      "read:business-units",
      "write:business-units",
      "read:transactions",
      "write:transactions",
      "admin:system"
    ],
    "roles": {
      "admin": ["all"],
      "manager": ["read:business-units", "write:business-units", "read:transactions", "write:transactions"],
      "cashier": ["read:business-units", "read:transactions", "write:transactions"]
    },
    "config": {
      "enabled": true,
      "sessionTimeout": 3600000,
      "maxLoginAttempts": 5
    }
  }
}
EOF

    # Skill: Logging
    cat > "$skills_dir/logging.skill.json" << 'EOF'
{
  "skill": {
    "name": "Logging y Monitoreo",
    "type": "logging",
    "version": "1.0.0",
    "description": "Sistema de logs y trazabilidad",
    "rules": [
      "Loggear todas las operaciones CRUD",
      "Incluir timestamp en cada log",
      "Diferenciar niveles: debug, info, warn, error",
      "No loggear información sensible"
    ],
    "levels": ["debug", "info", "warn", "error", "fatal"],
    "format": "[{timestamp}] [{level}] [{context}] {message}",
    "config": {
      "enabled": true,
      "minLevel": "info",
      "persist": true,
      "maxLogs": 1000
    }
  }
}
EOF

    # Skill: Cache
    cat > "$skills_dir/cache.skill.json" << 'EOF'
{
  "skill": {
    "name": "Gestión de Caché",
    "type": "cache",
    "version": "1.0.0",
    "description": "Sistema de caché para optimización",
    "rules": [
      "Cachear datos frecuentemente accedidos",
      "Invalidar caché cuando cambian los datos",
      "Establecer TTL para entradas de caché",
      "Limitar tamaño máximo de caché"
    ],
    "strategies": {
      "memory": "Cache en memoria (rápido, no persistente)",
      "asyncStorage": "Cache persistente con AsyncStorage",
      "sqlite": "Cache estructurado en SQLite"
    },
    "config": {
      "enabled": true,
      "defaultTTL": 300000,
      "maxSize": 100,
      "strategy": "asyncStorage"
    }
  }
}
EOF

    # Skill: API Control
    cat > "$skills_dir/api-control.skill.json" << 'EOF'
{
  "skill": {
    "name": "Control de API",
    "type": "api",
    "version": "1.0.0",
    "description": "Gestión de peticiones API",
    "rules": [
      "Implementar retry con backoff exponencial",
      "Manejar timeouts de peticiones",
      "Validar respuestas antes de usar",
      "Implementar cancelación de peticiones"
    ],
    "config": {
      "enabled": true,
      "timeout": 30000,
      "retries": 3,
      "retryDelay": 1000,
      "baseURL": "https://api.bus-system.com/v1"
    }
  }
}
EOF

    # Skill: Error Handling
    cat > "$skills_dir/error-handling.skill.json" << 'EOF'
{
  "skill": {
    "name": "Manejo de Errores",
    "type": "error",
    "version": "1.0.0",
    "description": "Gestión centralizada de errores",
    "rules": [
      "Usar try/catch en operaciones asíncronas",
      "Crear clases de error personalizadas",
      "Mostrar mensajes amigables al usuario",
      "Loggear errores para debugging"
    ],
    "error_types": {
      "ValidationError": "Error de validación de datos",
      "AuthError": "Error de autenticación",
      "NetworkError": "Error de red",
      "DatabaseError": "Error de base de datos",
      "BusinessError": "Error de reglas de negocio"
    },
    "config": {
      "enabled": true,
      "showUserMessages": true,
      "logErrors": true
    }
  }
}
EOF

    log_success "Skills de control creados en: $skills_dir"
}

# ============================================
# CREAR MÓDULOS PROGRAMADOS
# ============================================

create_modules() {
    log_section "CREANDO MÓDULOS PROGRAMADOS"
    
    local modules_base="src/modules"
    
    # Módulo: Autenticación
    create_module "$modules_base/authentication" "Autenticación" "auth" "Gestión de usuarios y sesiones"
    
    # Módulo: Dashboard
    create_module "$modules_base/dashboard" "Dashboard" "dashboard" "Panel principal del sistema"
    
    # Módulo: Reportes
    create_module "$modules_base/reporting" "Reportes" "reports" "Generación de reportes"
    
    # Módulo: Usuarios
    create_module "$modules_base/user-management" "Gestión de Usuarios" "users" "Administración de usuarios"
    
    # Módulo: Configuración
    create_module "$modules_base/settings" "Configuración" "settings" "Ajustes del sistema"
    
    # Módulo: Notificaciones
    create_module "$modules_base/notifications" "Notificaciones" "notifications" "Sistema de notificaciones"
    
    # Módulo: Analíticas
    create_module "$modules_base/analytics" "Analíticas" "analytics" "Métricas y estadísticas"
    
    # Módulo: Pagos
    create_module "$modules_base/payments" "Pagos" "payments" "Gestión de transacciones"
    
    log_success "Módulos creados en: $modules_base"
}

create_module() {
    local module_dir=$1
    local module_name=$2
    local module_key=$3
    local description=$4
    
    mkdir -p "$module_dir"
    
    # module.json
    cat > "$module_dir/module.json" << EOF
{
  "module": {
    "name": "$module_name",
    "key": "$module_key",
    "version": "1.0.0",
    "description": "$description",
    "enabled": true,
    "dependencies": [],
    "config": {
      "autoLoad": true,
      "priority": 5
    }
  }
}
EOF

    # index.ts
    cat > "$module_dir/index.ts" << EOF
/**
 * Módulo: $module_name
 * Key: $module_key
 * Description: $description
 */

export * from './types';
export * from './utils';
export * from './hooks';
export * from './constants';
export * from './services';

// Inicialización del módulo
export const initialize = async (): Promise<boolean> => {
  console.log('[$module_name] Módulo inicializado');
  return true;
};

export const destroy = async (): Promise<void> => {
  console.log('[$module_name] Módulo destruido');
};

export default {
  name: '$module_name',
  key: '$module_key',
  initialize,
  destroy
};
EOF

    # types.ts
    cat > "$module_dir/types.ts" << EOF
/**
 * Tipos del módulo $module_name
 */

export interface ${module_key^}Config {
  enabled: boolean;
  settings: Record<string, any>;
}

export interface ${module_key^}State {
  isLoading: boolean;
  data: any;
  error: Error | null;
}

export interface ${module_key^}Props {
  config?: ${module_key^}Config;
  onError?: (error: Error) => void;
}
EOF

    # utils.ts
    cat > "$module_dir/utils.ts" << EOF
/**
 * Utilidades del módulo $module_name
 */

export const formatData = (data: any): any => {
  return data;
};

export const validateInput = (input: any): boolean => {
  return input !== null && input !== undefined;
};

export const parseResponse = (response: any): any => {
  try {
    return typeof response === 'string' ? JSON.parse(response) : response;
  } catch {
    return null;
  }
};
EOF

    # hooks.ts
    cat > "$module_dir/hooks.ts" << EOF
/**
 * Hooks del módulo $module_name
 */

import { useState, useEffect, useCallback } from 'react';
import type { ${module_key^}State, ${module_key^}Config } from './types';

export const use${module_key^} = (config?: ${module_key^}Config) => {
  const [state, setState] = useState<${module_key^}State>({
    isLoading: false,
    data: null,
    error: null
  });

  const setLoading = useCallback((isLoading: boolean) => {
    setState(prev => ({ ...prev, isLoading }));
  }, []);

  const setData = useCallback((data: any) => {
    setState(prev => ({ ...prev, data, error: null, isLoading: false }));
  }, []);

  const setError = useCallback((error: Error) => {
    setState(prev => ({ ...prev, error, isLoading: false }));
  }, []);

  useEffect(() => {
    // Lógica de inicialización del hook
  }, [config]);

  return {
    ...state,
    setLoading,
    setData,
    setError
  };
};
EOF

    # constants.ts
    cat > "$module_dir/constants.ts" << EOF
/**
 * Constantes del módulo $module_name
 */

export const ${module_key^^}_MODULE_NAME = '$module_name';
export const ${module_key^^}_MODULE_KEY = '$module_key';

export const DEFAULT_CONFIG: Record<string, any> = {
  enabled: true,
  autoLoad: true,
  timeout: 5000
};

export const API_ENDPOINTS = {
  base: '/$module_key',
  list: '/$module_key/list',
  create: '/$module_key/create',
  update: '/$module_key/update',
  delete: '/$module_key/delete'
};
EOF

    # services.ts
    cat > "$module_dir/services.ts" << EOF
/**
 * Servicios del módulo $module_name
 */

import { API_ENDPOINTS } from './constants';

export class ${module_key^}Service {
  private baseURL: string;

  constructor(baseURL: string = '') {
    this.baseURL = baseURL;
  }

  async fetchAll(): Promise<any[]> {
    const response = await fetch(\`\${this.baseURL}\${API_ENDPOINTS.list}\`);
    return response.json();
  }

  async fetchById(id: string): Promise<any> {
    const response = await fetch(\`\${this.baseURL}\${API_ENDPOINTS.base}/\${id}\`);
    return response.json();
  }

  async create(data: any): Promise<any> {
    const response = await fetch(\`\${this.baseURL}\${API_ENDPOINTS.create}\`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return response.json();
  }

  async update(id: string, data: any): Promise<any> {
    const response = await fetch(\`\${this.baseURL}\${API_ENDPOINTS.update}/\${id}\`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return response.json();
  }

  async delete(id: string): Promise<void> {
    await fetch(\`\${this.baseURL}\${API_ENDPOINTS.delete}/\${id}\`, {
      method: 'DELETE'
    });
  }
}

export const ${module_key}Service = new ${module_key^}Service();
EOF

    log_info "  └─ Módulo creado: $module_name"
}

# ============================================
# CONFIGURACIÓN DEL SISTEMA
# ============================================

setup_configuration() {
    log_section "CONFIGURANDO SISTEMA"
    
    cat > "system.config.json" << EOF
{
  "system": {
    "name": "$SISTEM",
    "version": "$VERSION",
    "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "environment": "development"
  },
  "modules": {
    "autoLoad": true,
    "path": "src/modules",
    "enabled": [
      "authentication",
      "dashboard",
      "reporting",
      "user-management",
      "settings",
      "notifications",
      "analytics",
      "payments"
    ]
  },
  "skills": {
    "path": "src/skills",
    "enabled": true,
    "active": [
      "validation",
      "security",
      "logging",
      "cache",
      "api-control",
      "error-handling"
    ]
  },
  "prompts": {
    "path": ".docs/prompts",
    "autoUpdate": false
  },
  "agents": {
    "maxConcurrent": 5,
    "timeout": 30000
  },
  "database": {
    "type": "sqlite",
    "name": "bus_system.db",
    "version": 1
  }
}
EOF

    log_success "Configuración del sistema creada"
}

# ============================================
# CREACIÓN DE ESTRUCTURA BASE
# ============================================

create_base_structure() {
    log_section "CREANDO ESTRUCTURA BASE"
    
    log_info "Creando aplicación Expo con TypeScript..."
    npx create-expo-app@latest "$NAME" --template blank-typescript
    cd "$NAME"
    
    log_info "Instalando dependencias..."
    npx expo install \
      expo-sqlite \
      expo-notifications \
      expo-linking \
      expo-constants \
      expo-router \
      react-native-safe-area-context \
      react-native-screens \
      react-native-gesture-handler \
      @react-native-async-storage/async-storage \
      expo-status-bar \
      react-native-web \
      react-dom \
      @expo/metro-runtime
    
    # Crear estructura de carpetas
    mkdir -p .docs/prompts
    mkdir -p src/{
      domain/{entities,value-objects,repositories},
      application/{use-cases,services},
      infrastructure/{db,repositories,analytics,api},
      ui/{components/{common,forms,layout},screens,theme/{context,styles},hooks,constants},
      modules,
      skills
    }
    mkdir -p app
    
    log_success "Estructura base creada"
}

# ============================================
# SISTEMA DE TEMAS
# ============================================

setup_theme_system() {
    log_section "CONFIGURANDO SISTEMA DE TEMAS"
    
    # Colores
    cat > src/ui/theme/constants/colors.ts << 'EOF'
export const LIGHT_THEME = {
  primary: '#007AFF',
  primaryLight: '#40C4FF',
  primaryDark: '#005BB5',
  background: '#F8F9FA',
  surface: '#FFFFFF',
  text: '#1C1C1E',
  textSecondary: '#8E8E93',
  textTertiary: '#AEAEB2',
  error: '#FF3B30',
  success: '#34C759',
  warning: '#FF9500',
  info: '#5856D6',
  border: '#E5E5EA',
  divider: '#C6C6C8',
} as const;

export const DARK_THEME = {
  primary: '#0A84FF',
  primaryLight: '#60B0F5',
  primaryDark: '#0056B3',
  background: '#000000',
  surface: '#1C1C1E',
  text: '#FFFFFF',
  textSecondary: '#E8E8ED',
  textTertiary: '#AEAEB2',
  error: '#FF453A',
  success: '#32D74B',
  warning: '#F29322',
  info: '#5E5CE6',
  border: '#38383A',
  divider: '#48484A',
} as const;

export type ThemeColors = typeof LIGHT_THEME;
EOF

    # Estilos globales
    cat > src/ui/theme/styles/globalStyles.ts << 'EOF'
import { StyleSheet } from 'react-native';
import { LIGHT_THEME } from '../constants/colors';

export const globalStyles = StyleSheet.create({
  // Contenedores
  container: {
    flex: 1,
    backgroundColor: LIGHT_THEME.background,
    padding: 16,
  },
  containerCenter: {
    flex: 1,
    backgroundColor: LIGHT_THEME.background,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
  
  // Cards
  card: {
    backgroundColor: LIGHT_THEME.surface,
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    elevation: 2,
    shadowColor: LIGHT_THEME.text,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  cardOutlined: {
    backgroundColor: LIGHT_THEME.surface,
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: LIGHT_THEME.border,
  },
  
  // Tipografía
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: LIGHT_THEME.text,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: LIGHT_THEME.textSecondary,
    marginBottom: 16,
  },
  heading: {
    fontSize: 20,
    fontWeight: '600',
    color: LIGHT_THEME.text,
    marginBottom: 8,
  },
  body: {
    fontSize: 14,
    color: LIGHT_THEME.text,
    lineHeight: 20,
  },
  caption: {
    fontSize: 12,
    color: LIGHT_THEME.textSecondary,
  },
  
  // Botones
  button: {
    backgroundColor: LIGHT_THEME.primary,
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
  buttonSecondary: {
    backgroundColor: LIGHT_THEME.surface,
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: LIGHT_THEME.primary,
  },
  buttonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
  buttonTextSecondary: {
    color: LIGHT_THEME.primary,
    fontSize: 16,
    fontWeight: '600',
  },
  
  // Inputs
  input: {
    borderWidth: 1,
    borderColor: LIGHT_THEME.border,
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    marginBottom: 12,
    backgroundColor: LIGHT_THEME.surface,
    color: LIGHT_THEME.text,
  },
  inputFocused: {
    borderColor: LIGHT_THEME.primary,
    borderWidth: 2,
  },
  
  // Layout
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rowBetween: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  spacer: {
    height: 16,
  },
  divider: {
    height: 1,
    backgroundColor: LIGHT_THEME.divider,
    marginVertical: 12,
  },
  
  // Estados
  error: {
    color: LIGHT_THEME.error,
    fontSize: 12,
    marginTop: -8,
    marginBottom: 12,
  },
  success: {
    color: LIGHT_THEME.success,
    fontSize: 12,
  },
  warning: {
    color: LIGHT_THEME.warning,
    fontSize: 12,
  },
});
EOF

    # Spacing
    cat > src/ui/theme/constants/spacing.ts << 'EOF'
export const SPACING = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
} as const;

export const BORDER_RADIUS = {
  xs: 2,
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  xxl: 24,
} as const;
EOF

    # ThemeProvider
    cat > src/ui/theme/context/ThemeContext.tsx << 'EOF'
import React, { createContext, useContext, useState, useEffect, useCallback, ReactNode } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useColorScheme } from 'react-native';
import { LIGHT_THEME, DARK_THEME, ThemeColors } from '../constants/colors';

interface ThemeContextType {
  theme: ThemeColors;
  isDark: boolean;
  toggleTheme: () => Promise<void>;
  setTheme: (isDark: boolean) => Promise<void>;
  colors: ThemeColors;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

interface ThemeProviderProps {
  children: ReactNode;
}

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme debe usarse dentro de ThemeProvider');
  }
  return context;
};

export const ThemeProvider: React.FC<ThemeProviderProps> = ({ children }) => {
  const systemScheme = useColorScheme();
  const [isDark, setIsDark] = useState(false);
  const [theme, setThemeState] = useState<ThemeColors>(LIGHT_THEME);
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    loadTheme();
  }, []);

  const loadTheme = async () => {
    try {
      const saved = await AsyncStorage.getItem('theme');
      if (saved) {
        const shouldBeDark = saved === 'dark';
        setIsDark(shouldBeDark);
        setThemeState(shouldBeDark ? DARK_THEME : LIGHT_THEME);
      } else {
        const systemIsDark = systemScheme === 'dark';
        setIsDark(systemIsDark);
        setThemeState(systemIsDark ? DARK_THEME : LIGHT_THEME);
      }
    } catch (error) {
      console.log('Error loading theme:', error);
    } finally {
      setIsReady(true);
    }
  };

  const setTheme = useCallback(async (dark: boolean) => {
    setIsDark(dark);
    setThemeState(dark ? DARK_THEME : LIGHT_THEME);
    try {
      await AsyncStorage.setItem('theme', dark ? 'dark' : 'light');
    } catch (error) {
      console.log('Error saving theme:', error);
    }
  }, []);

  const toggleTheme = useCallback(async () => {
    await setTheme(!isDark);
  }, [isDark, setTheme]);

  const value: ThemeContextType = {
    theme,
    isDark,
    toggleTheme,
    setTheme,
    colors: theme,
  };

  if (!isReady) {
    return null;
  }

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
};
EOF

    log_success "Sistema de temas configurado"
}

# ============================================
# PANTALLAS Y NAVEGACIÓN
# ============================================

setup_screens() {
    log_section "CONFIGURANDO PANTALLAS"
    
    # Layout principal
    cat > app/_layout.tsx << 'EOF'
import React from 'react';
import { ThemeProvider } from '@/src/ui/theme/context/ThemeContext';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { Slot } from 'expo-router';

export default function RootLayout() {
  return (
    <SafeAreaProvider>
      <ThemeProvider>
        <Slot />
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
EOF

    # Pantalla de Setup
    cat > app/setup.tsx << 'EOF'
import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  Switch,
  StyleSheet,
  ScrollView,
} from 'react-native';
import { useTheme } from '@/src/ui/theme/context/ThemeContext';
import { globalStyles } from '@/src/ui/theme/styles/globalStyles';

const SetupScreen = () => {
  const { theme, isDark, toggleTheme } = useTheme();

  const styles = StyleSheet.create({
    container: {
      ...globalStyles.container,
    },
    toggleContainer: {
      ...globalStyles.card,
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: 24,
    },
    toggleText: {
      ...globalStyles.subtitle,
      marginBottom: 0,
    },
    moduleCard: {
      ...globalStyles.card,
      marginTop: 8,
    },
    moduleTitle: {
      ...globalStyles.heading,
    },
    moduleList: {
      ...globalStyles.body,
      lineHeight: 24,
    },
    version: {
      ...globalStyles.caption,
      textAlign: 'center',
      marginTop: 24,
    },
  });

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />
      <ScrollView style={styles.container}>
        <View style={globalStyles.card}>
          <Text style={globalStyles.title}>🚀 BUs System</Text>
          <Text style={globalStyles.subtitle}>
            Sistema de Control de Unidades de Negocio
          </Text>
        </View>

        <View style={styles.toggleContainer}>
          <Text style={styles.toggleText}>
            {isDark ? '☀️ Modo Claro' : '🌙 Modo Oscuro'}
          </Text>
          <Switch
            value={isDark}
            onValueChange={toggleTheme}
            trackColor={{ true: theme.primary, false: theme.border }}
            thumbColor={isDark ? '#FFFFFF' : theme.primary}
          />
        </View>

        <View style={styles.moduleCard}>
          <Text style={styles.moduleTitle}>📦 Módulos Cargados</Text>
          <Text style={styles.moduleList}>
            • Autenticación{'\n'}
            • Dashboard{'\n'}
            • Reportes{'\n'}
            • Gestión de Usuarios{'\n'}
            • Notificaciones{'\n'}
            • Analíticas{'\n'}
            • Configuración{'\n'}
            • Pagos
          </Text>
        </View>

        <View style={styles.moduleCard}>
          <Text style={styles.moduleTitle}>🛡️ Skills Activos</Text>
          <Text style={styles.moduleList}>
            • Validación de Datos{'\n'}
            • Seguridad y Autenticación{'\n'}
            • Logging y Monitoreo{'\n'}
            • Gestión de Caché{'\n'}
            • Control de API{'\n'}
            • Manejo de Errores
          </Text>
        </View>

        <View style={globalStyles.card}>
          <Text style={globalStyles.title}>✅ Sistema Listo</Text>
          <TouchableOpacity style={globalStyles.button}>
            <Text style={globalStyles.buttonText}>Continuar al Dashboard</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.version}>v2.0.0 • Business Units Control</Text>
      </ScrollView>
    </SafeAreaView>
  );
};

export default SetupScreen;
EOF

    # Index con redirección
    cat > app/index.tsx << 'EOF'
import { Redirect } from 'expo-router';
import { useEffect, useState } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

export default function Index() {
  const [isSetupDone, setIsSetupDone] = useState<boolean | null>(null);

  useEffect(() => {
    checkSetup();
  }, []);

  const checkSetup = async () => {
    try {
      const setupDone = await AsyncStorage.getItem('setupDone');
      setIsSetupDone(!!setupDone);
    } catch {
      setIsSetupDone(false);
    }
  };

  if (isSetupDone === null) {
    return null;
  }

  return <Redirect href={isSetupDone ? "/dashboard" : "/setup"} />;
}
EOF

    log_success "Pantallas configuradas"
}

# ============================================
# CONFIGURACIÓN EAS Y SCRIPTS
# ============================================

setup_eas_and_scripts() {
    log_section "CONFIGURANDO EAS Y SCRIPTS"
    
    # EAS config
    cat > eas.json << 'EOF'
{
  "cli": {
    "version": ">= 14.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": {
        "simulator": true
      }
    },
    "preview": {
      "distribution": "internal",
      "android": {
        "buildType": "apk"
      }
    },
    "production": {}
  },
  "submit": {
    "production": {}
  }
}
EOF

    # Actualizar package.json
    node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json'));
pkg.scripts = {
  ...pkg.scripts,
  'start': 'expo start',
  'dev': 'npx expo start --clear',
  'android': 'expo start --android',
  'ios': 'expo start --ios',
  'web': 'expo start --web',
  'build:android': 'eas build --platform android --profile preview',
  'build:ios': 'eas build --platform ios --profile preview',
  'build:dev': 'eas build --platform android --profile development'
};
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

    log_success "EAS y scripts configurados"
}

# ============================================
# FUNCIÓN PRINCIPAL
# ============================================

main() {
    log_section "INICIANDO: $SISTEM v$VERSION"
    
    # Verificar dependencias
    check_dependencies
    
    # Crear estructura base
    create_base_structure
    
    # Configurar sistema
    setup_configuration
    
    # Copiar prompts JSON locales
    copy_prompt_json
    
    # Crear skills de control
    create_agent_skills
    
    # Crear módulos programados
    create_modules
    
    # Configurar tema y UI
    setup_theme_system
    setup_screens
    
    # Configurar EAS
    setup_eas_and_scripts
    
    # Crear documentación
    cat > README.md << EOF
# $SISTEM

Sistema de Control de Unidades de Negocio con arquitectura modular.

## Estructura

\`\`\`
.docs/prompts/          # Prompts JSON generados por Kimi
src/
  domain/               # Entidades y reglas de negocio
  application/          # Casos de uso
  infrastructure/       # Implementaciones (DB, API)
  ui/                   # Componentes y temas
  modules/              # Módulos programados
  skills/               # Skills de control para agentes
app/                    # Pantallas (expo-router)
\`\`\`

## Comandos

\`\`\`bash
# Iniciar desarrollo
npm run dev

# Construir
npm run build:android
npm run build:ios
\`\`\`

## Módulos

- **authentication** - Gestión de usuarios y sesiones
- **dashboard** - Panel principal
- **reporting** - Reportes y estadísticas
- **user-management** - Administración de usuarios
- **settings** - Configuración del sistema
- **notifications** - Notificaciones push
- **analytics** - Métricas y analíticas
- **payments** - Gestión de pagos

## Skills

- **validation** - Validación de datos
- **security** - Seguridad y autenticación
- **logging** - Logging y monitoreo
- **cache** - Gestión de caché
- **api-control** - Control de API
- **error-handling** - Manejo de errores

## Configuración

Editar \`system.config.json\` para personalizar el sistema.
EOF

    # Resumen final
    log_section "INSTALACIÓN COMPLETADA"
    
    echo ""
    log_success "✅ $SISTEM creado con éxito"
    log_success "✅ Prompts JSON en: .docs/prompts/"
    log_success "✅ Skills de control en: src/skills/"
    log_success "✅ Módulos programados en: src/modules/"
    log_success "✅ ThemeProvider + Dark Mode configurado"
    echo ""
    log_info "📁 Directorio: $NAME/"
    log_info "📱 Probar: cd $NAME && npm run dev"
    log_info "🔧 Configuración: system.config.json"
    log_info "📖 Documentación: README.md"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ¡Sistema listo para usar!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
}

# Ejecutar función principal
main "$@"
