- [Labels, Selectors and Annotations](#labels-selectors-and-annotations)
  - [The Core Concept: Grouping and Filtering](#the-core-concept-grouping-and-filtering)
  - [Using Labels in Kubernetes](#using-labels-in-kubernetes)
  - [Connecting Objects Internally](#connecting-objects-internally)
  - [Annotations: For information, Not Selection](#annotations-for-information-not-selection)
  - [Summary](#summary)

# Labels, Selectors and Annotations

## The Core Concept: Grouping and Filtering

- **Problem**: As your cluster grows, you may end up with hundreds or thousands of objects like pods, services, and deployments. You need a way to filter and view these objects by categories such as application type or functionality.
- **Labels**: These are properties (key-value pairs) attached to each item to classify them. Think of them like tags on a YouTube video or keywords on a blog.
- **Selectors**: These are the **filters** used to find items based on their labels. For example, a selector can find all pods where the label "class" equals "mammal".

## Using Labels in Kubernetes

- **Defining Labels**: Labels are specified in the `metadata` section of a pod definition file under a dedicated `labels` section. You can add as many labels as you like in a key-value format.
- **Filtering via CLI**: To find specific pods using the command line, you use the `--selector` option with `kubectl get pods` command.
  - _Example_: `kubectl get pods --selector <key>=<value>`

## Connecting Objects Internally

Kubernetes uses labels and selectors to "glue" different objects together. This is a critical concept for the CKAD exam:

- `ReplicaSet`: To create a group of pods, a `ReplicaSet` uses a **selector** to discover and manage pods that have matching labels.
- **Placement in YAML**: In a `ReplicaSet` file, `labels` under the `template` section are for the pods, while labels at the very top are for the `ReplicaSet` itself.
- **Matching**: The `selector` field under the ReplicaSet specification **must match** the labels defined on the pod for the connection to work.
- **Services**: Similarly, a service uses a selector defined in its configuration file to find and route traffic to pods with matching labels.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-rs
  labels:
    app: myapp
    type: front-end # replicaset labels
spec:
  selector:
    matchLabels:
      type: front-end # matches labels of the pod
  template: # pod template
    metadata:
      name: myapp-pod
      labels: # pod labels
        app: myapp
        type: front-end

---
apiVersion: v1
kind: Service
spec:
  type: ClusterIP
  selector:
    app: myapp # service matching labels on pod
    type: front-end
```

## Annotations: For information, Not Selection

- **Purpose**: While labels are for grouping and selecting, **annotations** are used to record informatory details.
- **Usage**: They store data that might be used for integration or documentation, such as:
  - **Tooling details**: Name, version, or build information.
  - **Contact details**: Phone numbers or email IDs of the team responsible for the object.
- **Key Difference**: Unlike labels, you do not use annotations to filter or group objects for Kubernetes to act upon.

## Summary

| Feature               | Labels & Selectors                            | Annotations                                       |
| --------------------- | --------------------------------------------- | ------------------------------------------------- |
| **Primary Use**       | Grouping, filtering and connecting objects    | Recording informatory/metadata details            |
| **Example Data**      | `app: frontend`, `env: production`            | `version: 1.2`, `contact: dev-team@org.com`       |
| **Kubernetes Action** | Used by ReplicaSets and Services to find pods | Not used by Kubernetes to group or select objects |

# Kubernetes Deployment Strategies

## 1. RollingUpdte vs Recreate

<p align="center">
    <img src="./diagrams/04/04-deployment-strategy.png" width="75%">
</p>

### Rollouts and Revisions

- **Initial Rollout**: When you first create a deployment, it triggers a **rollout**, which automatically creates a `ReplicaSet`.
- **Tracking Revision**: Every time you update the deployment (such as changing the container image version), a new rollout is triggered and a new **deployment revision** is created.
- **History**: You can keep track of these changes by running `kubectl rollout history` to see the different versions your application has gone through.
- **Monitoring**: To see if an update is still in progress or has finished, use the command `kubectl rollout status`.

### Deployment Strategies

There are 2 primary ways Kubernetes handles updates, and knowing the difference is vital for the exam:

- **Recreate Strategy**:
    - All old pods are **destroyed first**, and then the new versions are created.
    - This results in **application downtime** because there is a period where no pods are running.
    - In the event logs, you will see the old ReplicaSet scale to zero before the new one scales up.
- **RollingUpdate Strategy (The Default)**:
    - This is the **standard behaviour** if you do not specify a strategy. 
    - It takes down old pods and brings up new ones **one by one**.
    - This ensures the application stays online and provides a **seamless upgrade** for users.
    - Under the hood, it scales down the old ReplicaSet while simultaneously scaling up a new one.

<p align="center">
    <img src="./diagrams/04/04-deployment-rollingupdate.png" width="75%">
</p>
<p align="center">
    <img src="./diagrams/04/04-recreate-vs-rollingupdate.png" width="75%">
</p>

## Updating and Rolling back

- **Applying Changes**: The preferred way to update is to modify your YAML configuration file and use `kubectl apply`.
- **Imperative Updates**: You can also use `kubectl set image` to quickly change a container version, though this can make your local YAML files outdated.
- **Undo/Rollback**: If a new version is buggy, you can use `kubectl rollout undo` to revert to the previous revision.
- **Recovery**: During a rolback, Kubernetes destroys the pods in the new ReplicaSet and birngs the old ones back up gradually.

<p align="center">
    <img src="./diagrams/04/04-deployment-rollback.png" width="75%">
</p>

## Understanding Max Unavailable and Max Surge

These 2 settings allow you to fine-tune the `RollingUpdate` strategy to balance speed and availability:

- **Max Unavailable (e.g., 25%)**: This defines the maximum number of pods that can be "down" during an update. If you have 4 replicas and set this to 25%, Kubernetes ensures that at least 3 pods are always running and available to serve traffic.
- **Max Surge (e.g., 25%)**: This defines how many extra pods Kubernetes can create above your desired number during the update. If you have 4 replicas and set this to 25%, Kubernetes can briefly run up to 5 pods (the 4 original plus 1 new version) while it transitions between versions.
