Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aks-genocs"
)

# Browse AKS dashboard
Write-Host "Browse AKS cluster $clusterName" -ForegroundColor Yellow
az aks browse `
    --resource-group=$resourceGroupName `
    --name=$clusterName