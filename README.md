# Проект etoosamoe

## Цель проекта

Организовать инфраструктуру для развертывания, доставки и развертывания кода, а также мониторинга микросервисного приложения:  
 - https://github.com/express42/search_engine_crawler
 - https://github.com/express42/search_engine_ui

Так же для работы приложения необходимы:  
- RabbitMQ
- MongoDB

## IP addresses

 - UI-prod [ui-prod.84.201.128.191.xip.io](http://ui-prod.84.201.128.191.xip.io/)
 - UI-dev [ui-dev.84.201.158.178.xip.io](http://ui-dev.84.201.158.178.xip.io/)
 - Gitlab [gitlab.178.154.230.20.xip.io](http://gitlab.178.154.230.20.xip.io)
 - Grafana [grafana.178.154.224.216.xip.io](http://grafana.178.154.224.216.xip.io)

## Checklist

 - [x] docker builds  
 - [x] docker-compose  
 - [x] k8s кластер из terraform  
 - [x] деплой приложения в кластере    
 - [x] деплой prometheus
 - [x] деплой grafana, подключенного к prometheus
 - [ ] деплой ELK\EFK  
 - [x] ~~деплой gitlab, gitlab-runner  (или в github actions?)~~
 - [x] подготовка ci-cd для master
 - [x] подготовка ci-cd для разных веток  
 - [ ] красивейший README  


## Требования для разворачивания инфраструктуры
 
 - yc-cli
 - terraform
 - docker
 - kubectl
 - jq

### Создание docker-образов и загрузка их на docker-hub

> Опционально, если мы хотим разворачивать приложение сами. В GitLab происходит автоматическая сборка приложений в yandex registry.

 - создать виртуальную машину с docker на борту (опционально)
 - установить docker-machine (опционально)
 - установить переменную ``USER`` в файле ``./docker/app/Makefile``
 - ``make`` (отработает сборка и push образов в docker-hub)
 
 - запустить приложение ``docker-compose up -d -f ./docker/compose/docker-compose.yml``  (опционально)


## Запуск инфраструктуры

 - перейти в папку с teraform ``cd ./infra/tf-k8s``  
 - ``mv terraform.tfvars.example terraform.tfvars``  
 - ``terraform.tfvars`` **<~~ заполнить файл**  
 - создаем кластер ``terraform apply --auto-approve``  
 - добавляем кластер в kubectl ``yc managed-kubernetes cluster   get-credentials crawler-app-cluster --external``  
  
## Запуск дополнительных подов 

 - создадим namespaces ``./namespaces.sh``  (создаются неймспейсы prod, dev, monitoring, logging)
 - развернем сопутствующие mongodb и rabbitmq ``./additional.sh``  (разворачиваются как прод, так и дев)

### Запуск приложения без GitLab CI

> Этот пункт необходимо выполнить, если мы не хотим разворачивать приложение через CI\CD в GitLab.  
 - развернем приложение ``./crawler.sh``
 - смотрим ext-ip адрес балансера, который пробрасывает 80-ый порт приложение ``kubectl get svc ui -n prod``  

## Запуск мониторинга

Мониторится кластер, а так же метрики из ui и bot сервисов.  

 - из корневой папки репозитория ``./monitoring.sh``  
 - ожидаем разворачивания балансера, который пробрасывает 80-ый порт на приложения ``kubectl get svc grafana -n monitoring``  
  prometheus-server разворачивается без доступа снаружи.

  - получаем креды от админского аккаунта для графаны ``kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo``
  - добавляем дашборд из папки ``./infra/k8s/charts/grafana/dashboards``

> В Grafana два графика в каждой панели: prod и dev

## GitLab и Container Registry

> Машину с GitLab и регистр образов необходимо создать через веб-интерфейс консоли YandexCloud с рекомендуемыми параметрами. 

> CI/CD описан в .gitlab-ci.yml
 - Создаем проект в GitLab
 - Создаем сервис ``kubectl apply -f ./infra/k8s/gitlab-admin-service-account.yaml``
 - Получаем API URL, токен и сертификат и ввести их в настройках проекта Opertaions - Kubernetes - Add Existing Cluster:  
   - Адрес API нашего мастера - ``yc managed-kubernetes cluster get crawler-app-cluster --format=json | jq -r .master.endpoints.external_v4_endpoint``  
   - Токен для доступа по API ``kubectl -n kube-system get secrets -o json | jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | base64 --decode``  
   - CA-сертификат кластера ``yc managed-kubernetes cluster get crawler-app-cluster --format=json | jq -r .master.master_auth.cluster_ca_certificate``  

 - Установить Tiller и Gitlab Runner 
 - В настройках ``Settings`` - ``CI\CD`` добавить переменные
   - ``KUBE_URL`` - адрес API нашего мастера
   - ``KUBE_TOKEN`` - токен для доступа по API
   - ``REGISTRY_ID`` - id нашего yandex registry
  
  Верификация установки:
  ```
  kubectl get pods -n gitlab-managed-apps
NAME                                    READY   STATUS    RESTARTS   AGE
runner-gitlab-runner-7bb5cf45d4-87p6r   1/1     Running   0          5m27s
tiller-deploy-997ddd879-x68rb           1/1     Running   0          41m
```
 - Добавляем remote в наш git репозиторий.
 - Делаем push кода в GitLab в ветку master.
 - Ожидаем окончания, ищем ip-адрес Load Balancer и проверяем.


## Процесс CI-CD

 - Всегда имеются два окружения: **prod** и **dev**.
 - Разработчик вносит свои изменения в ветку с любым названием, например ``feature-new-design``.
 - Разработчик делает merge-request в ветку dev, мержит изменения.
 - Срабатывают jobs для сборки новых образов и их деплоя в dev namespace. 
 - Разработчик делает merge request в master.
 - Срабатывают jobs для сборки образов и их деплоая в prod namespace.