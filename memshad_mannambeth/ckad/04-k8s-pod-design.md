# POD Design

- Labels, Selectors and Annotations
- Rolling Updates & Rollbacks in Deployments
- Jobs and CronJobs

## Labels, Selectors and Annotations

- **Labels**: Key-value pairs attached to objects (like Pods) to organize and select subsets of resources based on common attributes.
- **Selectors**: Queries used to identify and group objects (such as Pods) based on labels, enabling targeted operations or services.

```yaml
# pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp
  labels:
    app: App1
    function: frontend
spec:
  containers:
    - name: simple-webapp
      image: simple-webapp
      ports:
        - containerPort: 8080
```

```yaml
# replicaset-definition.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: simple-webapp
  ## replicaset labels, when another service is looking for replicaset
  labels:
    app: App1
    function: frontend
spec:
  replicas: 3
  ## selectors on ReplicaSet, this will be used to look for similar pod labels
  selector:
    matchLabels:
      app: App1
  template:
    metadata:
      ## pod labels
      labels:
        app: App1
        function: frontend
    spec:
      containers:
        - name: simple-webapp
          image: simple-webapp
```

```sh
## get pods with labels
kubectl get pods --selector app=App1

## get pods that have multiple labels
kubectl get pods --selector env=prod,bu=finance,tier=frontend

## get all objects with specified labels
kubectl get all --selector env=prod

## get count of number of pods with label
kubectl get pods --selector env=dev --no-headers | wc -l
```

- **Annotations**: Additional metadata attached to Kubernetes objects (e.g., Pods or Services) for documentation, monitoring, or management purposes, distinct from labels used for identification and grouping.

```yaml
# replicaset-definition.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: simple-webapp
  labels:
    app: App1
    function: frontend
  annotations:
    buildversion: 1.34
```

## Rolling Updates & Rollbacks in Deployments

- Rollout and Versioning

  - When Deployment is first created, it triggers a rollout.
  - A new rollout creates a new Revision, e.g., Revision 1
  - When a new version in the container is deployed, a new rollout and hence a new Revision is created, e.g., Revision 2
  - This helps us to keep track of the versions of our deployment and rollback to previous versions if necessary.
  - `kubectl rollout status deployment/myapp-deployment`
  - `kubectl rollout history deployment/myapp-deployment` shows revisions and history of deployment

- Deployment Strategy

  - `Recreate`: destroy all pods at once and create all new pods. Application will be down for a while.
  - `RollingUpdate`: Default deployment strategy. Take down the older version and bring up newer version one by one. Application won't go down and update is seamless.

- Deployment RollingUpdate under the hood
  - replicaset-1 contains the older pods to be removed
  - Deployment creates a new replicaset-2.
  - Older Pods are removed from replicaset-1 and new pods are created in replicaset-2 1 by 1. Seamless Deployment.

```yaml
## deployment-definition.yaml
## older version
spec:
  containers:
  - name: nginx-container
    image: nginx

## new version
spec:
  containers:
  - name: nginx-container
    image: nginx:1.7.1
```

```yaml
## adding Recreate strategy (declarative)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: default
spec:
  replicas: 4
  selector:
    matchLabels:
      name: webapp
  strategy:
    type: Recreate

## for RollingUpdate
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
```

```sh
## declarative approach (update deployment)
kubectl apply -f deployment-definition.yaml

## imperative approach (updating image version)
kubectl set image deployment/myapp-deployment \
            nginx-container=nginx:1.9.1

## view the deployment events
kubectl describe deployment myapp-deployment

## status
kubectl rollout status deployment/myapp-deployment
kubectl rollout history deployment/myapp-deployment

## check status of each revision individually
kubectl rollout history deployment nginx --revision=1

## to include "change-cause" field in the rollout history output
## use the `--record` flag to save the command used to create/update a Deployment against the revision number
kubectl set image deployment nginx nginx=nginx:1.17 --record
kubectl edit deployments nginx --record ## when editing Deployment

## rollback
kubectl rollout undo deployment/myapp-deployment

## rollback to specified revision
kubectl rollout undo deployment nginx --to-revision=1

## view image used to create deployment
kubectl describe deployments nginx | grep -i image:
```

- RollingUpdateStrategy
  - `kubectl describe deploy <deployment_name>`: look for RollingUpdateStrategy section
  - `25% max unavailable, 25% max surge`: will take down 25% of the pods before bring new pods up, 4 replicas means 25% is 1 pod

## Deployment Strategy - Blue / Green

