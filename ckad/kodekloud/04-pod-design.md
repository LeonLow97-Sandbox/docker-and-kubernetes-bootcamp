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
