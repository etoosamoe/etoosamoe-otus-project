#!/bin/bash
set -e
kubectl apply -n prod \
        -f ./infra/k8s/deployments/deployment-bot.yml \
        -f ./infra/k8s/deployments/deployment-ui.yml \
        -f ./infra/k8s/deployments/service-bot.yml \
        -f ./infra/k8s/deployments/service-ui.yml \
        --wait