- Blue/Green deployment involves running 2 identical production environments, Blue and Green,
  - where Blue is the current live environment and Green is the new version.
- All Traffic is switched to Green after thorough testing, enabling a quick rollout to Blue if issues arise.
- Procedure:
  1. Set labels on Blue deployment, e.g., version: v1
  2. Set selector on Service object, e.g., version: v1
  3. Once the Green deployment is ready, set labels on Green deployment to e.g., version: v2
  4. Edit the selector on Service object to version: v2
  5. The service the routes traffic to Green deployment

## Deployment Strategy = Canary

- Canary deployment releases the new version incrementally to a small subset of users, allowing for monitoring and verification before a full rollout.
- This approach minimizes risk by gradually increasing the user base exposed to the new version, enabling detection and mitigation of potential issues early.
- Procedure:
  1. Set labels on primary deployment, e.g., version: v1
  2. Set selector on Service object, e.g., version: v1
  3. Set labels on canary deployment, e.g., version: v2
  4. The service needs to:
  - Route traffic to both versions
  - Route a small percentage of traffic to Version 2
  5. Set an additional label of e.g., app:front-end to both primary deployment and canary deployment. Also, change selector to app:frontend on Service object
  - However, now traffic is routed equally (50 - 50) to both Deployment
  - Need to reduce traffic to canary deployment
  6. Reduce number of Pods in Canary deployment to 1 (`replicas: 1`)
  - Either run `kubectl edit deployment ...` or `kubectl scale deployment <deployment_name> --replicas=1`
  7. Once tested, we can increase replicas of Canary deployment to 5 replicas and scale down replicas of Primary deployment to 0 replicas.

# Kubernetes Jobs and CronJobs

## Jobs

- Kubernetes Jobs are used to create 1 or more Pods to run to completion, performing a specific task such as data processing or batch jobs, and then terminate.
- They **ensure that a specified number of pods successfully complete their tasks**, automatically restarting failed pods until the job is finished.
- When running `docker run ubuntu expr 3 + 2`, it returns `5` and the container exits with status 0 as it was completed successfully.
- In Kubernetes, `kubectl create -f pod-definition.yaml`, when the computation is completed, the container in the Pod exits and will be restarted and recreated again until a threshold is reached.
  - This is because by default it has a `restartPolicy: Always`
  - To prevent restarting the container once the job is finished, `restartPolicy: Never` or `restartPolicy: OnFailure`
- Pods are created sequentially by default when specified `completions` in Jobs definition file. To create pods in parallel, add `parallelism` in Jobs definition file.

```yaml
# pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
  name: math-pod
spec:
  containers:
    - name: math-add
      image: ubuntu
      command: ['expr', '3', '+', '2']
  restartPolicy: Never
```

```yaml
# job-definition.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: math-add-job
spec:
  completions: 3 # ensure that 3 Pods created and complete their Job
  parallelism: 3 # create 3 Pods in parallel
  backoffLimit: 15 # Number of times to attempt creating a successful pod that completes the job, This is so the job does not quit before it succeeds.
  template:
    ## moved from pod definition file
    spec:
      containers:
        - name: math-add
          image: ubuntu
          command: ['expr', '3', '+', '2']
      restartPolicy: Never
```

```sh
kubectl create -f job-definition.yaml

kubectl get jobs
kubectl delete job

kubectl get pods ## check if kubernetes restarted the pod

kubectl logs <pod_name> ## to see the output from the Pod/Job

kubectl create job <job_name> --image=<image_name> --dry-run=client -o yaml  > <job_name>.yaml
```

## CronJobs

- Kubernetes CronJobs are a type of Kubernetes Job that **run on a scheduled basis**, similar to cron jobs in Unix-like systems, allowing for periodic and recurring tasks.
- They automatically create Kubernetes Jobs at specified times and intervals, enabling tasks like regular backups, report generation or cleanup operations.

```yaml
## cron-job-definition.yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
spec:
  schedule: '*/1 * * * *'
  jobTemplate:
    ## spec section from Job definition file (it contains both the Job spec and Pod spec)
    spec:
      completions: 3 # ensure that 3 Pods created and complete their Job
      parallelism: 3 # create 3 Pods in parallel
      template:
        ## moved from pod definition file
        spec:
          containers:
            - name: math-add
              image: ubuntu
              command: ['expr', '3', '+', '2']
          restartPolicy: Never
```

```sh
kubectl create -f cron-job-definition.yaml

kubectl get cronjob
```
