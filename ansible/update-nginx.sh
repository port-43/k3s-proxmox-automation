#!/bin/bash

. ./bash-functions.sh

ensure_ssh_connectivity "$TF_ANSIBLE_HOST"

echo "NGINX - Updating Conf"

update_nginx_config "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST" "$TF_ANSIBLE_HIVE_IPS"
