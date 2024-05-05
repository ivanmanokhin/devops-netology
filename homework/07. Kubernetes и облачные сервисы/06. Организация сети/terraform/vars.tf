variable "zone" {
  type = string
  default = "ru-central1-a"
}

variable "network_name" {
  type = string
  default = "netology"
}

variable "public_subnet_name" {
  type = string
  default = "public"
}

variable "private_subnet_name" {
  type = string
  default = "private"
}

variable "public_subnet_cidr" {
  type = list
  default = ["192.168.10.0/24"]
}

variable "private_subnet_cidr" {
  type = list
  default = ["192.168.20.0/24"]
}

variable "nat_name" {
  type = string
  default = "nat"
}

variable "nat_image" {
  type = string
  default = "fd80mrhj8fl2oe87o4e1"
}

variable "instance_resources" {
  type = map(number)
  default = {
    cores = 2
    memory = 1
    core_fraction = 20
  }
}

variable "route_table_name" {
  type = string
  default = "private"
}

variable "public_instance_name" {
  type = string
  default = "public-instance"
}

variable "private_instance_name" {
  type = string
  default = "private-instance"
}
