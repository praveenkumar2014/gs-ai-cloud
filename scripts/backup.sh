#!/usr/bin/env bash
set -euo pipefail

# GS-AI-CLOUD Automated Backup Script
echo "======================================================"
echo "          GS-AI-CLOUD BACKUP UTILITY                 "
echo "======================================================"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="${ROOT_DIR}/backups/${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

echo "Backup Destination: ${BACKUP_DIR}"

# Backup 1: Environment & Config Files
echo "[1/4] Backing up configuration files and .env..."
cp .env "$BACKUP_DIR/.env" 2>/dev/null || true
cp -r configs "$BACKUP_DIR/configs" 2>/dev/null || true

# Backup 2: PostgreSQL Database Dump
echo "[2/4] Dumping PostgreSQL database..."
if docker ps | grep -q "gs-ai-postgres"; then
    POSTGRES_USER=$(grep POSTGRES_USER .env | cut -d '=' -f2 | tr -d ' "' || echo "gscloud")
    POSTGRES_DB=$(grep POSTGRES_DB .env | cut -d '=' -f2 | tr -d ' "' || echo "gscloud")
    docker exec gs-ai-postgres pg_dumpall -U "$POSTGRES_USER" > "$BACKUP_DIR/postgres_dump.sql" || echo "WARNING: Postgres dump failed."
    echo "PostgreSQL backup completed: postgres_dump.sql"
else
    echo "PostgreSQL container not running, skipping database dump."
fi

# Backup 3: Redis Snapshot
echo "[3/4] Triggering Redis RDB save..."
if docker ps | grep -q "gs-ai-redis"; then
    REDIS_PASS=$(grep REDIS_PASSWORD .env | cut -d '=' -f2 | tr -d ' "' || echo "")
    if [ -n "$REDIS_PASS" ]; then
        docker exec gs-ai-redis redis-cli -a "$REDIS_PASS" save || true
    else
        docker exec gs-ai-redis redis-cli save || true
    fi
    echo "Redis snapshot triggered."
else
    echo "Redis container not running, skipping Redis snapshot."
fi

# Backup 4: Archive Backup Bundle
echo "[4/4] Creating tar.gz archive..."
ARCHIVE_PATH="${ROOT_DIR}/backups/gs_ai_cloud_backup_${TIMESTAMP}.tar.gz"
tar -czf "$ARCHIVE_PATH" -C "$BACKUP_DIR" .
rm -rf "$BACKUP_DIR"

echo "Backup completed successfully!"
echo "Archive created: ${ARCHIVE_PATH}"
echo "======================================================"
