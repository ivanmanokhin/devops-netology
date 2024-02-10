# Домашнее задание по теме: «Установка Kubernetes»

## Цель задания

Установить кластер K8s.

## Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

## Результат

1. Подготавливаем ноды кластера с помощью [terraform](./terraform/):
    <details>
      <summary>Лог terraform</summary>
    
      ```bash
      terraform apply -auto-approve
      data.yandex_compute_image.image: Reading...
      data.yandex_compute_image.image: Read complete after 0s [id=fd8bt3r9v1tq5fq7jcna]
      
      Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create
      
      Terraform will perform the following actions:
      
        # yandex_compute_instance.instance[0] will be created
        + resource "yandex_compute_instance" "instance" {
            + created_at                = (known after apply)
            + folder_id                 = (known after apply)
            + fqdn                      = (known after apply)
            + hostname                  = "k8s-node01"
            + id                        = (known after apply)
            + metadata                  = {
                + "ssh-keys" = <<-EOT
                      ubuntu:ssh-rsa AAAAB3Nza[REDACTED]
                  EOT
              }
            + name                      = "k8s-node01"
            + network_acceleration_type = "standard"
            + platform_id               = "standard-v1"
            + service_account_id        = (known after apply)
            + status                    = (known after apply)
            + zone                      = (known after apply)
      
            + boot_disk {
                + auto_delete = true
                + device_name = (known after apply)
                + disk_id     = (known after apply)
                + mode        = (known after apply)
      
                + initialize_params {
                    + block_size  = (known after apply)
                    + description = (known after apply)
                    + image_id    = "fd8bt3r9v1tq5fq7jcna"
                    + name        = (known after apply)
                    + size        = 32
                    + snapshot_id = (known after apply)
                    + type        = "network-hdd"
                  }
              }
      
            + network_interface {
                + index              = (known after apply)
                + ip_address         = (known after apply)
                + ipv4               = true
                + ipv6               = (known after apply)
                + ipv6_address       = (known after apply)
                + mac_address        = (known after apply)
                + nat                = true
                + nat_ip_address     = (known after apply)
                + nat_ip_version     = (known after apply)
                + security_group_ids = (known after apply)
                + subnet_id          = (known after apply)
              }
      
            + resources {
                + core_fraction = 20
                + cores         = 4
                + memory        = 4
              }
          }
      
        # yandex_compute_instance.instance[1] will be created
        + resource "yandex_compute_instance" "instance" {
            + created_at                = (known after apply)
            + folder_id                 = (known after apply)
            + fqdn                      = (known after apply)
            + hostname                  = "k8s-node02"
            + id                        = (known after apply)
            + metadata                  = {
                + "ssh-keys" = <<-EOT
                      ubuntu:ssh-rsa AAAAB3Nza[REDACTED]
                  EOT
              }
            + name                      = "k8s-node02"
            + network_acceleration_type = "standard"
            + platform_id               = "standard-v1"
            + service_account_id        = (known after apply)
            + status                    = (known after apply)
            + zone                      = (known after apply)
      
            + boot_disk {
                + auto_delete = true
                + device_name = (known after apply)
                + disk_id     = (known after apply)
                + mode        = (known after apply)
      
                + initialize_params {
                    + block_size  = (known after apply)
                    + description = (known after apply)
                    + image_id    = "fd8bt3r9v1tq5fq7jcna"
                    + name        = (known after apply)
                    + size        = 32
                    + snapshot_id = (known after apply)
                    + type        = "network-hdd"
                  }
              }
      
            + network_interface {
                + index              = (known after apply)
                + ip_address         = (known after apply)
                + ipv4               = true
                + ipv6               = (known after apply)
                + ipv6_address       = (known after apply)
                + mac_address        = (known after apply)
                + nat                = true
                + nat_ip_address     = (known after apply)
                + nat_ip_version     = (known after apply)
                + security_group_ids = (known after apply)
                + subnet_id          = (known after apply)
              }
      
            + resources {
                + core_fraction = 20
                + cores         = 4
                + memory        = 4
              }
          }
      
        # yandex_compute_instance.instance[2] will be created
        + resource "yandex_compute_instance" "instance" {
            + created_at                = (known after apply)
            + folder_id                 = (known after apply)
            + fqdn                      = (known after apply)
            + hostname                  = "k8s-node03"
            + id                        = (known after apply)
            + metadata                  = {
                + "ssh-keys" = <<-EOT
                      ubuntu:ssh-rsa AAAAB3Nza[REDACTED]
                  EOT
              }
            + name                      = "k8s-node03"
            + network_acceleration_type = "standard"
            + platform_id               = "standard-v1"
            + service_account_id        = (known after apply)
            + status                    = (known after apply)
            + zone                      = (known after apply)
      
            + boot_disk {
                + auto_delete = true
                + device_name = (known after apply)
                + disk_id     = (known after apply)
                + mode        = (known after apply)
      
                + initialize_params {
                    + block_size  = (known after apply)
                    + description = (known after apply)
                    + image_id    = "fd8bt3r9v1tq5fq7jcna"
                    + name        = (known after apply)
                    + size        = 32
                    + snapshot_id = (known after apply)
                    + type        = "network-hdd"
                  }
              }
      
            + network_interface {
                + index              = (known after apply)
                + ip_address         = (known after apply)
                + ipv4               = true
                + ipv6               = (known after apply)
                + ipv6_address       = (known after apply)
                + mac_address        = (known after apply)
                + nat                = true
                + nat_ip_address     = (known after apply)
                + nat_ip_version     = (known after apply)
                + security_group_ids = (known after apply)
                + subnet_id          = (known after apply)
              }
      
            + resources {
                + core_fraction = 20
                + cores         = 4
                + memory        = 4
              }
          }
      
        # yandex_compute_instance.instance[3] will be created
        + resource "yandex_compute_instance" "instance" {
            + created_at                = (known after apply)
            + folder_id                 = (known after apply)
            + fqdn                      = (known after apply)
            + hostname                  = "k8s-node04"
            + id                        = (known after apply)
            + metadata                  = {
                + "ssh-keys" = <<-EOT
                      ubuntu:ssh-rsa AAAAB3Nza[REDACTED]
                  EOT
              }
            + name                      = "k8s-node04"
            + network_acceleration_type = "standard"
            + platform_id               = "standard-v1"
            + service_account_id        = (known after apply)
            + status                    = (known after apply)
            + zone                      = (known after apply)
      
            + boot_disk {
                + auto_delete = true
                + device_name = (known after apply)
                + disk_id     = (known after apply)
                + mode        = (known after apply)
      
                + initialize_params {
                    + block_size  = (known after apply)
                    + description = (known after apply)
                    + image_id    = "fd8bt3r9v1tq5fq7jcna"
                    + name        = (known after apply)
                    + size        = 32
                    + snapshot_id = (known after apply)
                    + type        = "network-hdd"
                  }
              }
      
            + network_interface {
                + index              = (known after apply)
                + ip_address         = (known after apply)
                + ipv4               = true
                + ipv6               = (known after apply)
                + ipv6_address       = (known after apply)
                + mac_address        = (known after apply)
                + nat                = true
                + nat_ip_address     = (known after apply)
                + nat_ip_version     = (known after apply)
                + security_group_ids = (known after apply)
                + subnet_id          = (known after apply)
              }
      
            + resources {
                + core_fraction = 20
                + cores         = 4
                + memory        = 4
              }
          }
      
        # yandex_compute_instance.instance[4] will be created
        + resource "yandex_compute_instance" "instance" {
            + created_at                = (known after apply)
            + folder_id                 = (known after apply)
            + fqdn                      = (known after apply)
            + hostname                  = "k8s-node05"
            + id                        = (known after apply)
            + metadata                  = {
                + "ssh-keys" = <<-EOT
                      ubuntu:ssh-rsa AAAAB3Nza[REDACTED]
                  EOT
              }
            + name                      = "k8s-node05"
            + network_acceleration_type = "standard"
            + platform_id               = "standard-v1"
            + service_account_id        = (known after apply)
            + status                    = (known after apply)
            + zone                      = (known after apply)
      
            + boot_disk {
                + auto_delete = true
                + device_name = (known after apply)
                + disk_id     = (known after apply)
                + mode        = (known after apply)
      
                + initialize_params {
                    + block_size  = (known after apply)
                    + description = (known after apply)
                    + image_id    = "fd8bt3r9v1tq5fq7jcna"
                    + name        = (known after apply)
                    + size        = 32
                    + snapshot_id = (known after apply)
                    + type        = "network-hdd"
                  }
              }
      
            + network_interface {
                + index              = (known after apply)
                + ip_address         = (known after apply)
                + ipv4               = true
                + ipv6               = (known after apply)
                + ipv6_address       = (known after apply)
                + mac_address        = (known after apply)
                + nat                = true
                + nat_ip_address     = (known after apply)
                + nat_ip_version     = (known after apply)
                + security_group_ids = (known after apply)
                + subnet_id          = (known after apply)
              }
      
            + resources {
                + core_fraction = 20
                + cores         = 4
                + memory        = 4
              }
          }
      
        # yandex_vpc_network.network will be created
        + resource "yandex_vpc_network" "network" {
            + created_at                = (known after apply)
            + default_security_group_id = (known after apply)
            + folder_id                 = (known after apply)
            + id                        = (known after apply)
            + labels                    = (known after apply)
            + name                      = "net"
            + subnet_ids                = (known after apply)
          }
      
        # yandex_vpc_subnet.subnet will be created
        + resource "yandex_vpc_subnet" "subnet" {
            + created_at     = (known after apply)
            + folder_id      = (known after apply)
            + id             = (known after apply)
            + labels         = (known after apply)
            + name           = "subnet"
            + network_id     = (known after apply)
            + v4_cidr_blocks = [
                + "10.10.10.0/24",
              ]
            + v6_cidr_blocks = (known after apply)
            + zone           = "ru-central1-a"
          }
      
      Plan: 7 to add, 0 to change, 0 to destroy.
      
      Changes to Outputs:
        + private_ip = [
            + (known after apply),
            + (known after apply),
            + (known after apply),
            + (known after apply),
            + (known after apply),
          ]
        + public_ip  = [
            + (known after apply),
            + (known after apply),
            + (known after apply),
            + (known after apply),
            + (known after apply),
          ]
      yandex_vpc_network.network: Creating...
      yandex_vpc_network.network: Creation complete after 1s [id=enpo7o6s6pmo2af1snev]
      yandex_vpc_subnet.subnet: Creating...
      yandex_vpc_subnet.subnet: Creation complete after 1s [id=e9bc7d68ch2rivjmthjn]
      yandex_compute_instance.instance[4]: Creating...
      yandex_compute_instance.instance[0]: Creating...
      yandex_compute_instance.instance[3]: Creating...
      yandex_compute_instance.instance[2]: Creating...
      yandex_compute_instance.instance[1]: Creating...
      yandex_compute_instance.instance[0]: Still creating... [10s elapsed]
      yandex_compute_instance.instance[3]: Still creating... [10s elapsed]
      yandex_compute_instance.instance[2]: Still creating... [10s elapsed]
      yandex_compute_instance.instance[1]: Still creating... [10s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [10s elapsed]
      yandex_compute_instance.instance[3]: Still creating... [20s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [20s elapsed]
      yandex_compute_instance.instance[1]: Still creating... [20s elapsed]
      yandex_compute_instance.instance[2]: Still creating... [20s elapsed]
      yandex_compute_instance.instance[0]: Still creating... [20s elapsed]
      yandex_compute_instance.instance[0]: Still creating... [30s elapsed]
      yandex_compute_instance.instance[1]: Still creating... [30s elapsed]
      yandex_compute_instance.instance[3]: Still creating... [30s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [30s elapsed]
      yandex_compute_instance.instance[2]: Still creating... [30s elapsed]
      yandex_compute_instance.instance[2]: Still creating... [40s elapsed]
      yandex_compute_instance.instance[3]: Still creating... [40s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [40s elapsed]
      yandex_compute_instance.instance[1]: Still creating... [40s elapsed]
      yandex_compute_instance.instance[0]: Still creating... [40s elapsed]
      yandex_compute_instance.instance[0]: Still creating... [50s elapsed]
      yandex_compute_instance.instance[3]: Still creating... [50s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [50s elapsed]
      yandex_compute_instance.instance[2]: Still creating... [50s elapsed]
      yandex_compute_instance.instance[1]: Still creating... [50s elapsed]
      yandex_compute_instance.instance[1]: Creation complete after 59s [id=fhm3f2d02mqacoa2j1sl]
      yandex_compute_instance.instance[2]: Still creating... [1m0s elapsed]
      yandex_compute_instance.instance[3]: Still creating... [1m0s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [1m0s elapsed]
      yandex_compute_instance.instance[0]: Still creating... [1m0s elapsed]
      yandex_compute_instance.instance[0]: Creation complete after 1m5s [id=fhmmnomv4htplgg6oj8v]
      yandex_compute_instance.instance[2]: Creation complete after 1m6s [id=fhm9j0n1jn26rovmu4iq]
      yandex_compute_instance.instance[3]: Still creating... [1m10s elapsed]
      yandex_compute_instance.instance[4]: Still creating... [1m10s elapsed]
      yandex_compute_instance.instance[3]: Creation complete after 1m10s [id=fhmt3sos7gt98vk4fms8]
      yandex_compute_instance.instance[4]: Creation complete after 1m12s [id=fhmaf6h669kgvr3d6tqq]
      
      Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
      
      Outputs:
      
      private_ip = [
        "10.10.10.32",
        "10.10.10.13",
        "10.10.10.30",
        "10.10.10.15",
        "10.10.10.18",
      ]
      public_ip = [
        "158.160.45.157",
        "158.160.36.120",
        "158.160.35.177",
        "51.250.87.98",
        "158.160.63.68",
      ]
      ```
    </details>

