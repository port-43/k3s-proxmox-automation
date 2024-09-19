#---------------------------------
# provider vars
#---------------------------------
proxmox_endpoint = "https://proxmoxurl"
proxmox_username = "user@pam"
proxmox_password = "password"

#---------------------------------
# cloud init vars
#---------------------------------
cloud_init_username = "username"
cloud_init_password = "password"
cloud_init_public_key = "ssh-rsa asdf"
cloud_init_private_key_path = "/home/user/.ssh/cloud-init-key"
cloud_init_datastore_id = "local-zfs"

#---------------------------------
# file vars
#---------------------------------
file_datastore_id = "truenas"
file_node_name = "pve-01"
download_file = {
  name = "noble-ubuntu-server-cloudimg-amd64.img"
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  checksum = "21dc4933dc022406b20df78d81fd34d953799ff133d826c2f3136f6936887a52"
  checksum_algorithm = "sha256"
}

#---------------------------------
# k3s db vars
#---------------------------------
postgres_user_password = "my-postgres-password"
k3s_db_username = "k3s_admin"
k3s_db_password = "my-k3s-db-password"
k3s_db_name = "k3s"

#---------------------------------
# k3s cluster vars
#---------------------------------
# general
kubernetes_cluster = "mustafar"
ip_gateway = "192.168.1.1"
vm_tags = ["k3s", "terraform", "mustafar"]
disk_datastore_id = "local-zfs"

# supporting infra
infra_virtual_machines = {
    "nginx" = {
        name    = "nginx"
        node    = "pve-01"
        id      = 2010
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.10/24"
    }
    "postgres" = {
        name    = "postgres"
        node    = "pve-01"
        id      = 2011
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.11/24"
    }
}

# control plane nodes
hive_virtual_machines = {
    "hive-01" = {
        name    = "hive-01"
        node    = "pve-01"
        id      = 2020
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.20/24"
    }
    "hive-02" = {
        name    = "hive-02"
        node    = "pve-02"
        id      = 2021
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.21/24"
    }
    "hive-03" = {
        name    = "hive-03"
        node    = "pve-03"
        id      = 8902
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.22/24"
    }
}

# worker nodes
drone_virtual_machines = {
    "drone-01" = {
        name    = "drone-01"
        node    = "pve-01"
        id      = 2030
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.30/24"
    }
    "drone-02" = {
        name    = "drone-02"
        node    = "pve-02"
        id      = 2031
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.31/24"
    }
    "drone-03" = {
        name    = "drone-03"
        node    = "pve-03"
        id      = 2032
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.32/24"
    }
}

# storage nodes
storage_virtual_machines = {
    "storage-01" = {
        name    = "storage-01"
        node    = "pve-01"
        id      = 2040
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.40/24"
    }
    "storage-02" = {
        name    = "storage-02"
        node    = "pve-02"
        id      = 2041
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.41/24"
    }
    "storage-03" = {
        name    = "storage-03"
        node    = "pve-03"
        id      = 2042
        pool    = "mustafar"
        memory  = 4096
        cores   = 2
        ip      = "192.168.1.42/24"
    }
}
