#!/usr/bin/env bash
export $(grep -v '^#' .env | xargs)
DEBUG_LOG="./$(date "+%Y-%m-%d_%H-%M-%S").ansiblelog"

ansible-playbook -i Ansible/inventory Ansible/playbook.yml
# ansible-playbook -i Ansible/inventory -vvv Ansible/playbook.yml > "${DEBUG_LOG}" | grep -E '^TASK|^PLAY|^ok|^changed|^failed|^skipping'