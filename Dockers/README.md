## Dockerizing MongoDB

- publish port 27017
- expose port 27017 from docker container to local machine so other services can connect to it through local machine.
- Thus, locally running backend can talk to this mongodb container.
  `docker run --name mongodb --rm -d -p 27017:27017 mongo`

## Dockerizing Node App

- building backend image
  `docker build -t goals-node .`

- starting the container (but it crashes)
- Error FAILED TO CONNECT TO MONGODB
- connect ECONNREFUSED 127.0.0.1:27017
  `docker run --name goals-backend --rm goals-node`

- We have mongodb running in a container exposing port 27017
- However, in backend, we are reaching out to localhost.
- We are trying to access some other service (localhost) that's not on the host machine
  `mongoose.connect('mongodb://localhost:27017/course-goals',`

- By using `host.docker.internal`, we access the ip address of our localhost machine run by docker.
  `mongoose.connect('mongodb://host.docker.internal:27017/course-goals',`
- rebuilt the image as source code changed
  `docker build -t goals-node .`
  `docker run --name goals-backend --rm goals-node`
- However, not react frontend will fail to talk to backend because we are not publishing the port of the backend. Although we "EXPOSE 80" in Dockerfile, we need to publish the ports the should be available on local host machine when we run the container

- we should publish the port 80 in backend nodejs to localhost port 80
  `docker run --name goals-backend --rm -d -p 80:80 goals-node`

## Dockerizing React App

- create another nodejs Dockerfile to run react
  `docker build -t goals-react .`

- publish internally exposed port 3000 on the local host port 3000
  `docker run --name goals-frontend --rm -d -p 3000:3000 -it goals-react`

## Adding Docker Networks for Cross-Container Communication

- create a network
  `docker network create goals-net`

- no longer have to publish the port because containers are in the same network (can communicate with each other)
- local host machine cannot communicate inside this network.
  `docker run --name mongodb --rm -d --network goals-net mongo`

- have to adjust the backend app.js file
- port 27017 is no longer available because we did not publish it to local host machine. 27017 is in the network.
  `mongoose.connect("mongodb://mongodb:27017/course-goals",`

- build the backend image again
  `docker build -t goals-node .`
- backend container is attached to the mongodb container in the same network
  `docker run --name goals-backend --rm -d --network goals-net goals-node`

- adjust frontend too (add in goals-backend container instead of localhost)
  `try {const response = await fetch('http://goals-backend/goals', {`

- build the frontend image again
  `docker build -t goals-react .`
- run the container
- still want to publish the ports, as we want to run it in browser.
  `docker run --name goals-frontend --network goals-net --rm -d -p 3000:3000 -it goals-react`

- However, 'goals-backend' runs in the browser and not to frontend...
- Error: net::ERR_NAME_NOT_RESOLVED
  `try {const response = await fetch('http://localhost/goals', {`
- need to rebuild the image.
  `docker build -t goals-react .`
- restart the container (remove the network because the network does not interact with node.)
  `docker run --name goals-frontend --rm -d -p 3000:3000 -it goals-react`

- restart the backend container (need to publish ports but we cannot remove network because the network still talks to mongodb)
- publish port 80 so frontend react can talk to this port.
  `docker run --name goals-backend --rm -d -p 80:80 --network goals-net goals-node`

## Adding Data Persistence to MongoDB with Volumes

- If we stop the container, it is automatically removed due to the "--rm" tag and the data is not stored (because the data was stored in the container). Use volumes (to store it in some hard drive so data survives).
- Use named volumes.
- `/data/db` was obtained from docker mongodb. mongodb stores the database files in the container inside that docker folder.
  `docker run --name mongodb -v data:/data/db --rm -d --network goals-net mongo`
- now if you stop the container, the data still persists.

## MongoDB Authentication

- the image supports environment variables `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD`.

- username and password is required to access the database when other containers try to access it (extra layer of security).
  `docker run --name mongodb -v data:/data/db --rm -d --network goals-net -e MONGO_INITDB_ROOT_USERNAME=lowjiewei -e MONGO_INITDB_ROOT_PASSWORD=secret mongo`

