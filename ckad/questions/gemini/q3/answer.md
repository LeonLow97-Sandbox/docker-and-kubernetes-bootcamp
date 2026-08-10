1. `kubectl create ns qa-namespace`
2. `kubectl config set-context --current --namespace=qa-namespace`
3. `kubectl create cj report-generator --image=busybox:1.36 --schedule="*/5 * * * *" --dry-run=client -o yaml > cj.yaml`
4. vim cj.yaml

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  creationTimestamp: null
  name: report-generator
spec:
  successfulJobsHistoryLimit: 4
  failedJobsHistoryLimit: 2
  concurrencyPolicy: Forbid
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: report-generator
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
            - image: busybox:1.36
              name: report-worker
              command: ["sh", "-c", 'echo "Generating report at $(date)"']
              resources: {}
          restartPolicy: OnFailure
  schedule: "*/5 * * * *"
status: {}
```

5. `kubectl create -f cj.yaml`
6. `kubectl create job test-report-job --from=cronjob/report-generator`
7. `kubectl logs job/test-report-job`
