# Add the Jaeger distributed tracing
helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo

helm repo update

Write-Host "Starting deployment of Jaeger on AKS cluster using Helm" -ForegroundColor Yellow
    
helm install jaeger oci://registry-1.docker.io/bitnamicharts/jaeger

Write-Host "Deployment of Jaeger using Helm completed successfully" -ForegroundColor Yellow

# Refer to the bitnami jaeger helm chart documentation for parameters and more details
# https://github.com/bitnami/charts/tree/main/bitnami/jaeger/#installing-the-chart

# To access the Jaeger service from outside the cluster, you need to expose the service using a LoadBalancer
kubectl patch svc/jaeger-query -p '{"spec":{"type":"LoadBalancer"}}'