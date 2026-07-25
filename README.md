# 🚀 GS-AI-CLOUD — Enterprise AI Infrastructure Platform

[![Docker Compose v2](https://img.shields.io/badge/Docker_Compose-v2-blue.svg?logo=docker)](https://docs.docker.com/compose/)
[![Dokploy Ready](https://img.shields.io/badge/Dokploy-Ready-success.svg)](https://dokploy.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GPU Accelerated](https://img.shields.io/badge/NVIDIA-CUDA_Ready-green.svg?logo=nvidia)](https://developer.nvidia.com/cuda-zone)

**GS-AI-CLOUD** is a production-ready, enterprise-grade, modular AI Cloud platform engineered for effortless deployment on **[Dokploy](https://dokploy.com/)** and **Docker Compose v2**.

---

## 🌟 Architectural Features

- 🧩 **Modular 6-Stack Architecture**: Deploy individual stacks independently or orchestrate the full platform via Docker Compose v2 `include`.
- ⚡ **Unified Inference Engine**: Local LLM runner (Ollama), high-throughput inference (vLLM, SGLang), text embeddings (Infinity), and unified multi-provider routing (LiteLLM).
- 🤖 **Agentic & Scraper Suite**: Web scraping engines (Crawl4AI, Firecrawl), autonomous browser agents (Browser Use), long-term memory (OpenMemory), and Model Context Protocol (MCP Gateway).
- 🛠️ **Full Application Suite**: Open WebUI, LibreChat, Flowise, Langflow, Dify, n8n, OpenHands, and AnythingLLM.
- 🛡️ **Enterprise Security & Isolation**: Traefik Edge reverse proxy with Let's Encrypt TLS, socket proxy isolation (`tecnativa/docker-socket-proxy`), and persistent volume segregation.
- 📊 **Complete Observability**: Prometheus metrics, Grafana dashboards, Loki log aggregation, Promtail shipper, and Uptime Kuma monitoring.
- 🎮 **GPU Acceleration & CPU Fallback**: Native NVIDIA container toolkit support with automatic CPU fallback.

---

## 🏗️ Repository Structure

```
gs-ai-cloud/
├── docker-compose.yml              # Master Orchestrator (Docker Compose v2 include)
├── .env.example                    # Enterprise Environment Template
├── README.md                       # Main Documentation & System Overview
├── LICENSE                         # MIT Open Source License
├── docs/                           # Comprehensive Operations Guides
│   ├── installation.md             # Bare-Metal & VPS Setup Guide
│   ├── dokploy.md                  # Dokploy Deployment Guide
│   ├── backup.md                   # Automated Backup Procedures
│   ├── restore.md                  # Disaster Recovery Guide
│   ├── update.md                   # Zero-Downtime Update Guide
│   ├── troubleshooting.md          # Diagnostics & Issue Resolution
│   └── security.md                 # System Hardening & Isolation
├── scripts/                        # Maintenance & Management Scripts
│   ├── install.sh                  # Pre-flight System Installer
│   ├── update.sh                   # Automated Stack Updater
│   ├── backup.sh                   # Database & Config Backup Script
│   ├── restore.sh                  # Backup Restoration Script
│   └── healthcheck.sh              # Platform Diagnostic Tool
├── stacks/                         # Modular Stack Definitions
│   ├── core.yml                    # Traefik, Watchtower, Portainer Agent, Socket Proxy
│   ├── database.yml                # PostgreSQL, Redis, MinIO, Qdrant
│   ├── ai.yml                      # Ollama, LiteLLM, vLLM, SGLang, Infinity
│   ├── apps.yml                    # Open WebUI, LibreChat, Flowise, Langflow, Dify, n8n, OpenHands, AnythingLLM
│   ├── agents.yml                  # Crawl4AI, Firecrawl, Browser Use, MCP Gateway, OpenMemory, Agent Orchestration
│   └── monitoring.yml              # Prometheus, Grafana, Loki, Promtail, Uptime Kuma
├── configs/                        # Service Configurations
│   ├── traefik/                    # Static & Dynamic TLS Configs
│   ├── prometheus/                 # Prometheus Scrape Targets
│   ├── loki/                       # Loki Storage & Ingestion Config
│   ├── promtail/                   # Promtail Log Shipping Rules
│   ├── grafana/                    # Datasources & Dashboards Provisioning
│   ├── litellm/                    # LiteLLM Proxy Routing Config
│   └── qdrant/                     # Vector DB Configuration
├── backups/                        # Backup Target Directory
├── templates/                      # Deployment Templates
│   └── dokploy-stack-template.yml  # Dokploy Unified Stack Import File
└── examples/                       # Developer & Custom Agent Examples
    ├── custom-agent.yml            # Custom Agent Composition Example
    └── dokploy-env-setup.md        # Dokploy Environment Reference
```

---

## 📦 Stack Overview

| Stack | Component Services | Purpose / Function |
|---|---|---|
| **STACK 1 — CORE** | Traefik, Watchtower, Portainer Agent, Docker Socket Proxy | Edge Proxy, SSL Certificates, Auto-updates, Container Management, Socket Hardening |
| **STACK 2 — DATABASE** | PostgreSQL, Redis, MinIO, Qdrant | Relational DB, Caching/Message Broker, Object Storage, Vector Database |
| **STACK 3 — AI ENGINE** | Ollama, LiteLLM, vLLM, SGLang, Infinity Embedding | Local LLM Serving, Unified Router/Gateway, High-throughput Inference, Fast Embeddings |
| **STACK 4 — APPLICATIONS** | Open WebUI, LibreChat, Flowise, Langflow, Dify, n8n, OpenHands, AnythingLLM | AI Web UIs, Visual Flow Builders, App Builders, Automation Workflows, Coding Sandbox, RAG |
| **STACK 5 — AGENTS** | Crawl4AI, Firecrawl, Browser Use, MCP Gateway, OpenMemory, Agent Orchestrator | Web Crawlers, Web Extraction, Autonomous Browser, MCP Protocols, Memory Store, Agent Bridge |
| **STACK 6 — MONITORING** | Prometheus, Grafana, Loki, Promtail, Uptime Kuma | Metrics Collection, Visual Dashboards, Centralized Logging, Uptime & Health Monitoring |

---

## 🚀 Quick Start (Bare-Metal / VPS)

### 1. Clone Repository & Run Installer
```bash
git clone https://github.com/praveenkumar2014/gs-ai-cloud.git
cd gs-ai-cloud
./scripts/install.sh
```

### 2. Configure Environment
Edit `.env` to set your domain and secrets:
```bash
nano .env
```

### 3. Launch Platform
```bash
# Launch entire platform
docker compose up -d

# Or launch individual modular stacks
docker compose -f stacks/core.yml up -d
docker compose -f stacks/database.yml up -d
docker compose -f stacks/ai.yml up -d
docker compose -f stacks/apps.yml up -d
docker compose -f stacks/agents.yml up -d
docker compose -f stacks/monitoring.yml up -d
```

### 4. Diagnostic Check
```bash
./scripts/healthcheck.sh
```

---

## 💜 Dokploy Deployment

Deploying on **Dokploy** takes less than 2 minutes:

1. Open your Dokploy Dashboard.
2. Create a new Stack in your Project.
3. Select Git Repository: `https://github.com/praveenkumar2014/gs-ai-cloud`
4. Set Compose Path: `templates/dokploy-stack-template.yml` (or `docker-compose.yml`).
5. Copy environment variables from `.env.example` into Dokploy.
6. Click **Deploy**.

For detailed instructions, refer to the [Dokploy Deployment Guide](docs/dokploy.md).

---

## 🛠️ Management & Automation Scripts

- `./scripts/install.sh`: System pre-flight validation, `.env` initialization, network setup.
- `./scripts/update.sh`: Automated pre-update backup, image pulling, zero-downtime stack recreation.
- `./scripts/backup.sh`: Dumps Postgres, snapshots Redis, packages configs & environment into timestamped `.tar.gz`.
- `./scripts/restore.sh`: Interactive database and volume restoration utility.
- `./scripts/healthcheck.sh`: Container status inspector and health monitor.

---

## 📄 Operational Documentation

- 📖 [Installation Guide](docs/installation.md)
- 🚀 [Dokploy Deployment Guide](docs/dokploy.md)
- 💾 [Backup Guide](docs/backup.md)
- 🔄 [Restore & Recovery Guide](docs/restore.md)
- 🆙 [Update & Maintenance Guide](docs/update.md)
- 🔧 [Troubleshooting Guide](docs/troubleshooting.md)
- 🛡️ [Security Hardening Guide](docs/security.md)

---

## 📜 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for details.
