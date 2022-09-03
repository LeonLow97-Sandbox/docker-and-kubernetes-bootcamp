## To run node

`docker run -it node`

## Run commands in container

- execute npm init inside the container
  `docker exec -it <container-name> npm init`

- create a utility container with npm init
- use bind mount to bind the Dockerfile to the app folder in the container
- if you delete node and npm, can still run on the container.
  `docker run -it -v C:\Users\commonuser\Desktop\udemy-docker\utility-containers:/app node-util npm init`
  `docker run -it -v C:\Users\commonuser\Desktop\udemy-docker\utility-containers:/app node-util npm install`

## ENTRYPOINT vs CMD

For docker run commands, if Dockerfile uses

- CMD [...], `docker run .... <image-name>` image name overwrites the command CMD.
- ENTRYPOINT [...], `docker run ... <image-name>` image name is appended after the command.

- this runs npm init
  `ENTRYPOINT ["npm"]`
  `docker run -it -v C:\Users\commonuser\Desktop\udemy-docker\utility-containers:/app mynpm init`
- the bind mount helps to run npm install as package.json file is copied over.
  `docker run -it -v C:\Users\commonuser\Desktop\udemy-docker\utility-containers:/app mynpm install`

## Using Docker Compose

- docker-compose run allows us to run a single service in the docker-compose file
  `docker-compose run npm init`
  `docker-compose run --rm npm init` (remove docker container once it stops)
- Running single (composer service)
  `docker-compose run --rm composer create-project --prefer-dist laravel/laravel .`
- Running specific services (containers)
  `docker-compose up -d server php mysql`
- build the image again
  `docker-compose up -d --build server`
- migrate command (writes some data to database, checks if database works)
  `docker-compose run --rm artisan migrate`
