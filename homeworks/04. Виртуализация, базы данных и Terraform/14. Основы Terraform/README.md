# Домашнее задание по теме: "Основы Terraform"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

**Результат:**

#### AWS:

```bash
>aws s3api list-buckets
{
    "Buckets": [
        {
            "Name": "manokhin-terraform",
            "CreationDate": "2023-01-08T19:18:46.000Z"
        }
    ],
    "Owner": {
        "ID": "104499c50ed09e4bb8c3aa1b5ad6fd12d2a5dcc0d2d7395802a4ac8349722ac9"
    }
}
```

```bash
>terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/aws versions matching "4.49.0"...
- Installing hashicorp/aws v4.49.0...
- Installed hashicorp/aws v4.49.0 (signed by HashiCorp)
...
Terraform has been successfully initialized!
```

#### Yandex.Cloud:

```bash
>yc storage bucket list 
+--------------------+----------------------+------------+-----------------------+---------------------+
|        NAME        |      FOLDER ID       |  MAX SIZE  | DEFAULT STORAGE CLASS |     CREATED AT      |
+--------------------+----------------------+------------+-----------------------+---------------------+
| manokhin-terraform | b1g51tksi3aq7j9inm1k | 1073741824 | STANDARD              | 2023-01-08 16:26:17 |
+--------------------+----------------------+------------+-----------------------+---------------------+
```

```bash
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching "0.84.0"...
- Installing yandex-cloud/yandex v0.84.0...
- Installed yandex-cloud/yandex v0.84.0 (self-signed, key ID E40F590B50BB8E40)
...
Terraform has been successfully initialized!
```

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

**Результат:**

#### [AWS](./AWS/terraform/):

```bash
>terraform workspace list
* default
  prod
  stage
```

