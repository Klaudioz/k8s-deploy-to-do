#!/bin/sh

export DIGITALOCEAN_ACCESS_TOKEN=${DIGITALOCEAN_ACCESS_TOKEN} # Use docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten:latest sh
doctl auth init

mkdir ~/.kube
doctl kubernetes cluster kubeconfig show claudio-canales > ~/.kube/config
KUBECONFIG=~/.kube/config

echo "DO account is authorized in the container"

# init_k10 script

if [ $1 == "init_k10" ]; then
    echo "Starting function init_k10"
    kubectl create namespace kasten-io
    helm repo add kasten https://charts.kasten.io/
    helm install k10 kasten/k10 --namespace=kasten-io
    kubectl annotate --overwrite volumesnapshotclass do-block-storage k10.kasten.io/is-snapshot-class=true
    helm install my-release stable/mysql
fi

if [ $1 == "clean_k10" ]; then
    echo "Starting function clean_k10"
    helm uninstall my-release
    kubectl annotate --overwrite volumesnapshotclass do-block-storage k10.kasten.io/is-snapshot-class=false
    helm uninstall k10 -n kasten-io
    sleep 20
    kubectl delete namespace kasten-io
fi

sleep 1000
