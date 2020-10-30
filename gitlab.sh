#!/bin/bash
set -e
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade -n gitlab --install gitlab gitlab/gitlab \
--set certmanager-issuer.email=etoosamoe@yandex.ru \
--set global.edition=ce \
--set certmanager.install=false \
--set global.ingress.configureCertmanager=false \
--set gitlab-runner.install=false