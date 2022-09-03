# ------------------ Creating an image ----------------------
# Setting up node image (either exists on your system locally or dockerhub)
FROM node

# Setting working directory (all subsequent commands will be called in /app)
WORKDIR /app

# for npm install  , so that it does not have to be ran again when source
# code changes (pacakage.json did not change so dont need to npm install again)
# OPTIMIZATION
COPY package.json /app 

# install all dependencies for node application after copying all files
RUN npm install

# files to be used in the node image 
# (one . everything in the particular folder), (second . in image/container file system)
# copy into the image file system (like a "snapshot" of our source code)
COPY . /app

# Docker is isolated from our local environment
# have to expose the port to the local machine (Optional)
# usually added to "document" the exposed port
EXPOSE 80

# start the server (start in a container based on an image), CMD = command
CMD ["node", "server.js"]
