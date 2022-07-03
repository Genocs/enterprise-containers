# source common variables
. .\var.ps1

Write-Host "Starting deployment of application and services" -ForegroundColor Yellow

Write-Host "Deploying Application Consumer" -ForegroundColor Yellow
Set-Location $applicationConsumerRootDirectory
kubectl apply --filename consumer-deployment-virtual-node.yml

Write-Host "Application Consumer deployed successfully" -ForegroundColor Cyan

Write-Host "Deploying Application Producer" -ForegroundColor Yellow
Set-Location $applicationProducerRootDirectory
kubectl apply --recursive --filename .

Write-Host "Application Producer deployed successfully" -ForegroundColor Cyan

Write-Host "All the services have been successfully deployed" -ForegroundColor Cyan