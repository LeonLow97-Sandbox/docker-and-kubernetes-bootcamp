# CKAD Scenario 9: Deployment Rolling Updates & Rollback Management

## **Context**

An application deployment in the `prod-space` namespace was updated with a faulty container image, causing new pods to crash. You need to inspect the deployment history, roll back to a stable revision, and tune the update strategy to prevent future downtime during updates.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `prod-space`.
- **Initial deployment setup**
  - Create a deployment named `web-app` in `prod-space` using image `nginx:1.24`.
  - Replicas: `3`
  - Record the change cause annotation as `"Initial version 1.24"`.
- Update the deployment image to `nginx:invalid-tag-999` with change cause `"Upgraded to broken version"`.
- **Tasks to execute**
  - Inspect the rollout history of `web-app`.
  - Roll back to the previous working revision (`nginx:1.24`).
  - Configure the rolling update strategy with `maxSurge: 1` and `maxUnavailable: 0`.

## **Validation**

Verify that the rollout is complete and that all `3` replicas are running `nginx:1.24` with the expected rolling update strategy.
