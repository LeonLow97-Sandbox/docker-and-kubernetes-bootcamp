# Docker Compose with Multiple Local Containers

- Creating a project with Node App and recording the number of web visits to the app using Redis.
- Create separate Docker containers of the Node App.
- Connect all the Docker Node App containers to the singular instance Docker container of Redis to record the number of visits to all the Node App.
- Project Name: `visits`

## Options for Connecting Containers (Networking infrastructure between containers)

- Containers are isolated and to connect the containers, we need some networking infrastructure.
- Use Docker CLI's Network Features (Not recommended).
- Use Docker Compose!

## Docker Compose

- Separate CLIi that gets installed along with Docker.
- Used to start up multiple Docker containers at the same time.
- Automates some of the long-winded arguments we were passing to `docker run`.
- `docker-compose.yml` --> docker-compose CLI (containers to be created)
  - redis-server
    - Make it use the 'redis' image.
  - node-app
    - Make it using the Dockerfile in the current directory.
    - Map port 8081 to 8081.
- Creates the containers and allowing them to working in the same networking automatically with docker compose.

|   docker-compose commands   |              Description              |
| :-------------------------: | :-----------------------------------: |
|     `docker-compose up`     |          `docker run image`           |
| `docker-compose up --build` | start up containers and rebuild them. |
|   `docker-compose up -d`    |  Launch docker compose in background  |
|    `docker-compose down`    |            Stop containers            |

```yml
Creating network "visits_default" with the default driver
---
Creating visits_node-app_1     ... done
Creating visits_redis-server_1 ... done
```
