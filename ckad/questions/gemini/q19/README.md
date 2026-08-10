# CKAD Scenario 19: ClusterRole & ClusterRoleBinding

## **Context**

A cluster administrator needs to delegate global read permissions to a central monitoring service account so it can observe workload and storage resources across all namespaces in the cluster.

## **Task**

Perform the following setup in the `monitoring-space` namespace (create the namespace if it does not exist).

## **Requirements**

- **Namespace & ServiceAccount**
  - Namespace: `monitoring-space`
  - ServiceAccount name: `cluster-monitor-sa`

- **ClusterRole**
  - Name: `global-resource-reader`
  - Scope: Cluster-wide
  - API Resources: `pods`, `persistentvolumes`, `namespaces`
  - Permitted verbs: `get`, `list`, `watch`

- **ClusterRoleBinding**
  - Name: `global-monitor-binding`
  - Scope: Cluster-wide
  - Role reference: `global-resource-reader`
  - Subject: ServiceAccount `cluster-monitor-sa` in namespace `monitoring-space`

## **Validation**

1. Provide the command to check if `cluster-monitor-sa` can list `persistentvolumes` across the cluster using `kubectl auth can-i`.
2. Provide the command to check if `cluster-monitor-sa` can list `pods` in the `kube-system` namespace.