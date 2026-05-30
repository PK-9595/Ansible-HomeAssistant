# APIs And Integrations

Last verified against codebase: 2026-05-30

## External Integrations

Confidence: High

The repository provisions a Home Assistant container stack and related services rather than exposing its own API. External integration points are container services, remote install scripts, SSH, Tailscale, and Home Assistant UI add-ons.

Evidence: `Docker/docker-compose.yml`; `Ansible/roles/upgradeAndInstallPackages/tasks/main.yml`; `Ansible/roles/setupHAAddOns/tasks/main.yml`; `README.md`.

## Container Services

- Home Assistant: web UI exposed on port `8123`.
- Zigbee2MQTT: web UI exposed on port `8080`, Zigbee device passed through from `ZIGBEE_DONGLE`.
- Mosquitto: MQTT exposed on ports `1883` and `9001`.
- Node-RED: web UI exposed on port `1880`.
- ESPHome: web UI exposed on port `6052`.
- MariaDB: database service exposed on port `3306`.
- Samba: SMB/CIFS exposed on ports `139` and `445`.

Evidence: `Docker/docker-compose.yml` service `ports`, `devices`, and volume entries.

## Network And Remote Access

The README explains local Home Assistant access through the target host on port `8123`. It also documents Tailscale as the remote access path. The playbook installs Tailscale and starts `tailscaled`, but authentication through `tailscale up` is manual per the README.

Evidence: `README.md` Tailscale section; `Ansible/roles/upgradeAndInstallPackages/tasks/main.yml`.

## HACS And Home Assistant UI Integrations

The playbook installs or updates HACS by running the HACS install script in the Home Assistant config directory. The README describes manual setup for HACS authorization, MQTT integration, Node-RED integration, Xiaomi Miot Auto, and LocalTuya.

Evidence: `Ansible/roles/setupHAAddOns/tasks/main.yml`; `README.md` add-ons section.

## Unknown / Needs verification

- Whether each exposed port is intended to be reachable beyond the local network is not defined in repository configuration.
- Whether the HACS installation command is pinned or verified is not shown in repository files.
