# Add the Rabbitmq repository
helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo

helm repo update

Write-Host "Starting deployment of RabbitMQ on AKS cluster using Helm" -ForegroundColor Yellow

helm upgrade --install rabbitmq `
    bitnami/rabbitmq `
    --version 10.1.9 `
    --set auth.username=user `
    --set auth.password=PASSWORD `
    --set auth.erlangCookie=c2VjcmV0Y29va2ll `
    --set metrics.enabled=true
    
# azure-marketplace/rabbitmq
    

Write-Host "Deployment of RabbitMQ using Helm completed successfully" -ForegroundColor Yellow

# Refer to the rabbitmq helm chart documentation for parameters and more details
# https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq/#installing-the-chart