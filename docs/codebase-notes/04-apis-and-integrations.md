# APIs And Integrations

Last verified against codebase: 2026-05-30

## External Integrations

Confidence: High

The repository provisions a Home Assistant container stack and related services rather than exposing its own API. External integration points are container services, remote install scripts, SSH, Tailscale, and Home Assistant UI add-ons.

Evidence: `Docker/docker-compose.yml`; `Ansible/roles/upgradeAndInstallPackages/tasks/main.yml`; `Ansible/roles/setupHAAddOns/tasks/main.yml`; `README.md`.

## Container Services

- Home Assistant: web UI exposed through `HOMEASSISTANT_HOST_PORT`, defaulting to port `8123`.
- Zigbee2MQTT: web UI exposed through `ZIGBEE2MQTT_HOST_PORT`, defaulting to port `8080`, with Zigbee device passed through from `ZIGBEE_DONGLE`.
- Mosquitto: MQTT exposed through `MOSQUITTO_MQTT_HOST_PORT`, defaulting to port `1883`; WebSocket MQTT exposed through `MOSQUITTO_WEBSOCKET_HOST_PORT`, defaulting to port `9001`.
- Node-RED: web UI exposed through `NODERED_HOST_PORT`, defaulting to port `1880`.
- ESPHome: web UI exposed through `ESPHOME_HOST_PORT`, defaulting to port `6052`.
- MariaDB: database service exposed through `MARIADB_HOST_PORT`, defaulting to port `3306`.
- Samba: SMB/CIFS exposed through `SAMBA_NETBIOS_HOST_PORT` and `SAMBA_SMB_HOST_PORT`, defaulting to ports `139` and `445`.
- Optional `PORT_BIND_IP` can bind these published ports to one local host IP instead of all host interfaces.

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
