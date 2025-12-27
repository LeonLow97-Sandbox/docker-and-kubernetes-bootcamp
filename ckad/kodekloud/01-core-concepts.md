# Core Infrastructure

## Nodes and Clusters

<p align="center">
    <img src="./diagrams/01-k8s-cluster.png" width="50%">
</p>

- **Nodes**: A node is the basic unit of a Kubernetes cluster; it is a physical or virtual machine where Kubernetes is installed. These are the **worker machines** where your containers are actually launched and run.
- **Clusters**: A cluster is a **group of nodes** working together. By grouping nodes, Kubernetes ensures that if one machine fails, your application remain accessible because it can run on the other nodes.
- **Redundancy and Load**: Beyond fixing failures, having multiple nodes allows the system to share the workload across different machines.

## The Master Node: The Control Plane

<p align="center">
    <img src="./diagrams/01-master-worker.png" width="50%">
</p>

- **Role of the Master**: The master is a specific node that **watches over the worker nodes** and is responsible for the orchestration of containers.
- **API Server**: This acts as the **frontend** of the Kubernetes cluster. All users, management devices and command-line tools talk to the API server to interact with the system.
- **etcd Keystore**: This is a distributed, reliable **key-value store**. It stores all the data needed to manage the cluster and implements "locks" to ensure there are no conflicts between multiple masters.
- **Scheduler**: The scheduler is responsible for **distributing work**; it looks for newly created containers and decides which node they should be assigned to.

## The Worker Node: The Execution Plane

- **Kubelet**: This is an **agent that runs on every node** in the cluster. Its job is to ensure that containers are running as expected and to report the health of the worker node back to the master.
- **Container Runtime**: This is the underlying software required to actually **run the containers**. While **Docker** is a common choice, other alternatives include *Rocket* or *Cri-o*.

## Managing the Cluster with `kubectl`

- `kubectl` Utility: Also known as "kube control", this is a **command-line tool** used to deploy and manage applications and inspect the cluster.
- Essential Commands:

```sh
kubectl run             # used to deploy an application on the cluster
kubectl cluster-info    # used to view the status and information of the cluster
kubectl get nodes       # used to list all the nodes that are part of the cluster
```

## Analogy for Understanding

Think of a Kubernetes cluster like a **large professional kitchen**. The **Master Node** is the **Head Chef** (or Manager) who stays in the office, looks at the orders (API Server), decides which cook should handle which dish (Scheduler), and monitors the kitchen to make sure no one has quit or burned a meal (Controller). The **Worker Nodes** are the **individual cooking stations**. Each station has a **Kubelet** (the station lead) who ensures the food is actually being cooked and reports back to the Head Chef. The **Container Runtime** is the actual **stove or oven** used to cook the food.

# Docker vs CRI

## The Evolution: From Docker to CRI

- **The Early Days**: Initially, Kubernetes and Docker were **tightly coupled**; Kubernetes was built specifically to orchestrate Docker and did not support other container tools.
- **Container Runtime Interface (CRI)**: As other tools emerged, Kubernetes introduced the **CRI**, a standard interface that allows any vendor's runtime to work with Kubernetes, provided they follow specific standards.
- **OCI Standards**: To ensure compatibility across the industry, the **Open Container Initiative (OCI)** established specifications for how images should be built (**Image Spec**) and how runtimes should be developed (**Runtime Spec**).
- The **"Docker Shim"**: Because Docker was created before the CRI, Kubernetes used a temporary "hack" called **Docker Shim** to keep it compatible. However, this was removed in **version 1.24**, meaning Docker is no longer a supported runtime.
- **Image Compatibility**: Even though Docker is no longer the runtime, **Docker Images still work** because they follow the OCI Image Spec.

## Containerd: The Modern Runtime

- **What is it?**: Containerd is the internal component of Docker that handles the container runtime.
- **Independence**: It is now a standalone project within the **Cloud Native Computing Foundation (CNCF)** and can be installed without the full Docker suite.
- **Kubernetes Integration**: Because containerd is **CRI compatible**, it can work directly with Kubernetes without the need for the old Docker shim.

## Essential Command-Line Tools (CLI)

When managign these environments, you will encounter 3 main tools, each with a different purpose:

- **ctr (Ctor)**
    - This comes with containerd but is **solely for debugging**.
    - It is not user-friendly, has limited features, and should not be used for managing containers in production.
- **nerdctl (Nerd Control)**
    - This is a **general-purpose CLI** that acts like a "Docker-like" tool for containerd.
    - It supports most Docker commands and adds advanced features like **image signing** and **lazy pulling**.
- **crictl (CRI Control)**
    - Maintained by the Kubernetes community, this tool works across **any CRI-compatible runtime** (not just containerd).
    - It is used for **inspecting and debugging** the runtime from a Kubernetes perspective.
    - **Pod Awareness**: Unlike Docker, `crictl` is "pod-aware", meaning it can list and manage Kubernetes pods directly.
    - **Warning**: You should not use `crictl` to create containers in production because the Kubelet may delete them if it doesn't recognize them.

## Analogy for Understanding

Think of the **CRI** as a **universal power socket**. In the beginning, Kubernetes only had a "Docker-shaped" plug. When other tools wanted to join, Kubernetes created a **universal adapter (the CRI)**. As long as every appliance follows the same safety standards (**OCI**), they can all plug in. **Containerd** is like a modern, efficient motor that fits that socket perfectly, while **nerdctl** and **crictl** are the different remote controls used to check on or operate that motor.
