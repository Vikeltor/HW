# Домашнее задание к занятию 1 «Disaster recovery и Keepalived» - Бондарев Виктор

### Цель задания
В результате выполнения этого задания вы научитесь:
1. Настраивать отслеживание интерфейса для протокола HSRP;
2. Настраивать сервис Keepalived для использования плавающего IP

------
### Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

![alt text](https://github.com/Vikeltor/HW/blob/main/HW01FLT/1.png)
![alt text](https://github.com/Vikeltor/HW/blob/main/HW01FLT/2.png)
![alt text](https://github.com/Vikeltor/HW/blob/main/HW01FLT/3.png)
![alt text](https://github.com/Vikeltor/HW/blob/main/HW01FLT/4.png)
------
### Задание 2

https://github.com/Vikeltor/HW/blob/main/HW01FLT/check_nginx.sh

https://github.com/Vikeltor/HW/blob/main/HW01FLT/keepalived.conf

![alt text](https://github.com/Vikeltor/HW/blob/main/HW01FLT/7.png)
![alt text](https://github.com/Vikeltor/HW/blob/main/HW01FLT/8.png)
