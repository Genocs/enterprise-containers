Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Pagamento in base al consumo",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "West Europe",
    [parameter(Mandatory = $false)]
    [string]$akvName = "kv-genocsakst",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$aksResourceGroupName = "rg-aks-genocs"
)

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName" -ForegroundColor Yellow
az account set --subscription=$subscriptionName

$subscriptionId = (az account show | ConvertFrom-Json).id
$tenantId = (az account show | ConvertFrom-Json).tenantId
# Write-Host "Azure subscription '$subscriptionName' subscriptionId: $subscriptionId, tenantId: $tenantId" -ForegroundColor Yellow


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

    Write-Host "Successfully created Azure Key Vault $akvName under resource group $resourceGroupName" -ForegroundColor Green        
}

# Retrieve existing AKS
# Write-Host "Retrieving AKS details"
# $aks = (az aks show `
#     --name $clusterName `
#     --resource-group $aksResourceGroupName | ConvertFrom-Json)

# Retrieve the existing AKS Azure Identity
Write-Host "Retrieving the existing Azure Identity..." -ForegroundColor Yellow
$nodeResourceGroup = $(az aks show -g $aksResourceGroupName -n $clusterName -o tsv --query "nodeResourceGroup")
Write-Host "nodeResourceGroup is: " $nodeResourceGroup -ForegroundColor Yellow

$identity = az identity show `
    --name "$clusterName-agentpool" `
    --resource-group $nodeResourceGroup | ConvertFrom-Json

Write-Host "Principal ID: " $identity.principalId
Write-Host "SubscriptionId: " $subscriptionId
Write-Host "Client ID: " $identity.clientId
Write-Host "Azure Key Vault: " $akvName
Write-Host "TenantId: " $tenantId

Write-Host "Please update the SecretProviderClass.yaml userAssignedIdentityID, keyvaultName, tenantId, accordingly" -ForegroundColor Green

Write-Host "Setting policy to access secrets in Key Vault with Client Id"
az keyvault set-policy `
    --name $akvName `
    --secret-permissions get `
    --spn $identity.clientId

# delete resource and purge
# az keyvault purge --subscription f20b0dac-53ce-44d4-a673-eb1fd36ee03b -n kv-genocsakst


az aks update -g $resourceGroupName -n $clusterName --enable-pod-identity --enable-pod-identity-with-kubenet

az aks pod-identity add `
    --resource-group $resourceGroupName `
    --cluster-name $clusterName  `
    --namespace default  `
    --name csi-to-key-vault  `
    --identity-resource-id $identity.id

kubectl get azureidentity