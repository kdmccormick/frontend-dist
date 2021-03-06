.PHONY: all build check.all check.one clean clean.all clean.one dist.all \
        dist.one dist.one.01+ dist.one.02+ dist.one.03+ dist.one.04+ \
        dist.one.05+ docker.attach docker.build docker.down docker.go \
        docker.kick-nginx docker.logs docker.push docker.reup docker.shell \
        docker.up full_clean index-page test

all: build

build: dist.all index-page docker.build

test: build docker.reup check.all

dist.all:
	./foreach-frontend.sh make dist.one

dist.all.%:
	./foreach-frontend.sh make dist.one.$*

dist.one: dist.one.01+

dist.one.01+: dist.one.stage.01-update-repo dist.one.02+

dist.one.02+: dist.one.stage.02-npm-install dist.one.03+

dist.one.03+: dist.one.stage.03-run-webpack dist.one.04+

dist.one.04+: dist.one.stage.04-copy-to-dist dist.one.05+

dist.one.05+: |

dist.one.stage.%:
	dist-pipeline/$**.sh

index-page:
	index-page/gen.sh
	cp -f index-page/index.html dist/
	cp -f index-page/favicon.ico dist/

check.all:
	./foreach-frontend.sh ./check.sh

check.one:
	./check.sh

docker.build:
	. ./env && \
	docker build . \
	    --tag "$$DOCKER_IMAGE_TAG" \
	    --build-arg NGINX_CONTAINER_PORT="$$NGINX_CONTAINER_PORT"

docker.push:
	. ./env && docker push "$$DOCKER_IMAGE_TAG"

docker.up:
	. ./env && \
	docker run \
	    --detach \
	    --tty \
	    --interactive \
	    --publish "$$DOCKER_HOST_PORT":"$$NGINX_CONTAINER_PORT" \
	    --name "$$DOCKER_CONTAINER_NAME" \
	    "$$DOCKER_IMAGE_TAG"

docker.reup: docker.down docker.up

docker.down:
	. ./env && docker stop "$$DOCKER_CONTAINER_NAME" || true
	. ./env && docker rm "$$DOCKER_CONTAINER_NAME" || true

docker.shell:
	. ./env && docker exec -it "$$DOCKER_CONTAINER_NAME" /bin/bash

docker.attach:
	. ./env && docker attach "$$DOCKER_CONTAINER_NAME"

docker.logs:
	. ./env && docker logs "$$DOCKER_CONTAINER_NAME"

docker.go: docker.build docker.reup docker.shell

docker.kick-nginx:
	. ./env && docker exec -t "$$DOCKER_CONTAINER_NAME" \
		bash -c 'kill $$(ps aux | grep "nginx: master process" | egrep -v "grep" | awk "{print \$$2}")'

clean: clean.all

clean.all:
	rm -rf repos
	rm -rf dist

clean.one:
	rm -rf "repos/frontend-app-$$FRONTEND"
	rm -rf "dist/$$FRONTEND"

full_clean: clean.all
	rm -rf node_modules
