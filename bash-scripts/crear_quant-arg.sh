#!/bin/bash
set -e  # Detiene la ejecución si algún comando falla

PROJECT_NAME="quant-argentina"

echo "🚀 Iniciando creación del proyecto: $PROJECT_NAME"

# Verificar si ya existe para evitar sobrescrituras accidentales
if [ -d "$PROJECT_NAME" ]; then
  echo "⚠️  La carpeta '$PROJECT_NAME' ya existe. Se recomienda eliminarla o renombrarla antes de continuar."
  exit 1
fi

# 1. Crear estructura de directorios (Sintaxis corregida: UNA SOLA LÍNEA sin espacios tras comas)
mkdir -p "$PROJECT_NAME"/{src/{core,agents,skills,data,utils},database/{migrations,seeds},notebooks,tests/{unit,integration},docs,scripts,data,logs}

# 2. Crear archivos __init__.py para módulos importables
touch "$PROJECT_NAME/src/core/__init__.py"
touch "$PROJECT_NAME/src/agents/__init__.py"
touch "$PROJECT_NAME/src/skills/__init__.py"
touch "$PROJECT_NAME/src/data/__init__.py"
touch "$PROJECT_NAME/src/utils/__init__.py"

# 3. Crear archivos fuente vacíos
touch "$PROJECT_NAME/src/core/{orchestrator.py,config_loader.py,prompt_engine.py}"
touch "$PROJECT_NAME/src/agents/{base_agent.py,macro.py,technical.py,risk.py,portfolio.py}"
touch "$PROJECT_NAME/src/skills/{trend_confirmator.py,staggered_rotation.py,api_fetcher.py,rem_parser.py,logger.py,snippet_generator.py}"
touch "$PROJECT_NAME/src/data/{api_client.py,models.py,cache.py}"
touch "$PROJECT_NAME/src/utils/{validators.py,formatters.py,exceptions.py}"
touch "$PROJECT_NAME/database/schema.sql"
touch "$PROJECT_NAME/tests/conftest.py"
touch "$PROJECT_NAME/docs/{architecture.md,api_reference.md,user_guide.md}"
touch "$PROJECT_NAME/scripts/{backup_db.py,monitor_health.py}"
touch "$PROJECT_NAME/notebooks/{01_exploracion_inicial.ipynb,02_validacion_señales.ipynb,03_backtesting_simple.ipynb}"

# 4. Inyectar contenido inicial en archivos clave

cat << 'EOF' > "$PROJECT_NAME/README.md"
# Quant Analyst Argentina 🇦🇷🤖

Sistema proactivo de análisis de inversiones para el mercado argentino.
Integra NotebookLM, ArgentinaDatos API y agentes de IA especializados.

## 📁 Estructura
- \`src/\`: Código modular (orquestador, agentes, skills)
- \`database/\`: Esquema SQL y migraciones
- \`notebooks/\`: Validaciones y backtesting
- \`scripts/\`: Despliegue y monitoreo

## 🛠️ Instalación
\`\`\`bash
pip install -r requirements.txt
\`\`\`

## ▶️ Ejecución
\`\`\`bash
python -m src.core.orchestrator
\`\`\`
EOF

cat << 'EOF' > "$PROJECT_NAME/requirements.txt"
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.2
sqlalchemy==2.0.23
alembic==1.13.0
httpx==0.25.2
pyyaml==6.0.1
python-dotenv==1.0.0
pandas==2.1.4
numpy==1.26.2
pytest==7.4.3
pytest-asyncio==0.23.2
structlog==23.2.0
EOF

cat << 'EOF' > "$PROJECT_NAME/config.yaml"
app:
  name: "Quant Analyst Argentina"
  version: "0.1.0"
  environment: "development"

thresholds:
  canje_alert: 6.0
  tasa_real_min: 0.5
  confirmation_window_days: 3
  max_single_rotation: 0.20

apis:
  argentinadatos:
    base_url: "https://api.argentinadatos.com/v1"
    timeout_seconds: 10
    retry_attempts: 3

database:
  dev:
    url: "sqlite:///./data/quant_dev.db"
  prod:
    url: "postgresql://user:pass@host:5432/quant_prod"

logging:
  level: "INFO"
  format: "json"
  output: "./logs/decisions.log"
EOF

cat << 'EOF' > "$PROJECT_NAME/database/schema.sql"
-- Esquema principal: SQLite (dev) / PostgreSQL (prod)
-- Ejecutar: sqlite3 data/quant_dev.db < database/schema.sql

CREATE TABLE IF NOT EXISTS decisions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT NOT NULL,
    query_text TEXT NOT NULL,
    query_type TEXT CHECK(query_type IN ('macro','technical','risk','portfolio','general')),
    agents_used TEXT NOT NULL,
    signal TEXT CHECK(signal IN ('BUY','SELL','HOLD','ROTATE')),
    instrument TEXT,
    confidence_level TEXT CHECK(confidence_level IN ('Alta','Media','Baja')),
    thresholds_applied TEXT,
    rotation_plan TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS outcomes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    decision_id INTEGER NOT NULL,
    actual_result TEXT,
    accuracy_score REAL CHECK(accuracy_score BETWEEN 0 AND 1),
    lessons_learned TEXT,
    evaluated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (decision_id) REFERENCES decisions(id)
);

CREATE INDEX IF NOT EXISTS idx_decisions_ts ON decisions(timestamp);
CREATE INDEX IF NOT EXISTS idx_outcomes_acc ON outcomes(accuracy_score);
EOF

cat << 'EOF' > "$PROJECT_NAME/scripts/deploy.sh"
#!/bin/bash
set -e
echo "🚀 Desplegando Quant Argentina..."
echo "📦 Instalando dependencias..."
pip install -r requirements.txt --quiet
echo "✅ Deploy finalizado. Iniciando servicio..."
# uvicorn src.api.main:app --host 0.0.0.0 --port 8000
EOF
chmod +x "$PROJECT_NAME/scripts/deploy.sh"

echo "✅ Estructura del proyecto '$PROJECT_NAME' creada exitosamente."
echo "📁 Para comenzar a trabajar:"
echo "   cd $PROJECT_NAME"
echo "   pip install -r requirements.txt"
echo "   python -c \"import src; print('Sistema listo 🇦🇷📈')\""
