# CKAD Scenario 3: Jobs & CronJobs

## **Context**

A team needs to automate periodic log cleanup and report generation tasks in their cluster using Kubernetes `CronJobs`.

## **Task**

Perform the following setup in the `qa-namespace` namespace (create the namespace if it does not exist).

## **Requirements**

- **CronJob**
  - Name: `report-generator`
  - Namespace: `qa-namespace`
  - Schedule: every 5 minutes (`*/5 * * * *`)
  - Successful Jobs History Limit: `4`
  - Failed Jobs History Limit: `2`
  - Concurrency Policy: `Forbid`
- **Pod template**
  - Container name: `report-worker`
  - Image: `busybox:1.36`
  - Command: `sh`, `-c`, `echo "Generating report at $(date)"`
  - Restart policy: `OnFailure`

## **Validation**

Create a manual test run of the `CronJob` to confirm that the job completes successfully.
