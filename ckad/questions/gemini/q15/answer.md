1. `kubectl create ns crd-space`
2. `kubectl config set-context --current --namespace=crd-space`
3. `kubectl api-resources | grep 'crontabs.stable.example.com'`
4. `touch crontab-cr.yaml`
5. `vim crontab-cr.yaml`

```yaml
apiVersion: stable.example.com/v1
kind: CronTab
metadata:
  name: my-crontab
  namespace: crd-space
spec:
  cronSpec: "* * * * *"
  image: my-awesome-cron-image
```

6. `kubectl apply -f crontab-cr.yaml`
