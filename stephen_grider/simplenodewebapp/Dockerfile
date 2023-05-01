# base image
FROM node:14-alpine

# Creating working directory of the container
WORKDIR /usr/app

# Copy package.json into the curernt working directory of the contianer
COPY ./package.json ./

# install dependencies into node_modules (runs only if the previous steps changes)
RUN npm install

# copy over everything else (index.js)
COPY ./ ./

# Default command to start up the web server
CMD ["npm", "start"]