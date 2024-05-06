# Домашнее задание к занятию «SQL. Часть 2»

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

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.
```
mysql> select concat(sta.last_name, ' ', sta.first_name) as ФИО_сотрудника_магазина, ci.city as Город_нахождения_магазина, count(cu.store_id) as Количество_пользователей_магазина from
customer cu join store sto on sto.store_id = cu.store_id join staff sta on sta.store_id = sto.store_id join address a on a.address_id = sto.address_id join city ci on a.city_id = ci.city_id group by cu.store_id, sta.staff_id, a.address_id, ci.city_id having count(cu.store_id) > 300;
+----------------------------------------------+--------------------------------------------------+------------------------------------------------------------------+
| ФИО_сотрудника_магазина                      | Город_нахождения_магазина                        | Количество_пользователей_магазина                                |
+----------------------------------------------+--------------------------------------------------+------------------------------------------------------------------+
| Hillyer Mike                                 | Lethbridge                                       |                                                              326 |
+----------------------------------------------+--------------------------------------------------+------------------------------------------------------------------+
1 row in set (0.01 sec)

```


### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

```
mysql> select count(film_id)
    -> from film
    -> where length > (select avg(length) from film);
+----------------+
| count(film_id) |
+----------------+
|            489 |
+----------------+
1 row in set (0.01 sec)
```

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.
```
mysql> select date_format(payment_date, "%c.%y") as Месяц_Год, count(payment_id) as Количество_аренд
    -> from payment
    -> where date_format(payment_date, "%c.%y") = (select date_format(payment_date, "%c.%y") from payment group by date_format(payment_date, "%c.%y") order by sum(amount) desc limit 1) 
    -> group by date_format(payment_date, "%c.%y");
+-------------------+---------------------------------+
| Месяц_Год         | Количество_аренд                |
+-------------------+---------------------------------+
| 7.05              |                            6709 |
+-------------------+---------------------------------+
1 row in set (0.38 sec)
```


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».
```
mysql> select concat(s.first_name, ' ', s.last_name) as Продавец,
    -> count(p.payment_id) as Количество_продаж,
    -> case when count(payment_id) > 8000 then 'Да' else 'Нет' end as Премия
    -> from payment p
    -> join staff s on s.staff_id = p.staff_id group by p.staff_id;
+------------------+-----------------------------------+--------------+
| Продавец         | Количество_продаж                 | Премия       |
+------------------+-----------------------------------+--------------+
| Mike Hillyer     |                              8054 | Да           |
| Jon Stephens     |                              7990 | Нет          |
+------------------+-----------------------------------+--------------+
2 rows in set (0.05 sec)
```

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.
```
mysql> select f.title as Фильм
    -> from film f
    -> left join inventory i on i.film_id = f.film_id
    -> left join rental r on r.inventory_id = i.inventory_id
    -> where r.rental_id is null
    -> order by f.title asc;
+------------------------+
| Фильм                  |
+------------------------+
| ACADEMY DINOSAUR       |
| ALICE FANTASIA         |
| APOLLO TEEN            |
| ARGONAUTS TOWN         |
| ARK RIDGEMONT          |
| ARSENIC INDEPENDENCE   |
| BOONDOCK BALLROOM      |
| BUTCH PANTHER          |
| CATCH AMISTAD          |
| CHINATOWN GLADIATOR    |
| CHOCOLATE DUCK         |
| COMMANDMENTS EXPRESS   |
| CROSSING DIVORCE       |
| CROWDS TELEMARK        |
| CRYSTAL BREAKING       |
| DAZED PUNK             |
| DELIVERANCE MULHOLLAND |
| FIREHOUSE VIETNAM      |
| FLOATS GARDEN          |
| FRANKENSTEIN STRANGER  |
| GLADIATOR WESTWARD     |
| GUMP DATE              |
| HATE HANDICAP          |
| HOCUS FRIDA            |
| KENTUCKIAN GIANT       |
| KILL BROTHERHOOD       |
| MUPPET MILE            |
| ORDER BETRAYED         |
| PEARL DESTINY          |
| PERDITION FARGO        |
| PSYCHO SHRUNK          |
| RAIDERS ANTITRUST      |
| RAINBOW SHOCK          |
| ROOF CHAMPION          |
| SISTER FREDDY          |
| SKY MIRACLE            |
| SUICIDES SILENCE       |
| TADPOLE PARK           |
| TREASURE COMMAND       |
| VILLAIN DESPERATE      |
| VOLUME HOUSE           |
| WAKE JAWS              |
| WALLS ARTIST           |
+------------------------+
43 rows in set (0.13 sec)

```
