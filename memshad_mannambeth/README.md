## Kubernetes

### Useful Links

- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

### Pods

```
# Get help
kubectl run --help

# Create a deployment named "nginx" using the official Nginx container image
kubectl run nginx --image=nginx

# Retrieves a list of running pods within the current Kubernetes cluster
kubectl get pods

# Displays detailed information about the pods, including the pod's IP address, associated ports, and the nodes where they are running on
kubectl get pods -o wide

# Detailed description of the specific pod named "nginx", offering insights into its configuration, events, and current status within the Kubernetes cluster
kubectl describe pod nginx

# Delete pod
kubectl delete pod nginx
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

```
# Directing Pod creation to a YAML file
kubectl run nginx --image=nginx --dry-run=client -o yaml

# Piping to a .yaml file
kubectl run nginx --image=nginx --dry-run=client -o yaml > nginx.yaml

cat nginx.yaml

# create new pod for nginx
kubectl create -f nginx.yaml

# Edit the image or yaml file
vi redis.yaml

# apply the changes
kubectl apply -f redis.yaml
```

### Replica Sets

- If the stated number of `replicas: 3` for the `ReplicaSet` and 3 Pods have already been created, then creating a new Pod will result in it being terminated and deleted.
- To scale up the application, edit the ReplicaSet
  - `kubectl edit replicaset <replicaset_name>` opens up in Vim. Temporary file that is created by Kubernetes in memory to allow us to edit the configuration, we will see many additional fields here. Editing this file only updates the configuration in the Kubernetes cluster, it does not update the YAML file.
  - `kubectl scale replicaset <replicaset_name> --replicas=6` another way to scale up the pods without using Vim

```
# Create ReplicaSet
kubectl create -f replicaset.yaml

kubectl get replicaset
kubectl get rs

kubectl get pods

kubectl delete pod <pod_name>

# ReplicaSet will create a new pod after you deleted 1
kubectl get pods

kubectl describe replicaset <replicaset_name>

kubectl get replicasets -o wide

# shows the kind and version
kubectl explain replicaset
```

```
# To edit image used in ReplicaSet
kubectl edit replicaset <replicaset_name>
kubectl edit rs <replicaset_name>
```

### Deployment

```
# Shows all the objects created in the Kubernetes Cluster
kubectl get all

kubectl get deployments

kubectl get pods

kubectl describe deployment <deployment_name>
```

```
kubectl create deployment --help

# Create a deployment named my-dep that runs the nginx image with 3 replicas
kubectl create deployment my-dep --image=nginx --replicas=3
```