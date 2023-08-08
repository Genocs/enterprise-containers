Param(
    [parameter(Mandatory = $false)]
    [string]$akvName = "kv-genocsakst"
)

Write-Host "Starting deployment of Azure Key Vault secrets" -ForegroundColor Yellow

az keyvault secret set `
    --vault-name $akvName `
    --name "RABBITMQ-HOST-NAME" `
    --value "rabbitmq"

az keyvault secret set `
    --vault-name $akvName `
    --name "RABBITMQ-USER-NAME" `
    --value "guest"

az keyvault secret set `
    --vault-name $akvName `
    --name "RABBITMQ-PASSWORD" `
    --value "guest"

az keyvault secret set `
    --vault-name $akvName `
    --name "RABBITMQ-BATCH-SIZE" `
    --value "100"

Write-Host "Deployment of Azure Key Vault secrets completed successfully" -ForegroundColor Yellow