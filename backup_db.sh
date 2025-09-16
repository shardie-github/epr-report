#!/usr/bin/env bash
set -euo pipefail
export PGPASSWORD="${DB_PWD:-pass}"
TIMESTAMP=$(date +%F_%H%M)
BACKUP_FILE="/tmp/db_backup_${TIMESTAMP}.sql.gz"
pg_dump -h ${DB_HOST:-localhost} -U ${DB_USER:-user} -d ${DB_NAME:-dbname} | gzip > "$BACKUP_FILE"
aws s3 cp "$BACKUP_FILE" s3://your-backup-bucket/hardonia/${HOSTNAME}/
find /tmp -name "db_backup_*.sql.gz" -mtime +7 -delete
