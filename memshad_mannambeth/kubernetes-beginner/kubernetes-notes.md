# Kubernetes

## 4 Sections in Kubernetes YAML file

1. apiVersion: specific to what we are creating (e.g., v1)
2. kind: a k8s object (e.g., Pod, Node, ReplicationController)
3. metadata: data about the k8s object (e.g., name, labels)
4. spec: specification of what's used in the k8s object

## Replication Controller

- To create multiple PODs and share the load across them. For instance, when the traffic increases, we deploy additional PODs to balance the load across multiple pods.
- High availability:
  - If there is only 1 POD in the Node, and the POD fails, replication controller automatically brings up a new POD when the existing POD fails.
- `replicas`: number of replicas needed.
- `apiVersion: v1`

## Replica Set

- Replaces Replication Controllers. Both have the same purpose but are not the same.
- `apiVersion: apps/v1`
- Requires a `selector` section that helps the replicaset identify what pods fall under it.
  - Besides managing the PODs specified in the template, replicaset can also manage existing PODs that were created before the replicaset.
  - Use `matchLabels` to match the labels specified on PODs
- Replicaset monitors the pods and if any of them were to fail, deploy new ones.

```yml
## Replica Set
selector:
  matchLabels:
    tier: front-end

## Pods
metadata:
  name: myapp-pod
  labels:
    tier: front-end
```

## Deployment

- For Production environment.
- Deployment object manages the rollout of updates to applications using a strategy called `Rolling Updates`, which ensures that updates are **applied incrementally with minimal downtime by replacing old pods with new ones in a controlled manner**.
    - `RollingUpdate` is the default Deployment strategy where we take down the older version and bring up a newer version 1 by 1.
    - `Recreate` (BAD) strategy destroys all running instances and then deploy the new instances. During this period, the application will be down and inaccessible to users.
- This approach enhances application availability and reliability by allowing for **smooth updates and easy rollback** if any issues arise during the deployment process.
- The contents of Deployment YAML file, similar to replicaset definition file.
- `apiVersion: apps/v1`
- Deployment automatically creates a replicaset. The replicasets ultimately create pods.

---

### Rollout and Versioning

- Rollout: process of gradually deploying or upgrading your application containers.
- When you first create a Deployment, it triggers a rollout.
- A new rollout creates a new Deployment revision. Let's call it "revision 1"
- In future, when the application is upgraded and the container version is updated to a new one, a new rollout is triggered and a new Deployment revision is created called "revision 2".
- This helps us to **track the changes made to the Deployment** and **enables to to rollback to a previous version of Deployment** (if necessary).

---
