# Add the ingress-nginx repository
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

Write-Host "Initializing NGINX Ingress on AKS cluster using Helm" -ForegroundColor Green

# kubectl create namespace nginx-ingress

helm install nginx-ingress nginx-stable/nginx-ingress `
    --namespace nginx-ingress `
    --set controller.replicaCount=2 `
    --skip-crds

# Use Helm to deploy an NGINX ingress controller
#helm upgrade nginx-ingress nginx-stable/nginx-ingress `
#    --namespace default `
#    --set controller.replicaCount=2 `
#    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux `
#    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux `
#    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux `
#    --set controller.customPorts="8085"

Write-Host "Deployment of NGINX Ingress using Helm completed successfully" -ForegroundColor Yellow