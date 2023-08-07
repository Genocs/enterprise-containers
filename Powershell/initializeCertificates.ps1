# Please check the documentation at: https://cert-manager.io/docs/

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml

# Wait for cert-manager to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=cert-manager -n cert-manager --timeout=300s

# Create the certificate issuer look into the certificate-issuer.yaml file for more details
kubectl create -f ./certificate-issuer.yaml 
