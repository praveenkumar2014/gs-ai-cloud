# Troubleshooting Guide

## Purpose

This guide covers the Troubleshooting workflow for GS-AI-CLOUD on Docker Compose v2 and Dokploy.

## Prerequisites

- Docker Engine with Compose v2.
- Dokploy host with DNS pointing to the server.
- `.env` created from `.env.example` with production secrets.
- NVIDIA Container Toolkit for the `gpu` profile when using accelerated runtimes.

## Procedure

1. Review `docker-compose.yml` and the modular files in `stacks/`.
2. Validate configuration with `docker compose --profile cpu config` or `docker compose --profile gpu config`.
3. Run the matching script from `scripts/` when applicable.
4. Confirm service status with `./scripts/healthcheck.sh` and Dokploy logs.

## Production notes

- Back up named volumes before major changes with `./scripts/backup.sh`.
- Keep all application data on named volumes.
- Use Dokploy secrets or environment variables for credentials.
- Monitor application health in Grafana and Uptime Kuma.
- Review service-specific upstream documentation before enabling public access to new tools.

## Dokploy error: `dockerfile parse error ... unknown instruction: version/name`

This means Dokploy is using the Compose file as a **Dockerfile build definition** instead of deploying it as a **Compose application**. The platform is not failing because of YAML syntax; it is invoking Docker BuildKit against `docker-compose.yml`.

Fix in Dokploy:

1. Open the application settings.
2. Change the application/build type to **Compose**.
3. Set the compose path to `dokploy-compose.yml` or `docker-compose.yml`.
4. Do not set `docker-compose.yml` as the Dockerfile path.
5. Redeploy from branch `main`.

The repository includes `dokploy-compose.yml` as a Dokploy-safe Compose entrypoint that includes the canonical root `docker-compose.yml`.
