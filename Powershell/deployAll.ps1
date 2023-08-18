Write-Host "Provisioning Azure Container Registry used by the AKS cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\initializeACR.ps1")

Write-Host "Provisioning AKS cluster with default parameters" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\initializeAKS.ps1")

Write-Host "Provisioning Azure Key Vault" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\initializeAKV.ps1")

Write-Host "Installing network infrastructure for AKS cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\initializeNetwork.ps1")

Write-Host "Deploy the Azure Key Vault Secrets" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployAKV-secrets.ps1")

Write-Host "Installing RabbitMQ on AKS cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployRabbitMQ.ps1")

Write-Host "Installing KEDA on AKS cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployKEDA.ps1")

Write-Host "Installing Application on AKS cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployApplications-AKS.ps1")

Write-Host "Installing Autoscaler on AKS cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployAutoScaler.ps1")