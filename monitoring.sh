#!/bin/bash
set -e

cd ./infra/k8s/charts/prometheus
helm upgrade --install prometheus . -f values.yaml -n monitoring
cd ../grafana
helm upgrade --install grafana . -f values.yaml -n monitoring