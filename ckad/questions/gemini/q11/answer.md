1. `k create ns helm-space`
2. `k config set-context --current --namespace=helm-space`
3. `helm repo add bitnami https://charts.bitnami.com/bitnami`
4. `helm repo update`
5. `helm install my-web-app bitnami/apache --set=replicaCount=2,service.type=ClusterIP`
6. `helm upgrade my-web-app bitnami/apache --set=replicaCount=3 --reuse-values`
7. `helm list`

```
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
my-web-app      helm-space      2               2026-07-26 18:12:47.914947 +0800 +08    deployed        apache-11.4.29  2.4.65
```

9. `k get deploy -n helm-space`

```
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
my-web-app-apache   0/3     3            0           5m10s
```
