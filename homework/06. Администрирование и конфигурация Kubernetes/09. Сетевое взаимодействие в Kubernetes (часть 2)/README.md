# Домашнее задание по теме: «Сетевое взаимодействие в K8S. Часть 2»

## Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

## Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

## Результат

1. Создание сервиса и Deployment'ов frontend/backend.  
    [Манифест деплойментов и сервиса](./01_dpl_svc-web.yaml)
    ```bash
    user@local:~$ kubectl apply -f /tmp/01_dpl_svc-web.yaml 
    deployment.apps/frontend created
    deployment.apps/backend created
    service/web created
    
    user@local:~$ kubectl get pods -o wide
    NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
    backend-55c6dfdccd-tt7z5    1/1     Running   0          15s   10.1.128.198   microk8s   <none>           <none>
    frontend-676b45b886-5hbp2   1/1     Running   0          15s   10.1.128.197   microk8s   <none>           <none>
    frontend-676b45b886-fxvgt   1/1     Running   0          15s   10.1.128.195   microk8s   <none>           <none>
    frontend-676b45b886-kb6mz   1/1     Running   0          15s   10.1.128.196   microk8s   <none>           <none>
    
    user@local:~$ kubectl get svc -o wide
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE     SELECTOR
    kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP           3m11s   <none>
    web          ClusterIP   10.152.183.127   <none>        80/TCP,8080/TCP   19s     service=web
    
    user@local:~$ kubectl get ep -o wide
    NAME         ENDPOINTS                                                       AGE
    kubernetes   10.128.0.23:16443                                               3m14s
    web          10.1.128.198:8080,10.1.128.195:80,10.1.128.196:80 + 1 more...   22s
    ```
2. Демонстрация доступности приложений между собой через сервис.
    ```bash
    user@local:~$ kubectl exec frontend-676b45b886-5hbp2 -- curl -s web:8080
    WBITT Network MultiTool (with NGINX) - backend-55c6dfdccd-tt7z5 - 10.1.128.198 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    
    user@local:~$ kubectl exec backend-55c6dfdccd-tt7z5 -- curl -s web:80
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

## Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

## Результат

1. Включение Ingress-controller'а в MicroK8S.
    ```bash
    root@microk8s:~# microk8s enable ingress
    Infer repository core for addon ingress
    Enabling Ingress
    ingressclass.networking.k8s.io/public created
    ingressclass.networking.k8s.io/nginx created
    namespace/ingress created
    serviceaccount/nginx-ingress-microk8s-serviceaccount created
    clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
    role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
    clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
    rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
    configmap/nginx-load-balancer-microk8s-conf created
    configmap/nginx-ingress-tcp-microk8s-conf created
    configmap/nginx-ingress-udp-microk8s-conf created
    daemonset.apps/nginx-ingress-microk8s-controller created
    Ingress is enabled
    ```
2. Создание Ingress Nginx.  
    [Манифест ингресса](./02_igs-nginx.yaml)
    ```bash
    user@local:~$ kubectl apply -f /tmp/02_igs-nginx.yaml 
    ingress.networking.k8s.io/ingress-nginx created
    
    user@local:~$ kubectl get ingress -o wide
    NAME            CLASS    HOSTS           ADDRESS     PORTS   AGE
    ingress-nginx   public   k8s.manokh.in   127.0.0.1   80      2m11s
    ```
3. Демонстрация доступности Nginx и Multitool через Ingress.
    ```bash
    [C:\~]$ curl -s k8s.manokh.in/
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
    
    [C:\~]$ curl -s k8s.manokh.in/api
    WBITT Network MultiTool (with NGINX) - backend-55c6dfdccd-tt7z5 - 10.1.128.198 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```
