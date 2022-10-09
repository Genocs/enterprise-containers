Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs"
)

# Delete resource group
Write-Host "Deleting resource group $resourceGroupName" -ForegroundColor Red
az group delete --name=$resourceGroupName --yes


# Delete the AKS cluster
#az aks delete --resource-group $resourceGroupName --name $clusterName --yes
#az aks delete --resource-group $resourceGroupName --yes
#az aks delete --resource-group $agicResourceGroupName --yes