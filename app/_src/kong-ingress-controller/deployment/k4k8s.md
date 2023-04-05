---
title: Kong Ingress Controller
---

{{site.kic_product_name}} is an Ingress Controller based on the
Open-Source {{site.base_gateway}}. It consists of two components:

- **Kong**: the Open-Source Gateway
- **Controller**: a daemon process that integrates with the
  Kubernetes platform and configures Kong.

## Installers

{{site.kic_product_name}} can be installed using an installer of
your choice.

Once you've installed {{site.kic_product_name}},
jump to the [next section](#using-kong-for-kubernetes)
on using it.

### YAML manifests

Please pick one of the following guides depending on your platform:

- [Minikube](/kong-ingress-controller/{{page.kong_version}}/deployment/minikube/)
- [Google Kubernetes Engine(GKE) by Google](/kong-ingress-controller/{{page.kong_version}}/deployment/gke/)
- [Elastic Kubernetes Service(EKS) by Amazon](/kong-ingress-controller/{{page.kong_version}}/deployment/eks/)
- [Azure Kubernetes Service(AKS) by Microsoft](/kong-ingress-controller/{{page.kong_version}}/deployment/aks/)

### Kustomize

<div class="alert alert-warning">
  Kustomize manifests are provided for illustration purposes only and are not officially supported by Kong.
  There is no guarantee of backwards compatibility or upgrade capabilities for our Kustomize manifests.
  For a production setup with Kong support, use the <a href="https://github.com/kong/charts">Helm Chart</a>.
</div>

Use Kustomize to install {{site.kic_product_name}}:

```
kustomize build github.com/kong/kubernetes-ingress-controller/config/base
```

You can use the above URL as a base kustomization and build on top of it
to make it suite better for your cluster and use-case.

Once installed, set an environment variable, $PROXY_IP with the External IP address of
the `kong-proxy` service in `kong` namespace:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

### Helm

You can use Helm to install Kong via the official Helm chart:

```
$ helm repo add kong https://charts.konghq.com
$ helm repo update


# Helm 3
$ helm install kong/kong --generate-name --set ingressController.installCRDs=false -n kong --create-namespace
```

Once installed, set an environment variable, $PROXY_IP with the External IP address of
the `demo-kong-proxy` service in `kong` namespace:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong demo-kong-proxy)
```

{:.note}
> **Note:** Alternatively, you can also specify `ingress[0].hostname` depending on your environment.

## Using {{site.kic_product_name}}

Once you've installed {{site.kic_product_name}}, please follow our
[getting started](/kong-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn more.