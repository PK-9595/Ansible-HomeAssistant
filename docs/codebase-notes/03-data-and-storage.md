# Data And Storage

Last verified against codebase: 2026-05-30

## Host Directory Layout

Confidence: High

The playbook stores persistent container data under the target user's home directory. `setupHAFilesAndDirectories` creates or ensures directories for Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, and MariaDB. `Docker/docker-compose.yml` mounts those paths into containers.

Evidence: `Ansible/roles/setupHAFilesAndDirectories/tasks/main.yml`; `Docker/docker-compose.yml` volume entries.

## Home Assistant Config Storage

- Host path: `/home/{{ ansible_user }}/homeAssistant`.
- Compose mount: `/home/${USER}/homeAssistant:/config`.
- Playbook adjustments configure `automation`, `script`, and `scene` to use include-dir merge lists.
- The `custom_components` directory is created for HACS and custom integrations.

Evidence: `Docker/docker-compose.yml` `homeassistant` service; `Ansible/roles/adjustHAConfigFiles/tasks/main.yml`.

## Add-On Storage

- Zigbee2MQTT data: `/home/${USER}/zigbee2mqtt/data`.
- Mosquitto config/data/log: `/home/${USER}/mosquitto/config`, `/home/${USER}/mosquitto/data`, `/home/${USER}/mosquitto/log`.
- Node-RED data: `/home/${USER}/nodered`.
- ESPHome config: `/home/${USER}/esphome`.
- MariaDB data: `/home/${USER}/mariadb`.

Evidence: `Docker/docker-compose.yml`; `Ansible/roles/setupHAFilesAndDirectories/tasks/main.yml`.

## Database

Confidence: Medium

MariaDB is defined as a Docker Compose service and initialized with `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, and `MYSQL_PASSWORD`. The repository does not contain application code or migrations that connect Home Assistant to MariaDB automatically.

Evidence: `Docker/docker-compose.yml` `mariadb` service; `.env.example` password variables.

## Secrets And Local Environment

`.env.example` lists required variables and image tags. `.env` is local configuration and may contain credentials. The playbook copies `.env` to the target user's home directory during provisioning.

Evidence: `.env.example`; `Ansible/roles/setupHAFilesAndDirectories/tasks/main.yml`.

## Unknown / Needs verification

- Whether Home Assistant is manually configured to use MariaDB instead of its default storage is not confirmed by repository files.
- Whether container user UID/GID settings have been tested for Mosquitto, Node-RED, ESPHome, and Samba is uncertain; Compose comments mark some user settings as not yet tested or optional.
