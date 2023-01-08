output "zone" {
  value = "${yandex_compute_instance.instance.zone}"
}

output "subnet_id" {
  value = "${yandex_compute_instance.instance.network_interface.0.subnet_id}"
}

output "private_ip" {
  value = "${yandex_compute_instance.instance.network_interface.0.ip_address}"
}

output "public_ip" {
  value = "${yandex_compute_instance.instance.network_interface.0.nat_ip_address}"
}
