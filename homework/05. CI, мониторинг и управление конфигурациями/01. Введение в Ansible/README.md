# Домашнее задание по теме: "Введение в Ansible"

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

    ### Результат:
    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    >ansible-playbook -i inventory/test.yml site.yml
    
    PLAY [Print os facts] ************************************************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************************
    ok: [localhost]
    
    TASK [Print OS] ******************************************************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ****************************************************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "12"
    }
    
    PLAY RECAP ***********************************************************************************************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

    ### Результат:

    Переменная задается в файле group_var/all/examp.yml
    
    Результат с измененной переменной:

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    >ansible-playbook -i inventory/test.yml site.yml
    
    PLAY [Print os facts] ************************************************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************************
    ok: [localhost]
    
    TASK [Print OS] ******************************************************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ****************************************************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "all default fact"
    }
    
    PLAY RECAP ***********************************************************************************************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

    ### Результат:

    ```shell
    docker run -dt --name centos7 centos:centos7
    docker run -dt --name ubuntu ubuntu:latest
    ```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

    ### Результат:

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ ansible-playbook -i inventory/prod.yml site.yml
    
    PLAY [Print os facts] ************************************************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ******************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ****************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el"
    }
    ok: [ubuntu] => {
        "msg": "deb"
    }
    
    PLAY RECAP ***********************************************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

    ### Результат:

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ ansible-playbook -i inventory/prod.yml site.yml
    
    PLAY [Print os facts] ************************************************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ******************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ****************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    
    PLAY RECAP ***********************************************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

    ### Результат:

    ```shell
    ansible-vault encrypt group_vars/deb/examp.yml
    ansible-vault encrypt group_vars/el/examp.yml
    ```

9.  Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

    ### Результат:

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
    Vault password:
    
    PLAY [Print os facts] ************************************************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ******************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ****************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    
    PLAY RECAP ***********************************************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

10. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

    ### Результат:

    ```shell
    $ ansible-doc -t connection -l |grep "on control"
    ansible.builtin.local          execute on controller
    ```

11. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

    ### Результат:

    ```shell
    $ cat inventory/prod.yml
    ---
      el:
        hosts:
          centos7:
            ansible_connection: docker
      deb:
        hosts:
          ubuntu:
            ansible_connection: docker
      local:
        hosts:
          localhost:
            ansible_connection: local
    ```

12. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

    ### Результат:

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
    Vault password:
    
    PLAY [Print os facts] ***************************************************************************************************************************************************
    
    TASK [Gathering Facts] **************************************************************************************************************************************************
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] *********************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] *******************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [localhost] => {
        "msg": "all default fact"
    }
    
    PLAY RECAP **************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

    ### Результат:

    ```shell
    ansible-vault decrypt group_vars/el/examp.yml
    ansible-vault decrypt group_vars/deb/examp.yml
    ```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

    ### Результат:

    ```shell
    $ ansible-vault encrypt_string
    New Vault password:
    Confirm New Vault password:
    Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
    PaSSw0rd
    Encryption successful
    !vault |
              $ANSIBLE_VAULT;1.1;AES256
              37323938326139333431383032663362616339346263646635303461363931363033393066653439
              3366653364356336303937636231306636393865303361660a386463633132336264383835353236
              64363739306530386632623530623733646130336535613030353336313731653566326466383734
              3632313433643364390a313536363264643031336462303033333139333564386435656230396130
              3639
    ```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

    ### Результат:

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
    Vault password:
    
    PLAY [Print os facts] ************************************************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************************
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ******************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ****************************************************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [localhost] => {
        "msg": "PaSSw0rd"
    }
    
    PLAY RECAP ***********************************************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

    ### Результат:

    ```shell
    $ cat inventory/prod.yml
    ---
      el:
        hosts:
          centos7:
            ansible_connection: docker
      deb:
        hosts:
          ubuntu:
            ansible_connection: docker
      local:
        hosts:
          localhost:
            ansible_connection: local
      fedora:
        hosts:
          fedora:
            ansible_connection: docker
    ```

    ```shell
    docker run -dt --name fedora fedora:latest
    ```

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
    Vault password:
    [WARNING]: Found both group and host with same name: fedora
    
    PLAY [Print os facts] ***************************************************************************************************************************************************
    
    TASK [Gathering Facts] **************************************************************************************************************************************************
    ok: [localhost]
    ok: [ubuntu]
    ok: [fedora]
    ok: [centos7]
    
    TASK [Print OS] *********************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    ok: [fedora] => {
        "msg": "Fedora"
    }
    
    TASK [Print fact] *******************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [fedora] => {
        "msg": "fedora default fact"
    }
    ok: [localhost] => {
        "msg": "PaSSw0rd"
    }
    
    PLAY RECAP **************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    </details>

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

    ### Результат:

    ```shell
    #!/usr/bin/env bash
    
    set -e
    
    array=(ubuntu centos7 fedora)
    
    for item in ${array[*]}
    do
        if [[ "$item" == "centos7" ]]; then
            docker run -dt --name $item centos:$item
        else
            docker run -dt --name $item $item:latest
            if [[ "$item" == "ubuntu" ]]; then
                docker exec ubuntu /bin/bash -c 'apt update && apt install python3 -y'
            fi
        fi
    done
    
    ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --vault-password-file ./secret.file
    
    for item in ${array[*]}
    do
        docker stop $item
        docker container rm $item
    done
    ```

    <details>
      <summary>Результат выполнения плейбука</summary>

    ```shell
    $ bash automate.sh
    Unable to find image 'ubuntu:latest' locally
    latest: Pulling from library/ubuntu
    6e3729cf69e0: Pull complete
    Digest: sha256:27cb6e6ccef575a4698b66f5de06c7ecd61589132d5a91d098f7f3f9285415a9
    Status: Downloaded newer image for ubuntu:latest
    cba3beb935ee8874d4343a8fb5340c260741737f05223bbb899444bda570b587
    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    
    Get:1 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
    Get:2 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
    Get:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [114 kB]
    Get:4 http://archive.ubuntu.com/ubuntu jammy-backports InRelease [99.8 kB]
    Get:5 http://archive.ubuntu.com/ubuntu jammy/main amd64 Packages [1792 kB]
    Get:6 http://archive.ubuntu.com/ubuntu jammy/multiverse amd64 Packages [266 kB]
    Get:7 http://archive.ubuntu.com/ubuntu jammy/restricted amd64 Packages [164 kB]
    Get:8 http://archive.ubuntu.com/ubuntu jammy/universe amd64 Packages [17.5 MB]
    Get:9 http://security.ubuntu.com/ubuntu jammy-security/multiverse amd64 Packages [4732 B]
    Get:10 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [791 kB]
    Get:11 http://archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [998 kB]
    Get:12 http://archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [730 kB]
    Get:13 http://archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 Packages [8978 B]
    Get:14 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [1054 kB]
    Get:15 http://archive.ubuntu.com/ubuntu jammy-backports/main amd64 Packages [3520 B]
    Get:16 http://archive.ubuntu.com/ubuntu jammy-backports/universe amd64 Packages [7286 B]
    Get:17 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [681 kB]
    Get:18 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [738 kB]
    Fetched 25.3 MB in 2s (11.8 MB/s)
    Reading package lists...
    Building dependency tree...
    Reading state information...
    All packages are up to date.
    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    
    Reading package lists...
    Building dependency tree...
    Reading state information...
    The following additional packages will be installed:
      libexpat1 libmpdec3 libpython3-stdlib libpython3.10-minimal
      libpython3.10-stdlib libreadline8 libsqlite3-0 media-types python3-minimal
      python3.10 python3.10-minimal readline-common
    Suggested packages:
      python3-doc python3-tk python3-venv python3.10-venv python3.10-doc binutils
      binfmt-support readline-doc
    The following NEW packages will be installed:
      libexpat1 libmpdec3 libpython3-stdlib libpython3.10-minimal
      libpython3.10-stdlib libreadline8 libsqlite3-0 media-types python3
      python3-minimal python3.10 python3.10-minimal readline-common
    0 upgraded, 13 newly installed, 0 to remove and 0 not upgraded.
    Need to get 6494 kB of archives.
    After this operation, 23.4 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libpython3.10-minimal amd64 3.10.6-1~22.04.2 [810 kB]
    Get:2 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libexpat1 amd64 2.4.7-1ubuntu0.2 [91.0 kB]
    Get:3 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 python3.10-minimal amd64 3.10.6-1~22.04.2 [2251 kB]
    Get:4 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 python3-minimal amd64 3.10.6-1~22.04 [24.3 kB]
    Get:5 http://archive.ubuntu.com/ubuntu jammy/main amd64 media-types all 7.0.0 [25.5 kB]
    Get:6 http://archive.ubuntu.com/ubuntu jammy/main amd64 libmpdec3 amd64 2.5.1-2build2 [86.8 kB]
    Get:7 http://archive.ubuntu.com/ubuntu jammy/main amd64 readline-common all 8.1.2-1 [53.5 kB]
    Get:8 http://archive.ubuntu.com/ubuntu jammy/main amd64 libreadline8 amd64 8.1.2-1 [153 kB]
    Get:9 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libsqlite3-0 amd64 3.37.2-2ubuntu0.1 [641 kB]
    Get:10 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libpython3.10-stdlib amd64 3.10.6-1~22.04.2 [1832 kB]
    Get:11 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 python3.10 amd64 3.10.6-1~22.04.2 [497 kB]
    Get:12 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libpython3-stdlib amd64 3.10.6-1~22.04 [6910 B]
    Get:13 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 python3 amd64 3.10.6-1~22.04 [22.8 kB]
    debconf: delaying package configuration, since apt-utils is not installed
    Fetched 6494 kB in 1s (10.5 MB/s)
    Selecting previously unselected package libpython3.10-minimal:amd64.
    (Reading database ... 4395 files and directories currently installed.)
    Preparing to unpack .../libpython3.10-minimal_3.10.6-1~22.04.2_amd64.deb ...
    Unpacking libpython3.10-minimal:amd64 (3.10.6-1~22.04.2) ...
    Selecting previously unselected package libexpat1:amd64.
    Preparing to unpack .../libexpat1_2.4.7-1ubuntu0.2_amd64.deb ...
    Unpacking libexpat1:amd64 (2.4.7-1ubuntu0.2) ...
    Selecting previously unselected package python3.10-minimal.
    Preparing to unpack .../python3.10-minimal_3.10.6-1~22.04.2_amd64.deb ...
    Unpacking python3.10-minimal (3.10.6-1~22.04.2) ...
    Setting up libpython3.10-minimal:amd64 (3.10.6-1~22.04.2) ...
    Setting up libexpat1:amd64 (2.4.7-1ubuntu0.2) ...
    Setting up python3.10-minimal (3.10.6-1~22.04.2) ...
    Selecting previously unselected package python3-minimal.
    (Reading database ... 4697 files and directories currently installed.)
    Preparing to unpack .../0-python3-minimal_3.10.6-1~22.04_amd64.deb ...
    Unpacking python3-minimal (3.10.6-1~22.04) ...
    Selecting previously unselected package media-types.
    Preparing to unpack .../1-media-types_7.0.0_all.deb ...
    Unpacking media-types (7.0.0) ...
    Selecting previously unselected package libmpdec3:amd64.
    Preparing to unpack .../2-libmpdec3_2.5.1-2build2_amd64.deb ...
    Unpacking libmpdec3:amd64 (2.5.1-2build2) ...
    Selecting previously unselected package readline-common.
    Preparing to unpack .../3-readline-common_8.1.2-1_all.deb ...
    Unpacking readline-common (8.1.2-1) ...
    Selecting previously unselected package libreadline8:amd64.
    Preparing to unpack .../4-libreadline8_8.1.2-1_amd64.deb ...
    Unpacking libreadline8:amd64 (8.1.2-1) ...
    Selecting previously unselected package libsqlite3-0:amd64.
    Preparing to unpack .../5-libsqlite3-0_3.37.2-2ubuntu0.1_amd64.deb ...
    Unpacking libsqlite3-0:amd64 (3.37.2-2ubuntu0.1) ...
    Selecting previously unselected package libpython3.10-stdlib:amd64.
    Preparing to unpack .../6-libpython3.10-stdlib_3.10.6-1~22.04.2_amd64.deb ...
    Unpacking libpython3.10-stdlib:amd64 (3.10.6-1~22.04.2) ...
    Selecting previously unselected package python3.10.
    Preparing to unpack .../7-python3.10_3.10.6-1~22.04.2_amd64.deb ...
    Unpacking python3.10 (3.10.6-1~22.04.2) ...
    Selecting previously unselected package libpython3-stdlib:amd64.
    Preparing to unpack .../8-libpython3-stdlib_3.10.6-1~22.04_amd64.deb ...
    Unpacking libpython3-stdlib:amd64 (3.10.6-1~22.04) ...
    Setting up python3-minimal (3.10.6-1~22.04) ...
    Selecting previously unselected package python3.
    (Reading database ... 5126 files and directories currently installed.)
    Preparing to unpack .../python3_3.10.6-1~22.04_amd64.deb ...
    Unpacking python3 (3.10.6-1~22.04) ...
    Setting up media-types (7.0.0) ...
    Setting up libsqlite3-0:amd64 (3.37.2-2ubuntu0.1) ...
    Setting up libmpdec3:amd64 (2.5.1-2build2) ...
    Setting up readline-common (8.1.2-1) ...
    Setting up libreadline8:amd64 (8.1.2-1) ...
    Setting up libpython3.10-stdlib:amd64 (3.10.6-1~22.04.2) ...
    Setting up libpython3-stdlib:amd64 (3.10.6-1~22.04) ...
    Setting up python3.10 (3.10.6-1~22.04.2) ...
    Setting up python3 (3.10.6-1~22.04) ...
    running python rtupdate hooks for python3.10...
    running python post-rtupdate hooks for python3.10...
    Processing triggers for libc-bin (2.35-0ubuntu3.1) ...
    Unable to find image 'centos:centos7' locally
    centos7: Pulling from library/centos
    2d473b07cdd5: Pull complete
    Digest: sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
    Status: Downloaded newer image for centos:centos7
    9a2a41e2e7ad54c2eceb20565c3998937bf64264d3400c070cb63d5cac0eb8ce
    Unable to find image 'fedora:latest' locally
    latest: Pulling from library/fedora
    cd974119263e: Pull complete
    Digest: sha256:3487c98481d1bba7e769cf7bcecd6343c2d383fdd6bed34ec541b6b23ef07664
    Status: Downloaded newer image for fedora:latest
    f63d4b9f715a134b137a3fadf4d87958cacecfffc060866c528fe3e2c4424cff
    [WARNING]: Found both group and host with same name: fedora
    
    PLAY [Print os facts] ***************************************************************************************************************************************************
    
    TASK [Gathering Facts] **************************************************************************************************************************************************
    ok: [localhost]
    ok: [fedora]
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] *********************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    ok: [fedora] => {
        "msg": "Fedora"
    }
    
    TASK [Print fact] *******************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [fedora] => {
        "msg": "fedora default fact"
    }
    ok: [localhost] => {
        "msg": "PaSSw0rd"
    }
    
    PLAY RECAP **************************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    
    ubuntu
    ubuntu
    centos7
    centos7
    fedora
    fedora
    ```
    </details>

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

    ### Результат:

    [playbook](./playbook/)
    