# Creating a Production-Grade Workflow

- Development --> Testing --> Deployment --> Development

## Flow Specifics

1. Dev
   - Create/change features
   - Make changes on a non-master branch
   - Push to github
   - Create Pull Request to merge with master
2. Test
   - Code pushed to _Travis CI_
   - Tests run
   - Merge PR with master
3. Prod
   - Code pushed to Travis CI
   - Tests run
   - Deploy to AWS Elastic Beanstalk

- Docker is a tool in a normal development flow.
  - Docker makes some of these tasks a lot easier.

## React (Frontend) Commands

|    Commands     |                       Description                        |
| :-------------: | :------------------------------------------------------: |
| `npm run start` | Start up a development server. For development use only. |
| `npm run test`  |         Runs tests associated with the project.          |
| `npm run build` |   Builds a **production** version of the application.    |

## Dockerfile in development

- `Dockerfile.dev`: for development only
    - `docker build -f Dockerfile.dev .`
- `Dockerfile`: for production

## What are Docker volumes?

- Docker volumes allow you to create a **reference** between folders inside a container and folders outside the container, on the host machine running Docker.
- This allows you to persist data and share files between the container and the host machine, and between multiple containers if needed.
- When you create a volume for a Docker container, you can specify a host path for the volume. 
    - This host path will be used to store the data that is being shared between the container and the host machine.
    - The container will have read and write access to this path, and any changes made to the files inside the container will be reflected in the host path, and vice versa.
- Summary: Volumes are for sharing configuration files, persisting data between container restarts, and sharing data between multiple containers.

## Docker Volume Command

- Docker container creates a reference with the folders in the container to the folders outside the container in the local machine.
- Syntax: `docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image_id>`
    - `/app/node_modules`: placeholder of folder inside the container, not mapping to anything. (Because we deleted the node_modules folder outside the container. Only the container has the node_modules.)
    - `$(pwd):/app`: take the present working directory of the local machine and map over to `/app` on Docker container. The colon `:` is used when we want to map folders between host and container.
- Changes are automatically reflected when we make changes in our local files which are propagated to the running container, and the container reflects the change by updating the page.

## Docker test in -it mode

- `docker run -it <image> npm run test`
- 1st Solution:
    - `docker-compose up`
    - On another cmd, `docker exec -it <image> npm run test`
- 2nd Solution:
    - using `docker-compose.yml` and `docker-compose up`. (unable to interact with npm run test CLI)
    - use `docker attach <container>`: attach to a running container and view the container's standard input (**stdin**), standard output (**stdout**), and standard error (**stderr**) streams.

## Production Environment

- In development, we use a development server. However, in production, we cannot rely on localhost and we need to deploy the application on production server that is accessible from the Internet and can handle incoming requests.
- `nginx`: Production server of for web applications.
    - Create a Docker image of your application.
    - Run it as a container on a production server with `nginx` configured as a reverse proxy.
    - Incoming requests are first handled by `nginx`, which can then pass them on to the backend application server as needed.
- Steps to build production environment
    - Build Phase
        1. Use node:alpine
        2. Copy the package.json file
        3. Install dependencies
        4. Run `npm run build`
    - Run Phase
    5. Start nginx
        - Use nginx
        - Copy over the result of `npm run build`
        - Start nginx
- After creating the Dockerfile, run `docker run -p 8080:80 <image>`
    - nginx port: 80
    - Running the application on nginx server
