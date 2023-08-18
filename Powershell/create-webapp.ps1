Param(
  [parameter(Mandatory = $false)]
  [string]$resourceGroupName = "rg-genocs-linux",
  [parameter(Mandatory = $false)]
  [string]$appServicePlanName = "asp-linux-base",
  [parameter(Mandatory = $false)]
  [string]$locationName = "West Europe",
  [parameter(Mandatory = $false)]
  [string]$acrRegistryName = "genocs-registry"
)

# Login to Azure
az login

# Login to azure container registry
az acr login --name $acrRegistryName

# List azure locations
az account list-locations -o table

# List the resources
az acr list --resource-group $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output table

# Create Azure Resource group
az group create `
  -n $resourceGroupName `
  --location $locationName

# Create WebApp
# https://learn.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
  
# create a placeholder webapp, useful to startup a pipeline
az webapp create `
  -n genocs-service-webapi `
  -i nginx `
  -g $resourceGroupName `
  -p $appServicePlanName

# create a webapp from a docker image
az webapp create `
  -n genocs-service-webapi `
  -i genocs-registry.azurecr.io/genocs-image:latest `
  -g $resourceGroupName `
  -p $appServicePlanName
