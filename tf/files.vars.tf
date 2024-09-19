#---------------------------------
# file vars
#---------------------------------

variable "file_datastore_id" {
  description = "datastore id for cloud-init file"
  type        = string
  default     = "datastore id"
}

variable "file_node_name" {
  description = "pve node for cloud-init file"
  type        = string
  default     = "pve-node"
}

variable "download_file" {
  description = "download details for image"
  type = object({
    name               = string
    url                = string
    checksum           = string
    checksum_algorithm = string
  })

  validation {
    condition     = var.download_file.checksum_algorithm == "sha256" || var.download_file.checksum_algorithm == "sha512"
    error_message = "Invalid checksum_algorithm, must be sha256 or sha512"
  }
}
