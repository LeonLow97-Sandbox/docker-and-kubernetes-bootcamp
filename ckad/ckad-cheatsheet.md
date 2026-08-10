- [CKAD CheatSheet](#ckad-cheatsheet)
- [1. Exam Setup and Speed](#1-exam-setup-and-speed)
  - [Always check Context and Namespace](#always-check-context-and-namespace)
  - [Fast Resource Discovery](#fast-resource-discovery)
  - [Generate, Edit, Apply, Verify](#generate-edit-apply-verify)
- [2. Core `kubectl` Commands](#2-core-kubectl-commands)
  - [Get and Inspect](#get-and-inspect)
  - [Create, Update, Delete](#create-update-delete)
  - [Wait, Verify](#wait-verify)
  - [Logs, Exec, Copy, Port Forward](#logs-exec-copy-port-forward)
  - [JSONPath and Custom Columns](#jsonpath-and-custom-columns)
- [3. Pods](#3-pods)
  - [Imperative Creation](#imperative-creation)
  - [Command vs Args](#command-vs-args)
  - [Environment Variables](#environment-variables)
  - [Requests and Limits](#requests-and-limits)
    - [QoS Classes](#qos-classes)
  - [Pod Editing Limitation](#pod-editing-limitation)
- [4. Labels, Selectors and Annotations](#4-labels-selectors-and-annotations)
  - [Selector Rules](#selector-rules)
- [5. Deployments and ReplicaSets](#5-deployments-and-replicasets)
  - [Common Commands](#common-commands)
  - [Rollout](#rollout)
  - [Pause and Resume](#pause-and-resume)
  - [Strategies](#strategies)
  - [Blue/Green Deployment](#bluegreen-deployment)
  - [Canary Deployment](#canary-deployment)
- [6. DaemonSet](#6-daemonset)
- [7. Jobs and CronJobs](#7-jobs-and-cronjobs)
  - [Jobs](#jobs)
  - [CronJobs](#cronjobs)
- [8. Multi-Container Pods](#8-multi-container-pods)
  - [Init Container](#init-container)
  - [Sidecar Container](#sidecar-container)
    - [Traditional Sidecar](#traditional-sidecar)
    - [Native Sidecar](#native-sidecar)
  - [Ambassador and Adapter](#ambassador-and-adapter)
  - [Debugging Multi-Container Pods](#debugging-multi-container-pods)
- [9. Probes](#9-probes)
  - [HTTP, TCP, Exec, gRPC Probes](#http-tcp-exec-grpc-probes)
  - [Timing Fields](#timing-fields)
  - [StartupProbe for Slow Applications](#startupprobe-for-slow-applications)
  - [Verify Probes](#verify-probes)
- [10. ConfigMaps and Secrets](#10-configmaps-and-secrets)
  - [Create](#create)
  - [Consume as Environment Variables](#consume-as-environment-variables)
  - [Consume as Volume](#consume-as-volume)
  - [Decode](#decode)
- [11. Services and DNS](#11-services-and-dns)
  - [Service commands](#service-commands)
  - [Port Meanings](#port-meanings)
  - [Verify Endpoints](#verify-endpoints)
  - [Cluster DNS](#cluster-dns)
  - [Headless Service](#headless-service)
- [12. Ingress](#12-ingress)
  - [Ingress Resource and Controller](#ingress-resource-and-controller)
  - [TLS](#tls)
  - [Troubleshoot](#troubleshoot)
- [13. NetworkPolicies](#13-networkpolicies)
  - [Default Deny Ingress](#default-deny-ingress)
  - [Allow Ingress from Selected Pods](#allow-ingress-from-selected-pods)
  - [Allow from a Namespace and Pod combination](#allow-from-a-namespace-and-pod-combination)
  - [Egress with DNS Access](#egress-with-dns-access)
- [14. Volumes, PVs and PVCs](#14-volumes-pvs-and-pvcs)
  - [`emptyDir`](#emptydir)
  - [Using PVC in Pod](#using-pvc-in-pod)
  - [PVC](#pvc)
  - [Static PV](#static-pv)
  - [Inspect](#inspect)
- [15. Scheduling](#15-scheduling)
  - [`nodeSelector`](#nodeselector)
  - [`nodeAffinity`](#nodeaffinity)
  - [Pod Affinity and Anti-Affinity](#pod-affinity-and-anti-affinity)
  - [Taints and Tolerations](#taints-and-tolerations)
- [16. SecurityContext and Capabilities](#16-securitycontext-and-capabilities)
  - [Pod and Container Security Context](#pod-and-container-security-context)
  - [Verify Runtime Identity](#verify-runtime-identity)
- [17. ServiceAccounts and RBAC](#17-serviceaccounts-and-rbac)
  - [ServiceAccounts](#serviceaccounts)
  - [Role and RoleBinding](#role-and-rolebinding)
  - [Verbs in Role](#verbs-in-role)
  - [Test Authorization](#test-authorization)
- [18. ResourceQuota and LimitRange](#18-resourcequota-and-limitrange)
  - [ResourceQuota](#resourcequota)
  - [LimitRange](#limitrange)
- [19. Container Images](#19-container-images)
  - [Dockerfile Essentials](#dockerfile-essentials)
  - [Image Settings in Kubernetes](#image-settings-in-kubernetes)
- [20. Helm](#20-helm)
  - [What is a Helm Chart?](#what-is-a-helm-chart)
  - [Repository Management](#repository-management)
  - [Installation](#installation)
  - [Inspecting Releases](#inspecting-releases)
  - [Updates and Deletions](#updates-and-deletions)
  - [Dry Run and Debugging (Crucial for CKAD!)](#dry-run-and-debugging-crucial-for-ckad)
- [21. Kustomize](#21-kustomize)
  - [Basic Structure](#basic-structure)
  - [Overlay Pattern](#overlay-pattern)
  - [Patching Patterns](#patching-patterns)
    - [1. Strategic Merge Patch (Most Common)](#1-strategic-merge-patch-most-common)
    - [2. JSON Patch (RFC 6902)](#2-json-patch-rfc-6902)
- [22. CRDs and Operators](#22-crds-and-operators)
  - [Discover Custom Resources](#discover-custom-resources)
  - [Minimal Custom Resource Instance](#minimal-custom-resource-instance)
- [23. API Deprecations](#23-api-deprecations)
- [24. Monitoring and Debugging](#24-monitoring-and-debugging)
  - [Metrics](#metrics)
  - [General Debugging Flow](#general-debugging-flow)
  - [Pod Status Quick Diagnosis](#pod-status-quick-diagnosis)
  - [Ephemeral Debugging Container](#ephemeral-debugging-container)
  - [Create a Temporary Diagnostic Pod](#create-a-temporary-diagnostic-pod)
  - [Service Troubleshooting](#service-troubleshooting)
- [25. Useful Manifests Snippets](#25-useful-manifests-snippets)
  - [Pod with ConfigMap, Secret, Resources, Probes and Security](#pod-with-configmap-secret-resources-probes-and-security)
  - [Deployment and Service](#deployment-and-service)
- [26. Common CKAD Mistakes](#26-common-ckad-mistakes)
- [27. Final Exam Workflow](#27-final-exam-workflow)
  - [High-value verification commands](#high-value-verification-commands)
- [28. Official References Used for Expansion](#28-official-references-used-for-expansion)

# CKAD CheatSheet

# 1. Exam Setup and Speed

```bash
alias k=kubectl
alias kns='kubectl config set-context --current --namespace'

export do='--dry-run=client -o yaml'
export now='--grace-period=0 --force'    # force delete k8s resources.
# e.g., `k delete pod nginx $now`

cat <<'VIM' >> ~/.vimrc
set tabstop=2
set shiftwidth=2
set expandtab
set number
VIM
```

## Always check Context and Namespace

- A **k8s context** refers to a combination of: **Cluster + User + Namespace**

```bash
k config get-contexts           # # lists all contexts in kubeconfig
k config current-context        # view currently active context
k config use-context <context>  # switch kubectl to a different cluster/context
k config set-context --current --namespace <namespace>  # switch kubectl to a different namespace
k config view --minify | grep namespace: # check current namespace

k get ns
```

## Fast Resource Discovery

```bash
k api-resources
k api-versions          # lists api groups and versions

k explain <resource>    # shows doc and main fields of a resource
k explain pod
k explain pod.spec
k explain pod.spec.containers --recursive   # recursively displays all fields nested under it

k create <resource> --help  # shows all flags and options for creating a resource
k create deployment --help
k create --help         # shows all resources that can be created with imperative command

k run --help            # primarily used to create and run a Pod
```

## Generate, Edit, Apply, Verify

```bash
k <command> ... $do > resource.yaml
k create deployment nginx --image=nginx $do > deploy.yaml

k apply -f resource.yaml    # If already exists, will update it.
k create -f resource.yaml   # If already exists, will throw error.

k get <resource> <name> -o yaml   # view resource in yaml format
k get pod nginx -o yaml

k describe <resource> <name>  # view resource in detail
k describe pod nginx
```

# 2. Core `kubectl` Commands

## Get and Inspect

```bash
k get all
k get all -A            # view all resources in all namespaces

k get po -o wide        # view pods with extra details: IP, node, etc.
k get po --show-labels  # view pods with labels
k get po -l app=nginx   # view pods with specific label
k get po --field-selector=status.phase=Running  # view Pods in Running phase
k get po -w             # watch pods continuously for changes

k get events --sort-by='.metadata.creationTimestamp' # view events sorted by creation time

k describe po <pod>

k get <resource> -o yaml
k get <resource> -o json
k get <resource> -o name # output only resource type/name
```

## Create, Update, Delete

```bash
k create -f file.yaml
k apply -f file.yaml

k replace -f file.yaml  # replace existing resource with new definition, resource must already exist
k replace --force -f file.yaml # delete and recreate resource, resource must already exist

k delete -f file.yaml
k delete po <pod>
k delete po <pod> $now  # delete immediately without graceful termination

k edit deploy <name>    # imperative command, edit live deployment
k patch deploy <name> --type=merge \
-p '{"spec":{"replicas":3}}'  # patch deployment to change replicas to 3

k diff -f file.yaml     # preview differences between manifest and live resource
```

## Wait, Verify

```bash
k wait --for=condition=Ready pod/<pod> --timeout=60s # wait for Pod to be ready, fails if not ready within 60s
k wait --for=condition=Available deploy/<deployment> --timeout=60s # wait for Deployment to be available, fails if not available within 60s

k rollout status deploy/<deploy>
```

## Logs, Exec, Copy, Port Forward

```bash
k logs <pod>                    # view logs of a pod
k logs -f <pod>                 # stream logs of a pod
k logs <pod> -c <container>     # view logs of container in Pod, useful for multi-container pods
k logs <pod> -c <container> --previous # view logs of PREVIOUS container instance, useful for crashed containers
k logs -l app=nginx --tail=50   # view last 50 log lines from Pods matching a label

k exec -it <pod> -- sh                  # open an interactive shell inside a container
k exec -it <pod> -c <container> -- sh   # open an interactive shell inside a specific container in a Pod
k exec <pod> -- cat /path/file          # execute a single command inside a container

k cp local.txt <pod>:/tmp/local.txt     # copy local file -> container
k cp <pod>:/tmp/remote.txt ./remote.txt # copy container file -> local

k port-forward pod/<pod> 8080:80        # forward localhost:8080 -> Pod port 80
k port-forward svc/<service> 8080:80    # forward localhost:8080 -> a Pod selected by Service, port 80
```

## JSONPath and Custom Columns

```bash
# Decode a secret
k get secret db-creds -o jsonpath='{.data.password}' | base64 -d

# Generic sorting pattern
k get po --sort-by=.metadata.creationTimestamp
```

# 3. Pods

## Imperative Creation

```bash
k run nginx --image=nginx
k run nginx --image=nginx $do > pod.yaml
k run nginx --image=nginx --port=80         # container port 80

k run nginx --image=nginx --labels='app=nginx,tier=frontend' # add labels to Pod
k run nginx --image=nginx --env='ENV=prod'  # add environment variable to Pod

# Override the image's command and run: sleep 3600
# `--command` flag means specifying container's command.
# `--` tells kubectl to stop parsing kubectl options, everything after belongs to container
k run sleeper --image=busybox --command -- sleep 3600

# Pod that runs once
# `sh -c` is needed to interpret the shell expression
k run once --image=busybox --restart=Never --command -- sh -c 'echo hello'
k logs once
```

## Command vs Args

- Add commands and arguments to containers.

```yaml
containers:
  - name: app
    image: busybox
    command: ['sh', '-c'] # overrides image ENTRYPOINT
    args: ['echo hello && sleep 3600'] # overrides image CMD
```

## Environment Variables

- Setting **1 key** as environment variable

```yaml
env:
  # Plain Text
  - name: APP_ENV
    value: production
  # From ConfigMap
  - name: DB_HOST
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: DB_HOST
  # From Secret
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: password
```

- Import **every key** from a ConfigMap and Secret.

```yaml
envFrom:
  - configMapRef:
      name: app-config
  - secretRef:
      name: db-secret
```

## Requests and Limits

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web
spec:
  containers:
    - name: web
      image: nginx
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 200m
          memory: 256Mi
```

> `resources` belongs under each container, not directly under `spec`.

### QoS Classes

- **Guaranteed**: Every container has CPU and memory requests equal to limits.
- **Burstable:**: At least 1 request or limit exists, but not all are equal.
- **BestEffort:** No requests or limits.

## Pod Editing Limitation

Most Pod fields are immutable. For major changes:

```bash
k get po web -o yaml > web.yaml
vim web.yaml
k replace --force -f web.yaml
```

> Remove server-generated fields such as `status`, `metadata.uid`, `resourceVersion`, and `creationTimestamp` when needed.

# 4. Labels, Selectors and Annotations

```bash
k label po nginx tier=frontend            # add a label
k label po nginx tier=backend --overwrite # change an existing label
k label po nginx tier-                    # remove a label

k get po -l tier=frontend                 # get pods with specified label
k get po -l 'tier in (frontend,backend)'  # get pods with either labels
k get po -l '!tier'                       # get pods that do not have specified label

k annotate po nginx description='frontend service'  # add annotation
k annotate po nginx description-                    # remove annotation
```

### Selector Rules

- Deployment `spec.selector.matchLabels` **MUST MATCH** Pod template labels.
- Service selector **MUST MATCH** the labels on the target Pods.
- NetworkPolicy `podSelector` selects the Pods to which the policy applies.

```yaml
# Deployment
spec:
  selector:
    matchLabels:
      app: web # Deployment selects Pods with this label
  template:
    metadata:
      labels:
        app: web # <-- Pod label

---
# Service (does not need to match every label on Pod, all selector labels must match though)
spec:
  selector:
    app: web # selects Pods with this label

---
# NetworkPolicy
spec:
  podSelector:
    matchLabels:
      app: web # applies to Pods with this label
```

- Multiple labels and selectors

```yaml
# Pod labels
labels:
  app: web
  tier: frontend
  env: prod # extra is OK

---
# Deployment — subset OK
selector:
  matchLabels:
    app: web

---
# Service — multiple labels = AND
selector:
  app: web
  tier: frontend

---
# NetworkPolicy — multiple labels = AND
podSelector:
  matchLabels:
    app: web
    env: prod

---
# NetworkPolicy — {} = ALL Pods in namespace
podSelector: {}
```

> **CKAD**: Selectors don't need to match all Pod labels. They only need to match the labels they specify.

# 5. Deployments and ReplicaSets

## Common Commands

```bash
k create deploy web --image=nginx --replicas=3
k create deploy web --image=nginx --replicas=3 $do > deploy.yaml

k get deploy,rs,po  # list Deployments, ReplicaSets and Pods

k scale deploy web --replicas=5

k set image deploy/web nginx=nginx:1.24   # update container image
k set env deploy/web APP_ENV=prod
k set env deploy/web APP_ENV-

k set resources deploy web -c nginx \
--requests=cpu=100m,memory=128Mi \
--limits=cpu=200m,memory=256Mi

k rollout restart deploy/web  # restart all Pods managed by deployment "web"
```

## Rollout

```bash
k rollout status deploy web
k rollout history deploy web                # show rollout revision history of deployment
k rollout history deploy web --revision=2   # show details of revision 2

k rollout undo deploy web                   # rollback deployment to previous version
k rollout undo deploy web --to-revision     # rollback deployment to specified version
```

## Pause and Resume

```bash
k rollout pause deploy web                # pause rollout of deployment
k set image deploy/web nginx=nginx:1.27   # update image
k set env deploy/web APP_ENV=prod         # set env variable
k rollout resume deploy/web               # resume rollout
```

## Strategies

```yaml
# RollingUpdate: Gradually replace old Pods with new Pods while keeping the app available
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1 # allow at most 1 Pod can be unavailable during the update
      maxSurge: 1 # allow at most 1 extra Pod above the desired replica count during the update
```

```yaml
# Recreate: Terminate all old Pods before creating the new Pods, causing downtime
spec:
  strategy:
    type: Recreate
```

## Blue/Green Deployment

Use 2 Deployments with different version labels and switch the Service selector

```yaml
# Blue Deployment
selector:
  matchLabels:
    app: web
    version: blue
template:
  metadata:
    labels:
      app: web
      version: blue
---
# Green Deployment
selector:
  matchLabels:
    app: web
    version: green
template:
  metadata:
    labels:
      app: web
      version: green
---
# Service → selects Pods
spec:
  selector:
    app: web
    version: green # switch blue → green
```

## Canary Deployment

Run stable and canary deployments with a shared Service selector

```
stable: replicas=9, labels app=web,track=stable
canary: replicas=1, labels app=web,track=canary
service selector: app=web
```

This gives an approximate 90/10 traffic split when Pods have equal readiness and capacity.

# 6. DaemonSet

A DaemonSet runs one Pod on every eligible node. There is no common imperative generator, start from documentation or convert a Deployment manifest.

```yaml
# Create a DaemonSet "log-agent" that runs one log-agent Pod on every eligible node
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-agent
spec:
  # Select Pods with label app=log-agent
  selector:
    matchLabels:
      app: log-agent
  template:
    metadata:
      # Label created Pods with app=log-agent
      labels:
        app: log-agent
    spec:
      containers:
        # Run the Fluent Bit log agent container
        - name: agent
          image: fluent/fluent-bit:latest
```

```bash
k get ds
k describe ds log-agent
k rollout status ds log-agent   # watch rollout status of DaemonSet
k set image ds/log-agent agent=fluent/fluent-bit:3 # update container "agent" to image fluent/fluent-bit:3
```

# 7. Jobs and CronJobs

## Jobs

- A **Job** creates Pod(s) to run a task until it successfully completes.

```bash
# create a Job "sleeper" that runs "sleep 30" once
k create job sleeper --image=busybox -- sleep 30
k create job sleeper --image=busybox $do -- sleep 30 > job.yaml

k get jobs

k logs job/sleeper    # show logs from the Pod created by Job "sleeper"

k delete job sleeper  # delete job "sleeper" and its Pods
```

```yaml
apiVersion: batch/v1/
kind: Job
metadata:
  name: worker
spec:
  completions: 5 # require 5 successful Pod completions
  parallelism: 2 # run at most 2 Pods concurrently
  backoffLimit: 4 # retry failed Pods up to 4 times
  activeDeadlineSeconds: 300 # fail Job if it runs longer than 300 seconds
  template:
    spec:
      restartPolicy: Never # do not restart containers within the same Pod
      containers:
        - name: worker
          image: busybox
          command: ['sh', '-c', 'echo work; sleep 5'] # Print "work", then sleep 5s
```

`restartPolicy`:

- `Never`: new Pod on failure
- `OnFailure`: restart container in same Pod.

## CronJobs

A **CronJob** creates **Jobs (which create Pods)** on a **recurring schedule**.

```bash
# create CronJob "backup" that runs "date" every 5 minutes
k create cronjob backup --image=busybox --schedule='*/5 * * * *' -- date
k create cronjob backup --image=busybox --schedule='*/5 * * * *' $do -- data > cronjob.yaml

# manually create a one-time Job from CronJob "backup"
k create job manual-run --from=cronjob/backup

k get cj
```

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup
spec:
  schedule: '0 2 * * *' # run every day at 2:00 AM
  concurrencyPolicy: Forbid # prevent overlapping Jobs (Allow, Forbid, Replace)
  successfulJobsHistoryLimit: 3 # keep last 3 successful Jobs
  failedJobsHistoryLimit: 1 # keep last 1 failed Job
  suspend: false # false = enabled, true = stop scheduling new Jobs
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure # restart container if it fails
          containers:
            - name: backup
              image: busybox
              command: ['sh', '-c', 'date'] # run the date command
```

# 8. Multi-Container Pods

All containers in one Pod share:

- **Network Namespace**: communicate through `localhost`.
- **Pod IP and Port space**: 2 containers cannot bind the same port.
- Explicitly mounted volumes
- **Lifecycle**: scheduled and terminated together.

They do not share filesystem or environment variables automatically.

## Init Container

Runs before app containers, sequentially, to successful completion.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-with-init
spec:
  initContainers: # run to completion before main containers start
    - name: init-content
      image: busybox
      command: ['sh', '-c', 'echo ready > /work/index.html'] # create initial web content
      volumeMounts:
        - name: work
          mountPath: /work # mount shared volume at /work
  containers:
    - name: web
      image: nginx
      volumeMounts:
        - name: work
          mountPath: /usr/share/nginx/html # serve files from shared volume
  volumes:
    - name: work
      emptyDir: {} # temporary volume shared between containers
```

**Init Container + Shared Volume**

```
emptyDir volume (Pod)
  │
  ├── Init container → mounts at /work
  │   └── writes /work/index.html
  │
  └── Nginx → mounts same volume at /usr/share/nginx/html
      └── sees /usr/share/nginx/html/index.html
```

**Key**: Same Pod volume can be mounted at different paths in different containers.

## Sidecar Container

- **Traditional Sidecar**: Defined in `spec.containers`, it starts in parallel with main containers without guaranteed startup ordering.
- **Native Sidecar:** Defined in `spec.initContainers` with `restartPolicy: Always`, it guarantees starting _before_ main containers and stays running for the Pod's lifecycle.

### Traditional Sidecar

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-sidecar
spec:
  containers:
    - name: app # main application container
      image: busybox
      # write date to log every 5s
      command:
        ['sh', '-c', 'while true; do date >> /logs/app.log; sleep 5; done']
      volumeMounts:
        - name: logs
          mountPath: /logs # mount shared logs volume
    - name: sidecar # sidecar container running alongside the app
      image: busybox
      command: ['sh', '-c', 'tail -F /logs/app.log'] # continuously read the app log
      volumeMounts:
        - name: logs
          mountPath: /logs # mount the same shared logs volume
  volumes:
    - name: logs
      emptyDir: {} # temporary volume shared by both containers
```

### Native Sidecar

A native sidecar is declared under `initContainers` with `restartPolicy: Always`.

```yaml
spec:
  initContainers:
    - name: log-shipper
      image: busybox
      restartPolicy: Always # makes this init container a native sidecar
      command: ['sh', '-c', 'tail -F /logs/app.log'] # continuously follow the app log
      volumeMounts:
        - name: logs
          mountPath: /logs
```

## Ambassador and Adapter

- **Ambassador**: Acts as an **outbound proxy** that simplifies communication _from_ the main application to external services (e.g., routing localhost requests to a database cluster).
- **Adapter:** Acts as an **inbound/outbound transformer** that standardizes or converts data from the main application so external systems can process it (e.g., reformatting custom metrics into Prometheus format).

## Debugging Multi-Container Pods

```bash
k get po <pod>        # show basic status and information of Pod

k describe po <pod>   # show detailed Pod information, conditions and events

k logs <pod> -c <container>   # show logs from a specific container in the Pod
k logs <pod> -c <container> --previous  # show logs from previous crashed/restarted container instance

k exec -it <pod> -c <container> -- sh   # open an interactive shell inside a specific container
```

# 9. Probes

- **Liveness**: Checks if the app is alive and **restarts** the container if it becomes deadlocked or unrecoverable.
- **Readiness**: Checks if the app is ready to serve traffic and temporarily removes the Pod from Service endpoints if it fails.
- **Startup**: Checks if the app has booted up, disabling liveness and readiness checks until it succeeds (restarting the container if it times out).

## HTTP, TCP, Exec, gRPC Probes

```yaml
# HTTP — sends HTTP GET; success = 2xx/3xx response
httpGet:
  path: /healthz
  port: 8080

# TCP — checks whether a TCP connection can be established
tcpSocket:
  port: 5432

# Exec — runs a command inside the container; success = exit code 0
exec:
  command: ['test', '-f', '/tmp/healthy']

# gRPC — performs a gRPC health check
grpc:
  port: 9000
  service: myservice # gRPC health service name
```

## Timing Fields

```yaml
initialDelaySeconds: 5 # wait 5s before first probe
periodSeconds: 10 # probe every 10s
timeoutSeconds: 1 # probe fails if no response within 1s
failureThreshold: 3 # considered failed after 3 consecutive failures
successThreshold: 1 # considered successful after 1 success

# Example Usage:
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 1
  failureThreshold: 3
  successThreshold: 1
```

So rough flow: **wait 5s → check every 10s → each check gets 1s → 3 consecutive failures triggers liveness failure/restart.**

Allowed failure window is approximately:

```
failureThreshold x periodSeconds
```

## StartupProbe for Slow Applications

```yaml
startupProbe:
  httpGet:
    path: /healthz
    port: 8080
  periodSeconds: 10
  failureThreshold: 30 # up to 5 minutes
```

## Verify Probes

```bash
k describe po <pod> # check probe configuration, Pod conditions, restart count, and probe failure events

k get po <pod> -w   # watch pod status and restarts in real time

# Show cluster events sorted chronologically
k get events --sort-by=.metadata.creationTimestamp

# Test the health endpoint from inside the Pod
# `-q`: quiet, hide wget messages
# `-O-`: write downloaded content to stdout (terminal) instead of a file
# `-qO-`: quietly fetch the URL and print only the response body
k exec <pod> -- wget -qO- http://localhost:8080/healthz
```

# 10. ConfigMaps and Secrets

## Create

- `ConfigMap`

```bash
k create cm app-config --from-literal=APP_ENV=prod
k create cm app-config --from-file=config.properties  # filename becomes the key
k create cm app-config --from-file=./configs/         # create ConfigMap from all files in configs dir
k create cm app-config --from-env-file=app.env        # from key=value pairs in app.env
```

- `Secret`

```bash
# create generic Secret "db-creds" with username and password
k create secret generic db-creds \
--from-literal=username=admin \
--from-literal=password=secret

# create TLS Secret "app-tls" from certification and private key
k create secret tls app-tls --cert=tls.cert --key=tls.key

# create image-pull Secret "regcred" for a private container registry
k create secret docker-registry regcred \
--docker-server=registry.example.com \
--docker-username=user \
--docker-password=secret
```

## Consume as Environment Variables

```yaml
envFrom:
  - configMapRef:
      name: app-config # load all ConfigMap keys as env variables
  - secretRef:
      name: db-creds # load all Secret keys as env variables
```

## Consume as Volume

- When you mount a `ConfigMap` or `Secret` as a volume, k8s automatically turns every **key** inside the ConfigMap/Secret into an **individual file** inside the `mountPath` directory.
- The **value** of that key becomes text or data stored inside that file.
  ```
  /etc/config/
  ├── APP_MODE          # File containing the text: "production"
  └── db-config.json    # File containing the text: '{"host": "localhost", "port": 5432}'
  ```

```yaml
# ConfigMap
volumeMounts:
  - name: config
    mountPath: /etc/config # ConfigMap keys become files in this directory
volumes:
  - name: config
    configMap:
      name: app-config   # use ConfigMap "app-config" as the volume source

# Secret
volumeMounts:
  - name: secret
    mountPath: /etc/secret # secret keys become files in this directory
    readOnly: true # prevent container from modifying mounted files
volumes:
  - name: secret
    secret:
      secretName: db-creds # use Secret "db-creds" as the volume source
```

## Decode

```bash
echo -n 'value' | base64        # base64 encode
echo -n 'dmFsdWU=' | base64 -d  # base64 decode
k get secret db-creds -o jsonpath='{.data.password}' | base64 -d; echo
```

> Base64 is encoding, not encryption.

# 11. Services and DNS

## Service commands

```bash
# Expose deployment "web" with a ClusterIP service: port 80 --> container port 8080
k expose deploy web --name=web-svc --port=80 --target-port=8080

# Expose deployment "web" with a NodePort service: port 80 --> container port 8080
k expose deploy web --name=web-svc --port=80 --target-port=8080 --type=NodePort

# Expose Pod "redis" with a ClusterIP service on port 6379
k expose po redis --name=redis --port=6379

# Create ClusterIP Service "web": Service port 80 -> target port 8080
k create svc clusterip web --tcp=80:8080

# Create NodePort Service "web": Service port 80 -> target port 8080
k create svc nodeport web --tcp=80:8080

# Create LoadBalancer Service "web": Service port 80 -> target port 8080
k create svc loadbalancer web --tcp=80:8080
```

## Port Meanings

- `port`: Service Port
- `targetPort`: Pod Port
- `nodePort`: port exposed on each Node (NodePort service)
- `containerPort`: optional metadata documenting the container’s listening port; usually not required for networking., does not expose or open the port itself.

## Verify Endpoints

```bash
k get svc
k describe svc web    # show Service details, selectors, ports and endpoints

k get endpoints web   # show backend Pod IPs targeted by Service "web"

# show EndpointSlices containing backends for Service "web"
k get endpointslices -l kubernetes.io/service-name=web

# List pods matching app=web and display their labels
k get po -l app=web --show-labels
```

> If a Service has **no endpoints**, its selector probably does not match ready Pods.

## Cluster DNS

```
# Full DNS name for a Service inside the cluster
<service>.<namespace>.svc.cluster.local

# From the same namespace, the Service name alone is enough
<service>
```

```bash
# create a temporary BusyBox Pod and DNS-resolve Service "web", then delete the Pod
k run tmp --image=busybox:1.36 --restart=Never -it --rm -- nslookup web

# create a temporary curl Pod and send an HTTP request to Service "web", then delete the Pod
k run tmp --image=curlimages/curl --restart=Never -it --rm -- curl http://web:80
```

- Images:
  - `busybox:1.36`: useful for `nslookup`, basic networking/shell commands.
  - `curlimages/curl`: useful for HTTP requests with `curl`.
- `--restart=Never`: "create a **Pod**, not a Deployment"
- `-it`
  - `-i`: keep stdin open
  - `-t`: allocate a terminal
  - `-it`: together means keeping the command interactive.
- `--rm`: automatically delete the Pod when the command finishes.
- **Generic Pattern:**: `k run tmp --image=<IMAGE> --restart=Never -it --rm -- <COMMAND>`

## Headless Service

- **No ClusterIP**: A headless Service has no virtual Service IP or built-in load balancing.
- **Direct Pod connection:**
  1. Clients query the **stable Service DNS name**
  2. DNS returns the **current Pod IPs**.
  3. Clients connect directly to a Pod.
- **Why it's useful**: Pod IPs can change, but DNS stays updated, making it useful for **stateful / distributed apps** like databases that need direct Pod discovery and communication.

```yaml
spec:
  clusterIP: None
  selector:
    app: database
```

> A headless Service returns Pod IPs directly instead of a virtual ClusterIP.

# 12. Ingress

- **Ingress provides HTTP/HTTPS routing:** It routes external traffic to different Services based on **hostname or URL path**.
  - _E.g., `app.com/api` --> `api-service` and `app.com/web` --> `web-service`_
- **Problem it solves**: ClusterIP is internal only, while NodePort/LoadBalancer generally exposes Services individually. **Ingress provides one external entry point for multiple Services**, with centralized routing and TLS/HTTP termination.

```bash
k get ingress
k describe ingress <name>

k create ingress web \
  --class=nginx \
  --rule='example.com/app*=web-svc:80'
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: / # rewrite matched path to /
spec"
  ingressClassName: nginx # use the NGINX Ingress Controller
  rules:
    - host: example.com # match requests for example.com
      http:
        paths:
          - path: /app  # match requests starting with /app
            pathType: prefix # match /app and paths below it
            backend:
              service:
                name: web-svc # forward traffic to Service "web-svc"
                port:
                  number: 80 # forward to Service port 80
```

> `nginx.ingress.kubernetes.io/rewrite-target: /` changes the path **sent to the backend** and is **NGINX-specific**, not standard k8s Ingress behavior.

## Ingress Resource and Controller

- **Ingress requires an Ingress Controller**
  - An Ingress Resources only defines **routing rules**.
  - An Ingress Controller (e.g., NGINX) actually implements those rules.
  - `ingressClassName: nginx` selects the controller/class.
- **Known host + path routing**:

```
example.com/app  → app-svc:80
example.com/api  → api-svc:80
api.example.com  → api-svc:80
```

> Main reason to use Ingress: **one entry point can route to multiple Services**.

- Know the path types:

```
path: /app
pathType: Prefix
```

> `Prefix` --> `/app` also matches `/app/foo`
> `Exact` --> only `/app`
> `ImplementationSpecific`: behavior depends on Ingress Controller.

- Traffic Flow:

```
Client
  ↓
Ingress Controller
  ↓  host/path rule
Service
  ↓
Pod
```

## TLS

```yaml
spec:
  tls:
    - hosts:
        - example.com
      secretName: app-tls
```

> Reference Secret normally contains `tls.crt` and `tls.key`

```bash
k create secret tls app-tls \
  --cert=tls.crt \
  --key=tls.key
```

## Troubleshoot

```bash
k get ingress
k describe ingress web
k get svc
k get endpoints
k get pods
```

- Troubleshooting order:

```
Ingress/class
     ↓
host + path
     ↓
Service name + port
     ↓
endpoints
     ↓
Pod readiness + targetPort
```

# 13. NetworkPolicies

- **Purpose**: `NetworkPolicy` controls which **pods can communicate with other pods or network endpoints**, defining allowed **ingress (incoming)** and **egress (outgoing)** traffic.
- **Problem it solves:** By default, Pods can communicate freely. `NetworkPolicy` provides **network isolation and least-privilege access**, limiting unwanted or unauthorized traffic between workloads.

> A `NetworkPolicy` only works when the cluster CNI supports NetworkPolicy.

## Default Deny Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: app # apply policy in namespace "app"
spec:
  podSelector: {} # select all Pods in the namespace
  policyTypes:
    - Ingress # deny all incoming traffic unless another policy allows it
```

## Allow Ingress from Selected Pods

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend
  namespace: app
spec:
  podSelector:
    matchLabels:
      role: api # apply policy to Pods with role=api (subset match)
  policyTypes:
    - Ingress # control incoming traffic
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: frontend # allow traffic from role=frontend Pods in same namespace
      ports:
        - protocol: TCP
          port: 8080 # allow TCP traffic on port 8080
```

- `spec.podSelector`: selects the destination Pods the policy applies to (role=api).
- `ingress.from.podSelector`: selects the source Pods allowed to connect (`role=frontend`). Since there's no `namespaceSelector`, they must be in the same `app` namespace.

## Allow from a Namespace and Pod combination

- A single `from` entry containing both selectors means **AND**.

```yaml
ingress:
  - from:
      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: client # require Pods to be in namespace "client"
        podSelector:
          matchLabels:
            role: frontend # AND require Pods to have role=frontend
```

- Separate entries mean **OR**.

```yaml
ingress:
  - from:
      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: client # allow ALL Pods from namespace "client"
      - podSelector:
          matchLabels:
            role: frontend # OR allow role=frontend Pods from the policy's namespace
```

## Egress with DNS Access

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: restricted-egress
spec:
  podSelector:
    matchLabels:
      app: web # apply policy to Pods with app=web
  policyTypes:
    - Egress # control outgoing traffic
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: database # allow traffic to Pods in "database" namespace
      ports:
        - protocol: TCP
          port: 5432 # allow PostgreSQL traffic on TCP 5432
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system # allow traffic to Pods in "kube-system"
      ports:
        - protocol: UDP
          port: 53 # allow DNS over UDP
        - protocol: TCP
          port: 53 # allow DNS over TCP
```

# 14. Volumes, PVs and PVCs

- **Volumes**: Gives containers **persistent/shared storage inside a Pod**. Solves the problem of container files disappearing when container restarts.
- **PV (`PersistentVolume`)**: Represents **actual storage available to k8s cluster** (disk, NFS, cloud storage, etc.). Solves the problem of providing storage independently from Pods.
- **PVC (`PersistentVolumeClaim`)**: A Pod/user's **request for storage** (e.g., 5Gi, ReadWriteOnce). Solves the problem of letting workloads request storage **without needing to know where the storage comes from.**

## `emptyDir`

- `emptyDir`: Temporary storage shared by containers in a Pod that exists only while the Pod exists.
- Data survives container restarts but is deleted when the Pod is removed from the node.

```yaml
volumeMounts:
  - name: cache
    mountPath: /cache # mount the "cache" volume at /cache inside the container
volumes:
  - name: cache
    emptyDir: {} # temporary Pod-scoped storage, deleted when the Pod is removed
```

## Using PVC in Pod

```yaml
volumeMounts:
  - name: data
    mountPath: /data # mount the "data" volume at /data inside the container
volumes:
  - name: data
    persistentVolumeClaim:
      claimName: data-pvc # use PVC 'data-pvc' as persistent storage
```

## PVC

- `accessModes`:
  - `ReadWriteOnce (RWO)`: Volume can be mounted **read-write by a single node**.
  - `ReadOnlyMany (ROX)`: Volume can be mounted **read-only by multiple nodes**.
  - `ReadWriteMany (RWX)`: Volume can be mounted **read-write by multiple nodes**.
  - `ReadWriteOncePod (RWOP)`: Volume can be mounted **read-write by only one Pod** in the entire cluster.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteOnce # volume can be mounted read-write by a single node
  resources:
    requests:
      storage: 1Gi # request 1 GiB of persistent storage
  storageClassName: standard
```

- If binding to specific PV, set `storageClassName: ""` empty.

```yaml
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: '' # empty
  volumeName: my-pv # Bind to this specific PV
```

## Static PV

**Static PV** is a PersistentVolume **manually created by an administrator** beforehand, which a PVC can later claim and use.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 1Gi # provide 1 GiB of storage
  accessModes:
    - ReadWriteOnce # mount read-write from a single node
  persistentVolumeReclaimPolicy: Retain # keep data/PV after its PVC is deleted
  storageClassName: manual # only bind to compatible PVCs using class "manual"
  hostPath:
    path: /data # use /data directory on the node as storage (good for local testing)


  # For production (use external storage like AWS EBS):
  # csi:
  #   driver: ebs.csi.aws.com
  #   volumeHandle: vol-0123456789abcdef0  # Existing AWS EBS volume ID
  #   fsType: ext4
```

- PV reclaim policies (`persistentVolumeReclaimPolicy`):
  - `Retain`: When PVC deleted, **PV and its data are kept** and require manual cleanup/reuse.
  - `Delete`: When PVC deleted, **PV and underlying storage are automatically deleted**.

## Inspect

```bash
k get pv,pvc,sc
k describe pvc data-pvc
k get pvc data-pvc -o jsonpath='{.status.phase}'
```

# 15. Scheduling

## `nodeSelector`

```bash
# Label node "node01" with disktype=ssd
k label node node01 disktype=ssd
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  nodeSelector:
    diskType: ssd # schedule Pod only onto nodes with disktype=ssd
  containers:
    - name: nginx
      image: nginx
```

> If no node has label `disktype: ssd`, Pod stays in `Pending` state until a matching node becomes available.

## `nodeAffinity`

- **Node Affinity**: controls **which nodes a Pod can or prefers to run on** based on node labels.
- **Purpose**: solves more complex scheduling needs than `nodeSelector`, such as **multiple allowed values, preferences, or exclusion rules**.

```yaml
# pod.yaml
spec:
  affinity:
    nodeAffinity:
      # hard scheduling requirement, existing Pod stays if node labels later change
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: disktype # check the node's "disktype" label
                operator: In # label value must be in the values list
                values: [ssd] # schedule only onto nodes with disktype=ssd
```

- **Node Affinity Types:**
  - `requiredDuringSchedulingIgnoredDuringExecution`: **Hard rule**, Pod will not schedule unless a node matches.
  - `preferredDuringSchedulingIgnoredDuringExecution`: **Soft rule**, k8s prefers matching nodes, but can schedule elsewhere.
    > `IgnoredDuringExecution`: if the node's labels change later, an already running Pod **keeps running**.
    > **Required = MUST**, **Preferred = TRY**.

- **`matchExpressions` operators**:
  - `In`: Node label value must be **one of** the specified values.
  - `NotIn`: Node label value must **not be one of** the specified values.
  - `Exists`: Node must **have the label key**, value doesn't matter.
  - `DoesNotExist`: Node must **not have the label key**.

## Pod Affinity and Anti-Affinity

- **Pod Affinity** places related pods **together** on the same node.
- **Pod Anti-Affinity** keeps matching pods **apart**.
  - In the example below, pods labeled `app: web`

```yaml
# pod.yaml

# Pod Affinity
# Places `web` pods on the same node as another `web` pod.
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: web
          topologyKey: kubernetes.io/hostname

# Pod Anti-Affinity
# Places `web` pods on different nodes form other `web` pods
spec:
  affinity:
    podAntiAffinity: # key difference is this line
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: web
          topologyKey: kubernetes.io/hostname
```

## Taints and Tolerations

- **Taints:** Applied to **nodes** to repel Pods that don't meet specific conditions.
- **Tolerations:** Applied to **pods** to allow them to be scheduled on nodes with matching taints.

```bash
# Taint node01 so Pods without a matching toleration cannot be scheduled there
k taint node node01 dedicated=app:NoSchedule

# Remove the dedicated=app:NoSchedule taint from node01
k taint node node01 dedicated=app:NoSchedule-
```

```yaml
# pod.yaml
tolerations:
  - key: dedicated
    operator: Equal
    value: app
    effect: NoSchedule # tolerate the matching taint, permits scheduling but does not force it
```

- Effects:
  - `NoSchedule`: block new Pods without a matching toleration.
  - `PreferNoSchedule`: try to avoid scheduling Pods without a matching toleration.
  - `NoExecute`: block new Pods and **evict existing Pods** without a matching toleration.

# 16. SecurityContext and Capabilities

## Pod and Container Security Context

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
spec:
  securityContext:
    runAsUser: 1000 # run Pod processes as user ID 1000
    runAsGroup: 3000 # run Pod processes with group ID 3000
    fsGroup: 2000 # give mounted volumes group ID 2000
    seccompProfile:
      type: RuntimeDefault # use container runtime's default seccomp profile
  containers:
    - name: app
      image: nginx
      securityContext:
        runAsNonRoot: true # prevent container from running as root
        allowPrivilegeEscalation: false # prevent processes from gaining more privileges
        readOnlyRootFilesystem: true # make container root filesystem read-only
        capabilities:
          drop: ['ALL'] # remove all Linux capabilities
          add: ['NET_BIND_SERVICE'] # allow binding to privileged ports below 1024
```

> Container-level settings override overlapping Pod-level settings

## Verify Runtime Identity

```bash
# Show the container's runtime user ID, group ID and supplementary groups
k exec secure-app -- id

# Show the username of the container's runtime user
k exec secure-app -- whoami
```

# 17. ServiceAccounts and RBAC

## ServiceAccounts

- **Purpose**: Provides a non-human identity for processes running inside Pods to authenticate with the k8s API Server.
- **Problem Solved:** Prevents hardcoding sensitive credentials or using administrative user accounts for automated workloads, enabling granular, isolated access control (RBAC) per application.

```bash
k create sa app-sa # create a ServiceAccount named app-sa
k get sa # list ServiceAccounts in the current namespace
k create token app-sa # generate an authentication token for app-sa
k set sa deploy/web app-sa # set app-sa as the ServiceAccount used by the web Deployment
```

```yaml
spec:
  serviceAccountName: app-sa # run the Pod using the app-sa ServiceAccount
  automountServiceAccountToken: false # prevent the ServiceAccount token from being automatically mounted in the Pod
```

## Role and RoleBinding

- **Purpose**:
  - `Role`: define _what_ actions are allowed (e.g., read pods).
  - `RoleBinding`: attach those permissions to a specific **user** or **ServiceAccount** within a namespace.
- **Problem Solved:**
  - Prevents granting global cluster-wide admin access to every application, enforcing the principle of least privilege by scoping permissions tightly to specific namespaces and resources.

```bash
# Create a Role allowing get, list and watch on Pods
k create role pod-reader --verb=get,list,watch --resource=pods

k create rolebinding read-pods \    # Create a RoleBinding named read-pods
--role=pod-reader \                 # Bind the pod-reader Role
--serviceaccount=default:app-sa     # Grant the Role to app-sa in the `default` namespace
```

> Format for `--serviceaccount` is `namespace:serviceaccount-name`

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role # 'Role' is namespace-scoped (Use 'ClusterRole' for cluster-wide access)
metadata:
  name: pod-reader
rules:
  - apiGroups: [''] # empty string "" means the "core" API group (pods, services, configmaps). Use "apps" for Deployments, "batch" for Jobs
    resources: ['pods', 'pods/log'] # 'pods/log' is a subresource! You MUST explicitly include it to read pod logs
    verbs: ['get', 'list', 'watch'] # 'list' is required to see multiple pods, 'get' is for a single pod
    # verbs: ['*'] # for all
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding # Grants the Role's permission to subjects strictly within THIS namespace
metadata:
  name: read-pods
subjects: # Defines WHO gets the permissions
  - kind: ServiceAccount # Can be ServiceAccount, User or Group
    name: app-sa
    namespace: default # The namespace where this ServiceAccount actually lives
roleRef: # Defines WHICH Role is being bound to the subjects above
  apiGroup: rbac.authorization.k8s.io # Must match the target Role's API group
  kind: Role # Must exactly match the target's kind (Role or ClusterRole)
  name: pod-reader # Must exactly match the target Role's name
```

## Verbs in Role

- `get`: Allows viewing details and configuration of a single specific resource by name.
- `list`: Allows viewing a list of all resources of a specific type within a namespace.
- `watch`: Allows streaming real-time status updates whenever resources are created, modified or deleted.
- `create`: Allows creating and deploying new resources into the cluster.
- `update`: Allows modifying or replacing an entire resource definition.
- `patch`: Allows updating specific, individual fields of an existing resource without overwriting the whole object.
- `delete`: Allows removing a single specific resource from the cluster.
- `*`: Grants full permission to permission to perform all available API actions on the target resources.

## Test Authorization

```bash
# Tests if YOUR current kubeconfig user can 'get' pods in the current namespace. Returns 'yes' or 'no'
k auth can-i get pods
k auth can-i get pods -n dev  # add namespace

# Impersonates an SA to test its RBAC!
# Format is strictly: system:serviceaccount:<namespace>:<sa-name>
k auth can-i get pods --as=system:serviceaccount:default:app-sa

# Lists ALL resources and verbs this SA is permitted to access in the current namespace
k auth can-i --list --as=system:serviceaccount:default:app-sa
```

# 18. ResourceQuota and LimitRange

- **ResourceQuota**:
  - A **namespace** level object that sets hard limits on aggregate resource consumption.
  - **Problem it solves**: a single team or project monopolizing shared cluster resources.
  - **Purpose**: enforce fair multi-tenancy by capping total CPU, memory, or object counts per namespace.
- **LimitRange**:
  - A **namespace** level object that defines default and boundary values for individual containers.
  - **Problem it solves**: unbounded pods crashing nodes due to missing resource specification.
  - **Purpose**: ensure every container has valid requests/limits and stays within acceptable min/max bounds.

> CKAD: When a `ResourceQuota` is applied to a namespace, **every new pod MUST specify CPU and Memory requests and limits** in its spec. If a pod omits them, Kubernetes rejects it, unless a `LimitRange` exists in that namespace to automatically fill in the missing defaults.

## ResourceQuota

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
spec:
  hard: # defines the absolute upper limit for the namespace
    requests.cpu: '2' # total CPU requests allowed across all pods
    requests.memory: 2Gi # total memory requests allowed
    limits.cpu: '4' # total CPU limits allowed
    limits.memory: 4Gi # total memory limits allowed
    pods: '10' # max number of pods allowed in namespace
```

```bash
k create quota compute-quota --hard=pods=10,requests.cpu=2,limits.cpu=4
k get quota
k describe quota compute-quota
```

## LimitRange

```yaml
apiVersion: v1
kind: LimitRange # enforces min/max/default resource constraints per namespace
metadata:
  name: container-limits
spec:
  limits:
    - type: Container # applies to containers, can also be Pod or PersistentVolumeClaim
      default: # default limits inject if container sets none
        cpu: 500m
        memory: 512Mi
      defaultRequest: # default requests injected if container sets none
        cpu: 100m
        memory: 128Mi
      max: # container cannot exceed these limits
        cpu: '1'
        memory: 1Gi
      min: # container must request at least these values
        cpu: 50m
        memory: 64Mi
```

```
k get limitrange
k describe limitrange container-limits
```

# 19. Container Images

CKAD includes defining, building and modifying container images.

## Dockerfile Essentials

```dockerfile
# Base Image
FROM nginx: alpine

# Injects application files into image
COPY ./html /usr/share/nginx/html

# Documents Port (Note: k8s Services handle actual external routing, not this)
EXPOSE 80

# Runs as non-root (mirrors k8s SecurityContext runAsUser)
USER 101

# Main process, MUST run in foreground or the Pod will crash/restart
CMD ["nginx", "-g", "daemon off;"]
```

```bash
# Builds image and tags it for the target registry
# - Registry Domain: registry.example.com
# - Repository Name: app
# - Tag: v1
docker build -t registry.example.com/app:v1

# Tests locally, maps host port 8080 to container port 80
# `--rm`: deletes containers filesystem automatically when it stops
# `-p`: port forwarding
docker run --rm -p 8080:80 registry.example.com/app:v1

# Pushes image to repository so k8s cluster can pull it
docker push registry.example.com/app:v1
```

## Image Settings in Kubernetes

```yaml
containers:
  - name: app
    image: registry.example.com/app:v1 # use fully qualified name (registry/repo:tag)
    imagePullPolicy: IfNotPresent # default for specific tags. Use 'Always' if tag is ':latest'
imagePullSecrets: # required for private registries. lives at Pod spec level, NOT container level!
  - name: regcred # must reference a valid 'docker-registry' Secret
```

- `imagePullPolicy`:
  - `Always`: pulls the image on every container start. Default policy if the tag is `:latest` or omitted.
  - `IfNotPresent`: pulls the image only if it isn't already cached locally. Default policy for explicit tags (e.g., `v1`).
  - `Never`: never pulls the image, assume it exists locally.

```bash
# Creating docker registry secret
k create secret docker-registry regcred \ # Type MUST be 'docker-registry' (not 'generic')
  --docker-server=REGISTRY_URL \          # Target registry URL (e.g., https://index.docker.io/v1/ for Docker Hub)
  --docker-username=USER \                # Registry username
  --docker-password=PASS \                # Registry password or access token
  --docker-email=EMAIL                    # Optional for some registries, but include if the question specifies it

k describe po <pod>
k get secret regcred
k get po <pod> -o jsonpath='{.spec.imagePullSecrets[*].name}' # confirms pod if actually referencing the correct secret name
```

# 20. Helm

- **What it is:** The **package manager for Kubernetes** (like `npm` or `apt`), bundling related YAML manifests into a single reusable package called a **Chart**.
- **Problem it solves:** Eliminates hardcoded, copy-pasted YAML files by using **templates and configuration files** (`values.yaml`) to dynamically deploy the same app across different environments (dev, staging, prod).
- **Purpose**: Simplifies release management by giving you **one-command installs, upgrades, and instant rollbacks** for an entire multi-resource application.

> CKAD expects using Helm to deploy existing packages.

## What is a Helm Chart?

Anatomy of a Helm Chart:

```
my-chart/
├── Chart.yaml          # Metadata about the chart (name, version, description)
├── values.yaml         # Default configuration values for templates
├── templates/          # Folder containing Kubernetes YAML template files
│   ├── deployment.yaml
│   ├── service.yaml
│   └── _helpers.tpl
└── charts/             # Folder for optional dependent charts
```

3 Parts of a Helm Chart:

1. `values.yaml` **(Variables)**: Standard key-value settings.

```yaml
replicaCount: 3
image:
  repository: nginx
```

2. `templates/*.yaml` **(Go Templates)**: The structural Kubernetes manifests with placeholders.

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: { { .Values.replicaCount } }
```

3. **Rendered k8s Manifests (Final Output):** Helm merges `values.yaml` into `templates/` to produce the standard k8s manifests sent to the API server.

## Repository Management

```bash
# adds a remote chart repository, it's a metadata catalog in `index.yaml` file listing available charts and versions
helm repo add bitnami https://charts.bitnami.com/bitnami

# fetches the latest chart info from all added repos, refreshes local `index.yaml` cache
helm repo update

helm search repo nginx                        # searches your local cache for charts matching 'nginx'
helm show values bitnami/nginx > values.yaml  # exports default config to a file so you can customize it
helm template bitnami/nginx                   # view actual k8s YAML files that will be generated
```

## Installation

**Note**: Syntax is always `helm install [RELEASE_NAME] [CHART_NAME]`

```bash
helm install web bitnami/nginx                                  # installs chart as release "web" in current namespace
helm install web bitnami/nginx -n app --create-namespace        # installs in 'app' namespace, creates the namespace if it doesn't exist
helm install web bitnami/nginx -f values.yaml                   # installs using your custom configuration file
helm install web bitnami/nginx --set service.type=ClusterIP     # overrides a single configuration value inline
```

> **Rendering Manifests**: When run `helm install`, Helm takes the chart templates, merges them with your configuration values, renders them into standard k8s YAML manifests, and sends them to the Kubernetes API server.
> **Creating Objects & Releases:** Kubernetes then creates the actual objects (Pods, Services, Deployments, etc.) in the cluster, and Helm assigns that specific running instance a unique Release name so you can track, upgrade, or uninstall it as a single unit later.

## Inspecting Releases

```bash
helm list -A              # lists all deployed Helm releases across ALL namespaces
helm status web           # shows deployment status and helpful notes for release
helm get values web       # shows the custom values currently applied to release 'web'
helm get manifest web     # shows the exact k8s YAML manifests Helm generated and applied
```

## Updates and Deletions

```bash
helm upgrade web bitnami/nginx -f values.yaml   # updates an existing release with a new chart version or new values
helm rollback web 1                             # reverts release 'web' to revision 1
helm history web                                # see all revisions of the release
helm uninstall web                              # deletes the release and all its associated k8s resources
```

## Dry Run and Debugging (Crucial for CKAD!)

```bash
# renders helm templates into raw k8s YAML locally without installing (great for generating boilerplate YAML!)
helm template web bitnami/nginx -f values.yaml > rendered.yaml

# simulates the install and prints the generated YAML and any errors without touching the cluster
helm install web bitnami/nginx --dry-run --debug
```

# 21. Kustomize

- **What it is:** A **native Kubernetes configuration management tool** built directly into `kubectl` (via `kubectl apply -k`) that modifies YAML manifests without using templates.
- **Problem it solves**: Eliminates messy copy pasting of YAML files across environments (dev, staging, prod) by using an **overlay system** to customzie base configurations.
- **Purpose**: Keeps your k8s manifests **clean and DRU (Don't Repeat Yourself)** by patching base YAML files without altering their original source code.

> MUST BE SPELLED ACCURATELY: `kustomization.yaml`

## Basic Structure

```
app/
├── deployment.yaml
├── service.yaml
└── kustomization.yaml
```

```yaml
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: # list of base YAML files to include
  - deployment.yaml
  - service.yaml
namePrefix: prod- # prepends 'prod-' to ALL resource names in this directory
commonLabels: # adds these labels to ALL resources AND updates their selectors automatically
  env: prod
images: # updates image tags across all deployments without editing the base YAML
  - name: nginx
    newTag: '1.27'
replicas: # scales specific deployments by matching the deployment's metadata.name
  - name: web
    count: 3
```

```bash
kubectl kustomize ./app   # builds and prints the final merged YAML to stdout (crucial for debugging)
kubectl apply -k ./app    # applies the Kustomize directory to the cluster (use `-k` instead of `-f`)
kubectl delete -k ./app   # deletes all resources created from this directory
```

## Overlay Pattern

```
base/                  # Contains the shared, environment-agnostic YAMLs
  deployment.yaml
  kustomization.yaml
overlays/prod/         # Contains prod-specific overrides
  kustomization.yaml
  patch.yaml
```

```yaml
# overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resoures:
  - ../../base # points to the base directory
patches: # applies environment specific changes
  - path: patch.yaml
```

## Patching Patterns

### 1. Strategic Merge Patch (Most Common)

- Standard YAML, it merges with base resource.
- **Must** specify the `apiVersion`, `kind`, and `metadata.name` so Kustomize knows which base resource to patch. You only include the fields you want to change or add.

```yaml
# overlays/prod/patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web # MUST match the base deployment name exactly!
spec:
  replicas: 5 # overwrites the base replicas
  template:
    spec:
      containers:
        - name: app
          resources: # adds resource limits that didn't exist in the base
            limits:
              cpu: 500m
```

### 2. JSON Patch (RFC 6902)

- Used when you need to perform specific operations (add, remove, replace) on arrays or specific paths.
- Defined inline in the `kustomization.yaml` or in a separate file.

```yaml
# overlays/prod/kustomization.yaml
patches:
  - target:
      kind: Deployment
      name: web
    patch: |- # JSON array of operations
      - op: replace   # operation: add, remove, replace, copy, move
        path: /spec/replicas
        value: 5
      - op: add
        path: /metadata/labels/tier
        value: frontend
```

> **CKAD Tip**: If the question asks to "modify a specific value in a deployment using Kustomize", use a **Strategic Merge Patch** (`patch.yaml`). It is much faster to type than JSON patch arrays. Always use `kubectl kustomize ./dir` to verify your patches worked before applying!

# 22. CRDs and Operators

- **What it is:**
  - **CRDs (Custom Resource Definitions):** extend the Kubernetes API to create new resource types (e.g., `Database`).
  - **Operators**: custom controllers that manage those CRDs.
- **Problem they solve**: Standard k8s objects (like Deployments) only understand simple lifecycle rules, they cannot handle domain-specific operational tasks like database failovers, schema migrations, or stateful backups automatically.
- Purpose: Encapsulates human operational knowledge into code (acting like an "automated SRE") to make complex, stateful applications (e.g., PostgreSQL, Kafka, Prometheus) self-managing.

## Discover Custom Resources

```bash
# lists all resource types, API versions, and short names. Use this to find the exact API group/version for your YAML!
k api-resources

k api-resources --api-group=<group>   # filters resources by API group (e.g., `rbac.authorization.k8s.io`) to reduce output cluster
k api-resources --api-group rbac.authorization.k8s.io

k get crd
k describe crd <name>
k explain <custom-resource>   # Crucial! Shows schema/fields for a CR. Use `k explain <resource>.<group>` if standard resources share the same name

k get <custom-resource> -A    # lists instances of the custom resource across all namespaces
```

## Minimal Custom Resource Instance

```yaml
apiVersion: example.com/v1 # CRD Group/Version
kind: Database # CRD Kind (case-sensitive)
metadata:
  name: app-db
spec: # Check CRD schema (`kubectl explain <kind>`) for valid fields
  engine: postgres
  size: small
```

An **Operator** is a controller that watches custom resources and reconciles real resources toward the declared state.

```bash
k get crd
k get deploy -A | grep -i operator                  # find the Operator's control plane deployment
k logs -n <namespace> deploy/<operator-deployment>  # view reconciliation/controller errors
k describe <custom-resource> <name>                 # check events for state mismatch/failures
```

# 23. API Deprecations

- **What it is:** The official process by which Kubernetes matures, renames, or removes old manifest API versions (e.g., moving `Ingress` from `extensions/v1beta1` to `networking.k8s.io/v1`).
- **Problem it solves:** Prevents sudden cluster breakage during Kubernetes upgrades by giving APIs a structured lifecycle and deprecation period before old versions are retired.
- **Purpose:** Ensures your cluster manifests stay compatible with newer Kubernetes releases by providing tools (`k api-resources`, `kubectl-convert`) to inspect supported APIs and update legacy YAMLs.

```bash
k api-resources
k api-versions      # list all support API versions on the cluster
k explain ingress   # view resource schema (check supported apiVersion)
k get --raw /apis   # list all registered API groups and versions
```

> Convert an old manifest when `kubectl-convert` is installed.

```bash
# Convert deprecated manifest to the current supported API version
kubectl-convert -f old.yaml \
  --output-version networking.k8s.io/v1 > new.yaml
```

> Always verify the API version supported by the exam cluster instead of relying on memory.

# 24. Monitoring and Debugging

## Metrics

```bash
# Install k8s Metrics Server (not needed for CKAD)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
# Wait until the pod is Ready
kubectl wait --for=condition=ready pod -l k8s-app=metrics-server -n kube-system --timeout=90s
# Verify metrics API is responding
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
```

```bash
k top nodes               # Node CPU/Mem (requires metrics server)
k top pods                # Pod CPU/Mem
k top pods --containers   # container level CPU/Mem in multi-container pods
```

## General Debugging Flow

```bash
k get po -o wide
k describe po <pod>
k logs <pod>
k logs <pod> --previous
k get events --sort-by=.metadata.creationTimestamp
k get po <pod> -o yaml
```

## Pod Status Quick Diagnosis

| Status                | Likely cause                   | First checks                       |
| --------------------- | ------------------------------ | ---------------------------------- |
| Pending               | scheduling, PVC, quota         | `describe pod`, nodes, PVC, events |
| ContainerCreating     | image, volume, CNI             | `describe pod`, events             |
| ImagePullBackOff      | image name or credentials      | `describe pod`, imagePullSecrets   |
| CrashLoopBackOff      | process exits repeatedly       | logs, `--previous`, command/args   |
| Running but 0/1 Ready | readiness probe                | describe, probe endpoint           |
| Init:0/N              | init container failing/running | init container logs                |
| Completed             | normal for Job/one-shot Pod    | verify exit code and logs          |

## Ephemeral Debugging Container

```bash
# Inject debug container into running pod (fixes no-shell/distroless).
# `--target` shares PID namespace
k debug -it pod/<pod> --image=busybox --target=<container>
```

## Create a Temporary Diagnostic Pod

```bash
# Use Case: When you need low-level network/DNS tools (nslookup, nc, ping, wget) to test connectivity
# but your target pods are minimal/distroless and lack these utilities
# CKAD Example: Testing if a backend database Service is reachable on a specific port and resolving correctly.
k run tmp --image=busybox:1.36 --restart=Never -it --rm -- sh
# Once inside the tmp pod shell:
# nc -vz db-service 5432 # Tests TCP port connectivity
# nslookup db-service    # Tests CoreDNS resolution

# Use Case: When you need to test HTTP/HTTPS endpoints (Services, Ingress backends, readiness probes) from
# inside the cluster network to verify routing, HTTP status codes, or API payloads.
# CKAD Example: Verifying a ClusterIP web Service is actually responding to HTTP requests.
k run curl --image=curlimages/curl --restart=Never -it --rm -- sh
# Once inside the curl pod shell:
# curl -I http://frontend-svc # Checks HTTP headers/status code (expect 200 OK)
# curl http://api-svc/health  # Checks a specific health endpoint payload

k run curl --image=curlimages/curl --restart=Never -it --rm -- \
curl -v http://<service>:<port>
```

## Service Troubleshooting

```bash
k get svc <svc> -o yaml   # check `selector` and `targetPort`

k get endpoints <svc>     # if empty, selector is wrong (very common CKAD trap!)
k get endpointslices -l kubernetes.io/service-name=<svc> # modern endpoints, verify Pod IPs are listed

k get po -l <selector> -o wide  # verify target pods exist and are `Running`
k describe po <pod>             # check `Readiness Probes` (must pass to receive traffic)
k exec <pod> -- ss -lnt         # verify app is listening on the `targetPort` inside the container
```

# 25. Useful Manifests Snippets

## Pod with ConfigMap, Secret, Resources, Probes and Security

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
  labels:
    app: app
spec:
  serviceAccountName: app-sa
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: app
      image: nginx:alpine
      ports:
        - containerPort: 80
      envFrom:
        - configMapRef:
            name: app-config
        - secretRef:
            name: app-secret
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 200m
          memory: 256Mi
      readinessProbe:
        httpGet:
          path: /
          port: 80
        periodSeconds: 5
      livenessProbe:
        httpGet:
          path: /
          port: 80
        periodSeconds: 10
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop: ['ALL']
```

## Deployment and Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: nginx:1.27
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```

# 26. Common CKAD Mistakes

1. Working in the wrong context or namespace.
2. Forgetting to verify the result after creating a resource.
3. Putting container fields such as `resources`, `env`, or probes at the wrong YAML level.
4. Service selector does not match Pod labels.
5. Deployment selector does not match template labels.
6. Using the Service port instead of the container port in a probe.
7. Forgetting `-c <container>` for logs or exec in multi-container Pods.
8. Forgetting shared `volumeMounts` in both containers.
9. Applying a default-deny egress policy without allowing DNS.
10. Assuming a toleration forces placement; it only permits it.
11. Editing immutable Pod fields instead of recreating the Pod.
12. Using uppercase or singular names in RBAC `resources`.
13. Forgetting `restartPolicy: Never` or `OnFailure` in Job Pod templates.
14. Using Base64 as though it encrypts Secret data.
15. Not checking Events after a failure.

# 27. Final Exam Workflow

For each task:

```text
1. Switch to the required context.
2. Set or specify the required namespace.
3. Read the exact resource name, labels, image, ports and paths.
4. Generate YAML imperatively when possible.
5. Edit only what is necessary.
6. Apply the manifest.
7. Verify using get, describe, logs, endpoints or an in-cluster test.
8. Move on; return later if troubleshooting is taking too long.
```

## High-value verification commands

```bash
k get <resource> <name> -o yaml
k describe <resource> <name>
k get po -w
k get events --sort-by=.metadata.creationTimestamp
k rollout status deploy/<name>
k get endpoints <service>
k auth can-i <verb> <resource> --as=<identity>
```

# 28. Official References Used for Expansion

- CKAD certification and curriculum: https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/
- CKAD overview: https://www.cncf.io/training/certification/ckad/
- kubectl quick reference: https://kubernetes.io/docs/reference/kubectl/quick-reference/
- kubectl generated reference: https://kubernetes.io/docs/reference/kubectl/generated/
- Kubernetes documentation: https://kubernetes.io/docs/home/
