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

