# General Commands

```sh
kubectl cluster-info                    # view cluster info like master and DNS
kubectl get nodes                       # view all nodes in the cluster
kubectl get all                         # view all objects in the current namespace
kubectl get all -A                      # view all objects in all namespaces
kubectl get all --namespace=<namespace> # view all objects in a specific namespace
kubectl api-resources                   # view all available resource types in the cluster (apiVersion, shortname, kind)
kubectl logs <pod> -c <container>       # view specific container in a pod with multiple containers
kubectl logs <pod>                      # view container logs where pod only has 1 container
kubectl get pods --no-headers | wc -l   # get count of the number pods (exclude headers)

# Imperative Commands
kubectl create <resource> --help        # view help for creating a specific resource
    kubectl create deployment --help    # view help for creating a deployment

kubectl explain <resource> --help       # view help for explaining a specific resource
    kubectl explain pods                # view details about Pod resource
    kubectl explain pods.spec           # view details about Pod spec
    kubectl explain pods --recursive    # view all fields of Pod resource
```

# Imperative Commands

```sh
# `--dry-run=client`: Don’t create the resource — just validate the command and print what would be created.
# `-o yaml`: Print the resource definition as YAML (great for saving into a file)
kubectl <command> ... --dry-run=client -o yaml > file.yaml  # generate resource YAML without creating it
    kubectl create deployment myapp --image=myapp-image --dry-run=client -o yaml                # generate Deployment YAML without creating it
    kubectl create deployment myapp --image=myapp-image --dry-run=client -o yaml > file.yaml    # save generated Deployment YAML to a file
kubectl apply -f file.yaml                                  # create or update resource from the YAML file

kubectl get <resource> <name> -o yaml      # view/editable YAML
kubectl get <resource> <name> -o json      # JSON form (less common in CKAD)
kubectl get <resource> -o wide             # extra columns (node/IP/etc)
kubectl get <resource> -o name             # just resource names (great for scripting)
```

# Node

```sh
kubectl get nodes
kubectl get no

kubectl label node node01 color=blue    # apply labels to nodes
```

# Pods

```sh
kubectl create -f pod-definition.yaml       # create a Pod using the definition file
kubectl get pods                            # list Pods in the current namespace
kubectl get pod <pod_name> -o yaml          # get Pod definition in YAML format
kubectl get pods --watch
kubectl describe pod <pod_name>             # show detailed information about all Pods (status, labels, image, events, containers)
kubectl delete pod <pod_name>               # delete the specified Pod
kubectl delete pod --all                    # delete all Pods in the current namespace
kubectl get pods -A                         # list Pods in all namespaces
kubectl get pod <pod> -o yaml > pod.yaml    # get pod yaml

kubectl get pods --selector <key>=<value>   # get pod with label <key>=<value>
kubectl get all --selector <key>=<value>    # get all objects with label <key>=<value>
kubectl get pods --selector key1=value1,key2=value2,key3=value3 # get pods with multiple labels
kubectl get pods --show-labels              # retrieve all pods and show all their labels

# Imperative Commands
kubectl run <pod_name> --help               # create a Pod using imperative command
    kubectl run myapp --image=myapp-image   # create a Pod named "myapp" using the specified image
    kubectl run myapp --image=myapp-image --dry-run=client -o yaml                  # generate Pod YAML without creating it
    kubectl run myapp --image=myapp-image --dry-run=client -o yaml > myapp-pod.yaml # save generated Pod YAML to a file
    kubectl run nginx --image=nginx -- <arg1> <arg2> # start nginx pod with custom arguments

# Editing a Pod
kubectl edit pod <pod_name>             # edit the Pod definition in your default text editor
    # only these are editable
    # spec.containers[*].image
    # spec.initContainers[*].image
    # spec.activeDeadlineSeconds
    # spec.tolerations
    # spec.terminationGracePeriodSeconds
# For editting pods, you cannot edit things like environment variables, service accounts, resource limits of a running pod. If you really want to edit, there are 2 ways:
# 1. Using the temporary file created
kubectl edit pod webapp
# error: pods "webapp" is invalid
# A copy of your changes has been stored to "/tmp/kubectl-edit-ccvrq.yaml"
# error: Edit cancelled, no valid changes were saved.
kubectl replace --force -f /tmp/kubectl-edit-ccvrq.yaml
# deletes the pod and recreates a new pod with the updated manifest file

# 2. Extract pod definition in YAML format to a file
kubectl get pod webapp -o yaml > new-pod.yaml
vi new-pod.yaml
kubectl delete pod webapp       # delete existing pod
kubectl create -f new-pod.yaml  # create new pod with edited file

# view app logs
k exec webapp -- cat /log/app.log
```

