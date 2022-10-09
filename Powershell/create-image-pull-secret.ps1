Param(
    [parameter(Mandatory = $false)]
    [string]$acrRegistryName = "acr-genocs",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [Parameter(Mandatory = $true)]
    [string]$servicePrincipalID,
    [Parameter(Mandatory = $true)]
    [string]$servicePrincipalPassword
)

# Get login server name based on ACR registry name
$serverName = az acr show `
    --name $acrRegistryName `
    --resource-group $resourceGroupName `
    --query loginServer

Write-Host "Creating docker secret" -ForegroundColor Yellow
kubectl create secret docker-registry acr-image-secret `
    --docker-server=$serverName `
    --docker-username=$servicePrincipalID `
    --docker-password=$servicePrincipalPassword

# Verify secret was created
kubectl get secret acr-image-secret --output=yaml
