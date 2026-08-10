1. `kubectl create ns app-space`
2. `kubectl config set-context --current --namespace=app-space`
3. `kubectl create secret generic db-secret --from-literal=DB_Password=super-secret-123`
4. `kubectl create cm app-config --from-literal=APP_COLOR=blue --from-literal=APP_MODE=live`
5. `kubectl create deploy webapp-dep --image=nginx:1.25 --replicas=2 --dry-run=client -o yaml > deploy.yaml`
6. `vim deploy.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: webapp-dep
  name: webapp-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp-dep
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webapp-dep
    spec:
      containers:
        - image: nginx:1.25
          name: webapp-container
          envFrom:
            - configMapRef:
                name: app-config
          env:
            - name: DB_PASS
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: DB_Password
          resources: {}
status: {}
```

7. `kubectl create -f deploy.yaml`
8. `kubectl exec -n app-space deploy/webapp-dep -c webapp-container -- env`

```sh
# Output:
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# HOSTNAME=webapp-dep-7b8569f459-khxmf
# NGINX_VERSION=1.25.5
# NJS_VERSION=0.8.4
# NJS_RELEASE=3~bookworm
# PKG_RELEASE=1~bookworm
# APP_COLOR=blue
# APP_MODE=live
# DB_Pass=super-secret-123
# KUBERNETES_SERVICE_PORT=443
# KUBERNETES_SERVICE_PORT_HTTPS=443
# KUBERNETES_PORT=tcp://10.96.0.1:443
# KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
# KUBERNETES_PORT_443_TCP_PROTO=tcp
# KUBERNETES_PORT_443_TCP_PORT=443
# KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
# KUBERNETES_SERVICE_HOST=10.96.0.1
# HOME=/root
```
