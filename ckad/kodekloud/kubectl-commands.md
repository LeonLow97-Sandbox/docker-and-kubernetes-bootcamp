# Miscellaneous

```sh
kubectl run hello-minikube      # create a Pod named "hello-minikube" (uses a default image if configured)
kubectl cluster-info            # show cluster API endpoint(s) and core service URLs
kubectl get nodes               # list the cluster nodes
```

# Pods

```sh
kubectl run nginx --image=nginx # create a Pod named "nginx" using the "nginx" container image
kubectl get pods                # list Pods in the current namespace
```
