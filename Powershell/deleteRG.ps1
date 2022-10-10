Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aks-genocs"    
)

# Delete resource group
Write-Host "Deleting resource group $resourceGroupName" -ForegroundColor Red

# Create resource group if it doesn't exist
$rgExists = az group exists --name $resourceGroupName
Write-Host "$resourceGroupName exists: $rgExists"

if ($rgExists -eq $true) {
    az aks delete --resource-group $resourceGroupName --name $clusterName --yes
    az group delete --name=$resourceGroupName --yes
}

# Delete the AKS cluster
#az aks delete --resource-group $resourceGroupName --name $clusterName --yes
#az aks delete --resource-group $resourceGroupName --yes
#az aks delete --resource-group $agicResourceGroupName --yes

Write-Host "Deleting resource group $resourceGroupName completed" -ForegroundColor Green
