# Images

## Creating our own Image

1. Dockerfile

- Configuration to define how our container should behave.
- `docker build .`: passing Dockerfile to Docker CLI.

2. Docker Client
3. Docker Server
4. Usable Image

### Additional Configuration to Docker Desktop

- Disable Docker buildkit
  - Docker desktop --> settings --> Docker Engine --> Change JSON {"buildkit": false}
  - Disabling buildkit can provide more detailed logs for debugging.

## Creating a `Dockerfile`

1. Specify a base image
2. Run some commands to install additional programs
3. Specify a command to run on container startup

- To run Dockerfile, `docker build .`

```Dockerfile
# Dockerfile
# alpine base image
FROM alpine

# apk add .. is an alpine command not Docker
# apk is a package manager built inside alpine image
RUN apk add --update redis

CMD ["redis-server"]
```

## What is a Base Image?

- A base image is the starting point for creating new Docker images.
- It is a read-only image that contains a minimal operating system such as Alpine, Linux or Ubuntu, along with some pre-installed software packages and libraries.
- In *Dockerfile*, we create our own **custom base images** by **starting with an existing base image and adding our own customizations**.

## Why did we use alpine as a base image?

- Small size: Alpine is designed to be lightweight and has a small footprint compared to other Linux distributions.
- Security: Alpine has a strong focus on security and is designed to be hardened against vulnerabilities and attacks.
- Package management: Uses the `apk` package manager to manage and install packages.
- Preinstalled packages: Comes with a preinstalled set of programs that are useful for common use cases such as networking, debugging and monitoring.
- Compatibility: Compatible with most Linux software and libraries, making a good choice for running applications that were designed to run on other Linux distributions.

## Dockerfile build process (`docker build .`)

- `FROM alpine`:
  - Starts by downloading the Alpine Linux base image from the Docker registry.
- `RUN apk add --update redis`
  - Get image from previous step
  - Create a container out of it.
  - Run `apk add --update redis` in the container which modifies the container file system.
  - Take snapshot of that container's filesystem.
  - Shut down that temporary container.
  - Get image ready for next instruction (image layer).
- `CMD ["redis-server"]`
  - Get image from previous step
  - Create a container out of it.
  - Tell container it should run `redis-server` when started which modifies the primary command of the container.
  - Shut down that temporary container
  - Get image ready for next instruction.
- Output is the image generated from the previous step.

## Adding a tag to the image

- `docker build -t leon/redis:latest .`
  - Docker ID: `leon`
  - Repo/Project name: `redis`
  - Version (tag): `latest`
- `docker run leon/redis` or `docker run leon/redis:latest`

