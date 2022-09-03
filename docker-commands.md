## To create an image based on a docker file

docker build . (one dot means run docker in the same folder we are in - local directory)

## To run docker image, where 3000 is the port number.

docker run -p 3000:3000 a17efb40d02e698a5143f
("-p": to expose the port to public-)

## View a list of running containers

docker ps
docker ps -a ("-a" to view all)
docker ps --help

## Stop docker container

docker stop thirsty_tereshkova

## Pulls the latest node image on docker hub

(runs this image as a container)

docker run node

docker run -it node  
(to enter the interactive node to run basic node commands)
(node is now running in the container)

- Images contain the logic and code.
- Containers are instances of the images.

## Building an Image

- When rebuild same dockerfile, it uses cache.
- Image layer
- Images are read-only unless you rebuild the image.

- When one layer changes, all layers are re-executed when the image is rebuilt.

## Quiz 1

- Images are "blueprints" for containers which then are running instances with read and write access.
- The concept of having "Images" and "Containers" allows multiple containers to be based on the same image
  without interfering with each other.
- What does "Isolation" mean in the context of containers? Containers are separated from each other and have
  no shared data or state by default.
- What is a "Container"? An isolated unit of software which is based on an image. A running instance
  of that image.
- What are "Layers" in the context of images? Every instruction in an image creates a cacheable layer - layers
  help with image re-building and sharing.
- What does "docker build ." command do? It builds an image.
- What does "docker run node" command do? It creates and runs a container based on the "node" image.

## Restarting a container (previously exited)

docker start nostalgic_benz
(Note: The container is running in the background.)

## docker run vs docker start

- docker run blocks us in the terminal (cannot enter more commands in the terminal)
- docker start does not
  (this can be configured: "attached" or "detached" mode)
  ("attached" mode is default for docker run --> listening to output, whatever console)
  ("detached" mode is default for docker start)

docker run -p 8080:80 -d 72e638dd16ba
(running in detach mode with "-d", no longer see console log in output)
docker attach hopeful_turing
(to attach it again)

docker start -a
(can also start with "attach" mode)

## docker logs

docker logs hopeful_turing
(to view all the logs printed by the container)

docker logs -f hopeful_turing
(to keep listening to the log, basically going back to "attach" mode)

## docker interactive

- for interacting with container, like python "input"
  docker run -it 201f3fd96b92
  docker run --help

docker start --help
docker start -a -i strange_cohen

## Deleting images & containers

- To remove CONTAINERS, stop running container then can remove
  docker rm trusting_hypatia

- To remove IMAGES and its layers, use the id and 'rmi'
- containers must be removed first then can remove images.
  docker rmi a5eaf9d2ca5b

- can remove multiple images (just add whitespace in between images)
  docker images
  docker rm trusting_hypatia nostalgic_benz sad_mendel
  docker image prune (remove most images)
  docker image prune -a (remove all images)

## Removing Stopped Containers Automatically

docker run --rm (automatically removes the container when it exits)
docker run -p 3000:80 -d --rm a5eaf9d2ca5bec9a400d28a90c6c2b9857ccec287

# Inspecting Images

docker image inspect a5eaf9d2ca5b

# Copying Files Into & From a Container

docker cp dummy/. focused_chebyshev:/test
docker cp focused_chebyshev:/test dummy
docker cp focused_chebyshev:/test/text.txt dummy

# Naming & Tagging Containers and Images

- naming container ("--name")
  docker run -p 3000:80 -d --rm --name leonlow a5eaf9d2ca5b

# Image Tags

- name: tag
- name defines a gorup of possible more specialised images (e.g., "node")
- tag defines a specialised image within a group of images. (e.g., "14")
- can find the different tags in docker hub. to use a specific image of node.

- by combining name and tag, we have a unique identifier.

docker build -t goals:latest .
docker run -p 3000:80 -d --rm --name leonlow assignment3:latest

## Pushing an image to Docker Hub

- Create a repository with the name "node-hello-world"
- This is just a "cloned" repository, not rename
  docker tag node-demo:latest lowjiewei/node-hello-world

- to push to docker hub (must be logged in to Docker Hub)
  docker push lowjiewei/node-hello-world

## Login to Docker Hub

docker login
docker logout

## Pull the repository image from DockerHub

- don't have to be logged in
- pulls the latest image from container registry
  docker pull lowjiewei/node-hello-world

- won't check for updates, not latest
- use the image locally
  docker run lowjiewei/node-hello-world

## View error message of Docker Container

docker logs feedback-app

## view volumes

docker volume ls

## creating named volumes

(-v used to create a named container)
("/app/feedback" is where you want to store the volume)
(use the same volume name to restart the container "feedback")
docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes

## Clearing Volumes

docker volume rm VOL_NAME
docker volume prune

## Bind Mount

- state an absolute path, not relative path
- entire folder is mounted as a volume in "app"
  docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v C:\Users\commonuser\Desktop\Dockers-and-Kubernetes\volumes\data-volumes-01-starting-setup:/app feedback-node:volumes

- to copy and use the full path, can use this shortcut:

macOS / Linux: -v $(pwd):/app
Windows: -v "%cd%":/app

