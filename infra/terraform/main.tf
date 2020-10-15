provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "ubuntu1804" {
  family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "crawler" {
  name = "crawler-app"

  labels = {
    tags = "crawler-app"
  }
  resources {
    core_fraction = 100
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "${data.yandex_compute_image.ubuntu1804.id}"
      size = 20
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

    provisioner "remote-exec" {
    script = "../deploy.sh"
  }
}