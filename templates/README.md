# SCRIPT_TEMPLATE

A collection of **production-ready Bash script templates** for DevOps, SRE, and system automation tasks.

This repository provides reusable, well-structured scripts with best practices applied:

* strict bash mode
* ShellCheck compliance
* monitoring & cron readiness
* clean configuration separation

---

## 📂 Repository Structure

```text
SCRIPT_TEMPLATE/
├── .github/workflows/
│   └── shellcheck.yml        # CI: ShellCheck validation
├── docs/                     # Documentation
├── examples/                 # Usage examples
├── templates/                # Script templates
│   ├── api/                  # API-related scripts
│   ├── cron/                 # Cron-ready scripts
│   └── monitoring/           # Monitoring & health-check scripts
│       ├── ports_check.sh    # TCP/UDP ports availability checker
│       ├── health_check.sh   # Generic health check example
│       └── config/
│           └── ports_check.conf
├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── .editorconfig
├── .gitignore
├── .env.example
└── cron_example.log
```

---

## 🔍 Featured Script: `ports_check.sh`

Location:

```text
templates/monitoring/ports_check.sh
```

### Description

`ports_check.sh` is a **production-ready TCP/UDP port availability checker** designed for:

* Zabbix / monitoring systems
* Cluster environments
* CI/CD smoke checks
* SRE / DevOps tooling

It supports **cluster-aware logic**, per-node port definitions, IP reachability checks, and strict exit codes.

---

## ✨ Key Features

* ✅ TCP and UDP port checks
* ✅ Port ranges support (`9310-9337`)
* ✅ IP reachability pre-check (ICMP)
* ✅ Cluster mode (exclude self)
* ✅ Extra (non-local) target check
* ✅ Zabbix-compatible exit codes
* ✅ Colored output (auto-disabled in non-TTY)
* ✅ Safe under `set -Eeuo pipefail`
* ✅ ShellCheck compliant

---

## ⚙️ Configuration

Configuration is stored separately from the script:

```text
templates/monitoring/config/ports_check.conf
```

### Example: `ports_check.conf`

```bash
# Enable or disable cluster mode
CLUSTER_MODE="ON"   # ON | OFF

# Logical name of the current server
WHO_AM_I="SERVER_01"

# Extra (non-local) check
EXTRA_IP="10.1.1.10"
EXTRA_PORTS_TCP="5432 8080"
EXTRA_PORTS_UDP="5432 8080"

# Cluster members
SERVERS=(SERVER_01 SERVER_02 SERVER_03 SERVER_04)

# Server IP mapping

declare -A SERVER_IP
SERVER_IP[SERVER_01]="10.1.1.11"
SERVER_IP[SERVER_02]="10.1.1.12"
SERVER_IP[SERVER_03]="10.1.1.13"
SERVER_IP[SERVER_04]="10.1.1.14"

# TCP ports per server

declare -A SERVER_PORTS_TCP
SERVER_PORTS_TCP[SERVER_01]="9300 9310-9337 4369"
SERVER_PORTS_TCP[SERVER_02]="9300 9310-9337 4369"
SERVER_PORTS_TCP[SERVER_03]="9300 9310-9319 2945-2946"
SERVER_PORTS_TCP[SERVER_04]="9300 9310-9319 2945-2946"

# UDP ports per server

declare -A SERVER_PORTS_UDP
SERVER_PORTS_UDP[SERVER_01]="5060 5080"
SERVER_PORTS_UDP[SERVER_02]="5060 5080"
SERVER_PORTS_UDP[SERVER_03]="2945-2946"
SERVER_PORTS_UDP[SERVER_04]="2945-2946"
```

---

## ▶️ Usage

```bash
bash templates/monitoring/ports_check.sh
```

With custom config:

```bash
bash templates/monitoring/ports_check.sh \
  --config templates/monitoring/config/ports_check.conf
```

Disable colored output:

```bash
bash templates/monitoring/ports_check.sh --no-color
```

---

## 🧠 Logic Overview

### `CLUSTER_MODE=OFF`

* Checks only:

  * `EXTRA_IP`
  * `EXTRA_PORTS_TCP`
  * `EXTRA_PORTS_UDP`

### `CLUSTER_MODE=ON`

1. Performs **extra target check**
2. Determines current node via `WHO_AM_I`
3. Checks **all cluster servers except itself**
4. Each server uses its own TCP/UDP port definitions

---

## 📊 Output Example

```text
🟦 EXTRA CHECK (127.0.0.1)
IP 127.0.0.1 reachable
TCP  5432 : open
TCP  8080 : closed
UDP  5432 : open|filtered

ZABBIX_SUMMARY | ip_down=0 tcp_open=1 tcp_closed=1 udp_open=0 udp_filtered=1
```

---

## 🚦 Exit Codes (Zabbix-compatible)

| Code | Meaning                                       |
| ---- | --------------------------------------------- |
| `0`  | OK – all required ports available             |
| `1`  | WARNING – UDP ports filtered                  |
| `2`  | CRITICAL – IP unreachable or TCP ports closed |
| `3`  | UNKNOWN – configuration or runtime error      |

---

## 🧪 Requirements

* Bash 4.4+
* `nc` (netcat / nmap-ncat)
* `ping`
* Linux environment

---

## 🔒 Quality & Safety

* Strict bash mode: `set -Eeuo pipefail`
* Safe arithmetic operations
* Isolated command failures (`nc`, `ping`)
* Automatic color disabling in non-interactive environments
* CI validation via ShellCheck

---

## 🤝 Contributing

Contributions are welcome.

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

This project is licensed under the MIT License.

---

## ⭐ Notes

This repository is intended as a **template library**, not a single-purpose tool.
Scripts can be copied, adapted, and extended for production environments.