2. Выполняем настройку нод:
    * Команды для настройки нод k8s:
      ```bash
      {
      # отключаем swap
      sudo swapoff -a
      sudo sed -i '/ swap / s/^/#/' /etc/fstab
      
      # активируем необходимые модули ядра
      cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
      overlay
      br_netfilter
      EOF
      sudo modprobe overlay
      sudo modprobe br_netfilter
      
      # включаем маршрутизацию и обработку фаерволом трафика на бриджах
      cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
      net.bridge.bridge-nf-call-iptables  = 1
      net.bridge.bridge-nf-call-ip6tables = 1
      net.ipv4.ip_forward                 = 1
      EOF
      sudo sysctl --system
      
      # обновляем и устанавливаем необходимые пакеты
      sudo apt update
      sudo apt upgrade -y
      sudo apt install -y apt-transport-https ca-certificates curl
      
      # устанавливаем k8s
      sudo mkdir /etc/apt/keyrings
      curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
      echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt update
      sudo apt install -y kubelet kubeadm kubectl containerd
      sudo apt-mark hold kubelet kubeadm kubectl containerd
      }
      ```

      <details>
         <summary>Лог выполнения команд (с одной ноды)</summary>
      
         ```bash
         ubuntu@k8s-node05:~$ {
         > # отключаем swap
         > sudo swapoff -a
         > sudo sed -i '/ swap / s/^/#/' /etc/fstab
         > 
         > # активируем необходимые модули ядра
         > cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
         > overlay
         > br_netfilter
         > EOF
         > sudo modprobe overlay
         > sudo modprobe br_netfilter
         > 
         > # включаем маршрутизацию и обработку фаерволом трафика на бриджах
         > cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
         > net.bridge.bridge-nf-call-iptables  = 1
         > net.bridge.bridge-nf-call-ip6tables = 1
         > net.ipv4.ip_forward                 = 1
         > EOF
         > sudo sysctl --system
         > 
         > # обновляем и устанавливаем необходимые пакеты
         > sudo apt update
         > sudo apt upgrade -y
         > sudo apt install -y apt-transport-https ca-certificates curl
         > 
         > # устанавливаем k8s
         > sudo mkdir /etc/apt/keyrings
         > curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
         > echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
         > sudo apt update
         > sudo apt install -y kubelet kubeadm kubectl containerd
         > sudo apt-mark hold kubelet kubeadm kubectl containerd
         > }
         overlay
         br_netfilter
         net.bridge.bridge-nf-call-iptables  = 1
         net.bridge.bridge-nf-call-ip6tables = 1
         net.ipv4.ip_forward                 = 1
         * Applying /etc/sysctl.d/10-console-messages.conf ...
         kernel.printk = 4 4 1 7
         * Applying /etc/sysctl.d/10-ipv6-privacy.conf ...
         net.ipv6.conf.all.use_tempaddr = 2
         net.ipv6.conf.default.use_tempaddr = 2
         * Applying /etc/sysctl.d/10-kernel-hardening.conf ...
         kernel.kptr_restrict = 1
         * Applying /etc/sysctl.d/10-link-restrictions.conf ...
         fs.protected_hardlinks = 1
         fs.protected_symlinks = 1
         * Applying /etc/sysctl.d/10-magic-sysrq.conf ...
         kernel.sysrq = 176
         * Applying /etc/sysctl.d/10-network-security.conf ...
         net.ipv4.conf.default.rp_filter = 2
         net.ipv4.conf.all.rp_filter = 2
         * Applying /etc/sysctl.d/10-ptrace.conf ...
         kernel.yama.ptrace_scope = 1
         * Applying /etc/sysctl.d/10-zeropage.conf ...
         vm.mmap_min_addr = 65536
         * Applying /usr/lib/sysctl.d/50-default.conf ...
         net.ipv4.conf.default.promote_secondaries = 1
         sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument
         net.ipv4.ping_group_range = 0 2147483647
         net.core.default_qdisc = fq_codel
         fs.protected_regular = 1
         fs.protected_fifos = 1
         * Applying /usr/lib/sysctl.d/50-pid-max.conf ...
         kernel.pid_max = 4194304
         * Applying /etc/sysctl.d/99-sysctl.conf ...
         * Applying /etc/sysctl.d/k8s.conf ...
         net.bridge.bridge-nf-call-iptables = 1
         net.bridge.bridge-nf-call-ip6tables = 1
         net.ipv4.ip_forward = 1
         * Applying /usr/lib/sysctl.d/protect-links.conf ...
         fs.protected_fifos = 1
         fs.protected_hardlinks = 1
         fs.protected_regular = 2
         fs.protected_symlinks = 1
         * Applying /etc/sysctl.conf ...
         Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
         Hit:2 http://mirror.yandex.ru/ubuntu focal InRelease     
         Get:3 http://mirror.yandex.ru/ubuntu focal-updates InRelease [114 kB]
         Hit:4 http://mirror.yandex.ru/ubuntu focal-backports InRelease
         Get:5 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [2,710 kB]
         Get:6 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages [706 kB]
         Get:7 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [413 kB]
         Get:8 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [2,547 kB]
         Get:9 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [355 kB]
         Get:10 http://security.ubuntu.com/ubuntu focal-security/universe i386 Packages [645 kB]
         Get:11 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [937 kB]
         Get:12 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [197 kB]
         Get:13 http://mirror.yandex.ru/ubuntu focal-updates/main i386 Packages [931 kB]
         Get:14 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 Packages [3,090 kB]
         Get:15 http://mirror.yandex.ru/ubuntu focal-updates/main Translation-en [496 kB]
         Get:16 http://mirror.yandex.ru/ubuntu focal-updates/restricted amd64 Packages [2,665 kB]
         Get:17 http://mirror.yandex.ru/ubuntu focal-updates/restricted Translation-en [371 kB]
         Get:18 http://mirror.yandex.ru/ubuntu focal-updates/universe i386 Packages [772 kB]
         Get:19 http://mirror.yandex.ru/ubuntu focal-updates/universe amd64 Packages [1,163 kB]
         Get:20 http://mirror.yandex.ru/ubuntu focal-updates/universe Translation-en [279 kB]
         Fetched 18.5 MB in 6s (3,175 kB/s)                              
         Reading package lists... Done
         Building dependency tree       
         Reading state information... Done
         5 packages can be upgraded. Run 'apt list --upgradable' to see them.
         Reading package lists... Done
         Building dependency tree       
         Reading state information... Done
         Calculating upgrade... Done
         The following NEW packages will be installed:
           linux-headers-5.4.0-171 linux-headers-5.4.0-171-generic linux-image-5.4.0-171-generic linux-modules-5.4.0-171-generic
           linux-modules-extra-5.4.0-171-generic
         The following packages will be upgraded:
           libssl1.1 linux-generic linux-headers-generic linux-image-generic openssl
         5 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
         5 standard LTS security updates
         Need to get 79.1 MB of archives.
         After this operation, 380 MB of additional disk space will be used.
         Get:1 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 libssl1.1 amd64 1.1.1f-1ubuntu2.21 [1,321 kB]
         Get:2 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 openssl amd64 1.1.1f-1ubuntu2.21 [621 kB]
         Get:3 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-modules-5.4.0-171-generic amd64 5.4.0-171.189 [15.0 MB]
         Get:4 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-image-5.4.0-171-generic amd64 5.4.0-171.189 [10.5 MB]
         Get:5 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-modules-extra-5.4.0-171-generic amd64 5.4.0-171.189 [39.2 MB]
         Get:6 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-generic amd64 5.4.0.171.169 [1,900 B]
         Get:7 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-image-generic amd64 5.4.0.171.169 [2,544 B]
         Get:8 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-headers-5.4.0-171 all 5.4.0-171.189 [11.0 MB]
         Get:9 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-headers-5.4.0-171-generic amd64 5.4.0-171.189 [1,379 kB]
         Get:10 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 linux-headers-generic amd64 5.4.0.171.169 [2,408 B]
         Fetched 79.1 MB in 3s (27.5 MB/s)                  
         Preconfiguring packages ...
         (Reading database ... 102638 files and directories currently installed.)
         Preparing to unpack .../0-libssl1.1_1.1.1f-1ubuntu2.21_amd64.deb ...
         Unpacking libssl1.1:amd64 (1.1.1f-1ubuntu2.21) over (1.1.1f-1ubuntu2.20) ...
         Preparing to unpack .../1-openssl_1.1.1f-1ubuntu2.21_amd64.deb ...
         Unpacking openssl (1.1.1f-1ubuntu2.21) over (1.1.1f-1ubuntu2.20) ...
         Selecting previously unselected package linux-modules-5.4.0-171-generic.
         Preparing to unpack .../2-linux-modules-5.4.0-171-generic_5.4.0-171.189_amd64.deb ...
         Unpacking linux-modules-5.4.0-171-generic (5.4.0-171.189) ...
         Selecting previously unselected package linux-image-5.4.0-171-generic.
         Preparing to unpack .../3-linux-image-5.4.0-171-generic_5.4.0-171.189_amd64.deb ...
         Unpacking linux-image-5.4.0-171-generic (5.4.0-171.189) ...
         Selecting previously unselected package linux-modules-extra-5.4.0-171-generic.
         Preparing to unpack .../4-linux-modules-extra-5.4.0-171-generic_5.4.0-171.189_amd64.deb ...
         Unpacking linux-modules-extra-5.4.0-171-generic (5.4.0-171.189) ...
         Preparing to unpack .../5-linux-generic_5.4.0.171.169_amd64.deb ...
         Unpacking linux-generic (5.4.0.171.169) over (5.4.0.170.168) ...
         Preparing to unpack .../6-linux-image-generic_5.4.0.171.169_amd64.deb ...
         Unpacking linux-image-generic (5.4.0.171.169) over (5.4.0.170.168) ...
         Selecting previously unselected package linux-headers-5.4.0-171.
         Preparing to unpack .../7-linux-headers-5.4.0-171_5.4.0-171.189_all.deb ...
         Unpacking linux-headers-5.4.0-171 (5.4.0-171.189) ...
         Selecting previously unselected package linux-headers-5.4.0-171-generic.
         Preparing to unpack .../8-linux-headers-5.4.0-171-generic_5.4.0-171.189_amd64.deb ...
         Unpacking linux-headers-5.4.0-171-generic (5.4.0-171.189) ...
         Preparing to unpack .../9-linux-headers-generic_5.4.0.171.169_amd64.deb ...
         Unpacking linux-headers-generic (5.4.0.171.169) over (5.4.0.170.168) ...
         Setting up linux-modules-5.4.0-171-generic (5.4.0-171.189) ...
         Setting up libssl1.1:amd64 (1.1.1f-1ubuntu2.21) ...
         Setting up linux-headers-5.4.0-171 (5.4.0-171.189) ...
         Setting up linux-image-5.4.0-171-generic (5.4.0-171.189) ...
         I: /boot/vmlinuz.old is now a symlink to vmlinuz-5.4.0-170-generic
         I: /boot/initrd.img.old is now a symlink to initrd.img-5.4.0-170-generic
         I: /boot/vmlinuz is now a symlink to vmlinuz-5.4.0-171-generic
         I: /boot/initrd.img is now a symlink to initrd.img-5.4.0-171-generic
         Setting up openssl (1.1.1f-1ubuntu2.21) ...
         Setting up linux-headers-5.4.0-171-generic (5.4.0-171.189) ...
         Setting up linux-modules-extra-5.4.0-171-generic (5.4.0-171.189) ...
         Setting up linux-headers-generic (5.4.0.171.169) ...
         Setting up linux-image-generic (5.4.0.171.169) ...
         Setting up linux-generic (5.4.0.171.169) ...
         Processing triggers for man-db (2.9.1-1) ...
         Processing triggers for libc-bin (2.31-0ubuntu9.14) ...
         Processing triggers for linux-image-5.4.0-171-generic (5.4.0-171.189) ...
         /etc/kernel/postinst.d/initramfs-tools:
         update-initramfs: Generating /boot/initrd.img-5.4.0-171-generic
         /etc/kernel/postinst.d/zz-update-grub:
         Sourcing file `/etc/default/grub'
         Sourcing file `/etc/default/grub.d/init-select.cfg'
         Generating grub configuration file ...
         Found linux image: /boot/vmlinuz-5.4.0-171-generic
         Found initrd image: /boot/initrd.img-5.4.0-171-generic
         Found linux image: /boot/vmlinuz-5.4.0-170-generic
         Found initrd image: /boot/initrd.img-5.4.0-170-generic
         Found linux image: /boot/vmlinuz-5.4.0-42-generic
         Found initrd image: /boot/initrd.img-5.4.0-42-generic
         done
         Reading package lists... Done
         Building dependency tree       
         Reading state information... Done
         ca-certificates is already the newest version (20230311ubuntu0.20.04.1).
         curl is already the newest version (7.68.0-1ubuntu2.21).
         apt-transport-https is already the newest version (2.0.10).
         The following packages were automatically installed and are no longer required:
           linux-headers-5.4.0-42 linux-headers-5.4.0-42-generic linux-image-5.4.0-42-generic linux-modules-5.4.0-42-generic linux-modules-extra-5.4.0-42-generic
         Use 'sudo apt autoremove' to remove them.
         0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
         deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main
         Hit:1 http://mirror.yandex.ru/ubuntu focal InRelease
         Hit:2 http://mirror.yandex.ru/ubuntu focal-updates InRelease                                                                    
         Hit:3 http://mirror.yandex.ru/ubuntu focal-backports InRelease                                                                  
         Hit:4 http://security.ubuntu.com/ubuntu focal-security InRelease                                                                
         Get:5 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [8,993 B]                        
         Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [69.9 kB]
         Fetched 78.9 kB in 1s (57.0 kB/s)  
         Reading package lists... Done
         Building dependency tree       
         Reading state information... Done
         All packages are up to date.
         Reading package lists... Done
         Building dependency tree       
         Reading state information... Done
         The following packages were automatically installed and are no longer required:
           linux-headers-5.4.0-42 linux-headers-5.4.0-42-generic linux-image-5.4.0-42-generic linux-modules-5.4.0-42-generic linux-modules-extra-5.4.0-42-generic
         Use 'sudo apt autoremove' to remove them.
         The following additional packages will be installed:
           conntrack cri-tools ebtables ethtool kubernetes-cni runc socat
         Suggested packages:
           nftables
         The following NEW packages will be installed:
           conntrack containerd cri-tools ebtables ethtool kubeadm kubectl kubelet kubernetes-cni runc socat
         0 upgraded, 11 newly installed, 0 to remove and 0 not upgraded.
         Need to get 123 MB of archives.
         After this operation, 489 MB of additional disk space will be used.
         Get:1 http://mirror.yandex.ru/ubuntu focal/main amd64 conntrack amd64 1:1.4.5-2 [30.3 kB]
         Get:2 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 runc amd64 1.1.7-0ubuntu1~20.04.2 [3,836 kB]
         Get:3 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 containerd amd64 1.7.2-0ubuntu1~20.04.1 [32.5 MB]
         Get:4 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 cri-tools amd64 1.26.0-00 [18.9 MB]
         Get:5 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 1.2.0-00 [27.6 MB]
         Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.28.2-00 [19.5 MB]
         Get:7 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.28.2-00 [10.3 MB]
         Get:8 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.28.2-00 [10.3 MB]
         Get:9 http://mirror.yandex.ru/ubuntu focal/main amd64 ebtables amd64 2.0.11-3build1 [80.3 kB]
         Get:10 http://mirror.yandex.ru/ubuntu focal/main amd64 ethtool amd64 1:5.4-1 [134 kB]
         Get:11 http://mirror.yandex.ru/ubuntu focal/main amd64 socat amd64 1.7.3.3-2 [323 kB]
         Fetched 123 MB in 2s (50.6 MB/s) 
         Selecting previously unselected package conntrack.
         (Reading database ... 139039 files and directories currently installed.)
         Preparing to unpack .../00-conntrack_1%3a1.4.5-2_amd64.deb ...
         Unpacking conntrack (1:1.4.5-2) ...
         Selecting previously unselected package runc.
         Preparing to unpack .../01-runc_1.1.7-0ubuntu1~20.04.2_amd64.deb ...
         Unpacking runc (1.1.7-0ubuntu1~20.04.2) ...
         Selecting previously unselected package containerd.
         Preparing to unpack .../02-containerd_1.7.2-0ubuntu1~20.04.1_amd64.deb ...
         Unpacking containerd (1.7.2-0ubuntu1~20.04.1) ...
         Selecting previously unselected package cri-tools.
         Preparing to unpack .../03-cri-tools_1.26.0-00_amd64.deb ...
         Unpacking cri-tools (1.26.0-00) ...
         Selecting previously unselected package ebtables.
         Preparing to unpack .../04-ebtables_2.0.11-3build1_amd64.deb ...
         Unpacking ebtables (2.0.11-3build1) ...
         Selecting previously unselected package ethtool.
         Preparing to unpack .../05-ethtool_1%3a5.4-1_amd64.deb ...
         Unpacking ethtool (1:5.4-1) ...
         Selecting previously unselected package kubernetes-cni.
         Preparing to unpack .../06-kubernetes-cni_1.2.0-00_amd64.deb ...
         Unpacking kubernetes-cni (1.2.0-00) ...
         Selecting previously unselected package socat.
         Preparing to unpack .../07-socat_1.7.3.3-2_amd64.deb ...
         Unpacking socat (1.7.3.3-2) ...
         Selecting previously unselected package kubelet.
         Preparing to unpack .../08-kubelet_1.28.2-00_amd64.deb ...
         Unpacking kubelet (1.28.2-00) ...
         Selecting previously unselected package kubectl.
         Preparing to unpack .../09-kubectl_1.28.2-00_amd64.deb ...
         Unpacking kubectl (1.28.2-00) ...
         Selecting previously unselected package kubeadm.
         Preparing to unpack .../10-kubeadm_1.28.2-00_amd64.deb ...
         Unpacking kubeadm (1.28.2-00) ...
         Setting up conntrack (1:1.4.5-2) ...
         Setting up runc (1.1.7-0ubuntu1~20.04.2) ...
         Setting up kubectl (1.28.2-00) ...
         Setting up ebtables (2.0.11-3build1) ...
         Setting up socat (1.7.3.3-2) ...
         Setting up cri-tools (1.26.0-00) ...
         Setting up containerd (1.7.2-0ubuntu1~20.04.1) ...
         Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
         Setting up kubernetes-cni (1.2.0-00) ...
         Setting up ethtool (1:5.4-1) ...
         Setting up kubelet (1.28.2-00) ...
         Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
         Setting up kubeadm (1.28.2-00) ...
         Processing triggers for man-db (2.9.1-1) ...
         kubelet set on hold.
         kubeadm set on hold.
         kubectl set on hold.
         containerd set on hold.
         ```
      </details>
