# Add the MongoDB repository
helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo

helm repo update

Write-Host "Starting deployment of MongoDB on AKS cluster using Helm" -ForegroundColor Yellow
    
helm install mongo oci://registry-1.docker.io/bitnamicharts/mongodb
# azure-marketplace/mongodb

Write-Host "Deployment of MongoDB using Helm completed successfully" -ForegroundColor Yellow

# Refer to the mongodb helm chart documentation for parameters and more details
# https://github.com/bitnami/charts/tree/master/bitnami/mongodb/#installing-the-chart

# To access the MongoDB service from outside the cluster, you need to expose the service using a LoadBalancer
kubectl patch svc/mongo-mongodb -p '{"spec":{"type":"LoadBalancer"}}'