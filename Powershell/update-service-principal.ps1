Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "rg-aks-genocs",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aks-genocs"
)

$SP_ID = (az aks show `
        --resource-group $resourceGroupName `
        --name $clusterName `
        --query servicePrincipalProfile.clientId `
        -o tsv)

az ad sp credential list --id $SP_ID --query "[].endDate" -o tsv

$SP_SECRET = (az ad sp credential reset `
        --name $SP_ID `
        --query password `
        -o tsv)

az aks update-credentials `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --reset-service-principal `
    --service-principal $SP_ID `
    --client-secret "$SP_SECRET"

./create-image-pull-secret.ps1 -servicePrincipalID $SP_ID -servicePrincipalPassword $SP_SECRET