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

- `docker version` find the version of docker
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
- `docker run --name <container_name> -d <image_name>` specifying a name for the container

## `docker run` commands

- `docker run redis` no tag specified, docker defaults tag to `latest`, so this command is similar to `docker run redis:latest`
- `docker run redis:4.0` tagging the image to run other versions of redis
- `docker run -it <image_name>` to enter STDIN input to the Docker container
- `docker run -p 80:5000 <image_name` map from outside port 50 to the port 80 in Docker host
- Volume Mapping / Bind Mount
  - `docker stop mysql` and `docker rm mysql` removes all the persistent data that was stored in the file system of the Docker container. This causes you to lose all the data because the container is removed.
  - `docker run -v /opt/datadir:/var/lib/mysql mysql` creates volume mapping or bind mount. The directory `/opt/datadir` on your host machine should be mounted into the container at `/var/lib/mysql`. This allows data written to `/var/lib/mysql` within the container to be persisted on your local machine at `/opt/datadir`. The data inside `/opt/datadir on your host machine is separated from the container and persists even if the container is removed.
- `docker inspect <container_name>` to view more details about the container, retains in a JSON format
- `docker logs <container_name>` to view the logs of the container
- `docker run -d <image_name>` running container in detach mode
- `docker attach <container_name>` going from detach to attach mode
- `docker inspect <container_name>` to retrieve the container IP Address
  - `docker run -p 8080:8080 <image_name>` to set up host port
  - http://172.17.0.2:8080
- use volumes to persist data in jenkins
  - `docker run -p 8080:8080 -v /root/my-jenkins-data:/var/jenkins_home -u root jenkins/jenkins`

---

### Container with Multiple Ports Published

```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                           NAMES
8d36839cbc71   nginx:alpine   "/docker-entrypoint.…"   39 seconds ago   Up 37 seconds   0.0.0.0:3456->3456/tcp, 0.0.0.0:38080->80/tcp   vigilant_thompson
```

- For example `0.0.0.0:3456->3456/tcp`, this port mapping means that the container's port `3456` is mapped to the same port `3456` on the host machine. This allows any traffic sent to `0.0.0.0:3456` on the host to be forwarded to the container's port `3456`.
- In the case of a web server like Nginx (`nginx:alpine`), you can access the server from a web browser using either `http://localhost:3456` or `http://localhost:38080`, depending on which port you prefer to use for communication with the containerized Nginx Server.

---
