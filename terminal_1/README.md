# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

1. Установленный Oracle VirtualBox:  
  ![image](https://user-images.githubusercontent.com/105848432/172354339-57ff23a0-1d54-438f-bcfb-61bc5e547b46.png)  
2. Установленный HashiCorp Vagrant:  
  ![image](https://user-images.githubusercontent.com/105848432/172354240-60db30d8-59d3-4f41-bd70-af7927929cfd.png)  
3. PowerShell в VSCode + плагин RemoteSSH:  
  ![image](https://user-images.githubusercontent.com/105848432/173374252-993141bf-cb33-4a2c-9aaa-3edecac09641.png)  
4. Успешный запуск VM:  
  ![image](https://user-images.githubusercontent.com/105848432/172360213-12723c89-2e1d-44b9-bf5e-fe99f0c42780.png)  
5. Выделенные ресурсы по умолчанию: 2 CPU, 1024MB RAM, 64GB SATA  
6. Добавить ресурсов: v.memory = 2048 (память)/v.cpus = 4 (процессоры) - прописать в Vagrantfile, секция: Vagrant.configure("2") do |config|  
7. vagrant ssh:  
  ![image](https://user-images.githubusercontent.com/105848432/172360374-9fcc4928-6757-4cbb-b40b-a7b118cdbee6.png)
8. Задать длину журнала history можно через переменную $HISTSIZE, строка документации 607.  
Директива ignoreboth влияет на сохранение строк в bash, при ее использовании не будут сохранены строки начинающиеся с пробела и дубликаты.  
9. Фигурные скобки обеспечивают т.н. brace expression, используются для генерации произвольных строк. 771 строка документации.
10. Создать 100000 файлов однократным вызовом touch можно командой touch {1..100000}.  
Создать аналогичным образом 300000 файлов не получится, т.к. есть ограничение на количество передаваемых аргументов, установлено в переменной ARG_MAX, посмотреть какое ограничение установлено можно командой getconf ARG_MAX или более расширенный вариант через: xargs --show-limits.  
11. Конструкция [[ -d /tmp ]] возвращает истину если существует директория (0 - "истина" (команда завершилась успешно), 1 - "ложь" (команда завершилась неудачей)).  
  ![image](https://user-images.githubusercontent.com/105848432/173431533-d2567f77-2cd0-4eb6-92b9-9ba086bbd3de.png)  
  ![image](https://user-images.githubusercontent.com/105848432/173431829-e7c1a1d5-d088-45cd-b92a-25ac8e42240f.png)  
13. mkdir -p /tmp/new_path_directory && cp /usr/bin/bash /tmp/new_path_directory && export PATH=/tmp/new_path_directory:$PATH && type -a bash  
14. Обе команды созданы для планирования одноразовых заданий. batch в отличии от at выполняет команды, когда это позволяют ресурсы системы (средняя загрузка падает ниже 1.5 или значения, указанного при вызове atd).  
15. Завершение работы виртуальной машины:  
  ![image](https://user-images.githubusercontent.com/105848432/173359558-b2897f09-80b8-4fda-98ca-af57e53a6fbd.png)  
