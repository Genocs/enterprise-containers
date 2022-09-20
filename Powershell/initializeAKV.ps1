Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Pagamento in base al consumo",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "RG-Genocs-akst",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "West Europe",
    [parameter(Mandatory = $false)]
    [string]$akvName = "kv-genocsakst",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aksgenocs",
    [parameter(Mandatory = $false)]
    [string]$aksResourceGroupName = "RG-Genocs-akst"
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

# Create Azure Key Vault if it doesn't exist
$akvCounts = az keyvault list --query "length([?name == '$akvName' && resourceGroup == '$resourceGroupName'].{Name: name})"

if ($akvCounts -eq 0) {

    # Create Azure Key Vault
    Write-Host "Creating Azure Key Vault $akvName under resource group $resourceGroupName" -ForegroundColor Yellow
    az keyvault create `
        --name=$akvName `
        --resource-group=$resourceGroupName `
        --location=$resourceGroupLocation `
        --output=jsonc
}

# Retrieve existing AKS
Write-Host "Retrieving AKS details"
$aks = (az aks show `
    --name $clusterName `
    --resource-group $aksResourceGroupName | ConvertFrom-Json)

# Retrieve the existing AKS Azure Identity
Write-Host "Retrieving the existing Azure Identity..." -ForegroundColor Yellow
$identityResource = 'mc_' + $aksResourceGroupName + '_' + $clusterName + '_' + $aks.location

Write-Host "identityResource is: $identityResource" -ForegroundColor Yellow

$existingIdentity = (az resource list `
    --resource-group $identityResource `
    --query "[?contains(name, '$clusterName-agentpool')]" | ConvertFrom-Json)

$identity = az identity show `
    --name $existingIdentity.name `
    --resource-group $existingIdentity.resourceGroup | ConvertFrom-Json

Write-Host "Principal ID: " + $identity.principalId
Write-Host "Client ID: " + $identity.clientId

Write-Host "Please update the SecretProviderClass accordingly" -ForegroundColor Green


Write-Host "Setting policy to access secrets in Key Vault with Client Id"
az keyvault set-policy `
    --name $akvName `
    --secret-permissions get `
    --spn $identity.clientId

# delete resource and purge
# az keyvault purge --subscription f20b0dac-53ce-44d4-a673-eb1fd36ee03b -n kv-genocsakst