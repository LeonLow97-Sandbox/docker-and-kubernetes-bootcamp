## Project Outline

- Goal: Building Multiple Container Application
- Project: Fibonacci Sequence

### Application Architecture

<img src="./diagrams/docker-34.png" />
<img src="./diagrams/docker-35.png" />
<img src="./diagrams/docker-36.png" />
<img src="./diagrams/docker-37.png" />

### Development Versions of Docker Containers

- Need to make **dev** Dockerfiles for React App, Express Server and Worker.
- This is to ensure we don't have to rebuild the entire Docker Image whenever we make a change to the source code.

1. Copy over package.json
2. Run `npm install`
3. Copy over everything else
4. Docker compose should set up a volume to 'share' files.

- Run `docker build -f Dockerfile.dev .` to build image and retrieve image_id
- `docker run <image_id>`

### Docker Compose

<img src="./diagrams/docker-39.png" />

### Environment Variables in Docker Compose

<img src="./diagrams/docker-40.png" />


### Nginx Path Routing

<img src="./diagrams/docker-41.png" />


- Production Web Server
- Nginx routes incoming requests and it knows which request goes to the React Server and which request goes to the Express server.
- On Client Side, we are making requests to `/api/values` but on the server side, we are receiving requests on `/values`.
  - NGINX looks at the incoming request path. If it starts with `/`, redirect request to express server.
  - If it starts with `/api`, redirect request to the express API, nginx removes `/api` and when it reaches express api, it will become `/values`

### Routing with NGINX

<img src="./diagrams/docker-42.png" />


- Use `default.conf` to add configuration rules to NGINX for the path routing.
    - **Upstream Server**: servers that NGINX redirect incoming requests to.
    - NGINX redirects to `client:3000` and `server:5000` as named in services in docker-compose.yml

### Switching of WebSocket between NGINX and React

<img src="./diagrams/docker-43.png" />

- In Client Service, add this in docker-compose.yml

```yaml
environment:
    - WDS_SOCKET_PORT=0
```

- In `default.conf`, add this:

```conf
# for allowing WebSocket to React Server
location /ws {
    proxy_pass http://client;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
}
```