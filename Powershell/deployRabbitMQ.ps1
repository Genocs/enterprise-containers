# Add the Rabbitmq repository
helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo

helm repo update

Write-Host "Starting deployment of RabbitMQ on AKS cluster using Helm" -ForegroundColor Yellow

helm upgrade --install rabbitmq `
    bitnami/rabbitmq `
    --version 12.0.8 `
    --set auth.username=guest `
    --set auth.password=guest `
    --set auth.erlangCookie=c2VjcmV0Y29va2ll `
    --set metrics.enabled=true
    
# azure-marketplace/rabbitmq
    

Write-Host "Deployment of RabbitMQ using Helm completed successfully" -ForegroundColor Yellow

# Refer to the rabbitmq helm chart documentation for parameters and more details
# https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq/#installing-the-chart

# To access the MongoDB service from outside the cluster, you need to expose the service using a LoadBalancer
kubectl patch svc/rabbitmq -p '{"spec":{"type":"LoadBalancer"}}'

# kubectl patch svc genocsdemo.genocs-demo-service -p '{"spec":{"type":"LoadBalancer"}}'
# kubectl patch svc --namespace genocsdemo genocs-demo-service -p '{"spec":{"type":"LoadBalancer"}}'