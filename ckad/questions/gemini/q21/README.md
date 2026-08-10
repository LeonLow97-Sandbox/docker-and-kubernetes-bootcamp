# CKAD Scenario 21: OCI / Docker Image Creation & Optimization

## **Context**

A development team needs to containerize a lightweight script application and build an OCI/Docker container image locally on the node before deploying it to Kubernetes.

## **Task**

Create a Dockerfile and build a container image according to the specification below in the directory `/tmp/app-build` (create the directory if it does not exist).

## **Requirements**

1. **Directory Setup**
   - Working directory: `/tmp/app-build`
   - Create a script named `entrypoint.sh` inside `/tmp/app-build` with the content:
     ```sh
     #!/bin/sh
     echo "Application running..."
     ```
   - Ensure `entrypoint.sh` is executable (`chmod +x /tmp/app-build/entrypoint.sh`).

2. **Dockerfile Definition**
   - Create a file named `/tmp/app-build/Dockerfile`:
     - Base image: `alpine:3.19`
     - Set the working directory to `/app`.
     - Copy `entrypoint.sh` into `/app/entrypoint.sh`.
     - Set the default command/entrypoint to execute `/app/entrypoint.sh`.

3. **Image Build**
   - Build the container image using `docker build` or `podman build` from `/tmp/app-build`.
   - Tag the resulting image as `custom-app:1.0`.

## **Validation**

Verify the built image exists using `docker images custom-app:1.0` or `podman images custom-app:1.0`.