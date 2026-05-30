# Architecture

Last verified against codebase: 2026-05-30

## Main Control Flow

Confidence: High

`deploy.sh` exports variables from `.env` and runs `ansible-playbook -i Ansible/inventory Ansible/playbook.yml`. The Ansible inventory reads `SERVER_HOSTNAME`, `USER`, `SSH_PRIV_KEY`, and `ZIGBEE_DONGLE` from environment variables.

Evidence: `deploy.sh`; `Ansible/inventory`; `.env.example`.

## Playbook Structure

Confidence: High

`Ansible/playbook.yml` has two plays:

- `Python Installation`: targets all hosts, disables fact gathering, and runs `installPython` first so later Ansible modules can run.
- `HA Setup`: gathers facts and applies roles in a fixed sequence for SSH, packages, rfkill behavior, user environment, Docker, Home Assistant files, config initialization, config adjustment, add-ons, and final container startup.

Evidence: `Ansible/playbook.yml`; role task files under `Ansible/roles/`.

## Role Responsibilities

- `installPython`: validates Debian/Ubuntu/Raspbian-like OS text, installs Python, pip, and `python3-six` with raw apt commands.
- `setupSSH`: disables password authentication, enables public key authentication, and reloads `ssh` when configuration changes.
- `upgradeAndInstallPackages`: performs apt full upgrade/autoremove, installs utility packages, installs and starts xrdp, installs Tailscale through its shell installer, and starts `tailscaled`.
- `preventRfkillFromBlockingWifi`: adds wifi and Bluetooth unblock commands to `/etc/rc.local` when that file exists.
- `configureUserEnvironment`: writes shell/editor preferences to the target user's shell startup files and sets the user shell to Bash.
- `setupDocker`: installs Docker apt repository dependencies, adds Docker repository and GPG key, installs Docker Engine and Compose plugin, adds the target user to the Docker group, starts Docker, and runs a `hello-world` container.
- `setupHAFilesAndDirectories`: copies Docker Compose and `.env` to the target home directory and creates host directories/files for Home Assistant and add-ons.
- `initializeHAConfigFiles`: runs `docker compose --env-file .env up -d`, waits for generated Home Assistant and Zigbee2MQTT config files, then runs `docker compose down`.
- `adjustHAConfigFiles`: edits Mosquitto, Zigbee2MQTT, and Home Assistant configuration files and creates `custom_components`.
- `setupHAAddOns`: installs or updates HACS using the HACS install script.
- `runHA`: runs `docker compose --env-file .env up -d` from the target user's home directory.

Evidence: `Ansible/roles/*/tasks/main.yml`.

## Container Architecture

Confidence: High

`Docker/docker-compose.yml` defines services for Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, MariaDB, and Samba. Most services attach to `ha-network`; MariaDB has no explicit network entry and therefore uses Docker Compose defaults.

Evidence: `Docker/docker-compose.yml` service names and `networks` entries.

## Boundaries

- Repository-owned configuration: Ansible playbook, roles, inventory, Docker Compose file, and environment template.
- Target-host generated configuration: Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, and MariaDB directories under the target user's home directory.
- Manual setup after automation: Home Assistant UI integrations described in `README.md`.

## Unknown / Needs verification

- Whether `setupRDP.backup` is intentionally retained as a backup role is not confirmed. It is not referenced by `Ansible/playbook.yml`.
- Whether MariaDB should join `ha-network` is not confirmed by the current Compose file.
