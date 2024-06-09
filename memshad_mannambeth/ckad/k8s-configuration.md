# k8s Configuration

## Creating own image

- Each layer in the dockerfile has a `SIZE`, run `docker history <image_name>` to see the SIZE
- `docker build Dockerfile -t leonlow/my-custom-app`
- `docker push leonlow/my-custom-app`: push to Docker registry

```dockerfile
## start from a base OS or another image
FROM ubuntu

## install dependencies using apt
RUN apt-get update
RUN apt-get install python

## install python dependencies using pip
RUN pip install flask
RUN pip install flask-mysql

## copy source code to /opt folder
COPY . /opt/source-code

## run the web server using `flask` command
ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

## Commands and Arguments in Docker

- Using `CMD`

```yaml
## override the default CMD of ubuntu image CMD["bash"] which causes the container to exit
FROM ubuntu

CMD sleep 5

## using docker command
docker run ubuntu-sleeper sleep 10
```

- Using `ENTRYPOINT`, command line parameters get appended

```yaml
FROM ubuntu

ENTRYPOINT ["sleep"]

## using docker command ("sleep 10")
docker run ubuntu-sleeper 10
```

- Using both `ENTRYPOINT` and `CMD`
  - If command line argument not provided, it uses the default parameter in CMD
  - `docker run ubuntu-sleeper`: sleep for 5 seconds
  - `docker run ubuntu-sleeper 10` sleep for 10 seconds
  - `docker run --entrypoint sleep2.0 ubuntu-sleeper 10` using a new entry point "sleep2.0 10"

```yaml
FROM ubuntu

ENTRYPOINT ["sleep"]

CMD ["5"]
```

## Commands and Arguments in Kubernetes

- Creating a Pod with the Commands
- Example: `docker run --name ubuntu-sleeper ubuntu-sleeper`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      command: ['sleep2.0'] ## override the ENTRYPOINT in docker image --> ENTRYPOINT ["sleep"]
      args: ['10'] ## override the CMD in docker image --> CMD ["5"]
```

- Can also do this

```yaml
command:
  - 'sleep'
  - '1200'
```

## Kubernetes Environment Variables

- **Plain Key Value**: Adding environment variables in Pod definition file

```yaml
spec:
  containers:
    - name: simple-webapp-color
      image: simple-webapp-color
      ports:
        - containerPort: 8080
      env:
        - name: APP_COLOR
          value: pink
```

- **ConfigMap**

```yaml
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
```

- **Secrets**

```yaml
env:
  - name: APP_COLOR
    valueFrom:
      secretKeyRef:
```

## Kubernetes ConfigMaps

- Instead of putting the environment variables key-value in the pod definition file (makes the file too large), we can put it in ConfigMap definition file.
- When the Pod is created, ConfigMap will inject key-value pairs into the environment variables of the Pod for the application hosted as a container in the Pod.

---

### Create `ConfigMap`

- Imperative

```sh
kubectl create configmap
  <config_name> --from-literal=<key>=<value>

kubectl create configmap \
  app_config --from-literal=APP_ENV=Prod \
             --from-literal=APP_NAME=my-app

## by file
kubectl create configmap
  <config_name> --from-file=<path_to_file>

kubectl create configmap \
  app_config --from-file=app_config.properties
```

- Declarative
  - `kubectl create -f config-map.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app_config
data:
  APP_ENV: Prod
  APP_NAME=my-app
```

- ConfigMap in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
  labels:
    name: my-app
spec:
  containers:
    - name: my-app
      image: my-app
      ports:
        - containerPort: 8080
      envFrom:
        - configMapRef:
          name: app_config
```

- Single Env

```yaml
env:
  - name: APP_ENV
    valueFrom:
      configMapKeyRef:
        name: app_config
        key: APP_ENV
```

- Volumes

```yaml
volumes:
  - name: app-config-volume
    configMap:
      name: app_config
```

- Other Commands

```sh
## View ConfigMap
kubectl get configmaps

## Describe ConfigMap
kubectl describe configmaps
```

---

## Kubernetes Secrets

- Create the secret then inject it into the Pod.

---

### Create Secret

- Imperative Method

```sh
kubectl create secret generic
  <secret_name> --from-literal=<key>=<value>

kubectl create secret generic \
  app-secret --from-literal=DB_HOST=mysql \
             --from-literal=DB_USER=root \
             --from-literal=DB_PASSWORD=password

## reading secrets from file
kubectl create secret generic
  <secret_name> --from-file=<path_to_file>

kubectl create secret generic \
  app-secret --from-file=app_secret.properties
```

- Declarative Approach
  - `kubectl create -f secret-data.yaml`
- Encode Secrets because we don't want to show them in plain text in YAML file
  ```
  echo -n 'mysql' | base64
  bXlzcWw=
  echo -n 'root' | base64
  cm9vdA==
  echo -n 'password' | base64
  cGFzc3dvcmQ=
  ```
- Decode Secrets
  ```
  echo -n 'bXlzcWw=' | base64 --decode
  mysql
  ```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: bXlzcWw=
  DB_User: cm9vdA==
  DB_Password: cGFzc3dvcmQ=
```

