# Backup Guide — GS-AI-CLOUD

This document outlines the backup strategies, scripts, and retention policies for **GS-AI-CLOUD**.

---

## 1. Automated Backups

GS-AI-CLOUD provides a dedicated backup utility in `scripts/backup.sh`.

### Manual Backup Execution
```bash
./scripts/backup.sh
```

### What is Backed Up?
1. **PostgreSQL Databases**: Full logical dump of all databases (`postgres_dump.sql`).
2. **Redis In-Memory State**: RDB persistence file snapshot.
3. **Configuration & Secrets**: `.env` file and `configs/` directory.
4. **Tarball Bundle**: Stored in `backups/gs_ai_cloud_backup_YYYYMMDD_HHMMSS.tar.gz`.

---

## 2. Automated Cron Job Scheduling

To automate daily backups at 02:00 AM:
```bash
crontab -e
```
Add the following line:
```cron
0 2 * * * /bin/bash /path/to/gs-ai-cloud/scripts/backup.sh >> /path/to/gs-ai-cloud/backups/backup.log 2>&1
```

---

## 3. Offsite / Cloud S3 Backup (Optional)

Using Rclone or AWS CLI to mirror backups to S3 / MinIO / Cloudflare R2:
```bash
aws s3 sync /path/to/gs-ai-cloud/backups/ s3://my-cloud-backups/gs-ai-cloud/
```
