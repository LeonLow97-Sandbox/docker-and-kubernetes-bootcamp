# CKAD Scenario 5: Ingress Resources & Path-Based Routing

## **Context**

An application requires traffic routing based on HTTP paths so that incoming requests are directed to different backend microservices through an `Ingress` controller.

## **Task**

Perform the following setup in the `ingress-space` namespace (create the namespace if it does not exist).

## **Requirements**

- **Deployments and services**
  - **Video application**
    - Deployment name: `video-deployment`
    - Image: `nginx:1.25`
    - Replicas: `1`
    - Service name: `video-svc`
    - Service type: `ClusterIP`
    - Port: `80`
    - Target port: `80`
  - **Store application**
    - Deployment name: `store-deployment`
    - Image: `nginx:1.25`
    - Replicas: `1`
    - Service name: `store-svc`
    - Service type: `ClusterIP`
    - Port: `80`
    - Target port: `80`
- **Ingress resource**
  - Name: `app-ingress`
  - Namespace: `ingress-space`
  - Ingress class name: `nginx`
  - Route requests with path prefix `/video` to `video-svc` on port `80`.
  - Route requests with path prefix `/store` to `store-svc` on port `80`.
  - Use `PathType: Prefix` for both rules.

## **Validation**

Verify that the `Ingress` definition routes `/video` to `video-svc:80` and `/store` to `store-svc:80`.
