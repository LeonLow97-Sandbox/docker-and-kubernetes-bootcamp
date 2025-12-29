# General Commands

```sh
kubectl cluster-info                    # view cluster info like master and DNS
kubectl get nodes                       # view all nodes in the cluster
kubectl get all                         # view all objects in the current namespace
kubectl get all -A                      # view all objects in all namespaces
kubectl get all --namespace=<namespace> # view all objects in a specific namespace
kubectl api-resources                   # view all available resource types in the cluster (apiVersion, shortname, kind)

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

# Pods

```sh
kubectl create -f pod-definition.yaml   # create a Pod using the definition file
kubectl get pods                        # list Pods in the current namespace
kubectl get pod <pod_name> -o yaml      # get Pod definition in YAML format
kubectl describe pod <pod_name>         # show detailed information about all Pods (status, labels, image, events, containers)
kubectl delete pod <pod_name>           # delete the specified Pod
kubectl delete pod --all                # delete all Pods in the current namespace
kubectl get pods -A                     # list Pods in all namespaces

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
kubectl get deployment                          # list deployments
kubectl get deploy                              # list deployments (short name)
kubectl describe deploy <deployment_name>       # describe deployment details

# Imperative Commands
kubectl create deployment my-dep --image=nginx --replicas=3 # create deployment using imperative command
kubectl create deploy nginx --image=nginx --dry-run=client -o yaml > nginx-deploy.yaml # generate deployment YAML without creating it
kubectl scale deployment my-dep --replicas=5                # scale deployment using imperative command
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
