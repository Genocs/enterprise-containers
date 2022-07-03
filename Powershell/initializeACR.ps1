Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Pagamento in base al consumo",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "RG-Genocs-akst",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "West Europe",
    [parameter(Mandatory = $false)]
    [string]$acrRegistryName = "genocsakst"
)

$subscriptionId = (az account show | ConvertFrom-Json).id
$tenantId = (az account show | ConvertFrom-Json).tenantId

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName" -ForegroundColor Yellow
az account set --subscription=$subscriptionName

# Create resource group if it doesn't exist
$rgExists = az group exists --name $resourceGroupName
Write-Host "$resourceGroupName exists: $rgExists"

if ($rgExists -eq $false) {

    # Create resource group name
    Write-Host "Creating resource group $resourceGroupName in region $resourceGroupLocation" -ForegroundColor Yellow
    az group create `
        --name=$resourceGroupName `
        --location=$resourceGroupLocation `
        --output=jsonc
}

# Create Azure Container Registry if it doesn't exist
$acrCounts = az container list --query "length([?name == '$acrRegistryName' && resourceGroup == '$resourceGroupName'].{Name: name})"

if ($acrCounts -eq 0) {

    # Create Azure Container Registry with Basic SKU and Admin user disabled
    Write-Host "Creating Azure Container Registry $acrRegistryName under resource group $resourceGroupName" -ForegroundColor Yellow
    az acr create `
        --name=$acrRegistryName `
        --resource-group=$resourceGroupName `
        --sku=Basic `
        --admin-enabled=false `
        --output=jsonc

    # If ACR registry is created without admin user, it can be updated usign the command
    az acr update -n $acrRegistryName --admin-enabled true
}