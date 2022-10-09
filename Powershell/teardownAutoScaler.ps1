# source common variables
. .\vars.ps1

Write-Host "Starting deletion of ScaledObject and related resources from Kubernetes cluster" -ForegroundColor Yellow

Write-Host "Deleting Tech Talks Consumer Autoscaler" -ForegroundColor Yellow
Set-Location $autoScalerRootDirectory
kubectl delete --recursive --filename .

Write-Host "ScaledObject and related resources deleted successfully" -ForegroundColor Cyan

Set-Location .\..\..\Powershell
