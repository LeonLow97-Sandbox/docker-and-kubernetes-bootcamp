1. `kubectl create namespace ingress-space`
2. `kubectl config set-context --current --namespace=ingress-space`
3. `kubectl create deploy video-deployment --image=nginx:1.25 --replicas=1`
4. `kubectl expose deploy video-deployment --name=video-svc --port=80 --target-port=80 --type=ClusterIP`
5. `kubectl create deploy store-deployment --image=nginx:1.25 --replicas=1`
6. `kubectl expose deploy store-deployment --name=store-svc --port=80 --target-port=80 --type=ClusterIP`
7. `vim ingress.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: ingress-space
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - path: /video
            pathType: Prefix
            backend:
              service:
                name: video-svc
                port:
                  number: 80
          - path: /store
            pathType: Prefix
            backend:
              service:
                name: store-svc
                port:
                  number: 80
```

8. `kubectl create -f ingress.yaml`
9. `kubectl describe ingress app-ingress -n ingress-space`

```sh
# Output:
# Name:             app-ingress
# Labels:           <none>
# Namespace:        ingress-space
# Address:
# Ingress Class:    nginx
# Default backend:  <default>
# Rules:
#   Host        Path  Backends
#   ----        ----  --------
#   *
#               /video   video-svc:80 (10.244.0.5:80)
#               /store   store-svc:80 (10.244.0.6:80)
# Annotations:  <none>
# Events:       <none>
```

10. `kubectl get endpointslice`

```sh
# Output:
# NAME              ADDRESSTYPE   PORTS   ENDPOINTS    AGE
# store-svc-5vws6   IPv4          80      10.244.0.6   6m57s
# video-svc-pvvp9   IPv4          80      10.244.0.5   7m43s
```
