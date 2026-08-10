1. `kubectl config set-context --current --namespace=default`
2. `kubectl run busybox-logger --image=nginx --dry-run=client -o yaml > pod.yaml`
3. `vim pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: busybox-logger
  name: busybox-logger
spec:
  containers:
  - image: nginx
    name: web-container
    resources: {}
    volumeMounts:
      - name: shared-data
        mountPath: /usr/share/nginx/html
  - image: busybox
    name: sidecar-container
    command: ['sh', '-c', 'while true; do date >> /var/log/index.html; sleep 5; done']
    volumeMounts:
      - name: shared-data
        mountPath: /var/log
  volumes:
    - name: shared-data
      emptyDir: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

4. `kubectl create -f pod.yaml`
5. `kubectl exec busybox-logger -c web-container -- curl localhost`

```sh
# Output:
#   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
#                                  Dload  Upload   Total   Spent    Left  Speed
#   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Fri Jul 24 06:04:29 UTC 2026
# Fri Jul 24 06:04:34 UTC 2026
# Fri Jul 24 06:04:39 UTC 2026
# Fri Jul 24 06:04:44 UTC 2026
# Fri Jul 24 06:04:49 UTC 2026
# Fri Jul 24 06:04:54 UTC 2026
# Fri Jul 24 06:04:59 UTC 2026
# Fri Jul 24 06:05:04 UTC 2026
# Fri Jul 24 06:05:09 UTC 2026
# Fri Jul 24 06:05:14 UTC 2026
# Fri Jul 24 06:05:19 UTC 2026
# Fri Jul 24 06:05:24 UTC 2026
# Fri Jul 24 06:05:29 UTC 2026
# Fri Jul 24 06:05:34 UTC 2026
# Fri Jul 24 06:05:39 UTC 2026
# Fri Jul 24 06:05:44 UTC 2026
# Fri Jul 24 06:05:49 UTC 2026
# Fri Jul 24 06:05:54 UTC 2026
# 100   522  100   522    0     0   617k      0 --:--:-- --:--:-- --:--:--  509k
```