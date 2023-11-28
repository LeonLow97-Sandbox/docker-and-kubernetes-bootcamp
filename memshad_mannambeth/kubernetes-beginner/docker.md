# Docker

## Docker Overview

- **Why do you need containers?**
  - Compatibility / Dependency
    - Compatibility with the underlying operating system, certain versions might not be compatible with the OS
    - Compatibility between the services (e.g., Node, Mongo, Redis), the libraries and the dependencies on the OS. For example, one service requires v1 of a dependent library and another service required v2.
    - We always end up checking the compatibility of these various components and the underlying infrastructure. (BAD!)
  - Long setup time
  - Different Dev/Test/Prod environments
- **What can containers do?**
  - Containerize Applications
  - Docker can run each component (E.g., Web Server, Database, Messaging) in a separate container with its own libraries and its dependencies, all on the same VM and the OS, but within separate environments or containers.
- **What are containers?**
  - Docker utilizes LXC containers.
  - Containers are completely isolated environments.
  - They can have their own processes or services, networking interfaces, mounts (just like virtual machines) that share the same operating system kernel.

### Operating System

- If we look at operating systems like Ubuntu, Fedora, Suse or CentOS, they consist of an **OS Kernel and a set of software**. 
- The operating system kernel is responsible for interacting with the underlying hardware, while the OS Kernel remains the same, which is Linux.
- The software above the OS Kernel (e.g., Ubuntu) makes these operating systems different. The software may consist of different user interface drivers, compilers, file managers, developers tools, etc.
- There is a common Linux Kernel shared across all operating systems and some custom software that differentiates operating systems from each other.
- **Docker containers share the underlying kernel**
    - For example, we have a system with an Ubuntu OS with Docker installed on it and Docker can run any OS on top of it as long as they are based on the same Kernel (Linux).
    - If the underlying operating system is Ubuntu, Docker can run a container based on another distribution like Debian, Suse or CentOS.
    - Docker utilizes the underlying kernel of Docker host, which works with all the operating systems above.
- What is an OS that does not share the same OS Kernel (Linux)?
    - Windows.
    - You won't be able to run a Windows based container on a Docker host with Linux OS on it. For that you would require *Docker on a Windows Server*.
    - Is it a disadvantage for not being able to run another kernel on the OS? No. Unlike Hypervisors, Docker is not meant to virtualize and run different Operating Systems and Kernels on the same hardware.
    - The main purpose of Docker is to containerize applications, to ship and run them.
- **Differences between Virtual Machines and Containers**
    - For Docker, we have the underlying hardware infrastructure, operating system and Docker installed on the OS.
    - Docker can then manage the containers that run with libraries and dependencies alone.
    - For Virtual Machines, we have the underlying hardware, hypervisor like ESX or virtualization of some kind. 
        - Each virtual machine has its **own operating system** inside it, the dependencies and the application.
        - This overhead causes higher utilization of underlying resources as there are multiple virtual operating systems and kernels running.
        - The virtual machines also consume higher disk space as each VM is heavy and is usually GB in size.
    - Docker containers are lightweight and are usually MB in size.
    - Docker containers boot up faster, usually in a matter of seconds, whereas virtual machines, takes minutes to boot up as it needs to boot up the entire operating system.
    - Docker has less isolation as more resources are shared between containers like the OS Kernel, whereas VMs have complete isolation from each other. Since VMs don't rely on the underlying operating system or kernel, you can have different types of operating systems such as Linux based or Windows based on the same hypervisor, whereas it is not possible on a single Docker Host.

### Docker Registry

- Many containerized versions of applications are available in a public Docker Registry called Docker Hub or Docker Store.
- For example, can find images of most common operating systems, databases, other services and tools.
- Once you identify the images you need, you install Docker on your host, Bringing up an application stack by running `docker run <image_name>`
  - Running a docker run Ansible command will run an instance of Ansible on the Docker host.
  - Running an instance of MongoDB, Redis and NodeJS using docker run command.
- If you need to run multiple instances of the web service, then simply add as many instances as you need and configure a load balancer. If one of the instances fail, destroy that instance and launch a new instance.
- Can create a public image yourself and push to Docker Hub repository.

### Images vs Containers

- An image is a package or a template.
- Images are used to create 1 or more containers.
- Containers are running instances of images that are isolated and have their own environments and set of processes.

### Traditional Deployment of Applications

- Traditionally, developers develop application and they hand it over to Ops team to deploy and manage it in production environments.
- Developers provide a set of instructions, such as information about how the host must be set up, what prerequisites are to be installed on the host, and how the dependencies are to be configured, etc.
- The Ops team uses this guide to set up the application. Since the Ops team did not develop the application on their own, they struggle with setting it up. When they hit an issue, they work with their developers to resolve it.
- With Docker, a large portion of work involved in setting up the infrastructure is now in the hands of the developers in the form of a `Dockerfile`.
  - `Dockerfile` is used to create an image for the application
- The Ops team can simple use the image to deploy the application. 
- Since the image was already working when the developer built it and operations are not modifying it, it continues to work the same way then deployed in production. 

