.PHONY= build build-example run-example test

ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKER ?= $(shell which docker)
DOCKER_COMPOSE ?= $(shell DOCKER_COMPOSE)
BUILD_TAG ?= getgo/gostatic
BUILD_EXAMPLE_TAG ?= getgo/gostatic-example
EXAMPLE_DIR ?= $(ROOT_DIR)/example

test: run-example

build:
	$(DOCKER) build -t $(BUILD_TAG) $(ROOT_DIR)/.

build-example: build
	$(DOCKER) build -t $(BUILD_EXAMPLE_TAG) $(EXAMPLE_DIR)/.

run-example: build-example
	$(DOCKER) run -it $(BUILD_EXAMPLE_TAG)