# ReplicationController

```sh
kubectl create -f rc-definition.yaml    # create a replication controller
kubectl get replicationcontroller       # list replication controllers
kubectl get rc                          # list replication controllers (short name)
kubectl get pods                        # shows <pod_name>-rc where rc indicates pod was created by ReplicationController
```

# ReplicaSet

```sh
kubectl create -f replicaset-definition.yaml    # create a replicaset
kubectl replace -f replicaset-definition.yaml   # to replace or update the replicaset
kubectl apply -f replicaset-definition.yaml     # to create or update the replicaset
kubectl get replicaset                          # list replicasets
kubectl get rs                                  # list replicasets (short name)
kubectl delete rs replicaset_name               # delete replicaset (also deletes underlying pods)
kubectl get pods️                                # list pods (shows <pod_name>-repliacset where replicaset indicates pod was created by ReplicaSet)
kubectl describe rs replicaset_name             # describe replicaset details

# Imperative Commands
kubectl scale --replicas=6 -f replicaset-definition.yaml    # scale using definition file
kubectl scale --replicas=6 replicaset myapp-replicaset      # scale using imperative command
```

# Deployment

```sh
kubectl create -f deployment-definition.yaml    # create a deployment
kubectl apply -f deployment.definition.yaml     # update a deployment
kubectl get deployment                          # list deployments
kubectl get deploy                              # list deployments (short name)
kubectl describe deploy <deployment_name>       # describe deployment details

# Imperative Commands
kubectl create deployment my-dep --image=nginx --replicas=3 # create deployment using imperative command
kubectl create deploy nginx --image=nginx --dry-run=client -o yaml > nginx-deploy.yaml # generate deployment YAML without creating it
kubectl scale deployment my-dep --replicas=5                # scale deployment using imperative command
kubectl set image deployment/<deployment-name> \            # update image of a deployment
    nginx=nginx:1.9.1

# Rollout commands
kubectl rollout status deployment/<deployment-name>     # view the status of the rollout deployment
kubectl rollout history deployment/<deployment-name>    # view revisions of rollout deployment
    kubectl rollout history deployment/<deployment-name> --revision=1 # view status of a specific revision
kubectl rollout undo deployment/<deployment-name>       # undo a deployment and rollback to previous replicaset version

# Expose a deployment via NodePort service
# NodePort service name = "webapp-svc", if `--type` not specified, it will be ClusterIP by default
kubectl expose deployment webapp --name=webapp-svc --type=NodePort --port=80 --target-port=8080 -n dev
# If you want to configure "nodePort"
kubectl expose deployment webapp --name=webapp-svc --type=NodePort --port=80 --target-port=8080 -n dev --dry-run=client -o yaml
```

# Namespace

```sh
kubectl create -f namespace-dev.yaml                    # create namespace using definition file
kubectl create -f pod-definition.yaml --namespace=dev   # create pod in dev namespace
kubectl get namespaces  # retrieve all namespaces
kubectl get ns          # retrieve all namespaces (short form)

kubectl get pods
    kubectl get pods --namespace=dev    # retrieve pods in dev namespace
    kubectl get pods -n dev             # retrieve pods in dev namespace (short form)
    kubectl get pods --all-namespaces   # retrieve pods in all namespaces
    kubectl get pods -A                 # retrieve pods in all namespaces (short form)

kubectl create -f compute-quota.yaml        # create resource quota in the specified namespace
kubectl get resourcequota --namespace=dev   # get resource quota in dev namespace

# Imperative Commands
kubectl create namespace dev                # create namespace
kubectl run redis --image=redis -n=finance  # create pod in finance namespace

# Switch namespace context
# By default, you are in `default` namespace.
kubectl config set-context --current --namespace=dev    # switch to dev namespace
kubectl config set-context kind-kind --namespace=dev    # switch to dev namespace for kind cluster
kubectl config set-context $(kubectl config current-context) --namespace=dev    # switch to dev namespace for current context
kubectl config get-contexts                             # view all contexts with their namespaces
kubectl config current-context                          # view current context
```

