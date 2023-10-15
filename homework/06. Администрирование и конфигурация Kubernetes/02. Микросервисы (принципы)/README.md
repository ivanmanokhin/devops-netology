# Домашнее задание по теме: «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

## Ответ

Сводная таблица решений для организации API Gateway:

| Программный продукт | Лицензия | Маршрутизация запросов к нужному сервису на основе конфигурации | Возможность проверки аутентификационной информации в запросах | Обеспечение терминации HTTPS |
|:- | :-: |  :-: |  :-: |  :-: |
| Nginx | BSD | Да | Да | Да |
| Kong | Apache License 2.0 | Да | Да | Да |
| Tyk | Mozilla Public License 2.0 | Да | Да | Да |
| HAProxy | GNU General Public License 2.0 | Да | Да | Да |
| Traefik | MIT | Да | Да | Да |
| Ambassador | Apache License 2.0 | Да | Да | Да |

Таблица формировалась на основе приведенных требований, а также наличии OSS версии. Также были исключены варианты предоставляемые облачными провайдерами, так как в случае их использования мы получим вендор лок и если нам по каким либо причинам придется сменить облако, то изменение шлюза станет большой проблемой.

Если учитывать тему модуля (Kubernates) то самым интересным на мой взгляд решением является Kong, так как он тесно интегрирован с контейнеризированной средой, но есть и минусы, так как множество функций доступны только в Enterprise версии.

С точки зрения рациональности лучшем решением будет Nginx, у него самое большое комьюнити огромные возможности, есть вариант с поддержкой Lua (OpenResty), на подавляющее вопросов уже даны ответы, версия Plus только добавляет дополнительные возможности, а не урезает свободную.

Но прежде чем останавливаться на каком-то из решений я бы поднял тестовые среды, на которых эти решения можно было бы протестировать возможности этих продуктов и сделать окончательный выбор. Т.к. возможно то, что кажется большими минусами в ходе работы влиять не будет, а плюсы будут перевешивать. А возможна ситуация когда не одно из решений не будет соответствовать требованиям и функционал API Gateway придется реализовывать команде разработки.

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

## Ответ

Сводная таблица решений для организации брокера сообщений:

| Программный продукт | Лицензия | Поддержка кластеризации для обеспечения надёжности | Хранение сообщений на диске в процессе доставких | Высокая скорость работы | Поддержка различных форматов сообщений | Разделение прав доступа к различным потокам сообщений | Простота эксплуатации |
|:- | :-: |  :-: |  :-: |  :-: |  :-: |  :-: |  :-: |
| RabbitMQ | MPL 2.0 | Да | Да | Средняя | Да | Да | Да |
| Apache Kafka |  Apache 2.0 | Да | Да | Высокая | Да | Да | Нет |
| Apache ActiveMQ | Apache 2.0 | Да | Да | Высокая | Да | Да | Нет |
| NATS | Apache 2.0 | Да | Нет | Высокая | Да | Да | Да | Да |
| Redis | BSD | Да | Нет | Высокая | Да | Да | Да | Да |
| IBM MQ | Коммерческая | Да | Да | Средняя | Да | Да | Нет |
| KubeMQ | Apache 2.0 | Да | Да | Высокая | Да | Да | Да |

Из приведенных решений я бы делал выбор между RabbitMQ, Kafka, KubeMQ. Rabbit намного проще в настройке и эксплуатации, отличная документация, но в средах где действительно огромные объемы данных, он может быть не эффективным. Kafka же довольно сложна в настройки но и возможностей у нее на порядок больше, в том числе хорошая интеграция с Kubernates через Kubernatess Ingress Controller.

С учетом темы модуля я бы вероятно остановился на KubeMQ - так как у него наиболее полнаяя интеграция с Kibernates (является нативны) и по остальным пунктам он вроде как подходит (по крайней мере, решенее выглядит интересно).

Но, как и в случае с API Gateway, требуется тестирование всех подходящих вариантов основываясь на типе, объеме и требованиям к скорости обработки данных в проекте.

## Задача 3: API Gateway * (необязательная)

### Есть три сервиса:

**minio**
- хранит загруженные файлы в бакете images,
- S3 протокол,

**uploader**
- принимает файл, если картинка сжимает и загружает его в minio,
- POST /v1/upload,

**security**
- регистрация пользователя POST /v1/user,
- получение информации о пользователе GET /v1/user,
- логин пользователя POST /v1/token,
- проверка токена GET /v1/token/validation.

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/user.

**POST /v1/token**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/token.