3. Инициализируем кластер (на местер ноде):
    * Команда для инициализации k8s:
      ```bash
      sudo kubeadm init \
        --apiserver-advertise-address=10.10.10.32 \
        --pod-network-cidr 10.244.0.0/16 \
        --apiserver-cert-extra-sans=158.160.45.157
      mkdir .kube && sudo cp /etc/kubernetes/admin.conf ~/.kube/config && sudo chown -R ubuntu: .kube/
      kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
      ```
      <details>
         <summary>Лог выполнения команды</summary>
      
         ```bash
         ubuntu@k8s-node01:~$       sudo kubeadm init \
         >         --apiserver-advertise-address=10.10.10.32 \
         >         --pod-network-cidr 10.244.0.0/16 \
         >         --apiserver-cert-extra-sans=158.160.45.157
         I0209 06:28:31.852075   21423 version.go:256] remote version is much newer: v1.29.1; falling back to: stable-1.28
         [init] Using Kubernetes version: v1.28.6
         [preflight] Running pre-flight checks
         [preflight] Pulling images required for setting up a Kubernetes cluster
         [preflight] This might take a minute or two, depending on the speed of your internet connection
         [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
         W0209 06:28:32.723493   21423 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
         [certs] Using certificateDir folder "/etc/kubernetes/pki"
         [certs] Generating "ca" certificate and key
         [certs] Generating "apiserver" certificate and key
         [certs] apiserver serving cert is signed for DNS names [k8s-node01 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.10.10.32 158.160.45.157]
         [certs] Generating "apiserver-kubelet-client" certificate and key
         [certs] Generating "front-proxy-ca" certificate and key
         [certs] Generating "front-proxy-client" certificate and key
         [certs] Generating "etcd/ca" certificate and key
         [certs] Generating "etcd/server" certificate and key
         [certs] etcd/server serving cert is signed for DNS names [k8s-node01 localhost] and IPs [10.10.10.32 127.0.0.1 ::1]
         [certs] Generating "etcd/peer" certificate and key
         [certs] etcd/peer serving cert is signed for DNS names [k8s-node01 localhost] and IPs [10.10.10.32 127.0.0.1 ::1]
         [certs] Generating "etcd/healthcheck-client" certificate and key
         [certs] Generating "apiserver-etcd-client" certificate and key
         [certs] Generating "sa" key and public key
         [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
         [kubeconfig] Writing "admin.conf" kubeconfig file
         [kubeconfig] Writing "kubelet.conf" kubeconfig file
         [kubeconfig] Writing "controller-manager.conf" kubeconfig file
         [kubeconfig] Writing "scheduler.conf" kubeconfig file
         [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
         [control-plane] Using manifest folder "/etc/kubernetes/manifests"
         [control-plane] Creating static Pod manifest for "kube-apiserver"
         [control-plane] Creating static Pod manifest for "kube-controller-manager"
         [control-plane] Creating static Pod manifest for "kube-scheduler"
         [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
         [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
         [kubelet-start] Starting the kubelet
         [wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
         [apiclient] All control plane components are healthy after 8.503695 seconds
         [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
         [kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
         [upload-certs] Skipping phase. Please see --upload-certs
         [mark-control-plane] Marking the node k8s-node01 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
         [mark-control-plane] Marking the node k8s-node01 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
         [bootstrap-token] Using token: eyn7vn.jxlqmrxi6d01ax55
         [bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
         [bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
         [bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
         [bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
         [bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
         [bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
         [kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
         [addons] Applied essential addon: CoreDNS
         [addons] Applied essential addon: kube-proxy
         
         Your Kubernetes control-plane has initialized successfully!
         
         To start using your cluster, you need to run the following as a regular user:
         
           mkdir -p $HOME/.kube
           sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
           sudo chown $(id -u):$(id -g) $HOME/.kube/config
         
         Alternatively, if you are the root user, you can run:
         
           export KUBECONFIG=/etc/kubernetes/admin.conf
         
         You should now deploy a pod network to the cluster.
         Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
           https://kubernetes.io/docs/concepts/cluster-administration/addons/
         
         Then you can join any number of worker nodes by running the following on each as root:
         
         kubeadm join 10.10.10.32:6443 --token eyn7vn.jxlqmrxi6d01ax55 \
         	--discovery-token-ca-cert-hash sha256:43a15a8426e7decb076cec908a77b5c5b81de76e108773d66dea58e9430d8248 
         ubuntu@k8s-node01:~$ mkdir .kube && sudo cp /etc/kubernetes/admin.conf ~/.kube/config && sudo chown -R ubuntu: .kube/
         ubuntu@k8s-node01:~$ kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
         namespace/kube-flannel created
         clusterrole.rbac.authorization.k8s.io/flannel created
         clusterrolebinding.rbac.authorization.k8s.io/flannel created
         serviceaccount/flannel created
         configmap/kube-flannel-cfg created
         daemonset.apps/kube-flannel-ds created
         ```
      </details>
