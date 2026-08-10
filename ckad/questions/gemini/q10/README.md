# CKAD Scenario 10: ResourceQuotas and LimitRanges

## **Context**

To prevent teams from over-allocating cluster resources, the cluster administration team requires strict governance controls on namespace `finance-space`. You need to define resource consumption limits and default request/limit boundaries for pods created in this namespace.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `finance-space`.
- **ResourceQuota**
  - Name: `finance-quota`
  - Namespace: `finance-space`
  - Hard limits:
    - Maximum pods: `4`
    - Requests CPU: `500m`
    - Requests Memory: `512Mi`
    - Limits CPU: `1` (or `1000m`)
    - Limits Memory: `1Gi`
- **LimitRange**
  - Name: `finance-limits`
  - Namespace: `finance-space`
  - Type: `Container`
  - Default limits: CPU `200m`, Memory `256Mi`
  - Default requests: CPU `100m`, Memory `128Mi`
- **Validation pod**
  - Create a Pod named `finance-pod` in `finance-space` using image `nginx:1.25` without defining an explicit `resources` block.
  - Verify that the Pod inherits the default requests and limits.

## **Validation**

Confirm that quota usage is updated and that `finance-pod` inherits the default resource configuration from the `LimitRange`.