<details>
  <summary>terraform plan (раскрыть)</summary>

  ```bash
  >terraform plan
  data.aws_caller_identity.current: Reading...
  data.aws_region.current: Reading...
  data.aws_ami.amazon-linux: Reading...
  data.aws_ami.ubuntu: Reading...
  data.aws_region.current: Read complete after 0s [id=eu-north-1]
  data.aws_ami.amazon-linux: Read complete after 1s [id=ami-073721f7dee4fb47c]
  data.aws_ami.ubuntu: Read complete after 1s [id=ami-09f8f28c19052e51f]
  data.aws_caller_identity.current: Read complete after 1s [id=745585637980]
  
  Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # aws_eip.amazon_linux_instance_eip["0"] will be created
    + resource "aws_eip" "amazon_linux_instance_eip" {
        + allocation_id        = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + tags_all             = (known after apply)
        + vpc                  = true
      }
  
    # aws_eip.amazon_linux_instance_eip["1"] will be created
    + resource "aws_eip" "amazon_linux_instance_eip" {
        + allocation_id        = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + tags_all             = (known after apply)
        + vpc                  = true
      }
  
    # aws_eip.ubuntu_instance_eip[0] will be created
    + resource "aws_eip" "ubuntu_instance_eip" {
        + allocation_id        = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + tags_all             = (known after apply)
        + vpc                  = true
      }
  
    # aws_eip.ubuntu_instance_eip[1] will be created
    + resource "aws_eip" "ubuntu_instance_eip" {
        + allocation_id        = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + tags_all             = (known after apply)
        + vpc                  = true
      }
  
    # aws_instance.amazon_linux_instance["0"] will be created
    + resource "aws_instance" "amazon_linux_instance" {
        + ami                                  = "ami-073721f7dee4fb47c"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
        + availability_zone                    = (known after apply)
        + cpu_core_count                       = (known after apply)
        + cpu_threads_per_core                 = (known after apply)
        + disable_api_stop                     = (known after apply)
        + disable_api_termination              = (known after apply)
        + ebs_optimized                        = (known after apply)
        + get_password_data                    = false
        + host_id                              = (known after apply)
        + host_resource_group_arn              = (known after apply)
        + iam_instance_profile                 = (known after apply)
        + id                                   = (known after apply)
        + instance_initiated_shutdown_behavior = (known after apply)
        + instance_state                       = (known after apply)
        + instance_type                        = "t3.micro"
        + ipv6_address_count                   = (known after apply)
        + ipv6_addresses                       = (known after apply)
        + key_name                             = "ssh-key"
        + monitoring                           = (known after apply)
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        + placement_partition_number           = (known after apply)
        + primary_network_interface_id         = (known after apply)
        + private_dns                          = (known after apply)
        + private_ip                           = (known after apply)
        + public_dns                           = (known after apply)
        + public_ip                            = (known after apply)
        + secondary_private_ips                = (known after apply)
        + security_groups                      = (known after apply)
        + source_dest_check                    = true
        + subnet_id                            = (known after apply)
        + tags                                 = {
            + "Name" = "[prod]-amazon-linux-instance-0"
          }
        + tags_all                             = {
            + "Name" = "[prod]-amazon-linux-instance-0"
          }
        + tenancy                              = (known after apply)
        + user_data                            = (known after apply)
        + user_data_base64                     = (known after apply)
        + user_data_replace_on_change          = false
        + vpc_security_group_ids               = (known after apply)
  
        + capacity_reservation_specification {
            + capacity_reservation_preference = (known after apply)
  
            + capacity_reservation_target {
                + capacity_reservation_id                 = (known after apply)
                + capacity_reservation_resource_group_arn = (known after apply)
              }
          }
  
        + ebs_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + snapshot_id           = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
  
        + enclave_options {
            + enabled = (known after apply)
          }
  
        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
          }
  
        + maintenance_options {
            + auto_recovery = (known after apply)
          }
  
        + metadata_options {
            + http_endpoint               = (known after apply)
            + http_put_response_hop_limit = (known after apply)
            + http_tokens                 = (known after apply)
            + instance_metadata_tags      = (known after apply)
          }
  
        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_card_index    = (known after apply)
            + network_interface_id  = (known after apply)
          }
  
        + private_dns_name_options {
            + enable_resource_name_dns_a_record    = (known after apply)
            + enable_resource_name_dns_aaaa_record = (known after apply)
            + hostname_type                        = (known after apply)
          }
  
        + root_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
      }
  
    # aws_instance.amazon_linux_instance["1"] will be created
    + resource "aws_instance" "amazon_linux_instance" {
        + ami                                  = "ami-073721f7dee4fb47c"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
        + availability_zone                    = (known after apply)
        + cpu_core_count                       = (known after apply)
        + cpu_threads_per_core                 = (known after apply)
        + disable_api_stop                     = (known after apply)
        + disable_api_termination              = (known after apply)
        + ebs_optimized                        = (known after apply)
        + get_password_data                    = false
        + host_id                              = (known after apply)
        + host_resource_group_arn              = (known after apply)
        + iam_instance_profile                 = (known after apply)
        + id                                   = (known after apply)
        + instance_initiated_shutdown_behavior = (known after apply)
        + instance_state                       = (known after apply)
        + instance_type                        = "t3.micro"
        + ipv6_address_count                   = (known after apply)
        + ipv6_addresses                       = (known after apply)
        + key_name                             = "ssh-key"
        + monitoring                           = (known after apply)
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        + placement_partition_number           = (known after apply)
        + primary_network_interface_id         = (known after apply)
        + private_dns                          = (known after apply)
        + private_ip                           = (known after apply)
        + public_dns                           = (known after apply)
        + public_ip                            = (known after apply)
        + secondary_private_ips                = (known after apply)
        + security_groups                      = (known after apply)
        + source_dest_check                    = true
        + subnet_id                            = (known after apply)
        + tags                                 = {
            + "Name" = "[prod]-amazon-linux-instance-1"
          }
        + tags_all                             = {
            + "Name" = "[prod]-amazon-linux-instance-1"
          }
        + tenancy                              = (known after apply)
        + user_data                            = (known after apply)
        + user_data_base64                     = (known after apply)
        + user_data_replace_on_change          = false
        + vpc_security_group_ids               = (known after apply)
  
        + capacity_reservation_specification {
            + capacity_reservation_preference = (known after apply)
  
            + capacity_reservation_target {
                + capacity_reservation_id                 = (known after apply)
                + capacity_reservation_resource_group_arn = (known after apply)
              }
          }
  
        + ebs_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + snapshot_id           = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
  
        + enclave_options {
            + enabled = (known after apply)
          }
  
        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
          }
  
        + maintenance_options {
            + auto_recovery = (known after apply)
          }
  
        + metadata_options {
            + http_endpoint               = (known after apply)
            + http_put_response_hop_limit = (known after apply)
            + http_tokens                 = (known after apply)
            + instance_metadata_tags      = (known after apply)
          }
  
        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_card_index    = (known after apply)
            + network_interface_id  = (known after apply)
          }
  
        + private_dns_name_options {
            + enable_resource_name_dns_a_record    = (known after apply)
            + enable_resource_name_dns_aaaa_record = (known after apply)
            + hostname_type                        = (known after apply)
          }
  
        + root_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
      }
  
    # aws_instance.ubuntu_instance[0] will be created
    + resource "aws_instance" "ubuntu_instance" {
        + ami                                  = "ami-09f8f28c19052e51f"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
        + availability_zone                    = (known after apply)
        + cpu_core_count                       = (known after apply)
        + cpu_threads_per_core                 = (known after apply)
        + disable_api_stop                     = (known after apply)
        + disable_api_termination              = (known after apply)
        + ebs_optimized                        = (known after apply)
        + get_password_data                    = false
        + host_id                              = (known after apply)
        + host_resource_group_arn              = (known after apply)
        + iam_instance_profile                 = (known after apply)
        + id                                   = (known after apply)
        + instance_initiated_shutdown_behavior = (known after apply)
        + instance_state                       = (known after apply)
        + instance_type                        = "t3.micro"
        + ipv6_address_count                   = (known after apply)
        + ipv6_addresses                       = (known after apply)
        + key_name                             = "ssh-key"
        + monitoring                           = (known after apply)
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        + placement_partition_number           = (known after apply)
        + primary_network_interface_id         = (known after apply)
        + private_dns                          = (known after apply)
        + private_ip                           = (known after apply)
        + public_dns                           = (known after apply)
        + public_ip                            = (known after apply)
        + secondary_private_ips                = (known after apply)
        + security_groups                      = (known after apply)
        + source_dest_check                    = true
        + subnet_id                            = (known after apply)
        + tags                                 = {
            + "Name" = "[prod]-ubuntu-instance-0"
          }
        + tags_all                             = {
            + "Name" = "[prod]-ubuntu-instance-0"
          }
        + tenancy                              = (known after apply)
        + user_data                            = (known after apply)
        + user_data_base64                     = (known after apply)
        + user_data_replace_on_change          = false
        + vpc_security_group_ids               = (known after apply)
  
        + capacity_reservation_specification {
            + capacity_reservation_preference = (known after apply)
  
            + capacity_reservation_target {
                + capacity_reservation_id                 = (known after apply)
                + capacity_reservation_resource_group_arn = (known after apply)
              }
          }
  
        + ebs_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + snapshot_id           = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
  
        + enclave_options {
            + enabled = (known after apply)
          }
  
        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
          }
  
        + maintenance_options {
            + auto_recovery = (known after apply)
          }
  
        + metadata_options {
            + http_endpoint               = (known after apply)
            + http_put_response_hop_limit = (known after apply)
            + http_tokens                 = (known after apply)
            + instance_metadata_tags      = (known after apply)
          }
  
        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_card_index    = (known after apply)
            + network_interface_id  = (known after apply)
          }
  
        + private_dns_name_options {
            + enable_resource_name_dns_a_record    = (known after apply)
            + enable_resource_name_dns_aaaa_record = (known after apply)
            + hostname_type                        = (known after apply)
          }
  
        + root_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
      }
  
    # aws_instance.ubuntu_instance[1] will be created
    + resource "aws_instance" "ubuntu_instance" {
        + ami                                  = "ami-09f8f28c19052e51f"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
        + availability_zone                    = (known after apply)
        + cpu_core_count                       = (known after apply)
        + cpu_threads_per_core                 = (known after apply)
        + disable_api_stop                     = (known after apply)
        + disable_api_termination              = (known after apply)
        + ebs_optimized                        = (known after apply)
        + get_password_data                    = false
        + host_id                              = (known after apply)
        + host_resource_group_arn              = (known after apply)
        + iam_instance_profile                 = (known after apply)
        + id                                   = (known after apply)
        + instance_initiated_shutdown_behavior = (known after apply)
        + instance_state                       = (known after apply)
        + instance_type                        = "t3.micro"
        + ipv6_address_count                   = (known after apply)
        + ipv6_addresses                       = (known after apply)
        + key_name                             = "ssh-key"
        + monitoring                           = (known after apply)
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        + placement_partition_number           = (known after apply)
        + primary_network_interface_id         = (known after apply)
        + private_dns                          = (known after apply)
        + private_ip                           = (known after apply)
        + public_dns                           = (known after apply)
        + public_ip                            = (known after apply)
        + secondary_private_ips                = (known after apply)
        + security_groups                      = (known after apply)
        + source_dest_check                    = true
        + subnet_id                            = (known after apply)
        + tags                                 = {
            + "Name" = "[prod]-ubuntu-instance-1"
          }
        + tags_all                             = {
            + "Name" = "[prod]-ubuntu-instance-1"
          }
        + tenancy                              = (known after apply)
        + user_data                            = (known after apply)
        + user_data_base64                     = (known after apply)
        + user_data_replace_on_change          = false
        + vpc_security_group_ids               = (known after apply)
  
        + capacity_reservation_specification {
            + capacity_reservation_preference = (known after apply)
  
            + capacity_reservation_target {
                + capacity_reservation_id                 = (known after apply)
                + capacity_reservation_resource_group_arn = (known after apply)
              }
          }
  
        + ebs_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + snapshot_id           = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
  
        + enclave_options {
            + enabled = (known after apply)
          }
  
        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
          }
  
        + maintenance_options {
            + auto_recovery = (known after apply)
          }
  
        + metadata_options {
            + http_endpoint               = (known after apply)
            + http_put_response_hop_limit = (known after apply)
            + http_tokens                 = (known after apply)
            + instance_metadata_tags      = (known after apply)
          }
  
        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_card_index    = (known after apply)
            + network_interface_id  = (known after apply)
          }
  
        + private_dns_name_options {
            + enable_resource_name_dns_a_record    = (known after apply)
            + enable_resource_name_dns_aaaa_record = (known after apply)
            + hostname_type                        = (known after apply)
          }
  
        + root_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
          }
      }
  
    # aws_internet_gateway.gw will be created
    + resource "aws_internet_gateway" "gw" {
        + arn      = (known after apply)
        + id       = (known after apply)
        + owner_id = (known after apply)
        + tags_all = (known after apply)
        + vpc_id   = (known after apply)
      }
  
    # aws_route_table.route-table will be created
    + resource "aws_route_table" "route-table" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + route            = [
            + {
                + carrier_gateway_id         = ""
                + cidr_block                 = "0.0.0.0/0"
                + core_network_arn           = ""
                + destination_prefix_list_id = ""
                + egress_only_gateway_id     = ""
                + gateway_id                 = (known after apply)
                + instance_id                = ""
                + ipv6_cidr_block            = ""
                + local_gateway_id           = ""
                + nat_gateway_id             = ""
                + network_interface_id       = ""
                + transit_gateway_id         = ""
                + vpc_endpoint_id            = ""
                + vpc_peering_connection_id  = ""
              },
          ]
        + tags_all         = (known after apply)
        + vpc_id           = (known after apply)
      }
  
    # aws_route_table_association.subnet-association will be created
    + resource "aws_route_table_association" "subnet-association" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
      }
  
    # aws_security_group.security_group will be created
    + resource "aws_security_group" "security_group" {
        + arn                    = (known after apply)
        + description            = "Managed by Terraform"
        + egress                 = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = ""
                + from_port        = 0
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "-1"
                + security_groups  = []
                + self             = false
                + to_port          = 0
              },
          ]
        + id                     = (known after apply)
        + ingress                = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = ""
                + from_port        = 22
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 22
              },
          ]
        + name                   = "allow-all-sg"
        + name_prefix            = (known after apply)
        + owner_id               = (known after apply)
        + revoke_rules_on_delete = false
        + tags_all               = (known after apply)
        + vpc_id                 = (known after apply)
      }
  
    # aws_subnet.subnet will be created
    + resource "aws_subnet" "subnet" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = (known after apply)
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.10.10.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + tags                                           = {
            + "Name" = "main-subnet"
          }
        + tags_all                                       = {
            + "Name" = "main-subnet"
          }
        + vpc_id                                         = (known after apply)
      }
  
    # aws_vpc.vpc will be created
    + resource "aws_vpc" "vpc" {
        + arn                                  = (known after apply)
        + cidr_block                           = "10.10.0.0/16"
        + default_network_acl_id               = (known after apply)
        + default_route_table_id               = (known after apply)
        + default_security_group_id            = (known after apply)
        + dhcp_options_id                      = (known after apply)
        + enable_classiclink                   = (known after apply)
        + enable_classiclink_dns_support       = (known after apply)
        + enable_dns_hostnames                 = true
        + enable_dns_support                   = true
        + enable_network_address_usage_metrics = (known after apply)
        + id                                   = (known after apply)
        + instance_tenancy                     = "default"
        + ipv6_association_id                  = (known after apply)
        + ipv6_cidr_block                      = (known after apply)
        + ipv6_cidr_block_network_border_group = (known after apply)
        + main_route_table_id                  = (known after apply)
        + owner_id                             = (known after apply)
        + tags                                 = {
            + "Name" = "main-vpc"
          }
        + tags_all                             = {
            + "Name" = "main-vpc"
          }
      }
  
  Plan: 14 to add, 0 to change, 0 to destroy.
  
  Changes to Outputs:
    + account_id                       = "7455********"
    + amazon_linux_instance_private_ip = [
        + (known after apply),
        + (known after apply),
      ]
    + amazon_linux_instance_public_dns = [
        + (known after apply),
        + (known after apply),
      ]
    + amazon_linux_instance_public_ip  = [
        + (known after apply),
        + (known after apply),
      ]
    + caller_user                      = "AIDA2****************"
    + region_name                      = "eu-north-1"
    + ubuntu_instance_private_ip       = [
        + (known after apply),
        + (known after apply),
      ]
    + ubuntu_instance_public_dns       = [
        + (known after apply),
        + (known after apply),
      ]
    + ubuntu_instance_public_ip        = [
        + (known after apply),
        + (known after apply),
      ]
  
  ─────────────────────────────────────────────────────────────────────────
  
  Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
  ```
