# Template Scripts

This folder contains reusable Bash script templates for:

- **api/** — REST API scripts (auth, PATCH, bulk updates)
- **cron/** — cron job examples
- **monitoring/** — health check scripts

# API Scripts Overview

This directory contains reusable Bash script templates for interacting with REST APIs.
All scripts are based on `curl` and are designed for learning, testing, and automation purposes.

---

## auth_token.sh  
**Authentication token retrieval (static configuration)**

Retrieves an authentication token using credentials defined directly inside the script.

**Use cases:**
- Local testing
- Debugging authentication logic
- Quick proof-of-concept requests

**Notes:**
- Credentials are hard-coded
- Not recommended for production environments

---

## auth_token_env.sh  
**Authentication token retrieval using environment variables**

Retrieves an authentication token using configuration loaded from environment variables or a `.env` file.


**Use cases:**
- Production systems
- CI/CD pipelines
- Scheduled jobs (cron)

---

## rest_api_patch.sh  
**Example PATCH request to a REST API**

Sends a PATCH request to update a single API resource with values defined directly in the script.

**Use cases:**
- Testing PATCH endpoints
- Understanding request structure
- Troubleshooting API behavior

**Notes:**
- Static endpoint and token
- Easily adaptable for POST, PUT, or DELETE requests
- Credentials are hard-coded
- Not recommended for production environments


---

## rest_api_patch_env.sh  
**PATCH request using environment variables**

Performs a PATCH request using environment-based configuration.


**Use cases:**
- Secure automation
- Reusable scripts across environments
- Infrastructure maintenance tasks

---

## bulk_update.sh  
**Bulk update operations via API**

Executes batch updates by iterating over multiple records or payloads.

**Use cases:**
- Mass configuration changes
- Administrative API operations
- Data synchronization tasks

**Features:**
- Loop-based processing
- Simple error handling
- Suitable for large datasets

**Notes:**
- Credentials are hard-coded
- Not recommended for production environments


---

## Security & Best Practices

- Never store real credentials in scripts
- Prefer `_env` versions for shared or production usage
- Keep `.env` files out of version control
- Consider adding logging and retry logic for long-running jobs

