variable "zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "image" {
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "subnet" {
  type        = string
}

variable "instance_name" {
  type        = string
}

variable "hostname" {
  type        = string
}

variable "cores" {
  type        = number
  default     = 2
}

variable "memory" {
  type        = number
  default     = 2
}

variable "nat" {
  type        = bool
  default     = true
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
}

variable "ssh_key" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
