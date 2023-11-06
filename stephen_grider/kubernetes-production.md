## Kubernetes Production

<img src="./diagrams/docker-architecture.png" />
<img src="./diagrams/k8s-architecture.png" />

- On local, we will set up our application on one single Node.
  - "ChatGPT": You generally don't need to use Docker Compose in a production Kubernetes environment. Kubernetes itself provides a way to define and manage containerized applications in a more scalable, resilient, and production-ready manner. However, Docker Compose can still be valuable for local development and testing.
- On Cloud (AWS or Google Cloud), we have the option to set up the application on multiple Nodes.

### Path to Production

1. Create config files for each service and deployment
2. Test locally on minikube
3. Create a GitHub/Travis flow to build images and deploy
4. Deploy app to a cloud provider

```
# commands used to run the development compose file when testing
docker-compose -f docker-compose-dev.yml up
docker-compose -f docker-compose-dev.yml up --build
docker-compose -f docker-compose-dev.yml down
```

### `NodePort` vs `ClusterIP` Services

<img src="./diagrams/k8s-clusterIP.png" />

- ClusterIP
  - ClusterIP Services attached to Deployment can allow other Deployment object types in the Kubernetes Cluster to connect to.
  - If connected to Cluster IP service, we are exposing the Pods in Deployment to other services inside the Kubernetes Cluster.
  - Need the ClusterIP Service to provide objects (Pods) to everything inside the cluster.
  - From outside Kubernetes Cluster (outside world), we cannot access the Pod even if the Deployment object has a ClusterIP Service.
- Use a `selector` so our service knows what set of Pods it is providing access to.
- Traffic will enter through the Ingress Service instead.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: client-cluster-ip-service
spec:
  type: ClusterIP
  selector:
    component: web # to connect to Pod
  ports:
    - port: 3000
      targetPort: 3000
```

- `port: 3000`: This is specifying a port on the service. It means that the service will listen on port 3000. Incoming traffic to this port on the service will be directed to the corresponding targetPort on the pods that the service is routing traffic to.
- `targetPort: 3000`: This specifies the target port on the Pods. When the service receives traffic on the port defined by `port`, it forwards that traffic to the Pods on the port defined by `targetPort`. In this case, both `port` and `targetPort` are set to 3000, so incoming traffic on port 3000 will be routed to port 3000 on the Pods.

```
# command to run a group of config files (specified directory instead)
➜  project-multi-container-k8s git:(main) kubectl apply -f ./k8s
service/client-cluster-ip-service created
deployment.apps/client-deployment created
```

### Express API Deployment Config

<img src="./diagrams/k8s-api-deployment.png" />

- Need to provide environment variables to out Deployment Config for API.

### Combining Config into Single Files

- Can create a single file to component the `ClusterIP` Service and `Deployment` object.
- Use `---` 3 dashes to separate

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: server-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      component: server
  template:
    metadata:
      labels:
        component: server
    spec:
      containers: # 1 container in each Pod
        - name: server
          image: stephengrider/multi-server
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: server-cluster-ip-service
spec:
  type: ClusterIP
  selector:
    component: server # specified in Pod as this selector
  ports:
    - port: 5000
      targetPort: 5000

```