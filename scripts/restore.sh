#!/usr/bin/env bash
set -euo pipefail
PROJECT=${COMPOSE_PROJECT_NAME:-gs-ai-cloud}
SRC=${1:?Usage: scripts/restore.sh backups/YYYYmmddTHHMMSSZ}
[ -f "$SRC/postgres.sql" ] && docker compose exec -T postgres psql -U "${POSTGRES_USER:-gsai}" -d postgres < "$SRC/postgres.sql"
for archive in "$SRC"/*.tgz; do
  [ -f "$archive" ] || continue
  base=$(basename "$archive" .tgz)
  [ "$base" = "configs" ] && continue
  docker run --rm -v "${PROJECT}_${base}:/data" -v "$(pwd)/$SRC:/backup" alpine sh -c "rm -rf /data/* && tar xzf /backup/${base}.tgz -C /data"
done
printf 'Restore completed from %s\n' "$SRC"
