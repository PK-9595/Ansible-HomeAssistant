# System Overview

Last verified against codebase: 2026-05-30

## Repository Purpose

Confidence: High

This repository automates provisioning and maintenance of Home Assistant Core on a Raspberry Pi or Ubuntu/Debian-like Linux server using Ansible and Docker containers.

Evidence: `README.md` project description, `Ansible/playbook.yml` play names and roles, `Docker/docker-compose.yml` service definitions.

## Top-Level Structure

- `README.md`: Human setup and usage guide.
- `deploy.sh`: Loads `.env` variables and invokes `ansible-playbook`.
- `.env.example`: Template for server connection, user IDs, credentials, image names, and Zigbee device path.
- `Ansible/ansible.cfg`: Disables host key checking for Ansible.
- `Ansible/inventory`: Defines `homeAssistantServer` from environment lookups.
- `Ansible/playbook.yml`: Main provisioning playbook.
- `Ansible/roles/`: Role-based host and Home Assistant setup tasks.
- `Docker/docker-compose.yml`: Container stack for Home Assistant and related services.

## Application Shape

Confidence: High

This is infrastructure automation, not a conventional frontend/backend application. There are no application routes, controllers, UI components, API handlers, database migrations, or compiled build outputs in the repository.

Evidence: Top-level files, `Ansible/roles/*/tasks/main.yml`, and `Docker/docker-compose.yml`.

## Target Runtime

Confidence: High

The Ansible target is expected to be a Linux host with the `apt` package manager. The bootstrap role checks `/etc/os-release` and fails unless the OS text contains Debian, Ubuntu, or Raspbian.

Evidence: `Ansible/roles/installPython/tasks/main.yml` tasks `Check OS`, `Install python using raw module`, `Run apt update`; `README.md` prerequisites.

## Control Machine

The control machine needs Ansible, access to the repository, an SSH private key, and environment variables from `.env`. The README describes installing Ansible through `pipx`, installing required Ansible collections, generating SSH keys, and running `source deploy.sh`.

## Unknown / Needs verification

- Whether the playbook is expected to support non-Debian target hosts is not confirmed.
- Whether all listed containers are required for every deployment is not confirmed.
