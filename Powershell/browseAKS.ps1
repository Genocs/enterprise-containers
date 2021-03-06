Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "RG-Genocs-aks",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aksgenocs"
)

# Browse AKS dashboard
Write-Host "Browse AKS cluster $clusterName" -ForegroundColor Yellow
az aks browse `
    --resource-group=$resourceGroupName `
    --name=$clusterName