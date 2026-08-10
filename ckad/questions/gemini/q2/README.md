# CKAD Scenario 2: ConfigMaps, Secrets & Deployments

## **Context**

A web application needs to consume database credentials from a `Secret` and application configuration settings from a `ConfigMap`.

## **Task**

Perform the following setup in the `app-space` namespace (create the namespace if it does not exist).

## **Requirements**

- **Secret**
  - Name: `db-secret`
  - Namespace: `app-space`
  - Data: `DB_Password = super-secret-123`
- **ConfigMap**
  - Name: `app-config`
  - Namespace: `app-space`
  - Data:
    - `APP_COLOR = blue`
    - `APP_MODE = live`
- **Deployment**
  - Name: `webapp-dep`
  - Namespace: `app-space`
  - Replicas: `2`
  - Container name: `webapp-container`
  - Image: `nginx:1.25`
- **Environment variables**
  - Map the Secret key `DB_Password` from `db-secret` to an environment variable named `DB_PASS`.
  - Inject all keys from `app-config` as environment variables into the container using `envFrom`.

## **Validation**

Once the deployment is running, verify that the following command shows the expected values:

```sh
kubectl exec -n app-space deployment/webapp-dep -c webapp-container -- env
```

Expected values include:

- `DB_PASS=super-secret-123`
- `APP_COLOR=blue`
- `APP_MODE=live`
