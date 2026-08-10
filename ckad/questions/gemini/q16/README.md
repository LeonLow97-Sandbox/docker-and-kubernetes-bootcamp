# CKAD Scenario 16: Role-Based Access Control (RBAC)

## **Context**

RBAC is heavily tested on the CKAD exam. You need to configure scoped permissions for an application service account in the `rbac-space` namespace so that it can inspect pods without gaining administrative privileges.

## **Requirements**

1. Create a namespace named `rbac-space`.
2. Create a `ServiceAccount` named `pod-reader-sa` in `rbac-space`.
3. Create a `Role` named `pod-reader-role` in `rbac-space` that grants permissions to `get`, `list`, and `watch` on `pods` resources.
4. Create a `RoleBinding` named `pod-reader-binding` in `rbac-space` that binds the `pod-reader-sa` ServiceAccount to `pod-reader-role`.
5. Provide a `kubectl auth can-i` command to verify that `pod-reader-sa` can list pods in `rbac-space`.