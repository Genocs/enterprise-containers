# AKS Preview features

## Enable preview features

Install `aks-preview` Azure CLI extension

``` PS
az extension add --name aks-preview
```

Register the `UseCustomizedContainerRuntime` feature

``` PS
az feature register --name UseCustomizedContainerRuntime --namespace Microsoft.ContainerService
```

Register the `UseCustomizedUbuntuPreview` feature

``` PS
az feature register --name UseCustomizedUbuntuPreview --namespace Microsoft.ContainerService

```

## Check the registration status

``` PS
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/UseCustomizedContainerRuntime')].{Name:name,State:properties.state}"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/UseCustomizedUbuntuPreview')].{Name:name,State:properties.state}"
```

## Refresh registration of `Microsoft.ContainerService` resource provider

``` PS
az provider register --namespace Microsoft.ContainerService
```

## Use `containerd` as container runtime when cluster is created

Add the following lines to the cluster creation command

`--aks-custom-headers CustomizedUbuntu=aks-ubuntu-1804,ContainerRuntime=containerd`
