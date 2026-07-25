# Installation Guide

## Purpose

This guide covers the Installation workflow for GS-AI-CLOUD on Docker Compose v2 and Dokploy.

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
