# CHANGELOG

**2020-10-13**
 - Создана структура папок
 - Созданы Dockerfile-s и Makefile для сборки образов

**2020-10-15**
 - Docker-compose файлы
 - Базовый README
 - Базовая инфраструктура для terraform

**2020-10-21**
 - Разворачивание Kubernetes Managed Service в YC с помощью terraform
 - Деплой приложения в namespace prod, деплой prometheus и grafana с помощью Helm
 - README

**2020-10-28**
 - Подключение grafana к prometheus
 - Отключение LoadBalancer для prometheus (чтобы не торчал наружу)

**2020-11-05**
 - Разворачивание GitLab, Container Registry в YC
 - Создание CI-CD для master ветки (окружение prod)
 - README

**2020-11-06**
 - Добавление переменной ``REGISTRY_ID`` в Gitlab CI-CD
 - Создание дашборда для Grafana
 - README

**2020-11-07**
 - Создание CI-CD для ветки dev (окружение dev)
 - Добавление в Grafana разделения графиков на kubernetes-namespace
 - Описание процесса CI-CD в README.md
 - Изменение фонового цвета в UI
