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

### YAML

- Equal number of spaces

```yaml
# Key Value Pair
Fruit: Apple
Vegetable: Carrot

# Array / Lists
Fruits:
  - Orange
  - Apple

Vegetables:
  - Carrot
  - Tomato

# Dictionary / Map
Banana:
  Calories: 105
  Fat: 0.4g
Grapes:
  Calories: 62
  Fat: 0.3g

# List of Dictionaries
- Banana:
    Calories: 105
    Fat: 0.4g
- Grape:
    Calories: 62
    Fat: 0.3g
```

### Pods with YAML

- Install VS Code Extension "YAML" by Red Hat

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
    tier: frontend
spec:
  containers:
    - name: nginx
      image: nginx
```

- Run `kubectl apply -f pod.yaml` to create the pod
- `kubectl describe pod nginx`

