#!/usr/bin/env bash

set -eo pipefail

DOCTL_VERSION=1.32.3
HELM_3_VERSION=3.0.0
KUBECTL_VERSION=1.16.0

setup() {
    mkdir /lib64
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
    apk add --no-cache wget
}

install_kubectl() {
    wget --no-check-certificate https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-linux-amd64.tar.gz
    tar zxvf kubernetes-client-linux-amd64.tar.gz
    mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl
    chmod +x /usr/local/bin/kubectl
    rm -rf kubernetes-client-linux-amd64.tar.gz kubernetes
}

install_helm() {
    wget --no-check-certificate https://get.helm.sh/helm-v${HELM_3_VERSION}-linux-amd64.tar.gz
    tar zxvf helm-v${HELM_3_VERSION}-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    chmod +x /usr/local/bin/helm
    rm -rf helm-v${HELM_3_VERSION}-linux-amd64.tar.gz linux-amd64
}

install_doctl() {
    wget --no-check-certificate https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz
    tar zxvf doctl-${DOCTL_VERSION}-linux-amd64.tar.gz
    mv doctl /usr/local/bin/doctl
    chmod +x /usr/local/bin/doctl
    rm -rf doctl-${DOCTL_VERSION}-linux-amd64.tar.gz
}

setup && install_kubectl && install_helm && install_doctl && apk del wget