4. Подключаем воркер ноды:
    * Команда:
      ```bash
      sudo kubeadm join 10.10.10.32:6443 --token eyn7vn.jxlqmrxi6d01ax55 --discovery-token-ca-cert-hash sha256:43a15a8426e7decb076cec908a77b5c5b81de76e108773d66dea58e9430d8248 
      ```
      <details>
         <summary>Лог выполнения команды на воркерах</summary>
      
         ```bash
         ubuntu@k8s-node02:~$ sudo kubeadm join 10.10.10.32:6443 --token eyn7vn.jxlqmrxi6d01ax55 --discovery-token-ca-cert-hash sha256:43a15a8426e7decb076cec908a77b5c5b81de76e108773d66dea58e9430d8248 
         [preflight] Running pre-flight checks
         [preflight] Reading configuration from the cluster...
         [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
         [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
         [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
         [kubelet-start] Starting the kubelet
         [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
         
         This node has joined the cluster:
         * Certificate signing request was sent to apiserver and a response was received.
         * The Kubelet was informed of the new secure connection details.
         
         Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
         
         ubuntu@k8s-node03:~$ sudo kubeadm join 10.10.10.32:6443 --token eyn7vn.jxlqmrxi6d01ax55 --discovery-token-ca-cert-hash sha256:43a15a8426e7decb076cec908a77b5c5b81de76e108773d66dea58e9430d8248 
         [preflight] Running pre-flight checks
         [preflight] Reading configuration from the cluster...
         [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
         [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
         [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
         [kubelet-start] Starting the kubelet
         [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
         
         This node has joined the cluster:
         * Certificate signing request was sent to apiserver and a response was received.
         * The Kubelet was informed of the new secure connection details.
         
         Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
         
         ubuntu@k8s-node04:~$ sudo kubeadm join 10.10.10.32:6443 --token eyn7vn.jxlqmrxi6d01ax55 --discovery-token-ca-cert-hash sha256:43a15a8426e7decb076cec908a77b5c5b81de76e108773d66dea58e9430d8248 
         [preflight] Running pre-flight checks
         [preflight] Reading configuration from the cluster...
         [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
         [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
         [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
         [kubelet-start] Starting the kubelet
         [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
         
         This node has joined the cluster:
         * Certificate signing request was sent to apiserver and a response was received.
         * The Kubelet was informed of the new secure connection details.
         
         Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
         
         ubuntu@k8s-node05:~$ sudo kubeadm join 10.10.10.32:6443 --token eyn7vn.jxlqmrxi6d01ax55 --discovery-token-ca-cert-hash sha256:43a15a8426e7decb076cec908a77b5c5b81de76e108773d66dea58e9430d8248 
         [preflight] Running pre-flight checks
         [preflight] Reading configuration from the cluster...
         [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
         [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
         [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
         [kubelet-start] Starting the kubelet
         [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
         
         This node has joined the cluster:
         * Certificate signing request was sent to apiserver and a response was received.
         * The Kubelet was informed of the new secure connection details.
         
         Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
         ```
      </details>
