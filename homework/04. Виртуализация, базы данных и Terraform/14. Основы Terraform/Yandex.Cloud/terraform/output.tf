output "ubuntu_private_ip" {
  value = "${yandex_compute_instance.ubuntu[*].network_interface.0.ip_address}"
}

output "ubuntu_public_ip" {
  value = "${yandex_compute_instance.ubuntu[*].network_interface.0.nat_ip_address}"
}

output "centos_private_ip" {
  value = values(yandex_compute_instance.centos).*.network_interface.0.ip_address
}

output "centos_public_ip" {
  value = values(yandex_compute_instance.centos).*.network_interface.0.nat_ip_address
}
