variable "instance_count" {
  default = 5
}

provider "yandex" {
  zone = "ru-central1-a"
}

data "yandex_compute_image" "image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_vpc_network" "network" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = ["10.10.10.0/24"]
}

resource "yandex_compute_instance" "instance" {
  count = var.instance_count

  name = "k8s-node0${count.index + 1}"
  hostname = "k8s-node0${count.index + 1}"

  resources {
    core_fraction = 20
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size = "32"
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
