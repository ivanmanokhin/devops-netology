provider "yandex" {
  zone = "ru-central1-c"
}

data "yandex_compute_image" "image" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "network" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name = "subnet"
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = ["10.10.10.0/24"]
}

resource "yandex_compute_instance" "instance" { 
  name = "ubuntu-instance-00"
  hostname = "ubuntu-instance-00"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
