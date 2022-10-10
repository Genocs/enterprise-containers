# Enterprise Kubernetes Cluster Setup

![Azure-KEDA](/images/Azure-KEDA.drawio.svg)

Setup Kubernetes cluster to be production ready isn't a simple and straightforward task. It requires to take in consideration many topics.


In this walkthrough will be implemented the steps required to setup the cluster. This proposal is thought as to be used on Azure, even though most of the options could be reused for any cloud provider like Google Cloud or AWS.

## Prerequisites

- **Azure Subscription** to create AKS cluster
- **kubectl** logged into kubernetes cluster
- **Powershell**
- **Postman**
- **Helm**
- **DockerHub account** (optional)

## Introduction

The setup process can be spitted into different steps:

- Bare setup
- Security
- Scaling
- Monitoring
- Application


## Setup - Overview

During this step we are going to setup Kubernetes cluster tackling the following components:

- Setup private images repository
- Setup the cluster
- Setup the secrets vault
- Setup network infrastructure 
- Secure secrets hiding sensitive data
- Setup autoscaler

### Monitoring

The monitoring will be implemented using open source components. The implementation will monitor both infrastructure and application side:

- [Grafana](https://grafana.com/)
- [Jaeger](https://www.jaegertracing.io/)
- [Promotheus](https://prometheus.io/)

The entreprise version require an active subscription or to pay a fee.  

### Security and Networking

Security and Networking context will implement all the components that allows to handle routing, to send requests to services throughout a reverse proxy, secure APIs calls using SSL termination.

The main components are:

- Public IP
- Vnet with Subnet
- Api Gateway Ingress Controller

There are various products out of the box that can be used to implement the solution. All of them have PROS and CONS.

The most used ones are:

- [Azure AGIC](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-install-new)
- [NGNIX](https://www.nginx.com/)
- [Kong](https://konghq.com/)

In this solution the first choice is based on `Kong`.

Authentication and authorization are implemented using `OAuth2`. `Kong` provides plugin that streamline the implementation.

- [OAuth2](https://oauth.net/2/)
- [OpenId](https://openid.net/connect/)

## KEDA - Kubernetes-based Event Driven Autoscaling

There are multiple options for scaling Kubernetes and containers in general.

Here `(KEDA) Kubernetes-based Event Driven Autoscaling` will be used.

RabbitMQ is used as the event source.


If you wish to use Kubernetes cluster apart from AKS, you can skip the `Step 2.1` of provisioning the cluster and [install KEDA](https://github.com/kedacore/keda#setup) on your own Kubernetes cluster.

Similarly, if you do not wish to execute the PowerShell scripts, you can execute the commands which are part of those scripts manually.

### Event Driven Autoscaling

There are multiple options for scaling with Kubernetes and containers in general. This demo uses `Kubernetes-based Event Driven Autoscaling (KEDA)`. RabbitMQ is used as an event source.

## Code organization

### [docker-compose](docker-compose)

Contains the docker compose files to install on docker a bunch of enterprise level tools.

Please refere to this [README](/docker-compose/README.md) for details.

### [docs](docs)

Contains the explanation files.

Contains the source code for an hypothetical application.

`Genocs.KubernetesCourse.WebApi` contains the code generating the events / messages which are published to a RabbitMQ queue.

- [aks-preview](aks-preview.md)
- [azure-developer-community](azure-developer-community.md)
- [minikube-wsl2](minikube-wsl2.md)
- [monitoring-and-observability](monitoring-and-observability.md)

### [src](src)

Contains the source code for a model class used by two services:

- The **Producers**: a WebApi that send messages to RabbitMQ cluster
- The **Consumers**: a Worker listening RabbitMQ messages.

`Genocs.KubernetesCourse.WebApi` contains the code for generating the messages which are published to a RabbitMQ queue.

`Genocs.KubernetesCourse.Worker` contains the consumer code processing RabbitMQ messages.

Both the Producer and Consumer uses the common data model. In order to build these you could use Dockerfile. We define the [Genocs.KubernetesCourse.WebApi](/src/Genocs.KubernetesCourse.WebApi.dockerfile) and [Genocs.KubernetesCourse.Worker](/src/Genocs.KubernetesCourse.Worker.dockerfile). These are built [docker-compose-build](/src/docker-compose-build.yml) file.

**NOTE**

The RabbitMQ cluster is installed inside the same kubernetes cluster.

In order to build these using Dockerfile:

- [Genocs.KubernetesCourse.WebApi](/src/Genocs.KubernetesCourse.WebApi.dockerfile)
- [Genocs.KubernetesCourse.Worker](/src/Genocs.KubernetesCourse.Worker.dockerfile)

You can build them and they are ready to be pushed to Azure Container Registry or DockerHub.

[docker-compose ACR](/src/docker-compose-acr.yml)

[docker-compose Dockerhub](/src/docker-compose-dockerhub.yml)

The docker images can be built using the following command:

``` ps
Measure-Command { docker-compose -f docker-compose-dockerhub.yml build | Out-Default }
```

Once the images are built successfully, we can push them to the DockerHub registry using the command

``` ps
Measure-Command { docker-compose -f docker-compose-dockerhub.yml push | Out-Default }
```

### [Powershell](Powersehll)

Contains the helper PowerShell scripts to:

- Provisioning the AKS cluster
- To proxy into the Kubernetes control plane
- To deploy the application
- To delete the application
- To delete the resource group (**AKS is expensive to keep alive**)

### [k8s](k8s)

Contains Kubernetes manifest files for deploying the Producer, Consumer and the Autoscaler components to the Kubernetes cluster.

### [helm](helm)

Contains the Helm RBAC enabling yaml file which add the Cluster Role Binding for RBAC enabled Kubernetes cluster.

This was required before Helm 3.0 for the Tiller service. With helm 3.0, Tiller is no longer required.

### [terraform](terraform)

Contains the terraform Kubernetes cluster setup. The setup is primary meant to be used on Azure. Anyway, deploy on other cloud Provider is quite straightforward.

## [skaffold](skaffold)

The Skaffold and Kaniko Kubernetes cluster setup.

This allows to setup Kubernetes cluster on Google Cloud.


# Setup - Details

## Steps
1. Install Azure Container Registry
2. Install Kubernetes Cluster
3. Install Azure Key Vault
4. Setup Network Infrastructure
5. Deploy Azure Key Vault Secret
6. Deploy RabbitMQ node inside the AKS
7. Deploy Keda Autoscaler
8. Deploy Application
9. Deploy Application AutoScaler

### 2.1 Initialize ACR

The **ACR** (Azure Container Registry) allows to store Docker images inside a private repositoy 

Run [initializeACR](/Powershell/initializeACR.ps1) powershell script with default values from root directory

``` PS
.\Powershell\initializeACR.ps1
```

### 2.2 Initialize AKS cluster

Run [initializeAKS](/Powershell/initializeAKS.ps1) powershell script with default values from root directory

``` PS
.\Powershell\initializeAKS.ps1
```

### 2.3 Initialize AKV

The **AKV** Azure Key Vault is used to store every secret used by the application, as connection string, API Key and so on, in a safe place.

Run [initializeAKV](/Powershell/initializeAKV.ps1) powershell script with default values from root directory

``` PS
.\Powershell\initializeAKV.ps1
```

### 2.4 Setup Network Infrastrutture

The **AKS** will use a network infrastructure composed by:
- Public IP
- VNET
- AGIC

The Poweshell script will *'Create peering beetween AGIC and AKS and viceversa'* as well

Run [initializeNetwork](/Powershell/initializeNetwork.ps1) powershell script with default values from root directory

``` PS
.\Powershell\initializeNetwork.ps1
```

### 2.5 Deploy AKV Secret

This step shows how to setup a script file to initialize some Secret inside AKV

``` PS
.\Powershell\deployAKV-secrets.ps1
```

### 2.6 Deploy RabbitMQ node

This step shows how to setup a RabbitMQ node inside AKS.

***Please do not use it for Production***.

``` PS
.\Powershell\deployRabbitMQ.ps1
```

### 2.7 Deploy KEDA Autoscaler

This step shall install the KEDA autoscaler inside AKS.

``` PS
.\Powershell\deployKEDA.ps1
```

Verify KEDA is installed correctly on the Kubernetes cluster.

``` bash
kubectl get all -n keda
```

### 2.8 Deploy Demo Application

Deploy Producers & Consumers

Execute the powershell script.

``` PS
.\Powershell\deployApplications-AKS.ps1
```

The `deployApplications-AKS` powershell script deploys the RabbitMQConsumer and RabbitMQProducer in the correct order. 

Alternately, all the components can also be deployed directly using the `kubectl` apply command recursively on the k8s directory as shown below:

``` bash
# Run the kubectl apply recursively on k8s directory
kubectl apply -R -f .
```

### 2.9 Deploy Autoscaler for Application Autoscaler

Execute the `deployAutoScaler.ps1` powershell script.

``` PS
.\Powershell\deployAutoScaler.ps1
```

**Note**

The default options can be overwritten by passing arguments to the initializeAKS script. In the below example, we are overriding the number of nodes in the AKS cluster to 4 instead of 3 and resource group name as `kedaresgrp`.

``` PS
.\Powershell\initilaizeAKS `
    -workerNodeCount 4 `
    -resourceGroupName "kedaresgrp"
```

If you do not wish to run the individual PowerShell scripts, you can run one single script which will deploy all the necessary things by running the above scripts in correct order.

``` PS
.\Powershell\deployAll.ps1
```

### 2.10 Get list of all the services deployed in the cluster

We will need to know the service name for RabbitMQ to be able to do port forwarding to the RabbitMQ management UI and also the public IP assigned to the Application producer WebApi which will be used to generate the messages onto RabbitMQ queue.

``` bash
kubectl get svc
```

![List of all Kubernetes services](/images/all-services.png)

As we can see above, RabbitMQ service is available within the Kubernetes cluster and it exposes `4369`, `5672`, `25672` and `15672` ports. We will be using `15672` port to map to a local port.

Also note the public `LoadBalancer` IP for the Producer Service. In this case the IP is **`52.139.237.252`**.

**Note:**

This IP will be different when the services are redeployed on a different Kubernetes cluster.

### 2.11 Watch for deployments

The rabbitmq `ScaledObject` will be deployed as part of the deployment. Watch out for the deployments to see the changes in the scaling as the number of messages increases

``` bash
kubectl get deployment -w
kubectl get deploy -w
```

![List of all Kubernetes services](/images/initial-deploy-state.png)

Initially there is 1 instance of rabbitmq-consumer and 2 replicas of the rabbitmq-producer (Producer) deployed in the cluster.

### 2.12 Port forward for RabbitMQ management UI

We will use port forwarding approach to access the RabbitMQ management UI.

``` bash
kubectl port-forward svc/rabbitmq 15672:15672
```

### 2.13 Browse RabbitMQ Management UI

http://localhost:15672/

Login to the management UI using credentials as `user` and `PASSWORD`. Remember that these were set during the installation of RabbitMQ services using Helm. If you are using any other user, please update the username and password accordingly.

### 2.14 Generate load using `Postman`

I am using [Postman](https://www.getpostman.com/) to submit a POST request to the API which generates 2000 messages onto a RabbitMQ queue named `hello`. You can use any other command line tool like CURL to submit a GET request.

Use the `EXTERNAL-IP -52.139.237.252` with port `8080` to submit a GET request to the API. http://52.139.237.252:8080/api/TechTalks/Generate?numberOfMessages=2000

![postman success](/images/postman-get-request.png)

Note that we are setting the number of messages to be produced by Producer as 2000 in this case. You can change the number to any other integer value.

After building the GET query, hit the blue `Send` button on the top right. If everything goes fine, you should receive a `200 OK` as status code.

![postman success](/images/postman-success.png)

The Producer will produce 2000 messages on the queue named `hello`. The consumer is configured to process `10` messages in a batch. The Consumer take the message, deserialize it and send the ACK to the message broker.

### 2.15 Auto-scaling in action

See the number of containers for consumer grow to adjust the messages and also the drop when messages are processed.

![autoscaling consumers](/images/pods-and-deployments-autoscaled.png)

On the left hand side of the screen you can see the pods auto scaled and on the right we see the deploymnets autoscaled progressively to 2, 4, 8, 16 and 30.

While the messages are being processed, we can also observe the RabbitMQ management UI.

![autoscaling consumers](/images/RabbitMQ-managementUI.PNG)

Our consumer processes 50 messages in a batch by prefetching them together. This can be verified by looking at the details of the consumers.

![Prefetch messages](/images/rabbitMQ-prefetch.PNG)

Once all the messages are processed, KEDA will scale down the pods and the deployments.

![autoscaled down consumers](/images/pods-and-deployments-scaled-down.png)

List Custom Resource Definition

``` bash
kubeclt get crd
```

![autoscaled down consumers](/images/KEDA-CRD.PNG)

---

As part of the KEDA installation, ScaledObject and TriggerAuthentications are deployed on the Kubernetes cluster.

## Acknowledgements

A lot of people inspired me and provided unevaluable amount of information:

Here some of them:
- [NileshGule](https://github.com/NileshGule/)
- [DevMentors](https://github.com/devmentors/)