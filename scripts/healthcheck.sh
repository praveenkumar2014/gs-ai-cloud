#!/usr/bin/env bash
set -euo pipefail

# GS-AI-CLOUD Health Diagnostic Script
echo "======================================================"
echo "          GS-AI-CLOUD HEALTH DIAGNOSTIC               "
echo "======================================================"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Timestamp: $(date)"
echo "------------------------------------------------------"
printf "%-30s %-15s %-15s\n" "CONTAINER NAME" "STATUS" "HEALTH"
echo "------------------------------------------------------"

CONTAINERS=(
    "gs-ai-traefik"
    "gs-ai-watchtower"
    "gs-ai-portainer-agent"
    "gs-ai-docker-socket-proxy"
    "gs-ai-postgres"
    "gs-ai-redis"
    "gs-ai-minio"
    "gs-ai-qdrant"
    "gs-ai-ollama"
    "gs-ai-litellm"
    "gs-ai-vllm"
    "gs-ai-sglang"
    "gs-ai-infinity"
    "gs-ai-open-webui"
    "gs-ai-librechat"
    "gs-ai-flowise"
    "gs-ai-langflow"
    "gs-ai-dify"
    "gs-ai-n8n"
    "gs-ai-openhands"
    "gs-ai-anythingllm"
    "gs-ai-crawl4ai"
    "gs-ai-firecrawl"
    "gs-ai-browser-use"
    "gs-ai-mcp-gateway"
    "gs-ai-openmemory"
    "gs-ai-agent-orchestrator"
    "gs-ai-prometheus"
    "gs-ai-grafana"
    "gs-ai-loki"
    "gs-ai-promtail"
    "gs-ai-uptime-kuma"
)

TOTAL=0
HEALTHY=0
UNHEALTHY=0
NOT_RUNNING=0

for container in "${CONTAINERS[@]}"; do
    TOTAL=$((TOTAL + 1))
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        STATUS=$(docker inspect --format '{{.State.Status}}' "$container" 2>/dev/null || echo "unknown")
        HEALTH=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}N/A{{end}}' "$container" 2>/dev/null || echo "N/A")
        printf "%-30s %-15s %-15s\n" "$container" "$STATUS" "$HEALTH"
        if [ "$HEALTH" = "healthy" ] || [ "$HEALTH" = "N/A" ]; then
            HEALTHY=$((HEALTHY + 1))
        else
            UNHEALTHY=$((UNHEALTHY + 1))
        fi
    else
        printf "%-30s %-15s %-15s\n" "$container" "STOPPED" "OFFLINE"
        NOT_RUNNING=$((NOT_RUNNING + 1))
    fi
done

echo "------------------------------------------------------"
echo "SUMMARY:"
echo "Total Services Tracked: $TOTAL"
echo "Running/Healthy:        $HEALTHY"
echo "Unhealthy:              $UNHEALTHY"
echo "Stopped/Not Deployed:   $NOT_RUNNING"
echo "======================================================"
