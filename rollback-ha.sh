#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: ./rollback-ha.sh <remote-backup-file> <home-assistant-version>"
  echo "Example: ./rollback-ha.sh homeAssistant-backup-2026-05-31_00-35-54.tar.gz 2025.1.4"
  return 1 2>/dev/null || exit 1
fi

if [[ ! -f .env ]]; then
  echo "Missing .env file. Copy .env.example to .env and fill in the values first." >&2
  return 1 2>/dev/null || exit 1
fi

BACKUP_FILE="$1"
HA_VERSION="$2"
HA_IMAGE="ghcr.io/home-assistant/home-assistant:${HA_VERSION}"

if [[ ! "${HA_VERSION}" =~ ^[0-9]{4}\.[0-9]{1,2}(\.[0-9]+)?$ ]]; then
  echo "Expected a Home Assistant version like 2025.1.4 or 2025.12." >&2
  return 1 2>/dev/null || exit 1
fi

if [[ ! "${BACKUP_FILE}" =~ ^[A-Za-z0-9._/-]+$ ]]; then
  echo "Backup file should be a simple remote path or file name without spaces." >&2
  return 1 2>/dev/null || exit 1
fi

if grep -q '^HOMEASSISTANT_IMAGE=' .env; then
  sed -i.bak "s|^HOMEASSISTANT_IMAGE=.*|HOMEASSISTANT_IMAGE=${HA_IMAGE}|" .env
else
  printf '\nHOMEASSISTANT_IMAGE=%s\n' "${HA_IMAGE}" >> .env
fi
rm -f .env.bak

set -a
source .env
set +a

ansible-playbook -i Ansible/inventory Ansible/restore-homeassistant-backup.yml \
  -e "homeassistant_backup_file=${BACKUP_FILE}"

source deploy.sh
