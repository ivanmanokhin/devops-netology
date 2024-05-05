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
  depends_on = [
    yandex_vpc_subnet.public_subnet,
  ]
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

  depends_on = [
    yandex_vpc_subnet.public_subnet,
  ]
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

  depends_on = [
    yandex_vpc_subnet.private_subnet,
  ]
}

resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder
  name = var.service_account_name
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = var.folder
  role = "admin"
  member = "serviceAccount:${yandex_iam_service_account.sa.id}"

  depends_on = [
    yandex_iam_service_account.sa,
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id

  depends_on = [
    yandex_iam_service_account.sa,
  ]
}

resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  acl = "public-read"
  bucket = var.bucket_name

  depends_on = [
    yandex_iam_service_account_static_access_key.sa-static-key,
  ]
}

resource "yandex_storage_object" "picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = var.bucket_name
  key = "frog.jpg"
  source = "./files/frog.jpg"

  depends_on = [
    yandex_storage_bucket.bucket
  ]
}

resource "yandex_compute_instance_group" "instance_group" {
  name = var.instance_group_name
  folder_id = var.folder
  service_account_id  = yandex_iam_service_account.sa.id

  instance_template {
    platform_id = "standard-v1"
    resources {
      cores = var.instance_resources.cores
      memory = var.instance_resources.memory
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.instance_group_image
        size = 3
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public_subnet.id]
    }

    metadata = {
      user-data = file("./files/cloud-config.yml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating = 2
    max_expansion = 2
    max_deleting = 2
  }

  deletion_protection = false

  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }

  depends_on = [
    yandex_vpc_subnet.public_subnet,
  ]
}

resource "yandex_lb_target_group" "target_group" {
  name = var.target_group_name
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    address   =  yandex_compute_instance_group.instance_group.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    address   = yandex_compute_instance_group.instance_group.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    address   = yandex_compute_instance_group.instance_group.instances[2].network_interface[0].ip_address
  }
  depends_on = [
    yandex_compute_instance_group.instance_group,
  ]
}

resource "yandex_lb_network_load_balancer" "balancer" {
  name = var.balancer_name
  deletion_protection = false

  listener {
    name = "listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target_group.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }

  depends_on = [
    yandex_compute_instance_group.instance_group,
  ]
}
