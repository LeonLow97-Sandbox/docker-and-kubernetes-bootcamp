# CKAD Scenario 12: Kustomize Overlay Management

## **Context**

Kustomize is a built-in configuration management tool in `kubectl` (`kubectl apply -k`). On the CKAD exam, you may be asked to create base resources and an environment overlay that modifies labels, replicas, or image tags.

## **Requirements**

- **Directory structure setup**
  - Create a base directory: `/tmp/kustomize/base`
  - Create a dev overlay directory: `/tmp/kustomize/overlays/dev`
- **Base configuration**
  - Create a Deployment manifest named `deployment.yaml` with:
    - Deployment name: `app-deploy`
    - Replicas: `1`
    - Container name: `app-container`
    - Image: `nginx:1.24`
    - Container port: `80`
  - Create a `kustomization.yaml` inside `/tmp/kustomize/base` that references `deployment.yaml`.
- **Dev overlay configuration**
  - Create a `kustomization.yaml` inside `/tmp/kustomize/overlays/dev` that references the base directory.
  - Set a `namePrefix` of `dev-` so the deployment becomes `dev-app-deploy`.
  - Update the image from `nginx:1.24` to `nginx:1.25`.
  - Add the label `env=development`.
  - Increase replicas to `3`.

## **Validation**

Apply the dev overlay and verify that the resulting deployment has `3` replicas, uses `nginx:1.25`, and includes the development label.
