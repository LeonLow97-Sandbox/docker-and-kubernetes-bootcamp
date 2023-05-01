FROM node:16-alpine AS builder

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .

# /app/build for build files
RUN npm run build 

# Production Server
FROM nginx

# Copy over build files from builder phase to nginx static file (found in Docker Hub)
COPY --from=builder /app/build /usr/share/nginx/html