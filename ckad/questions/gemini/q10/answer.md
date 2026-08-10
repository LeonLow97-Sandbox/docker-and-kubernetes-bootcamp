1. `k create ns finance-space`
2. `k config set-context --current --namespace=finance-space`
3. `k create quota finance-quota --dry-run=client -o yaml > quota.yaml`
4. `vim quota.yaml`

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  creationTimestamp: null
  name: finance-quota
spec:
  hard:
    requests.cpu: 500m
    requests.memory: 512Mi
    pods: "4"
    limits.cpu: 1
    limits.memory: 1Gi
status: {}
```

5. `k create -f quota.yaml`
6. `vim limits.yaml` (no imperative command)

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: finance-limits
  namespace: finance-space
spec:
  limits:
    - default:
        cpu: 200m
        memory: 256Mi
      defaultRequest:
        cpu: 100m
        memory: 128Mi
      type: Container
```

7. `k create -f limits.yaml`
8. `k run finance-pod --image=nginx:1.25` (should automatically inherit the default requests and limits from LimitRange)
9. `kubectl describe quota finance-quota -n finance-space`

```
Name:            finance-quota
Namespace:       finance-space
Resource         Used   Hard
--------         ----   ----
limits.cpu       200m   1
limits.memory    256Mi  1Gi
pods             1      4
requests.cpu     100m   500m
requests.memory  128Mi  512Mi
```

10. `kubectl get pod finance-pod -n finance-space -o yaml | grep -i -A 5 resource`

```
  resourceVersion: "1215"
  uid: 31edcaef-8b54-4caa-a5e5-216506a86009
spec:
  containers:
  - image: nginx:1.25
    imagePullPolicy: IfNotPresent
--
    resources:
      limits:
        cpu: 200m
        memory: 256Mi
      requests:
        cpu: 100m
--
  - allocatedResources:
      cpu: 100m
      memory: 128Mi
    containerID: containerd://55a7174bfc3235ddd403c084de13d4ff962c3cf561dc9d9b0786930abdcae729
    image: docker.io/library/nginx:1.25
    imageID: docker.io/library/nginx@sha256:a484819eb60211f5299034ac80f6a681b06f89e65866ce91f356ed7c72af059c
--
    resources:
      limits:
        cpu: 200m
        memory: 256Mi
      requests:
        cpu: 100m
```
