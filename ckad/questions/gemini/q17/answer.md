1. `kubectl create ns deploy-space`
2. `kubectl config set-context --current --namespace deploy-space`
3. `kubectl create deploy app-blue -n deploy-space --replicas=3 --image=nginx:1.24 --port=80 --dry-run=client -o yaml > deploy-blue.yaml`
4. `vim deploy-blue.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: app-blue
  name: app-blue
  namespace: deploy-space
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      version: blue
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: my-app
        version: blue
    spec:
      containers:
        - image: nginx:1.24
          name: nginx
          ports:
            - containerPort: 80
          resources: {}
status: {}
```

5. `kubectl create -f deploy-blue.yaml`
6. `kubectl get deploy app-blue -n deploy-space`
7. `kubectl get pods -n deploy-space --show-labels`
8. `kubectl create deploy app-green -n deploy-space --replicas=3 --image=nginx:1.25 --port=80 --dry-run=client -o yaml > deploy-green.yaml`
9. `vim deploy-green.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: app-green
  name: app-green
  namespace: deploy-space
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      version: green
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: my-app
        version: green
    spec:
      containers:
        - image: nginx:1.25
          name: nginx
          ports:
            - containerPort: 80
          resources: {}
status: {}
```

10. `kubectl create -f deploy-green.yaml`
11. `kubectl get pods -n deploy-space --show-labels`

```
NAME                         READY   STATUS    RESTARTS   AGE     LABELS
app-blue-65bfd685bb-8x4bp    1/1     Running   0          8m45s   app=my-app,pod-template-hash=65bfd685bb,version=blue
app-blue-65bfd685bb-dbvpx    1/1     Running   0          8m45s   app=my-app,pod-template-hash=65bfd685bb,version=blue
app-blue-65bfd685bb-q5kfd    1/1     Running   0          8m45s   app=my-app,pod-template-hash=65bfd685bb,version=blue
app-green-66fc5dbb96-4lgkm   1/1     Running   0          7m27s   app=my-app,pod-template-hash=66fc5dbb96,version=green
app-green-66fc5dbb96-f2wfw   1/1     Running   0          7m27s   app=my-app,pod-template-hash=66fc5dbb96,version=green
app-green-66fc5dbb96-gxk6b   1/1     Running   0          7m27s   app=my-app,pod-template-hash=66fc5dbb96,version=green
```

12. `kubectl get deploy -n deploy-space -o wide`

```
NAME        READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES       SELECTOR
app-blue    3/3     3            3           8m31s   nginx        nginx:1.24   app=my-app,version=blue
app-green   3/3     3            3           7m13s   nginx        nginx:1.25   app=my-app,version=green
```

13. `kubectl expose deploy app-blue -n deploy-space --port=80 --target-port=80 --dry-run=client -o yaml > svc.yaml`
14. `vim svc.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: my-svc
  name: app-service
  namespace: deploy-space
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: my-app
    version: green
status:
  loadBalancer: {}
```

15. `kubectl apply -f svc.yaml`
16. `kubectl get pods -o wide`

- Showed that the pods in app-blue deployment have IPs = 10.244.0.5,10.244.0.6,10.244.0.7

17. `kubectl get endpoints app-service` OR `k get endpointslices -n deploy-space -l kubernetes.io/service-name=app-service`

```
NAME                ADDRESSTYPE   PORTS   ENDPOINTS                           AGE
app-service-wgvxl   IPv4          80      10.244.0.5,10.244.0.6,10.244.0.7   4m27s
```

18. `vim svc.yaml`

- Edited Service manifest file to change label from `version: blue` to `version: green`.

19. `kubectl apply -f svc.yaml`

- Another method is `kubectl set selector svc app-service version=green -n deploy-space` to seamlessly apply new selector
- OR can also do `kubectl edit svc app-service -n deploy-space`

21. `kubectl get pods -o wide`
22. `kubectl get endpoints app-service` OR `k get endpointslices -n deploy-space -l kubernetes.io/service-name=app-service`

```
NAME                ADDRESSTYPE   PORTS   ENDPOINTS                           AGE
app-service-wgvxl   IPv4          80      10.244.0.8,10.244.0.9,10.244.0.10   4m27s
```