5. Проверяем состояние кластера:
    ```bash
    ubuntu@k8s-node01:~$ kubectl get nodes
    NAME         STATUS   ROLES           AGE    VERSION
    k8s-node01   Ready    control-plane   103s   v1.28.2
    k8s-node02   Ready    <none>          27s    v1.28.2
    k8s-node03   Ready    <none>          23s    v1.28.2
    k8s-node04   Ready    <none>          22s    v1.28.2
    k8s-node05   Ready    <none>          18s    v1.28.2
    ubuntu@k8s-node01:~$ kubectl get pods --all-namespaces 
    NAMESPACE      NAME                                 READY   STATUS    RESTARTS   AGE
    kube-flannel   kube-flannel-ds-bwfz2                1/1     Running   0          29s
    kube-flannel   kube-flannel-ds-hm845                1/1     Running   0          32s
    kube-flannel   kube-flannel-ds-k9k6k                1/1     Running   0          28s
    kube-flannel   kube-flannel-ds-n7kkf                1/1     Running   0          91s
    kube-flannel   kube-flannel-ds-zhh2l                1/1     Running   0          24s
    kube-system    coredns-5dd5756b68-2qpz2             1/1     Running   0          91s
    kube-system    coredns-5dd5756b68-5v76q             1/1     Running   0          91s
    kube-system    etcd-k8s-node01                      1/1     Running   4          104s
    kube-system    kube-apiserver-k8s-node01            1/1     Running   4          104s
    kube-system    kube-controller-manager-k8s-node01   1/1     Running   1          104s
    kube-system    kube-proxy-b5bsm                     1/1     Running   0          29s
    kube-system    kube-proxy-bxfbg                     1/1     Running   0          32s
    kube-system    kube-proxy-h5dfd                     1/1     Running   0          28s
    kube-system    kube-proxy-hp24x                     1/1     Running   0          24s
    kube-system    kube-proxy-mm6ks                     1/1     Running   0          92s
    kube-system    kube-scheduler-k8s-node01            1/1     Running   4          104s
    ```

## Задание 2. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

## Результат

Поскольку Yandex Cloud в связи с тех. реализацией сети не позволяет использовать пакет `keepalived` (если точнее, протоколы второго уровня, такие как `VRRP`), кластер был развернут локально.
Развертка k8s выполнялась через `kubespray`.

