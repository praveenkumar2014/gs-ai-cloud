# Disaster Recovery & Restore Guide — GS-AI-CLOUD

This document explains how to perform full system restoration and database recovery using **GS-AI-CLOUD** backup archives.

---

## 1. Quick Restoration Command

To restore from a backup archive:
```bash
./scripts/restore.sh backups/gs_ai_cloud_backup_YYYYMMDD_HHMMSS.tar.gz
```

---

## 2. Step-by-Step Manual Recovery

### Step 1: Extract Archive
```bash
mkdir -p /tmp/restore_working
tar -xzf backups/gs_ai_cloud_backup_YYYYMMDD_HHMMSS.tar.gz -C /tmp/restore_working
```

### Step 2: Restore PostgreSQL Database
```bash
docker exec -i gs-ai-postgres psql -U gscloud < /tmp/restore_working/postgres_dump.sql
```

### Step 3: Restore Persistent Volumes
If recovering after hardware failure:
```bash
docker run --rm \
  -v gs_ai_postgres_data:/data \
  -v /tmp/restore_working:/backup \
  alpine tar -xzf /backup/postgres_volume.tar.gz -C /data
```

### Step 4: Restart Platform
```bash
docker compose up -d
./scripts/healthcheck.sh
```
