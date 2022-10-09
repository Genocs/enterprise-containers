# source common variables
. .\vars.ps1

Write-Host "Starting deployment of ScaledObject and related resources to Kubernetes cluster" -ForegroundColor Yellow

Write-Host "Deploying Application Autoscaler" -ForegroundColor Yellow
Set-Location $autoScalerRootDirectory
kubectl apply --recursive --filename .

Write-Host "ScaledObject and related resources deployed successfully" -ForegroundColor Cyan

Set-Location .\..\..\Powershell