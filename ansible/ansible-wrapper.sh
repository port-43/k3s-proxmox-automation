#!/bin/bash

. ./bash-functions.sh

setup_k3s_dir

ensure_ssh_connectivity "$TF_ANSIBLE_HOST"

echo "BASELINE CONFIGURATION - $TF_ANSIBLE_VM_NAME"

install_baseline_config "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST"

# configure nginx vm
if [[ $TF_ANSIBLE_VM_NAME == *"nginx"* ]]; then
    echo "NGINX - Setting up $TF_ANSIBLE_VM_NAME"

    install_nginx_config "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST" "$TF_ANSIBLE_HIVE_IPS"
fi

# configure postgres vm
if [[ $TF_ANSIBLE_VM_NAME == *"postgres"* ]]; then
    echo "POSTGRES - Setting up $TF_ANSIBLE_VM_NAME"

    install_postgres_config "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST" "$TF_ANSIBLE_PG_ADMIN_PWD" "$TF_ANSIBLE_PG_USER" "$TF_ANSIBLE_PG_PWD" "$TF_ANSIBLE_PG_DB"
fi

# setup control plane nodes
if [[ $TF_ANSIBLE_VM_NAME == *"hive"* ]]; then
    echo "CONTROL PLANE NODE - Setting up $TF_ANSIBLE_VM_NAME"

    install_control_plane "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST" "$TF_ANSIBLE_PG_USER" "$TF_ANSIBLE_PG_PWD" "$TF_ANSIBLE_PG_DB" "$TF_ANSIBLE_PG_HOST" "$TF_ANSIBLE_LB_IP" "$TF_ANSIBLE_HIVE_IP"
fi

# setup worker nodes
if [[ $TF_ANSIBLE_VM_NAME == *"drone"* ]]; then
    echo "WORKER NODE - Setting up $TF_ANSIBLE_VM_NAME"

    install_worker_node "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST" "$TF_ANSIBLE_LB_IP"
fi

# setup strage nodes
if [[ $TF_ANSIBLE_VM_NAME == *"storage"* ]]; then
    echo "STORAGE NODE - Setting up $TF_ANSIBLE_VM_NAME"

    install_storage_node "$TF_ANSIBLE_USER" "$TF_ANSIBLE_SSH_KEY" "$TF_ANSIBLE_HOST" "$TF_ANSIBLE_LB_IP"
fi
