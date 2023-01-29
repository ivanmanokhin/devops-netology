provider "yandex" {
  zone = local.resource_zone_map[terraform.workspace]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

data "yandex_compute_image" "centos" {
  family = "centos-stream-8"
}

resource "yandex_vpc_network" "network" {
  name = "${terraform.workspace}-net"
}
resource "yandex_vpc_subnet" "subnet" {
  name = "${terraform.workspace}-subnet"
  zone           = local.resource_zone_map[terraform.workspace]
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = local.vpc_subnet_map[terraform.workspace]
}

resource "yandex_compute_instance" "ubuntu" { 
  count    = local.instance_count_map[terraform.workspace]
  name     = "${terraform.workspace}-ubuntu-${count.index}"
  hostname = "${terraform.workspace}-ubuntu-${count.index}"

  resources {
    cores  = local.instance_resources[terraform.workspace].cores
    memory = local.instance_resources[terraform.workspace].memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
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

resource "yandex_compute_instance" "centos" { 
  for_each = local.instances[terraform.workspace]
  name     = "${terraform.workspace}-centos-${each.key}"
  hostname = "${terraform.workspace}-centos-${each.key}"

  resources {
    cores  = each.value
    memory = each.value
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "cloud-user:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy  = true
  }
}
