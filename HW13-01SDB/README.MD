# Домашнее задание к занятию «Уязвимости и атаки на информационные системы»

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

------

### Задание 1

Скачайте и установите виртуальную машину Metasploitable: https://sourceforge.net/projects/metasploitable/.

Это типовая ОС для экспериментов в области информационной безопасности, с которой следует начать при анализе уязвимостей.

Просканируйте эту виртуальную машину, используя **nmap**.

Попробуйте найти уязвимости, которым подвержена эта виртуальная машина.

Сами уязвимости можно поискать на сайте https://www.exploit-db.com/.

Для этого нужно в поиске ввести название сетевой службы, обнаруженной на атакуемой машине, и выбрать подходящие по версии уязвимости.

Ответьте на следующие вопросы:

- Какие сетевые службы в ней разрешены?
- Какие уязвимости были вами обнаружены? (список со ссылками: достаточно трёх уязвимостей)
  
*Приведите ответ в свободной форме.*  

Сканируем:
```
nmap -sSV 172.16.52.128 # инфомация по открытым TCP портам (TCP SYN)
nmap -sTV 172.16.52.128 # инфомация по открытым TCP портам (TCP Connect)
nmap -sAV 172.16.52.128 # инфомация по открытым TCP портам (TCP FIN)
nmap -sUV 172.16.52.128 # инфомация по открытым UDP портам
nmap -sV 172.16.52.128 # инфомация по всем открытым TCP портам
nmap -A 172.16.52.128 # агресивный режим - инфомация по всем открытым TCP портам
```
Список доступных сетевых служб:
![](https://github.com/Vikeltor/HW/blob/main/HW13-01SDB/HW13-01-01-01.png)
![](https://github.com/Vikeltor/HW/blob/main/HW13-01SDB/HW13-01-01-02.png)

Список нескольких уязвимостей:
- [TelnetD encrypt_keyid - Function Pointer Overwrite](https://www.exploit-db.com/exploits/18280)                 
- [ProFTPd IAC 1.3.x - Remote Command Execution](https://www.exploit-db.com/exploits/15449)
- [vsftpd 2.3.4 - Backdoor Command Execution](https://www.exploit-db.com/exploits/49757)
- [MySQL 5.0.x - IF Query Handling Remote Denial of Service](https://www.exploit-db.com/exploits/30020)
- [MySQL 5.0.x - Single Row SubSelect Remote Denial of Service](https://www.exploit-db.com/exploits/29724)

### Задание 2

Проведите сканирование Metasploitable в режимах SYN, FIN, Xmas, UDP.

Запишите сеансы сканирования в Wireshark.

Ответьте на следующие вопросы:

- Чем отличаются эти режимы сканирования с точки зрения сетевого трафика?
- Как отвечает сервер?

*Приведите ответ в свободной форме.*

- [SYN](https://github.com/Vikeltor/HW/blob/main/HW13-01SDB/nmap-SYN.pcapng)
- [UDP](https://github.com/Vikeltor/HW/blob/main/HW13-01SDB/nmap-UDP.pcapng)
- [Xmas](https://github.com/Vikeltor/HW/blob/main/HW13-01SDB/nmap-Xmass.pcapng)
- [FIN](https://github.com/Vikeltor/HW/blob/main/HW13-01SDB/nmap-FIN.pcapng)
