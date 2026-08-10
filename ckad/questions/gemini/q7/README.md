# CKAD Scenario 7: SecurityContext, Probes, and ServiceAccounts

## **Context**

A security audit requires hardening workloads by assigning dedicated identity credentials, running containers with strict user permissions, and ensuring application readiness before serving traffic.

## **Task**

Perform the following setup in the `security-space` namespace (create the namespace if it does not exist).

## **Requirements**

- **ServiceAccount**
  - Name: `sec-sa`
  - Namespace: `security-space`
- **Pod**
  - Name: `secure-app`
  - Namespace: `security-space`
  - Image: `nginx:1.25`
  - Service account: `sec-sa`
- **Security context (container level)**
  - Run as user ID `1000`.
  - Disable privilege escalation.
- **Probes**
  - Liveness probe: HTTP `GET` to `/` on port `80` with initial delay `5s` and period `10s`.
  - Readiness probe: HTTP `GET` to `/` on port `80` with initial delay `3s` and period `5s`.

## **Validation**

Confirm that the pod reaches `Running` and `READY` status `1/1` and that the `ServiceAccount`, security context, and probes are applied correctly.
