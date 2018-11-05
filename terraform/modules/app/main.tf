resource "google_compute_instance" "app" {
  count        = "${var.count}"
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # Определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  # Определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоеденить данный интерфейс
    network = "default"

    # используем статический IP адрес
    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  # connection {
  #   type        = "ssh"
  #   user        = "appuser"
  #   agent       = "false"
  #   private_key = "${file(var.private_key_path)}"
  # }

  # provisioner "file" {
  #   source      = "${path.module}/files/puma.service"
  #   destination = "/tmp/puma.service"
  # }

  # provisioner "file" {
  #   source      = "${path.module}/files/deploy.sh"
  #   destination = "/tmp/deploy.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/deploy.sh",
  #     "/tmp/deploy.sh ${var.db_host}:${var.db_port}",
  #   ]
  # }
}

resource "google_compute_firewall" "app_ip" {
  name = "reddit-app-ip"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешить доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тегами
  target_tags = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
