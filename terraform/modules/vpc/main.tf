resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"

  # Название сети, в которой действует правило
  network     = "default"
  description = "Allow SSH from anywhere"
  priority    = "65534"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = "${var.source_ranges}"
}
