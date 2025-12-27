# Miscellaneous

```sh
kubectl run hello-minikube      # create a Pod named "hello-minikube" (uses a default image if configured)
kubectl cluster-info            # show cluster API endpoint(s) and core service URLs
kubectl get nodes               # list the cluster nodes
```

# Pods

```sh
kubectl run nginx --image=nginx         # create a Pod named "nginx" using the nginx image
kubectl get pods                        # list Pods in the current namespace
kubectl create -f pod-definition.yaml   # create a Pod from a YAML manifest file
kubectl describe pod <pod_name>         # show detailed information about a Pod (status, labels, image, events, containers)
kubectl delete pod <pod_name>           # delete the specified Pod
kubectl delete pods --all               # delete all pods
kubectl run redis --image=redis --dry-run=client -o yaml                # generate Pod YAML without creating it
kubectl run redis --image=redis --dry-run=client -o yaml > redis.yaml   # save generated Pod YAML to a file

kubectl edit pod <pod_name>             # edit a Pod’s configuration in the editor
    # only these are editable
    # spec.containers[*].image
    # spec.initContainers[*].image
    # spec.activeDeadlineSeconds
    # spec.tolerations
    # spec.terminationGracePeriodSeconds
```

# ReplicationController

```sh
kubectl create -f rc-definition.yaml
kubectl get rc
kubectl get replicationcontroller
kubectl get pods # shows <pod_name>-rc where rc indicates pod was created by ReplicationController
```

# ReplicaSet

```sh
kubectl create -f replicaset-definition.yaml    # create a replciaset
kubectl get replicaset
kubectl get rs
kubectl delete replicaset myapp-replicaset      # delete replicaset (also deletes underlying pods)
kubectl replace -f replicaset-definition.yaml   # to replace or update the replicaset
kubectl get pods # shows <pod_name>-repliacset where replicaset indicates pod was created by ReplicaSet
kubectl describe replicaset new-replica-set
kubectl explain replicaset # tells us the apiVersion to use

# Scaling replicas
kubectl apply -f replicaset-definition.yaml                 # increase replicas in definition file
kubectl scale --replicas=6 -f replicaset-definition.yaml    # imperative command
kubectl scale --replicas=6 replicaset myapp-replicaset      # imperative command
```
