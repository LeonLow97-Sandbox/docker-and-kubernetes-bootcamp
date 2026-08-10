# CKAD Scenario 14: PodDisruptionBudget (PDB) & Taints / Tolerations

## **Context**

To guarantee application availability during node drains or cluster upgrades, high-priority workloads must define disruption budgets and tolerate dedicated node taints in the `ops-space` namespace.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `ops-space`.
- **Deployment definition**
  - Deployment name: `api-server`
  - Namespace: `ops-space`
  - Replicas: `4`
  - Image: `nginx:1.25`
  - Pod selector and labels: `app=api-server`
- **Tolerations**
  - The pods must be able to schedule on nodes tainted with key `tier`, value `backend`, effect `NoSchedule`, and operator `Equal`.
- **PodDisruptionBudget (PDB)**
  - Name: `api-pdb`
  - Namespace: `ops-space`
  - Selector: `app=api-server`
  - Ensure at least `3` replicas remain available during voluntary disruptions using `minAvailable: 3`.

## **Validation**

Verify that the `PDB` exists and that the deployment pods include the required toleration configuration.
