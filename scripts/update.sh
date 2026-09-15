#!/usr/bin/env bash
set -euo pipefail
PROFILE=${1:-cpu}
git pull --ff-only || true
docker compose --profile "$PROFILE" pull
docker compose --profile "$PROFILE" up -d --remove-orphans
./scripts/healthcheck.sh
