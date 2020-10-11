PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

# ==============================================================================
# Development workflow targets

build: project-config # Build project
	make docker-build NAME=app

start: project-start # Start project

stop: project-stop # Stop project

log: project-log # Show project logs

test: # Test project
	make start
	make stop

push: # Push project artefacts to the registry
	make docker-push NAME=app

deploy: # Deploy artefacts - mandatory: PROFILE=[name]
	make project-deploy STACK=application PROFILE=$(PROFILE)

provision: # Provision environment - mandatory: PROFILE=[name]
	make terraform-apply-auto-approve STACK=database PROFILE=$(PROFILE)

clean: # Clean up project

# ==============================================================================
# Supporting targets

trust-certificate: ssl-trust-certificate-project ## Trust the SSL development certificate

create-artefact-repositories: ## Create ECR repositories to store the artefacts
	make docker-create-repository NAME=app

# ==============================================================================
# Pipeline targets

build-artefact:
	echo make build

publish-artefact:
	echo make push

backup-data:

provision-infractructure:

deploy-artefact:

apply-data-changes:

# ---

run-static-analisys:

run-unit-test:

run-smoke-test:

run-integration-test:

run-contract-test:

run-functional-test:

run-performance-test:

run-security-test:

# ---

remove-unused-environments:

remove-old-artefacts:

remove-old-backups:

# ---

pipeline-send-notification:
	echo $(@)

pipeline-on-success:
	echo $(@)

pipeline-on-failure:
	echo $(@)

# ==============================================================================

.SILENT:
