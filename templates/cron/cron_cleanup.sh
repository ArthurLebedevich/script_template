#!/usr/bin/env bash
set -euo pipefail

# Cleanup old logs
LOG_DIR="/var/log/myapp"
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -delete
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] Cleanup completed"

