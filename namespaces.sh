#!/bin/bash
set -e
kubectl apply -f ./infra/k8s/namespace-prod.yml \
                -f ./infra/k8s/namespace-monitoring.yml \
                -f ./infra/k8s/namespace-logging.yml \
                --wait