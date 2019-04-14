variable project {
  description = "Project ID"
  type        = "string"
}

variable region {
  description = "Region"
  type        = "string"

  # Значение по умолчанию
  default = "europe-west1"
}

variable zone {
  description = "Availability Zone"
  type        = "string"
  default     = "europe-west1-b"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
  type        = "string"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
  type        = "string"
}

variable disk_image {
  description = "Disk image"
  type        = "string"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
