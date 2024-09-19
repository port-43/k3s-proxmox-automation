#---------------------------------
# cloud init vars
#---------------------------------

variable "cloud_init_username" {
  description = "cloud init username"
  type        = string
  default     = "username"
}

variable "cloud_init_password" {
  description = "cloud init password"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "cloud_init_public_key" {
  description = "cloud init public key"
  type        = string
  default     = "pub key"
}

variable "cloud_init_private_key_path" {
  description = "cloud init private key path"
  type        = string
  default     = "private key"
}

variable "cloud_init_datastore_id" {
  description = "datastore id for cloud init files"
  type        = string
  default     = "datastore id"
}

#---------------------------------
# k3s db vars
#---------------------------------

variable "postgres_user_password" {
  description = "password of postgres user"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "k3s_db_username" {
  description = "username for k3s postgres account"
  type        = string
  default     = "username"
}

variable "k3s_db_password" {
  description = "username for k3s postgres account"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "k3s_db_name" {
  description = "k3s postgres database name"
  type        = string
  default     = "db name"
}

#---------------------------------
# k3s cluster vars
#---------------------------------

# general
variable "kubernetes_cluster" {
  description = "name of kubernetes cluster"
  type        = string
  default     = "cluster id"
}

variable "ip_gateway" {
  description = "ip gateway"
  type        = string
  default     = "192.168.1.1"
}

variable "vm_tags" {
  description = "vm tags"
  type        = list(any)
  default     = ["k3s", "terraform"]
}

variable "disk_datastore_id" {
  description = "datastore id for vm disks"
  type        = string
  default     = "datastore id"
}

# supporting infra
variable "infra_virtual_machines" {
  type = map(object({
    name   = string
    node   = string
    id     = number
    pool   = string
    memory = number
    cores  = number
    ip     = string
  }))
  default = {
    "name" = {
      name   = "name"
      node   = "pve-node"
      id     = 9999
      pool   = "pool id"
      memory = 1024
      cores  = 1
      ip     = "x.x.x.x/24"
    }
  }
}

# control plane nodes
variable "hive_virtual_machines" {
  type = map(object({
    name   = string
    node   = string
    id     = number
    pool   = string
    memory = number
    cores  = number
    ip     = string
  }))
  default = {
    "name" = {
      name   = "name"
      node   = "pve-node"
      id     = 9999
      pool   = "pool id"
      memory = 1024
      cores  = 1
      ip     = "x.x.x.x/24"
    }
  }
}

# worker nodes
variable "drone_virtual_machines" {
  type = map(object({
    name   = string
    node   = string
    id     = number
    pool   = string
    memory = number
    cores  = number
    ip     = string
  }))
  default = {
    "name" = {
      name   = "name"
      node   = "pve-node"
      id     = 9999
      pool   = "pool id"
      memory = 1024
      cores  = 1
      ip     = "x.x.x.x/24"
    }
  }
}

# storage nodes
variable "storage_virtual_machines" {
  type = map(object({
    name   = string
    node   = string
    id     = number
    pool   = string
    memory = number
    cores  = number
    ip     = string
  }))
  default = {
    "name" = {
      name   = "name"
      node   = "pve-node"
      id     = 9999
      pool   = "pool id"
      memory = 1024
      cores  = 1
      ip     = "x.x.x.x/24"
    }
  }
}
