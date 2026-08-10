# CKAD Scenario 13: Container Logging and Multi-Container Troubleshooting

## **Context**

Application monitoring in the `logging-space` namespace requires aggregating application output and investigating log outputs directly from pods using `kubectl` filtering flags.

## **Requirements**

- **Namespace setup**
  - Create a namespace named `logging-space`.
- **Multi-container pod creation**
  - Create a Pod named `counter-pod` in `logging-space`.
  - Container 1:
    - Name: `count-app`
    - Image: `busybox:1.36`
    - Command: `["sh", "-c", "i=0; while true; do echo \"APP LOG: $i\"; i=$((i+1)); sleep 2; done"]`
  - Container 2:
    - Name: `count-sidecar`
    - Image: `busybox:1.36`
    - Command: `["sh", "-c", "i=0; while true; do echo \"SIDECAR LOG: $i\"; i=$((i+1)); sleep 2; done"]`
- **Log extraction tasks**
  - Extract the latest `5` lines from the `count-app` container and save them to `/tmp/count-app.log`.
  - Extract the logs from the `count-sidecar` container generated in the last `30 seconds` and save them to `/tmp/count-sidecar.log`.

## **Validation**

Display the contents of `/tmp/count-app.log` and `/tmp/count-sidecar.log`.
