FROM composer:latest

WORKDIR /var/www/html

# ignore flag ensure we can run without warnings or errors 
# even if there are some dependencies that are missing
ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]