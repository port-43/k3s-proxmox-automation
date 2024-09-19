resource "proxmox_virtual_environment_vm" "supporting_infra" {
  for_each = var.infra_virtual_machines

  name      = "${var.kubernetes_cluster}-${each.value.name}"
  node_name = each.value.node
  vm_id     = each.value.id
  pool_id   = var.kubernetes_cluster
  tags      = var.vm_tags

  initialization {
    datastore_id        = var.cloud_init_datastore_id
    vendor_data_file_id = proxmox_virtual_environment_file.vendor_config.id

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.ip_gateway
      }
    }

    user_account {
      keys     = [trimspace(var.cloud_init_public_key)]
      password = var.cloud_init_password
      username = var.cloud_init_username
    }
  }

  agent {
    enabled = true
  }

  cpu {
    cores        = each.value.cores != null ? each.value.cores : 2
    type         = "host"
    units        = 100
    architecture = "x86_64"
  }

  memory {
    dedicated = each.value.memory != null ? each.value.memory : 2048
    floating  = each.value.memory != null ? each.value.memory : 2048
  }

  disk {
    datastore_id = var.disk_datastore_id
    interface    = "scsi0"
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
    file_format  = "raw"
    iothread     = false
    discard      = "on"
    size         = 60
    ssd          = true
  }

  network_device {
    bridge   = "vmbr0"
    firewall = false
  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "./ansible-wrapper.sh"

    environment = {
      TF_ANSIBLE_VM_NAME      = self.name
      TF_ANSIBLE_USER         = var.cloud_init_username
      TF_ANSIBLE_HOST         = replace(each.value.ip, "/24", "")
      TF_ANSIBLE_SSH_KEY      = var.cloud_init_private_key_path
      TF_ANSIBLE_HIVE_IPS     = replace(join(",", [for vm in values(var.hive_virtual_machines) : vm.ip]), "/24", "")
      TF_ANSIBLE_PG_ADMIN_PWD = nonsensitive(var.postgres_user_password)
      TF_ANSIBLE_PG_PWD       = nonsensitive(var.k3s_db_password)
      TF_ANSIBLE_PG_USER      = var.k3s_db_username
      TF_ANSIBLE_PG_DB        = var.k3s_db_name
      TF_ANSIBLE_PG_HOST      = replace(var.infra_virtual_machines["postgres"].ip, "/24", "")
      TF_ANSIBLE_LB_IP        = replace(var.infra_virtual_machines["nginx"].ip, "/24", "")
    }
  }

  lifecycle {
    ignore_changes = [network_device, tags, vga, cpu[0].architecture]
  }
}

resource "null_resource" "update_nginx_conf" {
  depends_on = [proxmox_virtual_environment_vm.supporting_infra]

  triggers = {
    hive_ips = replace(join(",", [for vm in values(var.hive_virtual_machines) : vm.ip]), "/24", "")
  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "./update-nginx.sh"

    environment = {
      TF_ANSIBLE_USER     = var.cloud_init_username
      TF_ANSIBLE_HOST     = replace(var.infra_virtual_machines["nginx"].ip, "/24", "")
      TF_ANSIBLE_SSH_KEY  = var.cloud_init_private_key_path
      TF_ANSIBLE_HIVE_IPS = replace(join(",", [for vm in values(var.hive_virtual_machines) : vm.ip]), "/24", "")
    }
  }
}
