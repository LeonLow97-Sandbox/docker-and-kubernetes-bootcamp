# Docker Commands

```sh
# Image
docker images       # List all Docker images (returns image name, tag, image ID, created time, size)
docker build -t webapp-color -f ./webapp-color/Dockerfile ./webapp-color  # Build Docker image from Dockerfile (image name without tag)

# Container
docker run -p <hostPort>:<containerPort> <imageName>:<tag> # Run Docker container from image (map host port to container port)
docker run python:3.6 cat /etc/*release*     # Run Docker container and execute command inside it (prints OS release info)
```
