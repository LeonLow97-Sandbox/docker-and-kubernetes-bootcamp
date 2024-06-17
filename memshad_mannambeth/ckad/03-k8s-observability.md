# Kubernetes Observability

- Readiness Probes
- Liveness Probes
- Container Logging
- Monitor and Debug Applications

## Pod Status and Pod Conditions

- Pod Status (Pending, ContainerCreating, Running)

  - Tells us where the Pod is in its lifecycle.
  - When the Pod is first created, it is in the "Pending" state. This is when the kube-scheduler is figuring out which Node to place the Pod in. It also indicates that the Pod has been accepted by the Kubernetes system, but one oe more of its containers are not yet created, maybe due to delays in pulling container images.
  - If the kube-scheduler cannot find a Node to place the Pod, it will remain in "Pending" state.
  - Once the container is scheduled, it goes into "ContainerCreating" status where the images required for the application are pulled and the container starts.
  - Once all the containers in the Pod starts, it goes into "Running" state.

- Pod Condition

  - `PodScheduled`: Pod is scheduled on Node.
  - `Initialized`: Indicates that all initialization containers (if any) in the Pod have been successfully started and completed.
  - `ContainersReady`: Similar to `Ready`, but specifically indicates that all containers in the Pod are ready.
  - `Ready`: All containers in the Pod are ready to accept traffic. This is an important condition for services to route traffic to the Pod.

- Pod Condition can be found under "conditions" with `kubectl describe pod`
- When a Pod is marked as Ready, it indicates that it is prepared to receive traffic from services.
- However, it's important to note that the readiness status might not immediately reflect the application's ability to handle requests due to initialization or startup delays.
- Therefore, ensuring the readiness status accurately reflects the application's live state is crucial to prevent user requests from reaching Pods that are not yet fully operational.
- Examples for startup delays: image pulling, container initialization, application start up time (large codebase), ...

## Readiness Probes

- Readiness Probe: It determines whether the application inside the container is ready to accept traffic or requests.
- For API, Setup HTTP Test like `/api/ready`
- For database, set up TCP Test - 3306 (MySQL)

```yaml
## pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
	name: simple-webapp
  labels:
    name: simple-webapp
spec:
  containers:
  - name: simple-webapp
    image: simple-webapp
    ports:
      - containerPort: 8080
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
```

- When the container is created, k8s performs a test to see if API is ready with `readinessProbe`.
- Traffic will not be forwarded to this Pod until it is ready and passes the readinessProbe.

```yaml
## HTTP Test
readinessProbe:
  httpGet:
    path: /api/ready
    port: 8080
  initialDelaySeconds: 10 ## allow 10 seconds for application to warm up
  periodSeconds: 5 ## how frequent probe initiates
  failureThreshold: 8 ## by default, if application is not ready after 3 probes, probe stops. Edit this number to continue probing

## TCP Test - 3306 (MySQL)
readinessProbe:
  tcpSocket:
    port: 3306

## Exec Command
readinessProbe:
  exec:
    command:
      - cat
      - /app/is_ready
```

## Liveness Probes

- Liveness probes: These probes help you evaluate whether an application that is running in a container is in a healthy state. 
If not, Kubernetes kills the container and attempts to redeploy it.
- For API, Setup HTTP Test like `/api/healthy`
- For database, set up TCP Test - 3306 (MySQL)

```yaml
## HTTP Test
livenessProbe:
  httpGet:
    path: /api/ready
    port: 808
  initialDelaySeconds: 10 ## allow 10 seconds for application to warm up
  periodSeconds: 5 ## how frequent probe initiates
  failureThreshold: 8 ## by default, if application is not ready after 3 probes, probe stops. Edit this number to continue probing

## TCP Test - 3306 (MySQL)
livenessProbe:
  tcpSocket:
    port: 3306

## Exec Command
livenessProbe:
  exec:
    command:
      - cat
      - /app/is_ready
```
