## Creating a Production-Grade Workflow (`project-docker-frontend`)

<image src="./diagrams/docker-24.png" />

- Development --> Testing --> Deployment --> Development

### Flow Specifics

<image src="./diagrams/docker-23.png" />
<image src="./diagrams/docker-25.png" />

1. Dev
   - Working on a Git feature branch and adding code changes to this branch
   - Push to GitHub remote branch that contains the feature branch you were working on
   - Create Pull Request (Merge Request) to merge with master branch
2. Test
   - Merge PR with master (Merge Request)
   - Code pushed to _Travis CI_
     - Travis CI will run a set of tests to test the codebase that was merged.
3. Prod
   - Travis CI will run the tests here again to ensure all are passing
   - After testing code via Travis CI, the code will be deployed to AWS Hosting aka AWS Elastic Beanstalk in our case.

- Flow: GitHub Repo --> Travis CI --> AWS Hosting

### Docker's Purpose

- Docker is a tool in a normal development flow and it is not required in this workflow but recommended.
- Docker makes some of these tasks a lot easier.

### Project Commands (React)

<image src="./diagrams/docker-26.png" />

|    Commands     |                                     Description                                     |
| :-------------: | :---------------------------------------------------------------------------------: |
| `npm run start` |              Start up a development server. For development use only.               |
| `npm run test`  |                       Runs tests associated with the project.                       |
| `npm run build` | Builds a **production** version of the application. Used in the AWS Hosting Service |

### Dockerfile in development

- Docker Container:
  - In Development: `npm run start`
  - In Production: `npm run build`
- Dockerfile In different environments:
  - Development: `Dockerfile.dev`
  - Production: `Dockerfile`
- `Dockerfile.dev`
  - `.dev` runs it in development only
  - `docker build -f Dockerfile.dev .`
    - `-f` specify file to be used to build the image
- Starting the container: `docker run -p 3000:3000 <image_id>`

### What are Docker Volumes?

<image src="./diagrams/docker-28.png" />

- Docker volumes create a **reference** inside folders in the Docker container that points to folders on the local machine (outside of Docker container).
  - Similar to port mapping
- Changes are automatically reflected when we make changes in our local files which are propagated to the running container, and the container reflects the change by updating the page.
- This allows you to persist data and share files between the container and the host machine, and between multiple containers if needed.
- When you create a volume for a Docker container, you can specify a host path for the volume.
  - This host path will be used to store the data that is being shared between the container and the host machine.
  - The container will have read and write access to this path, and any changes made to the files inside the container will be reflected in the host path, and vice versa.

### Docker Volumes Command

<image src="./diagrams/docker-27.png" />

- Docker container creates a reference with the folders in the container to the folders outside the container in the local machine.
- Syntax: `docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image_id>`
  - `/app/node_modules`: placeholder of folder inside the container, not mapping to anything as we did not specify `:`. (We need this because we deleted the node_modules folder locally and the container has the node_modules, so we need to set a reference for the node modules in the container too)
    - `-v` to set up volume
  - `$(pwd):/app`: take the present working directory (pwd) of the local machine and map over to `/app` on Docker container. The colon `:` is used when we want to map folders between host and container.

### Using Docker Compose

```yaml
version: '3'

services:
  web:
    build: .
    ports:
      - '3000:3000'
    volumes:
      - /app/node_modules
      - .:/app
```

- Cannot use `build: .` to read `Dockerfile.dev`, it can only read `Dockerfile`
- **Solution**:

```yaml
version: '3'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - '3000:3000'
    volumes:
      - /app/node_modules
      - .:/app
```

### Running Tests in Docker Container (development)

- Solution 1:
  1. `docker build -f Dockerfile.dev .` to build the image and retrieve image_id
  2. `docker run -it <image_id> npm run test`
     - use `-it` for STDIN purposes
     - For Solution 1, as we make changes to our test files, the tests are not updating (no auto-run of tests).
- Solution 2 (using docker compose):
  1. `docker-compose up`
  2. `docker ps` to get the running container id
  3. `docker exec -it <container_id> npm run test`
     - For Solution 2, the tests are updating as we make changes to test files because this time we are making use of the volumes we set up earlier in docker-compose for our 'web' service.
     - Not the best solution because we always need to retrieve the container_id
- Solution 3 (setting up another service for tests in docker compose):

  ```yaml
  tests:
    build:
    context: .
    dockerfile: Dockerfile.dev
    volumes:
      - /app/node_modules
      - .:/app
    # override the starting command in Dockerfile.dev, i.e., npm run start
    command: ['npm', 'run', 'test']
  ```

  1. `docker-compose up`
     - Not the best solution because there is no updating of tests when you make changes to test files.

<image src="./diagrams/docker-29.png" />

- In my opinion, **Solution 2 is the best**.
- `docker attach <container>`:
  - forward input from terminal to a specific container (STDIN) but it doesn't work with running containers by docker compose because `docker attach` is only to a primary process.
  - attach to a running container and view the container's standard input (**stdin**), standard output (**stdout**), and standard error (**stderr**) streams.

## NGINX - Production Environment

<image src="./diagrams/docker-30.png" />
<image src="./diagrams/docker-31.png" />
<image src="./diagrams/docker-32.png" />

- In Development, our Docker container has (i) Dev Server, (ii) index.html, (iii) main.js
- In Production, our Docker container has (i) index.html and (ii) main.js but there is no server.
  - Thus, we need a Production Server to accept incoming requests and send back the html and javascript files to the browser.
  - Production Server: `NGINX`
- What is NGINX?
  - Production Web Server that can be used for web applications serving static content.
  - Run NGINX in a Docker container on a production server with nginx configured as a reverse proxy that routes incoming requests to the frontend web application.

### Create Image for Production Environment

1. Create `Dockerfile`
   - `FROM` specifies a block and we will create 2 blocks - build phase and run phase
2. Run `docker build .` to retrieve the image id
3. Run `docker run -p 8080:80 <image_id>`
   - `80` because that is the port used by nginx

## Continuous Integration and Deployment with AWS (CI/CD)

### Services Used

- GitHub, Travis CI, AWS
- Git Repository
  - `git add` + `git commit`
  - `git remote add origin <github_repo_https_link>`
  - `git push -f origin master`
  - `git push --set-upstream origin master`
- Travis CI
  - When you push code to GitHub, Travis will pull code from GitHub Repository.
  - Travis CI will test your code base and help to deploy your application to AWS.
    - To run test suite, we will be using `Dockerfile.dev` instead of `Dockerfile`
  ```
  docker build -t leonlow/docker-react -f Dockerfile.dev .
  docker run -e CI=true leonlow/docker-react npm run test
  ```
- AWS
  - Rename the development compose config file from docker-compose.yml to docker-compose-dev.yml.
    - Need to pass a flag to specify which compose file you want to build and run from:
    ```
    docker-compose -f docker-compose-dev.yml up
    docker-compose -f docker-compose-dev.yml up --build
    docker-compose -f docker-compose-dev.yml down
    ```
  - Create a Production Compose config file
    - Create a docker-compose.yml file in the root of the project and paste the following:
    ```yaml
    version: '3'
    services:
      web:
        build:
          context: .
          dockerfile: Dockerfile
        ports:
          - '80:80'
    ```
    - AWS ElasticBeanstalk will see a file named docker-compose.yml and use it to build the single container application.
