# Specify a base image (using node alpine which is a lightweight version with npm)
FROM node:14-alpine

# now the working directory becomes `/usr/app` instead of the root directory
WORKDIR /usr/app

# copy package.json from current working directory to current wd in container
COPY ./package.json ./

# Install some dependencies
RUN npm install

# After installing dependencies, we will copy everything else (including index.js)
# If we now make a change in index.js, we will not reinstall all dependencies
COPY ./ ./

# Default command
CMD ["npm", "start"]