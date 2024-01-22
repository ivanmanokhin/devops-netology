# Домашнее задание по теме: «Запуск приложений в K8S»

## Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

## Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

## Результат

1. Проблема возникает, из-за того, что оба контейнера слушают порт 80. Изменил конфигурацию Multitool на прослушивание порта 8080 (с помощью env).
    [Манифест деплоймента](./01_dpl-web.yaml)
    ```bash
    user@local:~/.kube$ kubectl apply -f /tmp/01_dpl-web.yaml 
    deployment.apps/dpl-web created
    user@local:~/.kube$ kubectl get pod
    NAME                       READY   STATUS    RESTARTS   AGE
    dpl-web-555f67795b-rmnmp   2/2     Running   0          5s

    # Проверка Nginx

    user@local:~/.kube$ kubectl port-forward pod/dpl-web-555f67795b-rmnmp 8080:80
    Forwarding from 127.0.0.1:8080 -> 80
    Forwarding from [::1]:8080 -> 80
    Handling connection for 8080

    user@local:~$ curl localhost:8080
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
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

    # Проверка Multitool

    user@local:~kubectl port-forward pod/dpl-web-555f67795b-rmnmp 8081:8080
    Forwarding from 127.0.0.1:8081 -> 8080
    Forwarding from [::1]:8081 -> 8080
    Handling connection for 8081

    user@local:~$ curl localhost:8081
    WBITT Network MultiTool (with NGINX) - dpl-web-555f67795b-rmnmp - 10.1.77.21 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```
2. Увеличение количества реплик (изменение параметра replicas на 2)
    ```bash
    user@local:~/.kube$ kubectl apply -f /tmp/01_dpl-web.yaml 
    deployment.apps/dpl-web configured
    user@local:~/.kube$ kubectl get pod
    NAME                       READY   STATUS    RESTARTS   AGE
    dpl-web-555f67795b-rmnmp   2/2     Running   0          2m32s
    dpl-web-555f67795b-4smgs   2/2     Running   0          6s
    ```
3. [Манифест сервиса](./02_svc-web.yaml)
    ```bash
    user@local:~/.kube$ kubectl apply -f /tmp/02_svc-web.yaml 
    service/svc-web created
    user@local:~/.kube$ kubectl get svc
    NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
    kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP             5d5h
    svc-web      ClusterIP   10.152.183.77   <none>        8080/TCP,8081/TCP   48s

    # Проверка Nginx

    user@local:~/.kube$ kubectl port-forward svc/svc-web 8080:8080
    Forwarding from 127.0.0.1:8080 -> 80
    Forwarding from [::1]:8080 -> 80
    Handling connection for 8080

    user@local:~$ curl localhost:8080
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
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

    # Проверка Multitool

    user@local:~$ kubectl port-forward svc/svc-web 8081:8081
    Forwarding from 127.0.0.1:8081 -> 8080
    Forwarding from [::1]:8081 -> 8080
    Handling connection for 8081

    user@local:~$ curl localhost:8081
    WBITT Network MultiTool (with NGINX) - dpl-web-555f67795b-rmnmp - 10.1.77.21 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```
4. Запускаем Multitool в интерактивном режиме и проверяем доступность сервиса по портам
    ```bash
    user@local:~$ kubectl run multitool-test -i --tty --image=wbitt/network-multitool -- bash
    If you don't see a command prompt, try pressing enter.

    # Проверка Nginx

    multitool-test:/# curl svc-web:8080
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
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

    # Проверка Multitool

    multitool-test:/# curl svc-web:8081
    WBITT Network MultiTool (with NGINX) - dpl-web-555f67795b-4smgs - 10.1.77.22 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```

## Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

## Результат
1. [Манифест деплоймента](./03_dpl-web-with-init.yaml)
    ```bash
    user@local:~$ kubectl apply -f /tmp/03_dpl-web-with-init.yaml 
    deployment.apps/dpl-web-with-init created
    user@local:~/.kube$ kubectl get pod -w
    NAME                                READY   STATUS     RESTARTS   AGE
    dpl-web-with-init-fc7ff5958-x5rcv   0/1     Init:0/1   0          4s
    # контейнер с nginx не стартует
    ```
2. [Манифест сервиса](./04_svc-web-with-init.yaml)
    ```bash
    user@local:~$ kubectl apply -f /tmp/04_svc-web-with-init.yaml 
    service/svc-web-with-init created
    user@local:~$ kubectl get svc
    NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
    kubernetes          ClusterIP   10.152.183.1    <none>        443/TCP    5d5h
    svc-web-with-init   ClusterIP   10.152.183.29   <none>        8080/TCP   12s

    # контейнер запустился
    user@local:~/.kube$ kubectl get pod -w
    NAME                                READY   STATUS     RESTARTS   AGE
    dpl-web-with-init-fc7ff5958-x5rcv   0/1     Init:0/1   0          4s
    dpl-web-with-init-fc7ff5958-x5rcv   0/1     PodInitializing   0          63s
    dpl-web-with-init-fc7ff5958-x5rcv   1/1     Running           0          65s
    ```
