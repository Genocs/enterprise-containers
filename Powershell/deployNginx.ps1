# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

Write-Host "Initializing NGINX Ingress on AKS cluster using Helm" -ForegroundColor Green

# kubectl create namespace nginx-ingress

# Use Helm to deploy an NGINX ingress controller
helm upgrade nginx-ingress ingress-nginx/ingress-nginx `
    --namespace nginx-ingress `
    --set controller.replicaCount=2 `
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux `
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux `
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux `
    --set controller.customPorts="8085"

Write-Host "Deployment of NGINX Ingress using Helm completed successfully" -ForegroundColor Yellow