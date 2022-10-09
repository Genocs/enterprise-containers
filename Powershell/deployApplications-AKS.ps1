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

Write-Host "Starting deployment of application and services" -ForegroundColor Yellow

Write-Host "Deploying Consumer" -ForegroundColor Yellow
Set-Location $applicationConsumerRootDirectory
kubectl apply --filename deployment.yml

Write-Host "Consumer Worker deployed successfully" -ForegroundColor Cyan

Write-Host "Deploying Producer" -ForegroundColor Yellow
Set-Location $applicationProducerRootDirectory
kubectl apply --recursive --filename .

Write-Host "Producer WebApi deployed successfully" -ForegroundColor Cyan

Write-Host "All the services related to the application have been successfully deployed" -ForegroundColor Cyan

Set-Location .\..\..\Powershell