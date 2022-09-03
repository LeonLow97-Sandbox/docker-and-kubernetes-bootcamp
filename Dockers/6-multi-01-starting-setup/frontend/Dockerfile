FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# default port 3000 for frontend
EXPOSE 3000

CMD ["npm", "start"]