1. Разворчиваем сервера с помощью [vagrant](./vagrant/).
    <details>
      <summary>Лог vagrant</summary>
    
      ```bash
      Bringing machine 'k8s-master01' up with 'virtualbox' provider...
      Bringing machine 'k8s-master02' up with 'virtualbox' provider...
      Bringing machine 'k8s-master03' up with 'virtualbox' provider...
      Bringing machine 'k8s-worker01' up with 'virtualbox' provider...
      Bringing machine 'k8s-worker02' up with 'virtualbox' provider...
      ==> k8s-master01: Importing base box 'ubuntu/focal64'...
      ==> k8s-master01: Matching MAC address for NAT networking...
      ==> k8s-master01: Checking if box 'ubuntu/focal64' version '1.0.0' is up to date...
      ==> k8s-master01: Setting the name of the VM: vagrant_k8s-master01_1707546470048_19688
      ==> k8s-master01: Clearing any previously set network interfaces...
      ==> k8s-master01: Preparing network interfaces based on configuration...
          k8s-master01: Adapter 1: nat
          k8s-master01: Adapter 2: bridged
      ==> k8s-master01: Forwarding ports...
          k8s-master01: 22 (guest) => 2222 (host) (adapter 1)
      ==> k8s-master01: Running 'pre-boot' VM customizations...
      ==> k8s-master01: Booting VM...
      ==> k8s-master01: Waiting for machine to boot. This may take a few minutes...
          k8s-master01: SSH address: 127.0.0.1:2222
          k8s-master01: SSH username: vagrant
          k8s-master01: SSH auth method: private key
          k8s-master01: Warning: Connection reset. Retrying...
          k8s-master01: Warning: Remote connection disconnect. Retrying...
          k8s-master01: Warning: Connection aborted. Retrying...
          k8s-master01: 
          k8s-master01: Vagrant insecure key detected. Vagrant will automatically replace
          k8s-master01: this with a newly generated keypair for better security.
          k8s-master01: 
          k8s-master01: Inserting generated public key within guest...
          k8s-master01: Removing insecure key from the guest if it's present...
          k8s-master01: Key inserted! Disconnecting and reconnecting using new SSH key...
      ==> k8s-master01: Machine booted and ready!
      ==> k8s-master01: Checking for guest additions in VM...
          k8s-master01: The guest additions on this VM do not match the installed version of
          k8s-master01: VirtualBox! In most cases this is fine, but in rare cases it can
          k8s-master01: prevent things such as shared folders from working properly. If you see
          k8s-master01: shared folder errors, please make sure the guest additions within the
          k8s-master01: virtual machine match the version of VirtualBox you have installed on
          k8s-master01: your host and reload your VM.
          k8s-master01: 
          k8s-master01: Guest Additions Version: 6.1.38
          k8s-master01: VirtualBox Version: 7.0
      ==> k8s-master01: Setting hostname...
      ==> k8s-master01: Configuring and enabling network interfaces...
      ==> k8s-master01: Mounting shared folders...
          k8s-master01: /vagrant => C:/Users/user/Desktop/k8s/vagrant
      ==> k8s-master01: Running provisioner: shell...
          k8s-master01: Running: inline script
      ==> k8s-master02: Importing base box 'ubuntu/focal64'...
      ==> k8s-master02: Matching MAC address for NAT networking...
      ==> k8s-master02: Checking if box 'ubuntu/focal64' version '1.0.0' is up to date...
      ==> k8s-master02: Setting the name of the VM: vagrant_k8s-master02_1707546578113_94645
      ==> k8s-master02: Fixed port collision for 22 => 2222. Now on port 2200.
      ==> k8s-master02: Clearing any previously set network interfaces...
      ==> k8s-master02: Preparing network interfaces based on configuration...
          k8s-master02: Adapter 1: nat
          k8s-master02: Adapter 2: bridged
      ==> k8s-master02: Forwarding ports...
          k8s-master02: 22 (guest) => 2200 (host) (adapter 1)
      ==> k8s-master02: Running 'pre-boot' VM customizations...
      ==> k8s-master02: Booting VM...
      ==> k8s-master02: Waiting for machine to boot. This may take a few minutes...
          k8s-master02: SSH address: 127.0.0.1:2200
          k8s-master02: SSH username: vagrant
          k8s-master02: SSH auth method: private key
          k8s-master02: Warning: Connection reset. Retrying...
          k8s-master02: Warning: Remote connection disconnect. Retrying...
          k8s-master02: Warning: Connection aborted. Retrying...
          k8s-master02: 
          k8s-master02: Vagrant insecure key detected. Vagrant will automatically replace
          k8s-master02: this with a newly generated keypair for better security.
          k8s-master02: 
          k8s-master02: Inserting generated public key within guest...
          k8s-master02: Removing insecure key from the guest if it's present...
          k8s-master02: Key inserted! Disconnecting and reconnecting using new SSH key...
      ==> k8s-master02: Machine booted and ready!
      ==> k8s-master02: Checking for guest additions in VM...
          k8s-master02: The guest additions on this VM do not match the installed version of
          k8s-master02: VirtualBox! In most cases this is fine, but in rare cases it can
          k8s-master02: prevent things such as shared folders from working properly. If you see
          k8s-master02: shared folder errors, please make sure the guest additions within the
          k8s-master02: virtual machine match the version of VirtualBox you have installed on
          k8s-master02: your host and reload your VM.
          k8s-master02: 
          k8s-master02: Guest Additions Version: 6.1.38
          k8s-master02: VirtualBox Version: 7.0
      ==> k8s-master02: Setting hostname...
      ==> k8s-master02: Configuring and enabling network interfaces...
      ==> k8s-master02: Mounting shared folders...
          k8s-master02: /vagrant => C:/Users/user/Desktop/k8s/vagrant
      ==> k8s-master02: Running provisioner: shell...
          k8s-master02: Running: inline script
      ==> k8s-master03: Importing base box 'ubuntu/focal64'...
      ==> k8s-master03: Matching MAC address for NAT networking...
      ==> k8s-master03: Checking if box 'ubuntu/focal64' version '1.0.0' is up to date...
      ==> k8s-master03: Setting the name of the VM: vagrant_k8s-master03_1707546687349_9072
      ==> k8s-master03: Fixed port collision for 22 => 2222. Now on port 2201.
      ==> k8s-master03: Clearing any previously set network interfaces...
      ==> k8s-master03: Preparing network interfaces based on configuration...
          k8s-master03: Adapter 1: nat
          k8s-master03: Adapter 2: bridged
      ==> k8s-master03: Forwarding ports...
          k8s-master03: 22 (guest) => 2201 (host) (adapter 1)
      ==> k8s-master03: Running 'pre-boot' VM customizations...
      ==> k8s-master03: Booting VM...
      ==> k8s-master03: Waiting for machine to boot. This may take a few minutes...
          k8s-master03: SSH address: 127.0.0.1:2201
          k8s-master03: SSH username: vagrant
          k8s-master03: SSH auth method: private key
          k8s-master03: Warning: Connection reset. Retrying...
          k8s-master03: Warning: Remote connection disconnect. Retrying...
          k8s-master03: Warning: Connection aborted. Retrying...
          k8s-master03: 
          k8s-master03: Vagrant insecure key detected. Vagrant will automatically replace
          k8s-master03: this with a newly generated keypair for better security.
          k8s-master03: 
          k8s-master03: Inserting generated public key within guest...
          k8s-master03: Removing insecure key from the guest if it's present...
          k8s-master03: Key inserted! Disconnecting and reconnecting using new SSH key...
      ==> k8s-master03: Machine booted and ready!
      ==> k8s-master03: Checking for guest additions in VM...
          k8s-master03: The guest additions on this VM do not match the installed version of
          k8s-master03: VirtualBox! In most cases this is fine, but in rare cases it can
          k8s-master03: prevent things such as shared folders from working properly. If you see
          k8s-master03: shared folder errors, please make sure the guest additions within the
          k8s-master03: virtual machine match the version of VirtualBox you have installed on
          k8s-master03: your host and reload your VM.
          k8s-master03: 
          k8s-master03: Guest Additions Version: 6.1.38
          k8s-master03: VirtualBox Version: 7.0
      ==> k8s-master03: Setting hostname...
      ==> k8s-master03: Configuring and enabling network interfaces...
      ==> k8s-master03: Mounting shared folders...
          k8s-master03: /vagrant => C:/Users/user/Desktop/k8s/vagrant
      ==> k8s-master03: Running provisioner: shell...
          k8s-master03: Running: inline script
      ==> k8s-worker01: Importing base box 'ubuntu/focal64'...
      ==> k8s-worker01: Matching MAC address for NAT networking...
      ==> k8s-worker01: Checking if box 'ubuntu/focal64' version '1.0.0' is up to date...
      ==> k8s-worker01: Setting the name of the VM: vagrant_k8s-worker01_1707546799690_21250
      ==> k8s-worker01: Fixed port collision for 22 => 2222. Now on port 2202.
      ==> k8s-worker01: Clearing any previously set network interfaces...
      ==> k8s-worker01: Preparing network interfaces based on configuration...
          k8s-worker01: Adapter 1: nat
          k8s-worker01: Adapter 2: bridged
      ==> k8s-worker01: Forwarding ports...
          k8s-worker01: 22 (guest) => 2202 (host) (adapter 1)
      ==> k8s-worker01: Running 'pre-boot' VM customizations...
      ==> k8s-worker01: Booting VM...
      ==> k8s-worker01: Waiting for machine to boot. This may take a few minutes...
          k8s-worker01: SSH address: 127.0.0.1:2202
          k8s-worker01: SSH username: vagrant
          k8s-worker01: SSH auth method: private key
          k8s-worker01: Warning: Connection reset. Retrying...
          k8s-worker01: Warning: Remote connection disconnect. Retrying...
          k8s-worker01: Warning: Connection aborted. Retrying...
          k8s-worker01: 
          k8s-worker01: Vagrant insecure key detected. Vagrant will automatically replace
          k8s-worker01: this with a newly generated keypair for better security.
          k8s-worker01: 
          k8s-worker01: Inserting generated public key within guest...
          k8s-worker01: Removing insecure key from the guest if it's present...
          k8s-worker01: Key inserted! Disconnecting and reconnecting using new SSH key...
      ==> k8s-worker01: Machine booted and ready!
      ==> k8s-worker01: Checking for guest additions in VM...
          k8s-worker01: The guest additions on this VM do not match the installed version of
          k8s-worker01: VirtualBox! In most cases this is fine, but in rare cases it can
          k8s-worker01: prevent things such as shared folders from working properly. If you see
          k8s-worker01: shared folder errors, please make sure the guest additions within the
          k8s-worker01: virtual machine match the version of VirtualBox you have installed on
          k8s-worker01: your host and reload your VM.
          k8s-worker01: 
          k8s-worker01: Guest Additions Version: 6.1.38
          k8s-worker01: VirtualBox Version: 7.0
      ==> k8s-worker01: Setting hostname...
      ==> k8s-worker01: Configuring and enabling network interfaces...
      ==> k8s-worker01: Mounting shared folders...
          k8s-worker01: /vagrant => C:/Users/user/Desktop/k8s/vagrant
      ==> k8s-worker01: Running provisioner: shell...
          k8s-worker01: Running: inline script
      ==> k8s-worker02: Importing base box 'ubuntu/focal64'...
      ==> k8s-worker02: Matching MAC address for NAT networking...
      ==> k8s-worker02: Checking if box 'ubuntu/focal64' version '1.0.0' is up to date...
      ==> k8s-worker02: Setting the name of the VM: vagrant_k8s-worker02_1707546905654_15745
      ==> k8s-worker02: Fixed port collision for 22 => 2222. Now on port 2203.
      ==> k8s-worker02: Clearing any previously set network interfaces...
      ==> k8s-worker02: Preparing network interfaces based on configuration...
          k8s-worker02: Adapter 1: nat
          k8s-worker02: Adapter 2: bridged
      ==> k8s-worker02: Forwarding ports...
          k8s-worker02: 22 (guest) => 2203 (host) (adapter 1)
      ==> k8s-worker02: Running 'pre-boot' VM customizations...
      ==> k8s-worker02: Booting VM...
      ==> k8s-worker02: Waiting for machine to boot. This may take a few minutes...
          k8s-worker02: SSH address: 127.0.0.1:2203
          k8s-worker02: SSH username: vagrant
          k8s-worker02: SSH auth method: private key
          k8s-worker02: Warning: Connection reset. Retrying...
          k8s-worker02: Warning: Remote connection disconnect. Retrying...
          k8s-worker02: Warning: Connection aborted. Retrying...
          k8s-worker02: 
          k8s-worker02: Vagrant insecure key detected. Vagrant will automatically replace
          k8s-worker02: this with a newly generated keypair for better security.
          k8s-worker02: 
          k8s-worker02: Inserting generated public key within guest...
          k8s-worker02: Removing insecure key from the guest if it's present...
          k8s-worker02: Key inserted! Disconnecting and reconnecting using new SSH key...
      ==> k8s-worker02: Machine booted and ready!
      ==> k8s-worker02: Checking for guest additions in VM...
          k8s-worker02: The guest additions on this VM do not match the installed version of
          k8s-worker02: VirtualBox! In most cases this is fine, but in rare cases it can
          k8s-worker02: prevent things such as shared folders from working properly. If you see
          k8s-worker02: shared folder errors, please make sure the guest additions within the
          k8s-worker02: virtual machine match the version of VirtualBox you have installed on
          k8s-worker02: your host and reload your VM.
          k8s-worker02: 
          k8s-worker02: Guest Additions Version: 6.1.38
          k8s-worker02: VirtualBox Version: 7.0
      ==> k8s-worker02: Setting hostname...
      ==> k8s-worker02: Configuring and enabling network interfaces...
      ==> k8s-worker02: Mounting shared folders...
          k8s-worker02: /vagrant => C:/Users/user/Desktop/k8s/vagrant
      ==> k8s-worker02: Running provisioner: shell...
          k8s-worker02: Running: inline script
      ```
    </details>
