# Deployment And Config

Last verified against codebase: 2026-05-30

## Deployment Entry Point

Confidence: High

The documented deployment command is `source deploy.sh` from the repository root. The script exports `.env` values and invokes `ansible-playbook` with `Ansible/inventory` and `Ansible/playbook.yml`.

Evidence: `README.md` setup instructions; `deploy.sh`.

## Required Configuration

`.env.example` defines:

- Target host and Ansible connection: `SERVER_HOSTNAME`, `USER`, `SSH_PRIV_KEY`.
- Target user identity: `USERID`, `GROUPID`.
- Database credentials: `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD`.
- Container image variables for Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, MariaDB, and Samba.
- Hardware path: `ZIGBEE_DONGLE`.

Evidence: `.env.example`; `Ansible/inventory`; `Docker/docker-compose.yml`.

## Ansible Configuration

`Ansible/ansible.cfg` disables host key checking. `Ansible/inventory` uses Jinja environment lookups rather than static host values.

Evidence: `Ansible/ansible.cfg`; `Ansible/inventory`.

## Deployment Target

The README describes a Raspberry Pi or Linux server using apt as the Home Assistant server. The `installPython` role explicitly checks for Debian, Ubuntu, or Raspbian text in `/etc/os-release`.

Evidence: `README.md`; `Ansible/roles/installPython/tasks/main.yml`.

## Test And Validation

The repository includes role-local `tests/test.yml` and `tests/inventory` files for each role, but no CI configuration or top-level automated test runner was found. The docs validator lives under `docs/codebase-notes/` and checks documentation health only.

Evidence: `Ansible/roles/*/tests`; top-level repository file list.

## Cross-Platform Docs Validation

Use `check-notes.ps1` on Windows or any environment with PowerShell. Use `check-notes.sh` on Linux/macOS shell environments. When both are available, run both because they should enforce equivalent checks.

## Unknown / Needs verification

- Whether `deploy.sh` is expected to be sourced instead of executed only because of environment export behavior is implied by README and script behavior, but not separately documented in code comments.
- Whether role test files are actively maintained or executable as-is is not confirmed.
