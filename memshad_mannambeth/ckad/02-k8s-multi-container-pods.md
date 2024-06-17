# Kubernetes Multi-Container Pods

- Patterns:
  - Ambassador
  - Adapter
  - Sidecar
- In Microservices Architecture, sometimes you may need a Log Agent service paired together with the microservice. They should be deployed separately but work together. Thus, we have multi-container pods that share the same lifecycle, i.e., created and destroyed together. They share the same network space (localhost) and have access to the same storage volumes.

```yaml
## pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp
  labels:
    name: simple-webapp
spec:
  # this is an array because we allow multiple containers in a Pod
  containers:
    - name: simple-webapp
      image: simple-webapp
      ports:
        - containerPort: 8080
    - name: log-agent
      image: log-agent
```

## Design Patterns

1. Sidecar

- The Sidecar pattern involves deploying additional containers alongside the main application container within the same Pod. These sidecar containers enhance or extend the functionality of the main application.
- E.g., Deploying a log-agent alongside a web server to collect logs and forward the logs to a central log server.

1. Adapter

- The Adapter pattern helps standardize interactions between components with incompatible interfaces. In logging, different log formats can be standardized before being sent to a central logging server.
- If each logging agent has a different format of logs, it will be difficult to handle it in the central logging server. E.g.,
  - `12-JULY-2018 16:05:49 "GET /index1.html" 200`
  - `12/JUL/2018 16:05:49 -0800 "GET /index2.html" 200`
  - `GET 1531411549 "/index3.html" 200`
- With Adaptor pattern, we can create a standardized log format and insert into central logging server.

1. Ambassador

- The Ambassador pattern involves a proxy container that acts as an intermediary between the application container and external services. This pattern is particularly useful for managing communication, such as adding extra security or handling connection pooling.
- E.g., Web server application needs to communicate with a database. The database configuration differs between development and production environments. The ambassador container will handle the communication to the correct database based on the environment.

```sh
## viewing logs in elastic-stack namespace log file within the container
kubectl -n elastic-stack exec -it app -- cat /log/app.log
```

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: app
  namespace: elastic-stack
  labels:
    name: app
spec:
  containers:
    - name: app
      image: kodekloud/event-simulator
      volumeMounts:
        - mountPath: /log
          name: log-volume

    - name: sidecar
      image: kodekloud/filebeat-configured
      volumeMounts:
        - mountPath: /var/log/event-simulator/
          name: log-volume

  volumes:
    - name: log-volume
      hostPath:
        # directory location on host
        path: /var/log/webapp
        # this field is optional
        type: DirectoryOrCreate
```

## Init Containers

- In a multi-container Pod, each container is expected to run a process that stays alive as long as the POD's lifecycle.

  - For example, in the multi-container Pod that has a web application and logging agent, both the containers are executed to stay alive at all times.
  - The process running in the log agent container is expected to stay alive as long as the web application is running.
  - If any one of them fails, the POD restarts.

- But at times, you may want to run a process that runs to completion in a container.

  - For example, a process that pulls a code or binary from a repository that will be used by the main web application.
  - i.e., A task that will run only 1 time when the Pod is first created. Or a process that waits for an external service or database to be up before the actual application starts.
  - That's where `initContainers` come in.

- An `initContainer` is a special type of container in Kubernetes that **runs and completes before any of the main application containers in a Pod start**, typically used for setup tasks such as initializing data or setting up configurations.
- An `initContainer` is configured in a Pod like all other containers, except that it is specified inside a `initContainers` section, like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: busybox:1.28
      command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
    - name: init-myservice
      image: busybox
      command: ['sh', '-c', 'git clone <some_repository>;']
```

- When the Pod is first created, the `initContainer` is ran, and the process in the `initContainer` must run to a completion before the real container hosting the application starts.
- You can configure multiple such `initContainers` as well, like how we did for multi-pod containers. In that case, each `initContainer` is run **one at a time in sequential order**.
- If any of the initContainers fail to complete, Kubernetes restarts the Pod repeatedly until the initContainer succeeds.
