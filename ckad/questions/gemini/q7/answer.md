1. `kubectl create ns security-space`
2. `kubectl create sa sec-sa`
3. `kubectl run secure-app --image=nginx:1.25 --dry-run=client -o yaml > pod.yaml`
4. `vim pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secure-app
  name: secure-app
spec:
  serviceAccountName: sec-sa
  containers:
    - image: nginxinc/nginx-unprivileged:1.25 # to allow running as userID 1000
      name: secure-app
      resources: {}
      securityContext:
        runAsUser: 1000
        allowPrivilegeEscalation: false
      livenessProbe:
        httpGet:
          path: /
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 10
      readinessProbe:
        httpGet:
          path: /
          port: 8080
        initialDelaySeconds: 3
        periodSeconds: 5
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

5. `kubectl create -f pod.yaml`
6. `kubectl get pods`

```sh
# NAME         READY   STATUS    RESTARTS   AGE
# secure-app   1/1     Running   0          2m21s
```

7. `kubectl describe po secure-app`

```sh
# Name:             secure-app
# Namespace:        security-space
# Priority:         0
# Service Account:  sec-sa
# Node:             kind-control-plane/10.89.4.19
# Start Time:       Sat, 25 Jul 2026 15:21:18 +0800
# Labels:           run=secure-app
# Annotations:      <none>
# Status:           Running
# IP:               10.244.0.7
# IPs:
#   IP:  10.244.0.7
# Containers:
#   secure-app:
#     Container ID:   containerd://d0aa79ff147065deded11ffe6d1a51d73b71a9b8f1691f6ae9fbcf0403518c3a
#     Image:          nginxinc/nginx-unprivileged:1.25
#     Image ID:       docker.io/nginxinc/nginx-unprivileged@sha256:77e4b763b46ed8be6da1e8cc6386e3965411ea8e86f1c8f254a868d66657bddc
#     Port:           <none>
#     Host Port:      <none>
#     State:          Running
#       Started:      Sat, 25 Jul 2026 15:21:18 +0800
#     Ready:          True
#     Restart Count:  0
#     Liveness:       http-get http://:8080/ delay=5s timeout=1s period=10s #success=1 #failure=3
#     Readiness:      http-get http://:8080/ delay=3s timeout=1s period=5s #success=1 #failure=3
#     Environment:    <none>
#     Mounts:
#       /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-rcqbw (ro)
# Conditions:
#   Type                        Status
#   PodReadyToStartContainers   True
#   Initialized                 True
#   Ready                       True
#   ContainersReady             True
#   PodScheduled                True
# Volumes:
#   kube-api-access-rcqbw:
#     Type:                    Projected (a volume that contains injected data from multiple sources)
#     TokenExpirationSeconds:  3607
#     ConfigMapName:           kube-root-ca.crt
#     Optional:                false
#     DownwardAPI:             true
# QoS Class:                   BestEffort
# Node-Selectors:              <none>
# Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
#                              node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
# Events:
#   Type    Reason     Age    From               Message
#   ----    ------     ----   ----               -------
#   Normal  Scheduled  2m39s  default-scheduler  Successfully assigned security-space/secure-app to kind-control-plane
#   Normal  Pulled     2m39s  kubelet            Container image "nginxinc/nginx-unprivileged:1.25" already present on machine and can be accessed by the pod
#   Normal  Created    2m39s  kubelet            Container created
#   Normal  Started    2m39s  kubelet            Container started
```
