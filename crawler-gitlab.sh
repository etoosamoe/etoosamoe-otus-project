#!/bin/bash
set -e
kubectl apply -n prod \
        -f ./infra/k8s/gitlab-deployments/deployment-bot.yml \
        -f ./infra/k8s/gitlab-deployments/deployment-ui.yml \
        -f ./infra/k8s/gitlab-deployments/service-bot.yml \
        -f ./infra/k8s/gitlab-deployments/service-ui.yml \
        --wait