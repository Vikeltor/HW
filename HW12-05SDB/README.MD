# Домашнее задание к занятию «Индексы»

### Инструкция по выполнению домашнего задания

1. Сделайте fork [репозитория c шаблоном решения](https://github.com/netology-code/sys-pattern-homework) к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/gitlab-hw или https://github.com/имя-вашего-репозитория/8-03-hw).
2. Выполните клонирование этого репозитория к себе на ПК с помощью команды `git clone`.
3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
   - впишите вверху название занятия и ваши фамилию и имя;
   - в каждом задании добавьте решение в требуемом виде: текст/код/скриншоты/ссылка;
   - для корректного добавления скриншотов воспользуйтесь инструкцией [«Как вставить скриншот в шаблон с решением»](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md);
   - при оформлении используйте возможности языка разметки md. Коротко об этом можно посмотреть в [инструкции по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md).
4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`).
5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
6. Любые вопросы задавайте в чате учебной группы и/или в разделе «Вопросы по заданию» в личном кабинете.

Желаем успехов в выполнении домашнего задания.

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.
```
mysql> select sum(data_length) as SUM_Data_Length, sum(index_length) as SUM_Index_Length, sum(index_length)*100.0/sum(data_length) as Persentage_ratio
    -> from information_schema.tables
    -> where table_schema='sakila' and data_length is not null;
+-----------------+------------------+------------------+
| SUM_Data_Length | SUM_Index_Length | Persentage_ratio |
+-----------------+------------------+------------------+
|         4374528 |          2392064 |         54.68165 |
+-----------------+------------------+------------------+
1 row in set (0.27 sec)
```


### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

Проверяем запрос:
```
mysql> explain analyze select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title) from payment p, rental r, customer c, inventory
i, film f where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id;
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Table scan on <temporary>  (cost=2.5..2.5 rows=0) (actual time=5926..5927 rows=391 loops=1)
    -> Temporary table with deduplication  (cost=0..0 rows=0) (actual time=5926..5926 rows=391 loops=1)
        -> Window aggregate with buffering: sum(payment.amount) OVER (PARTITION BY c.customer_id,f.title )   (actual time=2625..5736 rows=642000 loops=1)
            -> Sort: c.customer_id, f.title  (actual time=2625..2682 rows=642000 loops=1)
                -> Stream results  (cost=22.6e+6 rows=16.5e+6) (actual time=0.404..2034 rows=642000 loops=1)
                    -> Nested loop inner join  (cost=22.6e+6 rows=16.5e+6) (actual time=0.396..1751 rows=642000 loops=1)
                        -> Nested loop inner join  (cost=20.9e+6 rows=16.5e+6) (actual time=0.391..1532 rows=642000 loops=1)
                            -> Nested loop inner join  (cost=19.3e+6 rows=16.5e+6) (actual time=0.383..1307 rows=642000 loops=1)
                                -> Inner hash join (no condition)  (cost=1.65e+6 rows=16.5e+6) (actual time=0.358..47.6 rows=634000 loops=1)
                                    -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1.72 rows=16500) (actual time=0.0531..6.98 rows=634 loops=1)
                                        -> Table scan on p  (cost=1.72 rows=16500) (actual time=0.0375..5.15 rows=16044 loops=1)
                                    -> Hash
                                        -> Covering index scan on f using idx_title  (cost=103 rows=1000) (actual time=0.0532..0.232 rows=1000 loops=1)
                                -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.969 rows=1) (actual time=0.00129..0.00183 rows=1.01 loops=634000)
                            -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=250e-6 rows=1) (actual time=169e-6..195e-6 rows=1 loops=642000)
                        -> Single-row covering index lookup on i using PRIMARY (inventory_id=r.inventory_id)  (cost=250e-6 rows=1) (actual time=144e-6..170e-6 rows=1 loops=642000)
 |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (5.96 sec)
