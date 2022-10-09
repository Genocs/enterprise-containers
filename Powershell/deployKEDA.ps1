# Add the Autoscaler to the cluster
helm repo add kedacore https://kedacore.github.io/charts

helm repo update

Write-Host "Initializing KEDA on AKS cluster" -ForegroundColor Green

# Helm 3 syntax
helm upgrade --install keda `
    kedacore/keda `
    --version 2.4.0 `
    --create-namespace `
    --namespace keda

Write-Host "Deployment of KEDA using Helm completed successfully" -ForegroundColor Yellow