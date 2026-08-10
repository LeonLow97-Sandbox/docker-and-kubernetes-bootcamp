# CKAD Scenario 15: CRDs, Custom Resources, and Storage/Jobs Review

## **Context**

Custom Resource Definitions (`CRDs`) and Custom Resources (`CRs`) are tested under the Application Environment, Configuration and Security (25%) domain. You may be asked to inspect existing CRDs or create a Custom Resource instance based on a provided CRD template.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `crd-space`.
- **Inspect the CRD**
  - Assume a CRD named `crontabs.stable.example.com` is installed in the cluster.
  - Retrieve the `kind` and `apiVersion` needed to create a resource instance.
- **Create a Custom Resource**
  - Create a manifest file named `crontab-cr.yaml` in `crd-space` with:
    - `apiVersion: stable.example.com/v1`
    - `kind: CronTab`
    - `metadata.name: my-crontab`
    - `spec.cronSpec: * * * * *`
    - `spec.image: my-awesome-cron-image`

## **Validation**

Apply the Custom Resource to the `crd-space` namespace and confirm that the resource is created successfully.
