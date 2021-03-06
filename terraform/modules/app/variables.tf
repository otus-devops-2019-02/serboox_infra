variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
  type        = "string"
}

variable zone {
  description = "Availability Zone"
  type        = "string"
  default     = "europe-west1-b"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
