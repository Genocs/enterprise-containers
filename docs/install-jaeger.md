# Installing the Jaeger Operator

There are different ways of installing the Jaeger Operator on Kubernetes:

- using Helm
- using Deployment files

Before you start, pay attention to the Prerequisite section.

Since version 1.31 the **Jaeger Operator** uses webhooks to validate Jaeger custom resources (CRs). This requires an installed version of the `cert-manager`.

## Installing Cert-Manager

The installation of `cert-manager` is very simple as you can see from the Getting Started page.

To install all `cert-manager` components, just run:

``` sh
# Please the latest version
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.0/cert-manager.yaml
```

By default, cert-manager will be installed into the cert-manager namespace.

You can verify the installation with:

``` sh
kubectl get pods -n cert-manager
```

You should see the `cert-manager`, `cert-manager-cainjector`, and `cert-manager-webhook` pods in a Running state. The webhook might take a little longer to successfully provision than the others.

## Installing Jaeger Operator using Helm

Jump over to Artifact Hub and search for jaeger-operator. Add the chart to the Helm repository.

helm repo add [jaegertracing](https://jaegertracing.github.io/helm-charts)

To install the chart with the release name `my-release` in `observability` namespace

``` sh
kubectl create ns observability
helm install my-release jaegertracing/jaeger-operator -n observability
```

You can also install a specific version of the helm chart:

``` sh
helm install my-jaeger-operator jaegertracing/jaeger-operator --version 2.25.0 -n observability
```

Verify that it’s installed on Kubernetes:

``` sh
helm list -A
```

## Installing Jaeger Operator using deployment files

The Jaeger Tracing provides instructions on how to install the operator on Kubernetes using deployment files. Again, create a new namespace:

``` sh
kubectl create ns observability
```

To install the Customer Resource Definition:

``` sh
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.36.0/jaeger-operator.yaml -n observability
```

At this point, there should be a jaeger-operator deployment available.

``` sh
kubectl get deployment jaeger-operator -n observability
```

<pre>
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
jaeger-operator   1/1     1            1           29s
</pre>

The operator is now ready to create Jaeger instances.

## Deploying the Jaeger All-One image

The operator (that we just installed) doesn’t do anything itself, it just means that we can create jaeger resources/instances that we want the Jaeger Operator to manage.

The simplest possible way to create a Jaeger instance is by creating a YAML file like the following.

``` sh
vim simplest.yml
```

``` yml
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simplest
```

The YAML file can then be used with kubectl:

``` sh
kubectl apply -f simplest.yaml
```

This will install the default All-In-One strategy, which deploys the all-in-one image, that includes all the following components in a single pod using in-memory storage by default.

- agent
- collector
- query
- ingester
- Jaeger UI
- Source

After a little while, a new in-memory all-in-one instance of Jaeger will be available, suitable for quick demos and development purposes.

To check the instances that were created, list the Jaeger objects:

``` sh
kubectl get jaegers
```

To get the pod name, query for the pods belonging to the simplest Jaeger instance:

``` sh
kubectl get pods -l app.kubernetes.io/instance=simplest
```

Query the logs from the pod:

``` sh
kubectl logs -l app.kubernetes.io/instance=simplest
```

Verify Jaeger instance created:

``` sh
kubectl get services -n default | grep jaeger
```

The output should looks like this (some of the output is omitted to fit), but you can see the names and ports in the output.

<pre>
NAME               
kubernetes          443/TCP
simplest-agent      5775/UDP,5778/TCP,6831/UDP,6832/UDP
simplest-collector  9411/TCP,14250/TCP,14267/TCP,14268/TCP,4317/TCP,4318/TCP
simplest-collector-headless 9411/TCP,14250/TCP,14267/TCP,14268/TCP,4317/TCP,4318/TCP
simplest-query      16686/TCP,16685/TCP
</pre>

Pay extra attention to simplest-collector on port `14268/TCP`

This is the service that will be used later on in the demo application to send the Jaeger traces containing the spans.
