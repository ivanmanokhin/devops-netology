# Домашнее задание по теме: "Языки разметки JSON и YAML"

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш вариант:
```
{
  "info": "Sample JSON output from our service\t",
  "elements": [
    {
      "name": "first",
      "type": "server",
      "ip": "7175"
    },
    {
      "name": "second",
      "type": "proxy",
      "ip": "71.78.22.43"
    }
  ]
}
```
Какой IP-адрес у первого сервера я не знаю, т.ч. перевел 7175 просто в строку.  

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import click # для парсинга аргументов
import json # для работы с JSON
import os
import socket # для работы с сокетами
import sys
import yaml # для работы с YAML

def check_host(hosts, host):
    '''Функция для проверки текущего IP с прошлыми результатами'''
    
    # проверка на существование файлов с результатами
    if os.path.isfile('./results.json') and os.path.isfile('./results.yaml'):
        pass
    else:
        print('results.[json, yaml] not created')
        sys.exit()

    # проверка на содержание хоста в файле hosts
    with open(hosts, 'r') as hosts:
        if host in hosts.read().split('\n'):
                pass
        else:
            print(f'{host} not in hosts file')
            sys.exit()

    # чтение результатов из файла json
    with open('results.json', 'r') as results_json:
        _dict = {k: v for d in json.load(results_json) for k, v in d.items()}

    # получение текущих результатов
    current_ip = get_ip(host, True)

    # проверка на соответствие 
    if _dict[host] == current_ip[host]:
        print(f'[OK] {host} IP has not changed: {current_ip[host]}')
    else:
        print(f'[ERROR] {host} IP mismatch: {_dict[host]} {current_ip[host]}')

        # изменение IP-адреса для хоста в словаре
        _dict[host] = current_ip[host]
        with open('results.json', 'w') as results_json, open('results.yaml', 'w') as results_yaml:
            json.dump([{h: ip} for h, ip in _dict.items()], results_json, indent=4) # запись в JSON
            yaml.dump([{h: ip} for h, ip in _dict.items()], results_yaml) # запись в YAML
        print(f'{host} IP in result files changed!')


def get_ip(hosts, _check=False):
    '''Функция для получения IP-адресов'''
    # проверка на аргумент _check
    if _check:
        return {hosts: socket.gethostbyname(hosts)}
    else:
        with open(hosts, 'r') as hosts:
            # проход по файлу hosts, создание словаря с результатами (через dict comprehension)
            _dict = {host: socket.gethostbyname(host) for host in hosts.read().splitlines()}

        with open('results.json', 'w') as results_json, open('results.yaml', 'w') as results_yaml:
            json.dump([{h: ip} for h, ip in _dict.items()], results_json, indent=4) # запись в JSON
            yaml.dump([{h: ip} for h, ip in _dict.items()], results_yaml) # запись в YAML

        # вывод результатов в терминал
        [print(f'{host} - {ip}') for host, ip in _dict.items()]

@click.command() # декораторы для click
@click.option('--hosts', type=click.Path(exists=True), required=True, help='Path to hosts file')
@click.option('--check', is_flag=True, show_default=True, default=False, help='URL for check (should be in hosts file)')
@click.argument('host', type=str, required=False)
def main(hosts, check, host=None):
    if check:
        check_host(hosts, host)
    else:
        get_ip(hosts)

if __name__ == '__main__':
    main()
```
Для запуска необходима библиотека click (`pip install click`)  

### Вывод скрипта при запуске при тестировании:
```
root@c03e1f0b3400:/# ./getip.py --help
Usage: getip.py [OPTIONS] [HOST]
Options:
  --hosts PATH  Path to hosts file  [required]
  --check       URL for check (should be in hosts file)  [default: False]
  --help        Show this message and exit.

root@c03e1f0b3400:/# ./getip.py --hosts hosts.txt
drive.google.com - 74.125.131.194
mail.google.com - 142.251.1.18
google.com - 142.250.74.174

root@c03e1f0b3400:/# ./getip.py --hosts hosts.txt --check drive.google.com
[OK] drive.google.com IP has not changed: 74.125.131.194

root@c03e1f0b3400:/# ./getip.py --hosts hosts.txt --check drive.google.com
[ERROR] drive.google.com IP mismatch: 74.125.131.194 142.250.74.174
drive.google.com IP in result files changed!
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[
    {
        "drive.google.com": "142.250.74.174"
    },
    {
        "mail.google.com": "172.217.21.165"
    },
    {
        "google.com": "142.250.74.142"
    }
]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 142.250.74.174
- mail.google.com: 142.251.1.18
- google.com: 142.250.74.174
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
#!/usr/bin/env python3

import click # для парсинга аргументов
import json # для работы с JSON
import os
import sys
import yaml # для работы с YAML

def check_ext(ext):
    '''Функция для проверки расширения файла'''
    ext_tup = ('.json', '.yaml', '.yml')

    if ext not in ext_tup:
        print(f'File extension ({ext}) is not JSON or YAML')
        sys.exit()

