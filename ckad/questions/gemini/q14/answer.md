1. `kubectl create ns ops-space`
2. `kubectl config set-context --current --namespace=ops-space`
3. `kubectl create deploy api-server --image=nginx:1.25 --replicas=4 --namespace=ops-space --dry-run=client -o yaml > deploy.yaml`
4. `vim deploy.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: api-server
  name: api-server
  namespace: ops-space
spec:
  replicas: 4
  selector:
    matchLabels:
      app: api-server
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: api-server
    spec:
      containers:
        - image: nginx:1.25
          name: nginx
          resources: {}
      tolerations:
        - key: tier
          operator: Equal
          effect: NoSchedule
          value: backend
status: {}
```

5. `kubectl create pdb api-pdb -n ops-space --help`: unsure how to add `selector` and `minAvailable`.
6. `kubectl create pdb api-pdb -n ops-space --selector=app=api-server --min-available=3`
7. Verify

```sh
bash-3.2$ k get pdb api-pdb -n ops-space
# NAME      MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
# api-pdb   3               N/A               1                     10s

bash-3.2$ kubectl get deploy api-server -n ops-space -o yaml | grep -i -A 5 tolerations
#       tolerations:
#       - effect: NoSchedule
#         key: tier
#         operator: Equal
#         value: backend
# status:
```
