## Docker Compose Project with Redis and Node

- Objective: Learn Docker Compose

### Project Outline (`project-visits`)

1. Set up a web server in NodeJS.
2. Store the number of visits to the web applications inside Redis.

### Things To Consider

- We should build the NodeJS Web Application and Redis in 2 separate containers.
- If we build both redis and NodeJS web app in 1 container and we perform horizontal scaling, we create multiple containers with both Redis and NodeJS. Now, our Redis Database (Stateful) is present in multiple containers which leads to data inconsistency. And it is also difficult to scale our web app independently.

```
docker build -t leonlow/visits:latest .
docker run leonlow/visits

# will fail because there is no running Redis Server
```

- Running both node app and redis in 2 separate containers will fail because they are not connected via any network. Solution: use docker-compose

```
docker run redis # starts a redis-server
docker build -t leonlow/visits:latest .
docker run leonlow/visits # starts a web application

# will fail because the web application is not connected to the container running redis-server
```

### Docker Compose

- [Recommended] Can setup a network to connect 2 different containers using docker-compose.
- [BAD - Not Recommended] We can also use Docker CLI's Network Features to connect 2 different containers but it is a pain to run those commands every single time as compared to something like `docker-compose up`
- What is Docker Compose?
  - Separate CLI that gets installed along with Docker
  - Used to start up multiple Docker containers at the same time.
  - Can connect multiple containers over a network.
  - Automates some of the long-winded arguments we were passing to `docker run`

```
# essentially putting these commands into docker-compose.yml file
docker build -t leonlow/visits:latest
docker run -p 8080:8080 leonlow/visits

# docker-compose.yml contains all the options we would normally pass to Docker CLI
# docker-compose.yml is then run with docker-compose CLI
```

### Docker Compose Commands

- `docker-compose up` = `docker run <image>`
- `docker-compose up --build` = `docker build .` + `docker run <image>`
  - used to rebuild the image
- `docker-compose up -d`: launch in background

```
# automatically creates a network for you for the services in docker compose
➜  project-visits git:(main) ✗ docker-compose up --build
Creating network "project-visits_default" with the default driver
```

- `docker-compose down`: stop containers
- `docker-compose stop`
- `docker-compose ps`: finds a docker-compose.yml file and finds containers on your machine that is specified in the docker-compose file.

### Automatic Container Restarts

- In NodeJS, we added `process.exit(0)` to deliberately exit the container.
  - Status Codes
    - 0 : existed and everything is OK
    - 1, 2, 3, etc: existed because something went wrong
- Goal: Restart a container when it crashes.

```
project-visits_node-app_1 exited with code 0

# running docker ps and you will see that the container has stopped and exited
docker ps
```

---

#### Restart Policies

| Restart Policy | Description |
| :------------: | ----------- |
|`"no"`|Never attempt to restart this container if it stops or crashes. Wrap it with double quotes because `no` is a false value in yaml file.|
|`always`|If this container stops for nay reason, always attempt to restart it. Good for web servers/applications where we want to keep them running|
|`on-failure`|Only restart if the container stops with an error code, i.e., 1, 2,3, etc. Good to use for worker processes, once they have finished their work, we can stop the container.|
|`unless-stopped`| Always restart unless we (the developers) forcibly stop it.|

---
