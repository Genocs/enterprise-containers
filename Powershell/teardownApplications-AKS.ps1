Write-Host "Starting deletion of application and services" -ForegroundColor Yellow

# source common variables
. .\var.ps1

Write-Host "Deleting application consumer " -ForegroundColor Yellow
Set-Location $applicationConsumerRootDirectory
# kubectl delete --recursive --filename .
kubectl delete deployment rabbitmq-consumer-deployment

Write-Host "Application consumer service deleted successfully" -ForegroundColor Cyan

Write-Host "Deleting application producer" -ForegroundColor Yellow
Set-Location $applicationProducerRootDirectory
kubectl delete --recursive --filename .

Write-Host "Application producer deleted successfully" -ForegroundColor Cyan

Write-Host "All the application services have been successfully deleted" -ForegroundColor Cyan

Set-Location .\..\..\Powershell