def check_content(ext, file):
    '''Функция для проверки содержимого файла'''
    with open(file) as f:
        if ext == '.json': 
            # попытка открыть как JSON
            try:
                print('Trying to open as JSON...')
                data = json.load(f)
                print('Successfully')
                return data, 'json'
            except json.decoder.JSONDecodeError as e:
                print(f'Invalid JSON\n{e}') # возврат строки с ошибкой
            # попытка открыть как YAML
            try:
                print('Trying to open as YAML...')
                data = yaml.safe_load(f)
                print('Successfully')
                return data, 'yml'
            except yaml.YAMLError as e:
                print(f'Invalid YAML\n{e}') # возврат строки с ошибкой
                print(f'File {file} cannot be converted')
                sys.exit()
        else:
            # попытка открыть как YAML
            try:
                print('Trying to open as YAML...')
                data = yaml.safe_load(f)
                print('Successfully')
                return data, 'yml'
            except yaml.YAMLError as e:
                print(f'Invalid YAML\n{e}') # возврат строки с ошибкой
            # попытка открыть как JSON
            try:
                print('Trying to open as JSON...')
                data = json.load(f)
                print('Successfully')
                return data, 'json'
            except json.decoder.JSONDecodeError as e:
                print(f'Invalid JSON\n{e}') # возврат строки с ошибкой
                print(f'File {file} cannot be converted')
                sys.exit()

def convert(data, ext, name):
    '''Функция для конвертации (принимает словарь), записывает в файл'''
    if ext == 'json':
        print('Convert file to YAML...')
        with open(f'{name}.yml', 'w') as yml_file:
            yaml.dump(data, yml_file)
        print(f'File converted, new file: {name}.yml')
    else:
        print('Convert file to JSON')
        with open(f'{name}.json', 'w') as json_file:
            json.dump(data, json_file, indent=4)
        print(f'File converted, new file: {name}.json')

@click.command() # декораторы для click
@click.option('--file', type=click.Path(exists=True), required=True, help='Path to file')
def main(file):
    name, ext = os.path.splitext(file) # передача имени и расширения в отдельные переменные
    check_ext(ext)
    data, ac_ext = check_content(ext, file) # получение содержимого и фактического расширения
    convert(data, ac_ext, name) # конвертация

if __name__ == '__main__':
    main()
```
Скрипт работает не совсем правильно, т.к. вариантов (простых) с валидацией YAML файлов не нашел. Хотел что бы было исключение (как с JSON).  
Также нужна библиотека click.  

### Пример работы скрипта:
```
root@c03e1f0b3400:/# ./convert.py --file example.json
Trying to open as JSON...
Successfully
Convert file to YAML...
File converted, new file: example.yml
```
```
# исходный JSON
{
    "name":"Topology1",
    "description":"This is a topology",
    "environment":"os-single-controller-n-compute",
    "secret_file":"data_bags/example_data_bag_secret",
    "run_sequentially":false,
    "concurrency":10,
    "nodes": [
        {
            "name": "controller",
            "description": "This is the controller node",
            "fqdn":"controllername.company.com",
            "password":"passw0rd",
            "run_order_number":1,
            "quit_on_error":true,
            "chef_client_options": [
                "-i 3600",
                "-s 600"
            ],
            "runlist": [
                "role[ibm-os-single-controller-node]"
            ]
        },
        {
            "name": "KVM qemu compute",
            "description": "This is a KVM qemu compute node",
            "fqdn":"computename.company.com",
            "user":"admin",
            "identity_file":"/root/identity.pem",
            "run_order_number":2,
            "allow_update": false,
            "runlist": [
                "role[ibm-os-compute-node-kvm]"
            ],
            "attributes":"{\"openstack\":{\"compute\":{\"libvirt\":{\"virt_type\":\"qemu\"}}}}"
        }
    ]
}
```
```
# сконвертированный в YAML
concurrency: 10
description: This is a topology
environment: os-single-controller-n-compute
name: Topology1
nodes:
- chef_client_options:
  - -i 3600
  - -s 600
  description: This is the controller node
  fqdn: controllername.company.com
  name: controller
  password: passw0rd
  quit_on_error: true
  run_order_number: 1
  runlist:
  - role[ibm-os-single-controller-node]
- allow_update: false
  attributes: '{"openstack":{"compute":{"libvirt":{"virt_type":"qemu"}}}}'
  description: This is a KVM qemu compute node
  fqdn: computename.company.com
  identity_file: /root/identity.pem
  name: KVM qemu compute
  run_order_number: 2
  runlist:
  - role[ibm-os-compute-node-kvm]
  user: admin
run_sequentially: false
secret_file: data_bags/example_data_bag_secret
```
```
# ошибка в JSON
Trying to open as JSON...
Invalid JSON
Invalid control character at: line 1 column 35 (char 34)
Trying to open as YAML...
None
Successfully
Convert file to JSON
File converted, new file: example.json
```
