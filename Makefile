.PHONY: all build check.all clean dist dist.frontend docker.build \
        docker.build.base docker.build.base.copy docker.build.base.run \
        docker.down docker.push.base docker.reup.base docker.shell \
        docker.up.base full_clean index-page test

all: build

build: dist index-page docker.build

test: build docker.reup.base check.all

dist:
	./foreach-frontend.sh make dist.frontend

dist.all.%:
	./foreach-frontend.sh make dist.frontend.$*

dist.frontend: \
	dist.frontend.01-update-repo \
	dist.frontend.02-npm-install \
	dist.frontend.03-inject-config \
	dist.frontend.04-run-webpack \
	dist.frontend.05-copy-to-dist

dist.frontend.%:
	dist-pipeline/$**.sh

index-page:
	index-page/gen.sh
	cp -f index-page/index.html dist/
	cp -f index-page/favicon.ico dist/

check.all:
	./foreach-frontend.sh ./check.sh

check.%:
	./check.sh $*

docker.build: docker.build.base

docker.build.base: docker.build.base.copy docker.build.base.run

docker.build.base.copy:
	rm -rf docker_base/frontends
	mkdir -p docker_base/frontends
	cp -r dist/* docker_base/frontends/

docker.build.base.run:
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

docker.reup.base: docker.down docker.up.base

docker.down:
	. ./env && docker stop "$$DOCKER_CONTAINER_NAME" || true
	. ./env && docker rm "$$DOCKER_CONTAINER_NAME" || true

docker.shell:
	. ./env && docker exec -it "$$DOCKER_CONTAINER_NAME" /bin/bash

clean:
	rm -rf repos
	rm -rf dist
	rm -rf docker_base/frontends

full_clean: clean
	rm -rf node_modules
