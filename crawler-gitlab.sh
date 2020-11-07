#!/bin/bash
set -e
kubectl apply -n $CR_ENV \
        -f ./infra/k8s/gitlab-deployments/deployment-bot.yml \
        -f ./infra/k8s/gitlab-deployments/deployment-ui.yml \
        -f ./infra/k8s/gitlab-deployments/service-bot.yml \
        -f ./infra/k8s/gitlab-deployments/service-ui.yml \
        --wait