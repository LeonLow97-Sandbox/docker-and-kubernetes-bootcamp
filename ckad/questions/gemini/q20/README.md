# CKAD Scenario 20: Init Containers & Sequential Startup

## **Context**

An application requires database schema setup or initialization tasks to complete before the main application container starts running. You need to configure a Pod with an `initContainer` that performs a setup step and passes data to the main container using an `emptyDir` volume.

## **Task**

Perform the following setup in the `init-space` namespace (create the namespace if it does not exist).

## **Requirements**

- **Namespace setup**
  - Create a namespace named `init-space`.

- **Storage**
  - Use an `emptyDir` volume named `config-vol`.

- **Init Container**
  - Name: `init-config`
  - Image: `busybox:1.36`
  - Command: `sh`, `-c`, `echo "env=production" > /config/app.env`
  - Mount path: `/config` (using `config-vol`)

- **Main Container**
  - Name: `web-app`
  - Image: `nginx:1.25`
  - Mount path: `/etc/app-config` (using `config-vol`)

- **Pod**
  - Name: `init-pod`
  - Namespace: `init-space`

## **Validation**

Verify that the `initContainer` completes successfully and that `/etc/app-config/app.env` inside the `web-app` container contains `env=production`.