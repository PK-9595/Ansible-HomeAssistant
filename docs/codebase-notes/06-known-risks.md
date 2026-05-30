# Known Risks

Last verified against codebase: 2026-05-30

## Platform Support

Confidence: High

The target host path is Linux with apt. The bootstrap role fails if `/etc/os-release` does not mention Debian, Ubuntu, or Raspbian. The control machine instructions are Linux-oriented and use `source deploy.sh`.

Evidence: `Ansible/roles/installPython/tasks/main.yml`; `README.md`; `deploy.sh`.

## Credential Handling

`.env` contains target host details, SSH key path, UID/GID values, and database credentials. The playbook copies `.env` to the target user's home directory.

Evidence: `.env.example`; `Ansible/roles/setupHAFilesAndDirectories/tasks/main.yml`.

## Remote Shell Installers

The playbook runs remote shell install patterns for Tailscale and HACS. These commands depend on external availability and trust of fetched scripts.

Evidence: `Ansible/roles/upgradeAndInstallPackages/tasks/main.yml` Tailscale task; `Ansible/roles/setupHAAddOns/tasks/main.yml` HACS task.

## Host Configuration Changes

The playbook changes SSH authentication settings, apt packages, Docker group membership, xrdp service state, Tailscale service state, user shell, and `/etc/rc.local` when present. These changes affect host security and login behavior.

Evidence: `Ansible/roles/setupSSH/tasks/main.yml`; `Ansible/roles/upgradeAndInstallPackages/tasks/main.yml`; `Ansible/roles/setupDocker/tasks/main.yml`; `Ansible/roles/configureUserEnvironment/tasks/main.yml`; `Ansible/roles/preventRfkillFromBlockingWifi/tasks/main.yml`.

## Docker Compose And Networking

MariaDB exposes its database port by default and does not explicitly attach to `ha-network` in the current Compose file. Services expose UI or protocol ports on the host by default. The Compose file supports optional host-port variables and a shared `PORT_BIND_IP` that can bind published ports to one local host IP, but the defaults preserve broad host-interface exposure.

Evidence: `Docker/docker-compose.yml`; `.env.example`.

## Validation Coverage

The docs validators check note structure and drift risks only. They do not validate Ansible syntax, idempotency, Docker Compose correctness, live host behavior, or container health.

Evidence: `docs/codebase-notes/check-notes.ps1`; `docs/codebase-notes/check-notes.sh`.

## Unknown / Needs verification

- Whether the role tests are intended for Molecule, direct Ansible runs, or examples is not confirmed.
- Whether all Docker image tags are intentionally floating or pinned is not documented beyond `.env.example`.
- Whether `hello-world` should be removed after Docker validation is not specified.
