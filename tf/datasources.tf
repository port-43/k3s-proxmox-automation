# data "onepassword_vault" "automation" {
#   name = "automation"
# }

# data "onepassword_item" "coruscant_database" {
#   vault = data.onepassword_vault.automation.uuid
#   title = "coruscant-database"
# }

# data "onepassword_item" "coruscant_database_admin" {
#   vault = data.onepassword_vault.automation.uuid
#   title = "coruscant-database-admin"
# }

# data "onepassword_item" "coruscant_node_token" {
#   for_each   = var.conditional_datasource ? toset("one") : "one"
#   depends_on = [proxmox_virtual_environment_vm.kubernetes-hive-vms]

#   vault = data.onepassword_vault.automation.uuid
#   title = "coruscant-node-token"
# }
