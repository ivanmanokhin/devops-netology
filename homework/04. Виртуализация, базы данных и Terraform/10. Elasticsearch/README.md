# Домашнее задание по теме: "Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

**Результат:**

1) Dockerfile:

    ```dockerfile
    FROM centos:centos7
    
    ARG ES_VERSION=8.6.1
    
    RUN yum update -y \
      && yum install -y \
      wget \
      perl-Digest-SHA \
      && yum clean all \
      && rm -rf /var/cache
    
    RUN useradd -d /elasticsearch -U elastic \
      && mkdir /var/lib/elasticsearch \
      && chown -R elastic: /var/lib/elasticsearch
    
    USER elastic
    WORKDIR /elasticsearch

    RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
      && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 \
      && shasum -a 512 -c elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 \
      && tar -xzf elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
      && mv elasticsearch-${ES_VERSION}/* . \
      && rm -rf elasticsearch-${ES_VERSION}*
    
    RUN echo -e '\
    node.name: netology_test\n\
    xpack.security.enabled: false\n\
    path.data: /var/lib/elasticsearch\n\
    discovery.type: single-node\n\
    http.host: 0.0.0.0\n\
    ' > /elasticsearch/config/elasticsearch.yml

    EXPOSE 9200
    EXPOSE 9300

    CMD ["./bin/elasticsearch"]
    ```

2) [Docker Hub](https://hub.docker.com/layers/manokhin/es-netology/8.6.1/images/sha256-285dcf91800ad15f25664944ea038de1ff6770afd26f3ef67d6ac0870742a802?context=explore)

3) `curl localhost:9200/:`

    ```
    {
      "name" : "netology_test",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "GaguutR8Q_uN4TiOAcAVXA",
      "version" : {
        "number" : "8.6.1",
        "build_flavor" : "default",
        "build_type" : "tar",
        "build_hash" : "180c9830da956993e59e2cd70eb32b5e383ea42c",
        "build_date" : "2023-01-24T21:35:11.506992272Z",
        "build_snapshot" : false,
        "lucene_version" : "9.4.2",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
      },
      "tagline" : "You Know, for Search"
    }
    ```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

**Результат:**
    
1) Создание индексов:

    ```bash
    curl -X PUT "http://localhost:9200/ind-1?pretty" \
      -H 'Content-Type: application/json' \
      -d '{"settings":{"number_of_replicas":0,"number_of_shards":1}}'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "ind-1"
    }
    
    curl -X PUT "http://localhost:9200/ind-2?pretty" \
      -H 'Content-Type: application/json' \
      -d '{"settings":{"number_of_replicas":1,"number_of_shards":2}}'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "ind-2"
    }
    
    curl -X PUT "http://localhost:9200/ind-3?pretty" \
      -H 'Content-Type: application/json' \
      -d '{"settings":{"number_of_replicas":2,"number_of_shards":4}}'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "ind-3"
    }
    ```

2) Список индексов и их статусов:

    ```bash
    curl -X GET "http://localhost:9200/_cat/indices?v"
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 4h3f0rZbRZGwNihAWgyVKA   1   0          0            0       225b           225b
    yellow open   ind-3 eVJqqjVERaeFRpSbPcTZAQ   4   2          0            0       900b           900b
    yellow open   ind-2 43g8coNIS2iADuu6HZSO9A   2   1          0            0       450b           450b
    ```

3) Состояние кластера Elasticsearch:

    ```bash
    curl -X GET "http://localhost:9200/_cluster/health?pretty=true"
    {
      "cluster_name" : "elasticsearch",
      "status" : "yellow",
      "timed_out" : false,
      "number_of_nodes" : 1,
      "number_of_data_nodes" : 1,
      "active_primary_shards" : 8,
      "active_shards" : 8,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 10,
      "delayed_unassigned_shards" : 0,
      "number_of_pending_tasks" : 0,
      "number_of_in_flight_fetch" : 0,
      "task_max_waiting_in_queue_millis" : 0,
      "active_shards_percent_as_number" : 44.44444444444444
    }
    ```

4) Состояние "YELLOW" части индексов и кластера обусловленно тем что отсутствуют реплики, так как нет ноды на которой их можно было бы разместить.

5) Удаление индексов:

    ```bash
    for i in 1 2 3; do curl -X DELETE "http://localhost:9200/ind-${i}?pretty"; done
    {
      "acknowledged" : true
    }
    {
      "acknowledged" : true
    }
    {
      "acknowledged" : true
    }
    ```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

**Результат:**

1) Регистрация директории как `snapshot repository`:

    ```bash
    curl -X PUT "http://localhost:9200/_snapshot/netology_backup?verify=false&pretty" \
      -H 'Content-Type: application/json' \
      -d '{"type":"fs","settings":{"location":"/elasticsearch/snapshots"}}'
    {
      "acknowledged" : true
    }
    ```

2) Создание индекса test и вывод списка индексов с состоянием

    ```bash
    curl -X PUT "http://localhost:9200/test?pretty" \
      -H 'Content-Type: application/json' \
      -d '{"settings":{"number_of_replicas":0,"number_of_shards":1}}'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "test"
    }

    curl -X GET "http://localhost:9200/_cat/indices?v"
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test  T9eV49LUTaKr8BK845clOA   1   0          0            0       225b           225b
    ```

3) Создание и вывод списка snapshot'ов:

	```bash
    curl -X PUT "localhost:9200/_snapshot/netology_backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?pretty"
    {
      "accepted" : true
    }

    curl -X GET "http://localhost:9200/_cat/snapshots?v"
    id                     repository       status start_epoch start_time end_epoch  end_time duration indices successful_shards failed_shards total_shards
    my_snapshot_2023.02.11 netology_backup SUCCESS 1676159460  23:51:00   1676159464 23:51:04     3.5s       5                 9             0            9
    ```

4) Удаление индекса test, создание индекса test-2, вывод списка индексов

    ```bash
    curl -X DELETE "http://localhost:9200/test?pretty"
    {
      "acknowledged" : true
    }

    curl -X PUT "http://localhost:9200/test-2?pretty" \
          -H 'Content-Type: application/json' \
          -d '{"settings":{"number_of_replicas":0,"number_of_shards":1}}'
      
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "test-2"
    }
    
    curl -X GET "http://localhost:9200/_cat/indices?v"
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 pIlF-LFnQF-aDi9m1bgj9A   1   0          0            0       225b           225b
    ```

5) Восстановление из snapshot'а и вывод списка индексов:

    ```bash
    curl -X POST "localhost:9200/_snapshot/netology_backup/my_snapshot_2023.02.11/_restore?pretty"
    {
      "accepted" : true
    }
    
    curl -X GET "http://localhost:9200/_cat/indices?v"
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 pIlF-LFnQF-aDi9m1bgj9A   1   0          0            0       225b           225b
    green  open   test   zMVbpUtBQSeRbgqzQLZzBQ   1   0          0            0       225b           225b
    ```
