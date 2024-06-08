## Kubernetes Namespace

- **Namespaces** are a way to divide cluster resources between multiple users (via resource limitation).
- Namespaces are intended for use in environments with many users spread across multiple teams, or projects. They provide a scope for names.
- `default`: default namespace for objects with no other namespace.
- `kube-system`: this namespace is used for objects created by the Kubernetes system.
- `kube-public`: this namespace is created automatically and is readable by all users (including those not authenticated). It is mostly reserved for cluster usage.
- **Creating Namespaces for Dev and Prod**: To isolate resources for development and production environments, you create separate namespaces for each. This ensures that resources like pods, services and deployments in the Dev namespace do not interfere with those in the Prod namespace.
- **Deploying Resources in namespaces**: When deploying resources in Kubernetes, you can specify which namespace they belong to.
- **Limiting Resources within Namespaces**: To prevent one namespace from using all the resources in the cluster, you can set limits on resources such as CPU and memory usage using a `ResourceQuota` object. This ensures fair distribution and prevents resource contention.
- `kubectl get namespaces` or `kubectl get ns`: get all namespaces

```sh
## list pods in default namespace
kubectl get pods

## list pods in `kube-system` namespace
kubectl get pods --namespace=kube-system
kubectl get pods -n=kube-system
```

```sh
## create pod in default namespace
kubectl create -f pod-definition.yml

## create pod in dev namespace
kubectl create -f pod-definition.yml --namespace=dev

## create pod in dev namespace with image and container name (imperative)
kubectl run redis --image=redis -n=dev

## create pod in dev namespace (specify in YAML file)
metadata:
    name: myapp-pod
    namespace: dev

kubectl create -f pod-definition.yml
```

- Creating Namespace
  - `kubectl create -f namespace-dev.yml`
  - `kubectl create namespace dev`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

- Switch namespace permanently.

  - Instead of `kubectl get pods --namespace=dev` to access dev namespace, you can use `kubectl get pods` to access dev namespace. Need to run the following command:
    - `kubectl config set-context $(kubectl config current-context) --namespace=dev`
  - However, you need to specify the namespace to access environments like `default` and `prod`
    - `kubectl get pods --namespace=default` and `kubectl get pods --namespace=prod`

- View pods in all namespaces

  - `kubectl get pods --all-namespaces`
  - `kubectl get pods -A`
  - `kubectl get pods --all-namespace | grep dev`: get dev namespace directly

- To limit resource in the namespace, create a `ResourceQuota` object.
  - `kubectl create -f compute-quota.yml`

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: '10'
    requests.cpi: '4'
    requests.memory: 5Gi
    limits.cpu: '10'
    limits.memory: 10Gi
```

- If within the same namespace, an application can access another Service directly

  - `kubectl get services -n=dev`
  - `kubectl get svc -v=dev`

- Access between different namespaces is possible. E.g., from `dev` namespace to `prod` namespace
  - Host name will be `<prod-service>.prod.svc.cluster.local`
