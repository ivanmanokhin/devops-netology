# Домашнее задание по теме "Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной c?  | Будет ошибка, т.к. складывать целочисленный тип данных со строковым нельзя.  |
| Как получить для переменной c значение 12?  | c = str(a) + b  |
| Как получить для переменной c значение 3?  | c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status --short"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') == True:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

repo_path = '~/netology/sysadm-homeworks'

bash_command = [f'cd {repo_path}', 'git status']
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'{repo_path}/{prepare_result}')
```
Убрал break, который завершал цикл при первом нахождении строки с modified. Перенес путь до репозитория в отдельную переменную repo_path.  
В выводе, для отображения полного пути, добавил эту переменную к результату.  

### Вывод скрипта при запуске при тестировании:
```
root@c44296d75f36:~# ./check-modified.py
~/netology/sysadm-homeworks/01-intro-01/netology.md
~/netology/sysadm-homeworks/01-intro-01/netology.sh
~/netology/sysadm-homeworks/03-sysadmin-02-terminal/README.md
~/netology/sysadm-homeworks/04-script-01-bash/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

repo_path = '~/netology/sysadm-homeworks'

if len (sys.argv) > 1:
    try:
        os.chdir(sys.argv[1])
        repo_path = sys.argv[1]
    except:
        print(f'Directory {sys.argv[1]} doesn\'t exist')
        sys.exit(1)

bash_command = [f'cd {repo_path}', 'git status']
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'{repo_path}/{prepare_result}')
```
Для работы с аргументами импортировал модуль sys. Сделал проверку на количество аргументов (простую, т.к. интересует только первый).  
Добавил блок try/except в котором проверяется существование директории (если она существует, то переменная repo_path перезаписывается,  
если нет, то выводится сообщение и программа завершается).  

### Вывод скрипта при запуске при тестировании:
```
root@c44296d75f36:~# ./check-modified.py 
~/netology/sysadm-homeworks/01-intro-01/netology.md
~/netology/sysadm-homeworks/01-intro-01/netology.sh
~/netology/sysadm-homeworks/03-sysadmin-02-terminal/README.md
~/netology/sysadm-homeworks/04-script-01-bash/README.md

root@c44296d75f36:~# ./check-modified.py /root/ansible-infra-playbooks
/root/ansible-infra-playbooks/deploy-pagure-repospanner.yml
/root/ansible-infra-playbooks/role-certbot.yml
/root/ansible-infra-playbooks/role-iptables.yml
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import argparse # для парсинга аргументов
import json # для работы с JSON
import os
import socket # для работы с сокетами
import sys

def check_file(path):
    '''Функция для проверки существования файла'''
    if not os.path.exists(path):
        print(f'File {path} does not exist')
        sys.exit(1)

def check_host(hosts, host, results_file):
    '''Функция для проверки текущего IP с прошлыми результатами'''
    with open(hosts, 'r') as hosts: # открытие файла с хостами
        if host in hosts.read(): # поиск необходимого хоста в файле
            with open(results_file, 'r') as results: # открытие файла с результатами
                last_ip = json.loads(results.read()) # получение результатов прошлой проверки
            current_ip = get_ip(host, check=True) # получение текущего IP
            if last_ip[host] == current_ip[host]:
                print(f'[OK] {host} IP address has not changed: {current_ip[host]}') # вывод сообщения в случае если ничего не изменилось
            else:
                print(f'[ERROR] {host} IP mismatch: {last_ip[host]} {current_ip[host]}') # вывод сообщения в случае если изменилось
        else:
            print(f'{host} not in hosts file') # в случае если хост не найден в файле

def get_ip(hosts, results_file='./results.json', check=False):
    '''Функция для получения IP-адресов'''
    if check: # проверка на проверку)
        return {hosts: socket.gethostbyname(hosts)} # возврат словаря с одним значением
    else:
        with open(hosts, 'r') as hosts: # открытие файла hosts на запись, в dict comprehension получение IP-адресов
            _dict = {host: socket.gethostbyname(host) for host in hosts.read().splitlines()} 
        [print(f'{host} - {ip}') for host, ip in _dict.items()] # в list comprehension вывод результатов в консоль
        with open('results_file', 'w') as results: # запись результатов в файл json
            results.write(json.dumps(_dict))

