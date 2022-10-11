Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$agicResourceGroupName = "rg-agic-genocs",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "West Europe",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$acrRegistryName = "genocscontainer",
    [parameter(Mandatory = $false)]
    [string]$agicPublicIpName = "agic-pip",
    [parameter(Mandatory = $false)]
    [string]$agicName = "agic-genocs"    
)

# Login to Azure
#az login


# Login to azure container registry
#az acr login --name $acrRegistryName


# List the resources
#az acr list --resource-group $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output table


## Setup the networking

# 1. Create the resource group for AGIC (NETWORK) if it doesn't exist
$rgExists = az group exists --name $agicResourceGroupName
Write-Host "$agicResourceGroupName exists: $rgExists"

if ($rgExists -eq $false) {

    # Create resource group name
    Write-Host "Creating resource group $agicResourceGroupName in region $resourceGroupLocation" -ForegroundColor Yellow
    az group create `
        --name=$agicResourceGroupName `
        --location=$resourceGroupLocation `
        --output=jsonc
}


# 2. Create the public IP 
az network public-ip create `
    -g $agicResourceGroupName `
    -n $agicPublicIpName `
    --allocation-method Static `
    --sku Standard `
    --dns-name "genocs-aks"


# 3. Create VNET
az network vnet create `
    -g $agicResourceGroupName `
    -n "agic-vnet" `
    --address-prefix 192.168.0.0/24 `
    --subnet-name "agic-subnet" `
    --subnet-prefix 192.168.0.0/24


# 4. Create Application Gateway
az network application-gateway create `
    -g $agicResourceGroupName `
    -n $agicName `
    -l $resourceGroupLocation `
    --sku Standard_v2 `
    --public-ip-address $agicPublicIpName `
    --vnet-name "agic-vnet" `
    --subnet "agic-subnet" `
    --priority 1000

# Enable the Application Gateway Add-on to the AKS cluster
$appgwId = $(az network application-gateway show -g $agicResourceGroupName -n $agicName  -o tsv --query "id")
az aks enable-addons -g $resourceGroupName -n $clusterName -a ingress-appgw --appgw-id $appgwId

# Read variable needed to setup the vnet peering
$nodeResourceGroup = $(az aks show -g $resourceGroupName -n $clusterName -o tsv --query "nodeResourceGroup")

$aksVnetName = $(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

$aksVnetId = $(az network vnet show -g $nodeResourceGroup -n $aksVnetName -o tsv --query "id")

$appGWVnetId = $(az network vnet show -g $agicResourceGroupName -n "agic-vnet" -o tsv --query "id")

# Create the Peering
az network vnet peering create -n AppGWtoAKSVnetPeering -g $agicResourceGroupName --vnet-name "agic-vnet" --remote-vnet $aksVnetId --allow-vnet-access

az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access


# Configuration and security
# To Secure the configuration on Azure Key Vault create a User managed Identity
# az aks pod-identity add `
#    --resource-group $resourceGroupName `
#    --cluster-name $clusterName `
#    --namespace default `
#    --name csi-to-key-vault `
#    --identity-resource-id /subscriptions/302929bf-b0ca-4518-9e93-936b536d692b/resourceGroups/UTU-RG-RD/providers/Microsoft.ManagedIdentity/userAssignedIdentities/csi-to-key-vault