# Service

```sh
kubectl create -f service-definition.yaml
kubectl get service
kubectl get svc
kubectl describe svc <service_name> # to view information on labels, port, target port, ip (IP/IPs - ClusterIP, Endpoints - destination address of the Pod)

# Imperative Commands
kubectl create svc --help               # view help for creating services
    kubectl create svc clusterip --help # view help for creating clusterip service
    kubectl create svc clusterip mysvc --tcp=6379:6379

kubectl run httpd --image=httpd:alpine --port=80 --expose true  # create a pod and expose it as a service (ClusterIP type)

kubectl expose pod redis --port=6379 --name=redis-service       # expose a pod as a service (ClusterIP type), pod must exist before exposing
    # ClusterIP (uses pod labels as selectors automatically)
    kubectl expose pod redis --port=6379 --name=redis-service --dry-run=client -o yaml > redis-svc.yaml
    # NodePort (generate then edit nodePort if needed), edit redis-svc.yaml: spec.ports[0].nodePort: 30080
    kubectl expose pod redis --port=80 --name=redis-service --type=NodePort --dry-run=client -o yaml > redis-svc.yaml
```

# ConfigMap

```sh
kubectl create -f configmap.yaml
kubectl get configmap
kubectl get cm
kubectl describe cm <config-name>

# Imperative Command
kubectl create configmap <config-name> \
    --from-literal=<key>=<value>
kubectl create configmap <config-name> \
    --from-file=<path-to-file>
```

# Secret

```sh
kubectl get secrets
kubectl describe secrets <secret-name>      # view secrets (in bytes, hides the actual values)
kubectl get secret <secret-name> -o yaml    # view secrets (in base64 encoded form)

echo -n 'decoded' | base64
echo -n 'encoded' | base64 --decode

# Imperative (creates base64 secrets)
kubectl create secret generic <secret-name> \
  --from-literal=<key>=<value>
kubectl create secret generic <secret-name> \
  --from-file=<path-to-file>
```

# Kubernetes Security

```sh
kubectl exec ubuntu-sleeper -- whoami # check the user executing the process
```

# Resource Limits, Requests and Quotas

```sh
# ResourceQuota
kubectl create -f ./resource-quota.yaml --namespace=myspace # resource quota is namespace-level object
```

# Service Account

```sh
kubectl create serviceaccount <name>
kubectl get serviceaccount
kubectl get sa
kubectl describe serviceaccount <name> # creates token for application to authenticate with k8s , token is stored in a k8s Secret object
    kubectl describe secret <secret_name>
    # curl https://<base_url>/api --header "Authorization: Bearer <token>"
kubectl describe pod <pod_name>
    # there will be a default token mounted as a volume to the pod
    # this token belongs to the default service account of k8s mounted on /var/run/secrets/kubernetes.io/serviceaccount
    kubectl exec -it <pod_name> -- ls /var/run/secrets/kubernetes.io/serviceaccount
    # this token is for the pod to authenticate with the kubernetes api

kubectl create token <serviceaccount_name> # Since v1.24, tokens are no longer created automatically with the service account. This command is used to request a time-limited security token for a specific Kubernetes service account, decode the token in jwt.io. This command uses the TokenRequestAPI
```

# Taints and Tolerations

