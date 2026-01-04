# Multi-Container Pods

- **Decoupling Applications**: Instead of 1 giant, bloadted application, you break it into small, independent and reusable microservices.
- **Working Together**: Sometimes 2 different services need to be paired togeter (e.g., a web server and a log agent) to function correctly.
- **Shared Resources**: Containers in the same pod share:
    - **Lifecycle**: They are created and destroyed at the same time.
    - **Network**: They share the same network space and can communicate with each other using `localhost`.
    - **Storage**: They can access the same storage volumes without needing extra configuratino to talk to each other.
- **Configuration**: In a pod definition file, the `containers` section is an **array**, which allows you to list multiple containers in a single Pod.

## Design Patterns

<p align="center">
    <img src="./diagrams/03/03-multi-container-design-patterns.png" width="75%">
</p>

### Design Pattern 1: Co-located Containers

- **Definition**: This is the simplest form, where 2 or more containers run in a pod together throughout its entire lifecycle.
- **Startup Order**: There is **no ability to define which container starts first**; they all start together as elements in an array.
- **Use Case**: Use this when 2 services are highly dependent on each other but don't require a specific order to begin running.

### Design Pattern 2: Init Containers

- **Definition**: These are containers that run **initialisation steps** before the main application starts.
- **Behaviour**: An init container runs to completion and then terminates. The main applicaiton only starts **after** the init container has successfully finished its job.
- **Sequential Order**: You can have multiple init containers; they will run **one at a time in a specific order**.
- **Failure Handling**: If an init container fails, Kubernetes will **repeatedly restart the pod** until the init container succeeds.
- **Common Uses**: Waiting for a database to be ready, pulling code from a repository (e.g., `git clone`), or checking an external API.

### Design Pattern 3: Sidecar Containers

- **Definition**: A sidecar starts before the main app (like an init container) but **continues to run** for the entire life of the pod.
- **Implementation**: In modern Kubernetes, this can be achieved by using the init container approach with a restart polocy set to `Always`.
- **Advantage**: Unlike co-located containers, sidecars allow you to specify a **startup order**.
- **Common Use (Log Shipping)**: A "Filebeat" or logging agent starts before the app to capture startup logs and remains running to catch termination logs if the app crashes.

<p align="center">
    <img src="./diagrams/03/03-multi-container-elk-example.png" width="75%">
</p>

### Summary of Patterns

| Feature              | Co-located                    | Init Container              | Sidecar                       |
| -------------------- | ----------------------------- | --------------------------- | ----------------------------- |
| **Section in YAML**  | `spec.containers`             | `spec.initContainers`       | `spec.initContainers`         |
| **Order of startup** | No guaranteed order           | Strict sequential order     | Starts before the main app    |
| **Duration**         | Runs entire lifecycle         | Runs until task is complete | Runs entire lifecycle         |
| **Failure Effect**   | Restarts individual container | Restarts the entire Pod     | Restarts individual container |

### Analogy for Understanding

Think of a **Multi-container Pod** like a professional camera crew:
- Co-located Containers are like the Camera Operator and the Sound Engineer; they both need to be there for the whole shoot, and it doesn't matter who arrives first.
- Init Containers are like the Set Designer; they arrive first, build the set (run to completion), and then leave before the actors (the main app) arrive.
- Sidecar Containers are like the Safety Officer; they arrive before the actors to check the equipment but stay for the entire shoot to make sure everything remains safe until the very end.

# Readiness and Liveness Probes

## Understanding Pod Lifecycle vs Conditions

Before configuring probes, you must understand how Kubernetes views a pod's 'health':

- **Pod Status**: This is a high-level summary of where the pod is in its life (e.g., `Pending`, `ContainerCreating` or `Running`).
- **Pod Condition**: These are an array of true/false values that provide more detail, such as whether the Pod is `Scheduled`, `Initialized` or `Ready`.
- **The "Ready" Gap**: By default, Kubernetes assumes a pod is `Ready` as soon as its containers are created. However, many applications (like Jenkins) take time to "warm up" or initialise before they can actually handle traffic.

## Readiness Probes: "Am I Ready for Traffic?"

- **Purpose**: These ensure that a **Servce** does not send traffic to a pod until the applicaiton inside is actually prepared to handle it.
- **Scenario**: If you add a new pod to a deployment, the service might route traffic to it immediately. Without a readiness probe, users might hit a pod that is still booting up, leading to **service disruption**.
- **Outcome**: If the probe fails, the pod is **not terminated**, but its "Ready" condition is set to false, and the service stops sending it traffic.

## Liveness Probes: "Am I still Healthy?"

- **Purpose**: These detect if an application is still running but has become **unresponsive** (e.g., stuck in an infinite loop due to a bug).
- **Auto-Healing**: While Kubernetes automatically restarts crashed containers, it cannot detect an application that is technically "up" but "broken" without a liveness probe.
- **Outcome**: If a liveness probe fails, Kubernetes considers the container unhealthy, **destroys it**, and **recreates a new one** to restore service.

## How to Configure Probes (CKAD Essentials)

Both probes are configured in the pod definition file under the `spec.containers` section using 3 main methods:

- **HTTP GET**: Checks if a specific API path (e.g., `/ready`) returns a successful response.
- **TCP Socket**: Checks if a specific port (e.g., 3306 for a database) is open and listening.
- **Exec Command**: Runs a custom script inside the container; if the script exists with a code of 0, it is successful.

## Key Tuning Options

To avoid "flapping" or unnecessary restarts, you can fine-tune probes with these settings:

- `initialDelaySeconds`: How long to wait before performing the first probe (gives the app time to start).
- `periodSeconds`: How often to perform the probe (frequency).
- `failureThreshold`: How many times the probe can fail before Kubernetes takes action (defaults to 3).

## Summary Comparison

| Feature               | Readiness Probe                       | Liveness Probe                    |
| --------------------- | ------------------------------------- | --------------------------------- |
| **Primary Goal**      | Controls traffic flow via Services    | Controls container restarts       |
| **Action on Failure** | Pod is removed from Service endpoints | Container is killed and restarted |
| **Simple Question**   | "Can I start working yet?"            | "Am I still alive/functional?"    |

## Analogy for Understanding

Think of a **Readiness Probe** like a **"Closed/Open" sign** on a shop door; even if the lights are on (the container is running), customers (traffic) won't enter until the staff is ready. Think of a **Liveness Probe** like a **Health Monitor** on a machine; if the machine stops moving even though the power is on, the monitor triggers a **Hard Reset** to try and fix the jam.
