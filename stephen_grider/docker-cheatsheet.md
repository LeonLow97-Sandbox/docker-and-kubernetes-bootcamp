# Docker Commands

- https://dockerlabs.collabnix.com/docker/cheatsheet/

## Generic Commands

|Commands|Description|
|:-:|:-:|
|`docker version`|To check the version of Docker installed.|
|`docker system prune`|Removes all unused objects from the Docker installation. These objects can include stopped containers, unused volumes, images that are not associated with a container, and networks that are not being used.|

## Docker Container

|Commands|Description|
|:-:|:-:|
|`docker run <image_name> override_command`|Creates a new container from the specified image, starts the container, and runs the specified command. If the image does not exist locally, it will be downloaded from a registry.|
|`docker create <image_name>`|Creates a new container from the specified image, but does not start it. This command returns the container ID.|
|`docker start <container>`|Starts a container that has already been created, but not started.|
|`docker start -a <container>`|Start a container that has already been created and attach the container's output to the console. This allows you to see the output of the container as it runs.|
|`docker ps`|Lists all running containers.|
|`docker ps -a`|Lists all containers.|
|`docker logs <container>`|Display the logs of a container.|
|`docker inspect <container>`|Displays detailed information of a container.|
|`docker rm <container>`|Removes the specified stopped container.|
|`docker rm -f <container>`|Forces the removal of a running container. (NOT RECOMMENDED) Could result in data loss or any unexpected issues.|
|`docker stop <container>`|Sends a SIGTERM signal to the container, allowing it to perform any necessary cleanup before stopping. If the container does not stop within 10 seconds, a SIGKILL signal is sent to force it to stop. RECOMMENDED way to stop a container, as it gives the container a chance to shut down gracefully.|
|`docker kill <container>`|Sends a SIGKILL signal to the container, immediately stopping it without allowing it to perform any cleanup. This can result in data loss or other issues, so it should be used with caution.|
|`docker exec <container> <command>`|Runs a command in a running container. Command can be bash script, powershell, or other commands like ls, cd, or echo.|
|`docker exec -it <container> <command>`|Runs an **interactive shell` in a running container.|
|`docker run -it alpine sh`|Starts up a container inside shell.|
|`docker rm -f $(docker ps -a -q)`|removing all containers|

## Docker Images

|Commands|Description|
|:-:|:-:|
|`docker pull <image_name>`|To pull Docker image from Docker Hub.|
