# Домашнее задание по теме: «Хранение в K8s. Часть 1»

## Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

## Задание 1. Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

## Результат

1. Создание деплоймента с busybox и multitool.  
    [Манифест деплоймента](./01_dpl-bb.yaml)
    ```bash
    user@local:/$ kubectl apply -f /tmp/01-dpl-bb.yaml 
    deployment.apps/dpl-bb created
    
    user@local:/$ kubectl get pods -o wide
    NAME                      READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
    dpl-bb-5f864fcb7b-d9tv8   2/2     Running   0          18s   10.1.128.209   microk8s   <none>           <none>
    ```
2. busybox пишет в /input/log (конфигурация в деплойменте).
3. Демонстрация чтения файла из multitool.
    ```bash
    user@local:/$ kubectl exec -it dpl-bb-5f864fcb7b-d9tv8 --container='multitool' -- tail -f /output/log
    Mon Feb 5 20:20:44 UTC 2024 ping
    Mon Feb 5 20:20:49 UTC 2024 ping
    Mon Feb 5 20:20:54 UTC 2024 ping
    Mon Feb 5 20:20:59 UTC 2024 ping
    Mon Feb 5 20:21:04 UTC 2024 ping
    ```

## Задание 2. Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

## Результат

1. Создание демонсета состоящего из multitool.  
    [Манифест демонсета](./02_ds-mt.yaml)
    ```bash
    user@local:/$ kubectl apply -f /tmp/02-ds-mt.yaml 
    daemonset.apps/ds-mt created
    
    user@local:/$ kubectl get pods -o wide
    NAME          READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
    ds-mt-4vq7l   1/1     Running   0          13s   10.1.128.211   microk8s   <none>           <none>
    ```
2. Демонстрация возможности чтения подом syslog'а ноды.
    ```bash
    user@local:/$ kubectl exec -it ds-mt-4vq7l --container='multitool' -- tail -f /node-syslog
    Feb  5 20:30:27 microk8s microk8s.daemon-containerd[789]: time="2024-02-05T20:30:27.481347193Z" level=info msg="ImageUpdate event &ImageUpdate{Name:docker.io/wbitt/network-multitool:latest,Labels:map[string]string{io.cri-containerd.image: managed,},XXX_unrecognized:[],}"
    Feb  5 20:30:27 microk8s microk8s.daemon-containerd[789]: time="2024-02-05T20:30:27.485469966Z" level=info msg="ImageUpdate event &ImageUpdate{Name:sha256:713337546be623588ed8ffd6d5e15dd3ccde8e4555ac5c97e5715d03580d2824,Labels:map[string]string{io.cri-containerd.image: managed,},XXX_unrecognized:[],}"
    Feb  5 20:30:27 microk8s microk8s.daemon-containerd[789]: time="2024-02-05T20:30:27.491607902Z" level=info msg="ImageUpdate event &ImageUpdate{Name:docker.io/wbitt/network-multitool:latest,Labels:map[string]string{io.cri-containerd.image: managed,},XXX_unrecognized:[],}"
    ```
