#!/bin/bash
# ~/dev-tools/db-backup.sh
# Úsalo dentro de la carpeta del proyecto

DB_NAME=$1
DB_USER=$2
BACKUP_DIR="/mnt/NVME1TB/.db/backups'

mkdir -p $BACKUP_DIR
FILENAME="$BACKUP_DIR/backup_$(date +%F_%H-%M).sql"

echo "💾 Respaldando $DB_NAME en $FILENAME..."
pg_dump -U $DB_USER $DB_NAME > $FILENAME

# Comprimir
gzip $FILENAME
echo "✅ Backup completado: ${FILENAME}.gz"
