Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "RG-Genocs-akst"
)

# Delete resource group
Write-Host "Deleting resource group $resourceGroupName" -ForegroundColor Red
az group delete --name=$resourceGroupName --yes
