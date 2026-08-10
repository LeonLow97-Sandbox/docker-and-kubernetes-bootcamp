1. `alias k=kubectl`
2. `alias kns="kubectl config set-context --current --namespace"`
3. `export do="--dry-run=client -o yaml"`
4. `k create ns canary-space`
5. `kns canary-space`
6. `k create deploy app-stable --replicas=3 --image=nginx:1.24 --port=80 $do > stable.yaml`
7. `vim stable.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: app-stable
  name: app-stable
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      version: stable
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: my-app
        version: stable
    spec:
      containers:
        - image: nginx:1.24
          name: nginx
          ports:
            - containerPort: 80
          resources: {}
status: {}
```

8. `k create deploy app-canary --replicas=1 --image=nginx:1.25 --port=80 $do > canary.yaml`
9. `vim canary.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: app-canary
  name: app-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
      version: canary
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: my-app
        version: canary
    spec:
      containers:
        - image: nginx:1.25
          name: nginx
          ports:
            - containerPort: 80
          resources: {}
status: {}
```

10. `k create -f canary.yaml`
11. `k create svc clusterip app-service --tcp=80:80 $do > svc.yaml`
12. `vim svc.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: app-service
  name: app-service
spec:
  ports:
    - name: 80-80
      port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: my-app # selects both canary and stable dpeloyment pod label
  type: ClusterIP
status:
  loadBalancer: {}
```

13. `k create -f svc.yaml`
14. `k get endpointslice`

```sh
k get endpointslice
# NAME                ADDRESSTYPE   PORTS   ENDPOINTS                                      AGE
# app-service-5sb92   IPv4          80      10.244.0.6,10.244.0.8,10.244.0.7 + 1 more...   3s

k describe endpointslice
# Endpoints:
#   - Addresses:  10.244.0.6
#     Conditions:
#       Ready:    true
#     Hostname:   <unset>
#     TargetRef:  Pod/app-stable-df7d4c75c-hdbzx
#     NodeName:   kind-control-plane
#     Zone:       <unset>
#   - Addresses:  10.244.0.8
#     Conditions:
#       Ready:    true
#     Hostname:   <unset>
#     TargetRef:  Pod/app-canary-8c859899d-5dpk8
#     NodeName:   kind-control-plane
#     Zone:       <unset>
#   - Addresses:  10.244.0.7
#     Conditions:
#       Ready:    true
#     Hostname:   <unset>
#     TargetRef:  Pod/app-stable-df7d4c75c-v7h8l
#     NodeName:   kind-control-plane
#     Zone:       <unset>
#   - Addresses:  10.244.0.5
#     Conditions:
#       Ready:    true
#     Hostname:   <unset>
#     TargetRef:  Pod/app-stable-df7d4c75c-fg8b2
#     NodeName:   kind-control-plane
#     Zone:       <unset>
```
