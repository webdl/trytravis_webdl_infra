variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west4"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for provisioner connection"
}

variable disk_image {
  description = "Disk image"
}

variable zone {
  description = "Zone"
  default     = "europe-west4-a"
}

variable count {
  description = "Instances count"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for Reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for Reddit DB"
  default     = "reddit-db-base"
}
