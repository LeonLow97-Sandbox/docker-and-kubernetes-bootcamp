# k8s Configuration

## Creating own image

- Each layer in the dockerfile has a `SIZE`, run `docker history <image_name>` to see the SIZE
- `docker build Dockerfile -t leonlow/my-custom-app`
- `docker push leonlow/my-custom-app`: push to Docker registry

```dockerfile
## start from a base OS or another image
FROM ubuntu

## install dependencies using apt
RUN apt-get update
RUN apt-get install python

## install python dependencies using pip
RUN pip install flask
RUN pip install flask-mysql

## copy source code to /opt folder
COPY . /opt/source-code

## run the web server using `flask` command
ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

## Commands and Arguments in Docker

- Using `CMD`

```yaml
## override the default CMD of ubuntu image CMD["bash"] which causes the container to exit
FROM ubuntu

CMD sleep 5

## using docker command
docker run ubuntu-sleeper sleep 10
```

- Using `ENTRYPOINT`, command line parameters get appended

```yaml
FROM ubuntu

ENTRYPOINT ["sleep"]

## using docker command ("sleep 10")
docker run ubuntu-sleeper 10
```

- Using both `ENTRYPOINT` and `CMD`
  - If command line argument not provided, it uses the default parameter in CMD
  - `docker run ubuntu-sleeper`: sleep for 5 seconds
  - `docker run ubuntu-sleeper 10` sleep for 10 seconds
  - `docker run --entrypoint sleep2.0 ubuntu-sleeper 10` using a new entry point "sleep2.0 10"

```yaml
FROM ubuntu

ENTRYPOINT ["sleep"]

CMD ["5"]
```

## Commands and Arguments in Kubernetes

- Creating a Pod with the Commands
- Example: `docker run --name ubuntu-sleeper ubuntu-sleeper`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      command: ['sleep2.0'] ## override the ENTRYPOINT in docker image --> ENTRYPOINT ["sleep"]
      args: ['10'] ## override the CMD in docker image --> CMD ["5"]
```

- Can also do this

```yaml
command:
    - "sleep"
    - "1200"
```