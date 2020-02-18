FROM edxops/bionic-common
RUN apt-get update
RUN apt-get install nginx -y

ARG NGINX_HTML_DIR
ADD frontends $NGINX_HTML_DIR

ARG NGINX_CONTAINER_PORT
EXPOSE $NGINX_CONTAINER_PORT

CMD ["nginx", "-g", "daemon off;"]
