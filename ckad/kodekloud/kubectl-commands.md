# Miscellaneous

```sh
kubectl run hello-minikube      # create a Pod named "hello-minikube" (uses a default image if configured)
kubectl cluster-info            # show cluster API endpoint(s) and core service URLs
kubectl get nodes               # list the cluster nodes
```

# Pods

```sh
kubectl run nginx --image=nginx         # create a Pod named "nginx" using the nginx image
kubectl get pods                        # list Pods in the current namespace
kubectl create -f pod-definition.yaml   # create a Pod from a YAML manifest file
kubectl describe pod <pod_name>         # show detailed information about a Pod (status, labels, image, events, containers)
kubectl delete pod <pod_name>           # delete the specified Pod
kubectl run redis --image=redis --dry-run=client -o yaml                # generate Pod YAML without creating it
kubectl run redis --image=redis --dry-run=client -o yaml > redis.yaml   # save generated Pod YAML to a file

kubectl edit pod <pod_name>             # edit a Pod’s configuration in the editor
    # only these are editable
    # spec.containers[*].image
    # spec.initContainers[*].image
    # spec.activeDeadlineSeconds
    # spec.tolerations
    # spec.terminationGracePeriodSeconds
```