**GET /v1/user**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис security GET /v1/user.

**POST /v1/upload**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис uploader POST /v1/upload.

**GET /v1/user/{image}**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис minio GET /images/{image}.

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл, запустив который можно локально выполнить следующие команды с успешным результатом.
Предполагается, что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки, который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
Авторизация
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

## Результат:

В security пришлось изменить версию библиотеки [Flask](./docker/security/requirements.txt) и [закомментировать](./docker/security/src/server.py) сторки с экземляром класса `metrics`, т.к. были ошибки:

<details>
   <summary>Ошибки запуска контейнера security</summary>

   ```bash
   security                | Traceback (most recent call last):
   security                |   File "/app/./server.py", line 2, in <module>
   security                |     from flask import Flask, request, make_response, jsonify
   security                |   File "/usr/local/lib/python3.9/site-packages/flask/__init__.py", line 14, in <module>
   security                |     from jinja2 import escape
   security                | ImportError: cannot import name 'escape' from 'jinja2' (/usr/local/lib/python3.9/site-packages/jinja2/__init__.py)
   ```

   ```bash
   security                | Traceback (most recent call last):
   security                |   File "/app/./server.py", line 3, in <module>
   security                |     from prometheus_flask_exporter import PrometheusMetrics, NO_PREFIX
   security                |   File "/usr/local/lib/python3.9/site-packages/prometheus_flask_exporter/__init__.py", line 12, in <module>
   security                |     from flask.views import MethodViewType
   security                | ImportError: cannot import name 'MethodViewType' from 'flask.views' (/usr/local/lib/python3.9/site-packages/flask/views.py)
   ```
</details>

---

Файлы:
  * [nginx.conf](./docker/gateway/nginx.conf)
  * [docker-compose.yaml](./docker/docker-compose.yaml)

