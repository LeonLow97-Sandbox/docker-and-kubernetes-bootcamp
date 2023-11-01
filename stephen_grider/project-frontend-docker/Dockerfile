# Build Phase
FROM node:16-alpine AS builder

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .

RUN npm run build


# Run Phase
FROM nginx

# EXPOSE port for port mapping on AWS, elastic beanstalk will automatically
# map this port to incoming traffic to the Docker container
EXPOSE 80

## `--from` means we want to copy something from a different phase
## in documentation, static files are stores in /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html