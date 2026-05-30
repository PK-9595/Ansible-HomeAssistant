#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: ./update-ha.sh <home-assistant-version>"
  echo "Example: ./update-ha.sh 2025.2.5"
  return 1 2>/dev/null || exit 1
fi

if [[ ! -f .env ]]; then
  echo "Missing .env file. Copy .env.example to .env and fill in the values first." >&2
  return 1 2>/dev/null || exit 1
fi

HA_VERSION="$1"
HA_IMAGE="ghcr.io/home-assistant/home-assistant:${HA_VERSION}"

if [[ ! "${HA_VERSION}" =~ ^[0-9]{4}\.[0-9]{1,2}(\.[0-9]+)?$ ]]; then
  echo "Expected a Home Assistant version like 2025.2.5 or 2025.12." >&2
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

ansible-playbook -i Ansible/inventory Ansible/backup-homeassistant.yml

source deploy.sh
