VENV_DIR ?= $(HOME)/venv

.PHONY: all help install venv run

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-\\.]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

all: help

.PHONY: build
build: ## Build a Docker image
	$(info Building Docker image...)
	docker build --rm --pull --tag products:1.0 . 

venv: ## Create a Python virtual environment
	$(info Creating Python 3 virtual environment...)
	@if command -v uv >/dev/null 2>&1; then \
		uv venv "$(VENV_DIR)"; \
	else \
		python3 -m venv "$(VENV_DIR)"; \
	fi

install: ## Install Python dependencies
	$(info Installing dependencies...)
	@if [ -x "$(VENV_DIR)/bin/python" ] && command -v uv >/dev/null 2>&1; then \
		uv pip install --python "$(VENV_DIR)/bin/python" -r requirements.txt; \
	elif [ -x "$(VENV_DIR)/bin/python" ]; then \
		"$(VENV_DIR)/bin/python" -m pip install -r requirements.txt; \
	else \
		python3 -m pip install -r requirements.txt; \
	fi

lint: ## Run the linter
	$(info Running linting...)
	flake8 service tests --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 service tests --count --max-complexity=10 --max-line-length=127 --statistics
	pylint service tests --max-line-length=127

.PHONY: tests
tests: ## Run the unit tests
	$(info Running tests...)
	nosetests -vv --with-coverage --cover-package=service

run: ## Run the service
	$(info Starting service...)
	honcho start

dbrm: ## Stop and remove PostgreSQL in Docker
	$(info Stopping and removing PostgreSQL...)
	-docker stop postgres
	-docker rm postgres

db: ## Run PostgreSQL in Docker
	$(info Running PostgreSQL...)
	docker run -d --name postgres \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=postgres \
		-v postgres:/var/lib/postgresql \
		postgres:15-alpine
