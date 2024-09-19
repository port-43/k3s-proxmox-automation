resource "proxmox_virtual_environment_file" "vendor_config" {
  content_type = "snippets"
  datastore_id = var.file_datastore_id
  node_name    = var.file_node_name

  source_raw {
    data      = <<EOF
#cloud-config
package_upgrade: true
package_reboot_if_required: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl start qemu-guest-agent
EOF
    file_name = "init-vendor-config.yaml"
  }
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type       = "iso"
  datastore_id       = var.file_datastore_id
  file_name          = var.download_file.name
  node_name          = var.file_node_name
  url                = var.download_file.url
  checksum           = var.download_file.checksum
  checksum_algorithm = var.download_file.checksum_algorithm
}
