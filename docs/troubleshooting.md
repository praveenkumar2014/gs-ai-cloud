# Troubleshooting Guide — GS-AI-CLOUD

Common issues, diagnostic commands, and resolution steps for **GS-AI-CLOUD**.

---

## 1. Quick Diagnostics

### Check All Services Status
```bash
./scripts/healthcheck.sh
```

### View Live Logs of a Service
```bash
docker logs -f gs-ai-litellm
docker logs -f gs-ai-ollama
docker logs -f gs-ai-postgres
```

---

## 2. Common Issues & Solutions

### Issue A: GPU Not Detected by Ollama / vLLM
**Symptoms**: Container logs show CPU-only fallback mode or `CUDA error: no CUDA-capable device is detected`.

**Resolution**:
1. Check host NVIDIA driver:
   ```bash
   nvidia-smi
   ```
2. Test Docker GPU access:
   ```bash
   docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
   ```
3. Restart Docker daemon:
   ```bash
   sudo systemctl restart docker
   ```

---

### Issue B: PostgreSQL Connection Refused
**Symptoms**: n8n, LiteLLM, or Dify fail to connect to Postgres.

**Resolution**:
1. Check Postgres container health:
   ```bash
   docker inspect --format='{{json .State.Health}}' gs-ai-postgres
   ```
2. Verify credentials in `.env` match `POSTGRES_USER` and `POSTGRES_PASSWORD`.

---

### Issue C: Traefik SSL Certificate Failures
**Symptoms**: Browser shows self-signed certificate warning or `ERR_CERT_AUTHORITY_INVALID`.

**Resolution**:
1. Ensure port 80 and 443 are open on host firewall (UFW/Security Group).
2. Check `ACME_EMAIL` in `.env`.
3. Check Traefik logs:
   ```bash
   docker logs gs-ai-traefik | grep acme
   ```

---

### Issue D: Out of Memory (OOM) Killed Container
**Symptoms**: LLM server or vLLM container exits unexpectedly with exit code 137.

**Resolution**:
1. Adjust model max context length or batch size in `stacks/ai.yml`.
2. Add swap space on Linux:
   ```bash
   sudo fallocate -l 16G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```
