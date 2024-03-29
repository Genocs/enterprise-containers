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
    [string]$agicName = "agic-genocs",
    [parameter(Mandatory = $false)]
    [string]$agicVnetName = "agic-vnet",
    [parameter(Mandatory = $false)]
    [string]$agicSubnetName = "agic-subnet",
    [parameter(Mandatory = $false)]
    [string]$agicDNSName = "genocs-aks",
    [parameter(Mandatory = $false)]
    [string]$backendSubnetName = "agic-be-subnet"
)
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
    -l $resourceGroupLocation `
    --allocation-method Static `
    --sku Standard `
    --dns-name $agicDNSName

Write-Host "Created public-ip $agicPublicIpName under resource group $agicResourceGroupName" -ForegroundColor Green

# 3. Create VNET
az network vnet create `
    -g $agicResourceGroupName `
    -n $agicVnetName `
    -l $resourceGroupLocation `
    --address-prefix 192.168.0.0/24 `
    --subnet-name $agicSubnetName `
    --subnet-prefix 192.168.0.0/24

Write-Host "Created vnet $agicVnetName under resource group $agicResourceGroupName" -ForegroundColor Green


# 4. Create Subnet
az network vnet subnet create `
    -g $agicResourceGroupName `
    -n $backendSubnetName `
    --vnet-name $agicVnetName `
    --address-prefix 192.168.0.0/24

Write-Host "Created subnet $agicSubnetName under resource group $agicResourceGroupName" -ForegroundColor Green

# 4. Create Application Gateway
az network application-gateway create `
    -g $agicResourceGroupName `
    -n $agicName `
    -l $resourceGroupLocation `
    --sku Standard_v2 `
    --public-ip-address $agicPublicIpName `
    --vnet-name $agicVnetName `
    --subnet $agicSubnetName `
    --priority 1000


#az network application-gateway create `
#    -g $agicResourceGroupName `
#    -n $agicName `
#    -l $resourceGroupLocation `
#    --sku Standard_v2 `
#    --public-ip-address $agicPublicIpName `
#    --vnet-name $agicVnetName `
#    --subnet $agicSubnetName `
#    --capacity 2 `
#    --http-settings-cookie-based-affinity Disabled `
#    --frontend-port 443 `
#    --http-settings-port 80 `
#    --http-settings-protocol Http `
#    --priority 1000 `
#    --cert-file appgwcert.pfx `
#    --cert-password "Azure123456!"

Write-Host "Created application-gateway $agicName under resource group $agicResourceGroupName" -ForegroundColor Green

# Enable the Application Gateway Add-on to the AKS cluster
# 1 get the id of the application gateway
$appgwId = $(az network application-gateway show -g $agicResourceGroupName -n $agicName -o tsv --query "id")

# 2 enable the add-on
az aks enable-addons -g $resourceGroupName -n $clusterName -a ingress-appgw --appgw-id $appgwId

# Read variable needed to setup the vnet peering

# 1 get the kubernetes cluster resource group name
$nodeResourceGroupName = $(az aks show -g $resourceGroupName -n $clusterName -o tsv --query "nodeResourceGroup")

# 2 get the vnet name
$aksVnetName = $(az network vnet list -g $nodeResourceGroupName -o tsv --query "[0].name")

# 3 get the kubernetes cluster vnet id
$aksVnetId = $(az network vnet show -g $nodeResourceGroupName -n $aksVnetName -o tsv --query "id")

# 4 get the app gateway vnet id
$appGWVnetId = $(az network vnet show -g $agicResourceGroupName -n $agicVnetName -o tsv --query "id")

# Create the Peering
az network vnet peering create `
    -n AppGWtoAKSVnetPeering `
    -g $agicResourceGroupName `
    --vnet-name $agicVnetName `
    --remote-vnet $aksVnetId `
    --allow-vnet-access

az network vnet peering create `
    -n AKStoAppGWVnetPeering  `
    -g $nodeResourceGroupName  `
    --vnet-name $aksVnetName  `
    --remote-vnet $appGWVnetId `
    --allow-vnet-access
