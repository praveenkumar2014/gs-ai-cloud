#!/usr/bin/env bash
set -euo pipefail

# GS-AI-CLOUD Automated Restoration Script
echo "======================================================"
echo "          GS-AI-CLOUD RESTORE UTILITY                "
echo "======================================================"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-backup-archive.tar.gz>"
    echo "Available backups in backups/ directory:"
    ls -lh backups/*.tar.gz 2>/dev/null || echo "No backups found."
    exit 1
fi

ARCHIVE_PATH="$1"

if [ ! -f "$ARCHIVE_PATH" ]; then
    echo "ERROR: Backup archive '$ARCHIVE_PATH' does not exist."
    exit 1
fi

TEMP_RESTORE_DIR="/tmp/gs_ai_restore_$(date +%s)"
mkdir -p "$TEMP_RESTORE_DIR"

echo "Extracting backup archive..."
tar -xzf "$ARCHIVE_PATH" -C "$TEMP_RESTORE_DIR"

# Restore Postgres
if [ -f "$TEMP_RESTORE_DIR/postgres_dump.sql" ]; then
    echo "Restoring PostgreSQL database..."
    if docker ps | grep -q "gs-ai-postgres"; then
        POSTGRES_USER=$(grep POSTGRES_USER .env | cut -d '=' -f2 | tr -d ' "' || echo "gscloud")
        docker exec -i gs-ai-postgres psql -U "$POSTGRES_USER" < "$TEMP_RESTORE_DIR/postgres_dump.sql"
        echo "PostgreSQL database restored successfully."
    else
        echo "WARNING: PostgreSQL container is not running. Start the database stack first."
    fi
fi

# Restore Configs
if [ -d "$TEMP_RESTORE_DIR/configs" ]; then
    echo "Restoring configs directory..."
    cp -r "$TEMP_RESTORE_DIR/configs/"* configs/
    echo "Configs restored."
fi

rm -rf "$TEMP_RESTORE_DIR"

echo "======================================================"
echo "       GS-AI-CLOUD RESTORATION COMPLETED             "
echo "======================================================"