```sh
kubectl get secrets
kubectl describe secrets

kubectl get secret app-secret -o yaml
```

### Injecting K8s secrets into Pods

```yaml
# env
envFrom:
  - secretRef
      name: app-config

# Single env
env:
  - name: DB_Password
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: DB_Password

# Volume
volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret
```

### Note on Secrets

- Secrets are not Encrypted. Only encoded.
  - Do not check-in Secret objects to SCM along with code.
- Secrets are not encrypted in ETCD.
  - Enable encryption at rest
  - `EncryptionConfiguration` k8s object to encrypt secrets.
- Anyone able to create pods/deployments in the same namespace can access the secrets.
  - Configure least-privilege access to Secrets - RBAC (role-based access control)
- Consider third-party secrets store providers
  - AWS Provider, Azure Provider, GCP Provider, Vault Provider

### How Kubernetes Handles Secrets

- A secret is only sent to a node if a pod on that node requires it.
- Kubelet stores the secret into a tmpfs so that the secret is not written to disk storage
- Once the Pod the depends on the secret is deleted, kubelet will delete its local copy of the secret data as well.

---

## Encrypting Secret Data at Rest

- [Encrypting Secret Data at Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)

1. Create a Secret Object

```sh
kubectl create secret generic my-secret --from-literal=key1=supersecret

kubectl get secret my-secret -o yaml
kubectl describe secret my-secret

echo "<secret>" | base64 --decode
```

2. Install etcdctl

- `apt-get install etcd-client`

3. Check if `etcd-controlplane` is in system pods namespace

- **System Components**: The output will include various Kubernetes system components such as etcd, kube-apiserver, kube-scheduler, kube-controller-manager, coredns, and others.
- `kubectl get pods -n kube-system`

4. Reading the secret out of etcd

```sh
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/my-secret | hexdump -C   ## secret name here
```

- Data is stored in etcd in an unencrypted format currently. Thus, we need encryption in etcd.

5. Check if `kube-api` server has the `--encryption-provider-config`

```sh
# 2 ways to check
    # 1.
ps -aux | grep kube-api | grep "encryption-provider-config"

    # 2.
ls /etc/kubernetes/manifests/
cat /etc/kubernetes/manifests/kube-apiserver.yaml
```

6. If no `--encryption-provider-config` option, encryption at rest has not been enabled

- Encryption happens at `identity` in the YAML file. If none provided, then no encryption.
- We need a secret key to encrypt the k8s secret
  - `head -c 32 /dev/urandom | base64`: generates a 32-byte random key and base64 encode it. (MacOS and Linux)
    ```
    ~ head -c 32 /dev/urandom | base64
    mEg+nxrHi/bO4Be6zfNT3HBccNRyndPQinnraJVozVY=
    ```
- The YAML file created below will be named as `enc.yaml`

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets ## specifying that we want to encrypt k8s secrets
    providers:
      - aesbc:
          keys:
            - name: key1
              secret: mEg+nxrHi/bO4Be6zfNT3HBccNRyndPQinnraJVozVY=
      - identity: {}
```

7. Mount the new encryption config file to the `kube-apiserver` static pod

- Save the new encryption config file to `/etc/kubernetes/enc/enc.yaml` on the control-plane node.
  - `mkdir /etc/kubernetes/enc`
  - `mv enc.yaml`

8. Edit the manifest for the kube-apiserver static pod: `/etc/kubernetes/manifests/kube-apiserver.yaml` so that it is similar to:

- `vi /etc/kubernetes/manifests/kube-apiserver.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 10.20.30.40:443
  creationTimestamp: null
  labels:
    app.kubernetes.io/component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    ...
    - --encryption-provider-config=/etc/kubernetes/enc/enc.yaml  # add this line
    # directory in the Pod
    volumeMounts:
    ...
    - name: enc                           # add this line
      mountPath: /etc/kubernetes/enc      # add this line
      readOnly: true                      # add this line
    ...
  # location of file in local directory
  volumes:
  ...
  - name: enc                             # add this line
    hostPath:                             # add this line
      path: /etc/kubernetes/enc           # add this line
      type: DirectoryOrCreate             # add this line
  ...
```

9. Restart the api server

- Run `crictl pods` to check the state of `kube-apiserver-controlplane`
- Run `ps -aux | grep kube-api | grep "encryption-provider-config"` to check if the encryption option was added
- Test creating a new secret `kubectl create secret generic my-secret-2 --from-literal=key2=topsecret`
- Run and should see encrypted secret (not plaintext)

  ```
  ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/my-secret-2 | hexdump -C
  ```

- Previously created secrets will not be encrypted. To ensure that all secrets are encrypted, run `kubectl get secrets --all-namespaces -o json | kubectl replace -f -`
