#!/usr/bin/env bash
set -euo pipefail

# Load environment variables
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
else
  echo "[ERROR] .env file not found"
  exit 1
fi

# =========================
# Logging helpers
# =========================
log_info() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [INFO] $*"
}

log_error() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") [ERROR] $*" >&2
}

# =========================
# 1. Obtain auth token
# =========================
log_info "Requesting authorization token"

RESPONSE=$(curl -sS -X POST "$AUTH_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"login\": \"$LOGIN\",
    \"password\": \"$PASSWORD\"
  }")

SESSION_TOKEN=$(echo "$RESPONSE" | grep -oP '"session_token"\s*:\s*"\K[^"]+' || true)

if [[ -z "$SESSION_TOKEN" ]]; then
  log_error "Authorization token was not received"
  log_error "Server response: $RESPONSE"
  exit 1
fi

log_info "Authorization token successfully obtained"

# =========================
# PATCH payload
# =========================
PATCH_DATA='{
  "key": "value"
}'

# =========================
# 2. PATCH request loop
# =========================
log_info "Starting PATCH requests (count=${REQUEST_COUNT}, interval=${SLEEP_INTERVAL}s)"

for ((i=1; i<=REQUEST_COUNT; i++)); do
  log_info "Sending PATCH request (${i}/${REQUEST_COUNT})"

  HTTP_CODE=$(curl -sS -o /dev/null -w "%{http_code}" \
    -X PATCH "$PATCH_URL" \
    -H "Authorization: Bearer $SESSION_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$PATCH_DATA")

  if [[ "$HTTP_CODE" =~ ^2 ]]; then
    log_info "PATCH request succeeded (http_code=${HTTP_CODE})"
  else
    log_error "PATCH request failed (http_code=${HTTP_CODE})"
  fi

  if [[ "$i" -lt "$REQUEST_COUNT" ]]; then
    log_info "Sleeping for ${SLEEP_INTERVAL}s before next request"
    sleep "$SLEEP_INTERVAL"
  fi
done

log_info "Script execution completed successfully"
