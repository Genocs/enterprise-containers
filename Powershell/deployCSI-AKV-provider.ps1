# Add Azure CSI Secret Store Provider to the cluster
helm repo add `
    csi-secrets-store-provider-azure `
    https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts

helm repo update    

Write-Host "Starting deployment of Azure CSI Secret Store Provider using Helm" -ForegroundColor Yellow

helm install csi-azure-driver `
    csi-secrets-store-provider-azure/csi-secrets-store-provider-azure 

Write-Host "Deployment of Azure CSI Secret Store Provider using Helm completed successfully" -ForegroundColor Yellow