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
  - A container exits if the process inside it crashes or stops. Thus `docker run ubuntu` will exit immediately because a container is not meant to run an OS.

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

## docker images

- `docker build . -f Dockerfile -t leonlow/my-app` building the image with dockerfile and tagging the image
- `docker push leonlow/my-app` push image to Docker registry like Docker Hub
- builds the image layer by layer in the Dockerfile
- layers that were built are cached by Docker, thus rebuilding the image is faster
  1. Base Ubuntu Layer (OS)
  1. Changes in apy packages
  1. Changes in pip packages
  1. Source code
  1. Update entrypoint with "flask" command
- building image with Dockerfile
  - `docker build .` inside `flask-image` directory
  - `docker build . -t flask-app` tagging image
  - `docker run -p 3000:3000 flask-app`
- Pushing image to registry
  - `docker login` login to docker hub registry
  - `docker push leonlow/flask-app` push image to docker hub

## Environment Variables

- `docker run -e APP_COLOR=blue <image_name>` set an environment variable to the container
- `docker inspect <container_name>` to find the environment variable running on the container

## Command vs Entrypoint

- `CMD` program that runs within the container

  - `docker run ubuntu [COMMAND]` like `docker run ubuntu sleep 5`
  - Can also create a Dockerfile to run the `sleep 5` command but as you can see, the number of seconds specified is hardcoded to be 5.

  ```dockerfile
  FROM ubuntu

  CMD sleep 5
  ```

- `ENTRYPOINT`

  - docker run ubuntu-sleeper 10
  - If not specified like this `docker run ubuntu-sleeper`, this throws an error.

  ```dockerfile
  FROM ubuntu

  ENTRYPOINT ["sleep"]
  ```

  - Thus, we need to add a default number of seconds. Combine both `ENTRYPOINT` and `CMD` together

  ```dockerfile
  FROM ubuntu

  # final command --> sleep 5
  ENTRYPOINT ["sleep"]
  CMD ["5"]
  ```

## docker compose

- Configuration in YAML file
- Run multiple containers at once to bring up the entire application stack
- Runs on a single Docker Host
- Without `docker-compose`,
  - we use `docker run` but the containers are not linked together.
  - use `docker run --links` to link the containers but this might be deprecated in future

```
docker run -d --name=redis redis
docker run -d --name=db postgres
docker run -d --name=vote -p 5000:80 --link redis:redis voting-app
docker run -d --name=result -p 50001:80 --link db:db result-app
docker run -d --name=worker --link db:db --link redis:redis worker
```

- With docker-compose.yml

```yaml
version: 3

services:
  redis:
    image: redis
  db:
    image: postgres:9.4
  vote:
    image: voting-app
    ports:
      - '5000:80'
    depends_on:
      - redis
  result:
    image: result-app
    ports:
      - '5001:80'
    depends_on:
      - db
  worker:
    image: worker
    depends_on:
      - redis
      - db
```

- `docker-compose` commands
  - `docker-compose up` to bring up the services
  - `docker-compose --build`

```yaml
# Using a pre-built image from the registry named "voting-app"
vote:
  image: voting-app

# Building the image using the Dockerfile in the specified directory "./vote"
vote:
  build: ./vote
```

- `docker compose` versions

```yaml
version: 3
```

- Networks in `docker compose`

```yaml
version: 3
services:
  redis:
    image: redis
    networks:
      - back-end
  db:
    image: postgres:9.4
    networks:
      - back-end

  vote:
    image: voting-app
    networks:
      - front-end
      - back-end
  result:
    image: result
    networks:
      - front-end
      - back-end

networks:
  front-end:
  back-end:
```

## Networking in Docker Compose

- When you define services in a `docker-compose.yml` file and bring them up using `docker-compose up`, all services by default are connected to the **same Docker network**, which allows them to communicate with each other using their **service names**.
- The DNS Resolution via service names helps in simplifying inter-service communication without the need to manage IP addresses directly.

---

- References:
  - https://docs.docker.com/compose/
  - https://docs.docker.com/engine/reference/commandline/compose/
  - https://github.com/dockersamples/example-voting-app

---

## Docker Registry

- Docker Registry
- Docker Engine interacts with Docker Hub (registry) by default
- Central repository for images
- `image: nginx` is actually `image: nginx/nginx`
  - `user/repository` or `image/repository`
  - default registry if not specified is docker hub, e.g., `image: docker.io/nginx/nginx`
- Private Registry
  - `docker login private-registry.io` login to private registry
  - `docker run private-registry.io/apps/internal-app`
