## Docker

- Why do you need Docker?
    - Compatibility/Dependency
    - Long setup time
    - Different Dev/Test/Prod environments
- Docker containers all share the same OS Kernel but they have their own processes, networks and mounts. 
- Docker makes use of LXC Containers.
- Operating system consists of OS Kernel and a set of software
    - OS Kernel is responsible for interacting with the underlying hardware. OS Kernel remains the same and it is Linux
    - The software is what makes the operating systems different. The software may contain different user interface, driver, compiler, file managers, etc.
- For example, if the host OS is Ubuntu, Docker allows you to run containers with different operating systems or distributions like CentOS, Fedora, or even multiple versions of Ubuntu itself within those containers.
- However, Windows does not share the same OS Kernel with Linux so we cannot run a Windows-based container on a Docker host with Linux on it. Can only run Docker container on a Windows server.
    - If you install Docker on Windows and run a Linux container on Windows, you are not really running a Linux container on Windows. Windows runs a Linux container on a Linux Virtual Machine under the hood. 
- Containers vs Virtual Machines
    - Each virtual machine has its own OS, higher overhead and higher disk space (in GB). Takes a long time to boot up because it has to boot up its own operating system. Complete isolation from each other.
    - Each container shares the same underlying OS, lower overhead and lower disk space (in MB). Faster boot up time.
    - Can combine both Containers and Virtual Machines
- Docker Image vs Container
    - Image is a package, template or a plan.
    - Containers are running instances of images and have their own set of processes.

## Docker Commands

- `docker run nginx` start a container
- `docker ps` list running containers
- `docker ps -a` list running containers and containers previously stopped
- `docker stop <container_name>` stop a container
- `docker rm <container_name` remove a container, it returns the container name if successfully removed container
- `docker images` list images
- `docker rmi <image_name>` remove images after deleting all dependent containers on that image
- `docker pull nginx` downloads the image but does not start the container
- `docker run ubuntu` container exits because ubuntu is just an operating system and it is not a running process. Container exits when there is no running process.
    - `docker run -d ubuntu sleep 200` let the container run and sleep for 200 seconds and not exit
- `docker exec <container_name> <command>` execute command on a running container, e.g., `docker run ubuntu bash -c "cat /etc/*release*"`
- Run - Attach and Detach
    - `docker run <image_name>` attach mode
    - `docker run -d <image_name>` detach mode, container continues to run in the background
    - `docker attach <container_id>` going from detach mode to attach mode