if __name__ == '__main__':
    # парсинг аргументов
    parser = argparse.ArgumentParser(description='Get host IP script')
    parser.add_argument("--hosts", dest="hosts", required=True, help="Path to hosts file")
    parser.add_argument("--check", dest="check", type=str, help="URL for check (should be in hosts file)")
    args = parser.parse_args()

    # проверка существования файла с хостами
    check_file(args.hosts)

    # путь до файла с результатами
    results_file = './results.json'

    # проверка на аргумент check
    if args.check is not None:
        check_file(results_file) # проверка файла с прошлыми результатами
        check_host(args.hosts, args.check, results_file) # запуск функции с проверкой
    else:
        get_ip(args.hosts) # запуск функции с получением IP-адресов
```
В принципе все описал в комментариях к коду.  

### Вывод скрипта при запуске при тестировании:
```
root@c44296d75f36:~# ./getip.py --help
usage: getip.py [-h] --hosts HOSTS [--check CHECK]
Get host IP script
options:
  -h, --help     show this help message and exit
  --hosts HOSTS  Path to hosts file
  --check CHECK  URL for check (should be in hosts file)

root@c44296d75f36:~# ./getip.py --hosts hosts.txt1 # если файла с хостами не существует
File hosts.txt1 does not exist

root@c44296d75f36:~# ./getip.py --hosts hosts.txt 
drive.google.com - 142.250.68.174
mail.google.com - 142.250.113.18
google.com - 142.251.116.139

root@c44296d75f36:~# ./getip.py --hosts hosts.txt --check mail.google.com
[OK] mail.google.com IP address has not changed: 142.250.113.18
root@c44296d75f36:~# ./getip.py --hosts hosts.txt --check mail.google.com
[ERROR] mail.google.com IP mismatch: 142.250.113.18 142.250.187.165

root@c44296d75f36:~# ./getip.py --hosts hosts.txt --check mail.google.com # если файла results.json нет
File ./results.json does not exist
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
#!/usr/bin/env python3

import click # для парсинга аргументов
from git import Repo # для работы с git'ом
import json
import requests

def git_push(repo, msg, br):
    '''Функция для git add|commit|checkout|push'''
    repo.git.add(all = True)
    repo.index.commit(msg)
    repo.git.checkout('-b', br)
    repo.git.push('--set-upstream', 'origin', br)
    print('Push was successful')

def create_pull_request(cred, br, rqst):
    '''Функция для отправки pull request (через API GitHub)'''
    with open(cred, 'r') as file:
        # открытие файла с названием репозитория, владельцем и токеном. присваивание значения переменным
        _dict = json.loads(file.read())
        repo = _dict['repo']
        owner = _dict['owner']
        token = 'token ' + _dict['token']
    url = f'https://api.github.com/repos/{owner}/{repo}/pulls'
    headers = {'Authorization': token, 'Content-Type': 'application/json'} # заголовки для POST-запроса
    data = {'title': rqst, 'base': 'main', 'head': br} # полезная нагрузка)
    response = requests.post(url, headers=headers, data=json.dumps(data)) # POST-запрос к API GitHub
    if response.ok:
        print('Pull request successfully created')
    else:
        print('Error :(')

@click.command() # декораторы для click
@click.option('--path', type=click.Path(exists=True), required=True, help='Path to repository')
@click.option('--cred', type=click.Path(exists=True), required=True, help='Path to credentials file')
@click.option('--msg', type=str, required=True, help='Commit message')
@click.option('--br', type=str, required=True, help='New branch name')
@click.option('--rqst', type=str, required=True, help='Request title')
def main(path, cred, msg, br, rqst):
    git_push(Repo(path), msg, br)
    create_pull_request(cred, br, rqst)
    
if __name__ == '__main__':
    main()
```
Предварительно установить библиотеки `pip install click GitPython`.  
Пример требуемого JSON файла с реквизитами:  
```
{
  "repo": "test-git",
  "owner": "manokhinivan",
  "token": "xxx_zzzyyy"
}
```

### Вывод скрипта при запуске при тестировании:
```
root@c44296d75f36:~# ./git-script.py --help
Usage: git-script.py [OPTIONS]

Options:
  --path PATH  Path to repository  [required]
  --cred PATH  Path to credentials file  [required]
  --msg TEXT   Commit message  [required]
  --br TEXT    New branch name  [required]
  --rqst TEXT  Request title  [required]
  --help       Show this message and exit.

root@c44296d75f36:~# ./git-script.py --path test-git/ --cred cred.json --msg "T3ST COMMIT" --br NEW-T3ST-BRANCH --rqst "T3ST REQUEST TITLE"
Push was successful
Pull request successfully created
```
