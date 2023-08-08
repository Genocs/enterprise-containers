# Azure Container Service with Terraform

This section describes about standing up the AKS using terraform.

## Pre-requisites

1. Terraform v1.2.x+. Install instructions [hashicorp terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

2. Setup Terraform with Azure. Follow the instructions [here](https://docs.microsoft.com/en-us/azure/developer/terraform/install-configure)
3. Make sure you have the following environment variables defined.


``` bash
# Your subscription ID
ARM_SUBSCRIPTION_ID=<your subscription ID>
ARM_TENANT_ID=<your_tenant_id>
ARM_CLIENT_SECRET=<your_client_secret>
ARM_CLIENT_ID=<your_client_id>
```

## Bootstrapping

You need the following environment variable defined.

``` bash
TF_VAR_client_id=<The same as the one defined for ARM_CLIENT_ID>
TF_VAR_client_secret=<The same as the one defined for ARM_CLIENT_SECRET>
```

**Please note that the case matters**

`client_id` and `client_secret` must be in small letters.

Steps:
* Go to directory `terraform`.
* Modify the `variables.tf` file so suit your needs.

Below are the current values defined.

``` json
variable "cluster_name" {
    type        = string
    description = "The cluster name." 
    default     = "aksgenocs"
}

variable "location" {
    type        = string
    description = "The Azure location to use." 
    default     = "westeurope"
}

variable "node_count" {
    type        = number
    description = "The number of nodes to bootstrap" 
    default     = 1
}

variable "vm_size" {
    type        = string
    description = "The vm size to use" 
    default     = "Standard_DS2_v2"
}

variable "vm_os" {
    type        = string
    description = "The operating system of the node" 
    default     = "Linux"
}

variable "vm_disk_size" {
    type        = number
    description = "The disk size of the node in GB" 
    default     = 50
}

variable "kubernetes_version" {
    type        = string
    description = "The kubernetes version" 
    default     = "1.24.6"
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}
```

Once the variables are ready, you are ready to go!

``` bash
# 1. Check what terraform will create for you
terraform plan

# 2. Apply the plan
terraform apply

# 3. Destroying the cluster
#    Once you are ready to destroy the cluster, simply execute
terraform destroy
```

You will be asked to continue or not.

## Output

This terraform will output in the console the `KUBECONFIG` raw content, after the successful execution.

To control what to be outputted, go to the file `output.tf` and change accordingly.

Sample output:

**Please note that sensitive information below are `REDACTED`**

``` bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

client_certificate = [REDACTED]
client_key = [REDACTED]
cluster_ca_certificate = [REDACTED]

cluster_username = clusterUser_demo-kube-group_demo-k8s
host = https://demo-k8s-5eb1f664.hcp.westeurope.azmk8s.io:443
kube_config = apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: [REDACTED]
    server: https://demo-k8s-5eb1f664.hcp.westeurope.azmk8s.io:443
  name: demo-k8s
contexts:
- context:
    cluster: demo-k8s
    user: clusterUser_demo-kube-group_demo-k8s
  name: demo-k8s
current-context: demo-k8s
kind: Config
preferences: {}
users:
- name: clusterUser_demo-kube-group_demo-k8s
  user:
    client-certificate-data: [REDACTED]
    client-key-data: [REDACTED]
    token: [REDACTED]
```
