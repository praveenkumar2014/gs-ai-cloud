#!/usr/bin/env bash
set -euo pipefail
STATUS=$(docker compose ps --format json 2>/dev/null || true)
if [ -z "$STATUS" ]; then docker compose ps; exit 0; fi
printf '%s\n' "$STATUS" | python3 -c 'import json,sys; bad=0
for line in sys.stdin:
  if not line.strip(): continue
  s=json.loads(line); name=s.get("Service") or s.get("Name"); state=s.get("State"); health=s.get("Health","")
  print(f"{name}: {state} {health}".strip())
  if state!="running" or (health and health not in ("healthy","starting")): bad=1
sys.exit(bad)'
