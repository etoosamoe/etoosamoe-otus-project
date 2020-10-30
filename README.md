# Проект etoosamoe

## Цель проекта

Организовать инфраструктуру для развертывания, мониторинга микросервисного приложения:  
 - https://github.com/express42/search_engine_crawler
 - https://github.com/express42/search_engine_ui

Так же для работы приложения необходимы:  
- RabbitMQ
- MongoDB

## Checklist

 - [x] docker builds  
 - [x] docker-compose  
 - [x] k8s кластер из terraform  
 - [x] деплой приложения в кластере    
 - [x] деплой prometheus
 - [x] деплой grafana, подключенного к prometheus
 - [ ] деплой ELK\EFK  
 - [ ] деплой gitlab, gitlab-runner  (или в github actions?)
 - [ ] подготовка ci-cd для разных namespace  
 - [ ] красивейший README  


## Требования для разворачивания инфраструктуры
 
 - yc-cli
 - terraform
 - docker
 - kubectl

### Создание docker-образов и загрузка их на docker-hub

 - создать виртуальную машину с docker на борту (опционально)
 - установить docker-machine (опционально)
 - установить переменную ``USER`` в файле ``./docker/app/Makefile``
 - ``make`` (отработает сборка и push образов в docker-hub)
 
 - запустить приложение ``docker-compose up -d -f ./docker/compose/docker-compose.yml``  (опционально)


## Запуск инфраструктуры

 - перейти в папку с teraform ``cd ./infra/tf-k8s``  
 - ``mv terraform.tfvars.example terraform.tfvars``  
 - ``terraform.tfvars`` <~~ заполнить файл  
 - создаем кластер ``terraform apply --auto-approve``  
 - добавляем кластер в kubectl ``yc managed-kubernetes cluster   get-credentials crawler-app-cluster --external``  
  
## Запуск приложения

 - создадим namespaces ``./namespaces.sh``  
 - развернем сопутствующие mongodb и rabbitmq ``./additional.sh``  
 - развернем приложение ``./crawler.sh``
 - смотрим ext-ip адрес балансера, который пробрасывает 80-ый порт приложение ``kubectl get svc ui -n prod``  

## Запуск мониторинга

Мониторится кластер, а так же метрики из ui и bot сервисов.  

 - из корневой папки репозитория ``./monitoring.sh``  
 - ожидаем разворачивания балансера, который пробрасывает 80-ый порт на приложения ``kubectl get svc grafana -n monitoring``  
  prometheus-server разворачивается без доступа снаружи.