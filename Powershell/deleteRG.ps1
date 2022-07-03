Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "demo-ossconf"
)

# Delete resource group
Write-Host "Deleting resource group $resourceGroupName" -ForegroundColor Red
az group delete --name=$resourceGroupName --yes
