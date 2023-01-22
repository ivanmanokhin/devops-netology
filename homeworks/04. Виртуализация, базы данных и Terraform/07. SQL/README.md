# Домашнее задание по теме: "SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### Результат:

```
version: '3.8'

services:
  postgres:
    image: postgres:12.13-alpine
    container_name: postgres
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD
    ports:
      - '5432:5432'
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/var/lib/postgresql/backup

volumes:
  data:
  backup:
```

*POSTGRES_PASSWORD подхватывается из .env.*

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

### Результат:

* SQL-запрос для получения списка БД:

  ```sql
  SELECT datname AS "table_name"
  FROM pg_database;
  ```
  
  Ответ:
  
  | table_name |
  | - |
  | postgres |
  | template1 |
  | template0 |
  | test_db |

* SQL-запрос для получения информации о таблицах:

  ```sql
  SELECT 
     table_name, 
     column_name, 
     data_type 
  FROM 
     information_schema.columns
  WHERE 
     table_name = 'orders' OR table_name = 'clients';
  ```
  
  Ответ:
  
  | table_name | column_name | data_type |
  |-|-|-|
  | orders | id | integer |
  | orders | наименование | character varying |
  | orders |  цена | integer |
  | clients |  фамилия | character varying |
  | clients |  страна проживания | character varying |
  | clients |  заказ | integer |

* SQL-запрос для получения информации о пользователях:

  ```sql
  SELECT grantee, table_schema, table_name, array_agg(privilege_type) 
  FROM information_schema.table_privileges
  WHERE grantee NOT IN ('PUBLIC', 'postgres')
  AND table_catalog = 'test_db'
  GROUP BY grantee, table_schema, table_name;
  ```

  | grantee | table_schema | table_name | array_agg |
  | - | - | - | - |
  | test-admin-user | public | clients | {TRUNCATE,REFERENCES,TRIGGER,INSERT,SELECT,UPDATE,DELETE} |
  | test-admin-user | public | orders | {TRUNCATE,REFERENCES,TRIGGER,INSERT,SELECT,UPDATE,DELETE} |
  | test-simple-user | public | clients | {DELETE,INSERT,SELECT,UPDATE} |
  | test-simple-user | public | orders | {INSERT,SELECT,UPDATE,DELETE} |

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

### Результат

* SQL-запросы на INSERT:

  ```sql
  INSERT INTO orders("наименование", "цена")
  VALUES
  ('Шоколад', 10),
  ('Принтер', 3000),
  ('Книга', 500),
  ('Монитор', 7000),
  ('Гитара', 4000);
  
  INSERT INTO clients("фио", "страна проживания")
  VALUES
  ('Иванов Иван Иванович', 'USA'),
  ('Петров Петр Петрович', 'Canada'),
  ('Иоганн Себастьян Бах', 'Japan'),
  ('Ронни Джеймс Дио', 'Russia'),
  ('Ritchie Blackmore', 'Russia');
  ```

* SQL-запрос для подсчета записей в таблицах
  ```sql
  SELECT count(*) AS "Количество записей"
  FROM clients;

  SELECT count(*) AS "Количество записей"
  FROM orders;
  ```

  #### Результат:

  | Количество записей |
  | - |
  | 5 |

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

### Результат

* SQL-запросы на UPDATE таблиц:

  ```sql
  UPDATE clients 
  SET "заказ" = (SELECT id FROM orders WHERE lower("наименование") = 'книга')
  WHERE "фио" = 'Иванов Иван Иванович';
  
  UPDATE clients 
  SET "заказ" = (SELECT id FROM orders WHERE lower("наименование") = 'монитор')
  WHERE "фио" = 'Петров Петр Петрович';
  
  UPDATE clients 
  SET "заказ" = (SELECT id FROM orders WHERE lower("наименование") = 'гитара')
  WHERE "фио" = 'Иоганн Себастьян Бах';
  ```

* SQL- для поиска пользователей, которые совершили заказ:

  ```sql
  SELECT "фио",
  	"страна проживания",
  	"наименование",
  	"цена"
  FROM clients c
  INNER JOIN orders o ON c."заказ" = o.id;
  ```

  #### Результат:

  | фио | страна проживания | наименование | цена |
  | - | - | - | - |
  | Иванов Иван Иванович | USA | Книга | 500 |
  | Петров Петр Петрович | Canada | Монитор | 7000 |
  | Иоганн Себастьян Бах | Japan | Гитара | 4000 |

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

### Результат

```sql
EXPLAIN
SELECT "фио",
	"страна проживания",
	"наименование",
	"цена"
FROM clients c
INNER JOIN orders o ON c."заказ" = o.id;
```

```
QUERY PLAN                                                              
------------------------------------------------------------------------
Hash Join  (cost=11.57..24.20 rows=70 width=1552)                       
  Hash Cond: (o.id = c."заказ")                                         
  ->  Seq Scan on orders o  (cost=0.00..11.40 rows=140 width=524)       
  ->  Hash  (cost=10.70..10.70 rows=70 width=1036)                      
        ->  Seq Scan on clients c  (cost=0.00..10.70 rows=70 width=1036)
```

```
Объединение по алгоритму hash join
  Условие объединения таблиц: атрибут id таблицы order == атрибуту "заказ" таблицы clients
  ->  Последовательное сканирование таблицы orders
  ->  Хеширование полученных данных
        ->  Последовательное сканирование таблицы orders
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 


### Результат

* Резервное копирование:

  ```bash
  docker exec postgres pg_dump -U postgres -d test_db -f /var/lib/postgresql/backup/test_db_dump.tar
  ```

* Восстановление:

  ```bash
  docker exec -u postgres postgres createdb test_db
  docker exec postgres pg_restore -U postgres -d test_db /var/lib/postgresql/backup/test_db_dump.tar
  ```
  