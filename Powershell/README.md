## Login to Azure
az login


## Login to azure container registry
az acr login --name $acrRegistryName


## List the resources
az acr list --resource-group $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output table