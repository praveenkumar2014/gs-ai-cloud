#!/usr/bin/env bash
set -euo pipefail
SRC=${1:?Usage: scripts/restore.sh backups/YYYYmmddTHHMMSSZ}
[ -f "$SRC/postgres.sql" ] && docker compose exec -T postgres psql -U "${POSTGRES_USER:-gsai}" -d postgres < "$SRC/postgres.sql"
for vol in minio_data qdrant_data ollama_data; do
  [ -f "$SRC/${vol}.tgz" ] || continue
  docker run --rm -v gs-ai-cloud_${vol}:/data -v "$(pwd)/$SRC:/backup" alpine sh -c "rm -rf /data/* && tar xzf /backup/${vol}.tgz -C /data"
done
printf 'Restore completed from %s\n' "$SRC"
