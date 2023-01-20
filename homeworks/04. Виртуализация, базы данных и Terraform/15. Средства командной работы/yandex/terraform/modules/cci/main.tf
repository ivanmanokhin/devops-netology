provider "yandex" {
  zone = var.zone
}

data "yandex_compute_image" "image" {
  family = var.image
}

data "yandex_vpc_subnet" "subnet" {
  name = var.subnet
}

resource "yandex_compute_instance" "instance" { 
  name     = var.instance_name
  hostname = var.hostname

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet.id
    nat = var.nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_key}")}"
  }

  depends_on = [
    data.yandex_vpc_subnet.subnet
  ]
}