2. Выполняем установку и настройку `haproxy` и `keepalived` (на мастер нодах):
    * Установка:
        ```bash
        sudo apt update && sudo apt upgrade -y
        sudo apt install haproxy keepalived -y
        ```
    * <details>
         <summary>Конфигурации keepalived</summary>
      
         ```bash
         # первая нода
         vrrp_script chk_haproxy {
           script "/usr/bin/killall -0 haproxy"
           interval 2
           weight 2
         }
         
         vrrp_instance VI_1 {
           interface enp0s8
           state MASTER
           advert_int 1
           virtual_router_id 10
           priority 101
           unicast_src_ip 192.168.0.124/24
           unicast_peer {
             192.168.0.125/24               # Node 2
             192.168.0.126/24               # Node 3
           }
           virtual_ipaddress {
             192.168.0.198/24               # VirtualIP
           }
           track_script {
             chk_haproxy
           }
         }

         # вторая нода
         vrrp_script chk_haproxy {
           script "/usr/bin/killall -0 haproxy"
           interval 2
           weight 2
         }
         
         vrrp_instance VI_1 {
           interface enp0s8
           state BACKUP
           advert_int 1
           virtual_router_id 10
           priority 100
           unicast_src_ip 192.168.0.125/24
           unicast_peer {
             192.168.0.124/24               # Node 1
             192.168.0.126/24               # Node 3
           }
           virtual_ipaddress {
             192.168.0.198/24               # VirtualIP
           }
           track_script {
             chk_haproxy
           }
         }

         # третья нода
         vrrp_script chk_haproxy {
           script "/usr/bin/killall -0 haproxy"
           interval 2
           weight 2
         }
         
         vrrp_instance VI_1 {
           interface enp0s8
           state BACKUP
           advert_int 1
           virtual_router_id 10
           priority 99
           unicast_src_ip 192.168.0.126/24
           unicast_peer {
             192.168.0.124/24               # Node 1
             192.168.0.125/24               # Node 2
           }
           virtual_ipaddress {
             192.168.0.198/24               # VirtualIP
           }
           track_script {
             chk_haproxy
           }
         }
         ```
      </details>
    * <details>
         <summary>Конфигурация haproxy</summary>
      
         ```bash
         # на всех нодах
         global
             log         127.0.0.1 local2
             chroot      /var/lib/haproxy
             pidfile     /var/run/haproxy.pid
             maxconn     4000
             user        haproxy
             group       haproxy
             daemon
             stats socket /var/lib/haproxy/stats
         
         defaults
             mode                    http
             log                     global
             option                  httplog
             option                  dontlognull
             option http-server-close
             option forwardfor       except 127.0.0.0/8
             option                  redispatch
             retries                 3
             timeout http-request    10s
             timeout queue           1m
             timeout connect         10s
             timeout client          1m
             timeout server          1m
             timeout http-keep-alive 10s
             timeout check           10s
             maxconn                 3000
         
         frontend apiserver
             bind *:8443
             mode tcp
             option tcplog
             default_backend apiserver
         
         backend apiserver
             option httpchk GET /healthz
             http-check expect status 200
             mode tcp
             option ssl-hello-chk
             balance     roundrobin
                 server k8s-node01 192.168.0.124:6443 check
                 server k8s-node02 192.168.0.125:6443 check
                 server k8s-node03 192.168.0.126:6443 check
         ```
      </details>
    * Запускаем службы:
      ```bash
      sudo systemctl enable --now keepalived
      sudo systemctl enable --now haproxy
      ```
3. Проверяем работу `keepakived`:
    * VirtualIP на первой ноде:
      ```bash
      vagrant@k8s-master01:~$ ip addr show enp0s8
      3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel       state UP group default qlen 1000
          link/ether 08:00:27:bf:0f:90 brd ff:ff:ff:ff:ff:ff
          inet 192.168.0.124/24 brd 192.168.0.255 scope global dynamic       enp0s8
             valid_lft 4596sec preferred_lft 4596sec
          inet 192.168.0.198/24 scope global secondary enp0s8
             valid_lft forever preferred_lft forever
          inet6 fe80::a00:27ff:febf:f90/64 scope link 
             valid_lft forever preferred_lft forever
      
      ```
    * Отключаем `HAProxy` и проверяем что адрес ушел на другую ноду:
      ```bash
      sudo systemctl stop haproxy
      vagrant@k8s-master01:~$ ip addr show enp0s8
      3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel       state UP group default qlen 1000
          link/ether 08:00:27:bf:0f:90 brd ff:ff:ff:ff:ff:ff
          inet 192.168.0.124/24 brd 192.168.0.255 scope global dynamic       enp0s8
             valid_lft 4524sec preferred_lft 4524sec
          inet6 fe80::a00:27ff:febf:f90/64 scope link 
             valid_lft forever preferred_lft forever
      
      # АДРЕС УСПЕШНО ПЕРЕЕХАЛ
      vagrant@k8s-master02:~$ ip addr show enp0s8
      3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel       state UP group default qlen 1000
          link/ether 08:00:27:81:29:6e brd ff:ff:ff:ff:ff:ff
          inet 192.168.0.125/24 brd 192.168.0.255 scope global dynamic       enp0s8
             valid_lft 4507sec preferred_lft 4507sec
          inet 192.168.0.198/24 scope global secondary enp0s8
             valid_lft forever preferred_lft forever
          inet6 fe80::a00:27ff:fe81:296e/64 scope link 
             valid_lft forever preferred_lft forever
      ```
    * Возвращаем все назад.