```
Время выполнения 5,96 сек. 
Убираем из запроса избыточные таблицы film и inventory,   убираем фрагмент over (partition by c.customer_id, f.title) и оператор distinct:
```
mysql> explain analyze select concat(c.last_name, ' ', c.first_name), sum(p.amount) from payment p, rental r, customer c  where date(p.payment_date) = '2005-07-30' and p.payment_date =
 r.rental_date and r.customer_id = c.customer_id group by c.last_name, c.first_name;
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Table scan on <temporary>  (actual time=7.7..7.75 rows=391 loops=1)
    -> Aggregate using temporary table  (actual time=7.7..7.7 rows=391 loops=1)
        -> Nested loop inner join  (cost=25084 rows=16500) (actual time=0.0644..6.9 rows=642 loops=1)
            -> Nested loop inner join  (cost=19309 rows=16500) (actual time=0.0583..6.34 rows=642 loops=1)
                -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1674 rows=16500) (actual time=0.0441..5.08 rows=634 loops=1)
                    -> Table scan on p  (cost=1674 rows=16500) (actual time=0.0335..3.78 rows=16044 loops=1)
                -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.969 rows=1) (actual time=0.00133..0.00181 rows=1.01 loops=634)
            -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=0.25 rows=1) (actual time=694e-6..718e-6 rows=1 loops=642)
 |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.02 sec)
```
Время выполнения уменьшилось в разы!

Еще можно объединенить таблицы в запросе, спомощью оператора join :
```
select concat(c.last_name, ' ', c.first_name), sum(p.amount)
from customer c
join rental r on r.customer_id = c.customer_id
join payment p on p.payment_date = r.rental_date and date(p.payment_date) = '2005-07-30'
group by c.last_name, c.first_name;
```

```
mysql> explain analyze select concat(c.last_name, ' ', c.first_name), sum(p.amount) from customer c join rental r on r.customer_id = c.customer_id join payment p on p.payment_date = r.
rental_date and date(p.payment_date) = '2005-07-30' group by c.last_name, c.first_name;
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Table scan on <temporary>  (actual time=7.86..7.9 rows=391 loops=1)
    -> Aggregate using temporary table  (actual time=7.85..7.85 rows=391 loops=1)
        -> Nested loop inner join  (cost=25084 rows=16500) (actual time=0.0647..7.06 rows=642 loops=1)
            -> Nested loop inner join  (cost=19309 rows=16500) (actual time=0.0585..6.45 rows=642 loops=1)
                -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1674 rows=16500) (actual time=0.0439..5.17 rows=634 loops=1)
                    -> Table scan on p  (cost=1674 rows=16500) (actual time=0.0331..3.86 rows=16044 loops=1)
                -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.969 rows=1) (actual time=0.00137..0.00186 rows=1.01 loops=634)
            -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=0.25 rows=1) (actual time=749e-6..774e-6 rows=1 loops=642)
 |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.01 sec)
```

Можно создать индекс для таблицы payment на столбец payment_date:

```
mysql> create index idx_payment_date on payment(payment_date);
Query OK, 0 rows affected (0.17 sec)
Records: 0  Duplicates: 0  Warnings: 0
```
```
mysql> explain analyze select concat(c.last_name, ' ', c.first_name), sum(p.amount) from payment p, rental r, customer c where p.payment_date >= '2005-07-30 00:00:00' and p.payment_dat
e < date_add(
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Table scan on <temporary>  (actual time=5.57..5.62 rows=391 loops=1)
    -> Aggregate using temporary table  (actual time=5.56..5.56 rows=391 loops=1)
        -> Nested loop inner join  (cost=582 rows=661) (actual time=0.049..4.76 rows=642 loops=1)
            -> Nested loop inner join  (cost=351 rows=634) (actual time=0.0327..1.13 rows=634 loops=1)
                -> Filter: ((r.rental_date >= TIMESTAMP'2005-07-30 00:00:00') and (r.rental_date < <cache>(('2005-07-30 00:00:00' + interval 1 day))))  (cost=129 rows=634) (actual time=0.0217..0.356 rows=634 loops=1)
                    -> Covering index range scan on r using rental_date over ('2005-07-30 00:00:00' <= rental_date < '2005-07-31 00:00:00')  (cost=129 rows=634) (actual time=0.0192..0.24 rows=634 loops=1)
                -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=0.25 rows=1) (actual time=0.00105..0.00108 rows=1 loops=634)
            -> Index lookup on p using idx_payment_date (payment_date=r.rental_date)  (cost=0.261 rows=1.04) (actual time=0.0051..0.00552 rows=1.01 loops=634)
 |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

```

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*
Индексы, которые используются в PostgreSQL, а в MySQL — нет:

- SP-GiST
- bloom
- BRIN
