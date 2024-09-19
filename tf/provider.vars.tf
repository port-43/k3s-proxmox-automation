#---------------------------------
# provider vars
#---------------------------------

variable "proxmox_endpoint" {
  description = "url for proxmox"
  type        = string
  default     = "https://proxmox.endpoint"
}

variable "proxmox_username" {
  description = "proxmox username"
  type        = string
  default     = "default"
}

variable "proxmox_password" {
  description = "proxmox password"
  type        = string
  sensitive   = true
  default     = "password"
}
