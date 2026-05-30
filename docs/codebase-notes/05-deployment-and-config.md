# Deployment And Config

Last verified against codebase: 2026-05-31

## Deployment Entry Point

Confidence: High

The documented deployment command is `source deploy.sh` from the repository root. The script sources `.env`, exports its values, and invokes `ansible-playbook` with `Ansible/inventory` and `Ansible/playbook.yml`.

Evidence: `README.md` setup instructions; `deploy.sh`.

## Home Assistant Image Maintenance

`update-ha.sh` pins `HOMEASSISTANT_IMAGE` in local `.env`, exports environment variables, runs `Ansible/backup-homeassistant.yml` to create a timestamped backup of the remote `homeAssistant` config directory, and then sources `deploy.sh` to apply the requested image through the normal deployment flow.

`rollback-ha.sh` pins `HOMEASSISTANT_IMAGE` in local `.env`, runs `Ansible/restore-homeassistant-backup.yml` to stop the remote Docker Compose stack, preserve the current remote `homeAssistant` directory under a timestamped `homeAssistant-before-rollback-*` name, and extract the selected backup, then sources `deploy.sh` to re-apply the normal deployment flow.

The backup and restore playbooks use privilege escalation for archive and restore operations because some Home Assistant config files can be owned by root or otherwise unreadable by the deployment user.

Evidence: `update-ha.sh`; `rollback-ha.sh`; `Ansible/backup-homeassistant.yml`; `Ansible/restore-homeassistant-backup.yml`; `deploy.sh`; `README.md`.

## Required Configuration

`.env.example` defines:

- Target host and Ansible connection: `SERVER_HOSTNAME`, `USER`, `SSH_PRIV_KEY`.
- Target user identity: `USERID`, `GROUPID`.
- Database credentials: `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD`.
- Container image variables for Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, MariaDB, and Samba.
- Hardware path: `ZIGBEE_DONGLE`.
- Optional `PORT_BIND_IP` and host-port variables for Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, MariaDB, and Samba. Defaults match the original all-interface Docker port publishing behavior, and users can set `PORT_BIND_IP` to a local host IP to bind those ports only on that interface.

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
