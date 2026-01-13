# script_template
Collection of production-ready Bash script templates for DevOps and SRE use cases. Includes safe execution patterns, structured logging, REST API interaction examples, and reusable automation building blocks for CI/CD, cron jobs, and operational tasks.

# Repository Structure: `script_template`

```text
script_template/
├── templates/                     # Reusable script templates
│   ├── api/                       # REST API interaction templates
│   │   ├── rest_api_patch.sh      # Example PATCH request to a REST API
│   │   ├── rest_api_patch_env.sh  # PATCH request using environment variables (.env)
│   │   ├── bulk_update.sh         # Bulk update operations via API
│   │   ├── auth_token.sh          # Authentication token retrieval
│   │   ├── auth_token_env.sh      # Token retrieval using .env configuration
│   │   └── README.md              # Documentation for API templates
│   │
│   ├── cron/                      # Cron / scheduled task templates
│   │   ├── cron_cleanup.sh        # Log and temporary files cleanup script
│   │   ├── cron_example_env.sh    # Cron job example using environment variables
│   │   └── cron_example.sh        # Basic cron job example
│   │
│   ├── monitoring/                # Monitoring and health-check scripts
│   │   └── health_check.sh        # Service availability / health check
│   │
│   └── README.md                  # Overview of all available templates
│
├── examples/                      # Usage and configuration examples
│   ├── api/                       # API script examples
│   │   └── example.env            # Sample environment variables file
│   │
│   ├── cron/                      # Cron job examples
│   │
│   └── monitoring/                # Monitoring examples
│
├── docs/                          # Project documentation and guidelines
│   ├── logging.md                 # Bash logging recommendations
│   └── best_practices.md          # Best practices for writing maintainable scripts
│
├── .env.example                   # Environment variables template
├── .gitignore                     # Git ignore rules (logs, env files, etc.)
├── CONTRIBUTING.md                # Contribution guidelines
├── cron_example.log               # Sample cron execution log
└── README.md                      # Project overview and usage instructions
