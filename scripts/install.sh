#!/usr/bin/env bash
set -euo pipefail
PROFILE=${1:-cpu}
[ -f .env ] || cp .env.example .env
mkdir -p backups
chmod 700 backups
printf 'Validating compose...\n'
docker compose --profile "$PROFILE" config >/dev/null
printf 'Starting GS-AI-CLOUD with profile %s...\n' "$PROFILE"
docker compose --profile "$PROFILE" up -d
./scripts/healthcheck.sh