```sh
kubectl taint nodes <node_name> key=value:taint-effect # taint-effect is what happens to pods that do not tolerate the taint --> NoSchedule, PreferNoSchedule, NoExecute
    kubectl taint nodes node1 app=myapp:NoSchedule
kubectl taint node <node_name> key=value:NoSchedule- # to remove taint, specify a `-` at the end.

kubectl describe node kubemaster | grep Taint  # view taint on Master node
```

# Logs and Monitoring

```sh
kubectl logs <pod>      # View logs for a specific pod with 1 container
kubectl logs -f <pod>   # Stream logs for a specific pod with 1 container

kubectl logs -f <pod> <container_name> # view logs for a specific pod and container

## Metrics
kubectl top node        # Shows the CPU and memory consumption of each node in the cluster (e.g., 8% CPU usage or 166 milli-cores)
kubectl top pod         # Shows the CPU and memory consumption of individual pods.
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml # to deploy latest metrics server to kubernetes cluster
```

# Job and CronJob

```sh
kubectl get jobs
kubectl delete job <job-name>
kubectl create job <job-name> --image=<image-name> --dry-run=client -o yaml > job.yaml

kubectl get cronjobs
kubectl create cronjob <cronjob-name> --image <image-name> --schedule="30 21 * * *" --dry-run=client -o yaml > cronjob.yaml
```

# Network Policy

```sh
kubectl get networkpolicies
kubectl get netpol

kubectl describe pod <podname> | grep -i labels # grep the label of the pod
```

# Ingress

```sh
# Ingress Resource
k get ing
k get ingress

# Ingress Controller
kubectl get deploy ingress-nginx-controller -n ingress-nginx -o yaml

# Finding Unmatched Path on INGRESS
# 1. Check Ingress Resource
kubectl describe ing -n app-space
# Look for "Default backend:"
# - If `Default backend: <service_name>:80`, stop here. Request is forwarded to this service.
# - If `Default backend: <default>`, Ingress Resource has passed the responsibility to Ingress Controller.

# 2. Check Ingress Controller
kubectl get deploy <deployment_name> -n ingress-nginx -o yaml | grep -i "default-backend-service"
# - If `--default-backend-service=namespace/service-name` found, controller routes traffic to that specific cluster sevice.
    # - E.g., `--default-backend-service=app-space/default-backend-service`
# - If `--default-backend-service` not found, returns 404 Not Found to client.

# Create Ingress Resource (Imperative command)
kubectl create ingress <name> -n <namespace> --rule="/pay=pay-service:8282"
# But need to change rewrite-target annotation as this forwards from `/<ingress-svc>:<ingress-port>/pay` to `http://<svc_name>:<port>/pay` when it should be `http://<svc_name>:<port>/` (after rewrite)

# Multiple rules
kubectl create ingress <name> -n <namespace> --rule="/pay=pay-service:8282" --rule="/wear=wear-service:8080"
```

## Ingress Resource Manifest

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: critical-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: / # the path you want to override
spec:
  ingressClassName: nginx # ingress controller name (no need namespace, it is cluster-scoped)
  rules:
    - http: # ⚠️ No host defined here, "Catch-All" rule displayed as "*" under Host column when kubectl describe
        paths:
          - path: /pay
            pathType: Prefix
            backend:
              service:
                name: pay-service # k get svc
                port:
                  number: 8282

    - host: store-my-company.com # bound to this exact domain, best for Production environments
      http:
        paths:
          - path: /wear
            pathType: prefix
            backend:
              service:
                name: wear-service
                port:
                  number: 8080
```

```yaml
# Redirect all HTTP requests to HTTPS via Ingress resource
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
```

# Persistent Volume

## Create PV

- Can only use declarative method

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /pv/log
    type: Directory
  persistentVolumeReclaimPolicy: Retain
```

## Create PVC

- Can only use declarative method

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-log-1
spec:
  resources:
    requests:
      storage: 50Mi
  accessModes:
    - ReadWriteOnce
```

# Storage Class

```sh
# Verify StorageClass does not support dynamic volume provisioning
k describe sc local-storage | grep -i provisioner
# Output:
# Provisioner:           kubernetes.io/no-provisioner
# "no-provisioner" means it does not support dynamic volume provisioning
```
