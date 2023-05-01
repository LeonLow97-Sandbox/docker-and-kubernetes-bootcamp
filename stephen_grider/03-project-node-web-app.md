# Building a web app using NodeJS

## NodeJS in Docker Hub

- [Node in Docker Hub](https://hub.docker.com/_/node)
- alpine with node `FROM node:14-alpine`
    - includes commands like `npm` and `node`.

## Copying Build Files into Docker container

- `COPY ./ ./`
    - Source: Path to folder to copy from on *local machine* relative to build context.
    - Destination: Place to copy stuff to inside *the container*.
    - `./`: current working directory

## Docker Run with Port Mapping

- Map request on port 8080 to container network port 8080.
- `docker run -p 8080:8080 <image_id>`
    - First 8080 (host port): Route incoming requests to this port on localhost to ...
    - Second 8080 (container port): ...this port inside the container. (incoming request is redirected to port 8080 in the container)
- `docker run -p 5000:8080 leon/simplenodewebapp`
    - can also be another port

## Specifying a Working Directory in Container

- `docker run -it leon/simplenodewebapp sh`
    - `ls`
    - Copied files into root project directory in the container (messy).
    ```
    Dockerfile         lib                package.json       sys
    bin                media              proc               tmp
    dev                mnt                root               usr
    etc                node_modules       run                var
    home               opt                sbin
    index.js           package-lock.json  srv
    ```
    - Creating working directory of the container
        - `WORKDIR /usr/app`

## Running `npm install` due to small changes.

```dockerfile
# Copy build files into the Docker container
COPY ./ ./

# install dependencies into node_modules
RUN npm install
```

- When the code in index.js changes, the npm install command is ran to install the node_modules again. Thus, `npm install` is always going to run whenever we make a small change (time-consuming and unnecessary).

```dockerfile
# Solution
# Copy package.json into the curernt working directory of the contianer
COPY ./package.json ./

# install dependencies into node_modules (runs only if the previous steps changes)
RUN npm install

# copy over everything else (index.js)
COPY ./ ./
```

