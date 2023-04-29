# Theory of Docker

## Why use Docker?

- Docker makes it really easy to install and run software without worrying about setup or dependencies.

## What is Docker?

- Docker is a platform or ecosystem around creating and running containers.
- Docker Ecosystem
  - Docker Client, Docker Server, Docker Machine, Docker Images, Docker Hub, Docker Compose.

## Image vs Container

- **Image**: Single file with all the dependencies and config required to run a program.
- **Container**: Instance of an image. Runs a program.

## Docker Tools

- **Docker Client (Docker CLI)**: Tool that we are going to issue commands to
- **Docker Server (Docker Daemon)**: Tool that is responsible for creating images, running containers, etc.

<img src="./pics/docker-architecture.svg" />

## Basic Commands

```docker
// Checking Docker Version
docker version
```

## Understanding `docker run hello-world` command

- `docker run hello-world`: start up a Docker container using the 'hello-world' image.

1. Starts up Docker Client or Docker CLI
2. Docker Client communicates with Docker Server
3. Docker Server checks locally of the hello-world image in the image cache in the local machine.
4. If image cache is empty, Docker Server reaches out to Docker Hub. Docker Hub is a repo with free images where you can download images to your local machine.
5. Docker Server then stores this image in your local cache.
6. Docker Server uses the image to create a container which is an instance of the image.

## Image and Container In-Depth

- A container is a set of isolated processes and resources.
- An **image is a read-only template** for creating containers.
- When you start a **container** based on an image, a new **writable layer is added on top of the image's read-only filesystem** to serve as the container's working directory.
- The container inherits the kernel resources of the host operating system, which are shared among all containers running on the same host.
- Image is like a file system snapshot.
  1. Kernel allocates a section of the hard drive to the container.
  2. Create a new instance of the container based on the image.

## How is Docker Running on your computer?

- When Docker is installed on Windows or macOS, Docker installs a small Linux virtual machine called the Docker Engine on the host machine.
- The Docker Engine is responsible for managing the containers and uses features of the Linux kernel such as namespaces and control groups to isolate the containers from the host and from each other.
- The Linux kernel limits access to different hardware resources on your computer.
- By running `docker version`, we see that the OS is the Linux kernel being used by Docker Engine, and not necessarily the same Linux distribution that is running on the host machine.