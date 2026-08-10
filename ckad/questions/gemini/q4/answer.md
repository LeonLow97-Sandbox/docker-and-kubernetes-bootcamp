1. `kubectl create ns secure-net`
2. `kubectl config set-context --current --namespace=secure-net`
3. `kubectl create deploy frontend --image=nginx:1.25 --replicas=1 $do > deploy-fe.yaml`
   - `vim deploy-fe.yaml` --> Labels are already `app: frontend`
4. `kubectl create deploy backend --image=redis:7-alpine --replicas=1 --port=6379 $do > deploy-be.yaml`
   - `vim deploy-be.yaml` --> Labels are already `app: backend`
5. `kubectl create -f deploy-fe.yaml`
6. `kubectl create -f deploy-be.yaml`
7. `kubectl expose deploy backend --name=backend-svc --type=ClusterIP --port=6379 --target-port=6379 $do > svc.yaml`
   - `vim svc.yaml` --> Labels are already `app: backend`
8. `kubectl create -f svc.yaml`
9. `vi np.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: secure-net
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 6379
```

10. `kubectl create -f np.yaml`
11. `kubectl describe netpol allow-frontend-to-backend -n secure-net`

```sh
# Name:         allow-frontend-to-backend
# Namespace:    secure-net
# Created on:   2026-07-24 21:33:00 +0800 +08
# Labels:       <none>
# Annotations:  <none>
# Spec:
#   PodSelector:     app=backend
#   Allowing ingress traffic:
#     To Port: 6379/TCP
#     From:
#       PodSelector: app=frontend
#   Not affecting egress traffic
#   Policy Types: Ingress
```
