.PHONY: all build check.all check.one clean clean.all clean.one dist.all \
        dist.one dist.one.01+ dist.one.02+ dist.one.03+ dist.one.04+ \
        dist.one.05+ dist.one.06+ dist.one.07+ docker.build docker.build.copy \
        docker.build.run docker.down docker.push docker.reup docker.shell \
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

dist.one.03+: dist.one.stage.03-inject-config dist.one.04+

dist.one.04+: dist.one.stage.04-run-webpack dist.one.05+

dist.one.05+: dist.one.stage.05-copy-to-dist dist.one.06+

dist.one.06+: |

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

docker.build: docker.build.copy docker.build.run

docker.build.copy:
	rm -rf docker_base/frontends
	mkdir -p docker_base/frontends
	cp -r dist/* docker_base/frontends/

docker.build.run:
	. ./env && \
	cd docker_base && \
	docker build . \
	    --tag "$$DOCKER_BASE_IMAGE_TAG" \
	    --build-arg NGINX_HTML_DIR="$$NGINX_HTML_DIR" \
	    --build-arg NGINX_CONTAINER_PORT="$$NGINX_CONTAINER_PORT"

docker.push:
	. ./env && docker push "$$DOCKER_BASE_IMAGE_TAG"

docker.up:
	. ./env && \
	docker run \
	    --detach \
	    --tty \
	    --interactive \
	    --publish "$$NGINX_HOST_PORT":"$$NGINX_CONTAINER_PORT" \
	    --name "$$DOCKER_CONTAINER_NAME" \
	    "$$DOCKER_BASE_IMAGE_TAG"

docker.reup: docker.down docker.up

docker.down:
	. ./env && docker stop "$$DOCKER_CONTAINER_NAME" || true
	. ./env && docker rm "$$DOCKER_CONTAINER_NAME" || true

docker.shell:
	. ./env && docker exec -it "$$DOCKER_CONTAINER_NAME" /bin/bash

clean: clean.all

clean.all:
	rm -rf repos
	rm -rf dist
	rm -rf docker_base/frontends

clean.one:
	rm -rf "repos/frontend-app-$$FRONTEND"
	rm -rf "dist/$$FRONTEND"
	rm -rf docker_base/frontends

full_clean: clean.all
	rm -rf node_modules
