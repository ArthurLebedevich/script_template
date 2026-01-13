#!/usr/bin/env bash
set -euo pipefail

# Health check for services
SERVICES=("nginx" "mysql" "redis" "postgresql")

for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] $service is running"
  else
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [ERROR] $service is NOT running"
  fi
done

