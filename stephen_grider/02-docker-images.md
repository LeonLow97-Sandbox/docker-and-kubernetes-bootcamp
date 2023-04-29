# Images

## Creating our own Image

1. Dockerfile

- Configuration to define how our container should behave.

2. Docker Client
3. Docker Server
4. Usable Image

### Additional Configuration to Docker Desktop

- Disable Docker buildkit
  - Docker desktop --> settings --> Docker Engine --> Change JSON {"buildkit": false}

## Creating a `Dockerfile`

1. Specify a base image
2. Run some commands to install additional programs
3. Specify a command to run on container startup

- To run Dockerfile, `docker build .`

```go
// Dockerfile:

FROM alpine
RUN apk add --update redis // apk add .. is an alpine command not Docker
CMD ["redis-server"]
```

## What is a Base Image?

- A base image is the starting point for creating new Docker images.
- It is a read-only image that contains a minimal operating system such as Alpine, Linux or Ubuntu, along with some pre-installed software packages and libraries.
- In Dockerfile, we create our own custom base images by starting with an existing base image and adding our own customizations.

### Why did we use alpine as a base image?

- They comes with a preinstalled set of programs that are useful to us.
