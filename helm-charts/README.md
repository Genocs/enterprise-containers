helm charts
===

This directory contains helm charts for deploying the various components of the demo project.

## Prerequisites

- [Helm](https://helm.sh/docs/intro/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Docker](https://docs.docker.com/get-docker/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)

## Usage

## How to deploy the demo project using helm charts


### helloworld

1. Created a new helm chart called helloworld
2. Deployed to the cluster
3. Created secret and updated cluster settings

### demoapp

1. Created a new helm chart called demoapp
2. Deployed to the cluster
3. Created secret and updated cluster settings


helm install hello_app ./helloworld --values ./helloworld/values.yaml
helm install demo_app ./demoapp --values ./demoapp/values.yaml


kubectl port-forward <yourapp> 8080:80
