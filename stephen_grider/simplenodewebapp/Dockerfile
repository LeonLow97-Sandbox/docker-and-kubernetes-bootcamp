# base image
FROM node:14-alpine

# Creating working directory of the container
WORKDIR /usr/app

# Copy build files into the Docker container
COPY ./ ./

# install dependencies into node_modules
RUN npm install

# Default command to start up the web server
CMD ["npm", "start"]