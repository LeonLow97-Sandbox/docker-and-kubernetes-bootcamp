1. `k create ns prod-space`
2. `k config set-context --current --namespace=prod-space`
3. `k create deploy web-app --image=nginx:1.24 --replicas=3`
4. `k annotate deploy web-app kubernetes.io/change-cause="Initial version 1.24"`
5. `k rollout history deploy web-app`

```
deployment.apps/web-app 
REVISION  CHANGE-CAUSE
1         Initial version 1.24
```

6. `k rollout pause deploy web-app`
7. `k set image deploy/web-app nginx=nginx:invalid-tag-999`
8. `k annotate deploy web-app kubernetes.io/change-cause="Upgraded to broken version"`
9. `k rollout resume deploy web-app`
10. `k rollout history deploy web-app`

```
deployment.apps/web-app 
REVISION  CHANGE-CAUSE
1         Initial version 1.24
2         Upgraded to broken version
```

11. `k events pod <pod>`

```
5s (x3 over 46s)    Warning   Failed              Pod/web-app-8db8cc949-hrrjh     Failed to pull image "nginx:invalid-tag-999": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/nginx:invalid-tag-999": failed to resolve reference "docker.io/library/nginx:invalid-tag-999": docker.io/library/nginx:invalid-tag-999: not found
5s (x3 over 46s)    Warning   Failed              Pod/web-app-8db8cc949-hrrjh     Error: ErrImagePull
```

12. `k rollout undo deploy web-app --to-revision=1`
13. `k edit deploy web-app`

```yaml
spec:
  replicas: 3
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```

14. `k rollout status deploy web-app`

```
deployment "web-app" successfully rolled out
```

15. `k describe deploy web-app`

```
Name:                   web-app
Namespace:              prod-space
CreationTimestamp:      Sat, 25 Jul 2026 19:09:24 +0800
Labels:                 app=web-app
Annotations:            deployment.kubernetes.io/revision: 3
                        kubernetes.io/change-cause: Initial version 1.24
Selector:               app=web-app
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  0 max unavailable, 1 max surge
Pod Template:
  Labels:  app=web-app
  Containers:
   nginx:
    Image:         nginx:1.24
    Port:          <none>
    Host Port:     <none>
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  web-app-8db8cc949 (0/0 replicas created)
NewReplicaSet:   web-app-76cffc8978 (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  4m5s   deployment-controller  Scaled up replica set web-app-76cffc8978 from 0 to 3
  Normal  ScalingReplicaSet  2m59s  deployment-controller  Scaled up replica set web-app-8db8cc949 from 0 to 1
  Normal  ScalingReplicaSet  83s    deployment-controller  Scaled down replica set web-app-8db8cc949 from 1 to 0
```