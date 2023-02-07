# Домашнее задание по теме: "MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

**docker-compose:**

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0.32
    container_name: mysql
    restart: always
    environment:
      - MYSQL_DATABASE=test_db
      - MYSQL_ROOT_PASSWORD
    ports:
      - '3306:3306'
    volumes:
      - data:/var/lib/mysql

volumes:
  data:
```

---

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и 
восстановитесь из него.

**Команда:**

`docker exec -i mysql sh -c 'exec mysql -uroot -p${MYSQL_ROOT_PASSWORD} test_db' < /tmp/test_dump.sql`

---

Перейдите в управляющую консоль `mysql` внутри контейнера.

**Команда:**

`docker exec -it mysql bash -c '/usr/bin/mysql -uroot -p${MYSQL_ROOT_PASSWORD}'`

---

Используя команду `\h` получите список управляющих команд.

**Результат:**

```
mysql> \h
...
List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
...
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'
```

---

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

**Ответ:**

```
mysql> \s
...
Server version:     8.0.32 MySQL Community Server - GPL
...
```

---

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Результат:**

```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)
```

---

**Приведите в ответе** количество записей с `price` > 300.

**Ответ:**

```
mysql> SELECT count(*) FROM orders WHERE price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)
```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

**SQL-запросы:**

```sql
CREATE USER 'test'@'%'
  IDENTIFIED WITH mysql_native_password BY 'test-pass'
  WITH MAX_QUERIES_PER_HOUR 100
  PASSWORD EXPIRE INTERVAL 180 DAY 
  FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 1
  ATTRIBUTE '{"lname": "Pretty", "fname": "James"}';

GRANT SELECT ON test_db.* TO test;
```

---

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

**Результат:**

```
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user = 'test';
+------+------+---------------------------------------+
| USER | HOST | ATTRIBUTE                             |
+------+------+---------------------------------------+
| test | %    | {"fname": "James", "lname": "Pretty"} |
+------+------+---------------------------------------+
1 row in set (0.01 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.

Изучите вывод профилирования команд `SHOW PROFILES;`.

**Ответ:** в выводе `SHOW PROFILES` содержатся исполненные SQL-запросы и время их исполнения.

---

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

**Результат:** InnoDB

```
mysql> SHOW TABLE STATUS FROM test_db LIKE 'orders'\G
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2023-02-07 20:50:24
    Update_time: 2023-02-07 20:50:24
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)
```

---

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

**Результат:**

Из профилирования видно, что после изменения движка на MyISAM, запрос выполнился в ~5 раз быстрее:

```
mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------+
| Query_ID | Duration   | Query                                         |
+----------+------------+-----------------------------------------------+
|       10 | 0.00987225 | SELECT count(*) FROM orders WHERE price > 300 |
|       11 | 0.13513775 | ALTER TABLE orders ENGINE = MyISAM            |
|       12 | 0.00213400 | SELECT count(*) FROM orders WHERE price > 300 |
+----------+------------+-----------------------------------------------+
3 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

**Измененная конфигурация:**

```
[mysqld]
logging
default_authentication_plugin,
server-system-variables.html#sysvar_default_authentication_plugin
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql
pid-file=/var/run/mysqld/mysqld.pid

# added
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = 1
innodb_log_buffer_size = 1
innodb_buffer_pool_size = 308M
innodb_log_file_size = 100M

[client]
socket=/var/run/mysqld/mysqld.sock
!includedir /etc/mysql/conf.d/
```
