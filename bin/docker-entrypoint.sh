#!/bin/sh

export DIGITALOCEAN_ACCESS_TOKEN=${DIGITALOCEAN_ACCESS_TOKEN} # Use docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten:latest sh
doctl auth init

mkdir ~/.kube
doctl kubernetes cluster kubeconfig show claudio-canales > ~/.kube/config
KUBECONFIG=~/.kube/config

echo "DO account is authorized in the container"

# init_k10 script

if [ $1 == "init_k10" ]; then
    echo "==========Starting function init_k10=========="
    kubectl create namespace kasten-io
    helm repo add kasten https://charts.kasten.io/
    helm install k10 kasten/k10 --namespace=kasten-io
    echo "==========Waiting to install mysql chart=========="
    sleep 20
    kubectl annotate --overwrite volumesnapshotclass do-block-storage k10.kasten.io/is-snapshot-class=true
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    helm install my-release stable/mysql
    sleep 20
    echo "========== Install backup policy =========="
    kubectl apply -f mysql-backup-policy.yaml
    echo "========== Checking backup policy =========="
    sleep 5
    kubectl get policies.config.kio.kasten.io --namespace kasten-io
    #kubectl describe policies.config.kio.kasten.io mysql-backup-policy -n kasten-io
    echo "========== Exposing K10 dashboard...  =========="
    kubectl --namespace kasten-io port-forward service/gateway 8080:8000
    echo "========== function init_k10 COMPLETED =========="
fi

if [ $1 == "clean_k10" ]; then
    echo "========== Starting function clean_k10 =========="
    kubectl delete -f mysql-backup-policy.yaml
    echo "========== Deleted backup policy =========="
    helm uninstall my-release
    kubectl annotate --overwrite volumesnapshotclass do-block-storage k10.kasten.io/is-snapshot-class=false
    helm uninstall k10 -n kasten-io
    echo "========== Waiting to delete the ns =========="
    kubectl delete namespace kasten-io
    echo "========== function clean_k10 COMPLETED =========="
fi
