#!/usr/bin/env bash
set -euo pipefail

# Load environment variables
if [ -f /path/to/.env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

LOG_FILE="/var/log/cron_example.log"
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] Cron job executed" >> "$LOG_FILE"
