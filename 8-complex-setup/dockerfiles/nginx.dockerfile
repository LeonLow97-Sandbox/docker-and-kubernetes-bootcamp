# already has a default "CMD"
FROM nginx:stable-alpine

WORKDIR /etc/nginx/conf.d

# nginx folder (outside dockerfile)
COPY nginx/nginx.conf .

# move command
# rename the file
RUN mv nginx.conf default.conf

WORKDIR /var/www/html

# src folder (outside dockerfile)
COPY src .

