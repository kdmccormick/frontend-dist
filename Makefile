.PHONY: build check clean docker.build docker.down docker.shell docker.up \
        download.all download-pack.all full_clean pack.all test

REPOS_DIR := repos
DIST_DIR := dist
DOCKER_DIR := docker
DOCKER_FRONTENDS_DIR := $(DOCKER_DIR)/frontends

IMAGE_TAG := kdmccormick96/frontends:latest
CONTAINER_NAME := edx.frontends
PORT := 19000

build: download-pack.all docker.build

test: build docker.up check

check:
	curl --fail http://localhost:$(PORT)/account/ 1>/dev/null

download-pack.all: download.all pack.all

download-pack.%: download.$* pack.$*

download.all:
	./foreach-frontend.sh ./download.sh

download.%:
	./download.sh $*

pack.all:
	./foreach-frontend.sh ./pack.sh

pack.%:
	./pack.sh $*

docker.build:
	cd $(DOCKER_DIR) && docker build . -t $(IMAGE_TAG)

docker.up:
	docker run -d -p $(PORT):80 -it --name $(CONTAINER_NAME) $(IMAGE_TAG)

docker.down:
	docker stop $(CONTAINER_NAME) ; docker rm $(CONTAINER_NAME)

docker.shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash

clean:
	rm -rf $(REPOS_DIR)
	rm -rf $(DIST_DIR)
	rm -rf $(DOCKER_FRONTENDS_DIR)

full_clean: clean
	rm -rf node_modules
