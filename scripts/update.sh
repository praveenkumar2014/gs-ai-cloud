#!/usr/bin/env bash
set -euo pipefail

# GS-AI-CLOUD Stack Update Script
echo "======================================================"
echo "          GS-AI-CLOUD PLATFORM UPDATER               "
echo "======================================================"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Step 1: Pre-update Backup Trigger
echo "[1/4] Triggering automated pre-update backup..."
if [ -f "scripts/backup.sh" ]; then
    bash scripts/backup.sh || echo "WARNING: Backup encountered an issue, proceeding with caution..."
fi

# Step 2: Pull Latest Docker Images
echo "[2/4] Pulling updated container images..."
for stack in stacks/*.yml; do
    echo "Pulling images for $stack..."
    docker compose -f "$stack" pull || echo "Notice: Some images in $stack skipped or unchanged."
done

# Step 3: Recreate Services
echo "[3/4] Recreating containers with updated images..."
if [ -f "docker-compose.yml" ]; then
    docker compose up -d --remove-orphans
else
    for stack in stacks/*.yml; do
        docker compose -f "$stack" up -d
    done
fi

# Step 4: Cleanup Dangling Images
echo "[4/4] Pruning unused dangling images..."
docker image prune -f

echo "======================================================"
echo "       GS-AI-CLOUD UPDATE COMPLETED SUCCESSFULLY      "
echo "======================================================"