</details>

---

#### [Yandex.Cloud](./Yandex.Cloud/terraform/):

```bash
>terraform workspace list
* default
  prod
  stage
```

<details>
  <summary>terraform plan (раскрыть)</summary>

  ```bash
  >terraform plan
  data.yandex_compute_image.centos: Reading...
  data.yandex_compute_image.ubuntu: Reading...
  data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8ueg1g3ifoelgdaqhb]
  data.yandex_compute_image.centos: Read complete after 1s [id=fd875rkc8fbq64ld3sk2]
  
  Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # yandex_compute_instance.centos["0"] will be created
    + resource "yandex_compute_instance" "centos" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = "prod-centos-0"
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  cloud-user:ssh-rsa   AAAAB3NzaC1yc2EAAAADAQABAAABAQCDD7DjHSSK1IyBmp7VtZFEuUcyGVYRV0Lqa5FdjYh4eIRzmNabiXqtUXQMYfb1ZyZULyqh4kJtTc4ZGJaPEuc+3P44HVFM3BpLVQT/EHMG4wVKXvSiU3cZaKw799UgVdezqmOUHhsTdSq71SbJl5SopjDSxZqkyKTHR07yYeu0IKPu14An7MB2+o4rIQEz7mMchwAq5pi7x0tRooVd+jlEVHGr9aZsrfhmTFfx/pNnxF07GY5m++ZlzMsIlkXSwis7jw9nYST+Mpy7KVOv9jE5ZPsbcR8rkPK7eYGaTfMzp1rkEveGGp86M4NDCsgX3yQ4pHcUnag8VoTdMbpf9/mP ivan@manokhin
              EOT
          }
        + name                      = "prod-centos-0"
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
                + image_id    = "fd875rkc8fbq64ld3sk2"
                + name        = (known after apply)
                + size        = (known after apply)
                + snapshot_id = (known after apply)
                + type        = "network-hdd"
              }
          }
  
        + metadata_options {
            + aws_v1_http_endpoint = (known after apply)
            + aws_v1_http_token    = (known after apply)
            + gce_http_endpoint    = (known after apply)
            + gce_http_token       = (known after apply)
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
  
        + placement_policy {
            + host_affinity_rules = (known after apply)
            + placement_group_id  = (known after apply)
          }
  
        + resources {
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_compute_instance.centos["1"] will be created
    + resource "yandex_compute_instance" "centos" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = "prod-centos-1"
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  cloud-user:ssh-rsa   AAAAB3NzaC1yc2EAAAADAQABAAABAQCDD7DjHSSK1IyBmp7VtZFEuUcyGVYRV0Lqa5FdjYh4eIRzmNabiXqtUXQMYfb1ZyZULyqh4kJtTc4ZGJaPEuc+3P44HVFM3BpLVQT/EHMG4wVKXvSiU3cZaKw799UgVdezqmOUHhsTdSq71SbJl5SopjDSxZqkyKTHR07yYeu0IKPu14An7MB2+o4rIQEz7mMchwAq5pi7x0tRooVd+jlEVHGr9aZsrfhmTFfx/pNnxF07GY5m++ZlzMsIlkXSwis7jw9nYST+Mpy7KVOv9jE5ZPsbcR8rkPK7eYGaTfMzp1rkEveGGp86M4NDCsgX3yQ4pHcUnag8VoTdMbpf9/mP ivan@manokhin
              EOT
          }
        + name                      = "prod-centos-1"
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
                + image_id    = "fd875rkc8fbq64ld3sk2"
                + name        = (known after apply)
                + size        = (known after apply)
                + snapshot_id = (known after apply)
                + type        = "network-hdd"
              }
          }
  
        + metadata_options {
            + aws_v1_http_endpoint = (known after apply)
            + aws_v1_http_token    = (known after apply)
            + gce_http_endpoint    = (known after apply)
            + gce_http_token       = (known after apply)
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
  
        + placement_policy {
            + host_affinity_rules = (known after apply)
            + placement_group_id  = (known after apply)
          }
  
        + resources {
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_compute_instance.ubuntu[0] will be created
    + resource "yandex_compute_instance" "ubuntu" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = "prod-ubuntu-0"
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:ssh-rsa   AAAAB3NzaC1yc2EAAAADAQABAAABAQCDD7DjHSSK1IyBmp7VtZFEuUcyGVYRV0Lqa5FdjYh4eIRzmNabiXqtUXQMYfb1ZyZULyqh4kJtTc4ZGJaPEuc+3P44HVFM3BpLVQT/EHMG4wVKXvSiU3cZaKw799UgVdezqmOUHhsTdSq71SbJl5SopjDSxZqkyKTHR07yYeu0IKPu14An7MB2+o4rIQEz7mMchwAq5pi7x0tRooVd+jlEVHGr9aZsrfhmTFfx/pNnxF07GY5m++ZlzMsIlkXSwis7jw9nYST+Mpy7KVOv9jE5ZPsbcR8rkPK7eYGaTfMzp1rkEveGGp86M4NDCsgX3yQ4pHcUnag8VoTdMbpf9/mP ivan@manokhin
              EOT
          }
        + name                      = "prod-ubuntu-0"
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
                + image_id    = "fd8ueg1g3ifoelgdaqhb"
                + name        = (known after apply)
                + size        = (known after apply)
                + snapshot_id = (known after apply)
                + type        = "network-hdd"
              }
          }
  
        + metadata_options {
            + aws_v1_http_endpoint = (known after apply)
            + aws_v1_http_token    = (known after apply)
            + gce_http_endpoint    = (known after apply)
            + gce_http_token       = (known after apply)
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
  
        + placement_policy {
            + host_affinity_rules = (known after apply)
            + placement_group_id  = (known after apply)
          }
  
        + resources {
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_compute_instance.ubuntu[1] will be created
    + resource "yandex_compute_instance" "ubuntu" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = "prod-ubuntu-1"
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:ssh-rsa   AAAAB3NzaC1yc2EAAAADAQABAAABAQCDD7DjHSSK1IyBmp7VtZFEuUcyGVYRV0Lqa5FdjYh4eIRzmNabiXqtUXQMYfb1ZyZULyqh4kJtTc4ZGJaPEuc+3P44HVFM3BpLVQT/EHMG4wVKXvSiU3cZaKw799UgVdezqmOUHhsTdSq71SbJl5SopjDSxZqkyKTHR07yYeu0IKPu14An7MB2+o4rIQEz7mMchwAq5pi7x0tRooVd+jlEVHGr9aZsrfhmTFfx/pNnxF07GY5m++ZlzMsIlkXSwis7jw9nYST+Mpy7KVOv9jE5ZPsbcR8rkPK7eYGaTfMzp1rkEveGGp86M4NDCsgX3yQ4pHcUnag8VoTdMbpf9/mP ivan@manokhin
              EOT
          }
        + name                      = "prod-ubuntu-1"
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
                + image_id    = "fd8ueg1g3ifoelgdaqhb"
                + name        = (known after apply)
                + size        = (known after apply)
                + snapshot_id = (known after apply)
                + type        = "network-hdd"
              }
          }
  
        + metadata_options {
            + aws_v1_http_endpoint = (known after apply)
            + aws_v1_http_token    = (known after apply)
            + gce_http_endpoint    = (known after apply)
            + gce_http_token       = (known after apply)
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
  
        + placement_policy {
            + host_affinity_rules = (known after apply)
            + placement_group_id  = (known after apply)
          }
  
        + resources {
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_vpc_network.network will be created
    + resource "yandex_vpc_network" "network" {
        + created_at                = (known after apply)
        + default_security_group_id = (known after apply)
        + folder_id                 = (known after apply)
        + id                        = (known after apply)
        + labels                    = (known after apply)
        + name                      = "prod-net"
        + subnet_ids                = (known after apply)
      }
  
    # yandex_vpc_subnet.subnet will be created
    + resource "yandex_vpc_subnet" "subnet" {
        + created_at     = (known after apply)
        + folder_id      = (known after apply)
        + id             = (known after apply)
        + labels         = (known after apply)
        + name           = "prod-subnet"
        + network_id     = (known after apply)
        + v4_cidr_blocks = [
            + "10.10.10.0/24",
          ]
        + v6_cidr_blocks = (known after apply)
        + zone           = "ru-central1-a"
      }
  
  Plan: 6 to add, 0 to change, 0 to destroy.
  
  Changes to Outputs:
    + centos_private_ip = [
        + (known after apply),
        + (known after apply),
      ]
    + centos_public_ip  = [
        + (known after apply),
        + (known after apply),
      ]
    + ubuntu_private_ip = [
        + (known after apply),
        + (known after apply),
      ]
    + ubuntu_public_ip  = [
        + (known after apply),
        + (known after apply),
      ]
  
  ─────────────────────────────────────────────────────────────────────────
  
  Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply"   now.
  ```
</details>
