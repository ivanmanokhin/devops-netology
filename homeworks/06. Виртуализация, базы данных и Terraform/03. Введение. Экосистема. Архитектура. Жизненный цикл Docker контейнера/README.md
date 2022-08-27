# Домашнее задание по теме "Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

**Ответ:** [Docker Hub](https://hub.docker.com/r/manokhin/nginx-alpine)

Команды:
```bash
----------

vagrant@server1:~/nginx-alpine$ cat Dockerfile
FROM nginx:1.23.1-alpine

RUN apk -U upgrade && rm -rf /var/cache/apk

COPY index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]

vagrant@server1:~/nginx-alpine$ cat index.html
<html>
<head>
    Hey, Netology
</head>
<body>
    <h1>I'm DevOps Engineer!</h1>
</body>
</html>

----------

docker build -t manokhin/nginx-alpine:v0.1 .

docker run -d -p 80:80 --name nginx manokhin/nginx-alpine:v0.1

docker exec nginx sh -c "nginx -v"                                                                                                        
nginx version: nginx/1.23.1

docker push manokhin/nginx-alpine:v0.1

```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

**Ответ:**
1. Физические сервера, если приложение высоконагруженное, то виртуализация будет отнимать лишние ресурсы, а для контейнерезации приложение нужно сначала разбить на микросервисы;
2. Docker-контейнеры, веб-приложение как раз тот сервис, который отлично подходит для контенеризации, можно использовать репликацию;
3. Docker-контейнеры, серверную часть приложения можно разбить на микросервисы и использовать в контейнерах;
4. Docker-контейнеры, если нагрузка большая можно использовать виртуальные машины, дабы избежать излишней инкапсуляции;
5. Docker-контейнеры, тем более под это уже есть готовые docker-compose;
6. Docker-контейнеры, для поднятия уже есть готовые docker-compose, которые легко доработать под нужные задачи;
7. Виртуальные машины, в зависимости от нагрузки конечно, можно использовать и docker-контейнеры;
8. Docker-контейнеры, для runner'ов можно использовать dind;

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

**Ответ:** официальные образы centos/debian не содержат команды запуска процесса, поэтому просто запусить в detached режиме их не получиться.

Команды:
```bash
docker run -d -v $PWD/data:/data --name centos centos sh -c "/usr/bin/sleep inf"
docker run -d -v $PWD/data:/data --name ubuntu ubuntu sh -c "/usr/bin/sleep inf"

docker exec -it centos bash
[root@d875158693d0 /]# echo "I'm CentOS Container" > /data/centos.txt

vagrant@server1:~$ echo "I'm Ubuntu VM" > data/ubuntu.txt

vagrant@server1:~$ docker exec ubuntu sh -c "ls -al /data; cat /data/*"
total 16
drwxrwxr-x 2 1000 1000 4096 Aug 27 12:13 .
drwxr-xr-x 1 root root 4096 Aug 27 12:13 ..
-rw-r--r-- 1 root root   11 Aug 27 12:13 centos.txt
-rw-rw-r-- 1 1000 1000   12 Aug 27 12:10 ubuntu.txt
I'm CentOS Container
I'm Ubuntu VM
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

**Ответ:** [Docker Hub](https://hub.docker.com/r/manokhin/ansible-alpine)

Команды:
```bash
docker build -t manokhin/ansible-alpine:v0.1 .

docker run --rm -it manokhin/ansible-alpine:v0.1 ansible --version
ansible [core 2.13.3]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
  jinja version = 3.1.2
  libyaml = False

docker push manokhin/ansible-alpine:v0.1
The push refers to repository [docker.io/manokhin/ansible-alpine]
b0700fc4fd50: Pushed
c41c18f36c8c: Pushed
63493a9ab2d4: Mounted from library/alpine
v0.1: digest: sha256:dd8d1aaf146bd0e1453de4efe279bcb4d86b7c8867305caa290f2b916e807cf8 size: 947
```
