1. Setup folder structure:

```sh
/ tree /tmp
# └── tmp
#     └── kustomize
#         ├── base
#         │   ├── deployment.yaml
#         │   └── kustomization.yaml
#         └── overlays
#             └── dev
#                 └── kustomization.yaml
```

2. View folder contents (`/base`):

```sh
/ cat /tmp/kustomize/base/deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deploy
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: app-container
          image: nginx:1.24
          ports:
            - containerPort: 80
```

```sh
/ cat /tmp/kustomize/base/deployment.yaml
```

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
```

3. View folder contents (`/base`):

```sh
/ cat /tmp/kustomize/overlays/dev/kustomization.yaml
```

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base/

namePrefix: dev-

images:
  - name: nginx:1.24
    newName: nginx
    newTag: "1.25"

labels:
  - pairs:
      env: development

replicas:
  - name: app-deploy
    count: 3
```

4. Apply `dev` overlay.

```sh
kubectl apply -k ./tmp/kustomize/overlays/dev
# deployment.apps/dev-app-deploy created

kubectl get deploy -o wide
# NAME             READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS      IMAGES       SELECTOR
# dev-app-deploy   3/3     3            3           53s   app-container   nginx:1.25   app=nginx,env=development
kubectl get pods --show-labels
# NAME                              READY   STATUS    RESTARTS   AGE   LABELS
# dev-app-deploy-58cdf65d47-kdg4n   1/1     Running   0          2s    app=nginx,env=development,pod-template-hash=58cdf65d47
# dev-app-deploy-58cdf65d47-qmzcp   1/1     Running   0          2s    app=nginx,env=development,pod-template-hash=58cdf65d47
# dev-app-deploy-58cdf65d47-vbjgn   1/1     Running   0          2s    app=nginx,env=development,pod-template-hash=58cdf65d47
```
