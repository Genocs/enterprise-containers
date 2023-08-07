# Setup Monitoring and Observability

Setup for Improve Monitoring and Observability for Kubernetes with OSS tools

## Initialize AKS cluster with all KEDA related resources

Run the [deployAll](\Powershell\deployAll.ps1) Powershell script which setup everything from AKS cluster, RabbitMQ, KEDA, Application services etc.

``` PS
.\deployAll.ps1
```

## Deploy EFK

Run the deployEFK Powershell script which will deploy Elasticsearch, FluentD and Kibana

``` PS
.\deployEFK.ps1

```

## Access Kibana UI 

``` bash
kubectl port-forward --namespace default svc/kibana 5601:5601
```

## Access RabbitMQ UI

``` bash
kubectl port-forward --namespace default svc/rabbitmq 15672:15672
```

Access the RabbitMQ UI with credential `guest` & `guest`
http://localhost:15672

## Get IP of Producer service

Retrieve the Load Balancer IP of the `rabbitmq-producer-service`

``` bash
kubectl get svc
kubectl get svc rabbitmq-producer-service
```

Got the IP as `20.195.103.121`

## Produce messages on the RabbitMQ

Use Postman to generate 5000 messages

``` bash
http://20.195.103.121/api/TechTalks/Generate?numberOfMessages=5000
```

Other options can also be used to produce messages like hitting the above url directly from browser or using command line utilities like curl or wget 

## Monitoring using Prometheus

Clone the repo for Spring Boot application
[spring-boot-conference-app](https://github.com/NileshGule/spring-boot-conference-app)

Switch to the `mssql-server` branch

## Install Prometheus

Run the Powershell script from powershell folder

``` PS
.\install-prometheus.ps1
```

Check Prometheus relates resources are installed correctly

``` bash
kubectl --namespace monitoring get pods -l "release=prometheus"
```

## Get Custom Resource Definitions (CRD) for Prometheus

``` bash
kubectl get crd
```

## Setup Spring Boot app

Apply manifest files from the following folder `k8s` folder

## Setup Service & Pod monitors
For Spring Boot conference app, apply the manifest files from the `k8s/prometheus-config` folder using the command

``` bash
kubectl apply -R -f .
```

For the application, apply the manifest files from the `k8s/Prometheus` folder using the same command as above

## Port forward Prometheus, Grafana & AlertManager services

``` bash
kubectl port-forward --namespace monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
kubectl port-forward --namespace monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093
kubectl port-forward --namespace monitoring svc/prometheus-grafana 80:80
```

Grafana login credentials `admin`, `prom-operator`

## Import Grafana dashboards

- RabbitMQ : https://grafana.com/grafana/dashboards/10991
- Springboot : https://grafana.com/grafana/dashboards/11955
- .Net core : https://grafana.com/grafana/dashboards/13399
- .Net Core Services : https://grafana.com/grafana/dashboards/12526
- .Net Core Controller Summary : https://grafana.com/grafana/dashboards/10915

## Access Prometheus Metrics for Spring Boot App

Find and Replace the load balancer IP for the conference-demo service

``` bash
kubectl get svc
```

In my case the load balancer IP was `40.119.248.189`

http://40.119.248.189:8080/actuator/

http://40.119.248.189:8080/actuator/prometheus

## Access Prometheus Metrics for .Net Core App

http://20.198.210.175/metrics
## Generate load on conference API

``` bash
for i in `seq 1 3000`; do curl http://40.119.248.189:8080/api/v1/speakers/; done
for i in `seq 1 1500`; do curl http://20.44.232.28:8080/api/v1/sessions/; done
for i in `seq 1 20`; do curl http://20.44.232.28:8080/api/v1/crash/boom; done
20.44.232.28

```

``` PS
for ($i =0; $i -lt 10; $i++)
{
    Invoke-WebRequest http://40.119.248.189:8080/api/v1/crash/boom
}
```

---

## All the links used during the demo

### Github repositories
- [Springboot conference app demo code](https://github.com/NileshGule/spring-boot-conference-app/tree/mssql-server)

### Slidedecks
- [Slideshare](https:/www.slideshare.net/nileshgule/)
- [Speakerdeck](https://www.speakerdeck.com/NileshGule/)

### Other links
- [Azure Singapore sessions](https://bit.ly/AzureSingaporeSessions)

- [CNCF trail](https://github.com/cncf/trailmap)
- [Elastic stack](https://www.elastic.co/elastic-stack/)
- [Kibana](https://www.elastic.co/kibana/)
- [Fluentbit](https://fluentbit.io/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Kube prometheus stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Hussem Dellai Prometheus & Grafana series](https://www.youtube.com/playlist?list=PLpbcUe4chE7-HuslXKj1MB10ncorfzEGa)
- [Sentry docs](https://docs.sentry.io/)
- [Sentry Architecture](https://develop.sentry.dev/architecture/)