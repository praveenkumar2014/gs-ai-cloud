# GS-AI-CLOUD

Production-ready modular AI Cloud stack for Dokploy and Docker Compose v2. It bundles secure ingress, databases, model-serving runtimes, AI applications, agent services, and observability with named volumes, health checks, restart policies, logging, and environment-driven configuration.

## Architecture

| Stack | File | Services |
| --- | --- | --- |
| Core | `stacks/core.yml` | Traefik, Watchtower, Portainer Agent, Docker Socket Proxy |
| Database | `stacks/database.yml` | PostgreSQL, Redis, MinIO, Qdrant |
| AI | `stacks/ai.yml` | Ollama, LiteLLM, vLLM, SGLang, Infinity |
| Apps | `stacks/apps.yml` | Open WebUI, LibreChat, Flowise, Langflow, Dify, n8n, OpenHands, AnythingLLM |
| Agents | `stacks/agents.yml` | Crawl4AI, Firecrawl, Browser Use, MCP Gateway, OpenMemory, agent orchestrator |
| Monitoring | `stacks/monitoring.yml` | Prometheus, Grafana, Loki, Promtail, Uptime Kuma |

## Quick start

```bash
cp .env.example .env
# edit .env secrets and domains
./scripts/install.sh cpu
```

For GPU hosts with the NVIDIA Container Toolkit:

```bash
./scripts/install.sh gpu
```

## Dokploy deployment

1. Create a Dokploy Compose application from this repository.
2. Set the compose file to `docker-compose.yml`.
3. Copy `.env.example` into Dokploy environment variables and replace every `change-me-*` value.
4. Point wildcard DNS for `*.your-domain` to the Dokploy host.
5. Choose profile `cpu` for default operation or `gpu` for NVIDIA-backed model serving.
6. Deploy. Traefik provisions public HTTPS routes through Let's Encrypt.

## Operations

```bash
./scripts/healthcheck.sh
./scripts/update.sh cpu
./scripts/backup.sh
./scripts/restore.sh backups/<timestamp>
```

## Security baseline

- Never deploy with `.env.example` secrets.
- Keep public exposure limited to Traefik routes.
- Keep databases on internal networks.
- Use Docker Socket Proxy for read-only Docker API access where possible.
- Rotate LiteLLM, application, and database credentials regularly.
- Enable Dokploy host firewall rules for ports 80/443 only unless operationally required.

See `docs/` for detailed installation, deployment, backup, restore, update, troubleshooting, and security guides.
