# Dokploy Deployment Guide

## Target domain

This repository is prepared for `admin.guidesoft.online` by default. Update `DOMAIN` in Dokploy if you want a different root domain.

## Deploy in Dokploy

1. Create a new **Compose** application in Dokploy.
2. Use repository `praveenkumar2014/gs-ai-cloud` and branch `main`.
3. Set the compose file path to `docker-compose.yml`.
4. Import `.env.example` into Dokploy environment variables.
5. Replace every `change-me-*` secret before the first deployment.
6. Confirm DNS records for the configured hostnames point to the Dokploy server.
7. Deploy with profile `cpu` unless the host has NVIDIA Container Toolkit; then use `gpu`.
8. After deployment, open `https://chat.admin.guidesoft.online`, `https://grafana.admin.guidesoft.online`, and `https://status.admin.guidesoft.online`.

## Required exposed ports

Only ports `80/tcp` and `443/tcp` need to be exposed publicly. Databases and model runtimes remain on private Docker networks.

## Post-deploy checks

Run `./scripts/healthcheck.sh` from the Dokploy terminal or inspect service health in the Dokploy UI. Configure Uptime Kuma checks for the public application URLs after first login.
