#!/usr/bin/env bash
set -euo pipefail

# Example cron job
LOG_FILE="/var/log/cron_example.log"
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] Cron job executed" >> "$LOG_FILE"

