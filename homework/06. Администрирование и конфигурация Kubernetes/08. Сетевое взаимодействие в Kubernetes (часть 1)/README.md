# Домашнее задание по теме: «Сетевое взаимодействие в K8S. Часть 1»

## Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

## Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

## Результат

1. Создание Deployment с nginx и multitul (3 реплики) и создание сервиса с указанием необходимых таргет портов.  
    [Манифест деплоймента и сервиса](./01_dpl_svc-web.yaml)
    ```bash
    user@local:~$ kubectl apply -f /tmp/01_dpl_svc-web.yaml 
    deployment.apps/dpl-web created
    service/svc-web created
    
    user@local:~$ kubectl get pods -o wide
    NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE   NOMINATED NODE   READINESS GATES
    dpl-web-555f67795b-ft4v7            2/2     Running   0          17s   10.1.77.45   k8s    <none>           <none>
    dpl-web-555f67795b-j4fgk            2/2     Running   0          17s   10.1.77.44   k8s    <none>           <none>
    dpl-web-555f67795b-n2gvs            2/2     Running   0          17s   10.1.77.46   k8s    <none>           <none>
    
    user@local:~$ kubectl get svc
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
    kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             18d
    svc-web      ClusterIP   10.152.183.178   <none>        9001/TCP,9002/TCP   79s
    ```
2. Создание отдельного пода для multitool и демонстрация доступности из него контейнеров.
    ```bash
    user@local:~$ kubectl run multitool-test --image=wbitt/network-multitool
    pod/multitool-test created
    
    user@local:~$ kubectl exec multitool-test -- curl 10.1.77.45:80
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
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   615  100   615    0     0   956k      0 --:--:-- --:--:-- --:--:--  600k

    user@local:~$ kubectl exec multitool-test -- curl 10.1.77.45:8080
    WBITT Network MultiTool (with NGINX) - dpl-web-555f67795b-ft4v7 - 10.1.77.45 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   141  100   141    0     0   258k      0 --:--:-- --:--:-- --:--:--  137k
    ```
3. Проверка доступности по имени сервиса.
    ```bash
    user@local:~$ kubectl exec multitool-test -- curl svc-web:9001
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--<!DOCTYPE html>
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
    100   615  100   615    0     0   476k      0 --:--:-- --:--:-- --:--:--  600k
    
    user@local:~$ kubectl exec multitool-test -- curl svc-web:9002
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   141  100   141    0     0   119k      0 --:--:-- --:--:-- --:--:--  137k
    WBITT Network MultiTool (with NGINX) - dpl-web-555f67795b-ft4v7 - 10.1.77.45 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```

## Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

## Результат

1. Создание сервиса с типом NodePort.  
    [Манифест сервиса](./02_svc_nodeport-web.yaml)
    ```bash
    user@local:~$ kubectl apply -f /tmp/02_svc_nodeport-web.yaml 
    service/svc-web-nodeport created
    
    user@local:~$ kubectl get svc -o wide
    NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE   SELECTOR
    kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP             18d   <none>
    svc-web            ClusterIP   10.152.183.178   <none>        9001/TCP,9002/TCP   26m   app=web
    svc-web-nodeport   NodePort    10.152.183.116   <none>        80:30001/TCP        19s   app=web
    ```
2. Добавляем правило в группе безопасности на порт 30001/TCP.
3. Проверяем доступность Nginx.
    ```bash
    user@local:~$ curl 51.250.74.250:30001
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
    ```
