# Manipulating Containers with Docker Client

## Creating and Running a Container from an Image

- `docker run <image_name> override_command`
```
docker - reference the Docker Client
run - Try to create and run a container
image_name - name of image to use for this container
command - default command override

`docker run <image_name>`
`docker run busybox echo hi there` // output: hi there
`docker run busybox ls` // lists all the files inside the container
`docker run hello-world ls` // returns error because there were no executable `ls` or `echo` commands that exists inside the file system.
```

## To list the running containers

```
docker ps
docker ps --all // view all containers
docker ps -a // view all containers

// To view running container
docker run busybox ping google.com
docker ps
```

## Container Lifecycle

- `docker run` = `docker create` + `docker start`
- `-a`: makes docker watch for output from the container and print it in our terminal.

```
docker create hello-world // returns container id --> getting the file system ready
docker start -a <container_id>
```

## Removing Stopped Containers

- `docker system prune`:
  - delete all stopped containers and build cache (from Docker Hub)
- `docker rm <container_id>`

## Retrieving Log Outputs

- `docker logs <container_id>`: get logs from a container
  - retrieve information from a container that has been emitted from it
- not restarted the container, just retrieving records that has been emitted from the container.

## Stopping Containers

- `docker stop <container_id>`
  - sends a signal (SIGTERM) to the container, asking it to stop gracefully.
  - Container can perform any necessary cleanup tasks before it is stopped.
    - E.g., close any open files or connections, and saved any unsaved data.
  - If container does not respond to the signal within a certain time (**usually 10 seconds**), Docker sends a SIGKILL signal to forcefully stop the container.
- `docker kill <container-id>`
  - sends a signal (SIGKILL) to the container, forcefully stopping it immediately.
  - Container is terminated abruptly, without any chance to perform cleanup tasks.
  - Any data or state that was not saved before the container was killed will be lost.
- Recommended to use `docker stop` first then `docker kill` (if container does not respond).

## Multi-Command Container

- Starting a second command inside a running container
- `docker exec -it <container_id> <command>`
  - `exec`: run another command
  - `-it`: allow us to provide input to the container
  - `<command>`: command to execute

```
docker run redis // running copy of redis-server in container
docker exec -it <container_id> redis-cli

docker exec -i -t <container_id> redis-cli // similar way of running 
```

- `-i`: directed to std-in of redis-cli
- `-t`: for formatting

## Getting a Command Prompt to a Container

- `docker exec -it <container_id> sh`
  - `sh`: program executed inside the container.
  - Other command processors: bash, powershell, zsh
- can run things like `ls`, `echo`, `cd`

```
docker exec -it 5f7fb7599f16 sh
```

- `docker run -it busybox sh`
  - starting up container with an attached running shell like `sh`
  - can interact with the container's filesystem and environment.
- To exit from shell inside container: CTRL + D or type "exit"

## Container Isolation

- Containers are isolated from each other. They do not share their file system.
- No sharing of data between the containers.