Secret Setup
===

There are different ways to setup secret. In this section will be shown how to do it.

## 1. Secret file
This section shall explain how to setup secret defined into a file.

The logical steps are:

1. Prepare the Secret file
2. Update the deployment file accordingly

``` ps
# Setup secret from file
kubectl apply -f .\k8s\Security\secret-file.yaml

# Check the secrets
kubectl get secrets
```

## 2. Secret literal
The following procedure allow setup secret as literal

The logical steps are:

1. Prepare the Secret file
2. Update the deployment file accordingly

This option is different only for the way of creating the secret file (see the command below) 

``` ps
# Set the secret in the  secret-container-literal litaral
kubectl create secret generic secret-container-literal \
    --from-literal=username='user' \
    --from-literal=password='PASSWORD' \
    --from-literal=url='rabbitmq' \

# Check the secrets
kubectl get secrets
```

### Apply the configuration to the deployment or the pod

``` ps
# Literal - Setup at deplyment level 
kubectl apply secret-literal.yaml

# File - Setup at deplyment level 
kubectl apply secret-file.yaml

# File - Setup at pod level 
kubectl apply pod-file.yaml
```

## 2. Secret from AKV

The steps required to use AKV as secret inside kubernetes are:

1. Deploy CSI provider on AKS
2. Setup the CRD file
3. Update the deployment file accordingly

``` ps
# Deploy CSI provider using helm
.\Powershell\deployCSI-AKV-provider.ps1

# Setup the Secret provider class
kubectl apply -f .\k8s\AKV\SecretProviderClass.yaml

# setup the deployment
kubectl apply -f .\k8s\ApplicationConsumer\deployment-akv.yaml
```
