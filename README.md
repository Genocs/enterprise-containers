# Enterprise Kubernetes Cluster Setup

[![GitHub](https://img.shields.io/github/license/Genocs/genocs-library?color=2da44e&style=flat-square)](https://github.com/Genocs/enterprice-containers/blob/main/LICENSE)
[![Discord](https://img.shields.io/discord/1106846706512953385?color=%237289da&label=Discord&logo=discord&logoColor=%237289da&style=flat-square)](https://discord.com/invite/fWwArnkV)
[![Twitter](https://img.shields.io/twitter/follow/genocs?color=1DA1F2&label=Twitter&logo=Twitter&style=flat-square)](https://twitter.com/genocs)

---

![Azure-KEDA](/images/Azure-KEDA.drawio.svg)

Setup Kubernetes cluster to be production ready isn't a simple task. It requires to take in consideration many topics.

In this walkthrough we will setup the steps required to have a Kubernetes cluster up and running.

This proposal is thought as to be used on Azure, even though most of the options could be reused for any cloud provider like Google Cloud or AWS.

## Prerequisites

- **Azure Subscription** to create AKS cluster
- **kubectl** logged into kubernetes cluster
- **Powershell**
- **Postman**
- **Helm**
- **DockerHub account** (optional)

## Introduction

The setup process can be spitted into different steps:

- Bare components
- Security
- Scaling
- Monitoring
- Application

## Setup - Overview

During this step we are going to setup Kubernetes cluster tackling the following components:

- Setup private Docker images repository
- Setup the Kubernetes cluster
- Setup the vault for secrets
- Secure secrets
- Setup networking
- Setup autoscaler

### Monitoring

The implementation will monitor both infrastructure and application side.

The monitoring will be implemented using different approach. Some are open source, other don't.

Open-source Components uses in this demo:

- [Grafana](https://grafana.com/)
- [Jaeger](https://www.jaegertracing.io/)
- [Promotheus](https://prometheus.io/)

**NOTE:** The open-source components have the entreprise version. It requires to have active subscription if you plan to use them.  

### Security and Networking

Security and Networking context will implement all the components that allows to handle:

- routing (forward requests to the services throughout a reverse proxy)
- termination (secure APIs calls by SSL or TLS)
- throttling

Main components are:

- Public IP
- Vnet and Subnet
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

## Autoscaler

There are multiple options for scaling Kubernetes and containers in general.

Here `(KEDA) Kubernetes-based Event Driven Autoscaling` will be used.

RabbitMQ is used as the event source.

If you wish to use Kubernetes cluster apart from AKS, you can skip the `Step 2.1` of provisioning the cluster and [install KEDA](https://github.com/kedacore/keda#setup) on your own Kubernetes cluster.

Similarly, if you do not wish to execute the PowerShell scripts, you can execute the commands which are part of those scripts manually.

## Code organization

### [docker-compose](docker-compose)

Contains the docker compose files to install a bunch of enterprise level tools.

Please refer to this [README](/docker-compose/README.md) for details.

### [docs](docs)

Contains some useful documentation like:

- [aks-preview](aks-preview.md)
- [azure-developer-community](azure-developer-community.md)
- [minikube-wsl2](minikube-wsl2.md)
- [monitoring-and-observability](monitoring-and-observability.md)

### [src](src)

Contains the source code for a hypothetical application.

It contains the source code for a model class used by two services:

- The **Producers**: a WebApi that send messages to RabbitMQ cluster
- The **Internal Service**: a WebApi that can be used only inside the cluster
- The **Consumers**: a Worker listening RabbitMQ messages.

`Genocs.KubernetesCourse.WebApi` contains the code for generating the messages which are published to a RabbitMQ queue, as well as to call an internal WebApi.

`Genocs.KubernetesCourse.Internal.WebApi` contains the code for the WebApi used only inside the cluster.

`Genocs.KubernetesCourse.Worker` contains the consumer code processing RabbitMQ messages.

Both the Producer and Consumer uses the common data model.

In order to build these using Dockerfile:

- [Genocs.KubernetesCourse.WebApi](/src/Genocs.KubernetesCourse.WebApi.dockerfile)
- [Genocs.KubernetesCourse.Internal.WebApi](/src/Genocs.KubernetesCourse.Internal.WebApi.dockerfile)
- [Genocs.KubernetesCourse.Worker](/src/Genocs.KubernetesCourse.Worker.dockerfile)

You can build them and they are ready to be pushed to:

- Azure Container Registry [docker-compose ACR](/src/docker-compose-acr.yaml)
- DockerHub [docker-compose Dockerhub](/src/docker-compose-dockerhub.yaml)

The docker images can be built and push to dockerhub using the following commands:

``` ps
# Build
docker-compose -f .\src\docker-compose-dockerhub.yaml build

# Push
docker-compose -f .\src\docker-compose-dockerhub.yaml push
```

**NOTE:** Please update the yaml files with the correct image version before use them.

### [Powershell](Powersehll)

Contains the helper PowerShell scripts to:

- Provisioning the AKS cluster
- To proxy into the Kubernetes control plane
- To deploy the application
- To delete the application
- To delete the resource group

**NOTE: AKS is expensive to keep alive**

### [k8s](k8s)

Contains Kubernetes manifest files for deploying the Producer, Consumer and the Autoscaler components to the Kubernetes cluster.

### [helm](helm)

Contains the Helm RBAC enabling yaml file which add the Cluster Role Binding for RBAC enabled Kubernetes cluster.

This was required before Helm 3.0 for the Tiller service. With helm 3.0, Tiller is no longer required.

### [terraform](terraform)

Contains the terraform Kubernetes cluster setup. The setup is primary meant to be used on Azure. Anyway, deploy on other cloud Provider is quite straightforward.

### [skaffold](skaffold)

The Skaffold and Kaniko Kubernetes cluster setup.

This allows to setup Kubernetes cluster on Google Cloud.

## Setup - Details

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

The **ACR** (Azure Container Registry) allows to store Docker images inside a private repositoy.

Run [initializeACR](/Powershell/initializeACR.ps1) powershell script with default values from root directory.

``` PS
.\Powershell\initializeACR.ps1
```

### 2.2 Initialize AKS cluster

Run [initializeAKS](/Powershell/initializeAKS.ps1) powershell script with default values from root directory.

``` PS
.\Powershell\initializeAKS.ps1
```

### 2.3 Initialize AKV

The **AKV** Azure Key Vault is used to store every secret used by the application in a safe place.

Secret data are:

- connection strings
- API Key
- certificates
- public/private keys

Run [initializeAKV](/Powershell/initializeAKV.ps1) powershell script with default values from root directory.

``` PS
.\Powershell\initializeAKV.ps1
```

### 2.4 Setup Network Infrastrutture

The **AKS** will use a network infrastructure composed by:

- Public IP
- VNET
- AGIC (Application Gateway Ingress Controller)

The Poweshell script will *'Create peering beetween AGIC and AKS and viceversa'* as well.

Run [initializeNetwork](/Powershell/initializeNetwork.ps1) powershell script with default values from root directory.

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

Deploy Producers, Internal Service and Consumers.

Execute the powershell script.

``` PS
# Use this to setup the application with Secret coming from file
cd Powershell 
.\deployApplications-AKS-SecretFile.ps1
cd ..
```

``` PS
# Use this to deploy the application using secret coming from Key Vault
cd Powershell 
.\Powershell\deployApplications-AKS.ps1
cd ..
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
cd Powershell 
.\deployAutoScaler.ps1
cd ..
```

**Note:** The default options can be overwritten by passing arguments to the initializeAKS script. In the below example, we are overriding the number of nodes in the AKS cluster to 4 instead of 3 and resource group name as `kedaresgrp`.

``` PS
.\Powershell\initilaizeAKS `
    -workerNodeCount 4 `
    -resourceGroupName "kedaresgrp"
```

If you do not wish to run the individual PowerShell scripts, you can run one single script which will deploy all the necessary things by running the above scripts in correct order.

``` PS
.\Powershell\deployAll.ps1
```

### 2.10 Get list of the resources

We will need to know the service name for RabbitMQ to be able to do port forwarding to the RabbitMQ management UI and also the public IP assigned to the Application producer WebApi which will be used to generate the messages onto RabbitMQ queue.

``` bash
# Get services
kubectl get svc

# Get pod
kubectl get pod

# Get deployments
kubectl get deployment

# Get secrets
kubectl get secret

# Get custom resource definition
kubectl get crd
```

![List of all Kubernetes services](/images/all-services.png)

As we can see above, RabbitMQ service is available within the Kubernetes cluster and it exposes `4369`, `5672`, `25672` and `15672` ports. We will be using `15672` port to map to a local port.

Also note the public `LoadBalancer` IP for the Producer Service. In this case the IP is **`52.139.237.252`**.

**Note:** This IP will be different when the services are redeployed on a different Kubernetes cluster.

### 2.11 Watch for deployments

The rabbitmq `ScaledObject` will be deployed as part of the deployment. Watch out for the deployments to see the changes in the scaling as the number of messages increases

``` bash
kubectl get deployment -w
kubectl get deploy -w
```

![List of all Kubernetes services](/images/initial-deploy-state.png)

Initially there is 1 instance of rabbitmq-consumer and 2 replicas of the rabbitmq-producer (Producer) deployed in the cluster.

### 2.12 Browse RabbitMQ Management UI

RabbitMQ Management UI is enabled by port forwarding.

In order to do this, open a bash shell and run the command.

Please keep the shell open to keep open the port forwarding.

``` bash
kubectl port-forward svc/rabbitmq 15672:15672
```

Open the web browser:
[rabbitmq](http://localhost:15672/)

Login to the management UI using credentials as `user` and `PASSWORD`.

Remember that these were set during the installation of RabbitMQ services using Helm. If you are using any other user, please update the username and password accordingly.

### 2.13 Generate load using `Visual Studio code Extension`

TBV

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

On the left-hand side of the screen you can see the pods auto scaled and on the right we see the deploymnets autoscaled progressively to 2, 4, 8, 16 and 30.

While the messages are being processed, we can also observe the RabbitMQ management UI.

![autoscaling consumers](/images/RabbitMQ-managementUI.PNG)

Our consumer processes 50 messages in a batch by prefetching them together. This can be verified by looking at the details of the consumers.

![Prefetch messages](/images/rabbitMQ-prefetch.PNG)

Once all the messages are processed, KEDA will scale down the pods and the deployments.

![autoscaled down consumers](/images/pods-and-deployments-scaled-down.png)

List Custom Resource Definition

``` bash
kubectl get crd
```

![autoscaled down consumers](/images/KEDA-CRD.PNG)

As part of the KEDA installation, ScaledObject and TriggerAuthentications are deployed on the Kubernetes cluster.

### 2.16 Delete all resources

``` PS
.\Powershell\deleteRG.ps1
```

## Resource Groups

This demo will create all the Azure Resource inside:

- rg-aks-genocs
- rg-agic-genocs
- MC_rg-aks-genocs_aks-genocs_westeurope
- DefaultResourceGroup-WEU

## 1. rg-aks-genocs

- aks-genocs - Kubernetes service
- genocscontainer - Container registry
- kv-genocsakst - Key vault

## 2. rg-agic-genocs

- agic-genocs - Application gateway
- agic-pip - Public IP address
- agic-vnet - Virtual network

## 3. MC_rg-aks-genocs_aks-genocs_westeurope

- 4c0f07f9-b962-478a-a875-be77a79462dc      Public IP address           West Europe
- aks-agentpool-33168902-nsg                Network security group      West Europe
- aks-agentpool-33168902-routetable         Route table                 West Europe
- aks-genocs-agentpool                      Managed Identity            West Europe
- aks-nodepool1-12518635-vmss               Virtual machine scale set   West Europe
- aks-vnet-33168902                         Virtual network             West Europe
- kubernetes                                Load balancer               West Europe
- omsagent-aks-genocs                       Managed Identity            West Europe
- pvc-49df2627-0ef7-4264-8441-f0e36b629bf2  Disk                        West Europe

## 4. DefaultResourceGroup-WEU

## Community

- Discord [@genocs](https://discord.com/invite/fWwArnkV)
- Facebook Page [@genocs](https://facebook.com/Genocs)
- Youtube Channel [@genocs](https://youtube.com/c/genocs)

## Contributors

Submit your PR and join the list!

<a href="https://github.com/Genocs/enterprise-containers/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Genocs/enterprise-containers" />
</a>

## License

This project is licensed with the [MIT license](LICENSE).

## Support :star:

Has this project helped you learn something New? or Helped you at work?
Here are a few ways by which you can support.

- Leave a star! :star:
- Recommend this awesome project to your colleagues. 🥇
- Do consider endorsing me on LinkedIn for ASP.NET Core - [Connect via LinkedIn](https://www.linkedin.com/in/giovanni-emanuele-nocco-b31a5169/) 🦸
- Or, If you want to support this project in the long run, [consider buying me a coffee](https://www.buymeacoffee.com/genocs)! ☕

<br>
<a href="https://www.buymeacoffee.com/genocs"><img width="250" alt="black-button" src="https://user-images.githubusercontent.com/31455818/138557309-27587d91-7b82-4cab-96bb-90f4f4e600f1.png" ></a>

## Acknowledgements

A lot of people inspired me and provided unevaluable amount of information:

Here some of them:

- [NileshGule](https://github.com/NileshGule/)
- [DevMentors](https://github.com/devmentors/)

## References

- [Hands-on-Kubernetes-on-Azure-Third-Edition](https://github.com/PacktPublishing/Hands-on-Kubernetes-on-Azure-Third-Edition)
