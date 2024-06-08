# Imperative Commands

- [kubectl Usage Conventions](https://kubernetes.io/docs/reference/kubectl/conventions/)

- While you would be working mostly the declarative way - using definition (`.yaml`) files, imperative commands can help in getting one-time tasks done quickly, as well as generate a definition template easily.
- This would help save a considerable amount of time during the CKAD exam.

## Important Commands

- `--dry-run`:

  - By default, as soon as the command is run, the resource will be created.
  - If you simply want to test you command, use the `--dry-run=client` option. This will not create the resource. Instead, it tells you whether the resource can be created and if your command is right.

- `-o yaml`:

  - This will output the resource definition in YAML format on the screen.

- Use the above 2 in combination along with Linux output redirection to generate a resource definition file quickly, that tou can then modify and create resources as required, instead of creating the files from scratch.
  - `kubectl run nginx --image=nginx --dry-run=client -o yaml > nginx-pod.yaml`

## POD

```sh
## Create an NGINX Pod
kubectl run nginx --image=nginx

## Generate Pod Manifest YAML file (-o yaml). If don't want to create it, add --dry-run
kubectl run nginx --image=nginx --dry-run=client -o yaml

## Create redis pod with labels
kubectl run redis --image=redis:alpine --labels="tier=db"
kubectl run redis --image=redis:alpine --dry-run=client -o yaml > redis-pod.yaml

## Create a new pod called custom-nginx using the nginx image and run it on container port 8080
kubectl run custom-nginx --image nginx --port=8080
```

## Deployment

```sh
## Create a deployment
kubectl create deployment --image=nginx nginx

## Generate Deployment YAML file (-o yaml). Don't create it (--dry-run)
kubectl create deployment --image=nginx nginx --dry-run -o yaml

## Generate Deployment with 4 Replicas
kubectl create deployment nginx --image=nginx --replicas=4

## Scale deployment using the `kubectl scale` command
kubectl scale deployment nginx --replicas=4

## Another way to do this is to save the YAML definition to a file and modify
## You can then update the YAML file with the replicas or any other field before creating the deployment
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yml
```

## Service

- Use `kubectl expose` for exposing target ports and adding pod's labels as selectors
- Use `kubectl create` for creating service but cannot specify pod's labels as selectors

```sh
## Create a Service named `redis-service` of type ClusterIP to expose pod redis on port 6379
## This will automatically use the pod's labels as selectors
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml

## Expose the Pod as a Service, creating a service of type ClusterIP that targets port 80
kubectl expose pod httpd --port=80 --target-port=80 --name=httpd --type=ClusterIP

## Will not use the pod's labels as selectors. Instead it will assume selectors as `app=redis`.
## Cannot pass in selectors as an option. So it does not work well if your pod has a different label set.
## So generate the file and modify the selectors before creating the service
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml

## Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:
## This will automatically use the pod's labels as selectors but you cannot specify the Node Port.
## Have to generate a definition file and then add the node port in manually before creating the service with the pod
kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml

## OR
## will not use the pod's labels as selectors
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

## Create a Pod and a Service (ClusterIP) at the same time
## Automatically add pod's labels as service selectors
kubectl run httpd --image=httpd:alpine --port=80 --expose=true
```

## Namespaces

```sh
## Create a namespace
kubectl create namespace dev

## Create a new deployment called redis-deploy in the dev-ns namespace with the redis image. It should have 2 replicas.
kubectl create deployment redis-deploy --image=redis --replicas=2 --namespace=dev-ns
kubectl create deployment redis-deploy --image=redis --replicas=2 -n=dev-ns
kubectl create deployment redis-deploy --image=redis --replicas 2 -n dev-ns
```
