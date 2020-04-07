# Based on edX's Ubuntu 18.04 image.
FROM edxops/bionic-common

# Install nginx
RUN apt-get update
RUN apt-get install nginx -y

# Disable default site.
RUN rm /etc/nginx/sites-enabled/default

# Copy nginx configuration to sites-available and link in sites-enabled.
COPY devstack-frontends.nginx.conf /etc/nginx/sites-available/devstack-frontends
RUN ln -s /etc/nginx/sites-available/devstack-frontends /etc/nginx/sites-enabled/devstack-frontends

# Allow for custom nginx rules for Devstack.
RUN mkdir -p /edx/etc/nginx-devstack/

# Copy in frontends.
COPY dist/ /var/www/html/

# Expose the port for serving HTTP.
ARG NGINX_CONTAINER_PORT
EXPOSE $NGINX_CONTAINER_PORT

# Run nginx.
CMD ["nginx", "-g", "daemon off;"]
