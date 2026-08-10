1. `kubectl create ns init-space`
2. `kubectl config set-context --current --namespace=init-space`
3. `k run init-space -n init-space --image=nginx:1.25 $do > pod.yaml`
4. `vim pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: init-space
  name: init-pod
  namespace: init-space
spec:
  initContainers:
    - name: init-config
      image: busybox:1.36
      command: ['sh', '-c', "echo 'env=production' > /config/app.env"]
      volumeMounts:
        - name: config-vol
          mountPath: /config
  containers:
    - image: nginx:1.25
      name: web-app
      volumeMounts:
        - name: config-vol
          mountPath: /etc/app-config
      resources: {}
  volumes:
    - name: config-vol
      emptyDir: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

5. `k create -f pod.yaml`
6. `k exec -it init-pod -- sh`
7. `cat /etc/app-config/app.env`

```
env=production
```
