## Kubernetes

### Useful Links

- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

### Pods

```
# Create a deployment named "nginx" using the official Nginx container image
kubectl run nginx --image=nginx

# Retrieves a list of running pods within the current Kubernetes cluster
kubectl get pods

# Displays detailed information about the pods, including the pod's IP address, associated ports, and the nodes where they are running on
kubectl get pods -o wide

# Detailed description of the specific pod named "nginx", offering insights into its configuration, events, and current status within the Kubernetes cluster
kubectl describe pod nginx
```