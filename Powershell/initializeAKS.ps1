Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Pagamento in base al consumo",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "RG-Genocs-akst",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "West Europe",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "aksgenocs",
    [parameter(Mandatory = $false)]
    [int16]$workerNodeCount = 1,
    [parameter(Mandatory = $false)]
    [string]$kubernetesVersion = "1.23.5",
    [parameter(Mandatory = $false)]
    [string]$kubernetesVMSize = "Standard_DS2_v2",    
    [parameter(Mandatory = $false)]
    [string]$acrRegistryName = "genocsakst"
)

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName" -ForegroundColor Yellow
az account set --subscription=$subscriptionName

# Create resource group if it doesn't exist
$rgExists = az group exists --name $resourceGroupName
Write-Host "$resourceGroupName exists: $rgExists"

if ($rgExists -eq $false) {

    # Create resource group name
    Write-Host "Creating resource group $resourceGroupName in region $resourceGroupLocation" -ForegroundColor Yellow
    az group create `
        --name=$resourceGroupName `
        --location=$resourceGroupLocation `
        --output=jsonc
}

# Create Kubernetes Cluster if it doesn't exist
$aksCounts = az aks list --query "length([?name == '$clusterName' && resourceGroup == '$resourceGroupName'].{Name: name})"

if ($aksCounts -eq 0) {
    # Create AKS cluster
    Write-Host "Creating AKS cluster '$clusterName' with resource group $resourceGroupName in region $resourceGroupLocation" -ForegroundColor Yellow
    az aks create `
        --resource-group=$resourceGroupName `
        --name=$clusterName `
        --location=$resourceGroupLocation `
        --node-count=$workerNodeCount `
        --node-vm-size=$kubernetesVMSize `
        --enable-addons azure-keyvault-secrets-provider `
        --enable-managed-identity `
        --generate-ssh-keys `
        --output=jsonc `
        --kubernetes-version=$kubernetesVersion `
        --attach-acr=$acrRegistryName 
    # --aks-custom-headers="CustomizedUbuntu=aks-ubuntu-1804,ContainerRuntime=containerd" `

    #check the status of last command
    if (!$?) {
        Write-Error "Error creating ASK cluster" -ErrorAction Stop
    }
}

# Get AKS credentials for newly created cluster
# needed to connect to AKS
Write-Host "Getting credentials for cluster $clusterName" -ForegroundColor Yellow
az aks get-credentials `
    --resource-group=$resourceGroupName `
    --name=$clusterName `
    --admin `
    --overwrite-existing

Write-Host "Successfully created cluster $clusterName with $workerNodeCount node(s)" -ForegroundColor Green

Write-Host "Creating cluster role binding for Kubernetes dashboard" -ForegroundColor Green

kubectl create clusterrolebinding kubernetes-dashboard `
    -n kube-system `
    --clusterrole=cluster-admin `
    --serviceaccount=kube-system:kubernetes-dashboard