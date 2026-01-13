#!/usr/bin/env bash
set -euo pipefail

# Bulk update template using PATCH requests
PATCH_URL="https://Y_LINK_2"
TOKEN="your_token_here"

log_info() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] $*"
}

log_error() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [ERROR] $*" >&2
}

PATCH_DATA='{"key": "value"}'

for i in {1..5}; do
  log_info "Sending PATCH for item $i"
  HTTP_CODE=$(curl -sS -o /dev/null -w "%{http_code}" \
    -X PATCH "$PATCH_URL" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$PATCH_DATA")

  if [[ "$HTTP_CODE" =~ ^2 ]]; then
    log_info "PATCH succeeded for item $i"
  else
    log_error "PATCH failed for item $i (http_code=$HTTP_CODE)"
  fi
done

