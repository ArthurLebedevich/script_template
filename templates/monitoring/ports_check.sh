#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

VERSION="1.1.2"

############################
# DEFAULTS
############################
CONFIG_FILE="./config/ports_check.conf"
NO_COLOR=0
TIMEOUT=1
PING_COUNT=1
PING_TIMEOUT=1

############################
# EXIT CODES (Zabbix)
############################
EXIT_OK=0
EXIT_WARNING=1
EXIT_CRITICAL=2
EXIT_UNKNOWN=3

############################
# ARGUMENTS
############################
while [[ $# -gt 0 ]]; do
  case "$1" in
    --config) CONFIG_FILE="$2"; shift 2 ;;
    --no-color) NO_COLOR=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--config file] [--no-color]"
      exit $EXIT_OK
      ;;
    *) echo "Unknown option: $1"; exit $EXIT_UNKNOWN ;;
  esac
done

############################
# LOAD CONFIG
############################
[[ -f "$CONFIG_FILE" ]] || { echo "Config not found: $CONFIG_FILE"; exit $EXIT_UNKNOWN; }
source "$CONFIG_FILE"

############################
# COLORS
############################
if [[ "$NO_COLOR" -eq 1 || ! -t 1 ]]; then
  GREEN=""; RED=""; YELLOW=""; NC=""
else
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  NC='\033[0m'
fi

############################
# STATE (Zabbix metrics)
############################
CRITICAL_FOUND=0
WARNING_FOUND=0

TCP_OPEN=0
TCP_CLOSED=0
UDP_OPEN=0
UDP_FILTERED=0
IP_DOWN=0

############################
# FUNCTIONS
############################

check_ip() {
  local ip=$1
  if ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$ip" &>/dev/null; then
    echo -e "${GREEN}IP $ip reachable${NC}"
    return 0
  else
    echo -e "${RED}IP $ip unreachable${NC}"
    IP_DOWN=1
    CRITICAL_FOUND=1
    return 1
  fi
}

check_port() {
  local proto=$1 ip=$2 port=$3
  local rc

  if [[ "$proto" == "TCP" ]]; then
    set +e
    nc -z -w"$TIMEOUT" "$ip" "$port" &>/dev/null
    rc=$?
    set -e

    if [[ $rc -eq 0 ]]; then
      echo -e "${GREEN}TCP  $port : open${NC}"
      ((++TCP_OPEN))
    else
      echo -e "${RED}TCP  $port : closed${NC}"
      ((++TCP_CLOSED))
      CRITICAL_FOUND=1
    fi
  else
    set +e
    nc -zu -w"$TIMEOUT" "$ip" "$port" &>/dev/null
    rc=$?
    set -e

    if [[ $rc -eq 0 ]]; then
      echo -e "${GREEN}UDP  $port : open${NC}"
      ((++UDP_OPEN))
    else
      echo -e "${YELLOW}UDP  $port : open|filtered${NC}"
      ((++UDP_FILTERED))
      WARNING_FOUND=1
    fi
  fi
}

expand_and_check() {
  local proto=$1 ip=$2 ports=$3

  for item in $ports; do
    if [[ "$item" =~ ^[0-9]+-[0-9]+$ ]]; then
      for p in $(seq "${item%-*}" "${item#*-}"); do
        check_port "$proto" "$ip" "$p"
      done
    else
      check_port "$proto" "$ip" "$item"
    fi
  done
}

check_server() {
  local srv=$1
  local ip="${SERVER_IP[$srv]}"

  echo -e "\n🔹 $srv ($ip)"
  echo "------------------------"

  if ! check_ip "$ip"; then
    return 0
  fi

  expand_and_check "TCP" "$ip" "${SERVER_PORTS_TCP[$srv]}"
  expand_and_check "UDP" "$ip" "${SERVER_PORTS_UDP[$srv]}"
}


############################
# MAIN
############################
echo "ports_check.sh v$VERSION"
echo "MODE: $CLUSTER_MODE"
echo "=============================="

echo -e "\n🟦 EXTRA CHECK ($EXTRA_IP)"
if check_ip "$EXTRA_IP"; then
  expand_and_check "TCP" "$EXTRA_IP" "$EXTRA_PORTS_TCP"
  expand_and_check "UDP" "$EXTRA_IP" "$EXTRA_PORTS_UDP"
fi

if [[ "$CLUSTER_MODE" == "ON" ]]; then
  echo -e "\n🟦 CLUSTER CHECK (excluding $WHO_AM_I)"
  for srv in "${SERVERS[@]}"; do
    [[ "$srv" == "$WHO_AM_I" ]] && continue
    check_server "$srv"
  done
fi

############################
# ZABBIX OUTPUT
############################
echo
echo "ZABBIX_SUMMARY | ip_down=$IP_DOWN tcp_open=$TCP_OPEN tcp_closed=$TCP_CLOSED udp_open=$UDP_OPEN udp_filtered=$UDP_FILTERED"

############################
# EXIT
############################
if [[ "$CRITICAL_FOUND" -eq 1 ]]; then
  exit $EXIT_CRITICAL
elif [[ "$WARNING_FOUND" -eq 1 ]]; then
  exit $EXIT_WARNING
else
  exit $EXIT_OK
fi
