Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$agicResourceGroupName = "rg-agic-genocs",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$akvName = "kv-genocsakst"
)

# Delete resource group
Write-Host "Deleting resource group $resourceGroupName" -ForegroundColor Red

$subscriptionId = (az account show | ConvertFrom-Json).id

# 1. Delete resource group if it exist
$rgExists = az group exists --name $resourceGroupName
Write-Host "$resourceGroupName exists: $rgExists" -ForegroundColor Red

if ($rgExists -eq $true) {
    Write-Host "Start delete AKS cluster $clusterName" -ForegroundColor Yellow
    az aks delete --resource-group $resourceGroupName --name $clusterName --yes
    Write-Host "AKS cluster $resourceGroupName deleted" -ForegroundColor Yellow

    Write-Host "Start delete $resourceGroupName" -ForegroundColor Yellow
    az group delete --name=$resourceGroupName --yes
    Write-Host "$resourceGroupName  deleted" -ForegroundColor Yellow
}

# 2. Delete resource group if it exist
$rgExists = az group exists --name $agicResourceGroupName
Write-Host "$agicResourceGroupName exists: $rgExists" -ForegroundColor Red

if ($rgExists -eq $true) {
    Write-Host "Start delete $agicResourceGroupName" -ForegroundColor Yellow
    az group delete --name=$agicResourceGroupName --yes
    Write-Host $agicResourceGroupName " deleted" -ForegroundColor Yellow
}

# 3. Delete resource group if it exist
$nodeResourceGroup = $(az aks show -g $aksResourceGroupName -n $clusterName -o tsv --query "nodeResourceGroup")
$rgExists = az group exists --name $nodeResourceGroup
Write-Host "$nodeResourceGroup exists: $rgExists" -ForegroundColor Red

if ($rgExists -eq $true) {
    Write-Host "Start delete $nodeResourceGroup" -ForegroundColor Yellow
    az group delete --name=$nodeResourceGroup --yes
    Write-Host $nodeResourceGroup " deleted" -ForegroundColor Yellow
}

az group delete --name="DefaultResourceGroup-WEU" --yes
az group delete --name="NetworkWatcherRG" --yes

# delete keyvault and purge
Write-Host "Deleting keyvault and purge it" -ForegroundColor Red
az keyvault purge --subscription $subscriptionId -n $akvName

Write-Host "Deleting resource group $resourceGroupName completed" -ForegroundColor Green
