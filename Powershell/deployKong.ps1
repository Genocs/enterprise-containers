# Add the kong repository
helm repo add kong https://charts.konghq.com
helm repo update

Write-Host "Initializing KONG Ingress on AKS cluster using Helm" -ForegroundColor Green

kubectl create namespace kong

# Use Helm to deploy an KONG ingress controller
helm install kong/kong `
    --namespace kong `
    --generate-name `
    --set ingressController.installCRDs=false

Write-Host "Deployment of KONG Ingress using Helm completed successfully" -ForegroundColor Yellow