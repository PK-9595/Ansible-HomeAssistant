#!/usr/bin/env bash
export $(grep -v '^#' .env | xargs)
ansible-playbook -i Ansible/inventory Ansible/playbook.yml