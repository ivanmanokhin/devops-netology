# Домашнее задание по теме: «Базовые объекты K8S»

## Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера.

## Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

## Результат

1. [Манифест пода](./01_pod_echoserver.yaml)
2. Применение конфигурации
  ```bash
  user@local:/tmp$ kubectl apply -f /tmp/01_pod_echoserver.yaml 
  pod/pod-echoserver-default created
  user@local:/tmp$ kubectl get pods -o wide
  NAME                     READY   STATUS    RESTARTS   AGE     IP          NODE   NOMINATED NODE   READINESS GATES
  pod-echoserver-default   1/1     Running   0          3m47s   10.1.77.5   k8s    <none>           <none>
  ```
3. Локальное подключение к pod с помощью `port-forward`
  ```bash
  user@local:/tmp$ kubectl port-forward pod/pod-echoserver-default 8080:8080
  Forwarding from 127.0.0.1:8080 -> 8080
  Forwarding from [::1]:8080 -> 8080
  Handling connection for 8080

  # в другой bash сессии
  user@local:~$ curl localhost:8080
  
  
  Hostname: pod-echoserver-default
  
  Pod Information:
  	-no pod information available-
  
  Server values:
  	server_version=nginx: 1.12.2 - lua: 10010
  
  Request Information:
  	client_address=127.0.0.1
  	method=GET
  	real path=/
  	query=
  	request_version=1.1
  	request_scheme=http
  	request_uri=http://localhost:8080/
  
  Request Headers:
  	accept=*/*  
  	host=localhost:8080  
  	user-agent=curl/7.81.0  
  
  Request Body:
  	-no body in request-
  ```

## Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

## Результат

1. [Манифест пода](./02_pod_netology-web.yaml), [Манифест сервиса](./03_svc_netology-svc.yaml)
2. Применение конфигурации и проверка эндпоинтов:
  ```bash
  user@local:/tmp$ kubectl apply -f /tmp/02_pod_netology-web.yaml 
  pod/netology-web created
  user@local:/tmp$ kubectl apply -f /tmp/03_svc_netology-svc.yaml 
  service/netology-svc created
  user@local:/tmp$ kubectl get pods -o wide
  NAME           READY   STATUS    RESTARTS   AGE     IP          NODE   NOMINATED NODE   READINESS GATES
  netology-web   1/1     Running   0          2m20s   10.1.77.7   k8s    <none>           <none>
  user@local:/tmp$ kubectl get service -o wide
  NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE   SELECTOR
  kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   37m   <none>
  netology-svc   ClusterIP   10.152.183.118   <none>        80/TCP    9m    app=echoserver
  user@local:/tmp$ kubectl describe svc netology-svc
  Name:              netology-svc
  Namespace:         default
  Labels:            <none>
  Annotations:       <none>
  Selector:          app=echoserver
  Type:              ClusterIP
  IP Family Policy:  SingleStack
  IP Families:       IPv4
  IP:                10.152.183.118
  IPs:               10.152.183.118
  Port:              http  80/TCP
  TargetPort:        es/TCP
  Endpoints:         10.1.77.7:8080
  Session Affinity:  None
  Events:            <none>
  user@local:/tmp$ kubectl port-forward svc/netology-svc 8080:80
  Forwarding from 127.0.0.1:8080 -> 8080
  Forwarding from [::1]:8080 -> 8080
  ```
3. Локальное подключение к сервису с помощью `port-forward`:

  ```bash
  user@local:/tmp$ kubectl port-forward svc/netology-svc 8080:80
  Forwarding from 127.0.0.1:8080 -> 8080
  Forwarding from [::1]:8080 -> 8080
  Handling connection for 8080
  
  # в другой bash сессии
  user@local:~$ curl localhost:8080
  
  
  Hostname: netology-web
  
  Pod Information:
  	-no pod information available-
  
  Server values:
  	server_version=nginx: 1.12.2 - lua: 10010
  
  Request Information:
  	client_address=127.0.0.1
  	method=GET
  	real path=/
  	query=
  	request_version=1.1
  	request_scheme=http
  	request_uri=http://localhost:8080/
  
  Request Headers:
  	accept=*/*  
  	host=localhost:8080  
  	user-agent=curl/7.81.0  
  
  Request Body:
  	-no body in request-
  
  ```
