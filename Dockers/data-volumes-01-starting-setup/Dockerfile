FROM node:14

ARG DEFAULT_PORT=80

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

ARG DEFAULT_PORT=80

ENV PORT $DEFAULT_PORT

EXPOSE $PORT

# Adding a anonymous volume
# path inside container mapped to some folder outside of the container (data persists)
# VOLUME ["/app/feedback"]

# Adding anonymous volume for container for node modules.
# VOLUME ["/app/node_modules"] 

# VOLUME ["/app/temp"]

# CMD ["node", "server.js"]
CMD ["npm", "start"]
