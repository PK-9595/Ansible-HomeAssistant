# Key Flows

Last verified against codebase: 2026-05-30

This file is an index. Keep detailed flow notes in a separate file only when a flow grows enough to justify it.

## Provisioning Flow

1. User copies `.env.example` to `.env` and fills connection, UID/GID, credential, image, and Zigbee settings.
2. User runs `source deploy.sh`.
3. `deploy.sh` exports `.env` values and runs the Ansible playbook.
4. `Ansible/inventory` resolves the target host, user, SSH key, and Zigbee dongle from environment variables.
5. `Ansible/playbook.yml` runs `installPython`, then the Home Assistant setup role sequence.

## Host Setup Flow

1. Bootstrap Python and pip on Debian/Ubuntu/Raspbian-like targets.
2. Enforce SSH public-key authentication and disable password authentication.
3. Upgrade apt packages, install utilities, xrdp, Tailscale, Docker, and Docker Compose plugin.
4. Configure user shell preferences and Docker group membership.
5. Add rfkill unblock commands when `/etc/rc.local` exists.

## Home Assistant Stack Flow

1. Copy `Docker/docker-compose.yml` and `.env` to the target user's home directory.
2. Create host directories for Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED, ESPHome, and MariaDB.
3. Start Docker Compose once to generate initial config files.
4. Wait for Home Assistant and Zigbee2MQTT config files to exist.
5. Stop the stack, adjust generated config, install HACS, and start the stack again.

## Manual Integration Flow

The README documents manual UI follow-up for Mosquitto MQTT, HACS authorization, Node-RED Home Assistant connection, Tailscale authentication, Xiaomi Miot Auto, and LocalTuya.

## Unknown / Needs verification

- No automated validation flow for a live provisioned host was found.
