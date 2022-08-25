# Домашнее задание по теме: "Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

**Ответ:**

1. IaaC позволяет абстрагироваться от инфраструктуры как таковой. При применении этого подхода все операции производятся с файлами конфигураций, которые хранятся в одном месте и имеют историю изменений, это позволяет избежать дрейфа конфигураций, автоматизировать большинство процессов. Помимо всего этого это полезно с точки зрения описания самой инфраструктуры, т.к. дать ссылку на Git-репозиторий гораздо проще и быстрее чем объяснять как все устроено.
2. Идемпотентность - получение того же результата при повторном выполнении операции.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

**Ответ:**

1. Open Source, использование YAML для описания требуемого состояния (декларативный подход), не требует установки клиентов на хосты, относительно простой с точки зрения изучения, огромная библиотека модулей и готовых плейбуков, а если чего-то не хватает - возможность расширять функционал за счет простого и понятного Python.

2. Более надежным считаю метод Pull, т.к. при его применении не важно в каком состоянии в данный момент клиентский хост (доступен ли он, нет ли проблем с сетью и т.д.). Как только хост будет доступен - он сам заберет и применит требуемую конфигурацию. Метод Push требует что-бы клиент был доступен в момент выполнения операции, но в принципе для этого есть обходные пути, такие как срабатывание операции по определенному триггеру (допустим на основе данных из мониторинга можно автоматизировать запуск плейбука, либо же Ansible AWX).

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

**Ответ:** в связи с тем, что я использую Windows и WSL мне пришлось отказаться от VirtualBox, т.к. при включенном WSL он использует программную виртуализацию, при которой [невозможно нормально работать](https://github.com/MicrosoftDocs/WSL/issues/798). От Windows и WSL я отказаться не могу. Использую связку Hyper-V + WSL (на нем проброшенный Vagrant и Ansible в Virtualenv). Единственное, что придется немного править конфиги, но это не страшно =). Поскольку vagrant не позволяет применять настройки сети для Hyper-V для нормальной работы Ansible использую Vagrant Hostmanager:

`vagrant plugin install vagrant-hostmanager`

Hyper-V Version:
```
PS G:\vagrant-project> $fpath = "c:\windows\system32\vmms.exe"
PS G:\vagrant-project> [System.Diagnostics.FileVersionInfo]::GetVersionInfo($fpath) | Format-List -property *

FileVersionRaw     : 10.0.22000.856
ProductVersionRaw  : 10.0.22000.856
Comments           : 
CompanyName        : Microsoft Corporation
FileBuildPart      : 22000
FileDescription    : Служба управления виртуальными машинами
FileMajorPart      : 10
FileMinorPart      : 0
FileName           : c:\windows\system32\vmms.exe
FilePrivatePart    : 856
FileVersion        : 10.0.22000.856 (WinBuild.160101.0800)
InternalName       : Virtual Machine Management Service
IsDebug            : False
IsPatched          : False
IsPrivateBuild     : False
IsPreRelease       : False
IsSpecialBuild     : False
Language           : Русский (Россия)
LegalCopyright     : © Корпорация Майкрософт (Microsoft Corp.). Все права защищены.
LegalTrademarks    :
OriginalFilename   : vmms.exe.mui
PrivateBuild       :
ProductBuildPart   : 22000
ProductMajorPart   : 10
ProductMinorPart   : 0
ProductName        : Операционная система Microsoft® Windows®
ProductPrivatePart : 856
ProductVersion     : 10.0.22000.856
SpecialBuild       :
```

Vagrant Version:
```
[manokhin@DESKTOP:.../vagrant()]vagrant version

Installed Version: 2.3.0
Latest Version: 2.3.0

You're running an up-to-date version of Vagrant!
```

Ansible Version:
```
ansible --version

(ansible-6.3) [manokhin@DESKTOP:.../vagrant()]ansible [core 2.13.3]
  config file = /mnt/g/vagrant-project/vagrant-ansible-netology/vagrant/ansible.cfg
  configured module search path = ['/home/manokhin/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/manokhin/ansible-venv/ansible-6.3/lib/python3.10/site-packages/ansible
  ansible collection location = /home/manokhin/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/manokhin/ansible-venv/ansible-6.3/bin/ansible
  python version = 3.10.4 (main, Jun 29 2022, 12:14:53) [GCC 11.2.0]
  jinja version = 3.1.2
  libyaml = True
```
## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

**Ответ:**

```
(ansible-6.3) [manokhin@DESKTOP:.../vagrant()]vagrant up                                                                                                                                                                    
Bringing machine 'server1.netology' up with 'hyperv' provider...
==> server1.netology: Verifying Hyper-V is enabled...
==> server1.netology: Verifying Hyper-V is accessible...
==> server1.netology: Importing a Hyper-V instance
    server1.netology: Creating and registering the VM...
    server1.netology: Successfully imported VM
    server1.netology: Configuring the VM...
    server1.netology: Setting VM Enhanced session transport type to disabled/default (VMBus)
==> server1.netology: Starting the machine...
==> server1.netology: Waiting for the machine to report its IP address...
    server1.netology: Timeout: 120 seconds
    server1.netology: IP: 172.17.193.86
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 172.17.193.86:22
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection refused. Retrying...
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Setting hostname...
==> server1.netology: Rsyncing folder: /mnt/g/vagrant-project/vagrant-ansible-netology/vagrant/ => /vagrant
==> server1.netology: [vagrant-hostmanager:guests] Updating hosts file on active guest virtual machines...
==> server1.netology: [vagrant-hostmanager:host] Updating hosts file on your workstation (password may be required)...
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
changed: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=git)
ok: [server1.netology] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

(ansible-6.3) [manokhin@DESKTOP:.../vagrant()]vagrant ssh
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-37-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu 25 Aug 2022 06:58:14 PM UTC

  System load:  0.35              Processes:                107
  Usage of /:   3.4% of 61.31GB   Users logged in:          0
  Memory usage: 24%               IPv4 address for docker0: 172.18.0.1
  Swap usage:   0%                IPv4 address for eth0:    172.17.193.86


298 updates can be installed immediately.
190 of these updates are security updates.
To see these additional updates run: apt list --upgradable



This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Thu Aug 25 18:56:42 2022 from 172.17.155.187
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```