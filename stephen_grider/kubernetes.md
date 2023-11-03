## Kubernetes (K8s)

### What is Kubernetes?

<img src="./diagrams/kubernetes-1.png" />
<img src="./diagrams/kubernetes-2.png" />

- Kubernetes is a system for running many different containers over multiple different machines / virtual machines.
- Use kubernetes when we need to scale up our application and run many different containers with different images.
- Previously, to scale up using Elastic Beanstalk, EB creates multiple sets of containers instead of the single container that is needed to scale up due to increase traffic. More machines, but little control over what each one was doing.
- `worker` service in our project is doing the hard computational work that takes time. 
    - Kubernetes can scale the number of containers (or pods) for a specific service or workload across multiple nodes (virtual machines) in a cluster.
    - Can use kubernetes to scale the `worker` service horizontally by running multiple containers of the `worker` service on a single virtual machine (node) or across multiple nodes in your cluster.
- Kubernetes typically runs on a cluster of multiple nodes (physical or virtual machines), allowing you to distribute workloads and enhance redundancy.

### kubectl and minikube

<img src="./diagrams/kubernetes-3.png" />

- kubectl
    - tell a virtual machine or node what set of containers it should be running and manage what the node is doing.
    - used locally and production
- minikube
    - development kubernetes cluster
    - to create and run a kubernetes cluster on local machine