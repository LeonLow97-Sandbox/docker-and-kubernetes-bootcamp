# CKAD Scenario 11: Helm Chart Release Management

## **Context**

Helm is heavily tested in the CKAD exam (Application Deployment domain). You are tasked with installing, modifying parameters, and upgrading a Helm release in a specific namespace.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `helm-space`.
- **Helm repository**
  - Add the Bitnami repository: `https://charts.bitnami.com/bitnami`
  - Update local Helm repositories.
- **Install a Helm release**
  - Release name: `my-web-app`
  - Install the `apache` chart from the Bitnami repository into `helm-space`.
  - Set `replicaCount` to `2`.
  - Set `service.type` to `ClusterIP`.
- **Upgrade the release**
  - Upgrade `my-web-app` in `helm-space`.
  - Update `replicaCount` to `3`.
  - Preserve existing values with `--reuse-values`.

## **Validation**

Confirm that the Helm release is present and that the deployment under `my-web-app` has scaled to `3` replicas.
