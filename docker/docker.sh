#!/bin/bash

set -e

echo -e "\n creating vm on yc"
yc compute instance create \
  --name docker-machine \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --memory 4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ~/.ssh/ubuntu.pub

echo -e "\ngetting ip address of new vm"
export DOCKER_MACHINE_IP=$(yc compute instance get docker-machine \
  | grep -A1 one_to_one_nat: \
  | grep -oE '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b')

echo -e "\nvm ip address is ${DOCKER_MACHINE_IP}"
echo -e "\ninstalling docker on ${DOCKER_MACHINE_IP}"
docker-machine create \
  --driver generic \
  --generic-ip-address=${DOCKER_MACHINE_IP} \
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/ubuntu \
  machine1

eval $(docker-machine env machine1)

echo -e "\n\ndocker environment set to ${DOCKER_MACHINE_IP}"

