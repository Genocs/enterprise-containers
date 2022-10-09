Write-Host "Provisioning AKS cluster with default parameters" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\initializeAKS-virtual-node.ps1")

Write-Host "Installing KEDA on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployKEDA.ps1")

Write-Host "Installing RabbitMQ on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployRabbitMQ.ps1")

Write-Host "Installing Applications on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployApplications-AKS-virtual-node.ps1")

Write-Host "Installing Autoscaler on cluster" -ForegroundColor Cyan
& ((Split-Path $MyInvocation.InvocationName) + "\deployAutoScaler.ps1")