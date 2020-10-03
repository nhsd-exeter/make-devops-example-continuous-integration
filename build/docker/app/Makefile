PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))/../../..))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

# ==============================================================================

dependencies:
	cd $(APPLICATION_DIR)
	tar -czf $(DOCKER_DIR)/app/assets/application.tar.gz *

build: dependencies project-config _copy-ssl-certificate
	make docker-build NAME=app

test:
	make docker-test NAME=app GOSS_OPTS="GOSS_SLEEP=3"

run:
	make docker-image-start NAME=app \
		DIR="$(PROJECT_DIR)/application" \
		ARGS=" \
			--publish 8443:8443 \
			--attach \
			--rm \
		"

push:
	make docker-push NAME=app

clean:
	make docker-image-clean NAME=app

# ==============================================================================

_copy-ssl-certificate:
	make ssl-copy-certificate-project DIR=$(DOCKER_DIR)/app/assets/certificate
