# Домашнее задание по теме: "PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

**docker-compose:**

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:13-alpine
    container_name: postgres
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD
    ports:
      - '5432:5432'
    volumes:
      - data:/var/lib/postgresql/data

volumes:
  data:
```

---

Подключитесь к БД PostgreSQL используя `psql`.

**Команда:**

`docker exec -it postgres bash -c '/usr/local/bin/psql -U postgres'`

---

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

**Результат:**

```
\l - вывод списка БД
\c DB_NAME - подключение к БД
\d - вывод списка таблиц
\d TABLE_NAME - вывод описания содержимого таблиц
\q - выход из psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.

**Команда:**

`docker exec -i postgres psql -U postgres -c "CREATE DATABASE test_database;"`

---

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

**Команда:**

`cat test_dump.sql | docker exec -i postgres psql -U postgres -d test_database`

---

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

**Ответ:**

```
docker exec -it postgres psql -U postgres -d test_database

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

---

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

**Ответ:**

```
test_database-# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' ORDER BY 2 DESC LIMIT 1;
```

```
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

**SQL-запросы:**

```sql
--создание таблиц со структурой родительской таблицы и условиями
CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);

--заполнение таблиц
INSERT INTO orders_1 (SELECT * FROM orders WHERE price > 499);
INSERT INTO orders_2 (SELECT * FROM orders WHERE price <= 499);

--удаление данных из таблицы-родителя
DELETE FROM only orders;
```

---

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

**Ответ:**

Да, при проектировании таблицы можно было воспользоваться условием PARTITION BY RANGE (price).

**DDL:**

```sql
CREATE TABLE orders (
    id serial4 NOT NULL,
    title varchar(80) NOT NULL,
    price int4 NULL DEFAULT 0,
    CONSTRAINT orders_pkey PRIMARY KEY (id)
) PARTITION BY RANGE (price);

CREATE TABLE orders_1 PARTITION OF orders
FOR
VALUES
FROM (500) TO (MAXVALUE);

CREATE TABLE orders_2 PARTITION OF orders
FOR
VALUES
FROM (0) TO ('500');
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

**Команда:**

`docker exec -it postgres pg_dump -U postgres test_database > test_database_dump-$(date +%Y-%m-%d).sql`

---

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

**Ответ:**

Добавить проверку на уникальность значений в стобце title (UNIQUE) при создании таблицы:

```sql
CREATE TABLE orders (
    id serial4 NOT NULL,
    title varchar(80) UNIQUE NOT NULL,
    price int4 NULL DEFAULT 0,
    CONSTRAINT orders_pkey PRIMARY KEY (id)
);
```
