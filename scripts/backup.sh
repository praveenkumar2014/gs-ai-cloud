#!/usr/bin/env bash
set -euo pipefail
TS=$(date -u +%Y%m%dT%H%M%SZ)
DEST=${1:-backups/$TS}
mkdir -p "$DEST"
docker compose exec -T postgres pg_dumpall -U "${POSTGRES_USER:-gsai}" > "$DEST/postgres.sql"
docker run --rm -v gs-ai-cloud_minio_data:/data:ro -v "$(pwd)/$DEST:/backup" alpine tar czf /backup/minio_data.tgz -C /data .
docker run --rm -v gs-ai-cloud_qdrant_data:/data:ro -v "$(pwd)/$DEST:/backup" alpine tar czf /backup/qdrant_data.tgz -C /data .
docker run --rm -v gs-ai-cloud_ollama_data:/data:ro -v "$(pwd)/$DEST:/backup" alpine tar czf /backup/ollama_data.tgz -C /data . || true
tar czf "$DEST/configs.tgz" configs .env docker-compose.yml stacks
printf 'Backup written to %s\n' "$DEST"
