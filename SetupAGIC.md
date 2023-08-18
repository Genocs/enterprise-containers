Kubernetes walkthrough
====

Official Documentation:

[kubectl official](https://kubernetes.io/docs/reference/kubectl/overview/)

# Main components

1. Kubernetes
2. kubectl
3. minikube
4. microk8s

**Kubernetes**: The orchestrator

**kubectl**: The kubernetes cli

**minikube**: It is a kubernetes implementation that allow to have a local cluster with a single node (used to test kubernetes locally)

**microk8s**: It is a multinode kubernetes cluster. It can run on both Linux Ubuntu bare metal or on windows WSL2.

----

## AKS Azure Kubernetes Services

Setup the Kubernetes Enviroment

``` ps
# Check the Azure version (2.28.0)
az --version


# Login to Azure
az login


# Login to azure container registry
az acr login --name "acr-genocs"


# Setup subscription credentials
az account set --subscription "<your subscription id>"


# Create the resource group
az group create --name "rg-aks-genocs" --location "eastus"


# Create the kubernates cluster with binding to azure container registry
az aks create --resource-group "rg-aks-genocs" --name "aks-genocs" --node-count 2 --enable-addons monitoring --generate-ssh-keys --attach-acr "acr-genocs" --location "eastus"


# Get AKS credentials (needed to connect to AKS)
az aks get-credentials --resource-group "rg-aks-genocs" --name "aks-genocs"


# Attach existing AKS to ACR
# (not needed if U create the kubernetes cluster as reported above)
az aks update -g "rg-aks-genocs" -n "aks-genocs" --attach-acr "acr-genocs"


# List the resources
az acr list --resource-group "rg-aks-genocs" --query "[].{acrLoginServer:loginServer}" --output table
```

## How to setup the Networking

Following commands allow to create:

1. AGIC
2. Public IP
3. VNET
4. Create peering beetween AGIC and AKS and viceversa

``` ps
# Create the resource group for AGIC (NETWORK)
az group create -n "rg-agic" -l "eastus"


# Create the public IP 
az network public-ip create -n "agic-pip" -g "rg-agic" --allocation-method Static --sku Standard --dns-name "aksapi"

az network public-ip show -n "agic-pip" -g "rg-agic" --query ipAddress --output tsv


# Create VNET
az network vnet create -n "agic-vnet" -g "rg-agic" --address-prefix 192.168.0.0/24 --subnet-name "agic-subnet" --subnet-prefix 192.168.0.0/24


# Create AGIC (Application Gatway Ingress Controller)
az network application-gateway create -n "agic" -g "rg-agic" -l "eastus" --sku Standard_v2 --public-ip-address "agic-pip" --vnet-name "agic-vnet" --subnet "agic-subnet"


# Enable the Application Gateway Add-on to the AKS cluster
appgwId=$(az network application-gateway show -n "agic" -g "rg-agic" -o tsv --query "id")
az aks enable-addons -n "aks" -g "rg-aks" -a ingress-appgw --appgw-id $appgwId

# Read variable needed to setup the vnet peering
nodeResourceGroup=$(az aks show -n "aks" -g "rg-aks" -o tsv --query "nodeResourceGroup")

aksVnetName=$(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")

appGWVnetId=$(az network vnet show -n "agic-vnet" -g "rg-agic" -o tsv --query "id")

# Create the Peering
az network vnet peering create -n AppGWtoAKSVnetPeering -g "rg-agic" --vnet-name "agic-vnet" --remote-vnet $aksVnetId --allow-vnet-access

az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access
```

## How setup Secrets

As a prerequisite it is necessery to register the services and providers.

``` ps
# Setup features
az feature register --name EnablePodIdentityPreview --namespace Microsoft.ContainerService

az provider register -n Microsoft.ContainerService

# Install the aks-preview extension
az extension add --name aks-preview

# Update the extension to make sure you have the latest version installed
az extension update --name aks-preview
```

To Secure the configuration on Azure Key Vault create a User Managed Identity

``` ps
az aks update -g "rg-aks" -n "aks" --enable-pod-identity-with-kubenet


** TODO WORK IN PROGRESS **
az aks pod-identity add --resource-group "rg-aks" \
--cluster-name "pod-identity-aks" --namespace default \
--name csi-to-key-vault \
--identity-resource-id "/subscriptions/302929bf-b0ca-4518-9e93-936b536d692b/resourceGroups/rg-genocs-aks-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/csi-to-key-vault"
```

Use following command to encode a value as base64.

``` ps
echo 'value to secure encoding with base64 ' | base64
```

## How to setup Kong as API Gateway and AGIC

Kong provide a full set of services to manage seamless all the issue container orchestrator issues.

The link to the official documentation: [Kong](https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/deployment/aks/)

<https://kubernetes.github.io/ingress-nginx/>

## How to setup Monitoring

**TBD**

## General pourpose kubectl commands

``` bash
kubectl version
kubectl --help


minikube version
minikube --help
```

Day by day usefull commands

``` bash
# Create a namespace
kubectl create namespace genocs

# Get info
kubectl get deployments
kubectl get nodes
kubectl get services
kubectl get pods
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

# Run a deployment
kubectl apply -f promotional-partner.yaml
```
