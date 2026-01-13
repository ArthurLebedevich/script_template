# Contributing

Thanks for your interest in contributing!

This document defines contribution rules, coding standards,
and workflow conventions for this repository.

## Purpose

The goal of this repository is to provide clean, reusable,
and production-oriented Bash script templates for DevOps and SRE use cases.

Consistency, readability, and safety are top priorities.

## Guidelines

- Use Bash best practices (`set -euo pipefail`)
- Avoid hardcoded credentials or secrets
- Use environment-based configuration where possible
- Use structured logging (timestamp + log level)
- Keep scripts minimal, readable, and reusable
- Add comments for non-obvious logic
- Follow ShellCheck recommendations

## Commit Messages

This repository follows **Conventional Commits**.

Format:

<type>: short description


Allowed types:
- `feat` — new functionality or script
- `fix` — bug fix
- `docs` — documentation changes
- `chore` — repository maintenance or structure
- `refactor` — code changes without behavior change
- `ci` — CI/CD or GitHub Actions changes
- `test` — tests or test-related changes

Examples:
chore: initial repository structure
feat: add env-based script templates
docs: update README with env usage
fix: handle empty auth token response


## Testing

- Run scripts locally before submitting a PR
- Ensure ShellCheck passes with no critical issues
- Test with env-based configuration when applicable

## Pull Requests

- Clearly describe the purpose of the change
- Reference related issues if applicable
- Keep pull requests focused and small
- Avoid mixing unrelated changes

## Disclaimer

All scripts are provided as templates.

Always test scripts in a non-production environment before real usage.