- error because the node application connected without that username and password.
- MongoDB standard connection string format: `mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]`
- need to change the connection format in app.js in node
  `mongoose.connect("mongodb://lowjiewei:secret@mongodb:27017/course-goals",`
- rebuild image in backend
  `docker build -t goals-node .`
- re-run container
  `docker run --name goals-backend --rm -d -p 80:80 --network goals-net goals-node`

- container crashes.
- according to mongodb documentation, need `mongodb://myDBReader:D1fficultP%40ssw0rd@mongodb0.example.com:27017/?authSource=admin` the `authSource=admin`
  `mongoose.connect("mongodb://lowjiewei:secret@mongodb:27017/course-goals?authSource=admin",`
- rebuild backend image and re-run container

## Data persist (log files) and live source code update.

- we need a volume in backend container for the log files
- using named volumes to bind the log files
- using bind mounts to bind the local files in folder (if any source code changes in app.js, it will update instantly.)
- dont want to overwrite the non-existing "node_modules" in the local host machine with the existing "node_modules" in the container (crashes container)
- `-v /app/node_modules` add another anonymous volume to tell the container that the existing node modules in the container should stay there and not be overwritten by the folder in the local host machine (i.e. `C:\Users\lowji\OneDrive\Desktop\docker-udemy\multi-01-starting-setup\backend`)
  `docker run --name goals-backend -v C:\Users\lowji\OneDrive\Desktop\docker-udemy\multi-01-starting-setup\backend:/app -v logs:/app/logs -v /app/node_modules --rm -d -p 80:80 --network goals-net goals-node`

- However, the CMD in Dockerfile is ["node", "app.js"] and it should be "nodemon".
- add new devDependencies in package.json
  ` "devDependencies": { "nodemon": "^2.0.4" }`
  ` "scripts": { "test": "echo \"Error: no test specified\" && exit 1", "start": "nodemon app.js" },`
- Change command line
  `CMD ["npm","start"]`

- add environment variables in dockerfile to control mongodb username and password
  `ENV MONGODB_USERNAME=root`
  `ENV MONGODB_PASSWORD=secret`

- change the connection string format for mongodb (use backticks)
  mongoose.connect(`mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD@mongodb:27017/course-goals?authSource=admin`

- default is `ENV MONGODB_USERNAME root`
- but we want to set own environment variables (-e MONGODB_USERNAME)
  `docker run --name goals-backend -v C:\Users\lowji\OneDrive\Desktop\docker-udemy\multi-01-starting-setup\backend:/app -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=lowjiewei --rm -d -p 80:80 --network goals-net goals-node`

## React Live Source Code Update

- bind mount to source code so changes are updated
- bind the source folder in local host to the source folder in the container
  `docker run -v C:\Users\lowji\OneDrive\Desktop\docker-udemy\multi-01-starting-setup\frontend\src:/app/src --name goals-frontend --rm -p 3000:3000 -it goals-react`

## Creating a Compose File

- Automating Multi-Container Setups
- by default, when you bring docker-compose down, it will be detached and removed (-d, --rm).

`docker-compose up`
`docker-compose down`

- run docker-compose in detach mode
  `docker-compose up -d`

- shutdown containers and network, not volumes
  `docker-compose down`
- to remove volumes too
  `docker-compose down -v`

- force docker to rebuild the image
  `docker-compose up --build`

## Quiz

- Does the `docker-compose` command replace the `docker` command? No, both commands can work together. Some tasks are replaced by docker-compose, but you for example will still push images via "docker push" (and use other commands as well).
- Which problem does `docker-compose` mainly solve? Annoying repetition of (long) commands.
- Which statement is false? docker-compose removes the concept of container images by just focusing on containers is false. We still use images when using docker-compose.
- Which statement is true? With docker-compose, you can define volumes and add them to any container than needs them.
- Which statement is true? With docker-compose, a default network is created for all the composed containers (i.e. all containers that are created by docker-compose are automatically added to that network.)