Логи запуска контейнеров:
  * <details>
      <summary>Лог docker compose</summary>

      ```bash
      [root@lab docker]# docker compose up
      [+] Running 20/20
       ✔ gateway 8 layers [⣿⣿⣿⣿⣿⣿⣿⣿]      0B/0B      Pulled                                                                                                4.6s 
         ✔ 96526aa774ef Pull complete                                                                                                                      0.7s 
         ✔ f2004135e416 Pull complete                                                                                                                      0.5s 
         ✔ fbf1cf5026c4 Pull complete                                                                                                                      0.5s 
         ✔ 38966af6931d Pull complete                                                                                                                      1.0s 
         ✔ c3ee70732c61 Pull complete                                                                                                                      1.1s 
         ✔ 7e2fd992447a Pull complete                                                                                                                      1.1s 
         ✔ 76cbc9ea6abf Pull complete                                                                                                                      1.4s 
         ✔ 37f8bcf34db7 Pull complete                                                                                                                      1.6s 
       ✔ storage 5 layers [⣿⣿⣿⣿⣿]      0B/0B      Pulled                                                                                                  13.2s 
         ✔ 72a648490971 Pull complete                                                                                                                      2.3s 
         ✔ 7b2e69810b03 Pull complete                                                                                                                      2.6s 
         ✔ 78856aa3cfeb Pull complete                                                                                                                      2.7s 
         ✔ 1f884916cc95 Pull complete                                                                                                                      2.9s 
         ✔ bc77c11e66b1 Pull complete                                                                                                                      3.7s 
       ✔ createbuckets 4 layers [⣿⣿⣿⣿]      0B/0B      Pulled                                                                                             13.1s 
         ✔ 395bceae1ad3 Pull complete                                                                                                                      1.9s 
         ✔ 05f14d065953 Pull complete                                                                                                                      1.8s 
         ✔ 12abda173316 Pull complete                                                                                                                      2.2s 
         ✔ c15fd5f0018d Pull complete                                                                                                                      2.5s 
      [+] Building 22.5s (20/20) FINISHED                                                                                                        docker:default
       => [uploader internal] load build definition from Dockerfile                                                                                        0.2s
       => => transferring dockerfile: 203B                                                                                                                 0.0s
       => [uploader internal] load .dockerignore                                                                                                           0.2s
       => => transferring context: 111B                                                                                                                    0.0s
       => [security internal] load build definition from Dockerfile                                                                                        0.2s
       => => transferring dockerfile: 239B                                                                                                                 0.0s
       => [security internal] load .dockerignore                                                                                                           0.2s
       => => transferring context: 2B                                                                                                                      0.0s
       => [uploader internal] load metadata for docker.io/library/node:alpine                                                                              1.8s
       => [security internal] load metadata for docker.io/library/python:3.9-alpine                                                                        1.8s
       => [uploader 1/5] FROM docker.io/library/node:alpine@sha256:37750e51d61bef92165b2e29a77da4277ba0777258446b7a9c99511f119db096                        9.3s
       => => resolve docker.io/library/node:alpine@sha256:37750e51d61bef92165b2e29a77da4277ba0777258446b7a9c99511f119db096                                 0.1s
       => => sha256:37750e51d61bef92165b2e29a77da4277ba0777258446b7a9c99511f119db096 1.43kB / 1.43kB                                                       0.0s
       => => sha256:80cc2c520781c1a4681e59df6791d81a432a6cb3da0c385d8d62e9f16acf8e5f 1.16kB / 1.16kB                                                       0.0s
       => => sha256:e722ab35703785bed3cf7b5f8f87652efbb311562fa6ec4634445ee31e9ec224 6.78kB / 6.78kB                                                       0.0s
       => => sha256:bd866a276fb26dd895780268b9622a1d92dc4393ab85054317bbd1ac40504459 49.80MB / 49.80MB                                                     2.7s
       => => sha256:86562bfdb01870649ea3dcc082af03ed25e8cdccb638638b8fa09ebc169a2995 2.34MB / 2.34MB                                                       1.5s
       => => sha256:20bf5151d902500e94a168975a49a04897e1f895290d75782ff2da96becab400 451B / 451B                                                           1.5s
       => => extracting sha256:bd866a276fb26dd895780268b9622a1d92dc4393ab85054317bbd1ac40504459                                                            2.6s
       => => extracting sha256:86562bfdb01870649ea3dcc082af03ed25e8cdccb638638b8fa09ebc169a2995                                                            0.1s
       => => extracting sha256:20bf5151d902500e94a168975a49a04897e1f895290d75782ff2da96becab400                                                            0.0s
       => [uploader internal] load build context                                                                                                           0.1s
       => => transferring context: 92.86kB                                                                                                                 0.0s
       => [security 1/5] FROM docker.io/library/python:3.9-alpine@sha256:774c221432ab78560a70aa0ca3a5b2ef6f17d1887c77ded2b93c980ff88677fd                  9.2s
       => => resolve docker.io/library/python:3.9-alpine@sha256:774c221432ab78560a70aa0ca3a5b2ef6f17d1887c77ded2b93c980ff88677fd                           0.1s
       => => sha256:774c221432ab78560a70aa0ca3a5b2ef6f17d1887c77ded2b93c980ff88677fd 1.65kB / 1.65kB                                                       0.0s
       => => sha256:c31d1e01897060699a49865075b566cd4c1db228e630d1dfc4f9091dba622140 1.37kB / 1.37kB                                                       0.0s
       => => sha256:c6a833d4884bf5d232be54ad733a6a22014ad33b29357928337c7a8647824d78 6.25kB / 6.25kB                                                       0.0s
       => => sha256:3deb9c5a5a50836c398bfdd7a06943c0b3db481817f0d2262a64403faa395c19 240B / 240B                                                           2.9s
       => => sha256:9875af95546db78168a6761b7fa205ed1cd0c153cd89356c1512e551c12b2d5c 622.29kB / 622.29kB                                                   2.9s
       => => sha256:78d94acc09a2869b561df6579ff8ec22285052ea7e9f90583bac46009b95bb74 11.44MB / 11.44MB                                                     3.5s
       => => extracting sha256:9875af95546db78168a6761b7fa205ed1cd0c153cd89356c1512e551c12b2d5c                                                            0.3s
       => => sha256:987c8cc50b4cc280377482b7c5f430357e6cc1a38eab93f0dfaa26b600620ef1 2.85MB / 2.85MB                                                       3.2s
       => => extracting sha256:78d94acc09a2869b561df6579ff8ec22285052ea7e9f90583bac46009b95bb74                                                            0.7s
       => => extracting sha256:3deb9c5a5a50836c398bfdd7a06943c0b3db481817f0d2262a64403faa395c19                                                            0.0s
       => => extracting sha256:987c8cc50b4cc280377482b7c5f430357e6cc1a38eab93f0dfaa26b600620ef1                                                            0.2s
       => [security internal] load build context                                                                                                           0.1s
       => => transferring context: 2.68kB                                                                                                                  0.0s
       => [security 2/5] WORKDIR /app                                                                                                                      1.2s
       => [uploader 2/5] WORKDIR /app                                                                                                                      1.1s
       => [security 3/5] COPY requirements.txt .                                                                                                           0.3s
       => [uploader 3/5] COPY package*.json ./                                                                                                             0.3s
       => [security 4/5] RUN pip install -r requirements.txt                                                                                               9.1s
       => [uploader 4/5] RUN npm install                                                                                                                   5.9s
       => [uploader 5/5] COPY src ./                                                                                                                       0.2s
       => [uploader] exporting to image                                                                                                                    0.5s
       => => exporting layers                                                                                                                              0.5s
       => => writing image sha256:b402fb9004b50002569aa40a40e975c7d8e568a7c951ab11e189c6d685dbf491                                                         0.0s
       => => naming to docker.io/library/docker-uploader                                                                                                   0.0s
       => [security 5/5] COPY src ./                                                                                                                       0.2s
       => [security] exporting to image                                                                                                                    0.3s
       => => exporting layers                                                                                                                              0.3s
       => => writing image sha256:645d289fc809d0bc457cf3a2f9bb13c2f94ddc436e3887bde893fde44f3ba7db                                                         0.0s
       => => naming to docker.io/library/docker-security                                                                                                   0.0s
      [+] Running 6/6
       ✔ Network docker_default            Created                                                                                                         0.2s 
       ✔ Container storage                 Created                                                                                                         0.4s 
       ✔ Container security                Created                                                                                                         0.4s 
       ✔ Container docker-createbuckets-1  Created                                                                                                         0.1s 
       ✔ Container uploader                Created                                                                                                         0.2s 
       ✔ Container gateway                 Created                                                                                                         0.2s 
      Attaching to docker-createbuckets-1, gateway, security, storage, uploader
      security                |  * Serving Flask app 'server'
      security                |  * Debug mode: off
      security                | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
      security                |  * Running on all addresses (0.0.0.0)
      security                |  * Running on http://127.0.0.1:3000
      security                |  * Running on http://172.27.0.3:3000
      security                | Press CTRL+C to quit
      storage                 | MinIO Object Storage Server
      storage                 | Copyright: 2015-2023 MinIO, Inc.
      storage                 | License: GNU AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
      storage                 | Version: RELEASE.2023-10-14T05-17-22Z (go1.21.3 linux/amd64)
      storage                 | 
      storage                 | Status:         1 Online, 0 Offline. 
      storage                 | S3-API: http://172.27.0.2:9000  http://127.0.0.1:9000 
      storage                 | Console: http://172.27.0.2:35339 http://127.0.0.1:35339 
      storage                 | 
      storage                 | Documentation: https://min.io/docs/minio/linux/index.html
      storage                 | Warning: The standard parity is set to 0. This can lead to data loss.
      docker-createbuckets-1  | Added `storage` successfully.
      docker-createbuckets-1  | Bucket created successfully `storage/images`.
      docker-createbuckets-1  | mc: Please use 'mc anonymous'
      uploader                | S3: storage:9000 images
      uploader                | Listening on port 3000
      uploader                | (node:1) [DEP0152] DeprecationWarning: Custom PerformanceEntry accessors are deprecated. Please use the detail property.
      uploader                | (Use `node --trace-deprecation ...` to show where the warning was created)
      docker-createbuckets-1 exited with code 0
      gateway                 | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
      gateway                 | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
      gateway                 | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
      gateway                 | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
      gateway                 | 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
      gateway                 | /docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
      gateway                 | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
      gateway                 | /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
      gateway                 | /docker-entrypoint.sh: Configuration complete; ready for start up
      ```
    </details>

Получение токена:

```
[root@lab ~]# curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/v1/token
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I
```

Проверка загрузки картинки без токена:

```
[root@lab ~]# curl -X POST -H 'Content-Type: octet/stream' --data-binary @toad.jpg http://localhost/v1/upload
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx/1.25.2</center>
</body>
</html>
```

Загрузка картинки:

```
curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @toad.jpg http://localhost/v1/upload
{"filename":"228848f7-40f7-4d37-b97d-554741711a77.jpg"}
```

Проверка:

```
[root@lab ~]# curl -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' http://localhost/v1/user/228848f7-40f7-4d37-b97d-554741711a77.jpg > toad_2.jpg 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 30181  100 30181    0     0  7368k      0 --:--:-- --:--:-- --:--:-- 7368k
[root@lab ~]# ls -ahl | grep toad
-rw-r--r--.  1 root root  30K Oct 15 13:10 toad_2.jpg
-rw-rw-r--.  1 root root  30K Oct 15 10:14 toad.jpg
```
