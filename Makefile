# Makefile for ironmq-error-pagerduty.
#
# Author:: Mike Juarez <mike@orionlabs.io>
# Source:: https://github.com/OnBeep/ironmq-error-pagerduty
#

DOCKER_CMD ?= docker
IRON_CMD ?= iron
PROJECT_NAME ?= ironmq-error-pagerduty

# Target Groups:

install: pull_images package_install

test: ironio_test

deploy: zip_code upload

# Docker tasks

pull_images:
	$(DOCKER_CMD) pull iron/python:2
	$(DOCKER_CMD) pull iron/python:2-dev

# Python tasks

package_install:
	$(DOCKER_CMD) run --rm -v "$(PWD)":/worker -w /worker iron/python:2-dev pip install -t packages --upgrade -r code/requirements.txt

ironio_test:
	$(DOCKER_CMD) run --rm -e "PAYLOAD_FILE=test/payload.json" -e "CONFIG_FILE=test/config.json" -v "$(PWD)":/worker -w /worker iron/python:2 python code/ironmq-error-pagerduty.py

# Deploy tasks

zip_code:
	zip -r ironmq-error-pagerduty.zip .

upload:
	$(IRON_CMD) worker upload --name $(PROJECT_NAME) --zip ironmq-error-pagerduty.zip iron/python:2 python code/ironmq-error-pagerduty.py
