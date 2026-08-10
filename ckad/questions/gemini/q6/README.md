# CKAD Scenario 6: Persistent Volume (PV), Persistent Volume Claim (PVC), and Pod Mounting

## **Problem Statement**

You need to configure persistent storage for an analytical application in the `storage-space` namespace.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `storage-space`.
- **PersistentVolume (PV)**
  - Name: `app-pv`
  - Capacity: `1Gi`
  - Access mode: `ReadWriteOnce`
  - Storage class name: `manual`
  - Host path: `/mnt/data`
- **PersistentVolumeClaim (PVC)**
  - Name: `app-pvc`
  - Namespace: `storage-space`
  - Request capacity: `1Gi`
  - Access mode: `ReadWriteOnce`
  - Storage class name: `manual`
  - Ensure the PVC binds successfully to `app-pv`.
- **Pod**
  - Create a Pod named `storage-pod` in `storage-space` using the image `nginx:1.25`.
  - Mount the PVC `app-pvc` at `/var/www/html` inside the container.

## **Validation**

Verify that the PVC status is `Bound` and that the volume is mounted inside `storage-pod`.
