#!/bin/bash

#---------------------------
# Setup k3s directory
#---------------------------
setup_k3s_dir() {
    if [ ! -d ./k3s ]; then
        echo "Setting up k3s directory..."
        mkdir ./k3s
    fi
}

#---------------------------
# Host Connection Validation
#---------------------------

# check ssh connection
check_ssh() {
  local HOST="$1"
  local PORT=22

  echo "Attempting to connect to $HOST on port $PORT..."
  echo -n | telnet "$HOST" "$PORT" | grep -q "Connected"

  if [ $? -eq 0 ]; then
    echo "SSH is accessible on $HOST:$PORT"
    return 0
  else
    echo "SSH is not accessible on $HOST:$PORT"
    return 1
  fi
}

# ssh connectivity with retry logic
ensure_ssh_connectivity() {
    local HOST="$1"
    local ATTEMPT=1
    local RETRIES=3
    local SLEEP_TIME=10
    local PORT=22

    while [ $ATTEMPT -le $RETRIES ]; do
        check_ssh "$HOST"

        if [ $? -eq 0 ]; then
            return 0
        else
            echo "Retrying... ($ATTEMPT/$RETRIES)"
            ATTEMPT=$((ATTEMPT + 1))
            sleep $SLEEP_TIME
        fi
    done

    echo "Failed to connect to $HOST on port $PORT after $RETRIES attempts."
    exit 1
}

check_node_token() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local THIS_NODE_TOKEN="./k3s/node-token"
    FIRST_SETUP="false"

    if [ ! -f "$THIS_NODE_TOKEN" ]; then
        echo "CHECKING NODE TOKEN"

        ansible-playbook -u $USER \
            --private-key=$PRIVATE_KEY_PATH \
            --ssh-common-args '-o StrictHostKeyChecking=no' \
            -i $HOST, get-k3s-node-token.yaml
    fi

    if [ ! -f "$THIS_NODE_TOKEN" ]; then
        FIRST_SETUP="true"
    fi
}

install_baseline_config() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"

    # install baseline configuration
    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -i $HOST, baseline-setup.yaml
}

install_nginx_config() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local K3S_HIVE_IPS="$4"

    # install nginx config
    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -e "control_plane_ips=$K3S_HIVE_IPS" \
        -i $HOST, nginx-setup.yaml
}

update_nginx_config() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local K3S_HIVE_IPS="$4"

    # install nginx config
    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -e "control_plane_ips=$K3S_HIVE_IPS" \
        -i $HOST, nginx-update.yaml
}

install_postgres_config() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local PG_ADMIN_PWD="$4"
    local K3S_USERNAME="$5"
    local K3S_PWD="$6"
    local K3S_DB="$7"

    # install nginx config
    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -e "postgres_password=$PG_ADMIN_PWD k3s_username=$K3S_USERNAME \
            k3s_password=$K3S_PWD k3s_database=$K3S_DB" \
        -i $HOST, postgres-setup.yaml
}

install_control_plane() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local K3S_DB_USER="$4"
    local K3S_DB_PWD="$5"
    local K3S_DB_NAME="$6"
    local K3S_DB_HOST="$7"
    local K3S_LB_IP="$8"
    local K3S_HIVE_HOST="$9"

    check_node_token "$USER" "$PRIVATE_KEY_PATH" "$K3S_HIVE_HOST"

    echo "CONTROL PLANE NODE - (First=$FIRST_SETUP)"

    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -e "postgres_username=$K3S_DB_USER \
            postgres_password=$K3S_DB_PWD postgres_host=$K3S_DB_HOST \
            database_name=$K3S_DB_NAME load_balancer_ip=$K3S_LB_IP first_setup=$FIRST_SETUP" \
        -i $HOST, k3s-hive-setup.yaml

    ansible-playbook -e "load_balancer_ip=$K3S_LB_IP first_setup=$FIRST_SETUP" \
        k3s-config-mod.yaml
}

install_worker_node() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local K3S_LB_IP="$4"

    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -e "load_balancer_ip=$K3S_LB_IP" \
        -i $HOST, k3s-drone-setup.yaml
}

install_storage_node() {
    local USER="$1"
    local PRIVATE_KEY_PATH="$2"
    local HOST="$3"
    local K3S_LB_IP="$4"

    ansible-playbook -u $USER \
        --private-key=$PRIVATE_KEY_PATH \
        --ssh-common-args '-o StrictHostKeyChecking=no' \
        -e "load_balancer_ip=$K3S_LB_IP" \
        -i $HOST, k3s-storage-setup.yaml
}

