# Домашнее задание по теме: "Работа с roles"

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

---

2. При помощи `ansible-galaxy` скачайте себе эту роль.

#### Результат:

```bash
> ansible-galaxy install -r requirements.yml --force
Starting galaxy role install process
- changing role clickhouse from 1.11.0 to 1.11.0
- extracting clickhouse to /home/ivanm/.ansible/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
```
---

3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.

#### Результат:

```bash
ansible-galaxy role init vector-role
- Role vector-role was created successfully
```

---

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры.

#### Результат:

[vector-role](https://github.com/ivanmanokhin/vector-role)

---

7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.

#### Результат:

[lighthouse-role](https://github.com/ivanmanokhin/lighthouse-role)

---

8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.

#### Результат:

requirements.yml:
```yaml
---
- src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.11.0"
  name: clickhouse
- src: git@github.com:ivanmanokhin/vector-role
  scm: git
  version: "1.0.1"
  name: vector
- src: git@github.com:ivanmanokhin/lighthouse-role
  scm: git
  version: "1.0.1"
  name: lighthouse

```

---

9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.

#### Результат:

site.yml:
```yaml
---
- name: Install ClickHouse
  hosts: clickhouse
  roles:
    - { role: clickhouse }
  tags:
    - clickhouse

- name: Install Vector
  hosts: vector
  roles:
    - { role: vector }
  tags:
    - vector

- name: Install LightHouse
  hosts: lighthouse
  pre_tasks:
    - name: Install EPEL-release
      become: true
      ansible.builtin.yum:
        name: epel-release
    - name: Install Git
      become: true
      ansible.builtin.yum:
        name: git
    - name: Install Nginx
      become: true
      ansible.builtin.yum:
        name: nginx
  roles:
    - { role: lighthouse }
  tags:
    - lighthouse
```

---

10. Выложите playbook в репозиторий.

#### Результат:

[cvl-stack](https://github.com/ivanmanokhin/cvl-stack/blob/role-based/site.yml)

---

11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

#### Результат:

- [vector-role](https://github.com/ivanmanokhin/vector-role)
- [lighthouse-role](https://github.com/ivanmanokhin/lighthouse-role)
- [cvl-stack](https://github.com/ivanmanokhin/cvl-stack/tree/role-based)
