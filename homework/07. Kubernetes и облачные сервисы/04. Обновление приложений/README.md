# Домашнее задание по теме: «Обновление приложений»

## Цель задания

Выбрать и настроить стратегию обновления приложения.

## Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

## Ответ

Учитывая, что обновление мажорное и новые версии не умеют работать со старыми, обновления по стратегиям `Rolling`/`Canary` не подходят. Т.к. в их случае мы получаем в один момент времени работающие (и принимающие пользовательскую нагрузку) инстансы разных версий.

Оптимальным вариантом вижу стратегию `Blue/Green`, с ее помощью мы можем развернуть необходимое нам количество реплик, и если брать в расчет, то, что при отсутствии трафика ресурсы в полной мере не потребляются, после успешного деплоя и теста на работоспособность - одномоментно переключить весь пользовательский трафик.

Так же есть вариант со стратегией `Recreate`, но в данном случае будет простой для пользователей, и если исходить из описания задачи, данный вариант также не является оптимальным (т.к. пользовательская нагрузка есть всегда).

## Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
4. Откатиться после неудачного обновления.

## Ответ

1. Самым быстрым вариантом обновления (при условии доступности) будет стратегия `Rolling Update` (с максимальным количеством недоступных реплик == 4).
2. [Манифест деплоймента](./01_dpl-web.yml)
3. Применяем манифест:
    ```bash
    vagrant@k8s-master01:~$ kubectl apply -f k8s-manifests/01_dpl-web.yml 
    deployment.apps/web created
    ```
    ```bash
    Every 1.0s: kubectl get pods -o wide                                                                                    k8s-master01: Wed Feb 14 04:32:02 2024
    
    NAME                   READY   STATUS    RESTARTS   AGE   IP              NODE           NOMINATED NODE   READINESS GATES
    web-666bfd9979-2zpnd   2/2     Running   0          8s    10.233.79.82    k8s-worker01   <none>           <none>
    web-666bfd9979-fsmfz   2/2     Running   0          8s    10.233.79.80    k8s-worker01   <none>           <none>
    web-666bfd9979-p99gw   2/2     Running   0          8s    10.233.109.78   k8s-worker02   <none>           <none>
    web-666bfd9979-pjkkg   2/2     Running   0          8s    10.233.109.77   k8s-worker02   <none>           <none>
    web-666bfd9979-wq9kf   2/2     Running   0          8s    10.233.79.81    k8s-worker01   <none>           <none>
    ```
4. Обновляем версию `nginx` в манифесте на `1.20`. Поведение подов в момент обновления (видим что 4 из 5 подов прекратили работу):
    ```bash
    vagrant@k8s-master01:~$ kubectl apply -f k8s-manifests/01_dpl-web.yml 
    deployment.apps/web configured
    ```
    ```bash
    Every 1.0s: kubectl get pods -o wide                                                                                    k8s-master01: Wed Feb 14 04:33:01 2024
    
    NAME                   READY   STATUS              RESTARTS   AGE   IP              NODE           NOMINATED NODE   READINESS GATES
    web-5b99745bc9-4rwkc   0/2     ContainerCreating   0          0s    <none>          k8s-worker01   <none>           <none>
    web-5b99745bc9-5z9b5   0/2     ContainerCreating   0          0s    <none>          k8s-worker02   <none>           <none>
    web-5b99745bc9-pcpdp   0/2     ContainerCreating   0          0s    <none>          k8s-worker01   <none>           <none>
    web-5b99745bc9-tsqwb   0/2     Pending             0          0s    <none>          k8s-worker02   <none>           <none>
    web-5b99745bc9-wh5kz   0/2     ContainerCreating   0          0s    <none>          k8s-worker02   <none>           <none>
    web-666bfd9979-2zpnd   2/2     Terminating         0          67s   10.233.79.82    k8s-worker01   <none>           <none>
    web-666bfd9979-fsmfz   2/2     Running             0          67s   10.233.79.80    k8s-worker01   <none>           <none>
    web-666bfd9979-p99gw   2/2     Terminating         0          67s   10.233.109.78   k8s-worker02   <none>           <none>
    web-666bfd9979-pjkkg   2/2     Terminating         0          67s   10.233.109.77   k8s-worker02   <none>           <none>
    web-666bfd9979-wq9kf   2/2     Terminating         0          67s   10.233.79.81    k8s-worker01   <none>           <none>
    ```
