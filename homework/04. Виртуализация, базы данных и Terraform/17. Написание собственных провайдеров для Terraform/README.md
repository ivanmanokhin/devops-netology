# Домашнее задание по теме: "Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   

    **Ответ:**

    Файл provider.go:

    * [data_source](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L419)
    * [recource](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L944)

2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.

        **Ответ:** с параметром `name_prefix`: [queue.go](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L88)

    * Какая максимальная длина имени?

        **Ответ:** [75 (для fifo)](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L432) и [80 (для остальных очередей)](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L434)

    * Какому регулярному выражению должно подчиняться имя?

        **Ответ:** fifo: `^[a-zA-Z0-9_-]{1,75}\.fifo$`, else: `^[a-zA-Z0-9_-]{1,80}$`
    
## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

**Результат:**

[Репозиторий с кодом](https://github.com/ivanmanokhin/terraform-provider-hashicups)

![](./assets/build.png)
