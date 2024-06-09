## Kubernetes

### Useful Links

- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

### Pods

```sh
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

## Edit pod (imperative)
kubectl edit pod <pod_name>
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

## Creating pod imperative command
kubectl run nginx --image=nginx
```

### Replica Sets

- If the stated number of `replicas: 3` for the `ReplicaSet` and 3 Pods have already been created, then creating a new Pod will result in it being terminated and deleted.
- To scale up the application, edit the ReplicaSet
  - `kubectl edit replicaset <replicaset_name>` opens up in Vim. Temporary file that is created by Kubernetes in memory to allow us to edit the configuration, we will see many additional fields here. Editing this file only updates the configuration in the Kubernetes cluster, it does not update the YAML file.
  - `kubectl scale replicaset <replicaset_name> --replicas=6` another way to scale up the pods without using Vim

```sh
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

```sh
# To edit image used in ReplicaSet
kubectl edit replicaset <replicaset_name>
kubectl edit rs <replicaset_name>
```

```sh
## Update to 6 Replicas from 3 (multiple ways to do it)
kubectl replace -f replicaset-definition.yml
kubectl scale --replicas=6 -f replicaset-definition.yml
kubectl scale --replicas=6 replicaset myapp-replicaset
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

### Deployment - Update and Rollback

```ruby
# create a kubernetes deployment using the definition in 'deployment-definition.yml'
kubectl create -f deployment-definition.yml
kubectl create -f deployment.yaml --record

kubectl get deployments

# update an existing kubernetes deployment using the file
kubectl apply -f deployment.definition.yml

# set the image of the pods in the 'myapp-deployment' deployment to 'nginx:1.9.1'
kubectl set image deployment/myapp-deplotment <container_name>=<image_name>

# check the status of the rollout for the 'myapp-deployment' deployment
kubectl rollout status deployment/myapp-deployment

# view the rollout history of changes for the 'myapp-deployment' deployment
kubectl rollout history deployment/myapp-deployment

# undo the latest rollout of the 'myapp-deployment' deployment, reverting to the previous state
kubectl rollout undo deployment/myapp-deployment

# to edit deployment and change strategy type e.g., from RollingUpdate to Recreate
kubectl edit deployment <deployment_name>
```

### Service

- `minikube service <service_name> --url` prints out the url where the service is available to use on the browser

### ClusterIP

- Default service launched by Kubernetes, it's type is ClusterIP

```
controlplane ~ ➜  kubectl get service
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   13m
```

```
# can find out the endpoints and ports the service is directing traffic to
kubectl describe services kubernetes
```

## Microservices Architecture

```
docker run -d --name=redis redis
docker run -d --name=db postgres:9.4
docker run -d --name=vote -p 5000:80 --link redis:redis voting-app
docker run -d --name=result -p 5001:80 --link db:db result-app
docker run -d --name=worker --link db:db --link redis:redis worker
```

- Microservices on Kubernetes

  1. Deploy PODs
  2. Create Services (ClusterIP)

  - redis
  - postgres

  3. Create Services (NodePort)

  - voting-app
  - result-app

- Use Deployment to scale our application with Pods
- Use Deployment instead of ReplicaSet because creating a Deployment will result in a ReplicaSet being created. Deployment can perform rolling updates or rollbacks, and record changes.
- `kubectl scale deployment voting-app-deploy --replicas=3` scaling up application to 3 replicas
- [Link to Application Kubernetes Project](https://github.com/kodekloudhub/example-voting-app-kubernetes)

## Kubernetes on the Cloud

- Self Hosted / Turnkey Solutions
  - You provision CMs
  - You configure VMs
  - You use scripts to deploy cluster
  - You maintain VMs yourself
  - E.g., Kubernetes on AWS using kope or KubeOne
- Hosted Solutions (Managed Solutions)
  - Kubernetes-As-A-Service
  - Provider provisions VMs
  - Provider installs Kubernetes
  - Provider maintains VMs
  - E.g., Google Kubernetes Engine (GKE), Azure Kubernetes Service (AKS) and Amazon Elastic Kubernetes Service (EKS)
    - [AWS EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html)

## Setup Multi Node Cluster using Kubeadm

- Oracle VirtualBox: https://www.virtualbox.org/
- Vagrant: https://www.vagrantup.com/
- Link to download VM images: http://osboxes.org/
- Link to kubeadm installation instructions: https://kubernetes.io/docs/setup/independent/install-kubeadm/
- The link to Vagrant file:
  https://github.com/kodekloudhub/certified-kubernetes-administrator-course
- If you are new to VirtualBox or Vagrant, please follow this pre-requisites course to learn about it: https://www.youtube.com/watch?v=Wvf0mBNGjXY

---

- Use kubeadm to set up a multi-node Kubernetes cluster locally
- Use minikube to set up a single node Kubernetes cluster locally

---
