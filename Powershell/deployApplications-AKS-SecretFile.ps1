Param(
    [parameter(Mandatory = $false)]
    [bool]$provisionAKSCluster = $false
)


if ($provisionAKSCluster) {
    Write-Host "Provisioning AKS cluster with default parameters" -ForegroundColor Cyan
    & ((Split-Path $MyInvocation.InvocationName) + "\initializeAKS.ps1")
}

# source common variables
. .\vars.ps1

Write-Host "Starting deployment of application, services and secrets by file" -ForegroundColor Yellow

Write-Host "Deploying Secrets by file" -ForegroundColor Yellow
Set-Location $secretsRootDirectory
kubectl apply --filename secret-file.yaml
Write-Host "Secrets by file deployed successfully" -ForegroundColor Cyan

# Consumers
Write-Host "Deploying Consumer" -ForegroundColor Yellow
Set-Location $applicationConsumerRootDirectory
kubectl apply --filename deployment-file.yml
Write-Host "Consumer Worker deployed successfully" -ForegroundColor Cyan

#Producers
Write-Host "Deploying Producer" -ForegroundColor Yellow
Set-Location $applicationProducerRootDirectory
kubectl apply --recursive --filename .
Write-Host "Producer WebApi deployed successfully" -ForegroundColor Cyan

#Producers internal
Write-Host "Deploying Producer internal" -ForegroundColor Yellow
Set-Location $applicationProducerInternalRootDirectory
kubectl apply --recursive --filename .
Write-Host "Producer WebApi deployed successfully" -ForegroundColor Cyan


Write-Host "All the services related to the application have been successfully deployed" -ForegroundColor Cyan

Set-Location .\..\..\Powershell