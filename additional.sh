#!/bin/bash
set -e
kubectl apply -n prod -f ./infra/k8s/deployments-prod/deployment-mongodb.yml \
        -f ./infra/k8s/deployments-prod/deployment-rabbitmq.yml \
        -f ./infra/k8s/deployments-prod/service-mongodb.yml \
        -f ./infra/k8s/deployments-prod/service-rabbitmq.yml \
        -f ./infra/k8s/deployments-prod/deployment-mongodb-exporter.yml \
        -f ./infra/k8s/deployments-prod/service-mongodb-exporter.yml \
        -f ./infra/k8s/deployments-prod/deployment-rabbitmq-exporter.yml \
        -f ./infra/k8s/deployments-prod/service-rabbitmq-exporter.yml \
        --wait

kubectl apply -n dev -f ./infra/k8s/deployments-dev/deployment-mongodb.yml \
        -f ./infra/k8s/deployments-dev/deployment-rabbitmq.yml \
        -f ./infra/k8s/deployments-dev/service-mongodb.yml \
        -f ./infra/k8s/deployments-dev/service-rabbitmq.yml \
        -f ./infra/k8s/deployments-dev/deployment-mongodb-exporter.yml \
        -f ./infra/k8s/deployments-dev/service-mongodb-exporter.yml \
        -f ./infra/k8s/deployments-dev/deployment-rabbitmq-exporter.yml \
        -f ./infra/k8s/deployments-dev/service-rabbitmq-exporter.yml \
        --wait