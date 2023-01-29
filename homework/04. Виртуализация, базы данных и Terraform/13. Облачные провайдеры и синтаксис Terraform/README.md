# Домашнее задание по теме: "Облачные провайдеры и синтаксис Terraform"

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов.

AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
1. Установите c aws-cli https://aws.amazon.com/cli/.
1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
1. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess
1. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

**Результат:**

```bash
>aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************QQ2N shared-credentials-file
secret_key     ****************5ECZ shared-credentials-file
    region               eu-north-1      config-file    ~/.aws/config
```

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

**Результат:**

```bash
>yc config list
token: AQAA***********************************
cloud-id: b1gh5p5qgslmcei5io0i
folder-id: b1g51tksi3aq7j9inm1k
compute-default-zone: ru-central1-c
```

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.  

**Ответ:**
1. HashiCorp Packer
2. [AWS](./AWS/terraform/) и [Yandex.Cloud](./Yandex.Cloud/terraform/)

**Результаты:**

AWS:

```bash
>terraform apply -auto-approve
data.aws_region.current: Reading...
data.aws_caller_identity.current: Reading...
...
aws_eip.eip: Creating...
aws_eip.eip: Creation complete after 2s [id=eipalloc-0f0c825059c912384]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

account_id = "7455********"
caller_user = "AIDA2****************"
private_ip = "10.10.10.185"
public_dns = "ec2-13-48-228-27.eu-north-1.compute.amazonaws.com"
public_ip = "13.48.228.27"
region_name = "eu-north-1"
subnet_id = "subnet-01be75027e2cfc6d0"
```

Yandex.Cloud:

```bash
>terraform apply -auto-approve
data.yandex_compute_image.image: Reading...
data.yandex_compute_image.image: Read complete after 1s [id=fd8ueg1g3ifoelgdaqhb]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.instance will be created
  + resource "yandex_compute_instance" "instance" {
...
yandex_compute_instance.instance: Creation complete after 33s [id=ef3eph98h2o7c1ipeka8]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

private_ip = "10.10.10.25"
public_ip = "51.250.47.71"
subnet_id = "b0ca5me23f1idkbsm3n4"
zone = "ru-central1-c"
```