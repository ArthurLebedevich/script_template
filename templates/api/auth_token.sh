#!/usr/bin/env bash
set -euo pipefail

# Simple template for obtaining auth token
AUTH_URL="https://Y_LINK_1"
LOGIN="Y_LOGIN"
PASSWORD="Y_PASSWORD"

log_info() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] $*"
}

log_error() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [ERROR] $*" >&2
}

log_info "Requesting authorization token"

RESPONSE=$(curl -sS -X POST "$AUTH_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"login\": \"$LOGIN\",
    \"password\": \"$PASSWORD\"
  }")

TOKEN=$(echo "$RESPONSE" | grep -oP '"session_token"\s*:\s*"\K[^"]+' || true)

if [[ -z "$TOKEN" ]]; then
  log_error "Authorization token was not received"
  exit 1
fi

log_info "Token: $TOKEN"

