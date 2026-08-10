1. `kubectl create ns logging-space`
2. `kubectl run counter-pod --image=busybox:1.36 -n logging-space --dry-run=client -o yaml > pod.yaml`
3. `vim pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  name: counter-pod
  namespace: logging-space
spec:
  containers:
  - image: busybox:1.36
    name: count-app
    command: ["sh", "-c", "i=0; while true; do echo \"APP LOG: $i\"; i=$((i+1)); sleep 2; done"]
    resources: {}
  - image: busybox:1.36
    name: count-sidecar
    command: ["sh", "-c", "i=0; while true; do echo \"SIDECAR LOG: $i\"; i=$((i+1)); sleep 2; done"]
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

4. `kubectl create -f pod.yaml`
5. `kubectl logs counter-pod -c count-app | tail -n 5 > /tmp/count-app.log`
6. `kubectl logs counter-pod -c count-sidecar --since=30s > /tmp/count-sidecar.log`

```sh
cat /tmp/count-app.log
# APP LOG: 68
# APP LOG: 69
# APP LOG: 70
# APP LOG: 71
# APP LOG: 72

cat /tmp/count-sidecar.log
# SIDECAR LOG: 87
# SIDECAR LOG: 88
# SIDECAR LOG: 89
# SIDECAR LOG: 90
# SIDECAR LOG: 91
# SIDECAR LOG: 92
# SIDECAR LOG: 93
# SIDECAR LOG: 94
# SIDECAR LOG: 95
# SIDECAR LOG: 96
# SIDECAR LOG: 97
# SIDECAR LOG: 98
# SIDECAR LOG: 99
# SIDECAR LOG: 100
# SIDECAR LOG: 101
```