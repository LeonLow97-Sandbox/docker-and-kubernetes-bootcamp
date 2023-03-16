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

```
Dockerfile:

FROM alpine
RUN apk add --update redis
CMD ["redis-server"]
```

## What is a Base Image?

- 