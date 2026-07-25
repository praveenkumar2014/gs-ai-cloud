# Bare-Metal & VPS Installation Guide — GS-AI-CLOUD

This guide covers installing and running the **GS-AI-CLOUD** enterprise AI infrastructure platform on a Linux VPS, Bare-Metal Server, or Cloud Instance (Ubuntu / Debian / RHEL).

---

## 1. System Requirements

### Hardware Requirements
| Component | Minimum | Recommended (Production) |
|---|---|---|
| **CPU** | 4 Cores | 16+ Cores |
| **RAM** | 16 GB | 64 GB+ |
| **Storage** | 100 GB NVMe | 1 TB+ NVMe |
| **GPU** | Optional (CPU fallback) | NVIDIA RTX 4090 / A100 / H100 (for vLLM/SGLang) |

### Software Prerequisites
- Docker Engine v24.0+
- Docker Compose v2 (2.20+)
- Git & Bash
- NVIDIA Container Toolkit (Optional, for GPU acceleration)

---

## 2. Pre-Installation Setup

### Install Docker & Docker Compose v2
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

### Install NVIDIA Container Toolkit (Optional for GPU)
```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

## 3. Deployment Steps

### Step 1: Clone Repository
```bash
git clone https://github.com/praveenkumar2014/gs-ai-cloud.git
cd gs-ai-cloud
```

### Step 2: Initialize Configuration
Run the automated installer script:
```bash
./scripts/install.sh
```

### Step 3: Edit Environment Variables
Customize `.env` with your domain, credentials, and keys:
```bash
nano .env
```
Key parameters to configure:
- `DOMAIN`: Main domain (e.g. `ai.yourdomain.com`)
- `ACME_EMAIL`: Your email for Let's Encrypt SSL certificates
- `POSTGRES_PASSWORD`, `REDIS_PASSWORD`, `MINIO_ROOT_PASSWORD`, `QDRANT_API_KEY`
- `LITELLM_MASTER_KEY`

### Step 4: Launch Stacks

#### Deploy All Stacks (Full Platform)
```bash
docker compose up -d
```

#### Modular Launch (Selective Stacks)
```bash
docker compose -f stacks/core.yml up -d
docker compose -f stacks/database.yml up -d
docker compose -f stacks/ai.yml up -d
docker compose -f stacks/apps.yml up -d
docker compose -f stacks/agents.yml up -d
docker compose -f stacks/monitoring.yml up -d
```

---

## 4. Verification

Check the system status using the healthcheck script:
```bash
./scripts/healthcheck.sh
```
