Write-Host "Starting deletion of application Worker and WebApi" -ForegroundColor Yellow

# source common variables
. .\vars.ps1

Write-Host "Deleting Application consumer" -ForegroundColor Yellow
Set-Location $applicationConsumerRootDirectory
# kubectl delete --recursive --filename .
kubectl delete deployment rabbitmq-consumer-deployment

Write-Host "Application consumer Worker deleted successfully" -ForegroundColor Cyan

Write-Host "Deleting Application Producer" -ForegroundColor Yellow
Set-Location $applicationProducerRootDirectory
kubectl delete --recursive --filename .

Write-Host "Application Producer eleted successfully" -ForegroundColor Cyan

Write-Host "All the application services have been successfully deleted" -ForegroundColor Cyan

Set-Location .\..\..\Powershell