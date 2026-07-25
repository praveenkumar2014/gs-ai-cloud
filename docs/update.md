# System Update & Maintenance Guide — GS-AI-CLOUD

This guide covers updating container images, stack definitions, and maintaining platform health.

---

## 1. Automated Zero-Downtime Update

Run the update script:
```bash
./scripts/update.sh
```

### What `scripts/update.sh` Does:
1. Triggers pre-update automated backup.
2. Pulls updated container images from Docker Registries.
3. Recreates modified containers while keeping existing volumes intact.
4. Prunes obsolete dangling images.

---

## 2. Automatic Updates via Watchtower

Watchtower is included in `stacks/core.yml` and checks for updated container images automatically according to `WATCHTOWER_POLL_INTERVAL` (default: 24h).

To force Watchtower to update immediately:
```bash
docker exec gs-ai-watchtower --run-once
```

---

## 3. Rollback Procedure

If a component update breaks compatibility:
1. Revert to previous image version in the stack YAML file (e.g. `stacks/ai.yml`).
2. Run `docker compose up -d`.
3. Restore database if schema migration occurred using `./scripts/restore.sh`.
