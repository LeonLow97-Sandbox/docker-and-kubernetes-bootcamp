# Docker Commands

```sh
# Image
docker images       # List all Docker images (returns image name, tag, image ID, created time, size)
docker build -t webapp-color -f ./webapp-color/Dockerfile ./webapp-color  # Build Docker image from Dockerfile (image name without tag)

# Container
docker run -p <hostPort>:<containerPort> <imageName>:<tag> # Run Docker container from image (map host port to container port)
docker run python:3.6 cat /etc/*release*     # Run Docker container and execute command inside it (prints OS release info)

# Docker Security
# by default, docker runs containers as root user, can specify another user.
# OR define it in Dockerfile, `USER 1001`
docker run --user=1001 ubuntu sleep 3600 
docker run --cap-add MAC_ADMIN ubuntu   # provide additional privileges
docker run --cap-drop KILL ubuntu      # drop privileges
docker run --privileged                 # run with all privileges
```