- to avoid clashes with outside modules use anonymous volume
- localhost overwrites the node modules in the docker container
- create another anonymous volume to store the node modules.
- node_modules folder can now co-exist with the bind mount "app" (node_modules didnt get overwritten by bind mount)
  docker run -d -p 3000:80 --name feedback-app --rm -v feedback:/app/feedback -v "C:\Users\commonuser\Desktop\Dockers-and-Kubernetes\volumes\data-volumes-01-starting-setup:/app" -v /app/node_modules feedback-node:volumes

## Reflect changes in containers (instant)

1. use nodemon in package.json devDependencies
   "devDependencies": {
   "nodemon": "2.0.4"
   }
2. Change script in package.json
   "scripts": {
   "start": "nodemon server.js"
   },
3. Edit CMD in Dockerfile so it runs nodemon
   CMD ["npm", "start"]
4. build the image again

## Quiz 3

- What is a "Volume"? A folder / file inside of a Docker container which is connected to some folder outside of the container.
- Volumes are managed by Docker, you don't necessarily know where the host folder (which is mapped to a container-internal path) is.
- Anonymoous volumes are removed when a container, that was start with "rm" is stopped.
- Named Volumes survive container removal.
- Bind Mount is a path on your host machine, which you know and specified, that is mapped to some container-internal path.
- What is a typical use-case for a Bind Mount? You want to provide "live data" to the container (no rebuilding needed).
- Are anonymous volumes useless? No, you can use them to prioritize container-internal paths higher than external paths.

## Read-Only Volumes

`docker run -d -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "C:\Users\commonuser\Desktop\Dockers-and-Kubernetes\volumes\data-volumes-01-starting-setup:/app:ro" -v /app/node_modules feedback-node:volumes`

## Managing Docker Volumes

`docker volume --help`

- bind mount does not show up (this one is managed by us on local host machine)
  `docker volume ls`

- inspect volume
  `docker volume inspect feedback`

- remove volumes
  `docker volume rm`
  `docker volume prune`

## .dockerignore File

- Add more "to be ignore" files and folders to the .dockerignore file.

# Setting new port as environment variable

`docker run -d -p 3000:8000 --env PORT=8000 --name feedback-app --rm -v feedback:/app/feedback -v "C:\Users\commonuser\Desktop\Dockers-and-Kubernetes\volumes\data-volumes-01-starting-setup:/app" -v /app/node_modules -v /app/temp feedback-node:env`

- in Dockerfile
  `ENV PORT 80`
  `EXPOSE $PORT`

- taking from .env file
  `docker run -d -p 3000:8000 --env-file ./.env --name feedback-app --rm -v feedback:/app/feedback -v "C:\Users\commonuser\Desktop\Dockers-and-Kubernetes\volumes\data-volumes-01-starting-setup:/app" -v /app/node_modules -v /app/temp feedback-node:env`

  # Build Arguments (BRG)

  `ARG DEFAULT_PORT=80`
  `ENV PORT $DEFAULT_PORT`

  - building on a different default_port without changing the Dockerfile
    `docker build -t feedback-node:dev --build-arg DEFAULT_PORT=8000 .`

## MongoDB Image

- running mongodb container based on the Docker Hub mongo image
  `docker run -d --name mongodb mongo`

## host.docker.internal

- host.docker.internal refers to the IP address of the local host machine, and not
  to some other container.

## Getting IP Address of container

- contains the IP Address to 'contact' the container
- "IPAddress": "172.17.0.3"
  `docker container inspect mongodb` (to find its IP Address)
  `mongoose.connect("mongodb://mongodb:27017/swfavorites", { useNewUrlParser: true }, err => { .... `
  `docker run --name favorites -d --rm -p 3000:3000 favorites-node`

## Creating a network

- create network
  `docker network create favorites-net`

- put mongodb container into this network
  `docker run -d --name mongodb --network favorites-net mongo`

- put container name in the connection
  `mongoose.connect("mongodb://mongodb:27017/swfavorites", { useNewUrlParser: true }, err => {`

- put nodejs into the same network
  `docker run --name favorites --network favorites-net -d --rm -p 3000:3000 favorites-node`

Note: did not run with "-p" because it is not needed. Only required if plan to connect something in the local host machine or outside of that container. container-to-container can communicate with each other, dont need to connect to another port.

## Quiz 4

- By default, container (and the apps inside of them) can reeach out to the web and send requests.
- By using the special `host.docker.internal` address, applications running in a container can communicate to your local host machine.
- Containers communicate with other containers by manually finding the IP addresses or by using a network.
- How can containers communicate with each other if they are in the same network? Can use the container names as addresses.

## Dockerizing MongoDB service

- expose port to local host machine (mongodb runs in the container can talk to the locally run backend)
  `docker run --name mongodb --rm -d -p 27017:27017 mongodb`

## Dockerizing NodeJS App

To allow mongodb exposed port to local host machine to talk to local host machine by docker
Change from
`mongoose.connect("mongodb://localhost:27017/course-goals",`
to
`mongoose.connect("mongodb://host.docker.internal:27017/course-goals",`

However, we haven't change the container's exposed port 80 to the frontend. Thus, the frontend receives the ERR_CONNECTION_REFUSED error as it is not connected to the new local host port.

`docker stop goals-backend`
restart with the correct ports
`docker run --name goals-backend --rm -d -p 80:80 goals-node`
now run the container by publishing the internal port 80 exposed byu the container (where the applciation is listening) to the local host port 80
