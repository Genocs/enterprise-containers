# Install NGINX Ingress controller on kubernetes

Check complete example on github

[Example](https://github.com/nginxinc/kubernetes-ingress/tree/v2.2.2/examples/complete-example)

**Note:**

If replicaset is set to 1 the loadbalancer is missing 

``` bash
helm install nginx-ingress nginx-stable/nginx-ingress  `
    --namespace default `
    --set controller.replicaCount=2 `
    --skip-crds
```