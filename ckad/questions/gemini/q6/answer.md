1. `kubectl create ns storage-space`
2. `kubectl config set-context --current --namespace=storage-space`
3. `vim pv.yaml`

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /mnt/data
```

4. `kubectl create -f pv.yaml`
5. `vim pvc.yaml`

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: manual
  volumeName: app-pv
```

6. `kubectl create -f pvc.yaml`
7. `kubectl run storage-pod --image=nginx:1.25 --dry-run=client -o yaml > pod.yaml`

```yaml
# Under volumeMounts
spec:
  containers:
    - image: nginx:1.25
      volumeMounts:
        - mountPath: /var/www/html
          name: app-pvc
  volumes:
    - name: app-pvc
      persistentVolumeClaim:
        claimName: app-pvc
```

9. `kubectl replace --force -f "..."` need to do this after `kubectl edit pod` command.
10. `kubectl get pvc`

```sh
# NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
# app-pvc   Bound    app-pv   1Gi        RWO            manual         <unset>                 3m14s
```

11. `kubectl describe pod storage-pod | grep -i -A 5 volume`

```sh
# Volumes:
#   app-pvc:
#     Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
#     ClaimName:  app-pvc
#     ReadOnly:   false
#   kube-api-access-nsc7w:
#     Type:                    Projected (a volume that contains injected data from multiple sources)
#     TokenExpirationSeconds:  3607
#     ConfigMapName:           kube-root-ca.crt
#     Optional:                false
#     DownwardAPI:             true
# QoS Class:                   BestEffort
```
