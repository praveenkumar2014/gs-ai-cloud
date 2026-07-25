# Security Hardening Guide — GS-AI-CLOUD

This document outlines the security architecture and hardening best practices implemented in **GS-AI-CLOUD**.

---

## 1. Security Architecture

```
Internet ---> [ Traefik Proxy (SSL/TLS TLS1.3) ]
                     |
                     v
             [ Internal Network: gs-ai-network ]
                     |
       +-------------+-------------+
       |                           |
[ Apps / Agents ]        [ Docker Socket Proxy ]
 (Restricted User)       (Filter Dangerous API Calls)
```

---

## 2. Docker Socket Proxy Protection

Raw access to `/var/run/docker.sock` gives containers root privilege over the host system. GS-AI-CLOUD uses `tecnativa/docker-socket-proxy` to filter API calls made by Watchtower, Promtail, and OpenHands.

- Read-only endpoints allowed: `GET /containers`, `GET /events`
- Dangerous endpoints blocked: `POST /exec`, `DELETE /volumes`, raw host mounts

---

## 3. Mandatory Security Hardening Checklist

- [ ] **Change All Default Passwords**: Modify `.env` default passwords for Postgres, Redis, MinIO, Qdrant, Grafana, and LiteLLM.
- [ ] **Restrict Traefik Dashboard**: Secure port 8080 with basic auth or Traefik IP whitelist.
- [ ] **Enable Firewall (UFW)**: Close all ports except 80, 443, and SSH (22).
  ```bash
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw enable
  ```
- [ ] **Rotate API Keys Regularly**: Keep `LITELLM_MASTER_KEY` and `QDRANT_API_KEY` secure.
