# Autoscale Containers With Event Driven Workloads

Setup for scaling .NET containers with event driven workloads.

## Initialize AKS cluster with all KEDA related resources

Run the [deployAll](\Powershell\deployAll.ps1) Powershell script which setup everything from AKS cluster, RabbitMQ, KEDA, Application services etc.

``` PS
.\deployAll.ps1
```

## Access RabbitMQ UI

``` bash
kubectl port-forward svc/rabbitmq 15672:15672
```

Access the RabbitMQ UI with credential `user` & `PASSWORD`

http://127.0.0.1:15672

## Get IP of Producer service

Retrieve the Load Balancer IP of the `rabbitmq-producer-service`

``` bash
kubectl get svc
kubectl get svc rabbitmq-producer-service
```

Got the IP as `20.195.103.121`

## Produce messages on the RabbitMQ

Use Postman to generate 5000 messages

``` bash
http://20.195.103.121/api/TechTalks/Generate?numberOfMessages=5000
```

Other options can also be used to produce messages like hitting the above url directly from browser or using command line utilities like ```curl``` or ```wget```

## Watch the rabbitmq-consumer scale

``` bash
kubectl get pods --watch
kubectl get deploy --watch
```

## Scale consumer deployment to 2 replicas

``` bash
kubectl scale deployment rabbitmq-consumer-deployment --replicas=2
```

## Create HPA with 75% CPU usage

``` bash
kubectl autoscale deployment rabbitmq-consumer-deployment --cpu-percent=75 --min=1 --max=10
```

## Verify KEDA Custom Resource Definitions

``` bash
kubectl get crd
```

## Delete KEDA Autoscaler

``` PS
.\teardownAutoScaler.ps1
```

## Delete HPA

``` bash
kubectl delete hpa rabbitmq-consumer-deployment
```

helm

---

useful commands

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
