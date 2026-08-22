- [Question 1: Create Secret from Hardcoded Variables](#question-1-create-secret-from-hardcoded-variables)
- [Question 2: Create CronJob with Schedule and History Limits](#question-2-create-cronjob-with-schedule-and-history-limits)
- [Question 3: Create ServiceAccount, Role, and RoleBinding from Logs Error](#question-3-create-serviceaccount-role-and-rolebinding-from-logs-error)
- [Question 4: Fix Broken Pod with Correct ServiceAccount](#question-4-fix-broken-pod-with-correct-serviceaccount)
- [Question 5: Build Container Image with Podman and Save as Tarball](#question-5-build-container-image-with-podman-and-save-as-tarball)
- [Question 6: Create Canary Deployment with Manual Traffic Split](#question-6-create-canary-deployment-with-manual-traffic-split)
- [Question 7: Fix NetworkPolicy by Updating Pod Labels](#question-7-fix-networkpolicy-by-updating-pod-labels)
- [Question 8: Fix Broken Deployment YAML](#question-8-fix-broken-deployment-yaml)
- [Question 9: Perform Rolling Update and Rollback](#question-9-perform-rolling-update-and-rollback)
- [Question 10: Add Readiness Probe to Deployment](#question-10-add-readiness-probe-to-deployment)
- [Question 11: Configure Pod and Container Security Context](#question-11-configure-pod-and-container-security-context)
- [Question 12: Fix Service Selector](#question-12-fix-service-selector)
- [Question 13: Create NodePort Service](#question-13-create-nodeport-service)
- [Question 14: Create Ingres Resource](#question-14-create-ingres-resource)
- [Question 15: Fix Ingress PathType](#question-15-fix-ingress-pathtype)
- [Question 16: Add Resource Requests and Limits to Pod](#question-16-add-resource-requests-and-limits-to-pod)

---

**References**:

- https://github.com/aravind4799/CKAD-Practice-Questions

---

**Setup**:

```sh
alias k=kubectl
alias kns='kubectl config set-context --current --namespace'
export do='--dry-run=client -o yaml'
export now='--grace-period=0 --force'
```

---

# Question 1: Create Secret from Hardcoded Variables

In namespace `default`, Deployment `api-server` exists with hard-coded environment variables:

- `DB_USER=admin`
- `DB_PASS=Secret123!`

**Requirements**

1. Create a Secret named `db-credentials` in namespace `default` containing:
   - `DB_USER=admin`
   - `DB_PASS=Secret123!`
2. Update Deployment `api-server` to use the Secret via `valueFrom.secretKeyRef`.
3. **Do not change** the Deployment name or namespace.

---

<details>
<summary>Setup for Question — click to expand</summary>

```sh
# Setup for Question, copy paste before doing
kubectl create deployment api-server \
  -n default \
  --image=nginx:alpine
kubectl set env deployment/api-server \
  -n default \
  DB_USER=admin \
  'DB_PASS=Secret123!'
kubectl rollout status deployment/api-server -n default
kubectl get deployment api-server \
  -n default \
  -o yaml
```

</details>

---

<details>
<summary>My Answer</summary>

1.  `k create secret generic db-credentials -n default --from-literal=DB_USER=admin --from-literal=DB_PASS='Secret123!'`
2.  `k edit deploy api-server -n default`

```yaml
# Under Deployment Pod Template
spec:
  containers:
    - env:
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              key: DB_USER
              name: db-credentials
        - name: DB_PASS
          valueFrom:
            secretKeyRef:
              key: DB_PASS
              name: db-credentials
```

5. `k get pods -n default`: To verify pod is running.
6. `k describe po api-server-77d6b84549-mzlld | grep -i -A 5 env`

```text
    Environment:
      DB_USER:  <set to the key 'DB_USER' in secret 'db-credentials'>  Optional: false
      DB_PASS:  <set to the key 'DB_PASS' in secret 'db-credentials'>  Optional: false
```

</details>

---

# Question 2: Create CronJob with Schedule and History Limits

Create a CronJob named `backup-job` in namespace `default` with the following specifications:

- **Schedule:** Run every 30 minutes (`*/30 * * * *`)
- **Image:** `busybox:latest`
- **Container command:** `echo "Backup completed"`
- Set `successfulJobsHistoryLimit: 3`
- Set `failedJobsHistoryLimit: 2`
- Set `activeDeadlineSeconds: 300`
- Use `restartPolicy: Never`

<details>
<summary>My Answer</summary>

1. `k create cj backup-job -n default --image=busybox:latest --schedule="*/30 * * * *" $do > cj.yaml`
2. `vim cj.yaml`

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  creationTimestamp: null
  name: backup-job
  namespace: default
spec:
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: backup-job
    spec:
      activeDeadlineSeconds: 300
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
            - image: busybox:latest
              name: backup-job
              resources: {}
              command: ["sh", "-c", "echo 'Backup completed'"]
          restartPolicy: Never
  schedule: "*/30 * * * *"
status: {}
```

3. `k create -f cj.yaml`
4. `k create job manual-run --from=cronjob/backup-job -n default`: manual run the job
5. `k logs job/manual-run`

```text
Backup completed
```

</details>

---

# Question 3: Create ServiceAccount, Role, and RoleBinding from Logs Error

In namespace `audit`, Pod `log-collector` exists but is failing with authorization errors.

Check the Pod logs to identify what permissions are needed:

```
kubectl logs -n audit log-collector
```

The logs show: `User "system:serviceaccount:audit:default" cannot list pods in the namespace "audit"`

Your task:

1. Create a ServiceAccount named `log-sa` in namespace `audit`
2. Create a Role `log-role` that grants `get`, `list`, and `watch` on resource `pods`
3. Create a RoleBinding `log-rb` binding `log-role` to `log-sa`
4. Update Pod `log-collector` to use ServiceAccount `log-sa`

---

<details>
<summary>Setup for Question — click to expand</summary>

```sh
# Setup for Question, copy paste before doing
kubectl create namespace audit
kubectl run log-collector \
  -n audit \
  --image=bitnami/kubectl:latest \
  --restart=Never \
  --command -- sh -c 'while true; do kubectl get pods -n audit; sleep 10; done'
kubectl wait \
  -n audit \
  --for=condition=Ready pod/log-collector \
  --timeout=60s
```

</details>

---

<details>
<summary>My Answer</summary>

1. `kns audit`
2. `kubectl logs -n audit log-collector`

```text
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:audit:default" cannot list resource "pods" in API group "" in the namespace "audit"
```

3. `k create sa log-sa -n audit`
4. `k create role log-role -n audit --verb=get,list,watch --resource=pods`
5. `k create rolebinding log-rb --role=log-role --serviceaccount=audit:log-sa -n audit`
6. `k describe rolebinding log-rb -n audit`
7. `k describe role log-role -n audit`
8. `k get po log-collector -n audit -o yaml > /tmp/log-collector.yaml`
9. `vim /tmp/log-collector.yaml`

```yaml
spec:
  containers:
  # delete this property: `spec.serviceAccount`
  serviceAccountName: log-sa
```

10. `k delete po log-collector $now -n audit`
11. `k apply -f /tmp/log-collector.yaml`
12. `k auth can-i list pods --as=system:serviceaccount:audit:log-sa -n audit`

```text
yes
```

</details>

# Question 4: Fix Broken Pod with Correct ServiceAccount

In namespace `monitoring`, Pod `metrics-pod` is using ServiceAccount `wrong-sa` and receiving authorization errors.

Multiple ServiceAccounts, Roles, and RoleBindings already exist in the namespace:

- ServiceAccounts: `monitor-sa`, `wrong-sa`, `admin-sa`
- Roles: `metrics-reader`, `full-access`, `view-only`
- RoleBindings: `monitor-binding`, `admin-binding`

Your task:

1. Identify which ServiceAccount/Role/RoleBinding combination has the correct permissions
2. Update Pod `metrics-pod` to use the correct ServiceAccount
3. Verify the Pod stops showing authorization errors

---

<details>
<summary>Setup for Question — click to expand</summary>

```sh
# Setup for Question, copy paste before doing
kubectl create namespace monitoring

kubectl create serviceaccount monitor-sa -n monitoring
kubectl create serviceaccount wrong-sa -n monitoring
kubectl create serviceaccount admin-sa -n monitoring

kubectl create role metrics-reader \
  -n monitoring \
  --verb=get,list,watch \
  --resource=pods

kubectl create role full-access \
  -n monitoring \
  --verb='*' \
  --resource='*'

kubectl create role view-only \
  -n monitoring \
  --verb=get \
  --resource=pods

kubectl create rolebinding monitor-binding \
  -n monitoring \
  --role=metrics-reader \
  --serviceaccount=monitoring:monitor-sa

kubectl create rolebinding admin-binding \
  -n monitoring \
  --role=full-access \
  --serviceaccount=monitoring:admin-sa

kubectl run metrics-pod \
  -n monitoring \
  --image=bitnami/kubectl:latest \
  --restart=Never \
  --overrides='{"spec":{"serviceAccountName":"wrong-sa"}}' \
  --command -- sh -c 'while true; do kubectl get pods -n monitoring; sleep 10; done'

kubectl wait \
  -n monitoring \
  --for=condition=Ready pod/metrics-pod \
  --timeout=60s
```

</details>

---

<details>
<summary>My Answer</summary>

1. `kns monitoring`
2. `k describe rolebindings -n monitoring`
3. `k describe roles -n monitoring`
4. `k get po metrics-pod -n monitoring -o yaml > pod.yaml`
5. `vim pod.yaml`

```yaml
spec:
  serviceAccountName: monitor-sa
```

6. `k delete po $now metrics-pod`
7. `k create -f pod.yaml`
8. `k get po metrics-pod`
9. `k logs metrics-pod`

</details>

# Question 5: Build Container Image with Podman and Save as Tarball

On the node, directory `/tmp/app-source` contains a valid `Dockerfile`.

Your task:

1. Build a container image using Podman with name `my-app:1.0` using `/tmp/app-source` as build context
2. Save the image as a tarball to `/tmp/my-app.tar`

**Note:** The exam environment typically uses Podman, but Docker commands are nearly identical.

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
mkdir -p /tmp/app-source

cat <<'EOF' > /tmp/app-source/Dockerfile
FROM docker.io/library/alpine:latest
CMD ["sh"]
EOF
```

</details>

---

<details>
<summary>My Answer</summary>

1. `podman build -t my-app:1.0 /tmp/app-source`
2. `podman save -o /tmp/my-app.tar my-app:1.0`
3. `ls -al /tmp/my-app.tar`

</details>

# Question 6: Create Canary Deployment with Manual Traffic Split

In namespace `default`, the following resources exist:

- Deployment `web-app` with 5 replicas, labels `app=webapp, version=v1`
- Service `web-service` with selector `app=webapp`

Your task:

1. Scale Deployment `web-app` to 8 replicas (80% of 10 total)
2. Create a new Deployment `web-app-canary` with 2 replicas, labels `app=webapp, version=v2`
3. Both Deployments should be selected by `web-service`
4. Verify the traffic split using the provided test command (if available)

**Note:** This is a manual canary pattern where traffic is split based on replica counts.

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
cat <<EOF > /tmp/web-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
  labels:
    app: webapp
    version: v1
spec:
  replicas: 5
  selector:
    matchLabels:
      app: webapp
      version: v1
  template:
    metadata:
      labels:
        app: webapp
        version: v1
    spec:
      containers:
      - name: nginx
        image: nginx:latest
EOF

kubectl apply -f /tmp/web-app.yaml

kubectl expose deployment web-app \
  --name=web-service \
  --port=80 \
  --selector=app=webapp
```

</details>

<details>
<summary>My Answer</summary>

1. `k scale deploy web-app -n default --replicas=8`
2. `k get deploy web-app -n default`
3. `k create deploy web-app-canary -n default --replicas=2 --image=nginx:latest $do > deploy.yaml`
4. `vim deploy.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: web-app-canary
  name: web-app-canary
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      version: v2
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webapp
        version: v2
    spec:
      containers:
        - image: nginx:latest
          name: nginx
          resources: {}
status: {}
```

5. `k create -f deploy.yaml`
6. `k get deploy -n default`

```text
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
web-app          8/8     8            8           6m18s
web-app-canary   2/2     2            2           5s
```

7. `k get ep web-service -n default`

```text
Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice
NAME          ENDPOINTS                                                  AGE
web-service   10.244.0.10:80,10.244.0.11:80,10.244.0.12:80 + 7 more...   5m52s
```

</details>

# Question 7: Fix NetworkPolicy by Updating Pod Labels

In namespace `network-demo`, three Pods exist:

- `frontend` with label `role=wrong-frontend`
- `backend` with label `role=wrong-backend`
- `database` with label `role=wrong-db`

Three NetworkPolicies exist:

- `deny-all` (default deny)
- `allow-frontend-to-backend` (allows traffic from `role=frontend` to `role=backend`)
- `allow-backend-to-db` (allows traffic from `role=backend` to `role=db`)

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl create namespace network-demo

kubectl run frontend \
  -n network-demo \
  --image=nginx \
  --labels=role=wrong-frontend

kubectl run backend \
  -n network-demo \
  --image=nginx \
  --labels=role=wrong-backend

kubectl run database \
  -n network-demo \
  --image=nginx \
  --labels=role=wrong-db

kubectl apply -n network-demo -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: frontend
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: backend
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `kns network-demo`
2. `k label pod frontend role=frontend --overwrite`
3. `k label pod backend role=backend --overwrite`
4. `k label pod database role=db --overwrite`
5. `k get pods -n network-demo --show-labels`

</details>

# Question 8: Fix Broken Deployment YAML

File `/tmp/broken-deploy.yaml` contains a Deployment manifest that fails to apply.

The file has the following issues:

1. Uses deprecated API version
2. Missing required `selector` field
3. Selector doesn't match template labels

Your task:

1. Fix the YAML file to use `apiVersion: apps/v1`
2. Add a proper `selector` field that matches the template labels
3. Apply the fixed manifest and ensure the Deployment is running

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
cat <<'EOF' > /tmp/broken-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: broken-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: wrong-app
  template:
    metadata:
      labels:
        app: broken-app
    spec:
      containers:
        - name: nginx
          image: nginx
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `vim /tmp/broken-deploy.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: nginx
          image: nginx
```

2. `k create -f /tmp/broken-deploy.yaml`
3. `k get deploy broken-deploy`
4. `k get po`
5. `k rollout status deploy broken-deploy`

```text
deployment "broken-deploy" successfully rolled out
```

</details>

# Question 9: Perform Rolling Update and Rollback

In namespace `default`, Deployment `app-v1` exists with image `nginx:1.20`.

Your task:

1. Update the Deployment to use image `nginx:1.25`
2. Verify the rolling update completes successfully
3. Rollback to the previous revision
4. Verify the rollback completed

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl create deployment app-v1 \
  --image=nginx:1.20 \
  --replicas=3
```

</details>

<details>
<summary>My Answer</summary>

1. `k set image deploy app-v1 nginx=nginx:1.25`
2. `k get deploy -o wide`

```text
NAME     READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES       SELECTOR
app-v1   3/3     1            3           42s   nginx        nginx:1.25   app=app-v1
```

3. `k rollout status deploy/app-v1`

```text
deployment "app-v1" successfully rolled out
```

4. `k rollout history deploy/app-v1`

```text
deployment.apps/app-v1
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

5. `k rollout undo deploy/app-v1 --to-revision=1`
6. `k rollout status deploy/app-v1`
7. `k get deploy app-v1 -o wide`

```text
NAME     READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES       SELECTOR
app-v1   3/3     3            3           2m53s   nginx        nginx:1.20   app=app-v1
```

</details>

# Question 10: Add Readiness Probe to Deployment

In namespace `default`, Deployment `api-deploy` exists with a container listening on port `8080`.

Your task: Add a readiness probe to the Deployment with:

- HTTP GET on path `/ready`
- Port `8080`
- `initialDelaySeconds: 5`
- `periodSeconds: 10`

Ensure the Deployment rolls out successfully.

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl create deployment api-deploy \
  --image=nginx:latest

kubectl patch deployment api-deploy \
  --type='strategic' \
  -p='{"spec":{"template":{"spec":{"containers":[{"name":"nginx","ports":[{"containerPort":8080}]}]}}}}'
```

</details>

<details>
<summary>My Answer</summary>

1. `k edit deploy api-deploy`

```yaml
# Pod Spec
spec:
  containers:
    - image: nginx:latest
      imagePullPolicy: Always
      name: nginx
      ports:
        - containerPort: 8080
          protocol: TCP
      readinessProbe:
        failureThreshold: 3
        httpGet:
          path: /ready
          port: 8080
          scheme: HTTP
        initialDelaySeconds: 5
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 1
```

2. `k rollout status deploy/api-deploy`

</details>

# Question 11: Configure Pod and Container Security Context

In namespace `default`, Deployment `secure-app` exists without any security context.

Your task:

1. Set Pod-level `runAsUser: 1000`
2. Add container-level capability `NET_ADMIN` to the container named `app`

**Note:** Capabilities are set at the container level, not the Pod level.

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl delete deployment secure-app --ignore-not-found
kubectl create deployment secure-app \
  --image=nginx:latest
kubectl patch deployment secure-app \
  --type='json' \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/name","value":"app"}]'
```

</details>

<details>
<summary>My Answer</summary>

1. `k edit deploy secure-app`

```yaml
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
        - image: nginx:latest
          name: app
          securityContext:
            capabilities:
              add:
                - NET_ADMIN
      securityContext:
        runAsUser: 1000
```

2. `k get pod -n default -l app=secure-app -o yaml | grep -A 10 securityContext`

```text
    securityContext:
      runAsUser: 1000

      securityContext:
        capabilities:
          add:
          - NET_ADMIN
```

</details>

# Question 12: Fix Service Selector

In namespace `default`, Deployment `web-app` exists with Pods labeled `app=webapp, tier=frontend`.
Service `web-svc` exists but has incorrect selector `app=wrongapp`.
Your task: Update Service `web-svc` to correctly select Pods from Deployment `web-app`.

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
      tier: frontend
  template:
    metadata:
      labels:
        app: webapp
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:latest
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: wrongapp
  ports:
    - port: 80
      targetPort: 80
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `k get pods --show-labels`: to check its labels
2. `k get service web-svc -o wide`: to check its selectors
3. `k edit svc web-svc`

```yaml
spec:
  selector:
    app: webapp
```

4. `k get endpoints web-svc`

```text
Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice
NAME      ENDPOINTS       AGE
web-svc   10.244.0.6:80   87s
```

</details>

# Question 13: Create NodePort Service

In namespace `default`, Deployment `api-server` exists with Pods labeled `app=api` and container port `9090`.

Your task: Create a Service named `api-nodeport` that:

- Type: `NodePort`
- Selects Pods with label `app=api`
- Exposes Service port `80` mapping to target port `9090`

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api-server
          image: nginx:latest
          ports:
            - containerPort: 9090
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `k get pods --show-labels -n default`
2. `k expose deploy api-server --name=api-nodeport --type=NodePort --port=80 --target-port=9090`
3. `k get svc api-nodeport -o yaml`

```yaml
spec:
  selector:
    app: api
```

4. `k describe svc api-nodeport`
5. `k get ep api-nodeport`

```text
Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice
NAME           ENDPOINTS         AGE
api-nodeport   10.244.0.5:9090   2m11s
```

</details>

# Question 14: Create Ingres Resource

In namespace `default`, the following resources exist:

- Deployment `web-deploy` with Pods labeled `app=web`
- Service `web-svc` with selector `app=web` on port `8080`

Your task: Create an Ingress named `web-ingress` that:

- Routes host `web.example.com`
- Path `/` with `pathType: Prefix`
- Backend Service `web-svc` on port `8080`
- Uses API version `networking.k8s.io/v1`

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: nginx:latest
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web
  ports:
    - port: 8080
      targetPort: 80
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `k get svc web-svc -n default -o wide`
2. `k create ingress web-ingress --rule=web.example.com/=web-svc:8080 $do > ingress.yaml`
3. `vim ingress.yaml`

```yaml
spec:
  rules:
    - host: web.example.com
      http:
        paths:
          - backend:
              service:
                name: web-svc
                port:
                  number: 8080
            path: /
            pathType: Prefix # changed from `Exact` to `Prefix`
```

4. `k create -f ingress.yaml`
5. `k describe ingress web-ingress`

---

```sh
# Faster method
# `/*` generates `/` with pathType: Prefix
k create ingress web-ingress \
  --rule="web.example.com/*=web-svc:8080"
```

---

</details>

# Question 15: Fix Ingress PathType

File `/tmp/fix-ingress.yaml` contains an Ingress manifest that fails to apply due to an invalid `pathType` value.

Your task:

1. Apply the file and note the error
2. Fix the `pathType` to a valid value (`Prefix`, `Exact`, or `ImplementationSpecific`)
3. Ensure the Ingress routes path `/api` to Service `api-svc` on port `8080`
4. Apply the fixed manifest successfully

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
cat <<'EOF' > /tmp/fix-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
spec:
  rules:
    - http:
        paths:
          - path: /api
            pathType: Invalid
            backend:
              service:
                name: api-svc
                port:
                  number: 8080
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `k apply -f /tmp/fix-ingress.yaml`

```text
The Ingress "api-ingress" is invalid: spec.rules[0].http.paths[0].pathType: Unsupported value: "Invalid": supported values: "Exact", "ImplementationSpecific", "Prefix"
```

2. `vim /tmp/fix-ingress.yaml`

Change from `pathType: Invalid` to `pathType: Prefix`

3. `k apply -f /tmp/fix-ingress.yaml`
4. `k describe ingress api-ingress`

</details>

# Question 16: Add Resource Requests and Limits to Pod

In namespace `prod`, a ResourceQuota exists that sets resource limits for the namespace.

Your task:

1. Check the ResourceQuota for namespace `prod` to see the limits set
2. Create a Pod named `resource-pod` with:
   - Image: `nginx:latest`
   - Set the CPU and memory limits to **half** of the limits set in the ResourceQuota
   - Set appropriate requests (at least `100m` CPU and `128Mi` memory)

<details>
<summary># Setup for Question, copy paste before doing</summary>

```sh
kubectl create namespace prod

kubectl apply -n prod -f - <<'EOF'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-quota
spec:
  hard:
    limits.cpu: "2"
    limits.memory: 2Gi
    requests.cpu: "1"
    requests.memory: 1Gi
EOF
```

</details>

<details>
<summary>My Answer</summary>

1. `k get resourcequota -n prod`: to check current limits and requests quota.

```text
NAME         REQUEST                                     LIMIT                                   AGE
prod-quota   requests.cpu: 0/1, requests.memory: 0/1Gi   limits.cpu: 0/2, limits.memory: 0/2Gi   2m57s
```

2. `k run resource-pod --image=nginx:latest $do > pod.yaml`
3. `vim pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: resource-pod
  name: resource-pod
spec:
  containers:
    - image: nginx:latest
      name: resource-pod
      resources:
        requests:
          memory: 128Mi
          cpu: 100m
        limits:
          memory: 1Gi
          cpu: 1
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

4. `k create -f pod.yaml`
5. `k describe pod resource-pod`

```text
Containers:
  resource-pod:
    Limits:
      cpu:     1
      memory:  1Gi
    Requests:
      cpu:        100m
      memory:     128Mi
```

</details>
