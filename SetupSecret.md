Secret Setup
===

There are different ways to setup secret. In this section will be shown how to do it.

## 1. Secret file
This section shall explain how to setup secret defined into a file.

``` ps
# Setup secret from file
kubectl apply secret-file.yaml

# Check the secrets
kubectl get secrets
``` 

## 2. Secret literal
The following procedure allow setup secret as literal

``` ps
# Set the secret in the  secret-container-literal litaral
kubectl create secret generic secret-container-literal \
    --from-literal=username='user' \
    --from-literal=password='PASSWORD' \
    --from-literal=url='rabbitmq' \

# Check the secrets
kubectl get secrets
```

### Create the POD to use the secret

``` ps
kubectl apply secret-literal.yaml
``` 

## 2. Secret from AKV

``` ps
kubectl apply secret-literal.yaml
``` 