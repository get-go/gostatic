
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Commands
JQ ?= $(shell which jq)
DOCKER ?= $(shell which docker)
DOCKER_COMPOSE ?= $(shell which docker-compose)
DOCKER_MACHINE ?= $(shell which docker-machine)
AZURE ?= $(shell which azure)

# Docker config
DOCKER_MACHINE_NAME = make-machine
BUILD_TAG ?= getgo/gostatic
BUILD_EXAMPLE_TAG ?= getgo/gostatic-example
EXAMPLE_DIR ?= $(ROOT_DIR)/example

# Azure config
AZURE_ID_CMD ?= cat $(AZURE_PROFILE)|$(JQ) '.subscriptions[].id'
AZURE_ID ?= $(shell $(AZURE_ID_CMD))
AZURE_PROFILE ?= ~/.azure/azureProfile.json

test: run

run: build-example
	$(DOCKER) run -it $(BUILD_EXAMPLE_TAG)

build-example: build
	$(DOCKER) build -t $(BUILD_EXAMPLE_TAG) $(EXAMPLE_DIR)/.

build:
	$(DOCKER) build -t $(BUILD_TAG) $(ROOT_DIR)/.

create_machine: check_azure_id $(DOCKER_MACHINE)
	$(call check_defined, AZURE_ID)
	$(DOCKER_MACHINE) create -d azure --azure-ssh-user ops --azure-subscription-id $(AZURE_ID) $(DOCKER_MACHINE_NAME)

check_azure_id: $(AZURE_PROFILE) $(JQ)
	@echo Checking for Azure ID ...
	@echo Azure ID: $(AZURE_ID)

$(AZURE):
	@echo Azure command not found! check here for information: https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/
	$(call check_defined, AZURE)

$(DOCKER_MACHINE):
	@echo Docker machine command not found! check here for information: https://docs.docker.com/machine/install-machine/
	$(call check_defined, DOCKER_MACHINE)

$(JQ):
	@echo JQ command not found! check here for information: https://stedolan.github.io/jq/download/
	$(call check_defined, JQ)

$(AZURE_PROFILE): $(AZURE)
	@echo Azure Profile config file not found! try logging in:
	$(AZURE) login

remove_machine:
	$(DOCKER_MACHINE) rm $(DOCKER_MACHINE_NAME)

docker_clean_images:
	$(DOCKER) images -q|xargs -I '{}' $(DOCKER) rmi -f '{}'

# error method for uneset variables.
check_defined = \
		$(foreach 1,$1,$(__check_defined))
__check_defined = \
		  $(if $(value $1),, \
		  $(error Undefined $1$(if $(value 2), ($(strip $2)))))
