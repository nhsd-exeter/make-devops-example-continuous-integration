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

build-workflow-run-static-analisys:

build-workflow-run-unit-test:

build-workflow-build-artefact:
	echo make build

build-workflow-prepare-data:

build-workflow-run-integration-test:

build-workflow-run-contract-test:

build-workflow-run-fitness-function:

build-workflow-publish-artefact:
	echo make push

# ---

deployment-workflow-backup-data:

deployment-workflow-provision-infractructure:

deployment-workflow-deploy-artefact:

deployment-workflow-prepare-data:

deployment-workflow-run-smoke-test:

deployment-workflow-send-notification:

# ---

pipeline-on-success:
	echo success

pipeline-on-failure:
	echo failure

# ==============================================================================

.SILENT:
