# Based on edX's Ubuntu 18.04 image.
FROM edxops/bionic-common

# Install nginx
RUN apt-get update
RUN apt-get install nginx -y

# Copy in frontends.
COPY dist/ /var/www/html/

# Copy in scripts and configuration for running nginx.
COPY nginx/ /edx/app

# Directory for mounting configuration from devstack, etc.
RUN mkdir /edx/app/mounted-config

# Expose the port for serving HTTP.
ARG NGINX_CONTAINER_PORT
EXPOSE $NGINX_CONTAINER_PORT

# Run script that runs nginx in a loop.
CMD ["/edx/app/serve-devstack-frontends.sh"]