- Deploy Private Registry (the private registry is localhost:5000)
  1. `docker run -d -p 5000:5000 --name registry registry:2` deploying a docker registry container, can specify `--restart always` so that the container automatically restarts if it stops for any reason.
  1. `docker tag my-image localhost:5000/my-image` tag images for the registry
  1. `docker push localhost:5000/my-image` pushing image to private registry
  1. `docker pull localhost:5000/my-image` pull image from private registry using localhost
  1. `docker pull 192.168.56.100:5000/my-image` pull the image from the private registry using private ip

## Docker Engine

- Docker engine contains Docker Daemon, REST API and Docker CLI
- Docker Daemon manges Docker Objects like images, containers, networks
- REST API for talking to the Docker Daemon
- Docker CLI is used to run commands and it uses the REST API to interact with the Docker Daemon
- Containerization under the hood in Docker
  - Docker uses namespace to isolate workspace
    - Process ID, Network, InterProcess, Unix Timesharing and Mount are created in their own namespace, thereby providing isolation within their own containers.
    - Each namespace instance operates independently within its container, providing isolation from the host and other containers.
    - **PID Namespace**: Within a Linux system, there can be multiple processes running with their respective process IDs (PIDs). When Docker starts processes within a container, it begins with PID 1, PID 2 and so on, specific to that container's namespace. However, these PIDs do not directly correlate with PIDs on the host. They are isolated and managed within the container's PID namespace. The underlying Linux system creates new PIDs (like PIDs 4 and 5) to manage these processes within the container, but these new PIDs are separate from the host's PIDs.
- Control Groups
  - **Resource Allocation**: Control groups (cgroups) are used to manage and restrict the hardware resources (CPU, memory, disk I/O, etc.) allocated to each container. Docker allows users to specify resource constraints during container creation.
  - Use control groups to restrict the amount of hardware resources allocated to each container
  - `docker run --cpus=.5 ubuntu` limits container to use half a CPU core
  - `docker run --memory=100m ubuntu` limits container to memory of 100MB
- [Docker Runtime options with Memory, CPUs and GPUs](https://docs.docker.com/config/containers/resource_constraints/)
- Demo
  1. `docker run -d --rm -p 8888:8080 tomcat:8.0`
  1. `docker ps`
  1. `docker exec <container_id> ps -eaf` to view the running processes PID in the container and you should see the process `docker-java-home` in the container
  1. `ps -eaf | grep docker-java-home` to view the `docker-java-home` that is running on the underlying host

## Docker Storage

- File system
  - stored in `/var/lib/docker`
- Image layer is read only and container layer can read and write.
  - COPY-ON-WRITE
  - Deleting the container removes the changes made in the files in the container.
- Volumes
  - Volumes in Docker are used to manage persistent data and facilitate communication between containers and the host system.
  - `docker volume create data_volume` creates a folder inside the local docker directory, i.e., `/var/lib/docker/volumes/data_volume`
  - `docker run -v data_volume:/var/lib/mysql sql` mounting the volume to the container directory, data written to `/var/lib/mysql` inside the container will be stored on the Docker Host. If `data_volume` is not created on the Docker Host, it will automatically create.
  - `docker -v /data/mysql:/var/lib/mysql mysql` bind mount
    - `docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql`
- Docker uses storage drivers like AUFS, ZFS, BTRFS, Device Mapper, etc. to maintain this layered architecture. Docker chooses the storage driver based on the Operating System.

---

### Bind Mounting vs Volume Mounting

- Bind Mounting
  - In bind mounting, a specific file or directory on the host machine is mounted into a container.
  - Used when you want to provide direct access to a file or directory on the host within a container. Any changes made within the container are reflected on the host and vice versa.
  - `docker run -v /host/path:/container/path ...`
  - Advantages:
    - Immediate updates: changes made to file or directories on either the host or container are instantly visible to both
    - Suitable for **development**: useful during development when you need immediate feedback without rebuilding the container.
- Volume Mounting
  - Volumes are a way to persist data generated by and used by Docker containers.
  - Created and managed by Docker, volumes are a better choice for persistent data. They exist outside the lifecycle of a container and can be used by multiple containers simultaneously.
  - `docker run -v volume_name:/container/path ...`
  - Advantages:
    - Data persistence: volumes are separated from containers, sock even if a container is removed, the data within the volume persists.
    - Shared storage: volumes can be shared among multiple containers, making it easier to manage data across different services.
- Key Differences
  - **Lifecycle**: Bind mounts depend on the host filesystem and are directly affected by changes made on the host. Volumes are managed by Docker and persist independently of containers.
  - **Sharing**: Volumes can be shared among multiple containers, while bind mounts are limited to one container's use.
  - **Ease of use**: Bind mounts are simpler to set up and use, especially for quick changes and local **development**. Volumes provide a more structured and controlled environment for managing persistent data and is good for **production**

---
