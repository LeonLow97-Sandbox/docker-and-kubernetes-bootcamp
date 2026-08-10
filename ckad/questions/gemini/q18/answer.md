1. `k create ns node-space`
2. `k config set-context --current --namespace=node-space`
3. `k create deploy analytics-deployment -n node-space --replicas=2 --image=nginx:1.25 --dry-run=client -o yaml > deploy.yaml`
4. `vim deploy.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: analytics-deployment
  name: analytics-deployment
  namespace: node-space
spec:
  replicas: 2
  selector:
    matchLabels:
      app: analytics
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: analytics
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: disktype
                operator: In
                values:
                - ssd
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: zone
                operator: In
                values:
                - us-east-1a
      containers:
      - image: nginx:1.25
        name: nginx
        resources: {}
status: {}
```

5. `k create -f deploy.yaml`
6. `kubectl get deploy analytics-deployment -n node-space -o yaml`
