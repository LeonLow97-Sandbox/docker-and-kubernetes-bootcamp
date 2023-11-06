## Kubernetes Production

<img src="./diagrams/docker-architecture.png" />
<img src="./diagrams/k8s-architecture.png" />

- On local, we will set up our application on one single Node.
- On Cloud (AWS or Google Cloud), we have the option to set up the application on multiple Nodes.

### Path to Production

1. Create config files for each service and deployment
2. Test locally on minikube
3. Create a GitHub/Travis flow to build images and deploy
4. Deploy app to a cloud provider

```
# commands used to run the development compose file when testing
docker-compose -f docker-compose-dev.yml up
docker-compose -f docker-compose-dev.yml up --build
docker-compose -f docker-compose-dev.yml down
```

