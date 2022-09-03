# Creating an image in the Docker container
# Uses nodejs as base image
FROM node:14

# directory in container file system
WORKDIR /app

COPY package.json .

RUN npm install

# copy the rest of the code in the current file
COPY . .

# expose port 3000 to the outside world
EXPOSE 3000

CMD [ "node", "app.mjs" ]