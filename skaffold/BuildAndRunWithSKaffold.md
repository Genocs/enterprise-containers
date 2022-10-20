# Building the project with Skaffold and Kaniko

## Prerequisites

- A Kubernetes cluster such as microk8s
- Download [skaffold](https://github.com/GoogleContainerTools/skaffold/releases) cli
- helm
- kubectl

### Install the Keda controller

Use helm to install the Keda Controller

``` bash
helm repo add kedacore https://kedacore.azureedge.net/helm

helm repo update

helm install kedacore/keda-edge `
    --devel `
    --set logLevel=debug `
    --namespace keda `
    --name keda
```

### Create secret for Kaniko use

Kaniko will pull and push from a Docker registry. If you already have a docker config, you can easily create the kaniko secret.

Example:

``` bash
kubectl create secret generic regcred  `
    --from-file=/home/your user/.docker/config.json
```

### Build and deploy the application

Examine the `skaffold.yaml` at the root of the project.
Change the image name according to your registry.

You dont need to specify the tag, skaffold will create a tag base on git hash.

```
apiVersion: skaffold/v1beta15
kind: Config
profiles:
- name: rabbitproducer
  build:
    artifacts:
    - image: genocs/rabbitproducer:1.3
      context: src
      kaniko:
        dockerfile: Genocs.KubernetesCourse.WebApi.dockerfile
        buildContext:
          localDir: {}
    cluster:
      dockerConfig:
        secretName: regcred
      namespace: default
    insecureRegistries: #Use this for local registry.  such as microk8s registry.
    - 10.152.183.39:5000
  deploy:
    kubectl:
      manifests:
        - k8s/ApplicationProducer/*.yml

- name: rabbitconsumer
  build:
    artifacts:
    - image: genocs/rabbitconsumer
      context: src
      kaniko:
        dockerfile: Genocs.KubernetesCourse.Worker.dockerfile
        buildContext:
          localDir: {}
    cluster:
      dockerConfig:
        secretName: regcred
      namespace: default
    insecureRegistries:
    - 10.152.183.39:5000
  deploy:
    kubectl:
      manifests:
        - k8s/ApplicationConsumer/*.yml
```

After modifying the `skaffold.yaml`, execute the following command.


``` bash
# Build and run the producer
skaffold run -p rabbitproducer

# Build and run the consumer
skaffold run -p rabbitconsumer
```

For more information on [Skaffold](https://skaffold.dev/docs/) and [Kaniko](https://github.com/GoogleContainerTools/kaniko)
