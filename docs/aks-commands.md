# Useful commands

This file contains some useful commands to manage the AKS cluster.

``` bash
# How to reate a namespace
kubectl create namespace genocs

# To get info
kubectl get deployments
kubectl get nodes
kubectl get services
kubectl get pods
kubectl get hpa
kubectl get storageclass

# Delete all resources **WARNING**
kubectl delete --all storageclass
kubectl delete --all services
kubectl delete --all pods
kubectl delete --all deployments
kubectl delete --all nodes

# Delete one single resource
kubectl delete service 'service_name'
kubectl delete deployment 'deployment_name'

# Get the service state
kubectl get service 'service_name' --watch
kubectl get service 'service_name' -w

# Run a deployment
kubectl apply -f deployment-file.yaml

# Delete a deployment
kubectl delete -f deployment-file.yaml
```

## Get IP of Producer service

Retrieve the Load Balancer IP of the `rabbitmq-producer-service`

``` bash
kubectl get svc
kubectl get svc rabbitmq-producer-service
```

Got the IP as `20.195.103.121`

``` bash
# Scale consumer deployment to 2 replicas
kubectl scale deployment rabbitmq-consumer-deployment --replicas=2

# Create HPA with 75% CPU usage
kubectl autoscale deployment rabbitmq-consumer-deployment --cpu-percent=75 --min=1 --max=10

# Delete HPA
kubectl delete hpa rabbitmq-consumer-deployment
```

## Delete KEDA Autoscaler

``` PS
.\teardownAutoScaler.ps1
```

## Verify KEDA Custom Resource Definitions

``` bash
kubectl get crd
```


helm
---

Helm commands

``` bash
# Get the helm version
helm version

# Get the installed components
helm list

# Delete installed helm component
helm uninstall nginx-ingress
```

## Purge Key Vault soft-enable secret

By default, Key Vault has soft-enabled delete option set to true.
So even though the Key vault resource is deleted the data remain in Azure for 90 days.
This means that is not possible to recreate a new one resource with the same name unless the purge is made.

The command below allows to purge the deleted resource so a new can happen without issues.

Please the the documentation:

[Official](https://docs.microsoft.com/en-us/azure/key-vault/general/key-vault-recovery?tabs=azure-portal)

``` sh
az keyvault purge --subscription <your subscription id> -n kv-genocsakst
```
