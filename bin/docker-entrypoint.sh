#!/bin/sh

echo "Starting docker-entrypoint.sh script"

export DIGITALOCEAN_ACCESS_TOKEN=${DIGITALOCEAN_ACCESS_TOKEN} # Use docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten:latest sh
doctl auth init

mkdir ~/.kube
doctl kubernetes cluster kubeconfig show claudio-canales > ~/.kube/config
KUBECONFIG=~/.kube/config

echo "DO account is authorized in the container"

sleep 1000000 # To avoid to exit
