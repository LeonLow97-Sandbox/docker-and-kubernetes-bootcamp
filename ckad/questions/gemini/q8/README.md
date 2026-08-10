# CKAD Scenario 8: Canary Deployments & Traffic Splitting

## **Context**

Your team is preparing to roll out a new version of the frontend application. Before fully upgrading, you must set up a canary deployment in the `canary-space` namespace so that traffic routed to the service is split between the existing stable version and the new canary version.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `canary-space`.
- **Stable deployment**
  - Name: `app-stable`
  - Namespace: `canary-space`
  - Replicas: `3`
  - Image: `nginx:1.24`
  - Container port: `80`
  - Labels: `app=my-app`, `version=stable`
- **Canary deployment**
  - Name: `app-canary`
  - Namespace: `canary-space`
  - Replicas: `1`
  - Image: `nginx:1.25`
  - Container port: `80`
  - Labels: `app=my-app`, `version=canary`
- **Service**
  - Name: `app-service`
  - Namespace: `canary-space`
  - Type: `ClusterIP`
  - Port: `80`
  - Target port: `80`
  - The service must route traffic to both stable and canary pods simultaneously.

## **Validation**

Verify that the service endpoints list a total of `4` IP endpoints (`3` stable and `1` canary).
