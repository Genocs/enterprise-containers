# Add the Prometheus and Grafana to the cluster

Write-Host "Creating Prometheus namespace" -ForegroundColor Yellow
kubectl create namespace prometheus

# Using the prometheus-community version
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

Write-Host "Starting deployment of Prometheus using Helm" -ForegroundColor Yellow
helm upgrade -i prometheus prometheus-community/prometheus `
    –namespace prometheus

# The command below allows to check the installation
# kubectl get pods -n Prometheus


# Grafana section
Write-Host "Creating Grafana namespace" -ForegroundColor Yellow
kubectl create namespace grafana

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

Write-Host "Starting deployment of Grafana using Helm" -ForegroundColor Yellow
helm install grafana grafana/grafana `
    –namespace grafana `
    –set persistence.enabled=true `
    –set adminPassword=’EKS!sAWSome’ `
    –set datasources.”datasources\.yaml”.apiVersion=1 `
    –set datasources.”datasources\.yaml”.datasources[0].name=Prometheus `
    –set datasources.”datasources\.yaml”.datasources[0].type=prometheus `
    –set datasources.”datasources\.yaml”.datasources[0].url=http://prometheus-server.prometheus.svc.cluster.local `
    –set datasources.”datasources\.yaml”.datasources[0].access=proxy `
    –set datasources.”datasources\.yaml”.datasources[0].isDefault=true 

# The command below allow to check the installation
# kubectl get all -n grafana

Write-Host "Deployment of Prometheus and Grafana using Helm completed successfully" -ForegroundColor Yellow