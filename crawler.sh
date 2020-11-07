#!/bin/bash
set -e
kubectl apply -n prod \
        -f ./infra/k8s/deployments-prod/deployment-bot.yml \
        -f ./infra/k8s/deployments-prod/deployment-ui.yml \
        -f ./infra/k8s/deployments-prod/service-bot.yml \
        -f ./infra/k8s/deployments-prod/service-ui.yml \
        --wait