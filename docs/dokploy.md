# Dokploy Deployment Guide — GS-AI-CLOUD

This guide details how to deploy **GS-AI-CLOUD** on [Dokploy](https://dokploy.com/), the self-hosted PaaS alternative to Vercel/Heroku.

---

## Architecture Overview on Dokploy

Dokploy manages applications via Docker Compose Stacks. GS-AI-CLOUD is designed with modular stacks that can be deployed either as a single unified stack or as 6 individual modular stacks inside Dokploy's UI.

```
+-------------------------------------------------------------+
|                        DOKPLOY UI                           |
+-------------------------------------------------------------+
   |             |             |             |            |
   v             v             v             v            v
Stack 1       Stack 2       Stack 3       Stack 4      Stack 5/6
(Core)       (Database)      (AI)         (Apps)      (Agents/Mon)
```

---

## Deployment Option A: Unified Stack Import (Recommended)

1. Open your **Dokploy Dashboard**.
2. Navigate to **Projects** -> Create Project `GS-AI-CLOUD`.
3. Click **Compose** -> **Create Stack**.
4. Set Stack Name: `gs-ai-cloud`.
5. Select Source: **Git Repository**.
   - Repository URL: `https://github.com/praveenkumar2014/gs-ai-cloud`
   - Branch: `main`
   - Compose Path: `templates/dokploy-stack-template.yml`
6. Under **Environment Variables**, paste the contents of `.env.example` (customized with your secrets and domain name).
7. Click **Deploy**.

---

## Deployment Option B: Modular Stack Deployment

For granular control, high availability, or resource segregation, deploy each stack individually in Dokploy:

### Step 1: Create Shared Network
In your server terminal or Dokploy pre-deploy script:
```bash
docker network create gs-ai-network || true
```

### Step 2: Add Stacks sequentially

| Priority | Stack Name | Compose Path | Description |
|---|---|---|---|
| 1 | `gs-ai-core` | `stacks/core.yml` | Traefik, Watchtower, Socket Proxy |
| 2 | `gs-ai-database` | `stacks/database.yml` | Postgres, Redis, MinIO, Qdrant |
| 3 | `gs-ai-engine` | `stacks/ai.yml` | Ollama, LiteLLM, vLLM, SGLang, Infinity |
| 4 | `gs-ai-apps` | `stacks/apps.yml` | Open WebUI, LibreChat, n8n, Dify, etc. |
| 5 | `gs-ai-agents` | `stacks/agents.yml` | Crawl4AI, Firecrawl, MCP Gateway |
| 6 | `gs-ai-monitoring` | `stacks/monitoring.yml` | Prometheus, Grafana, Loki |

---

## Routing & SSL Configuration in Dokploy

When deploying through Dokploy:
1. Enable **Traefik Integration** in Dokploy settings if using Dokploy's managed proxy, OR
2. Use the included **Traefik container in `stacks/core.yml`** by mapping host ports `80` and `443`.
3. Configure your DNS A/AAAA records to point to your Dokploy server IP:
   - `ai.yourdomain.com` -> Server IP
   - `*.ai.yourdomain.com` -> Server IP (Wildcard)

---

## Dokploy Environment Variables Setup

Ensure the following critical variables are set in the Dokploy Environment panel:
```env
DOMAIN=ai.yourdomain.com
POSTGRES_PASSWORD=your_secure_postgres_pass
REDIS_PASSWORD=your_secure_redis_pass
MINIO_ROOT_PASSWORD=your_secure_minio_pass
QDRANT_API_KEY=your_secure_qdrant_key
LITELLM_MASTER_KEY=sk-your-master-key
```