5. Обновление `nginx` до версии `1.28`. Видим, что поды с новой версией nginx не поднялись:
    ```bash
    vagrant@k8s-master01:~$ kubectl apply -f k8s-manifests/01_dpl-web.yml 
    deployment.apps/web configured
    ```
    ```bash
    Every 1.0s: kubectl get pods -o wide                                                                                    k8s-master01: Wed Feb 14 04:35:23 2024
    
    NAME                   READY   STATUS             RESTARTS   AGE     IP              NODE           NOMINATED NODE   READINESS GATES
    web-5b99745bc9-4rwkc   2/2     Running            0          2m22s   10.233.79.83    k8s-worker01   <none>           <none>
    web-64c5d48fcf-4dbg6   1/2     ImagePullBackOff   0          39s     10.233.109.83   k8s-worker02   <none>           <none>
    web-64c5d48fcf-jmj2n   1/2     ImagePullBackOff   0          39s     10.233.79.86    k8s-worker01   <none>           <none>
    web-64c5d48fcf-p7pqt   1/2     ImagePullBackOff   0          39s     10.233.109.82   k8s-worker02   <none>           <none>
    web-64c5d48fcf-plw7z   1/2     ImagePullBackOff   0          38s     10.233.79.87    k8s-worker01   <none>           <none>
    web-64c5d48fcf-vwfd6   1/2     ImagePullBackOff   0          39s     10.233.79.85    k8s-worker01   <none>           <none>
    ```
6. Командой `kubectl rollout undo deployment web` делаем откат на предыдущую версию:
    ```bash
    vagrant@k8s-master01:~$ kubectl rollout undo deployment web
    deployment.apps/web rolled back
    ```
    ```bash
    Every 1.0s: kubectl get pods -o wide                                                                                    k8s-master01: Wed Feb 14 04:37:43 2024
    
    NAME                   READY   STATUS    RESTARTS   AGE     IP              NODE           NOMINATED NODE   READINESS GATES
    web-5b99745bc9-4rwkc   2/2     Running   0          4m42s   10.233.79.83    k8s-worker01   <none>           <none>
    web-5b99745bc9-9kgpf   2/2     Running   0          61s     10.233.79.88    k8s-worker01   <none>           <none>
    web-5b99745bc9-kvc5b   2/2     Running   0          61s     10.233.109.86   k8s-worker02   <none>           <none>
    web-5b99745bc9-lhfds   2/2     Running   0          61s     10.233.109.84   k8s-worker02   <none>           <none>
    web-5b99745bc9-ztn8v   2/2     Running   0          61s     10.233.109.85   k8s-worker02   <none>           <none>
    ```

## Задание 3. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

## Результат

[Полный манифест](./02_full-web.yml)

Описание: созданы конфиг мапы, с помощью `volumeMounts` прицеплены к соответствующим контейнерам. Так же добавлены 2 сервиса и 2 ингресса, во втором добавлена аннотация:
```bash
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "50"
```
с помощью которой обеспечивается распределение 50% нагрузки на второй под.

Применение конфигурации:
```bash
vagrant@k8s-master01:~$ kubectl apply -f k8s-manifests/02_full-web.yml 
configmap/web-v1-cm created
configmap/web-v2-cm created
deployment.apps/web-v1 created
deployment.apps/web-v2 created
service/web-v1-svc created
service/web-v2-svc created
ingress.networking.k8s.io/web-v1-ingress created
ingress.networking.k8s.io/web-v2-ingress created
```
```
vagrant@k8s-master01:~$ kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE     IP               NODE           NOMINATED NODE   READINESS GATES
web-v1-6598bfb6fd-9jsjg   1/1     Running   0          7m47s   10.233.79.127    k8s-worker01   <none>           <none>
web-v1-6598bfb6fd-c4vkm   1/1     Running   0          7m47s   10.233.109.126   k8s-worker02   <none>           <none>
web-v1-6598bfb6fd-rlsbr   1/1     Running   0          7m47s   10.233.79.126    k8s-worker01   <none>           <none>
web-v2-7758f7d8c8-bnczk   1/1     Running   0          7m47s   10.233.109.124   k8s-worker02   <none>           <none>
web-v2-7758f7d8c8-gs6sq   1/1     Running   0          7m47s   10.233.79.66     k8s-worker01   <none>           <none>
web-v2-7758f7d8c8-lwwtt   1/1     Running   0          7m47s   10.233.109.125   k8s-worker02   <none>           <none>
```
```bash
vagrant@k8s-master01:~$ kubectl get ingress -o wide
NAME             CLASS   HOSTS              ADDRESS   PORTS   AGE
web-v1-ingress   nginx   canary.manokh.in             80      8m3s
web-v2-ingress   nginx   canary.manokh.in             80      8m3s
```

Проверка работы весов:
```bash
vagrant@k8s-worker01:~$ curl canary.manokh.in:80/
<html>
<body>
  <h1>Web App v2</h1>
</body>
</html>
vagrant@k8s-worker01:~$ curl canary.manokh.in:80/
<html>
<body>
  <h1>Web App v1</h1>
</body>
</html>
vagrant@k8s-worker01:~$ curl canary.manokh.in:80/
<html>
<body>
  <h1>Web App v2</h1>
</body>
</html>
vagrant@k8s-worker01:~$ curl canary.manokh.in:80/
<html>
<body>
  <h1>Web App v1</h1>
</body>
</html>
```