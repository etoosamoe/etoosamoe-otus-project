# Проект etoosamoe

## Цель проекта

Организовать инфраструктуру для развертывания, мониторинга микросервисного приложения:  
 - https://github.com/express42/search_engine_crawler
 - https://github.com/express42/search_engine_ui

Так же для работы приложения необходимы:  
- RabbitMQ
- MongoDB

## Требования для разворачивания инфраструктуры
 - terraform
 - ansible
 - ``ansible-galaxy collection install community.general``

## План действий

 - Подготовка инфраструктуры: Терраформ
  [] Виртуальные машины
  [] кластер k8s
[x] Подготовка докер образов: docker build
[] разворачивание приложения в k8s
[] Мониторинг: Prometheus + Grafana (?), EL(F)K для логов
[] k8s

## Подготовка инфраструктуры

## Подготовка docker образов

### Способ 1
 - установить переменную USER в файле docker.sh  
 - запустить docker.sh
Скрипт развернет виртуальную машину, установит на неё docker-machine, соберет там образы, пушнет их в docker_hub, удалит docker-machine и удалит виртуальную машину.  

### Способ 2
Код приложений лежит в папке ``./docker/app/[crawler|ui]``. В файле ``Makefile`` необходимо установить переменную ``USER`` и запустить ``make build_all``, ``make push_all``.  

## Запуск сервиса на машине

### Требования
 - создать виртуальную машину с docker на борту
 - установить docker-machine

### Запуск

``docker-compose up -d -f ./docker/compose/docker-compose.yml``
