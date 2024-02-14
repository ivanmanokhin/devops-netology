# Домашнее задание по теме: «Troubleshooting»

## Цель задания

Устранить неисправности при деплое приложения.

## Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

## Результат

1. Установка приложения:
    ```bash
    vagrant@k8s-master01:~$  kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
    
    # получаем сообщение о том, что не созданы namespaces

    Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web"     not found
    Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data"     not found
    Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data"     not found
    ```
    ```bash
    # создаем пространства имен

    vagrant@k8s-master01:~$ kubectl create namespace web
    namespace/web created
    vagrant@k8s-master01:~$ kubectl create namespace data
    namespace/data created
    ```
    ```bash
    vagrant@k8s-master01:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
    deployment.apps/web-consumer created
    deployment.apps/auth-db created
    service/auth-db created
    ```
2. Проверяем состояние подов:
    ```bash
    vagrant@k8s-master01:~$ kubectl get pods -n data -o wide
    NAME                       READY   STATUS    RESTARTS   AGE    IP              NODE           NOMINATED NODE   READINESS GATES
    auth-db-7b5cdbdc77-xlh5l   1/1     Running   0          2m5s   10.233.109.65   k8s-worker02   <none>           <none>
    vagrant@k8s-master01:~$ kubectl get pods -n web -o wide
    NAME                            READY   STATUS    RESTARTS   AGE    IP              NODE           NOMINATED NODE   READINESS GATES
    web-consumer-5f87765478-4pm62   1/1     Running   0          2m8s   10.233.109.66   k8s-worker02   <none>           <none>
    web-consumer-5f87765478-nbq67   1/1     Running   0          2m8s   10.233.79.75    k8s-worker01   <none>           <none>

    # поды успешно запущены
    ```
3. Проверяем логи подов:
    ```bash
    vagrant@k8s-master01:~$ kubectl logs auth-db-7b5cdbdc77-xlh5l -n data
    /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
    /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
    /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
    10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
    10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
    /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
    /docker-entrypoint.sh: Configuration complete; ready for start up
    
    # под "auth-db" успешно запущен

    vagrant@k8s-master01:~$ kubectl logs web-consumer-5f87765478-nbq67 -n web
    curl: (6) Couldn't resolve host 'auth-db'
    curl: (6) Couldn't resolve host 'auth-db'

    # поды "web-consumer" не могут разрезолвить адрес
    ```
4. Посмотрим описание пода:
    ```bash
    vagrant@k8s-master01:~$ kubectl describe pod web-consumer-5f87765478-nbq67 -n web

    ...
    Command:
      sh
      -c
      while true; do curl auth-db; sleep 5; done
    ...
    ```
5. Проблема заключается в том, что сервис `auth-db` находится в другом пространстве имен, для того что бы имя разрезолвилось, необходимо указывать полное доменное имя (включающее `namespace`).
6. Отредактируем манифест:
    ```yaml
    kubectl get -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml -o yaml > task.yaml

    # в полученном манифесте заменим "do curl auth-db", на "do curl auth-db.data"
    ```
7. Применяем обновленный манифест:
    ```bash
    vagrant@k8s-master01:~$ kubectl apply -f task.yaml 
    deployment.apps/web-consumer configured
    deployment.apps/auth-db configured
    service/auth-db configured
    ```
8. Проверяем логи `web-consumer` и `auth-db`:
    ```bash
    vagrant@k8s-master01:~$ kubectl logs -n web web-consumer-76669b5d6d-ldz2j
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   612  100   612    0     0   2526      0 --:--:-- --:--:-- --:--:--  597k
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>
    
    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>
    
    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>

    vagrant@k8s-master01:~$ kubectl logs -n data auth-db-7b5cdbdc77-xlh5l 
    /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
    /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
    /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
    10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
    10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
    /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
    /docker-entrypoint.sh: Configuration complete; ready for start up
    10.233.109.69 - - [14/Feb/2024:19:02:04 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.35.0" "-"
    10.233.79.79 - - [14/Feb/2024:19:02:05 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.35.0" "-"
    ```
9. Работа приложения восстановленна.
