# Домашнее задание по теме: «Как работает сеть в K8s»

## Цель задания

Настроить сетевую политику доступа к подам.

## Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

## Результат

1. `K8s` с установленным плагином Calico:
    ```bash
    vagrant@k8s-master01:~$ kubectl get pods -o wide --all-namespaces
    NAMESPACE     NAME                                      READY   STATUS    RESTARTS        AGE   IP              NODE           NOMINATED NODE   READINESS GATES
    kube-system   calico-kube-controllers-648dffd99-s6wzq   1/1     Running   0               10m   10.233.79.65    k8s-worker01   <none>           <none>
    kube-system   calico-node-48gnq                         1/1     Running   0               11m   192.168.0.192   k8s-master01   <none>           <none>
    kube-system   calico-node-f7r25                         1/1     Running   0               11m   192.168.0.194   k8s-worker02   <none>           <none>
    kube-system   calico-node-pf8pt                         1/1     Running   0               11m   192.168.0.193   k8s-worker01   <none>           <none>
    kube-system   coredns-69db55dd76-4pvlz                  1/1     Running   0               10m   10.233.96.129   k8s-master01   <none>           <none>
    kube-system   coredns-69db55dd76-q5htt                  1/1     Running   0               10m   10.233.109.65   k8s-worker02   <none>           <none>
    kube-system   dns-autoscaler-6f4b597d8c-7cbjh           1/1     Running   0               10m   10.233.96.130   k8s-master01   <none>           <none>
    kube-system   kube-apiserver-k8s-master01               1/1     Running   1               12m   192.168.0.192   k8s-master01   <none>           <none>
    kube-system   kube-controller-manager-k8s-master01      1/1     Running   4 (2m16s ago)   12m   192.168.0.192   k8s-master01   <none>           <none>
    kube-system   kube-proxy-622sc                          1/1     Running   0               12m   192.168.0.192   k8s-master01   <none>           <none>
    kube-system   kube-proxy-mpbpd                          1/1     Running   0               12m   192.168.0.194   k8s-worker02   <none>           <none>
    kube-system   kube-proxy-zkbs8                          1/1     Running   0               12m   192.168.0.193   k8s-worker01   <none>           <none>
    kube-system   kube-scheduler-k8s-master01               1/1     Running   3 (2m11s ago)   12m   192.168.0.192   k8s-master01   <none>           <none>
    kube-system   nginx-proxy-k8s-worker01                  1/1     Running   1 (116s ago)    12m   192.168.0.193   k8s-worker01   <none>           <none>
    kube-system   nginx-proxy-k8s-worker02                  1/1     Running   1 (111s ago)    12m   192.168.0.194   k8s-worker02   <none>           <none>
    kube-system   nodelocaldns-l45ms                        1/1     Running   0               10m   192.168.0.193   k8s-worker01   <none>           <none>
    kube-system   nodelocaldns-rpvjr                        1/1     Running   0               10m   192.168.0.194   k8s-worker02   <none>           <none>
    kube-system   nodelocaldns-x6p5v                        1/1     Running   0               10m   192.168.0.192   k8s-master01   <none>           <none>
    ``` 
2. Создаем namespace `app`:
    ```bash
    vagrant@k8s-master01:~/k8s-manifests$ kubectl create namespace app
    namespace/app created
    ```
3. Делаем деплойменты + сервисы и применяем их:
    * [Frontend Deployment + Service](./01_dpl_frontend.yml)
    * [Backend Deployment + Service](./02_dpl_backend.yml)
    * [Cache Deployment + Service](./03_dpl_cache.yml)
    * Применяем:
      ```bash
      vagrant@k8s-master01:~/k8s-manifests$ kubectl apply -f 01_dpl_frontend.yml 
      deployment.apps/frontend created
      service/frontend created
      vagrant@k8s-master01:~/k8s-manifests$ kubectl apply -f 02_dpl_backend.yml
      deployment.apps/backend created
      service/backend created
      vagrant@k8s-master01:~/k8s-manifests$ kubectl apply -f 03_dpl_cache.yml 
      deployment.apps/cache created
      service/cache created

      vagrant@k8s-master01:~/k8s-manifests$ kubectl get pods -o wide -n app
      NAME                        READY   STATUS    RESTARTS   AGE    IP              NODE           NOMINATED NODE   READINESS GATES
      backend-577878f84-sqgvm     1/1     Running   0          62s    10.233.109.66   k8s-worker02   <none>           <none>
      cache-c7d97bdd-m64qj        1/1     Running   0          14s    10.233.79.67    k8s-worker01   <none>           <none>
      frontend-5b945b89c8-v78t9   1/1     Running   0          2m9s   10.233.79.66    k8s-worker01   <none>           <none>

      vagrant@k8s-master01:~/k8s-manifests$ kubectl get svc -o wide -n app
      NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE     SELECTOR
      backend    ClusterIP   10.233.39.110   <none>        80/TCP    3m38s   app=backend
      cache      ClusterIP   10.233.21.149   <none>        80/TCP    2m50s   app=cache
      frontend   ClusterIP   10.233.23.167   <none>        80/TCP    4m45s   app=frontend
      ```
4. Проверяем, что без политик мы можем достучаться с кэша до фронтенда:
    ```bash
    vagrant@k8s-master01:~/k8s-manifests$ kubectl -n app exec -it cache-c7d97bdd-m64qj -- curl frontend
    WBITT Network MultiTool (with NGINX) - frontend-5b945b89c8-v78t9 - 10.233.79.66 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```
5. Применяем [сетевые политики](./04_np_app.yml):
    ```bash
    vagrant@k8s-master01:~/k8s-manifests$ kubectl apply -f 04_np_app.yml 
    networkpolicy.networking.k8s.io/allow-backend-from-frontend created
    networkpolicy.networking.k8s.io/allow-cache-from-backend created
    networkpolicy.networking.k8s.io/deny-all created
    ```
6. Проверяем их работу:
    ```bash
    # frontend -> backend
    vagrant@k8s-master01:~/k8s-manifests$ kubectl -n app exec -it frontend-5b945b89c8-v78t9 -- curl backend
    WBITT Network MultiTool (with NGINX) - backend-577878f84-sqgvm - 10.233.109.66 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

    # backend -> cache
    vagrant@k8s-master01:~/k8s-manifests$ kubectl -n app exec -it backend-577878f84-sqgvm -- curl cache --connect-timeout 5
    WBITT Network MultiTool (with NGINX) - cache-c7d97bdd-m64qj - 10.233.79.67 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

    # backend -> frontend
    vagrant@k8s-master01:~/k8s-manifests$ kubectl -n app exec -it backend-577878f84-sqgvm -- curl frontend --connect-timeout 5
    curl: (28) Failed to connect to frontend port 80 after 5001 ms: Timeout was reached
    command terminated with exit code 28

    # cache -> backend
    vagrant@k8s-master01:~/k8s-manifests$ kubectl -n app exec -it cache-c7d97bdd-m64qj -- curl backend --connect-timeout 5
    curl: (28) Failed to connect to backend port 80 after 5001 ms: Timeout was reached
    command terminated with exit code 28

    # cache -> frontend
    vagrant@k8s-master01:~/k8s-manifests$ kubectl -n app exec -it cache-c7d97bdd-m64qj -- curl frontend --connect-timeout 5
    curl: (28) Failed to connect to frontend port 80 after 5000 ms: Timeout was reached
    command terminated with exit code 28
    ```
