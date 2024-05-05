resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  network_id = "${yandex_vpc_network.network.id}"
  name = var.public_subnet_name
  zone = var.zone
  v4_cidr_blocks = var.public_subnet_cidr
}

resource "yandex_compute_instance" "nat" {
  name = var.nat_name
  zone = var.zone

  boot_disk {
    initialize_params {
      image_id = var.nat_image
    }
  }

  resources {
    cores = var.instance_resources.cores
    memory = var.instance_resources.memory
    core_fraction = var.instance_resources.core_fraction
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public_subnet.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa_yc.pub")}"
  }
}

resource "yandex_vpc_route_table" "private_route_table" {
  name = var.route_table_name
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address  = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "private_subnet" {
  network_id = "${yandex_vpc_network.network.id}"
  name = var.private_subnet_name
  zone = var.zone
  v4_cidr_blocks = var.private_subnet_cidr
  route_table_id = yandex_vpc_route_table.private_route_table.id
}

data "yandex_compute_image" "image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "public_instance" {
  name = var.public_instance_name
  zone = var.zone

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  resources {
    cores = var.instance_resources.cores
    memory = var.instance_resources.memory
    core_fraction = var.instance_resources.core_fraction
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public_subnet.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa_yc.pub")}"
  }
}

resource "yandex_compute_instance" "private_instance" {
  name = var.private_instance_name
  zone = var.zone

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  resources {
    cores = var.instance_resources.cores
    memory = var.instance_resources.memory
    core_fraction = var.instance_resources.core_fraction
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private_subnet.id}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa_yc.pub")}"
  }
}
