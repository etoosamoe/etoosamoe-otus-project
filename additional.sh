#!/bin/bash
set -e
kubectl apply -n prod -f ./infra/k8s/deployments/deployment-mongodb.yml \
        -f ./infra/k8s/deployments/deployment-rabbitmq.yml \
        -f ./infra/k8s/deployments/service-mongodb.yml \
        -f ./infra/k8s/deployments/service-rabbitmq.yml \
        -f ./infra/k8s/deployments/deployment-mongodb-exporter.yml \
        -f ./infra/k8s/deployments/service-mongodb-exporter.yml \
        -f ./infra/k8s/deployments/deployment-rabbitmq-exporter.yml \
        -f ./infra/k8s/deployments/service-rabbitmq-exporter.yml \
        --wait