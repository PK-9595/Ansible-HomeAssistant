#!/usr/bin/env bash

if [[ ! -f .env ]]; then
  echo "Missing .env file. Copy .env.example to .env and fill in the values first." >&2
  return 1 2>/dev/null || exit 1
fi

set -a
source .env
set +a

DEBUG_LOG="./$(date "+%Y-%m-%d_%H-%M-%S").ansiblelog"

ansible-playbook -i Ansible/inventory Ansible/playbook.yml
# ansible-playbook -i Ansible/inventory -vvv Ansible/playbook.yml > "${DEBUG_LOG}" | grep -E '^TASK|^PLAY|^ok|^changed|^failed|^skipping'
