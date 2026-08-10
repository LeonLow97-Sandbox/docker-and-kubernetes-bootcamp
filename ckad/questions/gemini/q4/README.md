# CKAD Scenario 4: Services & NetworkPolicies

## **Context**

A team needs to secure communication between tiers in a cluster by isolating backend pods so they only accept traffic from designated frontend pods.

## **Task**

Perform the following setup in the `secure-net` namespace (create the namespace if it does not exist).

## **Requirements**

- **Deployments**
  - **Frontend deployment**
    - Name: `frontend`
    - Namespace: `secure-net`
    - Image: `nginx:1.25`
    - Replicas: `1`
    - Pod labels: `app=frontend`
  - **Backend deployment**
    - Name: `backend`
    - Namespace: `secure-net`
    - Image: `redis:7-alpine`
    - Replicas: `1`
    - Pod labels: `app=backend`
    - Container port: `6379`
- **Service**
  - Name: `backend-svc`
  - Namespace: `secure-net`
  - Type: `ClusterIP`
  - Port: `6379`
  - Target port: `6379`
  - Selector: `app=backend`
- **NetworkPolicy**
  - Name: `allow-frontend-to-backend`
  - Namespace: `secure-net`
  - Pod selector: `app=backend`
  - Policy type: `Ingress`
  - Allow ingress only from pods labeled `app=frontend` on TCP port `6379`.

## **Validation**

Verify that the `NetworkPolicy` restricts inbound traffic to the backend on port `6379` from frontend pods only.