4. Клонируем репозиторий `kubespray` и устанавливаем зависимости из `requirements.txt`.
5. Генерируем инвентори:
    ```bash
    ~/kubespray/inventory$ cp -r sample mycluster
    declare -a IPS=(k8s-master01,192.168.0.124 k8s-master02,192.168.0.125 k8s-master03,192.168.0.126 k8s-worker01,192.168.0.127 k8s-worker02,192.168.0.128)
    ~/kubespray$ CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py "${IPS[@]}"
    DEBUG: Adding group all
    DEBUG: Adding group kube_control_plane
    DEBUG: Adding group kube_node
    DEBUG: Adding group etcd
    DEBUG: Adding group k8s_cluster
    DEBUG: Adding group calico_rr
    DEBUG: adding host k8s-master01 to group all
    DEBUG: adding host k8s-master02 to group all
    DEBUG: adding host k8s-master03 to group all
    DEBUG: adding host k8s-worker01 to group all
    DEBUG: adding host k8s-worker02 to group all
    DEBUG: adding host k8s-master01 to group etcd
    DEBUG: adding host k8s-master02 to group etcd
    DEBUG: adding host k8s-master03 to group etcd
    DEBUG: adding host k8s-master01 to group kube_control_plane
    DEBUG: adding host k8s-master02 to group kube_control_plane
    DEBUG: adding host k8s-master01 to group kube_node
    DEBUG: adding host k8s-master02 to group kube_node
    DEBUG: adding host k8s-master03 to group kube_node
    DEBUG: adding host k8s-worker01 to group kube_node
    DEBUG: adding host k8s-worker02 to group kube_node

    # и немного правим получившийся конфиг
    ```
6. Добавляем в `group_vars/all/all.yml` конфигурацию:
    ```yaml
    loadbalancer_apiserver:
       address: 192.168.0.198
       port: 8443
    loadbalancer_apiserver_localhost: false
    ```
7. Запускаем playbook ([очень большой лог](https://pastebin.com/7D9x7NJw)):
    ```bash
    ansible-playbook -i inventory/mycluster/hosts.yaml --become --user=vagrant --become-user=root cluster.yml
    ```
8. Проверяем состояние кластера:
    ```bash
    vagrant@k8s-master01:~$ kubectl cluster-info
    Kubernetes control plane is running at https://lb-apiserver.kubernetes.local:8443

    vagrant@k8s-master01:~$ ping lb-apiserver.kubernetes.local
    PING lb-apiserver.kubernetes.local (192.168.0.198) 56(84) bytes of data.
    64 bytes from lb-apiserver.kubernetes.local (192.168.0.198): icmp_seq=1 ttl=64 time=0.123 ms
    64 bytes from lb-apiserver.kubernetes.local (192.168.0.198): icmp_seq=2 ttl=64 time=0.109 ms

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    vagrant@k8s-master01:~$ kubectl get nodes -o wide
    NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
    k8s-master01   Ready    control-plane   18m   v1.29.1   192.168.0.124   <none>        Ubuntu 20.04.6 LTS   5.4.0-148-generic   containerd://1.7.13
    k8s-master02   Ready    control-plane   18m   v1.29.1   192.168.0.125   <none>        Ubuntu 20.04.6 LTS   5.4.0-148-generic   containerd://1.7.13
    k8s-master03   Ready    control-plane   18m   v1.29.1   192.168.0.126   <none>        Ubuntu 20.04.6 LTS   5.4.0-148-generic   containerd://1.7.13
    k8s-worker01   Ready    <none>          15m   v1.29.1   192.168.0.127   <none>        Ubuntu 20.04.6 LTS   5.4.0-148-generic   containerd://1.7.13
    k8s-worker02   Ready    <none>          15m   v1.29.1   192.168.0.128   <none>        Ubuntu 20.04.6 LTS   5.4.0-148-generic   containerd://1.7.13
    
    vagrant@k8s-master01:~$ kubectl get pods -o wide --all-namespaces
    NAMESPACE     NAME                                      READY   STATUS    RESTARTS        AGE     IP              NODE           NOMINATED NODE   READINESS GATES
    kube-system   calico-kube-controllers-648dffd99-d8kx2   1/1     Running   0               8m11s   10.233.79.65    k8s-worker01   <none>           <none>
    kube-system   calico-node-fn8sr                         1/1     Running   0               13m     192.168.0.128   k8s-worker02   <none>           <none>
    kube-system   calico-node-jvsgr                         1/1     Running   0               13m     192.168.0.127   k8s-worker01   <none>           <none>
    kube-system   calico-node-q7rsq                         1/1     Running   0               13m     192.168.0.125   k8s-master02   <none>           <none>
    kube-system   calico-node-vjp8r                         1/1     Running   0               13m     192.168.0.124   k8s-master01   <none>           <none>
    kube-system   calico-node-vtsbk                         1/1     Running   0               13m     192.168.0.126   k8s-master03   <none>           <none>
    kube-system   coredns-69db55dd76-7cl5h                  1/1     Running   0               7m18s   10.233.96.129   k8s-master01   <none>           <none>
    kube-system   coredns-69db55dd76-cq6bq                  1/1     Running   0               7m46s   10.233.69.1     k8s-master03   <none>           <none>
    kube-system   dns-autoscaler-6f4b597d8c-b57g7           1/1     Running   0               7m34s   10.233.87.65    k8s-master02   <none>           <none>
    kube-system   kube-apiserver-k8s-master01               1/1     Running   4               19m     192.168.0.124   k8s-master01   <none>           <none>
    kube-system   kube-apiserver-k8s-master02               1/1     Running   3               19m     192.168.0.125   k8s-master02   <none>           <none>
    kube-system   kube-apiserver-k8s-master03               1/1     Running   2               18m     192.168.0.126   k8s-master03   <none>           <none>
    kube-system   kube-controller-manager-k8s-master01      1/1     Running   4               19m     192.168.0.124   k8s-master01   <none>           <none>
    kube-system   kube-controller-manager-k8s-master02      1/1     Running   4               19m     192.168.0.125   k8s-master02   <none>           <none>
    kube-system   kube-controller-manager-k8s-master03      1/1     Running   6               18m     192.168.0.126   k8s-master03   <none>           <none>
    kube-system   kube-proxy-59zvp                          1/1     Running   0               15m     192.168.0.128   k8s-worker02   <none>           <none>
    kube-system   kube-proxy-cnt7c                          1/1     Running   0               15m     192.168.0.124   k8s-master01   <none>           <none>
    kube-system   kube-proxy-lkwqb                          1/1     Running   0               15m     192.168.0.127   k8s-worker01   <none>           <none>
    kube-system   kube-proxy-t4bnf                          1/1     Running   0               15m     192.168.0.125   k8s-master02   <none>           <none>
    kube-system   kube-proxy-tkz96                          1/1     Running   0               15m     192.168.0.126   k8s-master03   <none>           <none>
    kube-system   kube-scheduler-k8s-master01               1/1     Running   4 (5m55s ago)   19m     192.168.0.124   k8s-master01   <none>           <none>
    kube-system   kube-scheduler-k8s-master02               1/1     Running   4 (9m52s ago)   19m     192.168.0.125   k8s-master02   <none>           <none>
    kube-system   kube-scheduler-k8s-master03               1/1     Running   2               18m     192.168.0.126   k8s-master03   <none>           <none>
    kube-system   nodelocaldns-5bh5z                        1/1     Running   0               7m30s   192.168.0.125   k8s-master02   <none>           <none>
    kube-system   nodelocaldns-5wtmw                        1/1     Running   0               7m30s   192.168.0.124   k8s-master01   <none>           <none>
    kube-system   nodelocaldns-6dnx6                        1/1     Running   0               7m30s   192.168.0.126   k8s-master03   <none>           <none>
    kube-system   nodelocaldns-f8srr                        1/1     Running   0               7m30s   192.168.0.128   k8s-worker02   <none>           <none>
    kube-system   nodelocaldns-gj2vl                        1/1     Running   0               7m30s   192.168.0.127   k8s-worker01   <none>           <none>
    ```