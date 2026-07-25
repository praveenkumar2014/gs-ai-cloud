#!/usr/bin/env bash
set -euo pipefail

# GS-AI-CLOUD Installation Script
echo "======================================================"
echo "          GS-AI-CLOUD PLATFORM INSTALLER             "
echo "======================================================"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Step 1: Pre-flight Checks
echo "[1/5] Running pre-flight system checks..."

if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Please install Docker before proceeding."
    exit 1
fi

echo "Docker version check passed: $(docker --version)"

# Step 2: Environment Setup
echo "[2/5] Setting up environment configuration..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "Created .env from .env.example"
    else
        echo "ERROR: .env.example not found!"
        exit 1
    fi
else
    echo ".env file already exists."
fi

# Step 3: Create Docker Network
echo "[3/5] Creating dedicated Docker network..."
NETWORK_NAME=$(grep DOCKER_NETWORK .env | cut -d '=' -f2 | tr -d ' "' || echo "gs-ai-network")
NETWORK_NAME=${NETWORK_NAME:-gs-ai-network}

if ! docker network inspect "$NETWORK_NAME" &> /dev/null; then
    docker network create "$NETWORK_NAME"
    echo "Created Docker network: $NETWORK_NAME"
else
    echo "Docker network '$NETWORK_NAME' already exists."
fi

# Step 4: Create Directory Structure & Backups Folder
echo "[4/5] Preparing persistent directories..."
mkdir -p backups configs/traefik/dynamic configs/prometheus configs/loki configs/promtail configs/grafana/provisioning/datasources configs/grafana/provisioning/dashboards configs/litellm configs/qdrant

# Step 5: Stack Deployment Guidance
echo "[5/5] Installation preparation complete!"
echo "------------------------------------------------------"
echo "To launch the entire platform, run:"
echo "  docker compose up -d"
echo ""
echo "To launch individual stacks, run:"
echo "  docker compose -f stacks/core.yml up -d"
echo "  docker compose -f stacks/database.yml up -d"
echo "  docker compose -f stacks/ai.yml up -d"
echo "  docker compose -f stacks/apps.yml up -d"
echo "  docker compose -f stacks/agents.yml up -d"
echo "  docker compose -f stacks/monitoring.yml up -d"
echo "======================================================"
