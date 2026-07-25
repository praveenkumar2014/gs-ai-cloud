#!/usr/bin/env bash
set -euo pipefail
PROJECT=${COMPOSE_PROJECT_NAME:-gs-ai-cloud}
TS=$(date -u +%Y%m%dT%H%M%SZ)
DEST=${1:-backups/$TS}
mkdir -p "$DEST"
docker compose exec -T postgres pg_dumpall -U "${POSTGRES_USER:-gsai}" > "$DEST/postgres.sql"
for vol in minio_data qdrant_data ollama_data redis_data grafana_data; do
  docker run --rm -v "${PROJECT}_${vol}:/data:ro" -v "$(pwd)/$DEST:/backup" alpine tar czf "/backup/${vol}.tgz" -C /data . || true
done
tar czf "$DEST/configs.tgz" configs .env docker-compose.yml stacks
printf 'Backup written to %s\n' "$DEST"
