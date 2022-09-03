# Building an image for our custom application
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# expose port used by this application
EXPOSE 80

ENV MONGODB_USERNAME=root
ENV MONGODB_PASSWORD=secret

CMD ["npm", "start"]