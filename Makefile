.PHONY: all build check.all clean docker.build.base docker.down \
        docker.push.base docker.shell docker.up.down download.all full_clean \
        pack.all test

all: build

build: download.all pack.all docker.build.base

test: build docker.up.base check.all

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

docker.build.base:
	#rm -rf docker_base/frontends
	#mkdir -p docker_base/frontends
	#cp -r dist/* docker_base/frontends/
	. ./env && \
	cd docker_base && \
	docker build . \
	    --tag "$$DOCKER_BASE_IMAGE_TAG" \
	    --build-arg NGINX_HTML_DIR="$$NGINX_HTML_DIR" \
	    --build-arg NGINX_CONTAINER_PORT="$$NGINX_CONTAINER_PORT"

docker.push.base:
	. ./env && docker push "$$DOCKER_BASE_IMAGE_TAG"

docker.up.base:
	. ./env && \
	docker run \
	    --detach \
	    --tty \
	    --interactive \
	    --publish "$$NGINX_HOST_PORT":"$$NGINX_CONTAINER_PORT" \
	    --name "$$DOCKER_CONTAINER_NAME" \
	    "$$DOCKER_BASE_IMAGE_TAG"

docker.down:
	. ./env && docker stop "$$DOCKER_CONTAINER_NAME" || true
	. ./env && docker rm "$$DOCKER_CONTAINER_NAME"

docker.shell:
	. ./env && docker exec -it "$$DOCKER_CONTAINER_NAME" /bin/bash

clean:
	rm -rf repos
	rm -rf dist
	rm -rf docker_base/frontends

full_clean: clean
	rm -rf node_modules
