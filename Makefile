.PHONY: all build check.all clean docker.down docker.prod.build docker.prod.up \
        docker.shell download.all full_clean pack.all test

all: build

build: download.all pack.all docker.prod.build

test: build docker.prod.up check.all

download.all:
	./foreach-frontend.sh ./download.sh

download.%:
	./download.sh $*

pack.all:
	./foreach-frontend.sh ./pack.sh

pack.%:
	./pack.sh $*

check.all:
	./foreach-frontend.sh ./check.sh

check.%:
	./check.sh $*

docker.prod.build:
	rm -rf prod/frontends
	mkdir -p prod/frontends
	cp -r dist/* prod/frontends/
	. ./env && \
	cd prod && \
	docker build . \
	    --tag "$$DOCKER_PROD_IMAGE_TAG" \
	    --build-arg NGINX_HTML_DIR="$$NGINX_HTML_DIR" \
	    --build-arg NGINX_CONTAINER_PORT="$$NGINX_CONTAINER_PORT"

docker.prod.up:
	. ./env && \
	docker run \
	    --detach \
	    --tty \
	    --interactive \
	    --publish "$$NGINX_HOST_PORT":"$$NGINX_CONTAINER_PORT" \
	    --name "$$DOCKER_CONTAINER_NAME" \
	    "$$DOCKER_PROD_IMAGE_TAG"

docker.down:
	. ./env && docker stop "$$DOCKER_CONTAINER_NAME" || true
	. ./env && docker rm "$$DOCKER_CONTAINER_NAME"

docker.shell:
	docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash

clean:
	rm -rf repos
	rm -rf dist
	rm -rf prod/frontends

full_clean: clean
	rm -rf node_modules
