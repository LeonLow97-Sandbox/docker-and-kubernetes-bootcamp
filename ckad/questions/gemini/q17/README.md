# CKAD Scenario 17: Blue-Green Deployments & Service Traffic Switching

## **Context**

The Blue-Green deployment strategy is a key deployment pattern tested on the CKAD exam. You need to deploy a new version of an application alongside the existing version and safely switch live traffic from the old version (Blue) to the new version (Green) via Service selectors.

## **Requirements**

1. **Namespace setup**
   - Create a namespace named `deploy-space`.

2. **Blue Deployment (Existing version)**
   - Name: `app-blue`
   - Namespace: `deploy-space`
   - Replicas: `3`
   - Image: `nginx:1.24`
   - Pod labels: `app=my-app`, `version=blue`
   - Container port: `80`

3. **Green Deployment (New version)**
   - Name: `app-green`
   - Namespace: `deploy-space`
   - Replicas: `3`
   - Image: `nginx:1.25`
   - Pod labels: `app=my-app`, `version=green`
   - Container port: `80`

4. **Service Configuration & Cutover**
   - Create a Service named `app-service` in `deploy-space`.
   - Type: `ClusterIP`
   - Port: `80`, TargetPort: `80`
   - **Initial State:** Route live traffic **only** to the Blue deployment (`version=blue`).
   - **Switch Traffic:** Update `app-service` so that traffic switches entirely to the Green deployment (`version=green`).

5. **Validation**
   - Provide the command to inspect the Service endpoints and confirm that only Green pods are selected.
