# CKAD Scenario 18: NodeSelector and Node Affinity Rules

## **Context**

An analytics workload requires specific node capabilities to perform efficiently. The infrastructure team has labeled cluster nodes based on storage capabilities (`disktype=ssd`) and availability zones (`zone=us-east-1a`). You need to configure a deployment to strictly run on nodes with SSD storage while preferring nodes in a specific availability zone.

## **Task**

Perform the following setup in the `node-space` namespace (create the namespace if it does not exist).

## **Requirements**

- **Namespace setup**
  - Create a namespace named `node-space`.

- **Deployment**
  - Name: `analytics-deployment`
  - Namespace: `node-space`
  - Replicas: `2`
  - Image: `nginx:1.25`
  - Pod labels: `app=analytics`

- **Scheduling & Affinity Rules**
  - **Required Node Affinity (`requiredDuringSchedulingIgnoredDuringExecution`):**
    - Ensure pods are scheduled ONLY on nodes with the label key `disktype` equal to `ssd`.
  - **Preferred Node Affinity (`preferredDuringSchedulingIgnoredDuringExecution`):**
    - Prefer scheduling on nodes with the label key `zone` equal to `us-east-1a` with a weight of `100`.

## **Validation**

Verify the deployment definition contains the required and preferred node affinity rules using `kubectl get deploy analytics-deployment -n node-space -o yaml`.
