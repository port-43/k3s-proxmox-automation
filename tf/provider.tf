terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.48.4"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = false

  ssh {
    agent = false
  }
}
