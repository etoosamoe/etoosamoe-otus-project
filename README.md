# Проект etoosamoe

## Цель проекта

Организовать инфраструктуру для развертывания, мониторинга микросервисного приложения:  
 - https://github.com/express42/search_engine_crawler
 - https://github.com/express42/search_engine_ui

Так же для работы приложения необходимы:  
- RabbitMQ
- MongoDB

## IP addresses

 - Grafana 178.154.224.216
 - UI 84.201.128.191
 - Gitlab 178.154.230.20

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

  - получаем креды от админского аккаунта для графаны ``kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo``
  - добавляем дашборд из папки ``./infra/k8s/charts/grafana/dashboards``

## GitLab

Создается заранее в веб-интерфейсе Yandex Cloud Console из образа Gitlab с рекомендуемыми параметрами.

 - Создаем сервис ``kubectl apply -f ./infra/k8s/gitlab-admin-service-account.yaml``
 - Получить API URL, токен и сертификат и ввести их в настройках проекта Opertaions - Kubernetes - Add Existing Cluster:  
  ``yc managed-kubernetes cluster get crawler-app-cluster --format=json \
| jq -r .master.endpoints.external_v4_endpoint``
  ``kubectl -n kube-system get secrets -o json | jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | base64 --decode``  
  ``yc managed-kubernetes cluster get crawler-app-cluster --format=json \
| jq -r .master.master_auth.cluster_ca_certificate``  
 - Установить Tiller и Gitlab Runner 
 - В настройках Settings - CI\CD добавить переменные KUBE_URL и KUBE_TOKEN.
  
  Верификация установки:
  ```
  kubectl get pods -n gitlab-managed-apps
NAME                                    READY   STATUS    RESTARTS   AGE
runner-gitlab-runner-7bb5cf45d4-87p6r   1/1     Running   0          5m27s
tiller-deploy-997ddd879-x68rb           1/1     Running   0          41m
```
